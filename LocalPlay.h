//
//  LocalPlay.h
//  XFUpnpScan-xcode5
//
//  Created by mac on 14-10-16.
//  Copyright (c) 2014年 XF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SOAVPlayer.h"
#import "PlayList.h"
#import "CommonHelperManager.h"
#import "SOVMediaPlayer.h"

@interface LocalPlay : NSObject
@property (strong, nonatomic) SOAVPlayer* avplayer;
@property (strong, nonatomic) SOVMediaPlayer* vmplayer;
@property (strong, nonatomic) PlayList* playList;
@property (assign, nonatomic) NSInteger playerType; //1为avplayer 2:vmediaplayer

@end
