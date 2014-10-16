//
//  UpnpHelper.h
//  XFUpnpScan-xcode5
//
//  Created by mac on 14-10-15.
//  Copyright (c) 2014年 XF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UpnpHelper : NSObject

//判断播放返回状态码是否正确
+ (BOOL)ActionStatueIsSucessful:(NSMutableArray*)marray;
//规避xml中在http中出现解析不了的字符如：&
+ (NSString*)stringEscapeXml:(NSString*)sourcestr;
+ (NSMutableString*)xmlSimpleEscape:(NSMutableString*)sourcestr;

//将时间转换成固定格式 00:00:00
+ (NSString*)makeDataToString:(NSInteger)date;

@end
