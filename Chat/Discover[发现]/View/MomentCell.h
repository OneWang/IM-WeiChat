//
//  MomentCell.h
//  Chat
//
//  Created by LI on 16/8/26.
//  Copyright © 2016年 LI. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MomentModelDelegate <NSObject>

- (void)didClickLikeButtonInCell:(UITableViewCell *)cell;
- (void)didClickcCommentButtonInCell:(UITableViewCell *)cell;

@end


@class MomentModel;
@interface MomentCell : UITableViewCell

@property (nonatomic, weak) id<MomentModelDelegate> delegate;

@property (nonatomic, strong) NSIndexPath *indexPath;
///全文按钮
@property (nonatomic, copy) void (^moreButtonClickedBlock)(NSIndexPath *indexPath);
///评论按钮
@property (nonatomic, copy) void (^didClickCommentLabelBlock)(NSString *commentId, CGRect rectInWindow, NSIndexPath *indexPath);

/// 头像被点击
@property (copy, nonatomic) void(^clickIconBtnBlock)(NSIndexPath *indexPath);

/// 模型
@property (strong, nonatomic)  MomentModel *moment;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
