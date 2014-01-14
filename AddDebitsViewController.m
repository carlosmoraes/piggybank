//
//  DebitViewController.m
//  Piggy Bank
//
//  Created by OZZE on 16/11/13.
//  Copyright (c) 2013 The Mob Project. All rights reserved.
//

#import "AddDebitsViewController.h"

@interface AddDebitsViewController () <UITextFieldDelegate>

@end

@implementation AddDebitsViewController

- (IBAction)save:(id)sender {
    
    NSManagedObjectContext *context = [self.utilities managedObjectContext];
    NSDate *date = [NSDate date];
    
    // Create a new managed object
    NSManagedObject *newDebit = [NSEntityDescription insertNewObjectForEntityForName:@"Debit" inManagedObjectContext:context];
    
    NSDecimalNumber *amount = [NSDecimalNumber decimalNumberWithString:self.valueTextField.text];
    [newDebit setValue:amount forKey:@"amount"];
    [newDebit setValue:self.descriptionTextField.text forKey:@"desc"];
    [newDebit setValue:date forKey:@"date"];
    
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

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (textField.tag == 1){
        if (textField.tag == 1){
            NSArray  *arrayOfString = [newString componentsSeparatedByString:@"."];
            
            if ([arrayOfString count] > 2 )
                return NO;
            
            if (([arrayOfString count] == 2) && ([arrayOfString[1] length] > 2) )
                return NO;
        }
        
        if (textField.tag == 2){
            
            if ([newString length] > 16)
                return NO;
        }
        
        return YES;
    }
    
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
	self.utilities = [[Utilities alloc] init];
    self.valueTextField.keyboardType=UIKeyboardTypeDecimalPad;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
