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
    NSLog(@"Apareceu");
    self.valueTextField.text = self.value;
    self.descriptionTextField.text = self.description;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
