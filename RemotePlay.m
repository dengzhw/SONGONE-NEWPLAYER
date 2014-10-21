//
//  RemotePlay.m
//  SongOne
//
//  Created by mac on 14-10-10.
//  Copyright (c) 2014年 xiaoran. All rights reserved.
//

#import "RemotePlay.h"
#import "CommonHelperManager.h"

@implementation RemotePlay {
    PositionInfo* position;
    NSString* CurrentTransportState;
    dispatch_source_t waitingplay_dispatch_source;
    int repeattimes;
    NSInteger reltime;
    NSInteger tracktime;
    NSString* oldUri, *newUri;
    NSThread* playThread;
    SOAudio* currentAudio;
    dispatch_queue_t playQueue;
}

- (id)initWithRender:(DeviceRender*)render
{
    self = [super init];
    if (self) {
        self.render = render;
        [self setRenderService:SERVICE_TYPE1];
        [self setRenderService:SERVICE_TYPE2];
        self.playMode = NORMAL;
        self.playList = [[PlayList alloc] initWidthMode:self.playMode];
        self.Player = self;
        playQueue = GLOBALDISPATCHQUEUE;
        //当播放的状态发生改变所相应的页面view播放状态也跟着改变
//        [self.boxPlayerstate addObserver:APP forKeyPath:@"playstate" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
    }
    return self;
}
- (void)addKVOReg:(id)obj targetValue:(id)target
{
    [self.boxPlayerstate addObserver:obj forKeyPath:target options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
}

- (void)setRenderService:(NSString*)serviceType
{
    upnpServiceInfo* server = [self.render findServiceActionByServiceType:serviceType];
    if (server != nil) {
        if ([serviceType isEqualToString:SERVICE_TYPE1]) {
            NSString* urlBase = [self.render baseUrl];
            self.avTansport = [[AVTansport alloc] initAVTansportWithControlUrl:[NSString stringWithFormat:@"%@%@", urlBase, server.controlUrl]];

        } else {
            NSString* urlBase = [self.render baseUrl];
            self.renderindControl = [[RenderingControl alloc] initRenderControlWithControlUrl:[NSString stringWithFormat:@"%@%@", urlBase, server.controlUrl]];
        }
    }
}

//设置播放器播放列表
- (BOOL)setPlayAudioList:(NSArray*)audioQueu
{
    if (audioQueu.count > 0) {
        [self.playList setAudioList:audioQueu];
        return YES;
    } else {
        return NO;
    }
}
//IPod代理实现
- (void)senderAVTransportURI:(NSString*)url withAuido:(id)audio
{
    SOAudio* myaudio = (SOAudio*)audio;
    myaudio.play_uri = url;
    [self dispatchToPlay:myaudio];
}

//判断播放
- (void)dispatchToPlay:(SOAudio*)audio
{
    __block BOOL setAVTasportSuccess;
    __block BOOL playSuccess;
    dispatch_async(playQueue, ^{
        @autoreleasepool {
            setAVTasportSuccess = [self.avTansport setAVTransportURI:audio.play_uri];
            playSuccess = [self.avTansport playAsync];
        }
        if (setAVTasportSuccess && playSuccess) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.boxPlayerstate setPlaystate:BOXPLAYERMODEBEFORE];
            });

            [self waittingPlay];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.boxPlayerstate setPlaystate:BOXPLAYERMODEERROR];
            });
        }
    });
}

//播放
- (BOOL)play
{
    SOAudio* audio = self.playList.currentAudio;
    //ipod 音乐
    if (audio.audioType == IPODTYPE || audio.audioType == DOCUMENTTYPE) {
        IpodExport* ipodexport = [[IpodExport alloc] init];
        [ipodexport convertURL:audio];
        ipodexport.delete = self;
    } else {
        [self dispatchToPlay:audio];
    }
    return YES;
}

//暂停
- (BOOL)pause
{
    __block BOOL ispause;
    dispatch_async(playQueue, ^{
        ispause = [self.avTansport pause];
        if (ispause) {
            self.threadIsActive = NO;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.boxPlayerstate setPlaystate:BOXPLAYERMODEPAUSE];
            });
        }
    });
    return ispause;
}
//停止
- (BOOL)stop
{
    __block BOOL isstop;
    dispatch_async(playQueue, ^{
        isstop = [self.avTansport pause];
        if (isstop) {
            self.threadIsActive = NO;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.boxPlayerstate setPlaystate:BOXPLAYERMODESTOP];
            });

        }
    });
    return isstop;
}
//设置拖拽进度条功能。
- (BOOL)setSeekTime:(float)seektimes
{
    dispatch_async(playQueue, ^{
        [self.avTansport seek:(NSInteger)seektimes];
    });
    return YES;
}

