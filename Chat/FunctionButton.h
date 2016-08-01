//
//  FunctionButton.h
//  Chat
//
//  Created by LI on 16/8/1.
//  Copyright © 2016年 LI. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^FunctionButtonBlock)(id);

@interface FunctionButton : UIButton

/** 按钮点击之后所做的事情 */
@property (copy, nonatomic) FunctionButtonBlock block;

+ (instancetype)shareButton;

@end

