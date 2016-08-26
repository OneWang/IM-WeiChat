//
//  LikeModel.h
//  Chat
//
//  Created by LI on 16/8/26.
//  Copyright © 2016年 LI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LikeModel : NSObject
///用户名
@property (nonatomic, copy) NSString *userName;
///用户 ID
@property (nonatomic, copy) NSString *userId;
///属性内容
@property (nonatomic, copy) NSAttributedString *attributedContent;

@end
