//
//  SOVMediaPlayer.h
//  SongOne
//
//  Created by mac on 14-9-19.
//  Copyright (c) 2014年 xiaoran. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "ProtocolManager.h"
#import "VMediaPlayer.h"
#import "SOAudio.h"

@interface SOVMediaPlayer : NSObject <VMediaPlayerDelegate>
@property (strong, nonatomic) VMediaPlayer* vmediaplayer;
//@property (strong, nonatomic) id<SO_BoxPlayerDelegate> delegate;

- (void)addToVMediaPlayer:(SOAudio*)audio;
//- (void)initCurrentPlayer:(id)player;
- (void)play;
- (void)pause;
- (void)stop; //停止
- (void)reset;

- (NSInteger)avduration_times;
- (NSInteger)vacurrent_times;
- (void)setVolume:(float)volume;
- (float)volume;
- (void)setSeekTime:(float)seektimes;
- (BOOL)isPlaying;
+ (SOVMediaPlayer*)shareInstance;

@end
