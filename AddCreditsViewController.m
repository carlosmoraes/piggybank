//
//  CreditViewController.m
//  Piggy Bank
//
//  Created by OZZE on 15/11/13.
//  Copyright (c) 2013 The Mob Project. All rights reserved.
//

#import "AddCreditsViewController.h"

@interface AddCreditsViewController () <UITextFieldDelegate>

@end

@implementation AddCreditsViewController

- (IBAction)save:(id)sender
{
    NSManagedObjectContext *context = [self.utilities managedObjectContext];
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
    self.utilities = [[Utilities alloc] init];
    self.valueTextField.keyboardType=UIKeyboardTypeDecimalPad;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
//    if (textField.tag == 1){
//        NSString *cleanCentString = [[textField.text componentsSeparatedByCharactersInSet: [[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
//        // NSInteger centValue= cleanCentString.integerValue;
//        
//        NSDecimalNumber *base = [NSDecimalNumber decimalNumberWithString:@"10"];
//        NSDecimalNumber *decimalValue = [NSDecimalNumber decimalNumberWithString:cleanCentString];
//        NSDecimalNumber *result;
//        
//        if (string.length > 0)
//        {
//            // centValue = centValue * 10 + string.integerValue;
//            result = [decimalValue decimalNumberByMultiplyingBy:base];
//        }
//        else
//        {
//            // centValue = centValue / 10;
//            result = [decimalValue decimalNumberByDividingBy:base];
//        }
//        
//        NSNumberFormatter *_currencyFormatter = [[NSNumberFormatter alloc] init];
//        [_currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
//        textField.text = [_currencyFormatter stringFromNumber:result];
//        return NO;
    
    }
    
    if (textField.tag == 2){
//        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        if ([newString length] > 16)
            return NO;
    }
    
    return YES;
}

@end
