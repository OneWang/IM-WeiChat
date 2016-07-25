//
//  AddFriendViewController.m
//  Chat
//
//  Created by LI on 16/5/3.
//  Copyright © 2016年 LI. All rights reserved.
//

#import "AddFriendViewController.h"
#import "EaseMob.h"
#import "MBProgressHUD+MJ.h"

@interface AddFriendViewController ()<EMChatManagerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation AddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];

#warning 代理放在Conversation控制器比较好
    //添加(聊天管理器)代理
//    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:dispatch_get_main_queue()];
}

- (IBAction)addFriendsAction:(id)sender {
    
    //添加好友
    
    //1.获取要添加好友的名字
     NSString *username = self.textField.text;
    
    //2.向服务器发送一个添加好友的请求
    //message:请求添加好友的额外信息
    NSString *loginUsername = [[EaseMob sharedInstance].chatManager loginInfo][@"username"];
    NSString *message = [@"我是" stringByAppendingString:loginUsername];
    
    EMError *error = nil;
    [[EaseMob sharedInstance].chatManager addBuddy:username message:message error:&error];
    if (error) {
        NSLog(@"添加好友出错:%@",error);
    }else{
        [MBProgressHUD showSuccess:@"成功添加好友"];
    }
}



//-(void)dealloc
//{
//    [[EaseMob sharedInstance].chatManager removeDelegate:self];
//}

@end
