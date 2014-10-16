//
//  PlayAudio.h
//  XFUpnpScan-xcode5
//
//  Created by mac on 14-10-15.
//  Copyright (c) 2014年 XF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SOAudio.h"

@interface PlayAudio : NSObject
@property (strong,nonatomic) SOAudio *audio;
@property (assign,nonatomic) BOOL isplaying;

-(id)initWidthAudio:(SOAudio*)audio IsPlaying:(BOOL)isplaying;

@end
