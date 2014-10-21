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
#import "SO_Player.h"
#import "SODefine.h"
#import "SOPlayState.h"
#import "AppDelegate.h"
#import "IpodExport.h"

@interface RemotePlay : NSObject <Player, ipodExportDelegate>
@property (strong, nonatomic) AVTansport* avTansport;
@property (strong, nonatomic) RenderingControl* renderindControl;
@property (strong, nonatomic) PlayList* playList;
@property (strong, nonatomic) DeviceRender* render;
@property (assign, nonatomic) NSInteger playMode;
@property (strong, nonatomic) PositionInfo* positionInfo;
@property (strong, nonatomic) SOPlayState* boxPlayerstate;
@property (weak, nonatomic) id<Player> Player;
@property (assign, nonatomic) BOOL threadIsExit;
@property (assign, nonatomic) BOOL threadIsActive;

- (id)initWithRender:(DeviceRender*)render;

//播放
- (BOOL)play;
//播放器暂停
- (BOOL)pause;
//播放器停止
- (BOOL)stop;
//设置拖拽进度条功能。
- (BOOL)setSeekTime:(float)seektimes;
//获取播放器是否在播放
- (BOOL)isPlaying;
//设置本地播放器音量
- (BOOL)setVolume:(float)volume;
//获取本地播放器音量
- (float)volume;
//播放上一首
- (void)PlayPrevious;
//播放下一首
- (void)PlayNext;
//获取播放总长度
- (NSString*)avduration_times;
//获取当前播放长度
- (NSString*)vacurrent_times;
//获取播放进度信息
- (PositionInfo*)GetPosition;
//获取当前播放状态
- (NSString*)getTransportState;
//注册kvo
- (void)addKVOReg:(id)obj targetValue:(id)target;

@end
