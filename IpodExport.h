//
//  IpodExport.h
//  SongOne
//
//  Created by mac on 14-3-26.
//  Copyright (c) 2014年 xiaoran. All rights reserved.
//
#import "SOAudio.h"
#import <Availability.h>
@protocol ipodExportDelegate <NSObject>

- (void)senderAVTransportURI:(NSString*)url withAuido:(SOAudio*)audio;
@end

#import <Foundation/Foundation.h>

@interface IpodExport : NSObject
@property (nonatomic, weak) id<ipodExportDelegate> delete;
- (SOAudio*)getDownloadDocumentUrlWithAudio:(SOAudio*)audio;
- (void)convertURL:(SOAudio*)audio;
@end
