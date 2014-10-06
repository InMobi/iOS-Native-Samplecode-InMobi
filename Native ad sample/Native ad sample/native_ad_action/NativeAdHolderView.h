//
//  NativeAdHolderView.h
//
//

#import <UIKit/UIKit.h>

#import "IMNativeAd.h"
@interface NativeAdHolderView : UIView <IMNativeAdDelegate>  {
    UIImageView *imgView;
    UILabel *desc;
    UIButton *download;
    UILabel *title,*sponsored;
    UIImageView *star1,*star2,*star3,*star4,*star5;
}
@property(nonatomic,retain) IMNativeAd *nativeAd;


@end
