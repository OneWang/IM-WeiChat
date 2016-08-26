//
//  LiveMenu.h
//  Chat
//
//  Created by LI on 16/8/26.
//  Copyright © 2016年 LI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LiveMenu : UIView
///是否显示
@property (nonatomic, assign, getter = isShowing) BOOL show;
///点击点赞按钮
@property (nonatomic, copy) void (^likeButtonClickedOperation)();
///点击评论按钮
@property (nonatomic, copy) void (^commentButtonClickedOperation)();
@end
