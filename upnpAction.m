//
//  upnpAction.m
//  SongOne
//
//  Created by mac on 14-10-10.
//  Copyright (c) 2014年 xiaoran. All rights reserved.
// httpSoap协议

#import "upnpAction.h"
#import "XMLDictionary.h"
#import "UpnpHelper.h"
#import "SODefine.h"

@implementation upnpAction {
    NSMutableArray* paraArray;
    NSMutableString* resultstr;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.ActionResult = [[NSMutableArray alloc] init];
        paraArray = [[NSMutableArray alloc] init];
        resultstr = [[NSMutableString alloc] init];
    }
    return self;
}
- (void)createUpnpActionName:(NSString*)actionName ControlUrl:(NSString*)controlUrl ServiceType:(NSString*)serviceType
{
    self.actionName = actionName;
    self.controlUrl = controlUrl;
    self.serviceType = serviceType;
}
- (NSString*)getHeader
{
    NSString* str;
    str = [NSString stringWithFormat:@"\"%@%@%@\"", self.serviceType, @"#", self.actionName];
    //NSLog(@"str%@", str);
    // NSDictionary* headerdic = @{ @"SOAPACTION " : str };
    return str;
}

- (void)addParam:(NSString*)key withValue:(NSString*)value
{
    SOKVMode* kvmode = [[SOKVMode alloc] initKey:key widthValue:value];
    [paraArray addObject:kvmode];
}
- (void)cleanResultAction
{
    if (self.ActionResult.count > 0) {
        [self.ActionResult removeAllObjects];
    }
    if (paraArray.count > 0) {
        [paraArray removeAllObjects];
    }
}
- (NSString*)getParamsStr
{
    [resultstr setString:@""];
    for (SOKVMode* kvmode in paraArray) {
        NSString* str = [NSString stringWithFormat:@"<%@>%@</%@>\n", kvmode.key, kvmode.value, kvmode.key];
        [resultstr appendString:str];
    }
    return resultstr;
}

- (NSString*)getBody
{
    NSString* bodystr;
    bodystr = [NSString stringWithFormat:@"<?xml version=\"1.0\"?>\n<s:Envelope\n xmlns:s=\"http://schemas.xmlsoap.org/soap/envelope/\" s:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\">\n<s:Body>\n<u:%@ xmlns:u=\"%@\">\n%@</u:%@>\n</s:Body>\n</s:Envelope>",
                                         self.actionName, self.serviceType, [self getParamsStr], self.actionName];
    //NSLog(@"bodystr%@", bodystr);
    return bodystr;
}
- (void)invokeHttpRequest
{
    int ret = -1;
    NSString* xmlstr;
    NSString* targetxmlstr;
    NSString* msgLength = [NSString stringWithFormat:@"%ud", [[self getBody] length]];
    //为请求添加属性 构建html post
    self.clientRequest = nil;
    self.clientRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.controlUrl] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.0];
    [self.clientRequest addValue:[self getHeader] forHTTPHeaderField:@"SOAPACTION"];
    [self.clientRequest addValue:msgLength forHTTPHeaderField:@"CONTENT-LENGTH"];
    [self.clientRequest setValue:@"text/xml; charset=\"utf-8\"" forHTTPHeaderField:@"CONTENT-TYPE"];
    //发送同步请求
    [self.clientRequest setHTTPMethod:@"POST"];
    [self.clientRequest setHTTPBody:[[self getBody] dataUsingEncoding:NSUTF8StringEncoding]];
    NSError* error = nil;
    //    NSURLResponse* response = nil;
    NSHTTPURLResponse* response = nil;
    NSData* responseData = nil;
    responseData = [NSURLConnection sendSynchronousRequest:self.clientRequest returningResponse:&response error:&error];
    if (responseData == nil) {
        NSLog(@"send request failed:%@", error);
    } else {
        //NSLog(@"response %@", response);
        if ([response statusCode] != 200) {
            ret = 0 - [response statusCode];
            NSString* rsp = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
            NSLog(@"rsp %@", rsp);
        } else {
            ret = 0;
        }
        if (ret == 0 && [responseData length] > 0) {
            xmlstr = [[NSString alloc] initWithBytes:[responseData bytes] length:[responseData length] encoding:NSUTF8StringEncoding];
            targetxmlstr = (NSString*)[UpnpHelper stringEscapeXml:xmlstr];
            [self.ActionResult addObject:@{ STATUSCODE : [NSString stringWithFormat:@"%d", [response statusCode]] }];
            [self.ActionResult addObject:[NSDictionary dictionaryWithXMLString:targetxmlstr]];
        }
    }
}

@end
