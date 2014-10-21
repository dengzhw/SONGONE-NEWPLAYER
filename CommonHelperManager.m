//
//  CommonHelper.m

#import "CommonHelperManager.h"
#import "SOAudio.h"
#import <CommonCrypto/CommonDigest.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <arpa/inet.h>

@implementation CommonHelperManager

+ (NSString*)md5StringForData:(NSData*)data
{
    // const char *str = [string UTF8String];
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(data.bytes, data.length, r);
    return [NSString
        stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10],
            r[11], r[12], r[13], r[14], r[15]];
}
+ (NSString*)md5StringForString:(NSString*)str
{
    const char* str1 = [str UTF8String];
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str1, strlen(str1), r);
    return [NSString
        stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10],
            r[11], r[12], r[13], r[14], r[15]];
}

+ (NSString*)getFileSizeString:(NSString*)size
{
    if ([size floatValue] >= 1024 * 1024) //大于1M，则转化成M单位的字符串
    {
        return
            [NSString stringWithFormat:@"%1.2fM", [size floatValue] / 1024 / 1024];
    } else if ([size floatValue] >= 1024 &&
               [size floatValue] < 1024 * 1024) //不到1M,但是超过了1KB，则转化成KB单位
    {
        return [NSString stringWithFormat:@"%1.2fK", [size floatValue] / 1024];
    } else //剩下的都是小于1K的，则转化成B单位
    {
        return [NSString stringWithFormat:@"%1.2fB", [size floatValue]];
    }
}

+ (float)getFileSizeNumber:(NSString*)size
{
    NSInteger indexM = [size rangeOfString:@"M"].location;
    NSInteger indexK = [size rangeOfString:@"K"].location;
    NSInteger indexB = [size rangeOfString:@"B"].location;
    if (indexM < 1000) //是M单位的字符串
    {
        return [[size substringToIndex:indexM] floatValue] * 1024 * 1024;
    } else if (indexK < 1000) //是K单位的字符串
    {
        return [[size substringToIndex:indexK] floatValue] * 1024;
    } else if (indexB < 1000) //是B单位的字符串
    {
        return [[size substringToIndex:indexB] floatValue];
    } else //没有任何单位的数字字符串
    {
        return [size floatValue];
    }
}

+ (NSString*)getDocumentPath
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}
+ (NSString*)getTargetPathWithBasepath:(NSString*)name
                               subpath:(NSString*)subpath
{
    NSString* pathstr = [[self class] getDocumentPath];
    pathstr = [pathstr stringByAppendingPathComponent:name];
    pathstr = [pathstr stringByAppendingPathComponent:subpath];
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSError* error;
    if (![fileManager fileExistsAtPath:pathstr]) {
        [fileManager createDirectoryAtPath:pathstr
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:&error];
        if (!error) {
            NSLog(@"%@", [error description]);
        }
    }

    return pathstr;
}
+ (NSArray*)getTargetFloderPathWithBasepath:(NSString*)name
                                 subpatharr:(NSArray*)arr
{
    NSMutableArray* patharr = [[NSMutableArray alloc] init];
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSError* error;
    NSString* pathstr = [[self class] getDocumentPath];
    pathstr = [pathstr stringByAppendingPathComponent:name];
    for (NSString* str in arr) {
        NSString* path = [pathstr stringByAppendingPathComponent:str];

        if (![fileManager fileExistsAtPath:path]) {
            [fileManager createDirectoryAtPath:path
                   withIntermediateDirectories:YES
                                    attributes:nil
                                         error:&error];
            if (!error) {
                NSLog(@"%@", [error description]);
            }
        }
        [patharr addObject:path];
    }

    return patharr;
}

