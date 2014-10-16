//
//  upnpAction.h
//  SongOne
//
//  Created by mac on 14-10-10.
//  Copyright (c) 2014年 xiaoran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SOKVMode.h"

@class upnpAction;

@interface upnpAction : NSObject <NSURLConnectionDelegate>

@property (strong, nonatomic) NSMutableURLRequest* clientRequest;
@property (strong, nonatomic) NSString* actionName;
@property (strong, nonatomic) NSString* controlUrl;
@property (strong, nonatomic) NSString* serviceType;
@property (strong, nonatomic) NSMutableArray* ActionResult;

- (id)initWidthupnpAction:(NSMutableURLRequest*)httpClient ActionName:(NSString*)actionName ControlUrl:(NSString*)controlUrl ServiceType:(NSString*)serviceType;
- (void)addParam:(NSString*)key withValue:(NSString*)value;
- (void)invokeHttpRequest;

@end
