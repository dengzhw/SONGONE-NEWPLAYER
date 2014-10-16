//
//  LocalIpodAudio.m
//  XFUpnpScan-xcode5
//
//  Created by mac on 14-10-16.
//  Copyright (c) 2014年 XF. All rights reserved.
//

#import "LocalIpodAudio.h"

@implementation LocalIpodAudio

#pragma-- mark obtain all aritist s audio group by artists
- (NSArray*)allIpodArtists
{
    MPMediaQuery* mediaQuery = [MPMediaQuery artistsQuery];
    NSArray* artists = [mediaQuery collections];
    return [SOArtist artistsWithMediaItems:artists];
}

- (NSArray*)allIpodAlbums
{
    MPMediaQuery* mediaQuery = [MPMediaQuery albumsQuery];

    NSMutableArray* albums = [[NSMutableArray alloc] init];
    for (MPMediaItemCollection* item in [mediaQuery collections]) {
        SOAlbum* album = [self albumFromMediaItem:[item representativeItem]];
        NSMutableArray* songs = [[NSMutableArray alloc] init];
        for (MPMediaItem* media in item.items) { // 这个歌手的所有歌曲
            SOAudio* song = [SOAudio audioFromMedieItem:media];
            if (song) {
                [songs addObject:song];
            }
        }
        album.albumAudiolist = songs;
        [albums addObject:album];
    }
    return albums;
}
- (SOAlbum*)albumFromMediaItem:(MPMediaItem*)item
{
    SOAlbum* album = [[SOAlbum alloc] init];
    album.albumID = [item valueForProperty:MPMediaItemPropertyAlbumPersistentID];
    album.albumTitle = [item valueForProperty:MPMediaItemPropertyAlbumTitle];
    return album;
}

- (NSArray*)getCollection
{
    MPMediaQuery* mediaquery = [MPMediaQuery songsQuery];
    NSArray* items = [mediaquery items];
    return [SOAudio audiosFromMedieItems:items];
}

+ (NSArray*)getAllCollection
{
    // NSArray *items = [[MPMediaQuery songsQuery] items];
    NSMutableArray* ipodArray = [NSMutableArray array];
    MPMediaQuery* everything = [[MPMediaQuery alloc] init];
    //得到MPMediaItem
    NSArray* itemsFromGenericQuery = [everything items];
    for (int i = 0; i < itemsFromGenericQuery.count; i++) {
        MPMediaItem* item = itemsFromGenericQuery[i];
        if ([[item valueForProperty:MPMediaItemPropertyMediaType] intValue] != MPMediaTypeMusic) {
            continue;
        }
        SOAudio* audio = [[SOAudio alloc] init];
        audio.title = [item valueForProperty:MPMediaItemPropertyTitle];
        audio.artist = [item valueForProperty:MPMediaItemPropertyArtist];
        audio.album = [item valueForProperty:MPMediaItemPropertyAlbumTitle];
        NSString* playurl =
            [[item valueForProperty:MPMediaItemPropertyAssetURL] absoluteString];
        audio.play_uri = playurl;
        audio.download_url = playurl;
        audio.remote_play_uri = playurl;
        audio.audioID = playurl;
        audio.isIpodSource = YES;
        audio.audioType = 1;
        audio.album_id =
            [item valueForProperty:MPMediaItemPropertyAlbumPersistentID];
        audio.album_art = [item valueForProperty:MPMediaItemPropertyAlbumArtist];
        CGSize size = CGSizeMake(60, 60);
        audio.albumCover =
            [[item valueForProperty:MPMediaItemPropertyArtwork] imageWithSize:size];
        audio.mediaItem = item;
        [ipodArray addObject:audio];
    }
    return ipodArray;
}

@end
