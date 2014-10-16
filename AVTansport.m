//
//  AVTansport.m
//  SongOne
//
//  Created by mac on 14-10-10.
//  Copyright (c) 2014年 xiaoran. All rights reserved.
//

#import "AVTansport.h"
#import "upnpAction.h"
#import "UpnpHelper.h"
#import "SODefine.h"

@implementation AVTansport {
    NSMutableURLRequest* httpRequest;
    upnpAction* upnpaction;
    PositionInfo* position;
    NSString* CurrentTransportState;
}
- (id)initAVTansportWithControlUrl:(NSString*)controlUrl
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
    upnpaction = [[upnpAction alloc] initWidthupnpAction:httpRequest ActionName:actionName ControlUrl:self.controlUrl ServiceType:SERVICE_TYPE1];
}

- (PositionInfo*)getPositionInfo
{
    @synchronized(self)
    {
        [self newAction:@"GetPositionInfo"];
        [upnpaction invokeHttpRequest];
        NSMutableArray* positionAction = upnpaction.ActionResult;
        BOOL positionSuccess = [UpnpHelper ActionStatueIsSucessful:positionAction];
        if (positionSuccess) {
            NSDictionary* positionDic = [positionAction[1] valueForKeyPath:@"s:Body.u:GetPositionInfoResponse"];
            position = [[PositionInfo alloc] initPositionInfo:[positionDic valueForKey:@"RelTime"] TrackTime:[positionDic valueForKey:@"TrackDuration"] TrackURI:[positionDic valueForKey:@"TrackURI"]];
            return position;
        }
        return position;
    }
}

- (BOOL)setAVTransportURI:(NSString*)uri
{
    @synchronized(self)
    {
        [self newAction:@"SetAVTransportURI"];
        [upnpaction addParam:@"InstanceID" withValue:@"0"];
        NSMutableString* murl = [[NSMutableString alloc] initWithString:uri];
        [upnpaction addParam:@"CurrentURI" withValue:[UpnpHelper xmlSimpleEscape:murl]];
        [upnpaction addParam:@"CurrentURIMetaData" withValue:@""];
        [upnpaction invokeHttpRequest];
        return [UpnpHelper ActionStatueIsSucessful:upnpaction.ActionResult];
    }
}

- (NSMutableArray*)getTransportInfo
{
    @synchronized(self)
    {
        [self newAction:@"GetTransportInfo"];
        [upnpaction invokeHttpRequest];
        return upnpaction.ActionResult;
    }
}

- (BOOL)playAsync
{
    @synchronized(self)
    {
        [self newAction:@"Play"];
        [upnpaction addParam:@"InstanceID" withValue:@"0"];
        [upnpaction addParam:@"Speed" withValue:@"1"];
        [upnpaction invokeHttpRequest];
        return [UpnpHelper ActionStatueIsSucessful:upnpaction.ActionResult];
    }
}

- (BOOL)pause
{
    @synchronized(self)
    {
        [self newAction:@"Pause"];
        [upnpaction invokeHttpRequest];
        return [UpnpHelper ActionStatueIsSucessful:upnpaction.ActionResult];
    }
}

- (BOOL)seek:(NSInteger)pos
{
    @synchronized(self)
    {
        [self newAction:@"Seek"];
        [upnpaction addParam:@"Target" withValue:[UpnpHelper makeDataToString:pos]];
        [upnpaction addParam:@"Unit" withValue:@"REL_TIME"];
        [upnpaction invokeHttpRequest];
        return [UpnpHelper ActionStatueIsSucessful:upnpaction.ActionResult];
    }
}

@end
