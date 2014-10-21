//
//  SO_PlayerService.m
//  NewUPNP
//
//  Created by mac on 14-10-16.
//  Copyright (c) 2014年 deng.com. All rights reserved.
//

#import "SO_PlayerService.h"
#import "RemotePlay.h"
#import "LocalPlay.h"
#import "RemoteServer.h"
#import "DeviceRender.h"
#import "DeviceService.h"
@implementation SO_PlayerService

static SO_PlayerService* singleInstance = nil;

- (id)init
{
    self = [super init];
    if (self) {
        self.upnpdeviceManager = [upnpDeviceManager sharedInstance];
        self.boxplayerQueue = [[NSMutableArray alloc] init];
        self.selectedBoxPlayerQueue = [[NSMutableArray alloc] init];
        self.boxserverQueue = [[NSMutableArray alloc] init];
        [self createBoxPlayerQueue];
        [self createSelectedPlayerQueue];
    }

    return self;
}

+ (SO_PlayerService*)shareInstance
{
    if (singleInstance == nil) {
        @synchronized(self)
        {
            singleInstance = [[[self class] alloc] init];
        }
    }
    return singleInstance;
}
//初始化远程播放器集合
- (void)createBoxPlayerQueue
{
    for (DeviceRender* device in self.upnpdeviceManager.renderList) {
        RemotePlay* remotePlayer = [[RemotePlay alloc] initWithRender:device];
        [self.boxplayerQueue addObject:remotePlayer];
    }
}
//初始化选种播放器集合
- (void)createSelectedPlayerQueue
{
    LocalPlay* localplayer = [LocalPlay shareLocalPlayer];
    [self.selectedBoxPlayerQueue addObject:localplayer];
}
//删除所有远程播放器集合
- (void)clearBoxPlayerQueue
{
    [self.boxplayerQueue removeAllObjects];
}
//切换当前播放器
- (void)switchCurrentPlayer:(id)player
{
    [self.currentPlayer endPlayThread];
    self.currentPlayer = player;
    [self.currentPlayer startPlayThread];
}

@end
