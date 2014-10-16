//
//  SOSearch.m
//  ssdp
//
//  Created by mac on 14-10-8.
//  Copyright (c) 2014年 deng.com. All rights reserved.
//

#import "SSDPDeviceSearch.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import "SODefine.h"
@implementation SSDPDeviceSearch {
    SSDP* ssdp;
    NSMutableDictionary* msDict;
    NSMutableDictionary* mrDict;
    NSString* wifiSSID;
    int searchTimes;
    NSThread* searchThread;
}
+ (SSDPDeviceSearch*)shareDistance
{
    static SSDPDeviceSearch* searchDevcie;
    if (!searchDevcie) {
        searchDevcie = [[[self class] alloc] init];
    }
    return searchDevcie;
}
- (id)init
{
    self = [super init];
    if (self) {
        if (!msDict) {
            msDict = [NSMutableDictionary dictionary];
        }
        if (!mrDict) {
            mrDict = [NSMutableDictionary dictionary];
        }
        self.upnpDevice = [upnpDeviceManager sharedInstance];
    }
    return self;
}
#pragma mark--
#pragma mark--Puplic Meothes
- (void)startSSDP
{
    searchTimes = 0;
    if (!searchThread) {
        searchThread = [[NSThread alloc] initWithTarget:self selector:@selector(searchThreadSSID) object:nil];
        [searchThread start];
    }
}
- (void)searchThreadSSID
{
    while (1) {
        if (searchTimes > 12) {
            continue;
        }
        if (!ssdp) {
            ssdp = [[SSDP alloc] init];
        }
        ssdp.delegate = self;
        [ssdp startScanning];
        searchTimes++;
        usleep(300);
    }
}
- (void)clearSSDP
{
    [msDict removeAllObjects];
    [mrDict removeAllObjects];
    [self.delegate receiveMRDeviceModeDict:msDict];
    [self.delegate receiveMSDeviceModeDict:mrDict];
}
#pragma mark--
#pragma mark--SSDPDelegate
- (void)browserType:(NSString*)Type foundService:(NSDictionary*)service;
{
    if (service.count <= 0) {
        return;
    }
    //wifi改变了，清除上-网络的设备
    NSString* offsetSSID = [self fetchSSIDInfo];
    if (!offsetSSID || ![offsetSSID isEqualToString:wifiSSID]) {
        [mrDict removeAllObjects];
        [msDict removeAllObjects];
        wifiSSID = offsetSSID;
        return;
    }

    if ([Type isEqualToString:UPNP_MEDIARENDER]) {
        //NSLog(@"mrDict = %@",service[@"USN"]);
        //MR
        //如果添加了就return掉
        if ([[mrDict allKeys] containsObject:service[@"USN"]]) {
            return;
        }
        DeviceRender* mrMode = [[DeviceRender alloc] initWithDictionary:service];
        if (mrMode.XMLState) {
            NSLog(@"search device MR Url error");
            return;
        }
        NSArray* tempArray = [[NSArray alloc] initWithObjects:mrMode, nil];

        [mrDict setObject:tempArray forKey:service[@"USN"]];
        [[NSNotificationCenter defaultCenter] postNotificationName:POSTRENDERNOTIFY object:mrDict];

    } else if ([Type isEqualToString:UPNP_MEDIASERVER]) {
        //NSLog(@"msDict = %@",service[@"USN"]);
        //MS
        //如果添加了就return掉
        if ([[msDict allKeys] containsObject:service[@"USN"]]) {
            return;
        }
        DeviceService* msMode = [[DeviceService alloc] initWithDictionary:service];
        if (msMode.XMLState) {
            NSLog(@"search device MS Url error");
            return;
        }
        NSArray* tempArray = [[NSArray alloc] initWithObjects:msMode, nil];
        [msDict setObject:tempArray forKey:service[@"USN"]];
        [[NSNotificationCenter defaultCenter] postNotificationName:POSTSERVICENOTIFY object:msDict];
    }
}

- (NSString*)fetchSSIDInfo
{
    NSString* info = nil;
    CFArrayRef supportedInterfacesArrayRef = CNCopySupportedInterfaces();
    NSArray* netArray = (__bridge NSArray*)supportedInterfacesArrayRef;
    for (NSString* netItem in netArray) {
        CFDictionaryRef dicRef = CNCopyCurrentNetworkInfo((__bridge CFStringRef)netItem);
        if (dicRef != NULL) {
            CFStringRef ssid = CFDictionaryGetValue(dicRef, kCNNetworkInfoKeySSID);
            info = (__bridge id)ssid;
        }
    }
    return info;
}
@end
