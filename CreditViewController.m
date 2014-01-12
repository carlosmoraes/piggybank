//
//  CreditViewController.m
//  Piggy Bank
//
//  Created by OZZE on 15/11/13.
//  Copyright (c) 2013 The Mob Project. All rights reserved.
//

#import "CreditViewController.h"

@interface CreditViewController () <UITextFieldDelegate>

@end

@implementation CreditViewController

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (IBAction)save:(id)sender
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSDate *date = [NSDate date];
    NSManagedObject *newCredit = [NSEntityDescription insertNewObjectForEntityForName:@"Credit" inManagedObjectContext:context];
    NSDecimalNumber *amount = [NSDecimalNumber decimalNumberWithString:self.valueTextField.text];
    [newCredit setValue:amount forKey:@"amount"];
    [newCredit setValue:self.descriptionTextField.text forKey:@"desc"];
    [newCredit setValue:date forKey:@"date"];
    
    NSError *error = nil;
    
    if (![context save:&error]) {
        NSLog(@"Erro ao salvar! %@ %@", error, [error localizedDescription]);
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
    
    self.valueTextField.keyboardType=UIKeyboardTypeDecimalPad;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == 1){
        NSString *cleanCentString = [[textField.text componentsSeparatedByCharactersInSet: [[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
        NSInteger centValue= cleanCentString.integerValue;
        
        if (string.length > 0)
        {
            centValue = centValue * 10 + string.integerValue;
        }
        else
        {
            centValue = centValue / 10;
        }
        
        NSNumber *formatedValue;
        formatedValue = [[NSNumber alloc] initWithFloat:(float)centValue / 100.0f];
        NSNumberFormatter *_currencyFormatter = [[NSNumberFormatter alloc] init];
        [_currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        textField.text = [_currencyFormatter stringFromNumber:formatedValue];
        return NO;
    }
    
    if (textField.tag == 2){
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if ([newString length] > 16)
            return NO;
    }
    
    return YES;
}

@end
