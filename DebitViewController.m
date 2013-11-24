//
//  DebitViewController.m
//  Piggy Bank
//
//  Created by OZZE on 16/11/13.
//  Copyright (c) 2013 The Mob Project. All rights reserved.
//

#import "DebitViewController.h"

@interface DebitViewController () <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *valueTextField;
@property (strong, nonatomic) IBOutlet UITextField *descriptionTextField;

@end

@implementation DebitViewController

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
    NSDate *date = [NSDate date];
    
    // Create a new managed object
    NSManagedObject *newDebit = [NSEntityDescription insertNewObjectForEntityForName:@"Debit" inManagedObjectContext:context];
    
    double doubleValue = [self.valueTextField.text doubleValue];
    [newDebit setValue:[NSNumber numberWithDouble:doubleValue] forKey:@"amount"];
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
        NSArray  *arrayOfString = [newString componentsSeparatedByString:@"."];
        
        // Validates if number doesn't have more than 2 digits after the "."
        if ([arrayOfString count] > 2 )
            return NO;
        
        if (([arrayOfString count] == 2) && ([arrayOfString[1] length] > 2) )
            return NO;
        
        // Validates if the number isn't bigger than 999999999.99
        double newStringToDouble = [newString doubleValue];
        
        if(newStringToDouble > 999999999.99)
            return NO;
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
	// Do any additional setup after loading the view.
    
    self.valueTextField.keyboardType=UIKeyboardTypeDecimalPad;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
