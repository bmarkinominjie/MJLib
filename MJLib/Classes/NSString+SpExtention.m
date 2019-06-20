//
//  NSString+Extention.m
//  SpDrawLabel4-9
//
//  Created by ZhongSpace on 16/4/9.
//  Copyright © 2016年 ZhongSpace. All rights reserved.
//

#import "NSString+SpExtention.h"
#import <CoreText/CoreText.h>



@implementation NSString (SpExtention)

/**
 返回字符串的位置，首字母的位置
 */
- (NSUInteger) indexOfSubstring: (NSString*) substring {
    NSRange range = [self rangeOfString:substring options:NSCaseInsensitiveSearch];
    return range.location == NSNotFound ? -1 : range.location;
}


/**
 截取某个间距的字符串
 */
- (NSString*) substringFromIndex:(NSUInteger)from toIndex: (NSUInteger) to {
    NSRange range;
    range.location = from;
    range.length = to - from;
    return [self substringWithRange: range];
}


/**
 是否包含某个字符串
 */
- (bool) contains: (NSString*) substring {
    NSRange range = [self rangeOfString:substring];
    return range.location != NSNotFound;
}

- (NSString*) replace: (NSString*) target withString: (NSString*) replacement {
    return [self stringByReplacingOccurrencesOfString:target withString:replacement];
}
/**
 限制宽度计算文字尺寸(高度设置为Max_Float)
 */
- (CGSize)sizeWithConstrainedToWidth:(float)width fromFont:(UIFont *)font1 lineSpace:(float)lineSpace{
    return [self sizeWithConstrainedToSize:CGSizeMake(width, CGFLOAT_MAX) fromFont:font1 lineSpace:lineSpace];
}

/**
 限制宽度计算文字尺寸(高度设置为Max_Float)
 */
- (CGSize)sizeWithConstrainedToSize:(CGSize)size fromFont:(UIFont *)font1 lineSpace:(float)lineSpace{
    CGFloat minimumLineHeight = font1.pointSize,maximumLineHeight = minimumLineHeight, linespace = lineSpace;
    CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)font1.fontName,font1.pointSize,NULL);
    CTLineBreakMode lineBreakMode = kCTLineBreakByWordWrapping;
    //Apply paragraph settings
    CTTextAlignment alignment = kCTTextAlignmentLeft;
    CTParagraphStyleRef style = CTParagraphStyleCreate((CTParagraphStyleSetting[6]){
        {kCTParagraphStyleSpecifierAlignment, sizeof(alignment), &alignment},
        {kCTParagraphStyleSpecifierMinimumLineHeight,sizeof(minimumLineHeight),&minimumLineHeight},
        {kCTParagraphStyleSpecifierMaximumLineHeight,sizeof(maximumLineHeight),&maximumLineHeight},
        {kCTParagraphStyleSpecifierMaximumLineSpacing, sizeof(linespace), &linespace},
        {kCTParagraphStyleSpecifierMinimumLineSpacing, sizeof(linespace), &linespace},
        {kCTParagraphStyleSpecifierLineBreakMode,sizeof(CTLineBreakMode),&lineBreakMode}
    },6);
    NSDictionary* attributes = [NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)font,(NSString*)kCTFontAttributeName,(__bridge id)style,(NSString*)kCTParagraphStyleAttributeName,nil];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self attributes:attributes];
    //    [self clearEmoji:string start:0 font:font1];
    CFAttributedStringRef attributedString = (__bridge CFAttributedStringRef)string;
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedString);
    CGSize result = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, [string length]), NULL, size, NULL);
    CFRelease(framesetter);
    CFRelease(font);
    CFRelease(style);
    string = nil;
    attributes = nil;
    return result;
}


/**
 把文字画在上下文的位置size为上下文的宽度，position为文字相对于上下文的位置
 */
