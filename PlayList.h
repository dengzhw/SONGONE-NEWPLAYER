//
//  AudioList.h
//  SongOne
//
//  Created by mac on 14-10-11.
//  Copyright (c) 2014年 xiaoran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SOAudio.h"

@interface PlayList : NSObject
@property (strong, nonatomic) NSMutableArray* audioQueu;
@property (strong, nonatomic) SOAudio* currentAudio;
@property (assign, nonatomic) NSInteger currentIndex;
@property (assign, nonatomic) NSInteger playMode;

- (id)initWidthMode:(NSInteger)mode;
- (void)OnPrevious;
- (void)OnNext;
- (BOOL)setAudioList:(NSArray*)audioList;
- (BOOL)setPlayerCurrentAudio:(SOAudio*)audio;
@end
