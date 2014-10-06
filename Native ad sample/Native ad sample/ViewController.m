//
//  ViewController.m
//  Native Sample
//


//

#import "ViewController.h"
#import "IMNativeQueue.h"
#import "IMStubs.h"
#import "IMBannerAd.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize nativeAd,adHolderView;
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createAdHolderView];
    [self createNativeAdView];
    
    UIButton *b = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    b.frame = CGRectMake(80, 300, 170, 30);
    [b addTarget:self action:@selector(load) forControlEvents:UIControlEventTouchUpInside];
    [b setTitle:@"load" forState:UIControlStateNormal];
    [self.view addSubview:b];
    

}
//- (void)reload {
//    for(int i = 1; i <4; i++) {
//        [NSThread detachNewThreadSelector:@selector(load1:) toTarget:self withObject:[NSNumber numberWithInt:i]];
//        //[InMobiNativeQueue recordImpressionWithNamespace:[NSString stringWithFormat:@"im_5323_"] contextCode:[NSString stringWithFormat:@"%@",ad1] additionalParams:nil];
//    }
//}
//- (void)load1:(NSNumber *)i {
//    NSMutableString *ad1 = [[NSMutableString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ad1" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
//    //NSString *ns = @"im_5323_";
//    [IMNativeQueue recordClickWithNamespace:[NSString stringWithFormat:@"im_5323_%d",[i intValue]] contextCode:[NSString stringWithFormat:@"%@",ad1] additionalParams:nil];
//}
//
//- (void)load:(NSNumber *)i {
//    NSMutableString *ad1 = [[NSMutableString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ad1" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
//    //NSString *ns = @"im_5323_";
//    [IMNativeQueue recordImpressionWithNamespace:[NSString stringWithFormat:@"im_5323_%d",[i intValue]] contextCode:[NSString stringWithFormat:@"%@",ad1] additionalParams:nil];
//}

- (void)load {
    [nativeAd loadAd];


}

- (void)createAdHolderView {
    adHolderView = [[NativeAdHolderView alloc] initWithFrame:CGRectMake(0, 40, 320, 200)];
    adHolderView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:adHolderView];
}

- (void)createNativeAdView {
    
    IMUserSegmentObject *segmentObj = [[IMUserSegmentObject alloc] init];
    segmentObj.userSegmentArray = @[@{@"key1":@"value1"},@{@"key2":@"value2"},@{@"key3":@"value3"}];
    
    IMDataObject *dataObj = [[IMDataObject alloc] init];
    dataObj.ID = 123; dataObj.segmentObj = segmentObj;
    dataObj.name = @"name";
    
    IMUserObject *userObj = [[IMUserObject alloc] init];
    userObj.gender = IMGenderMale; userObj.yob = 1985;
    userObj.dataObj = dataObj;
    
    IMBannerObject *bannerObj = [[IMBannerObject alloc] init];
    bannerObj.adSize = 15; bannerObj.position = @"top";
    
    IMImpressionObject *impressionObj = [[IMImpressionObject alloc] init];
    impressionObj.noOfAds = 1; impressionObj.displayManager = @"c_your";
    impressionObj.displayManagerVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];;
    impressionObj.bannerObj = bannerObj;
    
    IMAdRequestData *request = [[IMAdRequestData alloc] initWithPropertyID:@"<YOUR-SITE-ID>" carrierIP:@"<DEVICE-CARRIER-IP>"];
    request.impressionObj = impressionObj;
    request.userObj = userObj;
    
    nativeAd = [[IMNativeAd alloc] init];
    nativeAd.request = request;
    nativeAd.controller = self;
    adHolderView.nativeAd = nativeAd;
    nativeAd.delegate = adHolderView;
    
    [nativeAd loadAd];
    //nativeAd.delegate = adHolderView;
    
    //[NSTimer scheduledTimerWithTimeInterval:30 target:nativeAd selector:@selector(loadAd) userInfo:nil repeats:YES];
    //[nativeAd loadAd];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
