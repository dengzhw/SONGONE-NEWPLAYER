
#define UPNP_MEDIASERVER @"urn:schemas-upnp-org:device:MediaServer:1"
#define UPNP_MEDIARENDER @"urn:schemas-upnp-org:device:MediaRenderer:1"

#import <Foundation/Foundation.h>

@class SSDP;

static const NSString* SSDP_DISCOVER_IP = @"239.255.255.250";
static const NSUInteger SSDP_DISCOVER_PORT = 1900;

static const NSString* SSDP_DISCOVER_DEVICES = @"M-SEARCH * HTTP/1.1\r\n\
HOST: 239.255.255.250:1900 \r\n\
Man: \"ssdp:discover\"\r\n\
MX: 3\r\n\
ST: %@\r\n\
\r\n";

@protocol SSDPDelegate <NSObject>
- (void)browserType:(NSString*)Type foundService:(NSDictionary*)service;
@end

@interface SSDP : NSObject
@property (strong, nonatomic) NSArray* searchType;

@property (nonatomic, weak) id<SSDPDelegate> delegate;

- (void)startScanning;
- (void)stopScanning;

@end
