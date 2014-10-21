//
//  LocalPlay.h
//  XFUpnpScan-xcode5
//
//  Created by mac on 14-10-16.
//  Copyright (c) 2014年 XF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SOAVPlayer.h"
#import "PlayList.h"
#import "CommonHelperManager.h"
#import "SOVMediaPlayer.h"
#import "SOPlayState.h"
#import "SODefine.h"
#import "AppDelegate.h"
#import "PositionInfo.h"
#import "SO_Player.h"
#define AVPLAYER 1
#define VMEDIAPLAYER 2

@interface LocalPlay : NSObject <Player>
@property (strong, nonatomic) SOAVPlayer* avplayer; //ipod播放器
@property (strong, nonatomic) SOVMediaPlayer* vmplayer; //高品质播放器
@property (strong, nonatomic) PlayList* playList; //播放列表
@property (assign, nonatomic) NSInteger playerType; //1为avplayer 2:vmediaplayer
@property (assign, nonatomic) NSInteger playMode; //播放模式
@property (strong, nonatomic) SOPlayState* boxPlayerstate; //播放状态监听
@property (strong, nonatomic) PositionInfo* positionInfo;
@property (strong, nonatomic) id<Player> Player;

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

+ (LocalPlay*)shareLocalPlayer;

@end
