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
