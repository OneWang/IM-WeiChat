//
//  ChatCell.h
//  Chat
//
//  Created by LI on 16/5/4.
//  Copyright © 2016年 LI. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *ReceiveCell = @"ReceiveCell";
static NSString *SendCell = @"SendCell";

@interface ChatCell : UITableViewCell
/** 消息的label */
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

/** 消息模型 ,内部的set方法显示文字*/
@property (strong, nonatomic) EMMessage *message;

- (CGFloat)cellHeight;

@end
