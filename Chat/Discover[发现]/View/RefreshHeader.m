//
//  RefreshHeader.m
//  Chat
//
//  Created by LI on 16/8/31.
//  Copyright © 2016年 LI. All rights reserved.
//

#import "RefreshHeader.h"

static const CGFloat criticalY = -60.f;

#define RefreshHeaderRotateAnimationKey @"RotateAnimationKey"

@implementation RefreshHeader

{
    CABasicAnimation *_rotateAnimation;
}

+ (instancetype)refreshHeaderWithCenter:(CGPoint)center
{
    RefreshHeader *header = [RefreshHeader new];
    header.center = center;
    return header;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

- (void)setupView
{
    self.backgroundColor = [UIColor clearColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AlbumReflashIcon"]];
    self.bounds = imageView.bounds;
    [self addSubview:imageView];
    
    _rotateAnimation = [[CABasicAnimation alloc] init];
    _rotateAnimation.keyPath = @"transform.rotation.z";
    _rotateAnimation.fromValue = @0;
    _rotateAnimation.toValue = @(M_PI * 2);
    _rotateAnimation.duration = 1.0;
    _rotateAnimation.repeatCount = MAXFLOAT;
}

- (void)setRefreshState:(RefreshViewState)refreshState
{
    [super setRefreshState:refreshState];
    
    if (refreshState == RefreshViewStateRefreshing) {
        if (self.refreshingBlock) {
            self.refreshingBlock();
        }
        [self.layer addAnimation:_rotateAnimation forKey:RefreshHeaderRotateAnimationKey];
    } else if (refreshState == RefreshViewStateNormal) {
        [self.layer removeAnimationForKey:RefreshHeaderRotateAnimationKey];
        [UIView animateWithDuration:0.3 animations:^{
            self.transform = CGAffineTransformIdentity;
        }];
    }
}


- (void)updateRefreshHeaderWithOffsetY:(CGFloat)y
{
    
    CGFloat rotateValue = y / 50.0 * M_PI;
    
    if (y < criticalY) {
        y = criticalY;
        
        if (self.scrollView.isDragging && self.refreshState != RefreshViewStateWillRefresh) {
            self.refreshState = RefreshViewStateWillRefresh;
        } else if (!self.scrollView.isDragging && self.refreshState == RefreshViewStateWillRefresh) {
            self.refreshState = RefreshViewStateRefreshing;
        }
    }
    
    if (self.refreshState == RefreshViewStateRefreshing) return;
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformTranslate(transform, 0, -y);
    transform = CGAffineTransformRotate(transform, rotateValue);
    
    self.transform = transform;
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (keyPath != BaseRefreshViewObserveKeyPath) return;
    
    [self updateRefreshHeaderWithOffsetY:self.scrollView.contentOffset.y];
}

@end
