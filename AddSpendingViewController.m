//
//  AddSpendingViewController.m
//  Piggy Bank
//
//  Created by OZZE on 16/11/13.
//  Copyright (c) 2013 The Mob Project. All rights reserved.
//

#import "AddSpendingViewController.h"

@interface AddSpendingViewController ()

@property (strong, nonatomic) IBOutlet UITextField *valueTextField;
@property (strong, nonatomic) IBOutlet UITextField *descriptionTextField;

@end

@implementation AddSpendingViewController

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}
- (IBAction)save:(id)sender {
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    // Create a new managed object
    NSManagedObject *addBudget = [NSEntityDescription insertNewObjectForEntityForName:@"Spendings" inManagedObjectContext:context];
    
    double amountDouble = [self.valueTextField.text doubleValue];
    [addBudget setValue:[NSNumber numberWithDouble:amountDouble] forKey:@"amount"];
    [addBudget setValue:self.descriptionTextField.text forKey:@"desc"];
    
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Erro ao salvar! %@ %@", error, [error localizedDescription]);
    }
    
    // else {
    //   NSLog(@"Salvou!");
    // }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
