//
//  FunctionView.m
//  Chat
//
//  Created by LI on 16/8/1.
//  Copyright © 2016年 LI. All rights reserved.
//  添加更多功能的 view

#define kWeChatScreenHeight [UIScreen mainScreen].bounds.size.height
#define kWeChatScreenWidth [UIScreen mainScreen].bounds.size.width

#define FunctionViewBtnWidth (kWeChatScreenWidth - 4 * kWeChatPadding) / 3

#define FunctionViewBtnHeight (self.height - 3 * kWeChatPadding) / 2

#define kWeChatPadding 10

#import "FunctionView.h"
#import "FunctionButton.h"
#import "UIViewExt.h"

@interface FunctionView ()

{
    FunctionButton *_imageBtn;
    FunctionButton *_callBtn;
    FunctionButton *_videoBtn;
}

@end

@implementation FunctionView

- (instancetype)initWithImageBlock:(void(^)(void))imageBlock callBtnBlock:(void(^)(void))callBlock videoBlock:(void(^)(void))videoBlock
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor grayColor];
        _imageBtn = [FunctionButton shareButton];
        [_imageBtn setBackgroundColor:[UIColor redColor]];
        [_imageBtn setTitle:@"图片" forState:UIControlStateNormal];
        [self addSubview:_imageBtn];
        
        _callBtn = [FunctionButton shareButton];
        [_callBtn setBackgroundColor:[UIColor blueColor]];
        [_callBtn setTitle:@"语音" forState:UIControlStateNormal];
        [self addSubview:_callBtn];
        
        _videoBtn = [FunctionButton shareButton];
        [_videoBtn setBackgroundColor:[UIColor greenColor]];
        [_videoBtn setTitle:@"视频" forState:UIControlStateNormal];
        [self addSubview:_videoBtn];
        
        // 事件处理
        _imageBtn.block = ^(FunctionButton *btn){
            if (imageBlock) {
                imageBlock();
            }
        };
        
        _callBtn.block = ^(FunctionButton *btn){
            if (callBlock) {
                callBlock();
            }
        };
        
        _videoBtn.block = ^(FunctionButton *btn){
            if (videoBlock) {
                videoBlock();
            }
        };
        
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _imageBtn.frame = CGRectMake(kWeChatPadding, kWeChatPadding, FunctionViewBtnWidth, FunctionViewBtnHeight);
    _callBtn.frame = CGRectMake(_imageBtn.right + kWeChatPadding, kWeChatPadding, FunctionViewBtnWidth, FunctionViewBtnHeight);
    _videoBtn.frame = CGRectMake(_callBtn.right + kWeChatPadding, kWeChatPadding, FunctionViewBtnWidth, FunctionViewBtnHeight);
}


@end
