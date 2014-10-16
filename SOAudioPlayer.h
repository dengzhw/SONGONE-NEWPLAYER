//
//  SOAudioPlayer.h
//  SongOne
//
//  Created by mac on 14-1-25.
//  Copyright (c) 2014年 xiaoran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "SOAudio.h"

@interface SOAudioPlayer : NSObject

@property (readonly) NSString* currentTime; // 当前播放时间 例  0:12
@property (readonly) NSString* leftTime; // 剩余播放时间 例  1:12
@property (readonly) NSString* durationTime; // 音乐总时长   例  3:12

@property (readonly) NSInteger currentSeconds; // 当前播放秒数   例  12
@property (readonly) NSInteger leftSeconds; // 剩余播放秒数   例  72
@property (readonly) NSInteger durationSeconds; // 音乐时长总秒数  例  192

@property (nonatomic, assign) float progress; // 播放进度     例 0.87777
@property (readonly) float downloadProgress; // 下载进度     例 0.88888

@property (nonatomic, readonly) AVPlayerStatus status; // 播放器状态

@property (nonatomic, assign) float volume; // 音量调节

@property (readonly) UIActivityIndicatorView* activityView; // 网络请求指示标

@property (nonatomic, strong) AVPlayer* _avPlayer;
@property (nonatomic, strong) AVPlayerItem* avitem;
@property (nonatomic, strong) SOAudio* playAudio;

- (void)play; // 播放
//-(void)playLoactionDocumentFileAudio;  //在本机播放ducment目录下的文件
- (void)pause; // 暂停
- (void)stop; //停止

//-(void)prev;     // 上一首
//-(void)next;     // 下一首
//-(void)addPlayURL:(NSString *)url;
- (void)addPlayAudio:(SOAudio*)audio;
- (BOOL)isPlaying;
- (void)setSeekTime:(float)seektimes;
+ (SOAudioPlayer*)sharedAVPlayer;

@end
