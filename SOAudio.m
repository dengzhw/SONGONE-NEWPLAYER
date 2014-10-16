//
//  SOAudio.m
//  SongOne
//
//  Created by mac on 14-1-16.
//  Copyright (c) 2014年 xiaoran. All rights reserved.
//

#import "SOAudio.h"

@implementation SOAudio

@synthesize album;
@synthesize album_art;
@synthesize album_id;
@synthesize artist;
@synthesize audioType;
@synthesize play_uri;
@synthesize download_url;
@synthesize remote_play_uri;
@synthesize title;
@synthesize audioformat;
@synthesize mediaItem;

- (id)initWithType:(NSInteger)audioTypes
{
    self = [super init];
    if (self) {
        switch (audioTypes) {
        case 0:
            self.audioType = 0; // local
            ;
            break;
        case 1:
            self.audioType = 1; // migu
            break;
        case 2:
            self.audioType = 2; // device
            break;
        default:
            break;
        }
    }
    return self;
}

+ (id)audioFromMedieItem:(MPMediaItem*)item
{
    if ([[item valueForProperty:MPMediaItemPropertyMediaType] intValue] != MPMediaTypeMusic) {
        return nil;
    }

    SOAudio* audio = [[SOAudio alloc] initWithType:0];
    audio.title = [item valueForProperty:MPMediaItemPropertyTitle];
    audio.artist = [item valueForProperty:MPMediaItemPropertyArtist];
    audio.album = [item valueForProperty:MPMediaItemPropertyAlbumTitle];
    NSString* playurl =
        [[item valueForProperty:MPMediaItemPropertyAssetURL] absoluteString];
    //    NSLog(@"scheme:%@", [[item
    //    valueForProperty:MPMediaItemPropertyAssetURL]scheme]); //协议 http
    //    NSLog(@"host:%@", [[item valueForProperty:MPMediaItemPropertyAssetURL]
    //    host]);     //域名 www.baidu.com
    //    NSLog(@"===>%@",[[item valueForProperty:MPMediaItemPropertyAssetURL]
    //    relativePath]);
    audio.play_uri = playurl;
    audio.isIpodSource = YES;
    audio.audioType = 1;
    audio.album_id = [item valueForProperty:MPMediaItemPropertyAlbumPersistentID];
    audio.album_art = [item valueForProperty:MPMediaItemPropertyAlbumArtist];
    CGSize size = CGSizeMake(60, 60);
    audio.albumCover =
        [[item valueForProperty:MPMediaItemPropertyArtwork] imageWithSize:size];
    audio.mediaItem = item;

    return audio;
}

+ (NSArray*)audiosFromMedieItems:(NSArray*)items
{

    NSMutableArray* audios = [[NSMutableArray alloc] init];
    for (MPMediaItem* item in items) {
        SOAudio* audio = [SOAudio audioFromMedieItem:item];
        if (audio) {
            [audios addObject:audio];
        }
    }

    return audios;
}


