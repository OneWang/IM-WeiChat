//
//  AudioPlayTool.h
//  Chat
//
//  Created by LI on 16/5/4.
//  Copyright © 2016年 LI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioPlayTool : NSObject

+ (void)playWithMessage:(EMMessage *)message messageLabel:(UILabel *)messageLabel receiver:(BOOL)receiver;

+ (void)stop;

@end
