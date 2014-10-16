//
//  ServiceContent.m
//  XFUpnpScan-xcode5
//
//  Created by mac on 14-10-15.
//  Copyright (c) 2014年 XF. All rights reserved.
//

#import "ServiceContent.h"
#import "upnpAction.h"
#import "UpnpHelper.h"
#import "SODefine.h"

@implementation ServiceContent {
    NSMutableURLRequest* httpRequest;
    upnpAction* upnpaction;
}

- (id)initRenderControlWithControlUrl:(NSString*)controlUrl
{
    self = [super init];
    if (self) {
        self.controlUrl = controlUrl;
        //[self httpRequst];
    }
    return self;
}
- (void)httpRequst
{
    httpRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.controlUrl] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.0];
}

- (void)newAction:(NSString*)actionName
{

    [self httpRequst];
    upnpaction = [[upnpAction alloc] initWidthupnpAction:httpRequest ActionName:actionName ControlUrl:self.controlUrl ServiceType:SERVICE_TYPE3];
}

- (NSArray*)browseDirectChildren:(NSString*)aObjectId requestedCount:(NSUInteger)count requestedStartIndex:(NSUInteger)startIndex
{
    NSString* requestcount = [NSString stringWithFormat:@"%tu", count];
    NSString* requeststartIndex = [NSString stringWithFormat:@"%tu", startIndex];
    [self newAction:@"Browse"];
    [upnpaction addParam:@"ObjectID" withValue:aObjectId];
    [upnpaction addParam:@"BrowseFlag" withValue:@"BrowseDirectChildren"];
    [upnpaction addParam:@"Filter" withValue:@"*"];
    [upnpaction addParam:@"StartingIndex" withValue:requeststartIndex];
    [upnpaction addParam:@"RequestedCount" withValue:requestcount];
    [upnpaction addParam:@"SortCriteria" withValue:@""];
    [upnpaction invokeHttpRequest];
    NSMutableArray* browseDic = upnpaction.ActionResult;
    BOOL browseisSucessful = [UpnpHelper ActionStatueIsSucessful:browseDic];
    if (browseisSucessful) {
        NSLog(@"%@", browseDic);
    }
    return nil;
}

@end
