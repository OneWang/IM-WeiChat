//
//  ContactCell.h
//  Chat
//
//  Created by LI on 16/8/24.
//  Copyright © 2016年 LI. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ContactModel;
@interface ContactCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
///
@property (nonatomic, copy) NSString *buddy;

/// 组头
@property (strong, nonatomic)  ContactModel *group;

@property (nonatomic,assign) NSInteger badge;
@end
