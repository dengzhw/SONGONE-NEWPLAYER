//
//  SOVMediaPlayer.m
//  SongOne
//
//  Created by mac on 14-9-19.
//  Copyright (c) 2014年 xiaoran. All rights reserved.
//

#import "SOVMediaPlayer.h"

@implementation SOVMediaPlayer {
    dispatch_queue_t _playQueue;
    NSInteger repeattimes;
}

/*static SOVMediaPlayer* singleInstance = nil;

- (id)init
{
    self = [super init];
    if (self) {
        self.vmediaplayer = [[VMediaPlayer alloc] init];
        UIView* view = [[UIView alloc] initWithFrame:CGRectZero];
        [self.vmediaplayer setupPlayerWithCarrierView:view withDelegate:self];
        _playQueue = dispatch_get_global_queue(0, 0);
    }
    return self;
}
+ (SOVMediaPlayer*)shareInstance
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
//- (void)initCurrentPlayer:(id)player
//{
//    currentplayer = (SOBoxPlayer*)player;
//}
- (void)addToVMediaPlayer:(SOAudio*)audio
{
    //    playerservice = [SOPlayerService shareInstance];
    NSLog(@"%@hhhh", audio.play_uri);
    if (audio.play_uri != nil && audio.play_uri.length > 0 && ![audio.play_uri isEqualToString:@"NULL"]) {
        NSURL* url = [NSURL URLWithString:audio.play_uri];
        dispatch_async(_playQueue, ^{
            [self.vmediaplayer reset];
            [self.vmediaplayer setDataSource:url];
            [self.vmediaplayer prepareAsync];
        });
    } else {
        NSLog(@"VMediaPlayer is Error");
    }
}

- (void)play
{
    [self.vmediaplayer start];
}
//播放器暂停
- (void)pause
{
    [self.vmediaplayer pause];
}
//播放器停止
- (void)stop
{
    [self.vmediaplayer pause];
}
//清空重置播放器
- (void)reset
{
    [self.vmediaplayer reset];
}

- (NSInteger)avduration_times
{
    return (NSInteger)([self.vmediaplayer getDuration] / 1000);
}
- (NSInteger)vacurrent_times
{

    return (NSInteger)([self.vmediaplayer getCurrentPosition] / 1000);
}
- (void)setVolume:(float)volume
{
    [self.vmediaplayer setVolume:volume];
}
- (float)volume
{
    return [self.vmediaplayer getVolume];
}

//设置拖拽进度条功能。
- (void)setSeekTime:(float)seektimes
{
    return [self.vmediaplayer seekTo:(long)seektimes * 1000];
}
- (BOOL)isPlaying
{
    return [self.vmediaplayer isPlaying];
}

#pragma mark---- VMediaPlayerDelegate
- (void)mediaPlayer:(VMediaPlayer*)player setupManagerPreference:(id)arg
{
    player.decodingSchemeHint = VMDecodingSchemeSoftware;
    player.autoSwitchDecodingScheme = NO;
}
- (void)mediaPlayer:(VMediaPlayer*)player didPrepared:(id)arg
{
    repeattimes = 0;
    dispatch_async(_playQueue, ^{
        [self play];
        dispatch_async(dispatch_get_main_queue(), ^{
            //[self.delegate playstart:currentplayer];
        });
    });
}
// 当'该音视频播放完毕'时, 该协议方法被调用, 我们可以在此作一些播放器善后
// 操作, 如: 重置播放器, 准备播放下一个音视频等
- (void)mediaPlayer:(VMediaPlayer*)player playbackComplete:(id)arg
{
    [self reset];
}
// 如果播放由于某某原因发生了错误, 导致无法正常播放, 该协议方法被调用, 参
// 数 arg 包含了错误原因.
- (void)mediaPlayer:(VMediaPlayer*)player error:(id)arg
{
    //[self.delegate playerror:currentplayer];
    //[currentplayer threadEndTime];

    NSLog(@"NAL 1RRE &&&& VMediaPlayer Error: %@", arg);
}
//缓冲完毕
- (void)mediaPlayer:(VMediaPlayer*)player seekComplete:(id)arg
{
    NSLog(@"seekcomplete  percent %@", arg);
}
- (void)mediaPlayer:(VMediaPlayer*)player notSeekable:(id)arg
{
    NSLog(@"notSeekable %@", arg);
}

- (void)mediaPlayer:(VMediaPlayer*)player bufferingStart:(id)arg
{
    NSLog(@"bufferstart pause play");
    dispatch_async(_playQueue, ^{
        //[currentplayer threadEndTime];
        //currentplayer.boxplayerstate = MESSAGEPRE;
        [self pause];
        dispatch_async(dispatch_get_main_queue(), ^{
          //  [self.delegate playbufferstart:currentplayer];
        });
    });
}
- (void)mediaPlayer:(VMediaPlayer*)player bufferingEnd:(id)arg
{
    NSLog(@"bufferend start play");
    repeattimes++;
    if (repeattimes > 1) {
        repeattimes = 0;
        return;
    }
    dispatch_async(_playQueue, ^{
        [self play];
        //currentplayer.boxplayerstate = MESSAGEPLAY;
        //[currentplayer threadStartTime];
        dispatch_async(dispatch_get_main_queue(), ^{
            //[self.delegate playbufferend:currentplayer];
        });
    });
}
 */

@end
