//
//  RemotePlay.h
//  SongOne
//
//  Created by mac on 14-10-10.
//  Copyright (c) 2014年 xiaoran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PositionInfo.h"
#import "AVTansport.h"
#import "PlayList.h"
#import "UPnPServiceInfo.h"
#import "DeviceRender.h"
#import "RenderingControl.h"

@interface RemotePlay : NSObject
@property (strong, nonatomic) AVTansport* avTansport;
@property (strong, nonatomic) RenderingControl* renderindControl;
@property (strong, nonatomic) PlayList* playList;
@property (strong, nonatomic) DeviceRender* render;
@property (assign, nonatomic) int playMode;

- (id)initWithRender:(DeviceRender*)render;
- (BOOL)play;
- (BOOL)pause;
- (PositionInfo*)GetPosition;
- (NSString*)getTransportState;
- (float)VolumeInfo;
- (BOOL)setVolume:(float)volume;
@end
