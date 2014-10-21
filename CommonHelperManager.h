//
//  CommonHelperManager.h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface CommonHelperManager : NSObject {
}

+ (uint64_t)getFreeDiskspace;
+ (uint64_t)getTotalDiskspace;
+ (NSString*)getDiskSpaceInfo;
////将字节转化成M单位，不附带M
//+(NSString *)transformToM:(NSString *)size;
////将不M的字符串转化成字节
//+(float)transformToBytes:(NSString *)size;
//将文件大小转化成M单位或者B单位
+ (NSString*)getFileSizeString:(NSString*)size;
//经文件大小转化成不带单位ied数字
+ (float)getFileSizeNumber:(NSString*)size;
+ (NSDate*)makeDate:(NSString*)birthday;
+ (NSString*)dateToString:(NSDate*)date;
+ (NSString*)getTempFolderPathWithBasepath:
        (NSString*)name; //得到临时文件存储文件夹的路径
+ (NSArray*)getTargetFloderPathWithBasepath:(NSString*)name
                                 subpatharr:(NSArray*)arr;
+ (NSString*)getTargetPathWithBasepath:(NSString*)name
                               subpath:(NSString*)subpath;
+ (BOOL)isExistFile:(NSString*)fileName; //检查文件名是否存在
+ (NSMutableArray*)getAllFinishFilesListWithPatharr:(NSArray*)patharr;
+ (NSString*)md5StringForData:(NSData*)data;
+ (NSString*)md5StringForString:(NSString*)str;
//传入文件总大小和当前大小，得到文件的下载进度
+ (CGFloat)getProgress:(float)totalSize currentSize:(float)currentSize;
+ (NSString*)makeDataToString:(NSInteger)date;
+ (NSInteger)dateStringToInt:(NSString*)datastr;

//<------------UIColor----------------------------->
+ (UIColor*)colorFromHexCode:(NSString*)hexString;
+ (UIImage*)createImageWithColor:(UIColor*)color;
- (UIColor*)getPixelColorAtLocation:(CGPoint)point withImage:(UIImage*)image;
- (UIColor*)colorAtPixel:(CGPoint)point andBigImage:(UIImage*)bigImage;
+ (CAGradientLayer*)gradientLayer:(CGRect)frame
                       withDirect:(NSInteger)direct
                     andColorArry:(NSArray*)colorArray;
//<------------设置TableView多余的行线隐藏-------------------------->
+ (void)setExtraCellLineHidden:(UITableView*)tableView;
//<-------------------Time---------------------->
+ (NSString*)curDateTime;
+ (NSData*)imageCompress:(UIImage*)image;
+ (NSData*)imageCompressToBinary:(UIImage*)image;

+ (BOOL)stringIsEmpty:(NSString*)str;
+ (BOOL)ipvalidate:(NSString*)ipstr;
+ (BOOL)isValidatIP:(NSString*)ipAddress;
//得到设备的名字,前半部分
+ (NSString*)checkIp:(NSString*)ipStr;
//<-------------------String ---------------------->
+ (NSString*)fromSourceString:(NSString*)source
             replaceSubString:(NSString*)string
                     ToString:(NSString*)aString;

/*-------------创建document目录下的文件.................*/
+ (NSString*)fullBundlePathFromRelativePath:(NSString*)filePath;

//设置View四周的阴影
+ (void)addSharwColorWithView:(UIView*)sharwView;
/*--------------提示view的方法--------------------------*/
+ (UIView*)noticeViewWithFrame:(CGRect)frame
                        andMsg:(NSString*)msg
            andBackgroundColor:(UIColor*)color;
//滤镜图片
+ (UIImage*)blurryImage:(UIImage*)image withBlurLevel:(CGFloat)blur andContext:(CIContext*)context;

//+ (UIImage*)blurryGPUImage:(UIImage*)image withBlurLevel:(NSInteger)blur;
//获取网络歌曲的格式。
+ (NSString*)PareURL:(NSString*)url;
//获取缓存目录
- (NSString*)getCacheRootDirectory;
//判断网络是否可用
+ (BOOL)isConnectionAvailable;

@end
