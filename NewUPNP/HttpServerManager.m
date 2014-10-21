//
//  HttpServerManager.m
//  SongOne
//
//  Created by mac on 14-3-26.
//  Copyright (c) 2014年 xiaoran. All rights reserved.
//

#import "HttpServerManager.h"

@interface HTTPServer (enableBackgroundingOnSocket)
- (void)enableBackgroundingOnSocket;
@end

@implementation HTTPServer (enableBackgroundingOnSocket)
- (void)enableBackgroundingOnSocket {
  [asyncSocket performBlock:^{ [asyncSocket enableBackgroundingOnSocket]; }];
}
@end

@implementation HttpServerManager

- (void)initHttpServerPara {
  self.httpServer = [[HTTPServer alloc] init];
  [self.httpServer setType:@"_http._tcp."];
  [self.httpServer setPort:999];
  [self.httpServer enableBackgroundingOnSocket];

  NSString *path = [NSSearchPathForDirectoriesInDomains(
      NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
  [self.httpServer setDocumentRoot:path];
  [self startHttpServer];
}
- (void)startHttpServer {
  [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
  // start
  NSError *error;
  if ([self.httpServer start:&error]) {
    NSLog(@"Started HTTP Server on port %hu", [self.httpServer listeningPort]);
  } else {
    NSLog(@"Error starting HTTP Server: %@", error);
  }
}

- (void)endHttpServer {
  [self.httpServer stop];
}

@end
