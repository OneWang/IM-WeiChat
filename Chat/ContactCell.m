//
//  ContactCell.m
//  Chat
//
//  Created by LI on 16/8/24.
//  Copyright © 2016年 LI. All rights reserved.
//

#import "ContactCell.h"
#import "UIImageView+WebCache.h"
#import "ContactModel.h"
#import "Masonry.h"
#import "UILabel+Extension.h"

@interface ContactCell ()

///头像
@property (nonatomic, weak) UIImageView *iconView;

///名字
@property (nonatomic, weak) UILabel *nameLabel;

///角标
@property (weak, nonatomic) UILabel *badgeView;

@end

@implementation ContactCell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellIdentifier = nil;
    if (cellIdentifier == nil) {
        cellIdentifier = [NSString stringWithFormat:@"%@cellIdentifier", NSStringFromClass(self)];
    }
    id cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    return cell;
}

- (void)setGroup:(ContactModel *)group
{
    _group = group;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:group.icon]];
    self.nameLabel.text = group.title;
    self.badgeView.hidden = YES;
}

- (void)setBuddy:(NSString *)buddy
{
    _buddy = buddy;
    
    int randomIndex = arc4random_uniform(23);
    self.iconView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",randomIndex]];
    self.nameLabel.text = buddy;
    self.badgeView.hidden = YES;
}

- (void)setBadge:(NSInteger)badge
{
    _badge = badge;
    
    if (badge > 0) {
        self.badgeView.hidden = NO;
        
        if (badge > 99) {
            self.badgeView.text = @"N+";
        }else{
            self.badgeView.text = [NSString stringWithFormat:@"%ld", (long)_badge];
        }
    }else{
        self.badgeView.hidden = YES;
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CGFloat margin = 8;
        
        UIImageView *iconView = [[UIImageView alloc] init];
        [self.contentView addSubview:iconView];
        self.iconView = iconView;
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(35, 35));
            make.left.mas_equalTo(self.contentView).with.offset(margin);
            make.centerY.mas_equalTo(self.contentView);
        }];
        
        UILabel *nameLabel = [UILabel labelWithTitle:@"" color:[UIColor blackColor] fontSize:13 alignment:NSTextAlignmentLeft];
        [self.contentView addSubview:nameLabel];
        self.nameLabel = nameLabel;
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(iconView.mas_right).with.offset(margin);
            make.centerY.mas_equalTo(iconView);
        }];
        
        
        UILabel *badgeView = [[UILabel alloc] init];
        badgeView.translatesAutoresizingMaskIntoConstraints = NO;
        badgeView.textAlignment = NSTextAlignmentCenter;
        badgeView.textColor = [UIColor whiteColor];
        badgeView.backgroundColor = [UIColor redColor];
        badgeView.font = [UIFont systemFontOfSize:11];
        badgeView.hidden = YES;
        badgeView.layer.cornerRadius = 20 / 2;
        badgeView.clipsToBounds = YES;
        [self.contentView addSubview:badgeView];
        self.badgeView = badgeView;
        
        [badgeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(20, 20));
            make.left.mas_equalTo(iconView.mas_right).with.offset(-margin);
            make.top.mas_equalTo(iconView.mas_top).with.offset(-5);
        }];
    }
    return self;
}

@end
