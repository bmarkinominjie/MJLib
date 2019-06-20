//
//  NSString+Extention.h
//  SpDrawLabel4-9
//
//  Created by ZhongSpace on 16/4/9.
//  Copyright © 2016年 ZhongSpace. All rights reserved.
//

#import <UIKit/UIKit.h>

#define NR(rect) NSStringFromCGRect(rect)
#define NS(size) NSStringFromCGSize(size)
#define NP(point) NSStringFromCGPoint(point)

/**
 打印Rect
 */
#define NRL(tag,rect)  NSLog(@"%@Rect==%@",tag,NR(rect))
#define NSL(tag,size)  NSLog(@"%@Size==%@",tag,NS(size))
#define NPL(tag,point)  NSLog(@"%@Point==%@",tag,NP(point))

@interface NSString (SpExtention)


/**
 限制宽度计算文字尺寸(高度设置为Max_Float)
 */
- (CGSize)sizeWithConstrainedToWidth:(float)width fromFont:(UIFont *)font1 lineSpace:(float)lineSpace;

/**
 把文字画在上下文的位置size为上下文的宽度，position为文字相对于上下文的位置
 */
-(void)drawInContext:(CGContextRef)context size:(CGSize)size color:(UIColor*)color
            position:(CGPoint)point font:(UIFont*)font1;

/**
 截取某个间距的字符串
 */
- (NSString*) substringFromIndex:(NSUInteger)from toIndex: (NSUInteger) to;

/**
 返回回字符串的位置，首字母的位置
 */
- (NSUInteger) indexOfSubstring: (NSString*) substring;

/**
 替换某个字符串
 */
- (NSString*) replace: (NSString*)target withString: (NSString*)replacement;

/**
 判断是否含有某个字符串
 */
- (bool) contains: (NSString*) substring ;

/**
 以时间为文件名创建文件路径
 */
+(NSString *)getImagePathWithFile:(NSString *)fileName;

/**
 以时间为文件名保存图片到沙盒
 */
+(BOOL)writeImageToFile:(UIImage *)image File:(NSString *)file;

/**
 从沙盒中读取一张图片
 */
+(UIImage *)readImageFromSanBoxWithFile:(NSString *)file;

/**
 获取国家名称
 */
+(NSString *)getCurrentCountryNameWithShortName:(NSString*)shortName;

/**
 * 返回国家名称的缩写
 */
+(NSString *)getCurrentCountryShortName:(NSString *)countryName;



@end