+ (NSMutableArray*)getAllFinishFilesListWithPatharr:(NSArray*)patharr
{

    NSMutableArray* finishlist = [[NSMutableArray alloc] init];
    for (NSString* pathstr in patharr) {
        NSFileManager* fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:pathstr]) {
            break;
        }
        NSError* error;
        NSArray* filelist =
            [fileManager contentsOfDirectoryAtPath:pathstr error:&error];
        if (!error) {
            NSLog(@"%@", [error description]);
        }
        if (filelist == nil) {
            break;
        }
        for (NSString* fileName in filelist) {
            SOAudio* finishedFile = [[SOAudio alloc] init];
            finishedFile.title = fileName;
            finishedFile.targetPath =
                [pathstr stringByAppendingPathComponent:fileName];
            //根据文件名获取文件的大小
            NSInteger length =
                [[fileManager contentsAtPath:finishedFile.targetPath] length];
            finishedFile.audiosize = [CommonHelperManager
                getFileSizeString:[NSString stringWithFormat:@"%d", length]];
            [finishlist addObject:finishedFile];
        }
    }
    return finishlist;
}

+ (NSString*)getTempFolderPathWithBasepath:(NSString*)name
{
    NSString* pathstr = [[self class] getDocumentPath];
    pathstr = [pathstr stringByAppendingPathComponent:name];
    pathstr = [pathstr stringByAppendingPathComponent:@"Temp"];
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSError* error;
    if (![fileManager fileExistsAtPath:pathstr]) {
        [fileManager createDirectoryAtPath:pathstr
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:&error];
        if (!error) {
            NSLog(@"%@", [error description]);
        }
    }
    return pathstr;
}

+ (BOOL)isExistFile:(NSString*)fileName
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:fileName];
}

+ (float)getProgress:(float)totalSize currentSize:(float)currentSize
{
    return currentSize / totalSize;
}
+ (NSDate*)makeDate:(NSString*)birthday
{
    NSDateFormatter* df = [[NSDateFormatter alloc] init];

    [df setDateFormat:@"MM-dd HH:mm:ss"]; //[df setDateFormat:@"yyyy-MM-dd
    //HH:mm:ss"];

    //    NSLocale *locale=[[NSLocale alloc] initWithLocaleIdentifier:@"en-US"];
    //    [df setLocale:locale];

    NSDate* date = [df dateFromString:birthday];
    NSLog(@"%@", date);
    return date;
}
+ (NSString*)dateToString:(NSDate*)date
{
    NSDateFormatter* df = [[NSDateFormatter alloc] init];

    [df setDateFormat:@"MM-dd HH:mm:ss"]; //[df setDateFormat:@"yyyy-MM-dd
    //HH:mm:ss"];
    NSString* datestr = [df stringFromDate:date];
    return datestr;
}
+ (uint64_t)getFreeDiskspace
{
    uint64_t totalSpace = 0.0f;
    uint64_t totalFreeSpace = 0.0f;
    NSError* error = nil;
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSDictionary* dictionary = [[NSFileManager defaultManager]
        attributesOfFileSystemForPath:[paths lastObject]
                                error:&error];

    if (dictionary) {
        NSNumber* fileSystemSizeInBytes =
            [dictionary objectForKey:NSFileSystemSize];
        NSNumber* freeFileSystemSizeInBytes =
            [dictionary objectForKey:NSFileSystemFreeSize];
        totalSpace = [fileSystemSizeInBytes floatValue];
        totalFreeSpace = [freeFileSystemSizeInBytes floatValue];
        NSLog(@"Memory Capacity of %llu MiB with %llu MiB Free memory available.",
              ((totalSpace / 1024ll) / 1024ll),
              ((totalFreeSpace / 1024ll) / 1024ll));
    } else {
        NSLog(@"Error Obtaining System Memory Info: Domain = %@, Code = %d",
              [error domain], [error code]);
    }

    return totalFreeSpace;
}
+ (uint64_t)getTotalDiskspace
{
    uint64_t totalSpace = 0.0f;
    NSError* error = nil;
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSDictionary* dictionary = [[NSFileManager defaultManager]
        attributesOfFileSystemForPath:[paths lastObject]
                                error:&error];

    if (dictionary) {
        NSNumber* fileSystemSizeInBytes =
            [dictionary objectForKey:NSFileSystemSize];
        totalSpace = [fileSystemSizeInBytes floatValue];
    } else {
        NSLog(@"Error Obtaining System Memory Info: Domain = %@, Code = %ld",
              [error domain], (long)[error code]);
    }

    return totalSpace;
}
+ (NSString*)getDiskSpaceInfo
{
    uint64_t totalSpace = 0.0f;
    uint64_t totalFreeSpace = 0.0f;
    NSError* error = nil;
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSDictionary* dictionary = [[NSFileManager defaultManager]
        attributesOfFileSystemForPath:[paths lastObject]
                                error:&error];

    if (dictionary) {
        NSNumber* fileSystemSizeInBytes =
            [dictionary objectForKey:NSFileSystemSize];
        NSNumber* freeFileSystemSizeInBytes =
            [dictionary objectForKey:NSFileSystemFreeSize];
        totalSpace = [fileSystemSizeInBytes floatValue];
        totalFreeSpace = [freeFileSystemSizeInBytes floatValue];
    } else
        return nil;

    NSString* infostr = [NSString
        stringWithFormat:@"%.2f GB 可用/总共 %.2f GB",
                         ((totalFreeSpace / 1024.0f) / 1024.0f) / 1024.0f,
                         ((totalSpace / 1024.0f) / 1024.0f) / 1024.0f];
    return infostr;
}

