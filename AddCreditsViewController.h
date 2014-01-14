//
//  CreditViewController.h
//  Piggy Bank
//
//  Created by OZZE on 15/11/13.
//  Copyright (c) 2013 The Mob Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utilities.h"

@interface AddCreditsViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *valueTextField;
@property (strong, nonatomic) IBOutlet UITextField *descriptionTextField;
@property (nonatomic,strong) Utilities *utilities;

@end
