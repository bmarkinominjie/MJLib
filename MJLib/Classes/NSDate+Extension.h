//
//  NSDate+Extension.h
//
//
//  Created by Space on 15/7/27.
//  Copyright (c) 2015年 Space. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)

//将一个字符串转化为时间戳
+(NSInteger)timeSwitchTimestamp:(NSString *)formatTime andFormatter:(NSString *)format;

//时间戳转换为字符串
+(NSString *)timeStrWithTimestamp:(NSString *)timestamp andformatter:(NSString *)format;

/**
 * 比较from和self的时间差值
 */
- (NSDateComponents *)deltaFrom:(NSDate *)from;

+ (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate;

//本地时间转换为utc时间
+ (NSTimeInterval)getUTCFormatDate:(NSString *)localDateStr;

/**
 * 是否为今年
 */
- (BOOL)isThisYear;

- (BOOL)isCurrentDay;

/**
 * 是否为今天
 */
- (BOOL)sj_isToday;

/**
 * 是否为昨天
 */
- (BOOL)isYesterday;

//getMonth 获取当月
+(NSInteger)getCurrentMonth;

//getYear 获取当年
+(NSInteger)getCurrentYear;

@end

