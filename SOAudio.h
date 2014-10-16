//
//  SOAudio.h
//  SongOne
//
//  Created by mac on 14-1-16.
//  Copyright (c) 2014年 xiaoran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MediaPlayer/MPMediaItem.h>
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVAssetExportSession.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <MobileCoreServices/UTType.h>
#import <AVFoundation/AVMetadataFormat.h>

// audioType :0为网络歌曲，1为ipod歌曲，2为Document目录下歌曲
typedef enum {
    NOTYPE = -1, //无类型
    IPODTYPE = 1, // IPOD类型
    DOCUMENTTYPE = 2, // Document目录下的歌曲类型，下载歌曲
    CHERRYTYPE = 3, //樱桃时光类型
    SHARECDTYPE = 4, //享CD类型
    SCHOOLERTYPE = 5, //状元听书
    FFMTYPE = 6, //电台类型
    SDCARDTYPE = 7 //SDCard类型
} AudioSourceType;

@interface SOAudio : NSObject

@property (nonatomic, copy) NSString* audioID;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, copy) NSString* artist;
@property (nonatomic, copy) NSString* actor;
@property (nonatomic, copy) NSString* album;

@property (nonatomic, copy) NSString* lyric; //歌词
@property (nonatomic, copy) NSString* play_uri;
@property (nonatomic, copy) NSString* album_id;
@property (nonatomic, copy) NSString* remote_play_uri;
@property (nonatomic, copy) NSString* album_art;
@property (nonatomic, copy) NSString* download_url;
@property (nonatomic, copy) NSString* style; //歌曲所属风格如：流行，摇滚。
@property (nonatomic, copy) NSString* audioDescription; //歌曲描述
@property (nonatomic, strong) NSString* coderate; //码率。
@property (nonatomic, copy) NSString* remark; //评论
@property (nonatomic, copy) NSString* audioImge; //歌曲图片。

@property (nonatomic, strong) MPMediaItem* mediaItem;
// audioType :0为网络歌曲，1为ipod歌曲，2为Document目录下歌曲
@property (nonatomic, assign) AudioSourceType audioType;
@property (nonatomic, copy) NSString* audiosize;
@property (nonatomic, copy) NSString* audioformat; //如 mp3,mp4. wav
@property (nonatomic, strong) NSData* albumImageData;
@property (nonatomic, assign) BOOL isIpodSource;
@property (nonatomic, copy) NSString* albumCover_url;
@property (nonatomic, strong) UIImage* albumCover; //  封面图片
@property (nonatomic, strong) UIImage* tmpimage;

@property (nonatomic, assign) BOOL isFavoritesFlag;
@property (nonatomic, assign) BOOL isScardAudio; // yes表示sd卡和u盘的数据
@property (nonatomic, assign) BOOL isCurrentPlayAudio; // yes 表示当前播放的歌曲
//涮新UI使用
@property (nonatomic, assign) BOOL isSelected;
//所属歌单的信息记录
@property (nonatomic, copy) NSString* musicMeauName;
@property (nonatomic, copy) NSString* musicMeauLogo;

//用存储到数据库的标识
@property (nonatomic, assign) NSInteger titleNameSection;
@property (nonatomic, assign) NSInteger artistSection;
@property (nonatomic, assign) NSInteger ablumSection;

@property (nonatomic, retain) NSString* targetPath;

- (id)initWithType:(NSInteger)audioTypes;
+ (id)audioFromMedieItem:(MPMediaItem*)item;
+ (NSArray*)audiosFromMedieItems:(NSArray*)items;

@end
