//
//  SOAVPlayer.m
//  SongOne
//
//  Created by mac on 14-9-19.
//  Copyright (c) 2014年 xiaoran. All rights reserved.
//

#import "SOAVPlayer.h"

@implementation SOAVPlayer

- (id)init
{
    self = [super init];
    if (self) {
        self.avplayer = [SOAudioPlayer sharedAVPlayer];
    }
    return self;
}

/////////////////////////////////////////////////////播放信息
//本机开始播放，除了doucment文件
- (void)play
{
    [self.avplayer play];
}
//播放器暂停
- (void)pause
{
    [self.avplayer pause];
}
//播放器停止
- (void)stop
{
    [self.avplayer stop];
}

- (void)addToAVPlayer:(SOAudio*)audio
{
    self.avplayer = [SOAudioPlayer sharedAVPlayer];
    [self.avplayer addPlayAudio:audio];
}

- (NSInteger)avduration_times
{
    return [self.avplayer durationSeconds];
}
- (NSInteger)vacurrent_times
{
    return [self.avplayer currentSeconds];
}
- (void)setVolume:(float)volume
{
    [self.avplayer setVolume:volume];
}
- (float)volume
{
    return [self.avplayer volume];
}

//设置拖拽进度条功能。
- (void)setSeekTime:(float)seektimes
{
    [self.avplayer setSeekTime:seektimes];
}
- (NSString*)durationTime
{
    return [self.avplayer durationTime];
}
- (NSString*)currentTime
{
    return [self.avplayer currentTime];
}
- (BOOL)isPlaying
{
    return [self.avplayer isPlaying];
}

@end
