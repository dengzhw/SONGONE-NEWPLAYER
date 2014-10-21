//
//  UpnpHelper.m
//  XFUpnpScan-xcode5
//
//  Created by mac on 14-10-15.
//  Copyright (c) 2014年 XF. All rights reserved.
//

#import "UpnpHelper.h"
#import "SODefine.h"

@implementation UpnpHelper

//判断播放返回状态码是否正确
+ (BOOL)ActionStatueIsSucessful:(NSMutableArray*)marray
{
    if (marray.count < 2) {
        return NO;
    }
    NSDictionary* statudic = marray[0];
    if (marray.count >= 2 && [[statudic valueForKey:STATUSCODE] isEqualToString:@"200"]) {
        return YES;
    }
    return NO;
}

+ (NSString*)makeDataToString:(NSInteger)date
{
    NSString* datestr;
    // NSLog(@"%d",(int)(date/3600.0));
    if (((int)(date / 3600.0)) == 0) {
        datestr = [NSString stringWithFormat:@"%02d:%02d",
                                             (int)(fmod(date, 3600.0) / 60.0),
                                             (int)fmod(date, 60.0)];
    } else {
        datestr =
            [NSString stringWithFormat:@"%02d:%02d:%02d", (int)(date / 3600.0),
                                       (int)(fmod(date, 3600.0) / 60.0),
                                       (int)fmod(date, 60.0)];
    }
    return datestr;
}

+ (NSString*)stringEscapeXml:(NSString*)sourcestr
{

    return [[[[[sourcestr stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"]
        stringByReplacingOccurrencesOfString:@"&quot;"
                                  withString:@"\""]
        stringByReplacingOccurrencesOfString:@"&#x27;"
                                  withString:@"'"]
        stringByReplacingOccurrencesOfString:@"&gt;"
                                  withString:@">"]
        stringByReplacingOccurrencesOfString:@"&lt;"
                                  withString:@"<"];
}

+ (NSMutableString*)xmlSimpleEscape:(NSMutableString*)sourcestr
{
    [sourcestr replaceOccurrencesOfString:@"&" withString:@"&amp;" options:NSLiteralSearch range:NSMakeRange(0, [sourcestr length])];
    [sourcestr replaceOccurrencesOfString:@"\"" withString:@"&quot;" options:NSLiteralSearch range:NSMakeRange(0, [sourcestr length])];
    [sourcestr replaceOccurrencesOfString:@"'" withString:@"&#x27;" options:NSLiteralSearch range:NSMakeRange(0, [sourcestr length])];
    [sourcestr replaceOccurrencesOfString:@">" withString:@"&gt;" options:NSLiteralSearch range:NSMakeRange(0, [sourcestr length])];
    [sourcestr replaceOccurrencesOfString:@"<" withString:@"&lt;" options:NSLiteralSearch range:NSMakeRange(0, [sourcestr length])];

    return sourcestr;
}

@end
