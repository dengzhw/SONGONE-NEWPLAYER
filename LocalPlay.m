//
//  LocalPlay.m
//  XFUpnpScan-xcode5
//
//  Created by mac on 14-10-16.
//  Copyright (c) 2014年 XF. All rights reserved.
//

#import "LocalPlay.h"

@implementation LocalPlay {

    dispatch_source_t waitingplay_dispatch_source;
    int repeattimes;
    NSInteger reltime;
    NSInteger tracktime;
    BOOL threadIsExit;
    BOOL threadIsActive;
    NSThread* playThread;
}

static LocalPlay* singleInstance;
//本地播放器相关的操作
- (id)init
{
    self = [super init];
    if (self) {
        self.playMode = NORMAL;
        self.avplayer = [[SOAVPlayer alloc] init];
        //self.vmplayer = [SOVMediaPlayer shareInstance];
        self.playList = [[PlayList alloc] initWidthMode:self.playMode];
        self.Player = self;
        //当播放的状态发生改变所相应的页面view播放状态也跟着改变
        [self.boxPlayerstate addObserver:APP forKeyPath:@"playstate" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
        self.positionInfo = [[PositionInfo alloc] init];
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
- (BOOL)setPlayAudioList:(NSArray*)audioQueu
{
    if (audioQueu.count > 0) {
        [self.playList setAudioList:audioQueu];
        return YES;
    } else {
        return NO;
    }
}

//为播放器添加地址
- (void)addToAVPlayer:(SOAudio*)audio
{
    if (self.playerType == AVPLAYER) {
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
- (BOOL)play
{
    SOAudio* currentAudio = self.playList.currentAudio;
    [self getplayerType:currentAudio];
    [self addToAVPlayer:currentAudio];
    if (self.playerType == AVPLAYER) {
        [self.avplayer play];
        [self waittingPlay];
    }
    /*else {
     dispatch_async(dispatch_get_global_queue(0, 0), ^{
     [self.vmplayer play];
     });
     }*/
    [self.boxPlayerstate setPlaystate:BOXPLAYERMODEPLAY];
    return YES;
}
//开始播放
- (BOOL)start
{
    if (self.playerType == AVPLAYER) {
        [self.avplayer play];
    }
    return YES;
}
//播放器暂停
- (BOOL)pause
{
    if (self.playerType == AVPLAYER) {
        [self.avplayer pause];
    }
    /*else {
     dispatch_async(dispatch_get_global_queue(0, 0), ^{
     [self.vmplayer pause];
     });
     }
     */
    [self.boxPlayerstate setPlaystate:BOXPLAYERMODEPAUSE];
    return YES;
}
//播放器停止
- (BOOL)stop
{
    if (self.playerType == AVPLAYER) {
        [self.avplayer stop];
    }
    /*else {
     dispatch_async(dispatch_get_global_queue(0, 0), ^{
     [self.vmplayer stop];
     });
     }*/
    [self.boxPlayerstate setPlaystate:BOXPLAYERMODESTOP];

    return YES;
}

//设置播放器音量
- (BOOL)setVolume:(float)volume
{
    if (self.playerType == AVPLAYER) {
        [self.avplayer setVolume:volume];
    }
    /*else {
     [self.vmplayer setVolume:volume];
     }*/
    return YES;
}
//获取播放器音量
- (float)volume
{
    if (self.playerType == AVPLAYER) {
        return [self.avplayer volume];
    }
    /*else {
     return [self.vmplayer volume];
     }*/
    return 0.0;
}

//设置拖拽进度条功能。
- (BOOL)setSeekTime:(float)seektimes
{
    if (self.playerType == AVPLAYER) {
        [self.avplayer setSeekTime:seektimes];
    }
    /*else {
     [self.vmplayer setSeekTime:seektimes];
     }*/
    return YES;
}

//获取播放器是否在播放
- (BOOL)isPlaying
{
    if (self.playerType == AVPLAYER) {
        return [self.avplayer isPlaying];
    }
    /*else {
     return [self.vmplayer isPlaying];
     }*/
    return NO;
}
//播放上一首
- (void)PlayPrevious
{
    self.playList.playMode = self.playMode;
    [self.playList OnPrevious];
}
//播放下一首
- (void)PlayNext
{
    self.playList.playMode = self.playMode;
    [self.playList OnNext];
}
//设置当前播放器的audio
- (BOOL)setPlayCurrentAudio:(SOAudio*)audio
{
    return [self.playList setPlayerCurrentAudio:audio];
}

//获取播放总长度
- (NSString*)avduration_times
{
    //if (self.playerType == 1) {
    tracktime = [self.avplayer avduration_times];
    return [CommonHelperManager makeDataToString:tracktime];
    //}
    /*else {
     return [self.vmplayer avduration_times];
     }*/
}
//获取当前播放长度
- (NSString*)vacurrent_times
{
    //if (self.playerType == 1) {
    reltime = [self.avplayer vacurrent_times];
    return [CommonHelperManager makeDataToString:reltime];
    //}
    /*else {
     return [self.vmplayer vacurrent_times];
     }*/
}
- (PositionInfo*)GetPosition
{
    [self.positionInfo createPosintionRelTime:[self vacurrent_times] TrackTime:[self avduration_times] TrackURI:@""];
    return self.positionInfo;
}

//设置播放器类型
- (void)getplayerType:(SOAudio*)audio
{
    NSString* songType = [CommonHelperManager PareURL:audio.play_uri];
    if ([songType isEqualToString:@""] || audio.audioType < 3) {
        self.playerType = AVPLAYER;
    } else {
        self.playerType = VMEDIAPLAYER;
    }
}

//关闭播放线程
- (void)endPlayThread
{
    threadIsExit = YES;
    [self stop];
}

//开启播放线程
- (void)startPlayThread
{
    threadIsActive = NO;
    threadIsExit = NO;
    playThread = [[NSThread alloc] initWithTarget:self selector:@selector(checkRemotPlay) object:nil];
    [playThread start];
}

- (void)checkRemotPlay
{
    while (YES) {
        if (threadIsExit) {
            [playThread cancel];
            threadIsActive = NO;
            if ([playThread isCancelled]) {
                playThread = nil;
                [NSThread exit];
            }
        }
        if (threadIsActive) {
            NSLog(@"starting...。。。。。。。。。。。。。");
            [self checkLocalIsNext];
        }
        usleep(1000);
    }
}
- (void)checkLocalIsNext
{
    //主要是针对本机播放时拖动滑动条出现的时间差，设置容错时间为三秒
    if (reltime > 0 && reltime >= tracktime) {
        threadIsActive = NO;
        [self PlayNext];
    }
}

//等待播放
- (void)waittingPlay
{
    __block int outtime = 10;
    repeattimes = 0;
    if (waitingplay_dispatch_source) {
        dispatch_source_cancel(waitingplay_dispatch_source);
        waitingplay_dispatch_source = nil;
    }
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    waitingplay_dispatch_source = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(waitingplay_dispatch_source,
                              dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC,
                              0); //每秒执行
    dispatch_source_set_event_handler(waitingplay_dispatch_source, ^{
        NSThread* currentthread = [NSThread currentThread];
        [currentthread setName:@"LocalPlayThread"];
        if (outtime <= 0) {
            [self.boxPlayerstate setPlaystate:BOXPLAYERMODEERROR];
            dispatch_source_cancel(waitingplay_dispatch_source);
        }
        outtime--;
        if ([self isPlaying]) {
            [self GetPosition];
            if (reltime!=tracktime && reltime>0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.boxPlayerstate setPlaystate:BOXPLAYERMODEPLAY];
                });
                dispatch_source_cancel(waitingplay_dispatch_source);
                threadIsActive = YES;
            }
        }
    });
    dispatch_resume(waitingplay_dispatch_source);
}

@end
