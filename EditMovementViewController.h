//
//  EditMovementViewController.h
//  Piggy Bank
//
//  Created by OZZE on 14/01/14.
//  Copyright (c) 2014 The Mob Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utilities.h"

@interface EditMovementViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *valueTextField;
@property (strong, nonatomic) IBOutlet UITextField *descriptionTextField;
@property (strong, nonatomic) NSString *value;
@property (strong, nonatomic) NSString *description;

@end
