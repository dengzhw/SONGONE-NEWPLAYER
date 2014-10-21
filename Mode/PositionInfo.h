//
//  PositionInfo.h
//  SongOne
//
//  Created by mac on 14-10-10.
//  Copyright (c) 2014年 xiaoran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PositionInfo : NSObject
@property (strong, nonatomic) NSString* reltime;
@property (strong, nonatomic) NSString* tracktime;
@property (strong, nonatomic) NSString* trackUri;

- (void)createPosintionRelTime:(NSString*)reltime TrackTime:(NSString*)tracktime TrackURI:(NSString*)trackUri;
@end
