//
//  TableHeaderView.m
//  Chat
//
//  Created by LI on 16/8/31.
//  Copyright © 2016年 LI. All rights reserved.
//

#import "TableHeaderView.h"

#import "UIView+SDAutoLayout.h"

@implementation TableHeaderView

{
    UIImageView *_backgroundImageView;
    UIImageView *_iconView;
    UILabel *_nameLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    _backgroundImageView = [UIImageView new];
    _backgroundImageView.image = [UIImage imageNamed:@"test1.jpg"];
    [self addSubview:_backgroundImageView];
    
    _iconView = [UIImageView new];
    _iconView.image = [UIImage imageNamed:@"test0.jpg"];
    _iconView.layer.borderColor = [UIColor whiteColor].CGColor;
    _iconView.layer.borderWidth = 3;
    [self addSubview:_iconView];
    
    _nameLabel = [UILabel new];
    _nameLabel.text = @"OneWang_iOS";
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.textAlignment = NSTextAlignmentRight;
    _nameLabel.font = [UIFont boldSystemFontOfSize:15];
    [self addSubview:_nameLabel];
    
    _backgroundImageView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(-60, 0, 40, 0));
    
    _iconView.sd_layout
    .widthIs(70)
    .heightIs(70)
    .rightSpaceToView(self, 15)
    .bottomSpaceToView(self, 20);
    
    
    _nameLabel.tag = 1000;
    [_nameLabel setSingleLineAutoResizeWithMaxWidth:200];
    _nameLabel.sd_layout
    .rightSpaceToView(_iconView, 20)
    .bottomSpaceToView(_iconView, -35)
    .heightIs(20);
}


@end
