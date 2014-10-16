//
//  SOAudioPlayer.m
//  SongOne
//
//  Created by mac on 14-1-25.
//  Copyright (c) 2014年 xiaoran. All rights reserved.
//

#import "SOAudioPlayer.h"
#import <AudioToolbox/AudioToolbox.h>
#import <MediaPlayer/MPMusicPlayerController.h>
//#import "SOHeaderMacro.h"

@implementation SOAudioPlayer {
    UIBackgroundTaskIdentifier _oldTaskId;
    BOOL _isFirstPlay;
    BOOL _isPlaying;
    float _progress;
    float _downloadProgress;
}
@synthesize _avPlayer;

static SOAudioPlayer* singleInstance = nil;

- (void)audioSessionInit
{
    //[[AVAudioSession sharedInstance] setDelegate:(id)self];

    NSError* setCategoryError = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback
                                           error:&setCategoryError];
    if (setCategoryError)
        NSLog(@"setCategoryError");

    NSError* activationError = nil;
    //[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient
    //error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:&activationError];
    if (activationError)
        NSLog(@"activationError");

    //[[AVAudioSession sharedInstance] setDelegate:(AppDelegate*)APP];
}

- (void)monitorPlayerProgress
{
    //每隔一秒进行刷新。
    //    __weak typeof(AVPlayer*)weakplayer =_avPlayer;
    //    __block typeof(BOOL) isnext;
    [_avPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1, 1)
                                            queue:NULL
                                       usingBlock:^(CMTime time) {}];
}
- (void)backgroundPlaySupport
{
    UIBackgroundTaskIdentifier newTaskId = UIBackgroundTaskInvalid;
    newTaskId = [[UIApplication sharedApplication]
        beginBackgroundTaskWithExpirationHandler:NULL];
    if (newTaskId != UIBackgroundTaskInvalid && _oldTaskId != UIBackgroundTaskInvalid) {
        [[UIApplication sharedApplication] endBackgroundTask:_oldTaskId];
    }
    _oldTaskId = newTaskId;
}

- (void)initAVPlayerARG
{
    _isPlaying = NO;
    _progress = 0.0f;
    _downloadProgress = 0.0f;
    _avPlayer = [[AVPlayer alloc] initWithPlayerItem:nil];
}

- (void)audioPlayerInit
{
    [self initAVPlayerARG];
    [self audioSessionInit];
    //[self monitorPlayerProgress];
    //[self backgroundPlaySupport];
}

+ (SOAudioPlayer*)sharedAVPlayer
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

- (id)init
{
    self = [super init];
    if (self) {
        [self audioPlayerInit];
    }
    _avPlayer = [[AVPlayer alloc] init];
    //[self monitorPlayerProgress];
    return self;
}
//-(void)addPlayURL:(NSString *)url{
//    self.playURL=url;
//}
- (void)addPlayAudio:(SOAudio*)audio
{
    self.playAudio = audio;
}

- (void)goToPlay
{
    [_avPlayer pause];
    _isPlaying = YES;
    [_avPlayer play];
    //_avPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;

    //[[NSNotificationCenter defaultCenter]
    //postNotificationName:@"AudioPlayerStautsPlay" object:nil];
}

- (BOOL)isEnablePlaying
{
    int downloadPercent = (int)(self.downloadProgress * 100);
    int progressPercent = (int)(self.progress * 100);
    BOOL result = downloadPercent > (progressPercent + 1);
    NSLog(@"down = %d , progress = %d, result = %d", downloadPercent,
          progressPercent, result);
    return result;
}
- (float)progress
{
    if (_avPlayer.currentItem.status == AVPlayerItemStatusReadyToPlay) {
        Float64 currentTime = CMTimeGetSeconds(_avPlayer.currentTime);
        Float64 durationTime = CMTimeGetSeconds(_avPlayer.currentItem.asset.duration);
        _progress = (float)(currentTime / durationTime);
        return _progress;
    } else {
        return 0.0f;
    }
}

