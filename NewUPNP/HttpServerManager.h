//
//  HttpServerManager.h
//  SongOne
//
//  Created by mac on 14-3-26.
//  Copyright (c) 2014年 xiaoran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpServer.h"
#import "GCDAsyncSocket.h"
#import "HTTPServer.h"
#import <UIKit/UIKit.h>

@interface HttpServerManager : NSObject
@property (strong, nonatomic) HTTPServer* httpServer;

- (void)initHttpServerPara;
- (void)endHttpServer;
@end
