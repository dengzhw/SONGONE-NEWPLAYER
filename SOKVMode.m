//
//  SOKVMode.m
//  XFUpnpScan-xcode5
//
//  Created by mac on 14-10-14.
//  Copyright (c) 2014年 XF. All rights reserved.
//

#import "SOKVMode.h"

@implementation SOKVMode
- (id)initKey:(NSString*)key widthValue:(NSString*)value
{
    self = [super init];
    if (self) {
        self.key = key;
        self.value = value;
    }
    return self;
}

@end
