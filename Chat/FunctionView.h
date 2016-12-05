//
//  FunctionView.h
//  Chat
//
//  Created by LI on 16/8/1.
//  Copyright © 2016年 LI. All rights reserved.
//  添加更多功能的 view

#import <UIKit/UIKit.h>

@class FunctionModel;

#define TAG_Photo 1
#define TAG_Camera 2
#define TAG_Sight 3
#define TAG_VideoCall 4
#define TAG_Redpackage 5
#define TAG_MoneyTransfer 6
#define TAG_Location 6
#define TAG_Favorites 7
#define TAG_Card 8
#define TAG_Wallet 9

@protocol ChatShareDelegate <NSObject>
- (void)cellWithTagDidTapped:(NSInteger)tag;
@end

/**
 *定义显示的 cell
 */
@interface ShareCell : UICollectionViewCell


@end


@interface FunctionView : UIView

@property (nonatomic, weak) id<ChatShareDelegate> delegate;

@end
