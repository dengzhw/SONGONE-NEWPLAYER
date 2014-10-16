//
//  RemotePlay.m
//  SongOne
//
//  Created by mac on 14-10-10.
//  Copyright (c) 2014年 xiaoran. All rights reserved.
//

#import "RemotePlay.h"
#import "SODefine.h"

@implementation RemotePlay {
    PositionInfo* position;
    NSString* CurrentTransportState;
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
    }
    return self;
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

//播放
- (BOOL)play
{
    SOAudio* audio = self.playList.currentAudio;
    BOOL setAVTasportSuccess = [self.avTansport setAVTransportURI:audio.play_uri];
    BOOL playSuccess = [self.avTansport playAsync];
    if (setAVTasportSuccess && playSuccess) {
        return YES;
    }
    return NO;
}
//暂停
- (BOOL)pause
{
    return [self.avTansport pause];
}

//获取播放Position
- (PositionInfo*)GetPosition
{
    return [self.avTansport getPositionInfo];
}
//获取播放状态 : “STOPPED” “PLAYING” “TRANSITIONING” "NO_MEDIA_PRESENT”
- (NSString*)getTransportState
{
    return [self.avTansport getTransportInfo];
}

//播放上一首歌曲

- (void)PlayPrevious
{
    self.playList.playMode = self.playMode;
    [self.playList OnPrevious];
}

//播放下一首歌曲

- (void)PlayNext
{
    self.playList.playMode = self.playMode;
    [self.playList OnNext];
}

//获取播放器音量
- (float)VolumeInfo
{
    NSLog(@"volume %f", [self.renderindControl volume] / 100.0);
    return [self.renderindControl volume] / 100.0;
}
//设置播放器音量
- (BOOL)setVolume:(float)volume
{
    return [self.renderindControl setVolume:(NSInteger)(volume * 100)];
}

@end
