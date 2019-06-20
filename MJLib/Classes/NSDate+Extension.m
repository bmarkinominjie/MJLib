//
//  NSDate+Extension.m
//
//
//  Created by Space on 15/7/27.
//  Copyright (c) 2015年 Space. All rights reserved.
//

#import "NSDate+Extension.h"
static NSDateFormatter *fq_dateFormatter;




@implementation NSDate (Extension)

+(void)load
{
    fq_dateFormatter = [[NSDateFormatter alloc]init];
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [[[languages objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:0];
    
    fq_dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:currentLanguage];
    
}

+(NSInteger)timeSwitchTimestamp:(NSString *)formatTime andFormatter:(NSString *)format{
    
    NSDateFormatter *dateFormatter = fq_dateFormatter;
    [dateFormatter setDateFormat:format];
    NSDate *date = [dateFormatter dateFromString:formatTime];
    
    return (long)[date timeIntervalSince1970];;
}
//时间戳转换为字符串
+(NSString *)timeStrWithTimestamp:(NSString *)timestamp andformatter:(NSString *)format{
    
    NSTimeInterval time=[timestamp doubleValue]+28800;//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    NSLog(@"date:%@",[detaildate description]);
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:format];
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    
    return currentDateStr;
}

- (NSDateComponents *)deltaFrom:(NSDate *)from
{
    // 日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // 比较时间
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    return [calendar components:unit fromDate:from toDate:self options:0];
}

- (BOOL)isThisYear
{
    // 日历
    //    NSCalendar *calendar = [NSCalendar currentCalendar];
    //
    //    NSInteger nowYear = [calendar component:NSCalendarUnitYear fromDate:[NSDate date]];
    //    NSInteger selfYear = [calendar component:NSCalendarUnitYear fromDate:self];
    
    NSDate *current = [NSDate date];
    fq_dateFormatter.dateFormat = @"yyyy";
    NSString * currtYear = [fq_dateFormatter stringFromDate:current];
    NSString * selfYear = [fq_dateFormatter stringFromDate:self];
    
    return [currtYear isEqualToString:selfYear];
}

+ (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate
{
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate];
    return destinationDateNow;
}

//- (BOOL)isToday
//{
//    // 日历
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//
//    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
//
//    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
//    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
//
//    return nowCmps.year == selfCmps.year
//    && nowCmps.month == selfCmps.month
//    && nowCmps.day == selfCmps.day;
//}

- (BOOL)isCurrentDay
{
    fq_dateFormatter.dateFormat = @"yyyy-MM-dd";
    [fq_dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSString *nowString = [fq_dateFormatter stringFromDate:[NSDate getNowDateFromatAnDate:[NSDate date]]];
    NSString *selfString = [fq_dateFormatter stringFromDate:self];
    return [nowString isEqualToString:selfString];
}

- (BOOL)sj_isToday
{
    
    fq_dateFormatter.dateFormat = @"yyyy-MM-dd";
    
    NSString *nowString = [fq_dateFormatter stringFromDate:[NSDate date]];
    NSString *selfString = [fq_dateFormatter stringFromDate:self];
    
    return [nowString isEqualToString:selfString];
}


- (BOOL)isYesterday
{
    
    // 日期格式化类
    fq_dateFormatter.dateFormat = @"yyyy-MM-dd";
    
    NSDate *nowDate = [fq_dateFormatter dateFromString:[fq_dateFormatter stringFromDate:[NSDate date]]];
    NSDate *selfDate = [fq_dateFormatter dateFromString:[fq_dateFormatter stringFromDate:self]];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:selfDate toDate:nowDate options:0];
    
    return cmps.year == 0
    && cmps.month == 0
    && cmps.day == 1;
}


//本地时间转换为utc时间
+ (NSTimeInterval)getUTCFormatDate:(NSString *)localDateStr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *newsDate = [dateFormatter dateFromString:localDateStr];
    NSTimeInterval timeInterval = [newsDate timeIntervalSince1970];
    return timeInterval;
}


//getMonth 获取当月
+(NSInteger)getCurrentMonth
{
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    // 获取当前日期
    NSDate* dt = [NSDate date];
    // 定义一个时间字段的旗标，指定将会获取指定年、月、日、时、分、秒的信息
    unsigned unitFlags = NSCalendarUnitMonth | NSCalendarUnitYear;
    // 获取不同时间字段的信息
    NSDateComponents* comp = [gregorian components: unitFlags
                                          fromDate:dt];
    // 获取各时间字段的数值
    NSLog(@"现在是%ld年" , comp.year);
    NSLog(@"现在是%ld月 " , comp.month);
    
    //    if (comp.month) { //comp.month如果是1月.2月 都需要特殊处理
    //        <#statements#>
    //    }
    
    
    return comp.month;
}

//getYear 获取当年
+(NSInteger)getCurrentYear
{
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    // 获取当前日期
    NSDate* dt = [NSDate date];
    // 定义一个时间字段的旗标，指定将会获取指定年、月、日、时、分、秒的信息
    unsigned unitFlags = NSCalendarUnitMonth | NSCalendarUnitYear;
    // 获取不同时间字段的信息
    NSDateComponents* comp = [gregorian components: unitFlags
                                          fromDate:dt];
    // 获取各时间字段的数值
    NSLog(@"现在是%ld年" , comp.year);
    NSLog(@"现在是%ld月 " , comp.month);
    
    return comp.year;
}

@end