// Media properties
MP_EXTERN NSString* const MPMediaItemPropertyPersistentID; // @"persistentID",
// NSNumber of
// int64_t (long
// long), filterable
MP_EXTERN NSString* const MPMediaItemPropertyMediaType; // @"mediaType",
// NSNumber of
// MPMediaType
// (NSInteger),
// filterable
MP_EXTERN NSString* const
MPMediaItemPropertyTitle; // @"title",               NSString, filterable
MP_EXTERN NSString* const
MPMediaItemPropertyAlbumTitle; // @"albumTitle",          NSString, filterable
MP_EXTERN NSString* const MPMediaItemPropertyAlbumPersistentID
NS_AVAILABLE_IOS(4_2);
// @"albumPID",            NSNumber of int64_t (long long), filterable
MP_EXTERN NSString* const
MPMediaItemPropertyArtist; // @"artist",              NSString, filterable
MP_EXTERN NSString* const MPMediaItemPropertyArtistPersistentID
NS_AVAILABLE_IOS(4_2);
// @"artistPID",           NSNumber of int64_t (long long), filterable
MP_EXTERN NSString* const
MPMediaItemPropertyAlbumArtist; // @"albumArtist",         NSString, filterable
MP_EXTERN NSString* const MPMediaItemPropertyAlbumArtistPersistentID
NS_AVAILABLE_IOS(4_2);
// @"albumArtistPID",      NSNumber of int64_t (long long), filterable
MP_EXTERN NSString* const
MPMediaItemPropertyGenre; // @"genre",               NSString, filterable
MP_EXTERN NSString* const MPMediaItemPropertyGenrePersistentID
NS_AVAILABLE_IOS(4_2);
// @"genrePID",            NSNumber of int64_t (long long), filterable
MP_EXTERN NSString* const
MPMediaItemPropertyComposer; // @"composer",            NSString, filterable
MP_EXTERN NSString* const MPMediaItemPropertyComposerPersistentID
NS_AVAILABLE_IOS(4_2);
// @"composerPID",         NSNumber of int64_t (long long), filterable
MP_EXTERN NSString* const
MPMediaItemPropertyPlaybackDuration; // @"playbackDuration",    NSNumber of
// NSTimeInterval (double)
MP_EXTERN NSString* const
MPMediaItemPropertyAlbumTrackNumber; // @"albumTrackNumber",    NSNumber of
// NSUInteger
MP_EXTERN NSString* const
MPMediaItemPropertyAlbumTrackCount; // @"albumTrackCount",     NSNumber of
// NSUInteger
MP_EXTERN NSString* const
MPMediaItemPropertyDiscNumber; // @"discNumber",          NSNumber of NSUInteger
MP_EXTERN NSString* const
MPMediaItemPropertyDiscCount; // @"discCount",           NSNumber of NSUInteger
MP_EXTERN NSString* const
MPMediaItemPropertyArtwork; // @"artwork",             MPMediaItemArtwork
MP_EXTERN NSString* const MPMediaItemPropertyLyrics; // @"lyrics", NSString
MP_EXTERN NSString* const MPMediaItemPropertyIsCompilation; // @"isCompilation",
// NSNumber of BOOL,
// filterable
MP_EXTERN NSString* const MPMediaItemPropertyReleaseDate NS_AVAILABLE_IOS(4_0);
// @"releaseDate",         NSDate
MP_EXTERN NSString* const MPMediaItemPropertyBeatsPerMinute
NS_AVAILABLE_IOS(4_0);
// @"beatsPerMinute",      NSNumber of NSUInteger
MP_EXTERN NSString* const MPMediaItemPropertyComments NS_AVAILABLE_IOS(4_0);
// @"comments",            NSString
MP_EXTERN NSString* const MPMediaItemPropertyAssetURL NS_AVAILABLE_IOS(4_0);
// @"assetURL",            NSURL
MP_EXTERN NSString* const MPMediaItemPropertyIsCloudItem NS_AVAILABLE_IOS(6_0);
// @"isCloudItem",         NSNumber of BOOL, filterable

// Podcast properties
MP_EXTERN NSString* const
MPMediaItemPropertyPodcastTitle; // @"podcastTitle",        NSString, filterable
MP_EXTERN NSString* const MPMediaItemPropertyPodcastPersistentID
NS_AVAILABLE_IOS(4_2);
// @"podcastPID",          NSNumber of int64_t (long long), filterable

// User properties
MP_EXTERN NSString* const MPMediaItemPropertyPlayCount; // @"playCount",
// NSNumber of
// NSUInteger filterable
MP_EXTERN NSString* const
MPMediaItemPropertySkipCount; // @"skipCount",           NSNumber of NSUInteger
MP_EXTERN NSString* const MPMediaItemPropertyRating; // @"rating",
// NSNumber of NSUInteger,
// 0...5
MP_EXTERN NSString* const
MPMediaItemPropertyLastPlayedDate; // @"lastPlayedDate",      NSDate
MP_EXTERN NSString* const MPMediaItemPropertyUserGrouping NS_AVAILABLE_IOS(4_0);
// @"userGrouping",        NSString
MP_EXTERN NSString* const MPMediaItemPropertyBookmarkTime NS_AVAILABLE_IOS(6_0);
// @"bookmarkTime",        NSNumber of NSTimeInterval (double)

@end
