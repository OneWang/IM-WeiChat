//
//  FunctionModel.h
//  Chat
//
//  Created by LI on 2016/12/1.
//  Copyright © 2016年 LI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FunctionModel : NSObject
///图片名字
@property (nonatomic,copy) NSString *imageName;
///显示的文字
@property (nonatomic,copy) NSString *text;
///对应的 tag 值
@property (nonatomic,assign) NSInteger tag;

+ (instancetype)cellWithImageName:(NSString *)imageName text:(NSString *)text tag:(NSInteger)tag;

@end
