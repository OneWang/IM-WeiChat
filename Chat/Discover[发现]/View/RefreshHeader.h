//
//  RefreshHeader.h
//  Chat
//
//  Created by LI on 16/8/31.
//  Copyright © 2016年 LI. All rights reserved.
//

#import "BaseRefreshView.h"

@interface RefreshHeader : BaseRefreshView

+ (instancetype)refreshHeaderWithCenter:(CGPoint)center;

@property (nonatomic, copy) void(^refreshingBlock)();

@end
