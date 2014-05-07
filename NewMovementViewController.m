//
//  NewMovementViewController.m
//  Piggy Bank
//
//  Created by OZZE on 16/11/13.
//  Copyright (c) 2013 The Mob Project. All rights reserved.
//

#import "NewMovementViewController.h"

@interface NewMovementViewController () <UITextFieldDelegate>

@end

@implementation NewMovementViewController

- (IBAction)save:(id)sender
{
    NSManagedObjectContext *moc = [self.operations managedObjectContext];
    NSManagedObject *managedObject = [NSEntityDescription insertNewObjectForEntityForName:self.movementType inManagedObjectContext:moc];
    NSDate *date = [NSDate date];
    NSDecimalNumber *value = [NSDecimalNumber decimalNumberWithString:self.valueTextField.text];
    
    [managedObject setValue:value forKey:@"value"];
    [managedObject setValue:self.descriptionTextField.text forKey:@"desc"];
    [managedObject setValue:date forKey:@"date"];
    
    NSError *error = nil;
    if (![moc save:&error]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"App" message:@"Sorry, the operation cannot be completed" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (textField.tag == 1)
    {
        NSArray  *arrayOfString = [newString componentsSeparatedByString:@"."];
            
        if ([arrayOfString count] > 2 )
            return NO;
            
        if (([arrayOfString count] == 2) && ([arrayOfString[1] length] > 2) )
            return NO;
    }
        
        return YES;
    
    if (textField.tag == 2){
        if ([newString length] > 16)
            return NO;
    }
    
    return YES;
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
