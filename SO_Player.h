//
//  SO_Player.h
//  NewUPNP
//
//  Created by mac on 14-10-16.
//  Copyright (c) 2014年 deng.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PositionInfo;
@class SOAudio;
@protocol Player <NSObject>
@required
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
//开启播放线程
- (void)startPlayThread;
//关闭播放线程
- (void)endPlayThread;
//设置播放队列
- (BOOL)setPlayAudioList:(NSArray*)audioQueu;
//设置当前播放器的audio
- (BOOL)setPlayCurrentAudio:(SOAudio*)audio;
@optional
//获取播放进度信息
- (PositionInfo*)GetPosition;
//获取当前播放状态
- (NSString*)getTransportState;

@end
