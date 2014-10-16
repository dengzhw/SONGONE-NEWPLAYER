//
//  DeviceInfoMSMode.h
//  WifiScanTesting
//
//  Created by qisheng on 14-10-9.
//  Copyright (c) 2014年 XF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "upnpServiceInfo.h"

@interface DeviceService : NSObject
@property (nonatomic, strong) NSString* baseUrl;
//"http://192.168.14.117:49153/renderer.xml";
@property (nonatomic, strong) NSString* locationURL;
//ST = "urn:schemas-upnp-org:device:MediaRenderer:1";
@property (nonatomic, strong) NSString* ST;
//"uuid:xx-02e07c05975b_MS::urn:schemas-upnp-org:device:MediaRenderer:1";
@property (nonatomic, strong) NSString* usn;
//"urn:schemas-upnp-org:device:MediaRenderer:1"
@property (nonatomic, strong) NSString* deviceType;
//uuid:xx-02e07c05975b_MS
@property (nonatomic, strong) NSString* udn;
//设备的名称
@property (nonatomic, strong) NSString* friendlyName;
/*
 数组中元素的样式如下(2个元素)：
 @"eventSubURL" : @"/MediaServer/ConnectionManager/Event"
 @"controlURL" : @"/MediaServer/ConnectionManager/Control"
 @"serviceType" : @"urn:schemas-upnp-org:service:ConnectionManager:1"
 @"SCPDURL" : @"/web/connectmanager.xml"
 @"serviceId" : @"urn:upnp-org:serviceId:ConnectionManager"
 */
@property (nonatomic, strong) NSMutableArray* serverList;

@property (nonatomic, assign) BOOL XMLState;

- (id)initWithDictionary:(NSDictionary*)dict;
- (upnpServiceInfo*)findActionByServiceType:(NSString*)type;
@end
