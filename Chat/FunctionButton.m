//
//  FunctionButton.m
//  Chat
//
//  Created by LI on 16/8/1.
//  Copyright © 2016年 LI. All rights reserved.
//

#import "FunctionButton.h"

@implementation FunctionButton

+ (instancetype)shareButton
{
    return [FunctionButton buttonWithType:UIButtonTypeCustom];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)click:(FunctionButton *)btn
{
    if (self.block) {
        self.block(btn);
    }
}


- (void)setHighlighted:(BOOL)highlighted
{}

@end
