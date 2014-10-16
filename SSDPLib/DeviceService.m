//
//  DeviceInfoMSMode.m
//  WifiScanTesting
//
//  Created by qisheng on 14-10-9.
//  Copyright (c) 2014年 XF. All rights reserved.
//

#import "DeviceService.h"
#import "XMLDictionary.h"
@implementation DeviceService
- (id)initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
        _locationURL = dict[@"LOCATION"];
        _ST = dict[@"ST"];
        _usn = dict[@"USN"];
        if (!_locationURL) {
            _XMLState = YES;
            return self;
        }
        NSError* error = nil;
        NSURL* URL = [[NSURL alloc] initWithString:_locationURL];
        NSString* xmlString = [[NSString alloc] initWithContentsOfURL:URL encoding:NSUTF8StringEncoding error:&error];
        NSDictionary* xmlDoc = [NSDictionary dictionaryWithXMLString:xmlString];
        if (xmlDoc) {
            NSDictionary* deviceDoc = xmlDoc[@"device"];
            _baseUrl = xmlDoc[@"URLBase"];
            NSInteger baseurlLen = _baseUrl.length;
            if ([[_baseUrl substringFromIndex:baseurlLen - 1] isEqualToString:@"/"]) {
                _baseUrl = [_baseUrl substringToIndex:baseurlLen - 1];
            }
            _deviceType = deviceDoc[@"deviceType"];
            _udn = deviceDoc[@"UDN"];
            _friendlyName = deviceDoc[@"friendlyName"];
            NSDictionary* list = deviceDoc[@"serviceList"];
            NSArray* arry = list[@"service"];
            [self serviceListInfo:arry];
            _XMLState = NO;
        } else {
            _XMLState = YES;
        }
    }
    return self;
}

- (void)serviceListInfo:(NSArray*)serviceArray
{
    self.serverList = [[NSMutableArray alloc] init];
    for (int i = 0; i < serviceArray.count; i++) {
        NSDictionary* dic = serviceArray[i];
        upnpServiceInfo* serviceinfo = [[upnpServiceInfo alloc] initWithServiceType:dic[@"serviceType"] andControlUrl:dic[@"controlURL"]];
        [self.serverList addObject:serviceinfo];
    }
}

- (upnpServiceInfo*)findActionByServiceType:(NSString*)type
{
    if (self.serverList) {
        for (upnpServiceInfo* serviceInfo in self.serverList) {
            if ([type isEqualToString:serviceInfo.serviceType])
                return serviceInfo;
        }
    }
    return nil;
}

@end
