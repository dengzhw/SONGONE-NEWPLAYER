//
//  SOSearch.h
//  ssdp
//
//  Created by mac on 14-10-8.
//  Copyright (c) 2014年 deng.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UpnpSSDP.h"
#import "DeviceRender.h"
#import "DeviceService.h"
#import "upnpDeviceManager.h"
#define UPNP_MEDIASERVER @"urn:schemas-upnp-org:device:MediaServer:1"
#define UPNP_MEDIARENDER @"urn:schemas-upnp-org:device:MediaRenderer:1"

@protocol SSDPDeviceSearchDelegate <NSObject>
@optional
//回调设备的改变
- (void)receiveMRDeviceModeDict:(NSDictionary*)mrDict;

- (void)receiveMSDeviceModeDict:(NSDictionary*)msDict;

@end

@interface SSDPDeviceSearch : NSObject <SSDPDelegate>
@property (strong, nonatomic) id<SSDPDeviceSearchDelegate> delegate;
@property (strong, nonatomic) upnpDeviceManager* upnpDevice;
+ (SSDPDeviceSearch*)shareDistance;

- (void)startSSDP;
- (void)clearSSDP;
@end