+ (NSString*)makeDataToString:(NSInteger)date
{
    NSString* datestr;
    // NSLog(@"%d",(int)(date/3600.0));
    if (((int)(date / 3600.0)) == 0) {
        datestr = [NSString stringWithFormat:@"%02d:%02d",
                                             (int)(fmod(date, 3600.0) / 60.0),
                                             (int)fmod(date, 60.0)];
    } else {
        datestr =
            [NSString stringWithFormat:@"%02d:%02d:%02d", (int)(date / 3600.0),
                                       (int)(fmod(date, 3600.0) / 60.0),
                                       (int)fmod(date, 60.0)];
    }
    return datestr;
}
+ (NSInteger)dateStringToInt:(NSString*)datastr
{
    NSInteger hours;
    NSInteger minis;
    NSInteger secs;
    NSInteger secondes;
    if (![datastr isKindOfClass:[NSString class]] || datastr == nil || datastr.length < 8) {
        NSLog(@"返回时间字符串出错!");
        return 0;
    }
    NSArray* array = [datastr componentsSeparatedByString:@":"];
    if ([array count] >= 3) {
        hours = [array[0] integerValue];
        minis = [array[1] integerValue];
        secs = [array[2] integerValue];
        return secondes = hours * 3600 + minis * 60 + secs;
    }
    return 0;
}

