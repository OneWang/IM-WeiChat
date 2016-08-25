//
//  ContacterTools.h
//  Chat
//
//  Created by LI on 16/8/24.
//  Copyright © 2016年 LI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContacterTools : NSObject
/**
 *  格式化好友列表
 */
+ (NSMutableArray *) getFriendListDataBy:(NSMutableArray *)array;
+ (NSMutableArray *) getFriendListSectionBy:(NSMutableArray *)array;

+ (NSMutableArray *)getFriensListItemsGroup;
@end