- (void)setProgress:(float)progress
{
    if (_avPlayer.currentItem.status == AVPlayerItemStatusReadyToPlay) {
        NSArray* loadedTimeRanges = _avPlayer.currentItem.loadedTimeRanges;
        if (loadedTimeRanges != nil && [loadedTimeRanges count] > 0) {
            CMTimeRange timeRange =
                [[loadedTimeRanges objectAtIndex:0] CMTimeRangeValue];
            Float64 startTime = CMTimeGetSeconds(timeRange.start);
            Float64 currentTime = CMTimeGetSeconds(timeRange.duration);
            Float64 downloadedTime = startTime + currentTime - 5;
            Float64 durationTime = CMTimeGetSeconds(_avPlayer.currentItem.asset.duration);
            Float64 dragTime = progress * durationTime - 5;
            _progress = progress;

            if ((int)dragTime >= (int)downloadedTime) {
                dragTime = downloadedTime;
                _progress = dragTime / durationTime;
            }
            NSLog(@"currentTime = %f , dragTime = %f", downloadedTime, dragTime);
            CMTime time = CMTimeMakeWithSeconds(dragTime, 1);
            [_avPlayer seekToTime:time];
        }
    }
}

- (float)downloadProgress
{
    if (_avPlayer.currentItem.status == AVPlayerItemStatusReadyToPlay) {
        NSArray* loadedTimeRanges = _avPlayer.currentItem.loadedTimeRanges;
        if (loadedTimeRanges != nil && [loadedTimeRanges count] > 0) {
            CMTimeRange timeRange =
                [[loadedTimeRanges objectAtIndex:0] CMTimeRangeValue];
            Float64 startTime = CMTimeGetSeconds(timeRange.start);
            Float64 currentTime = CMTimeGetSeconds(timeRange.duration);
            Float64 durationTime = CMTimeGetSeconds(_avPlayer.currentItem.asset.duration);
            _downloadProgress = (float)((currentTime + startTime) / durationTime);
        }
        return _downloadProgress;
    } else {
        return 0.0f;
    }
}

- (void)play
{
    NSString* url = self.playAudio.play_uri;
    if (url != nil && url.length > 0 && ![url isEqualToString:@"NULL"]) {
        NSURL* murl;
        if (self.playAudio.audioType == 2) {
            murl = [NSURL fileURLWithPath:url];
        } else {
            murl = [NSURL URLWithString:url];
        }
        //        NSString *musicPath = [[NSBundle mainBundle]
        //        pathForResource:@"aaaa" ofType:@"mp3"];
        //
        //        murl = [NSURL fileURLWithPath:musicPath];

        dispatch_async(dispatch_get_main_queue(), ^{
        AVPlayerItem *avitem = [AVPlayerItem playerItemWithURL:murl];
        //            [_avPlayer replaceCurrentItemWithPlayerItem:avitem];
        _avPlayer = [AVPlayer playerWithPlayerItem:avitem];
        [self goToPlay];
        });
    }
}
- (void)changeMusic:(AVPlayerItem*)item
{
    //[_avPlayer replaceCurrentItemWithPlayerItem:item];
    _avPlayer = [AVPlayer playerWithPlayerItem:item];
    [self goToPlay];
}
- (void)bufferingNextChangeMusic
{
    [self pause];
}

- (void)pause
{
    _isPlaying = NO;

    //[NSObject cancelPreviousPerformRequestsWithTarget:self
    //selector:@selector(changeMusic:) object:nil];
    //[NSObject cancelPreviousPerformRequestsWithTarget:self
    //selector:@selector(bufferingNextChangeMusic) object:nil];
    [_avPlayer pause];
    //[[NSNotificationCenter defaultCenter]
    //postNotificationName:@"AudioPlayerStautsPause" object:nil];
}
- (void)stop
{
    _isPlaying = NO;
    [_avPlayer pause];
    _avPlayer.rate = 0;
}
- (void)changeToPreAVMedie:(AVPlayerItem*)item
{
    //[_avPlayer replaceCurrentItemWithPlayerItem:item];
    _avPlayer = [AVPlayer playerWithPlayerItem:item];

    [self goToPlay];
}

- (void)prepareCheckPlayURL
{
    NSString* url = self.playAudio.play_uri;
    if (url != nil && url.length > 0 && ![url isEqualToString:@"NULL"]) {
        NSURL* murl =
            [NSURL URLWithString:[url stringByReplacingPercentEscapesUsingEncoding:
                                          NSUTF8StringEncoding]];
        AVPlayerItem* avitem = [AVPlayerItem playerItemWithURL:murl];
        [self performSelector:@selector(changeToPreAVMedie:)
                   withObject:avitem
                   afterDelay:1.0f];
    }
}
- (void)prev
{
    [self pause];
    [self prepareCheckPlayURL];
    [[NSNotificationCenter defaultCenter]
        postNotificationName:@"AudioPlayerStautsPrevMusic"
                      object:nil];
}
- (void)next
{
    [self pause];
    [self prepareCheckPlayURL];
    [[NSNotificationCenter defaultCenter]
        postNotificationName:@"AudioPlayerStautsNextMusic"
                      object:nil];
}

