//
//  PositionInfo.m
//  SongOne
//
//  Created by mac on 14-10-10.
//  Copyright (c) 2014年 xiaoran. All rights reserved.
//

#import "PositionInfo.h"

@implementation PositionInfo

-(id) initPositionInfo:(NSString*)reltime TrackTime:(NSString*)tracktime TrackURI:(NSString*)trackUri{
    self.reltime = reltime;
    self.tracktime = tracktime;
    self.trackUri =trackUri;
    return self;
}

@end
