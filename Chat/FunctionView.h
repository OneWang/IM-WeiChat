//
//  FunctionView.h
//  Chat
//
//  Created by LI on 16/8/1.
//  Copyright © 2016年 LI. All rights reserved.
//  添加更多功能的 view

#import <UIKit/UIKit.h>

@interface FunctionView : UIView
- (instancetype)initWithImageBlock:(void(^)(void))imageBlock callBtnBlock:(void(^)(void))callBlock videoBlock:(void(^)(void))videoBlock;
@end
