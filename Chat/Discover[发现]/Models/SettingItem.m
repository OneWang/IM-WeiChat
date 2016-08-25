//
//  SettingItem.m
//  tuyou
//
//  Created by LI on 16/8/22.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "SettingItem.h"

@implementation SettingItem

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title
{
    SettingItem * item = [[self alloc] init];
    item.icon = icon;
    item.title = title;
    return item;
}


+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title destVcClass:(Class)destVcClass
{
    SettingItem * item = [self itemWithIcon:icon title:title];
    item.destVcClass = destVcClass;
    return item;
}

+ (instancetype)itemWithTitle:(NSString *)title destVcClass:(Class)destVcClass
{
    return [self itemWithIcon:nil title:title destVcClass:destVcClass];
}

@end
