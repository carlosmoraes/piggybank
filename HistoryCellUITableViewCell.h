//
//  HistoryCellUITableViewCell.h
//  Piggy Bank
//
//  Created by OZZE on 24/11/13.
//  Copyright (c) 2013 The Mob Project. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryCellUITableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;

@end
