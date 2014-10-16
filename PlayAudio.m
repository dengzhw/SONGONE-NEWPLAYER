//
//  PlayAudio.m
//  XFUpnpScan-xcode5
//
//  Created by mac on 14-10-15.
//  Copyright (c) 2014年 XF. All rights reserved.
//

#import "PlayAudio.h"

@implementation PlayAudio
- (id)initWidthAudio:(SOAudio*)audio IsPlaying:(BOOL)isplaying
{
    self = [super init];
    if (self) {
        self.audio = audio;
        self.isplaying = isplaying;
    }
    return self;
}
@end
