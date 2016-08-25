//
//  ContactModel.h
//  Chat
//
//  Created by LI on 16/8/24.
//  Copyright © 2016年 LI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactModel : NSObject


///组头部标题
@property (nonatomic, copy) NSString *headerTitle;

///组尾部说明
@property (nonatomic, copy) NSString *footerTitle;

///标题
@property (nonatomic, copy) NSString *title;

///头像
@property (nonatomic, copy) NSString *icon;

@end
