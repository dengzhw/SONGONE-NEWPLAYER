//
//  RenderingControl.m
//  XFUpnpScan-xcode5
//
//  Created by mac on 14-10-15.
//  Copyright (c) 2014年 XF. All rights reserved.
//

#import "RenderingControl.h"
#import "upnpAction.h"
#import "UpnpHelper.h"
#import "SODefine.h"

@implementation RenderingControl {
    upnpAction* upnpaction;
    NSMutableURLRequest* httpRequest;
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
    upnpaction = [[upnpAction alloc] initWidthupnpAction:httpRequest ActionName:actionName ControlUrl:self.controlUrl ServiceType:SERVICE_TYPE2];
}

- (float)volume
{
    @synchronized(self)
    {
        [self newAction:@"GetVolume"];
        [upnpaction addParam:@"InstanceID" withValue:@"0"];
        [upnpaction addParam:@"Channel" withValue:@"Master"];
        [upnpaction invokeHttpRequest];
        NSMutableArray* volumeAction = upnpaction.ActionResult;
        BOOL volumeSuccess = [UpnpHelper ActionStatueIsSucessful:volumeAction];
        if (volumeSuccess) {
            NSDictionary* volumeDic = [volumeAction[1] valueForKeyPath:@"s:Body.u:GetVolumeResponse"];
            NSLog(@"%f", [volumeDic[@"CurrentVolume"] floatValue]);
            return [volumeDic[@"CurrentVolume"] floatValue];
        }
        return -1;
    }
}

- (BOOL)setVolume:(NSInteger)volume
{
    @synchronized(self)
    {
        [self newAction:@"SetVolume"];
        [upnpaction addParam:@"InstanceID" withValue:@"0"];
        [upnpaction addParam:@"Channel" withValue:@"Master"];
        [upnpaction addParam:@"DesiredVolume" withValue:[NSString stringWithFormat:@"%d", volume]];
        [upnpaction invokeHttpRequest];
        return [UpnpHelper ActionStatueIsSucessful:upnpaction.ActionResult];
    }
    return NO;
}

@end
