//
//  PiggyBankViewController.m
//  Piggy Bank
//
//  Created by OZZE on 15/11/13.
//  Copyright (c) 2013 The Mob Project. All rights reserved.
//

#import "PiggyBankViewController.h"

@interface PiggyBankViewController ()

@end

@implementation PiggyBankViewController

- (IBAction)reset:(id)sender // Reset all stored data
{
    NSManagedObjectContext *context = [self.operations managedObjectContext];
    NSFetchRequest *fetchRequest;
    NSArray *objects;
    NSError *error;
    
    fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Credit"];
    objects = [context executeFetchRequest:fetchRequest error:&error];
    
    for (NSManagedObject *object in objects) {
        [context deleteObject:object];
    }
    
    fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Debit"];
    objects = [context executeFetchRequest:fetchRequest error:&error];
    
    for (NSManagedObject *object in objects) {
        [context deleteObject:object];
    }
    
    [self viewDidAppear:(true)];
}

- (IBAction)populate:(id)sender
{
    NSManagedObjectContext *context = [self.operations managedObjectContext];
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/yyyy"];
    
    NSError *error;
    NSDate *fakeDate;
    double doubleValue;
    
    // Credits
    
    NSManagedObject *newCredit0 = [NSEntityDescription insertNewObjectForEntityForName:@"Credit" inManagedObjectContext:context];
    doubleValue = 1000.00;
    [newCredit0 setValue:[NSNumber numberWithDouble:doubleValue] forKey:@"amount"];
    [newCredit0 setValue:@"C0" forKey:@"desc"];
    fakeDate = [df dateFromString:@"10/10/2013"];
    [newCredit0 setValue:fakeDate forKey:@"date"];
    
    NSManagedObject *newCredit1 = [NSEntityDescription insertNewObjectForEntityForName:@"Credit" inManagedObjectContext:context];
    doubleValue = 60.00;
    [newCredit1 setValue:[NSNumber numberWithDouble:doubleValue] forKey:@"amount"];
    [newCredit1 setValue:@"C1" forKey:@"desc"];
    fakeDate = [df dateFromString:@"11/30/2013"];
    [newCredit1 setValue:fakeDate forKey:@"date"];
    
    NSManagedObject *newCredit2 = [NSEntityDescription insertNewObjectForEntityForName:@"Credit" inManagedObjectContext:context];
    doubleValue = 50.97;
    [newCredit2 setValue:[NSNumber numberWithDouble:doubleValue] forKey:@"amount"];
    [newCredit2 setValue:@"C2" forKey:@"desc"];
    fakeDate = [df dateFromString:@"12/01/2013"];
    [newCredit2 setValue:fakeDate forKey:@"date"];
    
    NSManagedObject *newCredit3 = [NSEntityDescription insertNewObjectForEntityForName:@"Credit" inManagedObjectContext:context];
    doubleValue = 99.03;
    [newCredit3 setValue:[NSNumber numberWithDouble:doubleValue] forKey:@"amount"];
    [newCredit3 setValue:@"C3" forKey:@"desc"];
    fakeDate = [df dateFromString:@"12/31/2013"];
    [newCredit3 setValue:fakeDate forKey:@"date"];
    
    // Debits
    
    NSManagedObject *newDebit0 = [NSEntityDescription insertNewObjectForEntityForName:@"Debit" inManagedObjectContext:context];
    doubleValue = 1000.00;
    [newDebit0 setValue:[NSNumber numberWithDouble:doubleValue] forKey:@"amount"];
    [newDebit0 setValue:@"D0" forKey:@"desc"];
    fakeDate = [df dateFromString:@"10/10/2013"];
    [newDebit0 setValue:fakeDate forKey:@"date"];
    
    NSManagedObject *newDebit1 = [NSEntityDescription insertNewObjectForEntityForName:@"Debit" inManagedObjectContext:context];
    doubleValue = 20.00;
    [newDebit1 setValue:[NSNumber numberWithDouble:doubleValue] forKey:@"amount"];
    [newDebit1 setValue:@"D1" forKey:@"desc"];
    fakeDate = [df dateFromString:@"11/29/2013"];
    [newDebit1 setValue:fakeDate forKey:@"date"];
    
    NSManagedObject *newDebit2 = [NSEntityDescription insertNewObjectForEntityForName:@"Debit" inManagedObjectContext:context];
    doubleValue = 00.88;
    [newDebit2 setValue:[NSNumber numberWithDouble:doubleValue] forKey:@"amount"];
    [newDebit2 setValue:@"D2" forKey:@"desc"];
    fakeDate = [df dateFromString:@"12/05/2013"];
    [newDebit2 setValue:fakeDate forKey:@"date"];
    
    NSManagedObject *newDebit3 = [NSEntityDescription insertNewObjectForEntityForName:@"Debit" inManagedObjectContext:context];
    doubleValue = 179.12;
    [newDebit3 setValue:[NSNumber numberWithDouble:doubleValue] forKey:@"amount"];
    [newDebit3 setValue:@"D3" forKey:@"desc"];
    fakeDate = [df dateFromString:@"12/31/2013"];
    [newDebit3 setValue:fakeDate forKey:@"date"];
    
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
    [self updateCurrentMonth];
    
    NSDate *now = [NSDate date];
    self.monthLabel.text = self.monthLabel.text = [self.operations stringFromDate:now toFormat:1];
    NSDecimalNumber *totalMonthCredits;
    totalMonthCredits = [self.operations sumCreditsFromDate:self.currentMonth toDate:self.nextMonth];
    self.creditLabel.text = [self.operations stringByDecimalNumber: totalMonthCredits];
    
    NSDecimalNumber *totalMonthDebits;
    totalMonthDebits = [self.operations sumDebitsFromDate:self.currentMonth toDate:self.nextMonth];
    self.debitLabel.text = [self.operations stringByDecimalNumber: totalMonthDebits];
    
    NSDecimalNumber *balance;
    balance = [self.operations calculateBalanceFromDate:self.currentMonth toDate:self.nextMonth];
    self.balanceLabel.text = [self.operations stringByDecimalNumber: balance];
    
    NSDecimalNumber *lastMonthBalance;
    lastMonthBalance = [self.operations  calculateBalanceFromDate:self.lastMonth toDate:self.currentMonth];
    self.lastMonthBalanceLabel.text = [self.operations stringByDecimalNumber: lastMonthBalance];
}

-(void)updateCurrentMonth
{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:now];
    [dateComponents setDay:1];
    self.currentMonth = [calendar dateFromComponents:dateComponents];
    
    NSDateComponents *oneMonth = [[NSDateComponents alloc] init];
    [oneMonth setMonth:1];
    self.nextMonth = [calendar dateByAddingComponents:oneMonth toDate:self.currentMonth options:0];
    
    [oneMonth setMonth:-1];
    self.lastMonth = [calendar dateByAddingComponents:oneMonth toDate:self.currentMonth options:0];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"newCredit"]) {
        NewMovementViewController *nmvc = [segue destinationViewController];
        nmvc.movementType = @"Credit";
    }
    
    if ([[segue identifier] isEqualToString:@"newDebit"]) {
        NewMovementViewController *nmvc = [segue destinationViewController];
        nmvc.movementType = @"Debit";
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.operations = [[TPBOperations alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
