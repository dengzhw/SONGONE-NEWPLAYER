//
//  upnpDeviceInfo.m
//  SongOne
//
//  Created by mac on 14-10-11.
//  Copyright (c) 2014年 xiaoran. All rights reserved.
//获取所有的设备列表

#import "upnpDeviceManager.h"
#import "SODefine.h"

@implementation upnpDeviceManager {
}

- (id)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RenderRecive:) name:POSTRENDERNOTIFY object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ServcieRecive:) name:POSTSERVICENOTIFY object:nil];
        self.renderList = [[NSMutableArray alloc] init];
        self.serviceList = [[NSMutableArray alloc] init];
    }
    return self;
}

static upnpDeviceManager* singleInstance = nil;
+ (upnpDeviceManager*)sharedInstance
{
    if (singleInstance == nil) {
        @synchronized(self)
        {
            if (singleInstance == nil) {
                singleInstance = [[[self class] alloc] init];
            }
        }
    }
    return singleInstance;
}

- (void)RenderRecive:(NSNotification*)notify
{
    NSDictionary* renderdic = (NSDictionary*)[notify object];
    NSLog(@"renderdic = %@", [renderdic allKeys]);

    for (NSArray* deviceMode in [renderdic allValues]) {
        DeviceRender* render = deviceMode[0];
        if ([self.renderList containsObject:render]) {
            return;
        }
        [self.renderList addObject:render];
    }
}

- (void)ServcieRecive:(NSNotification*)notify
{
    NSDictionary* servicedic = (NSDictionary*)[notify object];
    NSLog(@"servicedic = %@", [servicedic allKeys]);

    for (NSArray* deviceMode in [servicedic allValues]) {
        DeviceService* service = deviceMode[0];
        if ([self.serviceList containsObject:service]) {
            return;
        }

        [self.serviceList addObject:service];
    }
}

@end
