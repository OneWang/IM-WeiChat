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

@property (nonatomic, copy) void (^moreButtonClickedBlock)(NSIndexPath *indexPath);

@property (nonatomic, copy) void (^didClickCommentLabelBlock)(NSString *commentId, CGRect rectInWindow, NSIndexPath *indexPath);

/// 模型
@property (strong, nonatomic)  MomentModel *moment;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
