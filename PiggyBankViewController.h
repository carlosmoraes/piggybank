//
//  PiggyBankViewController.h
//  Piggy Bank
//
//  Created by OZZE on 15/11/13.
//  Copyright (c) 2013 The Mob Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utilities.h"

@interface PiggyBankViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *monthLabel;
@property (strong, nonatomic) IBOutlet UILabel *balanceLabel;
@property (strong, nonatomic) IBOutlet UILabel *previousBalanceLabel;
@property (strong, nonatomic) IBOutlet UILabel *creditLabel;
@property (strong, nonatomic) IBOutlet UILabel *debitLabel;
@property (strong) NSDate *currentMonth;
@property (strong) NSDate *nextMonth;
@property (strong) NSDate *previousMonth;
@property (nonatomic,strong) Utilities *utilities;

@end