- (AVPlayerStatus)status
{
    return _avPlayer.status;
}

- (float)volume
{
    return [MPMusicPlayerController applicationMusicPlayer].volume;
}

- (void)setVolume:(float)volume
{
    [MPMusicPlayerController applicationMusicPlayer].volume = volume;
}
- (NSString*)currentTime
{
    if (_avPlayer.currentItem.status == AVPlayerItemStatusReadyToPlay) {
        Float64 currentTime = CMTimeGetSeconds(_avPlayer.currentTime);
        NSString* currentTimeStr =
            [NSString stringWithFormat:@"%d:%0.2d", (int)currentTime / 60,
                                       (int)currentTime % 60];
        return currentTimeStr;
    } else {
        return [NSString stringWithFormat:@"%d:%0.2d", 0, 0];
    }
}

- (NSString*)leftTime
{
    if (_avPlayer.currentItem.status == AVPlayerItemStatusReadyToPlay) {
        Float64 currentTime = CMTimeGetSeconds(_avPlayer.currentTime);
        Float64 durationTime = CMTimeGetSeconds(_avPlayer.currentItem.asset.duration);
        Float64 leftTime = durationTime - currentTime;

        NSString* leftTimeStr =
            [NSString stringWithFormat:@"%d:%0.2d", (int)(leftTime) / 60,
                                       (int)(leftTime) % 60];
        return leftTimeStr;
    } else {
        return [NSString stringWithFormat:@"%d:%0.2d", 0, 0];
    }
}

- (NSString*)durationTime
{
    if (_avPlayer.currentItem.status == AVPlayerItemStatusReadyToPlay) {
        Float64 durationTime = CMTimeGetSeconds(_avPlayer.currentItem.asset.duration);

        NSString* durationTimeStr =
            [NSString stringWithFormat:@"%d:%0.2d", (int)(durationTime) / 60,
                                       (int)(durationTime) % 60];
        return durationTimeStr;
    } else {
        return [NSString stringWithFormat:@"%d:%0.2d", 0, 0];
    }
}

- (void)setSeekTime:(float)seektimes
{
    // CMTime dragedCMTime = CMTimeMake(seektimes, 1);
    seektimes = round(seektimes);
    CMTime dragedCMTime = CMTimeMakeWithSeconds(seektimes, 1.0);
    [_avPlayer seekToTime:dragedCMTime
        completionHandler:^(BOOL finished) { [_avPlayer play]; }];
}

- (NSInteger)currentSeconds
{
    if (_avPlayer.currentItem.status == AVPlayerItemStatusReadyToPlay) {
        Float64 currentTime = CMTimeGetSeconds(_avPlayer.currentTime);
        Float64 durationTime = CMTimeGetSeconds(_avPlayer.currentItem.asset.duration);
        return (NSInteger)(currentTime > durationTime ? durationTime : currentTime);
    } else {
        return 0;
    }
}

- (NSInteger)leftSeconds
{
    if (_avPlayer.currentItem.status == AVPlayerItemStatusReadyToPlay) {
        Float64 currentTime = CMTimeGetSeconds(_avPlayer.currentTime);
        Float64 durationTime = CMTimeGetSeconds(_avPlayer.currentItem.asset.duration);
        Float64 leftTime = durationTime - currentTime;

        return (NSInteger)leftTime;
    } else {
        return 0;
    }
}

- (NSInteger)durationSeconds
{
    if (_avPlayer.currentItem.status == AVPlayerItemStatusReadyToPlay) {
        Float64 durationTime = CMTimeGetSeconds(_avPlayer.currentItem.asset.duration);
        return (NSInteger)durationTime;
    } else {
        return 0;
    }
}

- (BOOL)isPlaying
{
    //NSLog(@"rate %f", _avPlayer.rate);
    if (_avPlayer.currentItem && _avPlayer.rate != 0) {
        return YES;
    }
    return NO;
}

@end
