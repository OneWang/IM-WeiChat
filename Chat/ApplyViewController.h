//
//  ApplyViewController.h
//  Chat
//
//  Created by LI on 16/8/25.
//  Copyright © 2016年 LI. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ApplyStyle){
    ApplyStyleFriend,
    ApplyStyleGroupInvitation,
    ApplyStyleJoinGroup,
};

@interface ApplyViewController : UIViewController
+ (instancetype)shareController;
@end
