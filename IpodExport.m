//
//  IpodExport.m
//  SongOne
//
//  Created by mac on 14-3-26.
//  Copyright (c) 2014年 xiaoran. All rights reserved.
//

#import "IpodExport.h"
#include <ifaddrs.h>
#include <sys/socket.h>
#include <arpa/inet.h>

@implementation IpodExport
- (BOOL)deletefile
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];

    NSArray* contents =
        [fileManager contentsOfDirectoryAtPath:documentsDirectory error:NULL];
    NSEnumerator* e = [contents objectEnumerator];
    NSString* filename;
    while ((filename = [e nextObject])) {
        NSArray* filearry = [filename componentsSeparatedByString:@"."];
        if ([filearry[0] isEqualToString:@"exportout"]) {
            [fileManager removeItemAtPath:[documentsDirectory
                                              stringByAppendingPathComponent:filename]
                                    error:NULL];
        }
    }
    return YES;
}
- (NSString*)setExportType:(NSString*)fileType
    withAVAssetExportSession:(AVAssetExportSession*) export
{

    if ([fileType isEqualToString:@"wav"] || [fileType isEqualToString:@"wave"]) {
        export.outputFileType = @"com.microsoft.waveform-audio";
    } else if ([fileType isEqualToString:@"mp3"]) {
        fileType = @"mov";
        export.outputFileType = @"com.apple.quicktime-movie";
    } else if ([fileType isEqualToString:@"m4a"]) {
        export.outputFileType = @"com.apple.m4a-audio";
    } else if ([fileType isEqualToString:@"mp4"]) {
        export.outputFileType = @"public.mpeg-4";
    } else if ([fileType isEqualToString:@"aifc"] ||
               [fileType isEqualToString:@"cdda"]) {
        export.outputFileType = @"public.aifc-audio";
    } else if ([fileType isEqualToString:@"aiff"]) {
        export.outputFileType = @"public.aiff-audio";
    } else if ([fileType isEqualToString:@"amr"]) {
        export.outputFileType = @"org.3gpp.adaptive-multi-rate-audio";
    } else {
        fileType = @"caf";
        export.outputFileType = @"com.apple.coreaudio-format";
    }
    return fileType;
}
//没有用到的方法
- (void)obtainIpodMPMedioitem
{
    MPMediaQuery* everything = [[MPMediaQuery alloc] init];
    NSLog(@"Logging items from a generic query...");
    //得到MPMediaItem
    NSArray* itemsFromGenericQuery = [everything items];
    for (MPMediaItem* song in itemsFromGenericQuery) {
        NSString* songTitle = [song valueForProperty:MPMediaItemPropertyTitle];
        NSLog(@"%@", songTitle);
    }
}

- (void)convertURL:(SOAudio*)audio
{

    MPMediaItem* mediaItem = audio.mediaItem;
    NSLog(@"type:%@", [mediaItem valueForProperty:MPMediaItemPropertyMediaType]);
    // convert MPMediaItem to AVURLAsset.
    AVURLAsset* sset;
    if (audio.audioType == 1 || audio.isIpodSource) {
        // [self obtainIpodMPMedioitem];
        if (mediaItem) {
            sset = [AVURLAsset
                assetWithURL:[mediaItem
                                 valueForProperty:MPMediaItemPropertyAssetURL]];
        } else {
            sset = [AVURLAsset assetWithURL:[NSURL URLWithString:audio.play_uri]];
        }
    }
    // get the extension of the file.
    NSString* fileType =
        [[[[sset.URL absoluteString] componentsSeparatedByString:@"?"]
            objectAtIndex:0] pathExtension];

    // init export, here you must set "presentName" argument to
    // "AVAssetExportPresetPassthrough". If not, you will can't export mp3
    // correct.
    AVAssetExportSession* export = [[AVAssetExportSession alloc]
        initWithAsset:sset
           presetName:AVAssetExportPresetPassthrough];
    // export to mov format.
    fileType = [self setExportType:fileType withAVAssetExportSession:export];
    export.shouldOptimizeForNetworkUse = YES;
    //    //export extension
    //    NSString *extension = (__bridge_transfer NSString
    //    *)UTTypeCopyPreferredTagWithClass((__bridge
    //    CFStringRef)export.outputFileType, kUTTagClassFilenameExtension);
    NSString* ip = [self getIPAddress];
    NSString* path = [NSHomeDirectory()
        stringByAppendingFormat:@"/Documents/exportout.%@", fileType];
    NSURL* outputURL = [NSURL fileURLWithPath:path];
    export.outputURL = outputURL;
    //    NSFileManager * fm = [NSFileManager defaultManager];
    [self deletefile];
    //    NSArray  *arry = [fm directoryContentsAtPath:[NSHomeDirectory()
    //    stringByAppendingString:@"/Documents"]];
    //    NSLog(@"%@",arry);
    [export exportAsynchronouslyWithCompletionHandler:^{
      NSString *url;
      if (export.status == AVAssetExportSessionStatusCompleted) {
        // then rename mov format to the original format.
        NSFileManager *filemanager = [NSFileManager defaultManager];
        //            NSError *error = nil;
        //            NSArray *ary=[filemanager
        //            directoryContentsAtPath:[NSHomeDirectory()
        //            stringByAppendingString:@"/Documents"]];
        //            NSLog(@"arrya %@",ary);
        if ([fileType isEqualToString:@"mov"]) {
          NSString *path = [NSHomeDirectory()
              stringByAppendingFormat:@"/Documents/exportout.%@", @"mov"];
          NSString *mp3Path = [NSHomeDirectory()
              stringByAppendingFormat:@"/Documents/exportout.%@", @"mp3"];
          NSError *error = nil;
          [filemanager moveItemAtPath:path toPath:mp3Path error:&error];
          url = [NSString stringWithFormat:@"http://%@:%@/exportout.%@", ip,
                                           @"999", @"mp3"];
        } else {
          url = [NSString stringWithFormat:@"http://%@:%@/exportout.%@", ip,
                                           @"999", fileType];
        }
        [self.delete senderAVTransportURI:url withAuido:audio];
        //            NSLog(@"error %@",error);
      } else {
        NSLog(@"%@", export.error);
      }
    }];
}
- (SOAudio*)getDownloadDocumentUrlWithAudio:(SOAudio*)audio
{
    NSString* lastConent = [audio.play_uri lastPathComponent];
    NSString* url =
        [NSString stringWithFormat:@"http://%@:%@/downloads/%@",
                                   [self getIPAddress], @"999", lastConent];
    audio.remote_play_uri = url;
    return audio;
}
// getIPAddress+999+a.mp3;
- (NSString*)getIPAddress
{
    NSString* address = @"error";
    struct ifaddrs* interfaces = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        struct ifaddrs* temp_addr = NULL;
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if (temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name]
                        isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString
                        stringWithUTF8String:inet_ntoa(((struct sockaddr_in*)
                                                        temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}
@end
