//
//  ChatViewController.h
//  Chat
//
//  Created by LI on 16/5/3.
//  Copyright © 2016年 LI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatViewController : UIViewController

/** 好友 */
@property (strong, nonatomic) EMBuddy *buddy;

/// 好友名字
@property (copy, nonatomic) NSString *friendName;

@end
