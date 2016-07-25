//
//  TimeCell.h
//  Chat
//
//  Created by LI on 16/5/5.
//  Copyright © 2016年 LI. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *timeCell = @"TimeCell";
@interface TimeCell : UITableViewCell

/** 显示时间的label */
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
