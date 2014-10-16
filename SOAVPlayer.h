//
//  SOAVPlayer.h
//  SongOne
//
//  Created by mac on 14-9-19.
//  Copyright (c) 2014年 xiaoran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SOAudioPlayer.h"

@interface SOAVPlayer : NSObject
@property (strong, nonatomic) SOAudioPlayer* avplayer;

- (void)play;
//播放器暂停
- (void)pause;
//播放器停止
- (void)stop;

- (void)addToAVPlayer:(SOAudio*)audio;
- (NSInteger)avduration_times;
- (NSInteger)vacurrent_times;
- (void)setVolume:(float)volume;
- (float)volume;

//设置拖拽进度条功能。
- (void)setSeekTime:(float)seektimes;
- (NSString*)durationTime;
- (NSString*)currentTime;
- (BOOL)isPlaying;

@end
