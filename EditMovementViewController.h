//
//  EditMovementViewController.h
//  Piggy Bank
//
//  Created by OZZE on 14/01/14.
//  Copyright (c) 2014 The Mob Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPBOperations.h"

@interface EditMovementViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *valueTextField;
@property (strong, nonatomic) IBOutlet UITextField *descriptionTextField;
@property (strong, nonatomic) NSManagedObject *movement;
@property (strong, nonatomic) TPBOperations *operations;


@end
