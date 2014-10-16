//
//  upnpServiceInfo.m
//  SongOne
//
//  Created by mac on 14-10-11.
//  Copyright (c) 2014年 xiaoran. All rights reserved.
//

#import "upnpServiceInfo.h"

@implementation upnpServiceInfo

- (id)initWithServiceType:(NSString*)serviceType andControlUrl:(NSString*)controlUrl
{
    self = [super init];
    if (self) {
        self.serviceType = serviceType;
        self.controlUrl = controlUrl;
    }
    return self;
}

@end
