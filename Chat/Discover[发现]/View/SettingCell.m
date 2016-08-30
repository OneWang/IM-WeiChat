//
//  SettingPersonCell.m
//  tuyou
//
//  Created by LI on 16/8/22.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "SettingCell.h"
#import "SettingItem.h"
#import "Masonry.h"
#import "UIView+Extension.h"

#define KScreen_Width [UIScreen mainScreen].bounds.size.width
#define KScreen_Hight [UIScreen mainScreen].bounds.size.height

@interface SettingCell ()

/** 头像 */
@property (strong, nonatomic)  UIImageView *iconView;

/** 文字 */
@property (strong, nonatomic)  UILabel *label;

/** 右侧箭头 */
@property (strong, nonatomic)  UIImageView *arrowView;

/** 右侧显示的 view */
@property (strong, nonatomic) UIView *rightView;

/// switch
@property (strong, nonatomic) UISwitch *switchView;

@end

@implementation SettingCell

#pragma mark - 
#pragma mark - 懒加载
- (UIImageView *)iconView
{
    if (!_iconView) {
        _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 25, 25)];
        _iconView.layer.cornerRadius = 5;
        _iconView.layer.borderColor = [UIColor redColor].CGColor;
        _iconView.layer.borderWidth = 2;
        _iconView.layer.masksToBounds = YES;
        _iconView.backgroundColor = [UIColor redColor];
    }
    return _iconView;
}
- (UISwitch *)switchView
{
    if (!_switchView) {
        _switchView = [[UISwitch alloc] init];
    }
    return _switchView;
}
- (UIImageView *)arrowView
{
    if (_arrowView == nil) {
        _arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CellArrow"]];
    }
    return _arrowView;
}

- (UILabel *)label
{
    if (_label == nil) {
        _label = [[UILabel alloc] init];
        _label.frame = CGRectMake(10, 2, 180, 40);
        _label.backgroundColor = [UIColor redColor];
    }
    return _label;
}

- (UIView *)rightView
{
    if (_rightView == nil) {
        _rightView = [[UIView alloc] init];
        [_rightView addSubview:self.arrowView];
        if (self.item.type == SettingTypePicture) {
            _rightView.bounds = CGRectMake(0, 0, 100, 70);
            [_rightView addSubview:self.iconView];
        }else if(self.item.type == SettingTypeLabel){
            _rightView.bounds = CGRectMake(0, 0, 200, 44);
            [_rightView addSubview:self.label];
        }else if(self.item.type == SettingTypeSwitch){
            _rightView.bounds = CGRectMake(0, 0, 100, 44);
            [_rightView addSubview:self.switchView];
        }
        [self.arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_rightView);
            make.right.equalTo(@0);
            make.width.equalTo(@8);
        }];
    }
    return _rightView;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString * ID = @"setting";
    SettingCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[SettingCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    return cell;
}

- (void)setItem:(SettingItem *)item
{
    _item = item;
    
    //设置数据
    [self setupData];
    //设置右边显示的内容
    [self setupRightContent];
}

- (void)setupData{
    if (self.item.icon) {
        self.imageView.image = [UIImage imageNamed:self.item.icon];
        self.imageView.layer.cornerRadius = 5;
        self.imageView.layer.borderColor = [UIColor redColor].CGColor;
        self.imageView.layer.borderWidth = 2;
        self.imageView.layer.masksToBounds = YES;
        self.imageView.backgroundColor = [UIColor redColor];
    }
    self.textLabel.text = self.item.title;
    self.detailTextLabel.text = self.item.subtitle;
    self.label.text = self.item.descTitle;
    self.iconView.image = self.item.image;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(16, 9, 25, 25);
    self.textLabel.x = 56;
}


- (void)setupRightContent{
    self.accessoryView = self.rightView;
    self.accessoryView.backgroundColor = [UIColor yellowColor];
}

@end
