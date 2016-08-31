//
//  BaseRefreshView.m
//  Chat
//
//  Created by LI on 16/8/31.
//  Copyright © 2016年 LI. All rights reserved.
//

#import "BaseRefreshView.h" 

NSString *const BaseRefreshViewObserveKeyPath = @"contentOffset";

@implementation BaseRefreshView

- (void)setScrollView:(UIScrollView *)scrollView
{
    _scrollView = scrollView;
    
    [scrollView addObserver:self forKeyPath:BaseRefreshViewObserveKeyPath options:NSKeyValueObservingOptionNew context:nil];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (!newSuperview) {
        [self.scrollView removeObserver:self forKeyPath:BaseRefreshViewObserveKeyPath];
    }
}

- (void)endRefreshing
{
    self.refreshState = RefreshViewStateNormal;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    // 子类实现
}

@end
