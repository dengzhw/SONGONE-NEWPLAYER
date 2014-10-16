//
//  RemoteServer.h
//  XFUpnpScan-xcode5
//
//  Created by mac on 14-10-15.
//  Copyright (c) 2014年 XF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServiceContent.h"
#import "DeviceService.h"

@interface RemoteServer : NSObject
@property (strong, nonatomic) DeviceService* server;
@property (strong, nonatomic) ServiceContent* servercontent;

- (id)initWithServer:(DeviceService*)server;
- (NSArray*)browseDirectChildren:(NSString*)rObjectId requestedCount:(NSUInteger)rcount requestedStartIndex:(NSUInteger)rstartIndex;

@end
