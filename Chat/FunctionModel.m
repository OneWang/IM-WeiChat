//
//  FunctionModel.m
//  Chat
//
//  Created by LI on 2016/12/1.
//  Copyright © 2016年 LI. All rights reserved.
//

#import "FunctionModel.h"

@implementation FunctionModel
+ (instancetype)cellWithImageName:(NSString *)imageName text:(NSString *)text tag:(NSInteger)tag
{
    FunctionModel *model = [[FunctionModel alloc] init];
    model.imageName = imageName;
    model.text = text;
    model.tag = tag;
    return model;
}
@end
