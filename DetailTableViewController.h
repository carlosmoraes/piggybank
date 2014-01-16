//
//  DebitHistoryUITableViewController.h
//  Piggy Bank
//
//  Created by OZZE on 16/11/13.
//  Copyright (c) 2013 The Mob Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailItemTableViewCell.h"
#import "EditMovementViewController.h"
#import "Movement.h"
#import "Utilities.h"

@interface DetailTableViewController : UITableViewController

@property (strong) NSMutableArray *movements;
@property (strong, nonatomic) Utilities *utilities;

@end