#pragma mark--
#pragma mark UIColor extern
+ (UIColor*)colorFromHexCode:(NSString*)hexString
{
    NSString* cleanString =
        [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if ([cleanString length] == 3) {
        cleanString = [NSString
            stringWithFormat:@"%@%@%@%@%@%@",
                             [cleanString substringWithRange:NSMakeRange(0, 1)],
                             [cleanString substringWithRange:NSMakeRange(0, 1)],
                             [cleanString substringWithRange:NSMakeRange(1, 1)],
                             [cleanString substringWithRange:NSMakeRange(1, 1)],
                             [cleanString substringWithRange:NSMakeRange(2, 1)],
                             [cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if ([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];

    float red = ((baseValue >> 24) & 0xFF) / 255.0f;
    float green = ((baseValue >> 16) & 0xFF) / 255.0f;
    float blue = ((baseValue >> 8) & 0xFF) / 255.0f;
    float alpha = ((baseValue >> 0) & 0xFF) / 255.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (UIImage*)createImageWithColor:(UIColor*)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage* theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
#pragma mark--
#pragma mark TableView hidden foot Lines
+ (void)setExtraCellLineHidden:(UITableView*)tableView
{
    UIView* view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}
#pragma mark--
#pragma mark curTiem
+ (NSString*)curDateTime
{
    NSDate* date = [NSDate date];
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
    NSString* datestr = [formater stringFromDate:date];
    return datestr;
}
#pragma mark--others meothes
+ (NSData*)imageCompress:(UIImage*)image
{
    //    NSLog(@"Image Convert  ");
    // UIImagePNGRepresentation(image);
    NSData* imageData = UIImageJPEGRepresentation(image, 0.8);
    //    NSLog(@"Image Done  ");
    return imageData;
}

+ (BOOL)stringIsEmpty:(NSString*)str
{
    if ((NSNull*)str == [NSNull null]) {
        return YES;
    }
    if (str == nil) {
        return YES;
    } else if ([str length] == 0) {
        return YES;
    } else {
        str = [str stringByTrimmingCharactersInSet:
                       [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([str length] == 0) {
            return YES;
        }
    }
    return NO;
}

//检测IP合法的两种方式
+ (BOOL)ipvalidate:(NSString*)ipstr
{
    ipstr = [ipstr
        stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString* urlRegEx = @"^([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\.([01]?\\d\\d?|2[0-"
        @"4]\\d|25[0-5])\\.([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\.("
        @"[01]?\\d\\d?|2[0-4]\\d|25[0-5])$";
    NSPredicate* ipTest =
        [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    return [ipTest evaluateWithObject:ipstr];
}
+ (BOOL)isValidatIP:(NSString*)ipAddress
{
    ipAddress = [ipAddress
        stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString* urlRegEx = @"^([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
                          "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
                          "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
                          "([01]?\\d\\d?|2[0-4]\\d|25[0-5])$";
    NSError* error;
    NSRegularExpression* regex =
        [NSRegularExpression regularExpressionWithPattern:urlRegEx
                                                  options:0
                                                    error:&error];
    if (regex != nil) {
        NSTextCheckingResult* firstMatch =
            [regex firstMatchInString:ipAddress
                              options:0
                                range:NSMakeRange(0, [ipAddress length])];

        if (firstMatch) {
            NSRange resultRange = [firstMatch rangeAtIndex:0];
            NSString* result = [ipAddress substringWithRange:resultRange];
            //输出结果
            NSLog(@"11==%@", result);
            return YES;
        }
    }

    return NO;
}

#pragma mark--
#pragma mark-- 删除字符串中的字符或者替换
+ (NSString*)fromSourceString:(NSString*)source
             replaceSubString:(NSString*)string
                     ToString:(NSString*)aString
{
    if (!source || source.length <= 0) {
        return @"未知";
    }
    if ([source rangeOfString:string].location != NSNotFound) {
        NSArray* sqlArray = [source componentsSeparatedByString:string];
        NSMutableString* str = [[NSMutableString alloc] init];
        for (int i = 0; i < sqlArray.count - 1; i++) {
            if (!aString) {
                aString = @"";
            }
            [str appendFormat:@"%@%@", sqlArray[i], aString];
        }
        [str appendString:[sqlArray lastObject]];
        return str;
    }
    return source;
}
#pragma mark--
#pragma mark-- Plist文件操作
//把字典保存到polist文件中去；
- (void)saveInformationToPlistFileWithDictionary:(NSDictionary*)dict
                                andPlistFileName:(NSString*)name
{
    NSFileManager* fm = [NSFileManager defaultManager];
    NSString* documentsPath = NSSearchPathForDirectoriesInDomains(
        NSDocumentDirectory, NSUserDomainMask, YES)[0];
    //把Plist文件加入
    NSString* plistPath = [documentsPath
        stringByAppendingPathComponent:[NSString
                                           stringWithFormat:@"%@.plist", name]];
    //开始创建文件
    [fm createFileAtPath:plistPath contents:nil attributes:nil];

    if ([dict writeToFile:plistPath atomically:YES]) {
        NSLog(@"write to plist file is ok");
    };
}
//把字典从到polist文件取去；
- (NSDictionary*)readInformationInPlistFileName:(NSString*)plistName
{
    NSString* documentsPath = NSSearchPathForDirectoriesInDomains(
        NSDocumentDirectory, NSUserDomainMask, YES)[0];
    //把TestPlist文件加入
    NSString* plistPath = [documentsPath
        stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",
                                                                  plistName]];

    NSDictionary* dict = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    return dict;
}

//获取图片中单个点的颜色：
- (UIColor*)getPixelColorAtLocation:(CGPoint)point withImage:(UIImage*)image
{
    UIColor* color = nil;
    CGImageRef inImage = image.CGImage;
    // Create off screen bitmap context to draw the image into. Format ARGB is 4
    // bytes for each pixel: Alpa, Red, Green, Blue
    CGContextRef cgctx = [self createARGBBitmapContextFromImage:inImage];
    if (cgctx == NULL) {
        return nil;
    }

    size_t w = CGImageGetWidth(inImage);
    size_t h = CGImageGetHeight(inImage);
    CGRect rect = { { 0, 0 }, { w, h } };

    // Draw the image to the bitmap context. Once we draw, the memory
    // allocated for the context for rendering will then contain the
    // raw image data in the specified color space.
    CGContextDrawImage(cgctx, rect, inImage);

    // Now we can get a pointer to the image data associated with the bitmap
    // context.
    unsigned char* data = CGBitmapContextGetData(cgctx);
    if (data != NULL) {
        // offset locates the pixel in the data from x,y.
        // 4 for 4 bytes of data per pixel, w is width of one row of data.
        @try {
            int offset = 4 * ((w * round(point.y)) + round(point.x));
            NSLog(@"offset: %d", offset);
            int alpha = data[offset];
            int red = data[offset + 1];
            int green = data[offset + 2];
            int blue = data[offset + 3];
            NSLog(@"offset: %i colors: RGB A %i %i %i  %i", offset, red, green, blue,
                  alpha);
            color = [UIColor colorWithRed:(red / 255.0f)
                                    green:(green / 255.0f)
                                     blue:(blue / 255.0f)
                                    alpha:(alpha / 255.0f)];
        }
        @catch (NSException* e)
        {
            NSLog(@"%@", [e reason]);
        }
        @finally
        {
        }
    }
    // When finished, release the context
    CGContextRelease(cgctx);
    // Free image data memory for the context
    if (data) {
        free(data);
    }
    return color;
}

//创建取点图片工作域：
- (CGContextRef)createARGBBitmapContextFromImage:(CGImageRef)inImage
{

    CGContextRef context = NULL;
    CGColorSpaceRef colorSpace;
    void* bitmapData;
    int bitmapByteCount;
    int bitmapBytesPerRow;

    // Get image width, height. We'll use the entire image.
    size_t pixelsWide = CGImageGetWidth(inImage);
    size_t pixelsHigh = CGImageGetHeight(inImage);

    // Declare the number of bytes per row. Each pixel in the bitmap in this
    // example is represented by 4 bytes; 8 bits each of red, green, blue, and
    // alpha.
    bitmapBytesPerRow = (pixelsWide * 4);
    bitmapByteCount = (bitmapBytesPerRow * pixelsHigh);

    // Use the generic RGB color space.
    colorSpace = CGColorSpaceCreateDeviceRGB();

    if (colorSpace == NULL) {
        fprintf(stderr, "Error allocating color spacen");
        return NULL;
    }

    // Allocate memory for image data. This is the destination in memory
    // where any drawing to the bitmap context will be rendered.
    bitmapData = malloc(bitmapByteCount);
    if (bitmapData == NULL) {
        fprintf(stderr, "Memory not allocated!");
        CGColorSpaceRelease(colorSpace);
        return NULL;
    }

    // Create the bitmap context. We want pre-multiplied ARGB, 8-bits
    // per component. Regardless of what the source image format is
    // (CMYK, Grayscale, and so on) it will be converted over to the format
    // specified here by CGBitmapContextCreate.
    context = CGBitmapContextCreate(
        bitmapData, pixelsWide, pixelsHigh,
        8, // bits per component
        bitmapBytesPerRow, colorSpace,
        kCGImageAlphaPremultipliedFirst | kCGImageAlphaFirst); // kCGBitmapAlphaInfoMask,kCGImageAlphaPremultipliedFirst

    if (context == NULL) {
        free(bitmapData);
        fprintf(stderr, "Context not created!");
    }
    // Make sure and release colorspace before returning
    CGColorSpaceRelease(colorSpace);

    return context;
}

- (UIColor*)colorAtPixel:(CGPoint)point andBigImage:(UIImage*)bigImage
{
    // Cancel if point is outside image coordinates
    if (!CGRectContainsPoint(
            CGRectMake(0.0f, 0.0f, bigImage.size.width, bigImage.size.height),
            point)) {
        return nil;
    }

    NSInteger pointX = trunc(point.x);
    NSInteger pointY = trunc(point.y);
    CGImageRef cgImage = bigImage.CGImage;
    NSUInteger width = bigImage.size.width;
    NSUInteger height = bigImage.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    int bytesPerPixel = 4;
    int bytesPerRow = bytesPerPixel * 1;
    NSUInteger bitsPerComponent = 8;
    unsigned char pixelData[4] = { 0, 0, 0, 0 };
    CGContextRef context = CGBitmapContextCreate(
        pixelData, 1, 1, bitsPerComponent, bytesPerRow, colorSpace,
        kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big | kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little);
    CGColorSpaceRelease(colorSpace);
    CGContextSetBlendMode(context, kCGBlendModeCopy);

    // Draw the pixel we are interested in onto the bitmap context
    CGContextTranslateCTM(context, -pointX, pointY - (CGFloat)height);
    CGContextDrawImage(context,
                       CGRectMake(0.0f, 0.0f, (CGFloat)width, (CGFloat)height),
                       cgImage);
    CGContextRelease(context);

    // Convert color values [0..255] to floats [0.0..1.0]
    CGFloat red = (CGFloat)pixelData[0] / 255.0f;
    CGFloat green = (CGFloat)pixelData[1] / 255.0f;
    CGFloat blue = (CGFloat)pixelData[2] / 255.0f;
    CGFloat alpha = (CGFloat)pixelData[3] / 255.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (CAGradientLayer*)gradientLayer:(CGRect)frame
                       withDirect:(NSInteger)direct
                     andColorArry:(NSArray*)colorArray
{
    CAGradientLayer* gradient = [CAGradientLayer layer];
    NSMutableArray* arry = [[NSMutableArray alloc] init];
    gradient.frame = frame;
    for (int row = 0; row < colorArray.count; row++) {
        CGColorRef color = ([CommonHelperManager colorFromHexCode:colorArray[row]]).CGColor;
        [arry addObject:(__bridge id)color];
    }
    gradient.colors = [NSArray arrayWithArray:arry];
    //
    //    UIColor *startColor =[CommonHelperManager
    //    colorFromHexCode:@"#393939b8"];
    //    UIColor *endColor   = [CommonHelperManager
    //    colorFromHexCode:@"#39393900"];
    //    gradient.colors = [NSArray arrayWithObjects:
    //                       (id)startColor.CGColor,
    //                       (id)endColor.CGColor,
    //                       nil];
    switch (direct) {
    case 0: //水平
        gradient.startPoint = CGPointMake(0, 0); //默认轴为: 0.5 0.0
        gradient.endPoint = CGPointMake(1, 0); //默认轴为: 0.5 1.0
        break;
    case 1: //垂直
        gradient.startPoint = CGPointMake(0, 1); //默认轴为: 0.5 0.0
        gradient.endPoint = CGPointMake(0, 0); //默认轴为: 0.5 1.0
    default:
        break;
    }
    return gradient;
}

//设置View四周的阴影
+ (void)addSharwColorWithView:(UIView*)sharwView
{
    sharwView.layer.shadowColor =
        [UIColor blackColor].CGColor; // shadowColor阴影颜色
    sharwView.layer.shadowOffset = CGSizeMake(
        0, 0); // shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
    sharwView.layer.shadowOpacity = 0.5; //阴影透明度，默认0
    sharwView.layer.shadowRadius = 3; //阴影半径，默认3

    //路径阴影
    UIBezierPath* path = [UIBezierPath bezierPath];

    float width = sharwView.bounds.size.width;
    float height = sharwView.bounds.size.height;
    float x = sharwView.bounds.origin.x;
    float y = sharwView.bounds.origin.y;
    float addWH = 5;

    CGPoint topLeft = sharwView.bounds.origin;
    CGPoint topMiddle = CGPointMake(x + (width / 2), y - addWH);
    CGPoint topRight = CGPointMake(x + width, y);

    CGPoint rightMiddle = CGPointMake(x + width + addWH, y + (height / 2));

    CGPoint bottomRight = CGPointMake(x + width, y + height);
    CGPoint bottomMiddle = CGPointMake(x + (width / 2), y + height + addWH);
    CGPoint bottomLeft = CGPointMake(x, y + height);

    CGPoint leftMiddle = CGPointMake(x - addWH, y + (height / 2));

    [path moveToPoint:topLeft];
    //添加四个二元曲线
    [path addQuadCurveToPoint:topRight controlPoint:topMiddle];
    [path addQuadCurveToPoint:bottomRight controlPoint:rightMiddle];
    [path addQuadCurveToPoint:bottomLeft controlPoint:bottomMiddle];
    [path addQuadCurveToPoint:topLeft controlPoint:leftMiddle];
    //设置阴影路径
    sharwView.layer.shadowPath = path.CGPath;
}
//创建docment目录下文件的绝对路径
+ (NSString*)fullBundlePathFromRelativePath:(NSString*)filePath
{
    NSString* documentsPath = NSSearchPathForDirectoriesInDomains(
        NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString* downloadFolder = [documentsPath
        stringByAppendingPathComponent:[NSString
                                           stringWithFormat:@"%@", filePath]];
    // 记录文件起始位置
    if ([[NSFileManager defaultManager]
            fileExistsAtPath:downloadFolder]) { // 已经存在
        return downloadFolder;
    } else { // 不存在，直接创建

        if ([[NSFileManager defaultManager] createFileAtPath:downloadFolder
                                                    contents:nil
                                                  attributes:nil]) {
            NSLog(@"it's OK");
            return downloadFolder;
        }
    }
    return downloadFolder;
}

//从friendname中取出设备的名字，去掉IP，返回字符串显示。
+ (NSString*)checkIp:(NSString*)ipStr
{
    NSString* str;
    NSArray* arry = [ipStr componentsSeparatedByString:@"-"];
    if (arry.count < 2) {
        str = ipStr;
    } else {
        if (![CommonHelperManager ipvalidate:arry[1]]) {
            str = [arry[0] stringByAppendingString:arry[1]];
        } else {
            str = arry[0];
        }
    }
    return str;
}

#pragma mark--对图片进行模糊滤镜
+ (UIImage*)blurryImage:(UIImage*)image withBlurLevel:(CGFloat)blur andContext:(CIContext*)context
{
    UIImage* returnImage = nil;
    @autoreleasepool
    {
        CIImage* inputImage = [CIImage imageWithCGImage:image.CGImage];
        CIFilter* filter = [CIFilter filterWithName:@"CIGaussianBlur"
                                      keysAndValues:kCIInputImageKey, inputImage,
                                                    @"inputRadius", @(blur), nil];
        CIImage* outputImage = filter.outputImage;
        CGImageRef outImage =
            [context createCGImage:outputImage fromRect:[inputImage extent]];
        inputImage = nil;
        filter = nil;
        outputImage = nil;
        returnImage = [UIImage imageWithCGImage:outImage];
        CGImageRelease(outImage);
    }
    return returnImage;
}

#pragma mark--对地址进行解析获取网络歌曲的格式
+ (NSString*)PareURL:(NSString*)url
{
    NSString* audiotype = @"";
    NSArray* formatArray = [[NSArray alloc] initWithObjects:@"flac",
                                                            @"ape",
                                                            @"aac",
                                                            @"ogg", nil];
    NSArray* baseArray = [url componentsSeparatedByString:@"?"];
    if (baseArray.count != 2) {
        return audiotype;
    }
    NSString* headstr = baseArray[0];
    NSArray* headArray = [headstr componentsSeparatedByString:@"."];
    if (headArray.count <= 2) {
        return audiotype;
    }
    NSString* audioFormate = [headArray[headArray.count - 1] lowercaseString];
    for (NSString* tempstr in formatArray) {
        if ([tempstr isEqualToString:audioFormate]) {
            audiotype = audioFormate;
            break;
        }
    }
    return audiotype;
}
//获取缓存目录
- (NSString*)getCacheRootDirectory
{
    NSString* cache = [NSString stringWithFormat:@"%@/Library/Caches/MediasCaches", NSHomeDirectory()];
    if (![[NSFileManager defaultManager] fileExistsAtPath:cache]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:cache
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:NULL];
    }
    return cache;
}

@end
