//
//  LoginViewController.m
//  Chat
//
//  Created by LI on 16/5/3.
//  Copyright © 2016年 LI. All rights reserved.
//

#import "LoginViewController.h"
#import "EaseMob.h"

#import "MBProgressHUD+MJ.h"


@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UITextField *passWordField;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)registerAction:(id)sender {
    
    NSString * username = self.userNameField.text;
    NSString * password = self.passWordField.text;
    
    if (username.length == 0 || password.length == 0) {
        [MBProgressHUD showError:@"账号或密码不能为空"];
        return;
    }
    
    //注册
    [[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:username password:password withCompletion:^(NSString *username, NSString *password, EMError *error) {
        
        if (!error) {
            [MBProgressHUD showSuccess:@"注册成功"];
        }else{
            [MBProgressHUD showError:@"注册失败"];
            NSLog(@"注册失败:%@",error);
        }
        
    } onQueue:dispatch_get_main_queue()];

}

- (IBAction)loginAction:(id)sender {
    
    //让环信的SDK在第一次登录之后,自动从服务器获取好友列表,添加到本地数据库中(Buddy表)
    [[EaseMob sharedInstance].chatManager setIsAutoFetchBuddyList:YES];
    
    NSString * username = self.userNameField.text;
    NSString * password = self.passWordField.text;
    
    if (username.length == 0 || password.length == 0) {
        [MBProgressHUD showError:@"账号或密码不能为空"];
        return;
    }
    
    //登录
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:username password:password completion:^(NSDictionary *loginInfo, EMError *error) {
        //登录请求之后的block的回调
        if (!error) {
            
            /* 
             LastLoginTime = 1462246275413;
             jid = "437512311#chat-wang_wang@easemob.com";
             password = 123456;
             resource = mobile;
             token = "YWMtOqAglhDfEeaq3zM2X-U7XgAAAVWpp1G2iB3Bmbp4pSTCxFiBv2EgsfS4xUc";
             username = wang;
             */
            
            [MBProgressHUD showSuccess:@"登录成功"];
            NSLog(@"用户信息:%@",loginInfo);
            
            //设置自动登录
            [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
            
            //来主界面
            self.view.window.rootViewController = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
            
            
        }else{
            [MBProgressHUD showError:@"登录失败"];
            NSLog(@"登录错误信息:%@",error);
            //User do not exist
            /** 每一个应用都有自己的注册用户 */
            
        }
    } onQueue:dispatch_get_main_queue()];
}

@end
