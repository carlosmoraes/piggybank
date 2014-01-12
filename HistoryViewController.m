//
//  History.m
//  Piggy Bank
//
//  Created by OZZE on 11/01/14.
//  Copyright (c) 2014 The Mob Project. All rights reserved.
//

#import "HistoryViewController.h"
#import "CreditHistoryUITableViewController.h"
#import "DebitHistoryUITableViewController.h"

@interface HistoryViewController ()

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

- (IBAction)nextMonth:(id)sender
{
    [self changeMonth:1];
    [self viewDidAppear:(true)];
}

- (IBAction)previousMonth:(id)sender
{
    [self changeMonth:-1];
    [self viewDidAppear:(true)];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self changeMonth:0];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM, YYYY"];
    self.monthLabel.text = [dateFormatter stringFromDate:self.currentMonth];
    
    NSDecimalNumber *monthCredits;
    monthCredits = [self sumCredits:self.currentMonth byPeriod:self.nextMonth];
    self.creditLabel.text = [NSString stringWithFormat:@"%1@", monthCredits];
    
    NSDecimalNumber *monthDebits;
    monthDebits = [self sumDebits:self.currentMonth byPeriod:self.nextMonth];
    self.debitLabel.text = [NSString stringWithFormat:@"%1@", monthDebits];
    
    NSDecimalNumber *balance;
    balance = [self calculateBalance:self.currentMonth byPeriod:self.nextMonth];
    self.balanceLabel.text = [NSString stringWithFormat:@"%1@", balance];
}

- (NSDecimalNumber *)sumCredits:(NSDate *)initDate byPeriod:(NSDate *) finalDate
{
    NSDecimalNumber *sum;
    NSPredicate *predicate;
    
    predicate = [NSPredicate predicateWithFormat:@"date >= %@ AND date < %@", initDate, finalDate];
    self.credits = [[self getObjectsFromStore:0] filteredArrayUsingPredicate:predicate];
    sum = [self.credits valueForKeyPath:@"@sum.amount"];
    
    return sum;
}

-(void) changeMonth:(NSInteger)byAmount // Change month
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:self.currentMonth];
    [dateComponents setDay:1];
    NSDate *oldDate = [calendar dateFromComponents:dateComponents];
    NSDateComponents *oneMonth = [[NSDateComponents alloc] init];
    [oneMonth setMonth:byAmount];
    NSDate *newDate = [calendar dateByAddingComponents:oneMonth toDate:oldDate options:0];
    self.currentMonth = newDate;
    
    // Set the beggining of following month for Predicate
    [oneMonth setMonth:1];
    NSDate *beginningOfFollowingMonth = [calendar dateByAddingComponents:oneMonth toDate:newDate options:0];
    self.nextMonth = beginningOfFollowingMonth;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([[segue identifier] isEqualToString:@"creditHistory"]) {
        CreditHistoryUITableViewController *creditHistoryUITableViewController = [segue destinationViewController];
        creditHistoryUITableViewController.credits = self.credits;
    }
    
    if ([[segue identifier] isEqualToString:@"debitHistory"]) {
        DebitHistoryUITableViewController *debitHistoryUITableViewController = [segue destinationViewController];
        debitHistoryUITableViewController.debits = self.debits;
    }
}

- (NSDecimalNumber *)sumDebits:(NSDate *)initDate byPeriod:(NSDate *) finalDate
{
    NSDecimalNumber *sum;
    NSPredicate *predicate;
    
    predicate = [NSPredicate predicateWithFormat:@"date >= %@ AND date < %@", initDate, finalDate];
    self.debits = [[self getObjectsFromStore:1] filteredArrayUsingPredicate:predicate];
    sum = [self.debits valueForKeyPath:@"@sum.amount"];
    
    return sum;
}

- (NSDecimalNumber *)calculateBalance:(NSDate *)initDate byPeriod:(NSDate *) finalDate
{
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

- (NSMutableArray *)getObjectsFromStore:(int)store
{
    NSMutableArray *objects;
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest;
    NSString *entity;
    
    switch (store)
    {
        case 0:
            entity = @"Credit";
            break;
        case 1:
            entity = @"Debit";
            break;
        default:
            NSLog (@"Invalid entity");
            break;
            
            fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entity];
            objects = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    }
    
    return objects;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.currentMonth = [NSDate date];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
