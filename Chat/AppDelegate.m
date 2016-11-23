//
//  AppDelegate.m
//  Chat
//
//  Created by LI on 16/5/3.
//  Copyright © 2016年 LI. All rights reserved.
//

#import "AppDelegate.h"

#import "EaseMob.h"

#import "MBProgressHUD+MJ.h"

@interface AppDelegate ()<EMChatManagerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    NSLog(@"%@",NSHomeDirectory());
    
    // Override point for customization after application launch.
    //registerSDKWithAppKey:注册的appKey，开发者注册及管理后台。
    //apnsCertName:推送证书名(不需要加后缀)，制作与上传推送证书。
//    [[EaseMob sharedInstance] registerSDKWithAppKey:@"437512311#chat-wang" apnsCertName:nil];
    
    //1.初始化SDK,并隐藏环信SDK的日志输出
    [[EaseMob sharedInstance] registerSDKWithAppKey:@"437512311#chat-wang" apnsCertName:nil otherConfig:@{kSDKConfigEnableConsoleLogger : @(NO)}];
    [[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];

    //2.监听自动登录的状态
    //设置chatManager代理
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    //3.如果登录过,直接来到主界面
    if ([[EaseMob sharedInstance].chatManager isAutoLoginEnabled]) {
        self.window.rootViewController = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
    }
    
    return YES;
}

#pragma mark 自动登录的回调
- (void)didAutoLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error
{
    if (!error) {
        [MBProgressHUD showSuccess:@"自动登录成功"];
//        [loginInfo writeToFile:[NSString stringWithFormat:@"%@",NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject] atomically:YES];
        NSLog(@"自动登录成功 %@",loginInfo);
    }else{
        [MBProgressHUD showError:@"自动登录失败"];
        NSLog(@"自动登录失败 %@",error);
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}
//app进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[EaseMob sharedInstance] applicationDidEnterBackground:application];
}

//app将要从后台返回
- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[EaseMob sharedInstance] applicationWillEnterForeground:application];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)dealloc
{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

@end
