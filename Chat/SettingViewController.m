//
//  SettingViewController.m
//  Chat
//
//  Created by LI on 16/5/3.
//  Copyright © 2016年 LI. All rights reserved.
//

#import "SettingViewController.h"
#import "EaseMob.h"

@interface SettingViewController ()
- (IBAction)logoutAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *loginUsername = [[EaseMob sharedInstance].chatManager loginInfo][@"username"];
    NSString * title = [NSString stringWithFormat:@"Logout(%@)",loginUsername];
    //设置退出按钮的文字
    [self.logoutBtn setTitle:title forState:UIControlStateNormal];
}


- (IBAction)logoutAction:(id)sender {
    //isUnbind 是否推送
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
        if (error) {
            NSLog(@"退出失败 %@",error);
        }else{
            NSLog(@"退出成功");
            //回到登录界面
            self.view.window.rootViewController = [UIStoryboard storyboardWithName:@"Login" bundle:nil].instantiateInitialViewController;
        }
    } onQueue:nil];
}
@end
