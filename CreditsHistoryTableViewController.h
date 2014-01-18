//
//  CreditHistoryUITableViewController.h
//  Piggy Bank
//
//  Created by OZZE on 16/11/13.
//  Copyright (c) 2013 The Mob Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPBOperations.h"

@interface CreditsHistoryTableViewController : UITableViewController

@property (strong) NSMutableArray *credits;
@property (nonatomic,strong) TPBOperations *operations;

@end
