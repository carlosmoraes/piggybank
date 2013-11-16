//
//  PiggyBankViewController.m
//  Piggy Bank
//
//  Created by OZZE on 15/11/13.
//  Copyright (c) 2013 The Mob Project. All rights reserved.
//

#import "PiggyBankViewController.h"

@interface PiggyBankViewController ()

@property (strong, nonatomic) IBOutlet UILabel *budget;
@property (strong, nonatomic) IBOutlet UILabel *spendings;
@property (strong, nonatomic) IBOutlet UILabel *avaiableMoney;
@property (strong) NSMutableArray *totalBudget;
@property (strong) NSMutableArray *totalSpendings;

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
    
    fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Budget"];
    objects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    for (NSManagedObject *object in objects) {
        [self.managedObjectContext deleteObject:object];
    }
    
    fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Spendings"];
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
    NSNumber *budgetSum;
    NSNumber *spendingSum;
    NSNumber *avaiable;
    
    fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Budget"];
    self.totalBudget = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    budgetSum = [self.totalBudget valueForKeyPath:@"@sum.amount"];
    self.budget.text = [NSString stringWithFormat:@"%@", budgetSum];
    
    fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Spendings"];
    self.totalSpendings = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    spendingSum = [self.totalSpendings valueForKeyPath:@"@sum.amount"];
    self.spendings.text = [NSString stringWithFormat:@"%@", spendingSum];
    
    avaiable = [NSNumber numberWithFloat:([budgetSum floatValue] - [spendingSum floatValue])];
    self.avaiableMoney.text = [NSString stringWithFormat:@"%@", avaiable];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
