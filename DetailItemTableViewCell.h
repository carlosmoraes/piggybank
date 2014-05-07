//
//  DetailItemTableViewCell.h
//  Piggy Bank
//
//  Created by OZZE on 24/11/13.
//  Copyright (c) 2013 The Mob Project. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailItemTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *valueLabel;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;


@end
