//
//  SDPhotoBrowser.h
//  photobrowser
//
//  Created by aier on 15-2-3.
//  Copyright (c) 2015年 aier. All rights reserved.
//

#import <UIKit/UIKit.h>


@class PhotoBrowser;

@protocol PhotoBrowserDelegate <NSObject>

@required

- (UIImage *)photoBrowser:(PhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index;

@optional

- (NSURL *)photoBrowser:(PhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index;

@end


@interface PhotoBrowser : UIView <UIScrollViewDelegate>

@property (nonatomic, weak) UIView *sourceImagesContainerView;
@property (nonatomic, assign) NSInteger currentImageIndex;
@property (nonatomic, assign) NSInteger imageCount;

@property (nonatomic, weak) id<PhotoBrowserDelegate> delegate;

- (void)show;

@end
