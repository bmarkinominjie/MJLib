//
//  NSString+SJFileMD5.h
//  
//
//  Created by SZHF-WZ on 2016/11/15.
//  Copyright © 2016年 sjcam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SJFileMD5)

+(NSString*)getFileMD5WithPath:(NSString*)path;

@end
