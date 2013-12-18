//
//  PiggyBankViewController.m
//  Piggy Bank
//
//  Created by OZZE on 15/11/13.
//  Copyright (c) 2013 The Mob Project. All rights reserved.
//

#import "PiggyBankViewController.h"

@interface PiggyBankViewController ()
@property (strong, nonatomic) IBOutlet UILabel *monthLabel;
@property (strong, nonatomic) IBOutlet UILabel *balanceLabel;
@property (strong, nonatomic) IBOutlet UILabel *previousBalanceLabel;
@property (strong, nonatomic) IBOutlet UILabel *creditLabel;
@property (strong, nonatomic) IBOutlet UILabel *debitLabel;
@property (strong) NSMutableArray *credits;
@property (strong) NSMutableArray *debits;
@property (strong) NSArray *creditsByMonth;
@property (strong) NSArray *debitsByMonth;
@end

@implementation PiggyBankViewController

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

// Reset all data in store
- (IBAction)reset:(id)sender {

    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest;
    NSArray *objects;
    NSError *error;
    
    fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Credit"];
    objects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    for (NSManagedObject *object in objects) {
        [self.managedObjectContext deleteObject:object];
    }
    
    fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Debit"];
    objects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    for (NSManagedObject *object in objects) {
        [self.managedObjectContext deleteObject:object];
    }
    
    [self viewDidAppear:(true)];
    
}

- (IBAction)Populate:(id)sender {
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *newCredit = [NSEntityDescription insertNewObjectForEntityForName:@"Credit" inManagedObjectContext:context];
    // NSManagedObject *newDebit = [NSEntityDescription insertNewObjectForEntityForName:@"Debit" inManagedObjectContext:context];
    
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/yyyy"];
    
    NSError *error;
    NSDate *fakeDate;
    double doubleValue;
    
    doubleValue = 100.00;
    [newCredit setValue:[NSNumber numberWithDouble:doubleValue] forKey:@"amount"];
    [newCredit setValue:@"P1" forKey:@"desc"];
    fakeDate = [df dateFromString:@"11/30/2013"];
    [newCredit setValue:fakeDate forKey:@"date"];
    
    error = nil;
    if (![context save:&error]) {
        NSLog(@"Erro ao salvar! %@ %@", error, [error localizedDescription]);
    }

    [self viewDidAppear:(true)];
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // Showing current month
    [dateFormatter setDateFormat:@"MMMM"];
    self.monthLabel.text = [dateFormatter stringFromDate:now];
    
    // Setting the beginning of current month
    NSDateComponents *nowComponents = [calendar components:NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:now];
    [nowComponents setDay:1];
    NSDate *beginningOfCurrentMonth = [calendar dateFromComponents:nowComponents];
    
    // Setting the beginning of next month
    NSDateComponents *oneMonth = [[NSDateComponents alloc] init];
    [oneMonth setMonth:1];
    NSDate *beginningOfNextMonth = [calendar dateByAddingComponents:oneMonth toDate:beginningOfCurrentMonth options:0];
    
    // Setting the beginning of last month;
    [oneMonth setMonth:-1];
    NSDate *beginningOfLastMonth = [calendar dateByAddingComponents:oneMonth toDate:beginningOfCurrentMonth options:0];
    
    // NSLog(@"%@", beginningOfCurrentMonth);
    // NSLog(@"%@", beginningOfNextMonth);
    // NSLog(@"%@", beginningOfLastMonth);
    
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSPredicate *predicate;
    NSFetchRequest *fetchRequest;
    NSDecimalNumber *totalCredits;
    NSDecimalNumber *totalDebits;
    NSDecimalNumber *monthCredits;
    NSDecimalNumber *monthDebits;
    NSDecimalNumber *balance;
    NSDecimalNumber *previousBalance;
    
    predicate = [NSPredicate predicateWithFormat:@"date >= %@ AND date < %@", beginningOfCurrentMonth, beginningOfNextMonth];
    
    fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Credit"];
    self.credits = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    totalCredits = [self.credits valueForKeyPath:@"@sum.amount"];
    self.creditsByMonth = [self.credits filteredArrayUsingPredicate:predicate];
    monthCredits = [self.creditsByMonth  valueForKeyPath:@"@sum.amount"];
    self.creditLabel.text = [NSString stringWithFormat:@"%1@", monthCredits];
    // self.creditLabel.text = [NSString stringWithFormat:@"%1@", totalCredits];
    
    fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Debit"];
    self.debits = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    totalDebits = [self.debits valueForKeyPath:@"@sum.amount"];
    self.debitsByMonth = [self.debits filteredArrayUsingPredicate:predicate];
    monthDebits = [self.debitsByMonth  valueForKeyPath:@"@sum.amount"];
    self.debitLabel.text = [NSString stringWithFormat:@"%1@", monthDebits];
    // self.debitLabel.text = [NSString stringWithFormat:@"%1@", totalDebits];
    
    balance = [totalCredits decimalNumberBySubtracting:totalDebits];
    self.balanceLabel.text = [NSString stringWithFormat:@"%1@", balance];
    
    predicate = [NSPredicate predicateWithFormat:@"date >= %@ AND date < %@", beginningOfLastMonth, beginningOfCurrentMonth];
    self.creditsByMonth = [self.credits filteredArrayUsingPredicate:predicate];
    monthCredits = [self.creditsByMonth  valueForKeyPath:@"@sum.amount"];
    self.debitsByMonth = [self.debits filteredArrayUsingPredicate:predicate];
    monthDebits = [self.debitsByMonth  valueForKeyPath:@"@sum.amount"];
    previousBalance = [monthCredits decimalNumberBySubtracting:monthDebits];
    self.previousBalanceLabel.text = [NSString stringWithFormat:@"%1@", previousBalance];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
