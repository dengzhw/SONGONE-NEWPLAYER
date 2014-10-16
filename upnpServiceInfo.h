//
//  upnpServiceInfo.h
//  SongOne
//
//  Created by mac on 14-10-11.
//  Copyright (c) 2014年 xiaoran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface upnpServiceInfo : NSObject

@property (strong, nonatomic) NSString* serviceType;
@property (strong, nonatomic) NSString* controlUrl;

- (id)initWithServiceType:(NSString*)serviceType andControlUrl:(NSString*)controlUrl;
@end
