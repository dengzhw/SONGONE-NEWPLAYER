//
//  SOAlbum.h
//  SongOne
//
//  Created by mac on 14-1-17.
//  Copyright (c) 2014年 xiaoran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SOAlbum : NSObject

//专辑的id
@property (strong, nonatomic) NSString* albumID;
//专辑名称
@property (strong, nonatomic) NSString* albumTitle;
//专辑的封面
@property (strong, nonatomic) NSString* albumCover;
//专辑的封面
@property (strong, nonatomic) UIImage* albumImage;
//专辑iocn
@property (strong, nonatomic) NSString* albumIcon;
//艺人的名称
@property (strong, nonatomic) NSString* albumArtist;
//艺人的图片
@property (copy, nonatomic) NSString* aristCover;
//歌的数量
@property (copy, nonatomic) NSString* albumNumbers;
//专辑分享数
@property (copy, nonatomic) NSString* shareCount;
//专辑赞的次数
@property (copy, nonatomic) NSString* likeCount;
//收听次数
@property (copy, nonatomic) NSString* lisenCount;
//专辑所属类型
@property (strong, nonatomic) NSString* typeName;
//专辑详情
@property (strong, nonatomic) NSString* introduction;
//是否当前的播放专辑
@property (assign, nonatomic) BOOL isCurrentPlaying;
//专辑评论
@property (strong, nonatomic) NSString* albumRemark;
//歌曲的列表
@property (nonatomic, strong) NSArray* albumAudiolist;
//歌曲的列表请求地址
@property (nonatomic, strong) NSString* albumAudioUrl;
//专辑发行时间
@property (nonatomic, copy) NSString* albumPublishDate;
@end
