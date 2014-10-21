//
//  SOKVMode.h
//  XFUpnpScan-xcode5
//
//  Created by mac on 14-10-14.
//  Copyright (c) 2014年 XF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SOKVMode : NSObject
@property (strong, nonatomic) NSString* key;
@property (strong, nonatomic) NSString* value;
- (id)initKey:(NSString*)key widthValue:(NSString*)value;
@end
