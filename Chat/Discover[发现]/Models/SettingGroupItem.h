//
//  SettingGroupItem.h
//  Chat
//
//  Created by LI on 16/8/25.
//  Copyright © 2016年 LI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingGroupItem : NSObject
/**
 *  头部标题
 */
@property (nonatomic,copy) NSString * header;
/**
 *  尾部标题
 */
@property (nonatomic,copy) NSString * footer;
/**
 *  存放着这组所有行的数据模型(这个数组中都是MySettingItem对象)
 */
@property (nonatomic,strong) NSArray * items;
@end
