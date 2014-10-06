//
//  IMNativeAd.m
//  TicTacToe
//
//

#import "IMNativeAd.h"
#import "EmbeddedWebViewController.h"
#import "IMRequestResponse.h"
#import <MediaPlayer/MediaPlayer.h>
#import "IMGTMBase64Private.h"
#import "IMNativeAdData.h"
#import "IMNativeQueue.h"

@interface IMNativeAd ()<IMRequestResponseDelegate> {
    BOOL isRequestInProgress;
    IMRequestResponse *requestResponse;

}
@property(nonatomic,retain) EmbeddedWebViewController *embeddedWebViewController;
@property(nonatomic,retain) IMNativeAdData *data;
@end

@implementation IMNativeAd
@synthesize embeddedWebViewController,controller,delegate,data;

- (id)init {
    if (self = [super init]) {
        requestResponse = [[IMRequestResponse alloc] init];
        requestResponse.delegate = self;
    }
    return self;
}

#pragma mark Util static methods

+ (BOOL) isITunesURL:(NSURL *)url {
    return [[url host] isEqualToString:@"itunes.apple.com"] ? YES : NO;
}

+ (NSString *)iTunesIDFromURL:(NSURL *)url {
    NSString *ID = NULL;
    if (NSClassFromString(@"SKStoreProductViewController")) {
        NSArray *query = [url pathComponents];
        BOOL success = NO;
        for (NSString *q in query) {
            if ([q hasPrefix:@"id"]) {
                //id found
                ID = [q substringFromIndex:2];
                
                success = YES;
                break;
            }
        }
    }
    return ID;
}

+ (BOOL)isMediaURL:(NSURL *)url {
    BOOL retVal = NO;
    NSString *urlStr = [url absoluteString];
    if ([urlStr hasSuffix:@"mp4"] || [urlStr hasSuffix:@"3gp"] || [urlStr hasSuffix:@"avi"] || [urlStr hasSuffix:@"mov"]) {
        retVal = YES;
    }
    return retVal;
}



#pragma mark Post Ad Lifecycle methods

- (void)startMediaPlayback:(NSURL *)url {
    MPMoviePlayerViewController *mediaController = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
    [self.controller presentMoviePlayerViewControllerAnimated:mediaController];
}

- (void)checkAndOpenLandingUrl {
    NSURL *url = [NSURL URLWithString:self.metadata.landing_url];
    if(url) {
        if ([IMNativeAd isITunesURL:url]) {
            //looks like an app store url
            NSString *itunesID = [IMNativeAd iTunesIDFromURL:url];
            if (itunesID) {
                [self openSkStore:itunesID];
            } else {
                [self checkAndOpenEmbeddedBrowser:url];
            }
            } else {
                [self checkAndOpenEmbeddedBrowser:url];
            }
        } else {
            NSLog(@"url is invalid:%@",url);
    }
}

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    [self.controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)openSkStore:(NSString *)ID {
    SKStoreProductViewController *skStoreController = [[SKStoreProductViewController alloc] init];
    skStoreController.delegate = self;
    [self.controller presentViewController:skStoreController animated:YES completion:nil];
    [skStoreController loadProductWithParameters:[NSDictionary dictionaryWithObject:ID forKey:SKStoreProductParameterITunesItemIdentifier] completionBlock:^(BOOL result, NSError *error) {
        NSLog(@"result:%d,eror:%@",result,[error description]);
    }];
}

- (void)checkAndOpenEmbeddedBrowser:(NSURL *)url {
    if ([url.scheme isEqualToString:@"http"] || [url.scheme isEqualToString:@"https"]) {
        if ([IMNativeAd isMediaURL:url]) {
            [self startMediaPlayback:url];
            return;
        }
        if (embeddedWebViewController) {
            embeddedWebViewController = NULL;
        }
        embeddedWebViewController = [[EmbeddedWebViewController alloc] initWithURL:url];
        UINavigationController *navigationController = [[UINavigationController alloc]
                                        initWithRootViewController:embeddedWebViewController];
        [self.controller presentViewController:navigationController animated:YES completion:NULL];
    } else {
        [self openExternal:url];
    }
}
- (void)openExternal:(NSURL *)url {
    UIApplication *app = [UIApplication sharedApplication];
    if ([app canOpenURL:url]) {
        [app openURL:url];
    } else {
        NSLog(@"Cannot identify URL:%@",url);
    }
}

