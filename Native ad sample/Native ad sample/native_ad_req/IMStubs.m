//
//  IMStubs.m
//  Native ad sample
//
//

#import "IMStubs.h"
#import <UIKit/UIKit.h>
#import <AdSupport/AdSupport.h>
#import <CoreLocation/CoreLocation.h>

@implementation IMPropertyObject
@synthesize propertyId;

@end

@implementation IMImpressionObject
@synthesize noOfAds,isInterstitial,displayManager,displayManagerVersion,bannerObj;

- (id)init {
    if (self = [super init]) {
        noOfAds = 1;
    }
    return self;
}

- (void)setNoOfAds:(int)no {
    if (no < 1) {
        noOfAds = 1;
    }
    else if (no > 3) {
        noOfAds = 3;
    } else {
        noOfAds = no;
    }
}

@end

@implementation IMDeviceObject
@synthesize carrierIP,userAgent,IDFA,IDV,adt,geoObj;

- (id)init {
    if (self = [super init]) {
        [self performSelectorOnMainThread:@selector(fetchUserAgent) withObject:nil waitUntilDone:YES];
        self.IDFA = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        self.IDV = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        self.adt = [[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled];
    }
    return self;
}

- (void)fetchUserAgent {
    UIWebView *w = [[UIWebView alloc] init];
    self.userAgent = [w stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    //self.userAgent = @"Mozilla/5.0 (iPhone; CPU iPhone OS 8_0 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9A334 Safari/7534.48.3";
    NSLog(@"UA: %@",userAgent);
}

@end

@interface IMGeoObject  ()<CLLocationManagerDelegate> {
    CLLocationManager *locationManager;
}

@end

@implementation IMGeoObject
@synthesize lat,lon,accu;
- (id)init {
    if (self = [super init]) {
        lat = lon = 0;
        accu = 0;
        if ([CLLocationManager locationServicesEnabled]) {
            locationManager = [[CLLocationManager alloc] init];
        }
    }
    return self;
}

- (void)dealloc {
    [locationManager stopUpdatingLocation];
    locationManager = nil;
}

@end

@implementation IMUserObject
@synthesize yob,dataObj,gender;

- (id)init {
    if (self = [super init]) {
        gender = IMGenderNone;
    }
    return self;
}

@end

@implementation IMBannerObject
@synthesize adSize,position;

@end

@implementation IMDataObject
@synthesize ID,name,segmentObj;

- (id)init {
    if (self = [super init]) {
        ID = 0;
    }
    return self;
}

@end

@implementation IMUserSegmentObject
@synthesize userSegmentArray;

@end