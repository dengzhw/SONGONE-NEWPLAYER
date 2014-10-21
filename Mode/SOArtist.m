//
//  SOArtist.m
//  SongOne
//
//  Created by mac on 14-1-17.
//  Copyright (c) 2014年 xiaoran. All rights reserved.
//

#import "SOArtist.h"

@implementation SOArtist

+ (id)artistWithMediaItem:(MPMediaItem *)item {

  SOArtist *artist = [[SOArtist alloc] init];
  artist.aristID =
      [item valueForProperty:MPMediaItemPropertyArtistPersistentID];
  artist.aristName = [item valueForProperty:MPMediaItemPropertyArtist];

  MPMediaItemArtwork *image =
      [item valueForProperty:MPMediaItemPropertyArtwork];
  artist.headphoto = [image imageWithSize:CGSizeMake(80, 80)];

  return artist;
}

+ (NSArray *)artistsWithMediaItems:(NSArray *)items {

  NSMutableArray *artists = [[NSMutableArray alloc] init];
  for (MPMediaItemCollection *item in items) {
    SOArtist *artist = [SOArtist artistWithMediaItem:[item representativeItem]];
    NSMutableArray *songs = [[NSMutableArray alloc] init];
    for (MPMediaItem *media in item.items) { // 这个歌手的所有歌曲
      SOAudio *song = [SOAudio audioFromMedieItem:media];
      if (song) {
        [songs addObject:song];
      }
    }
    artist.artistAudioList = songs;
    [artists addObject:artist];
  }
  return artists;
}

@end
