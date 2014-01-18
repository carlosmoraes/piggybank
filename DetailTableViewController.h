//
//  DetailTableViewController.h
//  Piggy Bank
//
//  Created by OZZE on 16/11/13.
//  Copyright (c) 2013 The Mob Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailItemTableViewCell.h"
#import "EditMovementViewController.h"
#import "TPBOperations.h"

@interface DetailTableViewController : UITableViewController

@property (strong) NSDate *currentMonth;
@property (strong) NSDate *nextMonth;
@property (strong) NSMutableArray *movements;
@property (strong) NSString *movementType;
@property (strong, nonatomic) TPBOperations *operations;

@end