-(void)drawInContext:(CGContextRef)context size:(CGSize)size color:(UIColor*)color
            position:(CGPoint)point font:(UIFont*)font1
{
    CGContextSetTextMatrix(context,CGAffineTransformIdentity);
    CGContextTranslateCTM(context,0,size.height);
    CGContextScaleCTM(context,1.0,-1.0);
    
    CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)font1.fontName, font1.pointSize, NULL);
    
    UIColor *  textColor = color;
    
    CGFloat minimumLineHeight = font1.pointSize,maximumLineHeight = minimumLineHeight+10, linespace = 5;
    
    CTTextAlignment alignment = kCTTextAlignmentLeft;
    
    CTLineBreakMode lineBreakMode = kCTLineBreakByWordWrapping;
    
    //Apply paragraph settings
    CTParagraphStyleRef style = CTParagraphStyleCreate((CTParagraphStyleSetting[6]){
        {kCTParagraphStyleSpecifierAlignment, sizeof(alignment), &alignment},
        {kCTParagraphStyleSpecifierMinimumLineHeight,sizeof(minimumLineHeight),&minimumLineHeight},
        {kCTParagraphStyleSpecifierMaximumLineHeight,sizeof(maximumLineHeight),&maximumLineHeight},
        {kCTParagraphStyleSpecifierMaximumLineSpacing, sizeof(linespace), &linespace},
        {kCTParagraphStyleSpecifierMinimumLineSpacing, sizeof(linespace), &linespace},
        {kCTParagraphStyleSpecifierLineBreakMode,sizeof(CTLineBreakMode),&lineBreakMode}
    },6);
    
    CGMutablePathRef path = CGPathCreateMutable();
    [[UIColor grayColor]set];
    //在后面的CTF里面吧Path加入去上下文了，所有这里不再需要吧路径添加到上下文
    CGPathAddRect(path, NULL, CGRectMake(point.x,-point.y, size.width, size.height));
    
    
    NSDictionary * attribute = [[NSDictionary alloc]initWithObjectsAndKeys:(__bridge id)font,kCTFontAttributeName,textColor,kCTForegroundColorAttributeName,(__bridge id)style,kCTParagraphStyleAttributeName, nil];
    

    
    
    NSMutableAttributedString * attributeStr = [[NSMutableAttributedString alloc]initWithString:self attributes:attribute];
    
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributeStr);
    CTFrameRef frameR =CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, self.length), path, NULL);
    
    CTFrameDraw(frameR, context);
    
    CFRelease(frameR);
    CFRelease(frameSetter);
    CFRelease(font);
    CFRelease(style);
    CGPathRelease(path);
    //不再次修改会影响第二次效果。。
    [[attributeStr mutableString]setString:@""];
    CGContextSetTextMatrix(context,CGAffineTransformIdentity);
    CGContextTranslateCTM(context,0, size.height);
    CGContextScaleCTM(context,1.0,-1.0);
}


+(NSString *)getImagePathWithFile:(NSString *)fileName
{
    //把图片保存在沙盒
    NSString * cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)firstObject];
//    NSLog(@"沙盒路径--%@",cachePath);
    //以时间创建文件名
    NSString * NewfileName = [NSString stringWithFormat:@"%@",fileName];
    //计算出文件的全路径
    NSString * file = [cachePath stringByAppendingPathComponent:NewfileName];
    
    return file;
}
+(BOOL)writeImageToFile:(UIImage *)image File:(NSString *)file
{
    //保存到沙盒
    NSData * data = UIImageJPEGRepresentation(image, 0);
    
    return  [data writeToFile:file atomically:YES];
}

+(UIImage *)readImageFromSanBoxWithFile:(NSString *)file
{
    NSData * data = [NSData dataWithContentsOfFile:file];
    UIImage * image = [UIImage imageWithData:data];
    return image;
    
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
/**
 * 根据国家的全称返回缩写
 */
+(NSString *)getCurrentCountryShortName:(NSString *)countryName
{
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    NSString * path  = [[NSBundle mainBundle]pathForResource:@"CountryAndArea.plist" ofType:nil];
    NSArray * array = [NSArray arrayWithContentsOfFile:path];
    
    if ([currentLanguage containsString:@"zh-Hans"]) {
        for (NSDictionary * dict in array) {
            NSString * longName = [dict[@"国家或地区"] lowercaseString];
            if ([longName isEqualToString:[countryName lowercaseString]]) {
                NSString * shortName = dict[@"国际域名缩写"];
                return shortName;
            }
        }

    }else{
        for (NSDictionary * dict in array) {
            NSString * longName = [dict[@"Countries and Regions"] lowercaseString];
            if ([longName isEqualToString:[countryName lowercaseString]]) {
                NSString * shortName = dict[@"国际域名缩写"];
                return shortName;
            }
        }
    }
    return @"";
    
}



@end
