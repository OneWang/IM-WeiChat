//
//  CommentModel.h
//  Chat
//
//  Created by LI on 16/8/26.
//  Copyright © 2016年 LI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentModel : NSObject
///评论内容
@property (nonatomic, copy) NSString *commentString;
///第一个用户名
@property (nonatomic, copy) NSString *firstUserName;
///第一个用户 ID
@property (nonatomic, copy) NSString *firstUserId;
///第二个用户名
@property (nonatomic, copy) NSString *secondUserName;
///第二个用户 ID
@property (nonatomic, copy) NSString *secondUserId;
///属性内容
@property (nonatomic, copy) NSAttributedString *attributedContent;
@end
