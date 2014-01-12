//
//  History.h
//  Piggy Bank
//
//  Created by OZZE on 11/01/14.
//  Copyright (c) 2014 The Mob Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utilities.h"
#import "CreditHistoryUITableViewController.h"
#import "DebitHistoryUITableViewController.h"

@interface HistoryViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *monthLabel;
@property (strong, nonatomic) IBOutlet UILabel *balanceLabel;
@property (strong, nonatomic) IBOutlet UILabel *creditLabel;
@property (strong, nonatomic) IBOutlet UILabel *debitLabel;
@property (strong) NSDate *currentMonth;
@property (strong) NSDate *nextMonth;
@property (strong) NSArray *credits;
@property (strong) NSArray *debits;
@property (nonatomic,strong) Utilities *utilities;

@end
