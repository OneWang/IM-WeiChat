//
//  TimeTool.m
//  Chat
//
//  Created by LI on 16/5/5.
//  Copyright © 2016年 LI. All rights reserved.
//

#import "TimeTool.h"

@implementation TimeTool

+ (NSString *)timeStr:(long long)timestamp
{
    //返回时间格式
    NSCalendar *calender = [NSCalendar currentCalendar];
    //获取当前的时间
    NSDate *currentDate = [NSDate date];
    //获取年月日
    NSDateComponents *components = [calender components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:currentDate];
    
    //获取发送的时间
    NSDate *msgDate = [NSDate dateWithTimeIntervalSince1970:timestamp/1000.0];
    //获取年月日
    NSDateComponents *msgComponents = [calender components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:msgDate];
    
    NSDateFormatter *dateFmt = [[NSDateFormatter alloc] init];
    //判断
    if (components.year == msgComponents.year && components.month == msgComponents.month && components.day == msgComponents.day) {//同一天
        dateFmt.dateFormat = @"HH:mm";
    }else if (components.year == msgComponents.year && components.month == msgComponents.month && components.day - 1 == msgComponents.day){//昨天
        dateFmt.dateFormat = @"昨天 HH:mm";
    }else{//昨天以前
        dateFmt.dateFormat = @"yyyy-MM-dd HH:mm";
    }
    
    return [dateFmt stringFromDate:msgDate];
}

@end
