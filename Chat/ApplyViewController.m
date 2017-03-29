//
//  ApplyViewController.m
//  Chat
//
//  Created by LI on 16/8/25.
//  Copyright © 2016年 LI. All rights reserved.
//

#import "ApplyViewController.h"

@implementation ApplyViewController
static ApplyViewController *controller = nil;
+ (instancetype)shareController
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        controller = [[self alloc] init];
    });
    return controller;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationItem.title = @"群组";
}

@end
