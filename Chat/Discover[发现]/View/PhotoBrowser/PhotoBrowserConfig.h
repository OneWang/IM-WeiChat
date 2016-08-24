//
//  SDPhotoBrowserConfig.h
//  SDPhotoBrowser
//
//  Created by aier on 15-2-9.
//  Copyright (c) 2015年 GSD. All rights reserved.
//


typedef enum {
    WaitingViewModeLoopDiagram, // 环形
    WaitingViewModePieDiagram // 饼型
} WaitingViewMode;

// 图片保存成功提示文字
#define PhotoBrowserSaveImageSuccessText @" ^_^ 保存成功 ";

// 图片保存失败提示文字
#define PhotoBrowserSaveImageFailText @" >_< 保存失败 ";

// browser背景颜色
#define PhotoBrowserBackgrounColor [UIColor colorWithRed:0 green:0 blue:0 alpha:0.95]

// browser中图片间的margin
#define PhotoBrowserImageViewMargin 10

// browser中显示图片动画时长
#define PhotoBrowserShowImageAnimationDuration 0.4f

// browser中显示图片动画时长
#define PhotoBrowserHideImageAnimationDuration 0.4f

// 图片下载进度指示进度显示样式（WaitingViewModeLoopDiagram 环形，WaitingViewModePieDiagram 饼型）
#define WaitingViewProgressMode WaitingViewModeLoopDiagram

// 图片下载进度指示器背景色
#define WaitingViewBackgroundColor [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]

// 图片下载进度指示器内部控件间的间距
#define WaitingViewItemMargin 10


