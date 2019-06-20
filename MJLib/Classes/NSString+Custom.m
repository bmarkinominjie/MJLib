//
//  NSString+Custom.m
//  JustFun
//
//  Created by zsbrother on 16/4/26.
//  Copyright © 2016年 zsbrother. All rights reserved.
//

#import "NSString+Custom.h"

#import "NSDate+Extension.h"

#import <CoreText/CoreText.h>

@implementation NSString (Custom)

//根据文字多少计算高度
- (CGFloat)getTextFrameHeightWithFontSize:(CGFloat)fontSize boundRectSize:(CGSize)size
{
    /*
     参数1：大小(指定的最大范围)
     参数2：类型(NSStringDrawingUsesLineFragmentOrigin)
     参数3：文字属性(包括大小、颜色等等)
     参数4：nil
     */
    CGRect rect = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil];
    
    return rect.size.height;
    
}


- (NSString *)publishTime
{
    NSString *string = self;
    
    if ([self containsString:@"T"]) {
        string = [self stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    }
    // 日期格式化类
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    // 设置日期格式(y:年,M:月,d:日,H:时,m:分,s:秒)
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    // 帖子的创建时间
    NSDate *create = [fmt dateFromString:string];
    
    return string;
}

+(NSString *)sj_DateFormatterWithDate:(NSDate *)create
{
    NSString *string = nil;
    //    // 日期格式化类
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    // 设置日期格式(y:年,M:月,d:日,H:时,m:分,s:秒)
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    create = [NSDate getNowDateFromatAnDate:create];
    NSDate *localDate = [NSDate getNowDateFromatAnDate:[NSDate date]];
    string = [fmt stringFromDate:create];
    
    return string;
}


- (NSString *)transformToChinesePhonetic
{
    NSMutableString *pinyin = [self mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
    return pinyin;
}

/**
 *将20160922195110 这种格式的转换为 2016-09-22 19:51:10格式
 */
+ (NSString *)convertToTimeFormatByString:(NSString *)str {

    if (str.length < 13) {
        return nil;
    }
    NSMutableString *dateStrM = [NSMutableString stringWithString:str];
    [dateStrM insertString:@"-" atIndex:4];
    [dateStrM insertString:@"-" atIndex:7];
    [dateStrM insertString:@" " atIndex:10];
    [dateStrM insertString:@":" atIndex:13];
    [dateStrM insertString:@":" atIndex:16];

    return dateStrM;
}

+ (NSString *)getCurrentLanguage
{
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [[[languages objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:0];
    if ([currentLanguage isEqualToString:@"zh"]) {
        return  @"cn";
    }
    return currentLanguage;
}

+ (BOOL)isLanguageChina
{
    return [[NSString getCurrentLanguage] isEqualToString:@"cn"];
}

+ (NSString *)getCountryCode
{
    NSLocale *currentLocale = [NSLocale currentLocale];
    NSString *countryCode = [currentLocale objectForKey:NSLocaleCountryCode];
    return countryCode.uppercaseString;
}

+ (BOOL)isCountryCodeWithChina
{
    return [[NSString getCountryCode] isEqualToString:@"CN"];
}

+ (NSString *)getTranslationStr:(NSString *)str
{

    return str;
}

+(NSString *)translatGetLanguage
{
    if ([[NSString getCurrentLanguage] isEqualToString:@"cn"]) {
        return @"zh";
    }else if([[NSString getCurrentLanguage] isEqualToString:@"fr"])
    {
        return @"fra";
    }else if([[NSString getCurrentLanguage] isEqualToString:@"es"])
    {
        return @"spa";
    }
    return [NSString getCurrentLanguage];
}


/**
 获取加密以后的字符串

 @param passwordsalt 随机字符串通过base64处理的字符串
 @param passwordStr 明文密码
 @return 返回合并以后的sha1和base64处理的字符串
 */
+(NSString *)getEncryptedStringWithSalt:(NSString *)passwordsalt password:(NSString *)passwordStr
{

    return passwordStr;
}


/**
 * 根据国家地域的缩写返回全称
 */
+(NSString *)getCurrentCountryNameWithShortName:(NSString*)shortName
{
    /**
     zh-Hans-US  中文
     en-US 英文
     */
    //    NSLog(@"shortName==%@",shortName);
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    //    NSLog(@"currentLanguage==%@",currentLanguage);
    NSString * path  = [[NSBundle mainBundle]pathForResource:@"CountryAndArea.plist" ofType:nil];
    NSArray * array = [NSArray arrayWithContentsOfFile:path];
    
    if ([currentLanguage containsString:@"zh-Hans"]) {
        
        for (NSDictionary * dict in array) {
            NSString * shortN = [dict[@"国际域名缩写"] lowercaseString];
            if ([shortN isEqualToString:shortName]) {
                NSString * countyName = dict[@"国家或地区"];
                return countyName;
            }
        }
    }else {
        for (NSDictionary * dict in array) {
            NSString * shortN = [dict[@"国际域名缩写"] lowercaseString];
            if ([shortN isEqualToString:shortName]) {
                NSString * countyName = dict[@"Countries and Regions"];
                return countyName;
            }
        }
    }
    return @"";
}


+(NSString *)setCurrentImageWithImageStr:(NSString *)imgStr
{
    return imgStr;
}


+(NSString *)getRandomString{
    NSString *string = [[NSString alloc]init];
    for (int i = 0; i < 16; i++) {
        int number = arc4random() % 36;
        if (number < 10) {
            int figure = arc4random() % 10;
            NSString *tempString = [NSString stringWithFormat:@"%d", figure];
            string = [string stringByAppendingString:tempString];
        }else {
            int figure = (arc4random() % 26) + 97;
            char character = figure;
            NSString *tempString = [NSString stringWithFormat:@"%c", character];
            string = [string stringByAppendingString:tempString];
        }
    }
    return string;
}

/**
 昵称.详情文本的转码策略
 */
-(NSString *)contentStrRemovingPercentEncoding
{
    //兼容安卓策略
//  return  [[self stringByReplacingOccurrencesOfString:@"+" withString:@"%20"] stringByRemovingPercentEncoding];
    
    //后台完善转码以后的策略
  return  [self  stringByRemovingPercentEncoding];  
}

-(NSString *)contentStrByAddingPercentEncoding
{
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[[NSCharacterSet characterSetWithCharactersInString:@"`+#&?%^{}\"[]|\\<> "] invertedSet]];
}

+ (NSString *)filterHTMLTag:(NSString *)str {
    //替换字符
    str  =  [str  stringByReplacingOccurrencesOfString:@"&mdash;" withString:@"-"];
    str  =  [str  stringByReplacingOccurrencesOfString:@"&ldquo;" withString:@"\""];
    str  =  [str  stringByReplacingOccurrencesOfString:@"&rdquo;" withString:@"\""];
    str  =  [str  stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    str  =  [str  stringByReplacingOccurrencesOfString:@"&rsquo;" withString:@"’"];
    str  =  [str  stringByReplacingOccurrencesOfString:@"&lsquo;" withString:@"‘"];
    str  =  [str  stringByReplacingOccurrencesOfString:@"&middot;" withString:@"·"];
    str  =  [str  stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    str  =  [str  stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    str  =  [str  stringByReplacingOccurrencesOfString:@"<strong>" withString:@""];
    str  =  [str  stringByReplacingOccurrencesOfString:@"</strong>" withString:@""];
    str  =  [str  stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    return str;
    
}


@end
