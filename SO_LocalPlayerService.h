//
//  SO_LocalPlayerService.h
//  NewUPNP
//
//  Created by mac on 14-10-21.
//  Copyright (c) 2014年 deng.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SO_Player.h"
#import "CommonHelperManager.h"
#import "SOAudio.h"

@interface SO_LocalPlayerService : NSObject
@property (strong, nonatomic) id<Player> currentPlayer;

/*+ (SO_LocalPlayerService*)shareInstance;
- (void)switchCurrentPlayer:(id)player;
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
//获取播放总长度
- (NSString*)avduration_times;
//获取当前播放长度
- (NSString*)vacurrent_times;
*/
@end