- (void)populateNativeAdMetadata:(NSString *)content {
    NSError *error = nil;
    NSDictionary *json = nil;
    if (content) {
       json = [NSJSONSerialization JSONObjectWithData:[content dataUsingEncoding:NSASCIIStringEncoding] options:kNilOptions error:&error];
    }
    
    if (json && [json isKindOfClass:[NSDictionary class]]) {
        NativeAdUIData *meta = [[NativeAdUIData alloc] init];
        meta.cta = [json objectForKey:@"cta_install"];
        meta.title = [json objectForKey:@"title"];
        meta.desc = [json objectForKey:@"subtitle"];
        meta.rating = [json objectForKey:@"rating"];
        meta.landing_url = [json objectForKey:@"landing_url"];
        NSDictionary *icons = [json objectForKey:@"icon_xhdpi"];
        if (icons && [icons isKindOfClass:[NSDictionary class]]) {
            meta.img_url = [icons objectForKey:@"url"];
        }
        self.metadata = meta;
       // NSLog(@"%@",[meta description]);
    }
}

#pragma mark request lifecycle methods

- (void)loadAd {
    @synchronized(self) {
        if (isRequestInProgress) {
            [self sendFailureCallback:[NSError errorWithDomain:@"InMobi" code:1 userInfo:@{NSLocalizedDescriptionKey : @"An ad request is already in progress"}]];
            return;
        }
        [requestResponse sendBannerRequest:self.request type:IMAdRequestTypeNative];
    }
}

#pragma mark RequestResponseDelegate callbacks

- (void)requestResponse:(IMRequestResponse *)response failedToLoadWithError:(NSError *)error {
    isRequestInProgress = NO;
    [self sendFailureCallback:error];
}
- (void)requestResponse:(IMRequestResponse *)response finishedWithData:(NSData *)responseData {
    if (responseData) {
        id response = [NSJSONSerialization JSONObjectWithData:responseData options:1 error:nil];
        if ([response isKindOfClass:[NSDictionary class]]) {
            //read as dictionary
            NSDictionary *r = (NSDictionary *)response;
            NSArray *ads = [r objectForKey:@"ads"];
            IMNativeAdData *tempData = nil;
            for (NSDictionary *ad in ads) {
                NSString *pubContentJSON = [[NSString alloc] initWithData:[IMGTMBase64Private decodeString:[ad objectForKey:@"pubContent"]] encoding:NSUTF8StringEncoding];
                [self populateNativeAdMetadata:pubContentJSON];
                tempData = [[IMNativeAdData alloc] init];
                tempData.ns = (NSString *)[ad objectForKey:@"namespace"];
                tempData.contextCode = (NSString *)[ad objectForKey:@"contextCode"];
            }
            
            if (tempData) {
                if (tempData.ns != nil && tempData.contextCode != nil && self.metadata != nil) {
                    self.data = tempData;
                    [self sendSuccessCallback];
                } else {
                    [self sendFailureCallback:[NSError errorWithDomain:@"Inmobi" code:5 userInfo:@{NSLocalizedDescriptionKey : @"Server returned a no-fill."}]];
                }
            } else {
                [self sendFailureCallback:[NSError errorWithDomain:@"Inmobi" code:5 userInfo:@{NSLocalizedDescriptionKey : @"Server returned a no-fill."}]];
            }
            
        } else {
            [self sendFailureCallback:[NSError errorWithDomain:@"Inmobi" code:2 userInfo:@{NSLocalizedDescriptionKey : @"Error parsing response data."}]];
        }
    } else {
        [self sendFailureCallback:[NSError errorWithDomain:@"Inmobi" code:2 userInfo:@{NSLocalizedDescriptionKey : @"Error parsing response data."}]];
    }
    isRequestInProgress = NO;
}

#pragma mark callbacks

- (void)sendSuccessCallback {
    if (delegate && [delegate respondsToSelector:@selector(nativeAdFinishedLoading:)]) {
        [delegate nativeAdFinishedLoading:self];
    }
}
- (void)sendFailureCallback:(NSError *)error {
    if (delegate && [delegate respondsToSelector:@selector(nativeAd:failedToLoadWithError:)]) {
        [delegate nativeAd:self failedToLoadWithError:error];
    }
}

#pragma mark counting impression/clicks

- (void)countImpression {
    [IMNativeQueue recordImpressionWithNamespace:data.ns contextCode:data.contextCode additionalParams:data.additionalParams];
}
- (void)countClick:(NSDictionary *)dictionary {
    [self checkAndOpenLandingUrl];
    [IMNativeQueue recordClickWithNamespace:data.ns contextCode:data.contextCode additionalParams:data.additionalParams];
}

@end

@implementation NativeAdUIData
@synthesize title,desc,rating,cta,img_url,landing_url;

- (NSString *)description {
    return [NSString stringWithFormat:@"cta:%@,title:%@,landing_url:%@,rating:%@,img-url:%@,dsc:%@",cta,title,landing_url,rating,img_url,desc];
}

@end