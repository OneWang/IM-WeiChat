//
//  ConversationCell.m
//  Chat
//
//  Created by LI on 16/8/25.
//  Copyright © 2016年 LI. All rights reserved.
//

#import "ConversationCell.h"
#import "BadgeView.h"
#import "Masonry.h"
#import "UIView+Extension.h"
#import "NSDate+Extension.h"

@interface ConversationCell ()

/// 头像
@property (weak, nonatomic)  UIImageView *iconView;
/// 昵称
@property (weak, nonatomic)  UILabel *nickLabel;
/// 消息
@property (weak, nonatomic)  UILabel *messageLabel;
/// 时间
@property (weak, nonatomic)  UILabel *timeLabel;
/// 角标
@property (weak, nonatomic)  BadgeView *badgeView;
/// 分割线
@property (weak, nonatomic)  UIView *divide;

@end

@implementation ConversationCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellID = @"conversation";
    ConversationCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[ConversationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.layer.cornerRadius = 50 * 0.5;
        imageView.clipsToBounds = YES;
        self.iconView = imageView;
        
        BadgeView *badge = [[BadgeView alloc] init];
        self.badgeView = badge;
        
        UILabel *nick = [[UILabel alloc] init];
        nick.font = [UIFont systemFontOfSize:16];
        nick.textColor = [UIColor blackColor];
        self.nickLabel = nick;
        
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.font = [UIFont systemFontOfSize:12];
        timeLabel.textColor = [UIColor lightGrayColor];
        timeLabel.textAlignment = NSTextAlignmentRight;
        self.timeLabel = timeLabel;
        
        UILabel *message = [[UILabel alloc] init];
        message.font = [UIFont systemFontOfSize:14];
        message.textColor = [UIColor lightGrayColor];
        self.messageLabel = message;
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor grayColor];
        view.alpha = 0.3;
        self.divide = view;
        
        [self.contentView addSubview:self.iconView];
        [self.contentView addSubview:self.badgeView];
        [self.contentView addSubview:self.nickLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.messageLabel];
        [self.contentView addSubview:self.divide];
        
        CGFloat margin = 10;
        
        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self.contentView).offset(margin);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(- 1.5 * margin);
            make.top.equalTo(self.iconView);
        }];
        
        [self.nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.timeLabel.mas_left).offset(-margin * 0.5);
            make.left.equalTo(self.iconView.mas_right).offset(margin);
            make.top.equalTo(self.contentView.mas_top).offset(margin);
        }];
        
        [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nickLabel);
            make.top.equalTo(self.nickLabel.mas_bottom).offset(0.5 * margin);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-1.5 * margin);
            make.right.equalTo(self.contentView.mas_right).offset(-margin);
        }];
        
        [self.divide mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-1.5);
            make.height.equalTo(@1);
            make.left.right.equalTo(self.contentView);
        }];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setConversaion:(EMConversation *)conversaion
{
    _conversaion = conversaion;
    
    int randomIndex = arc4random_uniform(23);
    self.iconView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",randomIndex]];
    
    self.badgeView.badgeValue = [NSString stringWithFormat:@"%ld",[conversaion unreadMessagesCount]];
    
    self.nickLabel.text = conversaion.chatter;
    
    if (conversaion.latestMessage) {
        self.timeLabel.hidden = NO;
        self.timeLabel.text = [NSDate dateFromLongLong:conversaion.latestMessage.timestamp].dateDescription;
    }else {
        self.timeLabel.hidden = YES;
    }

    // 获取消息体
    id body = conversaion.latestMessage.messageBodies[0];
    
    if ([body isKindOfClass:[EMTextMessageBody class]]) {
        EMTextMessageBody *textBody = body;
        self.messageLabel.text = textBody.text;
    }else if ([body isKindOfClass:[EMVoiceMessageBody class]]){
        self.messageLabel.text = @"[语音]";
    }else if([body isKindOfClass:[EMImageMessageBody class]]){
        self.messageLabel.text = @"[图片]";
    }else{
        self.messageLabel.text = @"";
    }
    self.messageLabel.textColor = [UIColor grayColor];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.badgeView.x = 45;
    self.badgeView.y = 5;
}

@end
