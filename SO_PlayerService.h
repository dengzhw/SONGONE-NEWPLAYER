//
//  SO_PlayerService.h
//  NewUPNP
//
//  Created by mac on 14-10-16.
//  Copyright (c) 2014年 deng.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SO_Player.h"
#import "upnpDeviceManager.h"

@interface SO_PlayerService : NSObject

@property (strong, nonatomic) upnpDeviceManager* upnpdeviceManager;
@property (strong, nonatomic) NSMutableArray* boxplayerQueue;
@property (strong, nonatomic) NSMutableArray* selectedBoxPlayerQueue;
@property (strong, nonatomic) NSMutableArray* boxserverQueue;
@property (strong, nonatomic) id<Player> currentPlayer;

+ (SO_PlayerService*)shareInstance;
- (void)switchCurrentPlayer:(id)player;
@end
