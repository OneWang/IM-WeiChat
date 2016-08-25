//
//  SettingPersonCell.h
//  tuyou
//
//  Created by LI on 16/8/22.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SettingItem;
@interface SettingCell : UITableViewCell

/** 模型数组 */
@property (strong, nonatomic)  SettingItem *item;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
