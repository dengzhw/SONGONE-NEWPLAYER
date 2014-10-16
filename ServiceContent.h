//
//  ServiceContent.h
//  XFUpnpScan-xcode5
//
//  Created by mac on 14-10-15.
//  Copyright (c) 2014年 XF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceContent : NSObject
@property (strong, nonatomic) NSString* controlUrl;
- (id)initRenderControlWithControlUrl:(NSString*)controlUrl;
- (NSArray*)browseDirectChildren:(NSString*)aObjectId requestedCount:(NSUInteger)count requestedStartIndex:(NSUInteger)startIndex;

@end
