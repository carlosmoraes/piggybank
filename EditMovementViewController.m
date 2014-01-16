//
//  EditMovementViewController.m
//  Piggy Bank
//
//  Created by OZZE on 14/01/14.
//  Copyright (c) 2014 The Mob Project. All rights reserved.
//

#import "EditMovementViewController.h"

@interface EditMovementViewController ()

@end

@implementation EditMovementViewController

- (IBAction)save:(id)sender {
    NSManagedObjectContext *moc = [self.utilities managedObjectContext];
    NSManagedObject *originalMovement = (NSManagedObject *) self.movement;
    NSManagedObjectID *originalMovementId = [originalMovement objectID];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(objectID = %@)", originalMovementId];
    NSArray *result = [[self.utilities getObjectsFromStore:0] filteredArrayUsingPredicate:predicate];
    
    if (result.count == 1)
    {
        NSManagedObject *newMovement = [result objectAtIndex:0];
        NSDecimalNumber *amount = [NSDecimalNumber decimalNumberWithString:self.valueTextField.text];
        [newMovement setValue:amount forKey:@"amount"];
        [newMovement setValue:self.descriptionTextField.text forKey:@"desc"];

        NSError *error = nil;
        
        if (![moc save:&error]) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"App" message:@"Sorry, the operation cannot be completed" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alertView show];
        }
        
    }
    
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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    self.utilities = [[Utilities alloc] init];
    NSDecimalNumber *amount;
    amount = [self.movement valueForKey:@"amount"];
    self.valueTextField.text = [amount stringValue];
    self.descriptionTextField.text = [self.movement valueForKey:@"desc"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
