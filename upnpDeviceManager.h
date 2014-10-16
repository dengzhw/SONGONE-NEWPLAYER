//
//  upnpDeviceInfo.h
//  SongOne
//
//  Created by mac on 14-10-11.
//  Copyright (c) 2014年 xiaoran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceService.h"
#import "DeviceRender.h"
#import "upnpServiceInfo.h"

@interface upnpDeviceManager : NSObject
@property (strong, nonatomic) NSMutableArray* renderList;
@property (strong, nonatomic) NSMutableArray* serviceList;
@property (strong, nonatomic) upnpServiceInfo* upnpService;
+ (upnpDeviceManager*)sharedInstance;
@end
