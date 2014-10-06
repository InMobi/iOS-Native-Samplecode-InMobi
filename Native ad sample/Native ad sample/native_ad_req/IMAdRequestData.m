//
//  IMNativeAdRequest.m
//  Native ad sample
//
//

#import "IMAdRequestData.h"

@interface IMAdRequestData ()
@property(nonatomic,copy) NSString *requestFormat;
@end

@implementation IMAdRequestData

@synthesize requestFormat,propertyObj,deviceObj,isRequestInProgress;

- (id)initWithPropertyID:(NSString *)ID carrierIP:(NSString *)carrier  {
    
    return [self initWithPropertyID:ID carrierIP:carrier adSize:15];
}
- (id)initWithPropertyID:(NSString *)ID carrierIP:(NSString *)carrier adSize:(int)size {
    if (self = [super init]) {
        self.propertyObj = [[IMPropertyObject alloc] init];
        propertyObj.propertyId = ID;
        
        self.deviceObj = [[IMDeviceObject alloc] init];
        deviceObj.carrierIP = carrier;
    }
    return self;
}

- (void)loadAd {
    
}

@end


