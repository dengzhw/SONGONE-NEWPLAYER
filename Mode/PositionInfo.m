//
//  PositionInfo.m
//  SongOne
//
//  Created by mac on 14-10-10.
//  Copyright (c) 2014年 xiaoran. All rights reserved.
//

#import "PositionInfo.h"

@implementation PositionInfo

- (id)init
{
    self = [super init];
    if (self) {
        self.reltime = @"";
        self.tracktime = @"";
        self.trackUri = @"";
    }
    return self;
}
- (void)createPosintionRelTime:(NSString*)reltime TrackTime:(NSString*)tracktime TrackURI:(NSString*)trackUri
{
    self.reltime = reltime;
    self.tracktime = tracktime;
    self.trackUri = trackUri;
}

@end
