//
//  History.m
//  Piggy Bank
//
//  Created by OZZE on 11/01/14.
//  Copyright (c) 2014 The Mob Project. All rights reserved.
//

#import "HistoryViewController.h"

@interface HistoryViewController ()
@property (strong, nonatomic) IBOutlet UILabel *monthLabel;
@property (strong, nonatomic) IBOutlet UILabel *balanceLabel;
@property (strong, nonatomic) IBOutlet UILabel *creditLabel;
@property (strong, nonatomic) IBOutlet UILabel *debitLabel;
@property (strong) NSDate *selectedMonth;
@property (strong) NSDate *nextMonth;
@property (strong) NSMutableArray *credits;
@property (strong) NSMutableArray *debits;
@property (strong) NSArray *creditsByMonth;
@property (strong) NSArray *debitsByMonth;
@end

@implementation HistoryViewController

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)nextMonth:(id)sender {
    [self changeMonth:1];
    [self viewDidAppear:(true)];
}

- (IBAction)previousMonth:(id)sender {
    [self changeMonth:-1];
    [self viewDidAppear:(true)];
}

-(void) changeMonth:(NSInteger)byAmount {
    
    // Update month
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:self.selectedMonth];
    [dateComponents setDay:1];
    NSDate *oldDate = [calendar dateFromComponents:dateComponents];
    NSDateComponents *oneMonth = [[NSDateComponents alloc] init];
    [oneMonth setMonth:byAmount];
    NSDate *newDate = [calendar dateByAddingComponents:oneMonth toDate:oldDate options:0];
    self.selectedMonth = newDate;
    
    // Set the beggining of following month for Predicate
    [oneMonth setMonth:1];
    NSDate *beginningOfFollowingMonth = [calendar dateByAddingComponents:oneMonth toDate:newDate options:0];
    self.nextMonth = beginningOfFollowingMonth;

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self changeMonth:0];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM, YYYY"];
    self.monthLabel.text = [dateFormatter stringFromDate:self.selectedMonth];
    
    NSDecimalNumber *monthCredits;
    monthCredits = [self sumCredits:self.selectedMonth byPeriod:self.nextMonth];
    self.creditLabel.text = [NSString stringWithFormat:@"%1@", monthCredits];
    
    NSDecimalNumber *monthDebits;
    monthDebits = [self sumDebits:self.selectedMonth byPeriod:self.nextMonth];
    self.debitLabel.text = [NSString stringWithFormat:@"%1@", monthDebits];
    
    NSDecimalNumber *balance;
    balance = [self calculateBalance:self.selectedMonth byPeriod:self.nextMonth];
    self.balanceLabel.text = [NSString stringWithFormat:@"%1@", balance];

}

- (NSDecimalNumber *)sumCredits:(NSDate *)initDate byPeriod:(NSDate *) finalDate{
    NSDecimalNumber *sum;
    NSPredicate *predicate;
    NSArray *objects;
    
    predicate = [NSPredicate predicateWithFormat:@"date >= %@ AND date < %@", initDate, finalDate];
    objects = [[self getObjectsFromStore:0] filteredArrayUsingPredicate:predicate];
    sum = [objects valueForKeyPath:@"@sum.amount"];
    
    return sum;
}

- (NSDecimalNumber *)sumDebits:(NSDate *)initDate byPeriod:(NSDate *) finalDate{
    NSDecimalNumber *sum;
    NSPredicate *predicate;
    NSArray *objects;
    
    predicate = [NSPredicate predicateWithFormat:@"date >= %@ AND date < %@", initDate, finalDate];
    objects = [[self getObjectsFromStore:1] filteredArrayUsingPredicate:predicate];
    sum = [objects valueForKeyPath:@"@sum.amount"];
    
    return sum;
}

- (NSDecimalNumber *)calculateBalance:(NSDate *)initDate byPeriod:(NSDate *) finalDate{
    NSDecimalNumber *balance;
    NSPredicate *predicate;
    NSDecimalNumber *totalCredits;
    NSDecimalNumber *totalDebits;
    NSArray *credits;
    NSArray *debits;
    
    predicate = [NSPredicate predicateWithFormat:@"date >= %@ AND date < %@", initDate, finalDate];
    credits = [[self getObjectsFromStore:0] filteredArrayUsingPredicate:predicate];
    debits = [[self getObjectsFromStore:1] filteredArrayUsingPredicate:predicate];
    totalCredits = [credits valueForKeyPath:@"@sum.amount"];
    totalDebits = [debits valueForKeyPath:@"@sum.amount"];
    balance = [totalCredits decimalNumberBySubtracting:totalDebits];
    
    return balance;
}

- (NSMutableArray *)getObjectsFromStore:(int)store{
    NSMutableArray *objects;
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest;
    
    switch (store)
    {
        case 0:
            // NSLog (@"Credit");
            fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Credit"];
            objects = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
            break;
        case 1:
            // NSLog (@"Debit");
            fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Debit"];
            objects = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
            break;
        default:
            // NSLog (@"Invalid store");
            break;
    }
    
    return objects;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.selectedMonth = [NSDate date];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
