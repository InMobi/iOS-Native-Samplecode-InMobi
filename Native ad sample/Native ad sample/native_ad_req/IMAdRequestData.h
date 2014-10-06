//
//  IMNativeAdRequest.h
//  Native ad sample
//
//

#import <Foundation/Foundation.h>
#import "IMStubs.h"

#define IM_AD_SERVER_URL @"http://api.w.inmobi.com/showad/v2"

typedef enum {
    IMAdRequestTypeBanner,
    IMAdRequestTypeInterstitial,
    IMAdRequestTypeNative
} IMAdRequestType;
/**
 * This class can be used to request InMobi ads. 
 * To request inmobi ads, use a subclass instance for specific banner/interstitial or native ads.
 * Mandatory parameters for a valid request: Site-id, carrierIP, adSize( valid for banner/int ads)
 * User-agent is fetched from UIWebView directly.
 */

@interface IMAdRequestData : NSObject

/**
 * The original carrier IP address of the device.
 * @note Please do not provide the internal IP(for eg. 10.14.x.y or 192.168.x.y )
 * as InMobi would terminate the request.
 */
//@property(nonatomic,copy) NSString *carrierIP;

@property(nonatomic,retain) IMImpressionObject *impressionObj;
@property(nonatomic,retain) IMUserObject *userObj;
@property(nonatomic,assign,readonly) BOOL isRequestInProgress;

//internally set objects
@property(nonatomic,retain) IMPropertyObject *propertyObj;
@property(nonatomic,retain) IMDeviceObject *deviceObj;
/**
 * The int value for requesting banner/interstitial ad of a specific size.
 * See more at "Ad Size Lookup Table" : https://www.inmobi.com/support/art/26555436/22465648/api-2-0-integration-guidelines/
 */
@property(nonatomic,assign) int adSize;

/*
 * Constructor to instantiate with an InMobi Property ID, and the device carrierIP.
 * Use this constructor with native ads.
 */
- (id)initWithPropertyID:(NSString *)ID carrierIP:(NSString *)carrierIP ;
/*
 * Constructor to instantiate with an InMobi Property ID, and the device carrierIP.
 * Use this constructor with banner/interstitial ads.
 */
- (id)initWithPropertyID:(NSString *)ID carrierIP:(NSString *)carrierIP adSize:(int)size;
/**
 * Call this method to request for a fresh ad.
 * May call failure if a failed resposne is received, or an ad is already in progress.
 */
- (void)loadAd;

@end

