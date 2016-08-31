//
//  BaseRefreshView.h
//  Chat
//
//  Created by LI on 16/8/31.
//  Copyright © 2016年 LI. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString *const BaseRefreshViewObserveKeyPath;

typedef enum {
    RefreshViewStateNormal,
    RefreshViewStateWillRefresh,
    RefreshViewStateRefreshing,
} RefreshViewState;

@interface BaseRefreshView : UIView

@property (nonatomic, strong) UIScrollView *scrollView;

- (void)endRefreshing;

@property (nonatomic, assign) UIEdgeInsets scrollViewOriginalInsets;
@property (nonatomic, assign) RefreshViewState refreshState;

@end
