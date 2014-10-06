//
//  ViewController.h
//  Native ad sample
//


//

#import <UIKit/UIKit.h>

#import "NativeAdHolderView.h"
#import "IMNativeAd.h"

#define IM_NATIVE_ID @"e6f745dadd9d4ebb9e77af0adfff77b3"

@interface ViewController : UIViewController

@property(retain,nonatomic)  NativeAdHolderView *adHolderView;
@property(retain,nonatomic) IMNativeAd *nativeAd;


@end

