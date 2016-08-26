//
//  MomentModel.h
//  Chat
//
//  Created by LI on 16/8/26.
//  Copyright © 2016年 LI. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LikeModel,CommentModel;

@interface MomentModel : NSObject
///头像
@property (nonatomic, copy) NSString *iconName;
///名字
@property (nonatomic, copy) NSString *name;
///内容详情
@property (nonatomic, copy) NSString *msgContent;
///照片数组
@property (nonatomic, strong) NSArray *picNamesArray;
///是否点赞
@property (nonatomic, assign, getter = isLiked) BOOL liked;
///是否打开
@property (nonatomic, assign) BOOL isOpening;
///是否打开更多按钮
@property (nonatomic, assign, readonly) BOOL shouldShowMoreButton;
///点赞模型数组
@property (nonatomic, strong) NSArray<LikeModel *> *likeArray;
///评论模型数组
@property (nonatomic, strong) NSArray<CommentModel *> *commentArray;
@end
