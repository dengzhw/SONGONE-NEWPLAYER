//
//  AVTansport.h
//  SongOne
//
//  Created by mac on 14-10-10.
//  Copyright (c) 2014年 xiaoran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PositionInfo.h"

@interface AVTansport : NSObject
@property (strong, nonatomic) NSString* controlUrl;
- (id)initAVTansportWithControlUrl:(NSString*)controlUrl;

- (BOOL)playAsync;
- (BOOL)pause;
- (BOOL)seek:(NSInteger)pos;
- (NSString*)getTransportInfo;
- (BOOL)setAVTransportURI:(NSString*)uri;
- (PositionInfo*)getPositionInfo;
- (BOOL)stop;

@end
