//
//  RemoteServer.m
//  XFUpnpScan-xcode5
//
//  Created by mac on 14-10-15.
//  Copyright (c) 2014年 XF. All rights reserved.
//

#import "RemoteServer.h"
#import "SODefine.h"

@implementation RemoteServer
- (id)initWithServer:(DeviceService*)server
{
    self = [super init];
    if (self) {
        self.server = server;
        [self setRenderService:SERVICE_TYPE3];
    }
    return self;
}

- (void)setRenderService:(NSString*)serviceType
{
    upnpServiceInfo* server = [self.server findActionByServiceType:serviceType];
    if (server != nil) {
        if ([serviceType isEqualToString:SERVICE_TYPE3]) {
            NSString* urlBase = [self.server baseUrl];
            self.servercontent = [[ServiceContent alloc] initRenderControlWithControlUrl:[NSString stringWithFormat:@"%@%@", urlBase, server.controlUrl]];
        }
    }
}
//获取音箱的sdcard数据或u盘数据
- (NSArray*)browseDirectChildren:(NSString*)rObjectId requestedCount:(NSUInteger)rcount requestedStartIndex:(NSUInteger)rstartIndex
{
    return [self.servercontent browseDirectChildren:rObjectId requestedCount:rcount requestedStartIndex:rstartIndex];
}

@end
