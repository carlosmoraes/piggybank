//
//  DebitHistoryUITableViewController.h
//  Piggy Bank
//
//  Created by OZZE on 16/11/13.
//  Copyright (c) 2013 The Mob Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HistoryItemTableViewCell.h"
#import "Utilities.h"

@interface DetailTableViewController : UITableViewController

@property (strong) NSMutableArray *debits;
@property (strong, nonatomic) Utilities *utilities;

@end
