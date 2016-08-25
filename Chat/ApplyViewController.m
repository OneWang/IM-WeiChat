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
        controller = [[self alloc] initWithStyle:UITableViewStylePlain];
    });
    return controller;
}

@end
