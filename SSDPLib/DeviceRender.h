//
//  DeviceInfoMRMode.h
//  WifiScanTesting
//
//  Created by qisheng on 14-10-9.
//  Copyright (c) 2014年 XF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "upnpServiceInfo.h"
@interface DeviceRender : NSObject
//"http://192.168.14.117:49153
@property (nonatomic, strong) NSString* baseUrl;
//"http://192.168.14.117:49153/renderer.xml";
@property (nonatomic, strong) NSString* locationURL;
//ST = "urn:schemas-upnp-org:device:MediaRenderer:1";
@property (nonatomic, strong) NSString* stXML;
//"uuid:xx-02e07c05975b_MR::urn:schemas-upnp-org:device:MediaRenderer:1";
@property (nonatomic, strong) NSString* usnXML;
//"urn:schemas-upnp-org:device:MediaRenderer:1"
@property (nonatomic, strong) NSString* deviceType;
//uuid:xx-02e07c05975b_MR
@property (nonatomic, strong) NSString* udn;
//设备的名称
@property (nonatomic, strong) NSString* friendlyName;
/*
    数组中元素的样式如下(3个元素)：
    @"SCPDURL" : @"/web/rct.xml"
    @"serviceId" : @"urn:upnp-org:serviceId:RenderingControl"
    @"controlURL" : @"/MediaRenderer/RenderingControl/Control"
    @"serviceType" : @"urn:schemas-upnp-org:service:RenderingControl:1"
    @"eventSubURL" : @"/MediaRenderer/RenderingControl/Event"
*/
@property (nonatomic, strong) NSMutableArray* serviceList;

@property (nonatomic, assign) BOOL XMLState;
- (id)initWithDictionary:(NSDictionary*)dict;
- (upnpServiceInfo*)findServiceActionByServiceType:(NSString*)type;
@end
