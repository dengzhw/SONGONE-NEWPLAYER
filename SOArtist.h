//
//  SOArtist.h
//  SongOne
//
//  Created by mac on 14-1-17.
//  Copyright (c) 2014年 xiaoran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "SOAudio.h"

@interface SOArtist : NSObject
@property(strong, nonatomic) NSString *aristID;
@property(strong, nonatomic) NSString *aristName;
@property(strong, nonatomic) NSString *aristDescription;
//歌手的专辑数量
@property(copy, nonatomic) NSString *albumCount;
//歌手的歌曲数量
@property(copy, nonatomic) NSString *audioCount;
//歌手的图片
@property(strong, nonatomic) NSString *aristCover;
//歌手的图片
@property(strong, nonatomic) UIImage *headphoto;

@property(strong, nonatomic) NSString *desc;
//歌曲列表
@property(strong, nonatomic) NSArray *artistAudioList;

//专辑列表
@property(strong, nonatomic) NSArray *aristAlbumList;
//专辑列表请求地址
@property(strong, nonatomic) NSString *aristAlbumUrl;

+ (id)artistWithMediaItem:(MPMediaItem *)item;
+ (NSArray *)artistsWithMediaItems:(NSArray *)items;

@end
