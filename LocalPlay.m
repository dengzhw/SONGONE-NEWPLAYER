//
//  LocalPlay.m
//  XFUpnpScan-xcode5
//
//  Created by mac on 14-10-16.
//  Copyright (c) 2014年 XF. All rights reserved.
//

#import "LocalPlay.h"

@implementation LocalPlay

static LocalPlay* singleInstance;
//本地播放器相关的操作
- (id)init
{
    self = [super init];
    if (self) {
        self.avplayer = [[SOAVPlayer alloc] init];
        self.vmplayer = [SOVMediaPlayer shareInstance];
    }
    return self;
}

+ (LocalPlay*)shareLocalPlayer
{
    if (singleInstance == nil) {
        @synchronized(self)
        {
            if (singleInstance == nil) {
                singleInstance = [[[self class] alloc] init];
            }
        }
    }
    return singleInstance;
}

//为播放器添加地址
- (void)addToAVPlayer:(SOAudio*)audio
{
    if (self.playerType == 1) {
        //[self.vmplayer reset];
        //[self.vmplayer stop];
        [self.avplayer addToAVPlayer:audio];
    }
    /*else {
     [self.avplayer stop];
     [self.vmplayer addToVMediaPlayer:audio];
     }*/
}

//播放
- (void)play
{
    if (self.playerType == 1) {
        [self.avplayer play];
    }
    /*else {
     dispatch_async(dispatch_get_global_queue(0, 0), ^{
     [self.vmplayer play];
     });
     }*/
}
//开始播放
- (void)start
{
    if (self.playerType == 1) {
        [self.avplayer play];
    }
}
//播放器暂停
- (void)pause
{
    if (self.playerType == 1) {
        [self.avplayer pause];
    }
    /*else {
     dispatch_async(dispatch_get_global_queue(0, 0), ^{
     [self.vmplayer pause];
     });
     }
     */
}
//播放器停止
- (void)stop
{
    if (self.playerType == 1) {
        [self.avplayer stop];
    }
    /*else {
     dispatch_async(dispatch_get_global_queue(0, 0), ^{
     [self.vmplayer stop];
     });
     }*/
}
//获取播放总长度
- (NSInteger)avduration_times
{
    //if (self.playerType == 1) {
    return [self.avplayer avduration_times];
    //}
    /*else {
     return [self.vmplayer avduration_times];
     }*/
}
//获取当前播放长度
- (NSInteger)vacurrent_times
{
    //if (self.playerType == 1) {
    return [self.avplayer vacurrent_times];
    //}
    /*else {
     return [self.vmplayer vacurrent_times];
     }*/
}
//设置播放器音量
- (void)setVolume:(float)volume
{
    //if (self.playerType == 1) {
    [self.avplayer setVolume:volume];
    //}
    /*else {
     [self.vmplayer setVolume:volume];
     }*/
}
//获取播放器音量
- (float)volume
{
    //if (self.playerType == 1) {
    return [self.avplayer volume];
    //}
    /*else {
     return [self.vmplayer volume];
     }*/
}

//设置拖拽进度条功能。
- (void)setSeekTime:(float)seektimes
{
    if (self.playerType == 1) {
        [self.avplayer setSeekTime:seektimes];
    }
    /*else {
     [self.vmplayer setSeekTime:seektimes];
     }*/
}

//获取播放器是否在播放
- (BOOL)isPlaying
{
    //if (self.playerType == 1) {
    return [self.avplayer isPlaying];
    //}
    /*else {
     return [self.vmplayer isPlaying];
     }*/
}

//设置播放器类型
- (void)playerType:(SOAudio*)audio
{
    NSString* songType = [CommonHelperManager PareURL:audio.play_uri];
    if ([songType isEqualToString:@""] || audio.audioType < 3) {
        self.playerType = 1;
    } else {
        self.playerType = 2;
    }
}
@end
