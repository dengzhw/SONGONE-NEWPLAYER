//
//  AudioList.m
//  SongOne
//
//  Created by mac on 14-10-11.
//  Copyright (c) 2014年 xiaoran. All rights reserved.
//

#import "PlayList.h"
#import "SODefine.h"

@implementation PlayList {
    NSInteger tempIndex;
}

- (id)initWidthMode:(NSInteger)mode
{
    self = [super init];
    if (self) {
        self.currentAudio = [[SOAudio alloc] init];
        //self.currentAudio.play_uri = @"http://qzone.haoduoge.com/music/C49CFN5RPXA4899AD79ADBB0B4714AA4529FC.mp3";
        //self.currentAudio.play_uri = @"http://cherrytime.oss-cn-hangzhou.aliyuncs.com/cherrytime乐库/上下班/打鸡血/独立摇滚%20要的就是个态度/01%20-%20万能青年旅店%20-%20乌云典当记.mp3?Expires=1414282665&OSSAccessKeyId=ndm6c0zcwyz1x6n5hqe66rig&Signature=ffcCuC6dT8yIqvpwbzMY0xFcBDk%3D";
        self.playMode = mode;
    }
    return self;
}
- (BOOL)setAudioList:(NSArray*)audioList
{
    if (audioList.count > 0) {
        self.audioQueu = [[NSMutableArray alloc] initWithArray:audioList];
        return YES;
    } else {
        self.audioQueu = nil;
        return NO;
    }
}
- (BOOL)setPlayerCurrentAudio:(SOAudio*)audio
{
    self.currentAudio = audio;
    return [self findIndexByAudio:self.currentAudio];
}

- (BOOL)findIndexByAudio:(SOAudio*)audio
{
    NSInteger count = 0;
    for (SOAudio* audios in self.audioQueu) {
        if ([audios.title isEqualToString:audio.title] &&
            [audios.play_uri isEqualToString:audio.play_uri]) {
            self.currentIndex = count;
            return YES;
        }
        count++;
    }
    return NO;
}
- (void)OnPrevious
{
    if (self.audioQueu == nil || self.audioQueu.count <= 0) {
        return;
    }
    if (self.currentIndex > 0) {
        switch (self.playMode) {
        case NORMAL:
            self.currentIndex = self.currentIndex - 1;
            break;
        case REPEAT_ALL:
            self.currentIndex = self.currentIndex - 1;
            break;
        case REPEAT_ONE:
            self.currentIndex = self.currentIndex - 1;
            break;
        case RANDOM:
            tempIndex = arc4random() % self.audioQueu.count;
            if (self.currentIndex == tempIndex) {
                if (tempIndex > 0 && tempIndex < self.audioQueu.count - 1 && self.audioQueu.count > 2) {
                    self.currentIndex = self.currentIndex + 1;
                } else {
                    self.currentIndex = 1;
                }
            } else {
                self.currentIndex = tempIndex;
            }
            break;
        default:
            break;
        }
    } else {
        self.currentIndex = self.audioQueu.count - 1;
    }
    self.audioQueu = [self.audioQueu objectAtIndex:self.currentIndex];
}
- (void)OnNext
{
    if (self.audioQueu == nil || self.audioQueu.count <= 0) {
        return;
    }
    if (self.currentIndex < self.audioQueu.count - 1) {

        switch (self.playMode) {
        case NORMAL:
            self.currentIndex = self.currentIndex + 1;
            break;
        case REPEAT_ALL:
            self.currentIndex = self.currentIndex + 1;
            break;
        case REPEAT_ONE:
            self.currentIndex = self.currentIndex + 1;
            break;
        case RANDOM:
            tempIndex = arc4random() % self.audioQueu.count;
            [self randomIndex:tempIndex];
            break;
        default:
            break;
        }
    } else {
        self.currentIndex = 0;
    }
    self.currentAudio = [self.audioQueu objectAtIndex:self.currentIndex];
}

- (void)randomIndex:(NSInteger)Index
{
    if (self.currentIndex == Index) {
        if (Index > 0 && Index < self.audioQueu.count - 1 && self.audioQueu.count > 2) {
            self.currentIndex++;
        } else {
            self.currentIndex = 0;
        }
    } else {
        self.currentIndex = Index;
    }
}

@end
