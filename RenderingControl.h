//
//  RenderingControl.h
//  XFUpnpScan-xcode5
//
//  Created by mac on 14-10-15.
//  Copyright (c) 2014年 XF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RenderingControl : NSObject

@property (strong, nonatomic) NSString* controlUrl;
- (id)initRenderControlWithControlUrl:(NSString*)controlUrl;

- (float)volume;
- (BOOL)setVolume:(NSInteger)volume;

@end
