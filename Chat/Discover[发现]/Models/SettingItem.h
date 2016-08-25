//
//  SettingItem.h
//  tuyou
//
//  Created by LI on 16/8/22.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SettingType) {
    SettingTypePicture,
    SettingTypeLabel,
    SettingTypeSwitch,
    SettingTypeArrow
};

typedef void(^SettingItemOption)(void);

@interface SettingItem : NSObject

/**
 *  图标
 */
@property (nonatomic,copy) NSString * icon;
/**
 *  标题
 */
@property (nonatomic,copy) NSString * title;
/**
 *  子标题
 */
@property (nonatomic,copy) NSString * subtitle;

/**
 *  描述
 */
@property (nonatomic,copy) NSString *descTitle;

/** image */
@property (strong, nonatomic) UIImage *image;

/**
 *  存储数据用的 key
 */
@property (nonatomic,copy) NSString * key;

/** 类型 */
@property (assign, nonatomic) SettingType type;

/**
 *  点击对应的 cell 应该做的事情
 */
@property (nonatomic,copy) SettingItemOption option;


/**
 *  点击这行 cell 需要跳转的控制器
 */
@property (nonatomic,assign) Class destVcClass ;

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title destVcClass:(Class)destVcClass;


+ (instancetype)itemWithTitle:(NSString *)title destVcClass:(Class)destVcClass;

@end
