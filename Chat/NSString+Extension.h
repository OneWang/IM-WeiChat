//
//  NSString+Extension.h
//  Chat
//
//  Created by LI on 16/8/24.
//  Copyright © 2016年 LI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

+ (NSString *)utf8String:(NSString *)str;

+ (NSString *)transformedValue:(long long)value;

- (BOOL)isChinese;

- (BOOL)isURL;

/**
 *  返回字符串所占用的尺寸
 *
 *  @param font    字体
 *  @param maxSize 最大尺寸
 */
- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW;
- (CGSize)sizeWithFont:(UIFont *)font;

+ (NSString *)timeWithDate:(NSDate *)date;


- (NSString *)pinyin;
- (NSString *)pinyinInitial;


/**
 *  正则判断手机号码
 */
- (BOOL)isMobileNum;

@end
