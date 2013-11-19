//
//  PiggyBankViewController.m
//  Piggy Bank
//
//  Created by OZZE on 15/11/13.
//  Copyright (c) 2013 The Mob Project. All rights reserved.
//

#import "PiggyBankViewController.h"

@interface PiggyBankViewController ()

@property (strong, nonatomic) IBOutlet UILabel *balanceLabel;
@property (strong, nonatomic) IBOutlet UILabel *creditLabel;
@property (strong, nonatomic) IBOutlet UILabel *debitLabel;
@property (strong) NSMutableArray *credits;
@property (strong) NSMutableArray *debits;

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
    
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest;
    NSDecimalNumber *totalCredits;
    NSDecimalNumber *totalDebits;
    NSDecimalNumber *balance;
    
    fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Credit"];
    self.credits = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    totalCredits = [self.credits valueForKeyPath:@"@sum.amount"];
    self.creditLabel.text = [NSString stringWithFormat:@"%1@", totalCredits];
    
    fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Debit"];
    self.debits = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    totalDebits = [self.debits valueForKeyPath:@"@sum.amount"];
    self.debitLabel.text = [NSString stringWithFormat:@"%1@", totalDebits];
    
    balance = [totalCredits decimalNumberBySubtracting:totalDebits];
    self.balanceLabel.text = [NSString stringWithFormat:@"%1@", balance];
    
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
