//
//  CommentView.h
//  Chat
//
//  Created by LI on 16/8/26.
//  Copyright © 2016年 LI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentView : UIView

- (void)setupWithLikeItemsArray:(NSArray *)likeItemsArray commentItemsArray:(NSArray *)commentItemsArray;

@property (nonatomic, copy) void (^didClickCommentLabelBlock)(NSString *commentId, CGRect rectInWindow);
@end
