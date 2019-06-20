//
//  NSString+Custom.h
//  JustFun
//
//  Created by zsbrother on 16/4/26.
//  Copyright © 2016年 zsbrother. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (Custom)

- (CGFloat)getTextFrameHeightWithFontSize:(CGFloat)fontSize boundRectSize:(CGSize)size;

- (NSString *)publishTime;

+ (NSString *)sj_DateFormatterWithDate:(NSDate *)create;

- (NSString *)transformToChinesePhonetic;

+ (NSString *)convertToTimeFormatByString:(NSString *)str;

/**
 获取当前语言环境
 */
+ (NSString *)getCurrentLanguage;

+ (BOOL)isLanguageChina;

+ (NSString *)getCountryCode;

+ (BOOL)isCountryCodeWithChina;

//获取需要的待翻译文本
+ (NSString *)getTranslationStr:(NSString *)str;

/**
 * 根据国家地域的缩写返回全称
 */
+(NSString *)getCurrentCountryNameWithShortName:(NSString*)shortName;

//根据不同地区.返回图片缩略图缓存key值
+(NSString *)setCurrentImageWithImageStr:(NSString *)imgStr;


/**
 后台编码-->转换为字符串的转码策略
 */
-(NSString *)contentStrRemovingPercentEncoding;

//字符串转换为后台编码的策略
-(NSString *)contentStrByAddingPercentEncoding;

//获取一段随机字符串
+(NSString *)getRandomString;

/**
 获取加密以后的字符串
 
 @param passwordsalt 随机字符串通过base64处理的字符串
 @param passwordStr 明文密码
 @return 返回合并以后的sha1和base64处理的字符串
 */
+(NSString *)getEncryptedStringWithSalt:(NSString *)passwordsalt password:(NSString *)passwordStr;

//过滤HTML中的特殊字符
+ (NSString *)filterHTMLTag:(NSString *)str;


@end
