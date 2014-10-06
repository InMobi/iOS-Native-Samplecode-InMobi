//
//  IMBannerAd.m
//  Native ad sample
//

//

#import "IMBannerAd.h"
#import "IMRequestResponse.h"

@implementation IMBannerAd
@synthesize request;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)loadAd {
    IMRequestResponse *req = [[IMRequestResponse alloc] init];
    [req sendBannerRequest:request type:IMAdRequestTypeBanner];
}

@end
