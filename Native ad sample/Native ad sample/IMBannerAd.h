//
//  IMBannerAd.h
//  Native ad sample
//
//

#import <UIKit/UIKit.h>
#import "IMAdRequestData.h"

@interface IMBannerAd : UIView

@property(nonatomic,retain) IMAdRequestData *request;

- (id)initWithFrame:(CGRect)frame;
- (void)loadAd;
@end
