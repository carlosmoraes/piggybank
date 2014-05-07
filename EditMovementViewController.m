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
    NSManagedObjectContext *moc = [self.operations managedObjectContext];
    NSManagedObjectID *movementId = [self.movement objectID];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(objectID = %@)", movementId];
    
    int type = 0;
    
    if ([self.movementType isEqualToString:@"Credit"])
    {
        type = 0;
    } else {
        type = 1;
    }
    
    NSArray *result = [[self.operations mutableArrayOfMovementsByType:type] filteredArrayUsingPredicate:predicate];
    
    if (result.count == 1)
    {
        NSManagedObject *updatedMovement = [result objectAtIndex:0];
        NSDecimalNumber *value = [NSDecimalNumber decimalNumberWithString:self.valueTextField.text];
        [updatedMovement setValue:value forKey:@"value"];
        [updatedMovement setValue:self.descriptionTextField.text forKey:@"desc"];

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
    self.operations = [[TPBOperations alloc] init];
    self.valueTextField.keyboardType=UIKeyboardTypeDecimalPad;
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    NSDecimalNumber *value;
    value = [self.movement valueForKey:@"value"];
    self.valueTextField.text = [value stringValue];
    self.descriptionTextField.text = [self.movement valueForKey:@"desc"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
