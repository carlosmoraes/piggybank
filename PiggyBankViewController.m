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
    NSManagedObjectContext *context = [self.utilities managedObjectContext];
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
    NSManagedObjectContext *context = [self.utilities managedObjectContext];
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
    
    Utilities *util = self.utilities;
    NSDate *now = [NSDate date];
    self.monthLabel.text = self.monthLabel.text = [util dateToFortmat:now :1];
    NSDecimalNumber *monthCredits;
    monthCredits = [util sumCredits:self.currentMonth byPeriod:self.nextMonth];
    self.creditLabel.text = [util decimalNumberAsString: monthCredits];
    
    NSDecimalNumber *monthDebits;
    monthDebits = [util sumDebits:self.currentMonth byPeriod:self.nextMonth];
    self.debitLabel.text = [util decimalNumberAsString: monthDebits];
    
    NSDecimalNumber *balance;
    balance = [util calculateBalance:self.currentMonth byPeriod:self.nextMonth];
    self.balanceLabel.text = [util decimalNumberAsString: balance];
    
    NSDecimalNumber *previousBalance;
    previousBalance = [util  calculateBalance:self.previousMonth byPeriod:self.currentMonth];
    self.previousBalanceLabel.text = [util decimalNumberAsString: previousBalance];
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
    self.previousMonth = [calendar dateByAddingComponents:oneMonth toDate:self.currentMonth options:0];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"newCredit"]) {
        Movement *movement = [segue destinationViewController];
        movement.movementType = @"Credit";
    }
    
    if ([[segue identifier] isEqualToString:@"newDebit"]) {
        Movement *movement = [segue destinationViewController];
        movement.movementType = @"Debit";
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.utilities = [[Utilities alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
