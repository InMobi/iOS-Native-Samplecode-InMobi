//
//  IMNativeAd.h
//
//


#import <StoreKit/StoreKit.h>
#import "IMAdRequestData.h"

@class IMNativeAd;
@protocol IMNativeAdDelegate <NSObject>

- (void)nativeAdFinishedLoading:(IMNativeAd *)nativeAd;
- (void)nativeAd:(IMNativeAd *)nativeAd failedToLoadWithError:(NSError *)error;

@end

@class NativeAdUIData;
@interface IMNativeAd : NSObject <SKStoreProductViewControllerDelegate>

@property(nonatomic,assign) id<IMNativeAdDelegate> delegate;
@property(nonatomic,retain) NativeAdUIData *metadata;
@property(nonatomic,weak) UIViewController *controller;
@property(nonatomic,retain) IMAdRequestData *request;


+ (BOOL) isITunesURL:(NSURL *)url;
+ (NSString *)iTunesIDFromURL:(NSURL *)url;
- (void)countClick:(NSDictionary *)dictionary;
- (void)countImpression;
- (void)loadAd;
@end

@interface NativeAdUIData : NSObject
@property(nonatomic,copy) NSString *title,*desc,*rating,*cta,*img_url,*landing_url;
@end
