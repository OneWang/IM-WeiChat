//
//  ConversationCell.h
//  Chat
//
//  Created by LI on 16/8/25.
//  Copyright © 2016年 LI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConversationCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;
///会话模型
@property (nonatomic, strong) EMConversation *conversaion;

@end