//获取播放器音量
- (float)volume
{
    @synchronized(self)
    {
        NSLog(@"volume %f", [self.renderindControl volume] / 100.0);
        return [self.renderindControl volume] / 100.0;
    }
}
//设置播放器音量
- (BOOL)setVolume:(float)volume;
{
    @synchronized(self)
    {
        return [self.renderindControl setVolume:(NSInteger)(volume * 100)];
    }
}

//播放上一首歌曲

- (void)PlayPrevious
{
    self.playList.playMode = self.playMode;
    [self.playList OnPrevious];
    [self play];
}

//播放下一首歌曲

- (void)PlayNext
{
    self.playList.playMode = self.playMode;
    [self.playList OnNext];
    [self play];
}
//设置当前播放器的audio
- (BOOL)setPlayCurrentAudio:(SOAudio*)audio
{
    return [self.playList setPlayerCurrentAudio:audio];
}

//获取播放总长度
- (NSString*)avduration_times
{
    return self.positionInfo.tracktime;
}
//获取当前播放长度
- (NSString*)vacurrent_times
{
    return self.positionInfo.reltime;
}
//获取音箱播放地址信息
- (NSString*)getTrackURI
{
    return self.positionInfo.trackUri;
}
//获取播放Position
- (PositionInfo*)GetPosition
{
    @autoreleasepool
    {
        self.positionInfo = [self.avTansport getPositionInfo];
        reltime = [CommonHelperManager dateStringToInt:[self vacurrent_times]];
        tracktime = [CommonHelperManager dateStringToInt:[self avduration_times]];
        return self.positionInfo;
    }
}
//获取播放状态 : “STOPPED” “PLAYING” “TRANSITIONING” "NO_MEDIA_PRESENT”
- (NSString*)getTransportState
{
    return [self.avTansport getTransportInfo];
}
//获取播放器是否在播放
- (BOOL)isPlaying
{
    if ([self.boxPlayerstate.playstate isEqualToString:BOXPLAYERMODEPLAY]) {
        return YES;
    } else {
        return NO;
    }
}
//关闭播放线程
- (void)endPlayThread
{
    self.threadIsExit = YES;
    [self stop];
}

//开启播放线程
- (void)startPlayThread
{
    self.threadIsActive = NO;
    self.threadIsExit = NO;
    playThread = [[NSThread alloc] initWithTarget:self selector:@selector(checkRemotPlay) object:nil];
    [playThread start];
}

- (void)checkRemotPlay
{
    while (YES) {
        if (_threadIsExit) {
            [playThread cancel];
            _threadIsActive = NO;
            if ([playThread isCancelled]) {
                playThread = nil;
                [NSThread exit];
            }
        }
        if (_threadIsActive) {
            [self checkRemotIsNext];
        }
        usleep(1000);
    }
}
- (void)checkRemotIsNext
{
    [self GetPosition];
    //主要是针对本机播放时拖动滑动条出现的时间差，设置容错时间为三秒
    if (reltime > 0 && reltime >= tracktime) {
        self.threadIsActive = NO;
        [self PlayNext];
    }
    [self checkMusicReplace];
}
- (void)checkMusicReplace
{
    newUri = [self getTrackURI];
    if (oldUri != nil && newUri != nil && ![newUri isEqualToString:oldUri]) {
        if ([self isPlaying]) {
            self.threadIsActive = NO;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.boxPlayerstate setPlaystate:BOXPLAYERMODEREPLACE];
            });
        }
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
        [currentthread setName:@"dispatThread"];
        if (outtime <= 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.boxPlayerstate setPlaystate:BOXPLAYERMODEERROR];
            });
            dispatch_source_cancel(waitingplay_dispatch_source);
        }
        outtime--;
        NSString *renderstatus = [self getTransportState];
        NSLog(@"playing state %@",renderstatus);
        if ([renderstatus isEqualToString:@"PLAYING"]) {
            [self GetPosition];
            //防第一次出现时间不对
            repeattimes++;
            if (repeattimes<2) {
                return;
            }
            if (reltime!=tracktime && reltime>0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.boxPlayerstate setPlaystate:BOXPLAYERMODEPLAY];
                });
                dispatch_source_cancel(waitingplay_dispatch_source);
                oldUri = [self.positionInfo trackUri];
                newUri = oldUri;
                self.threadIsActive = YES;
            }
        }
    });
    dispatch_resume(waitingplay_dispatch_source);
}

@end
