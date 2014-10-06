//
//  EmbeddedViewController.m
//  uigridview
//

//
//

#import "EmbeddedWebViewController.h"
#import "IMNativeAd.h"

@interface EmbeddedWebViewController ()

@end

@implementation EmbeddedWebViewController
@synthesize safari,close,back,fwd,reload;
@synthesize url;
@synthesize webView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithURL:(NSURL *)_url {
    self = [super init];
    if (self) {
        self.url = _url;
        self.safari = [self safariButton];
        self.back = [self backButton];
        self.reload = [self reloadButton];
        self.close = [self closeButton];
        self.fwd = [self fwdButton];
        self.safari.accessibilityLabel = @"safari";
        self.back.accessibilityLabel = @"back";
        self.reload.accessibilityLabel = @"reload";
        self.close.accessibilityLabel = @"close";
        self.fwd.accessibilityLabel = @"fwd";
        self.toolbarItems = [NSArray arrayWithObjects:close,[self flexiSpaceButton],reload,[self flexiSpaceButton],safari,[self flexiSpaceButton],back,[self flexiSpaceButton],fwd, nil];

        self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        webView.delegate = self;
        webView.scalesPageToFit = YES;
        webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self.view addSubview:webView];
        isFirstLoad = YES;
        dismissFlag = NO;
    }
    return self;
}

- (void)checkButtonAction {
    if ([webView canGoBack]) {
        [back setEnabled:YES];
    } else {
        [back setEnabled:NO];
    }
    if ([webView canGoForward]) {
        [fwd setEnabled:YES];
    } else {
        [fwd setEnabled:NO];
    }
}

#pragma mark UIBarButton click methods

- (void)closeMVC {
    [webView stopLoading];
    dismissFlag = YES;
    [self dismissViewControllerAnimated:YES completion:NULL];
}
- (void)goBack {
    [webView goBack];
    [self checkButtonAction];
}
- (void)goFwd {
    [webView goForward];
    [self checkButtonAction];
}
- (void)refresh {
    [webView reload];
}
- (void)openSafari {
    actionSheet = [[UIActionSheet alloc]
                   initWithTitle:@"" delegate:self
                   cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil
                   otherButtonTitles:@"Open in Safari", nil];
    [actionSheet showFromBarButtonItem:safari animated:YES];
}

- (void)actionSheet:(UIActionSheet *)_actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != _actionSheet.cancelButtonIndex) {
        [[UIApplication sharedApplication] openURL:[webView.request URL]];
    }
    actionSheet = nil;
}

#pragma mark UIBarButton create methods

- (CGContextRef)newContext {
    // create the bitmap context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(nil,27,27,8,0,
                                                 colorSpace,(CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    CFRelease(colorSpace);
    return context;
}
- (CGImageRef)newCloseImage {
    CGContextRef context = [self newContext];
    // set the fill color
    CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
    // Draw them with a 2.0 stroke width so they are a bit more visible.
    CGContextSetLineWidth(context, 4.0);
    // Draw a single line from left to right
    CGContextMoveToPoint(context, 8.0, 6.0);
    CGContextAddLineToPoint(context, 24.0, 20.0);
    CGContextMoveToPoint(context, 24.0, 6.0);
    CGContextAddLineToPoint(context, 8.0, 20.0);
    CGContextStrokePath(context);
    CGImageRef image = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    return image;
}
- (CGImageRef)newBackArrowImageRef {
    CGContextRef context = [self newContext];
    // set the fill color
    CGColorRef fillColor = [[UIColor blackColor] CGColor];
    CGContextSetFillColor(context, CGColorGetComponents(fillColor));
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 8.0f, 13.0f);
    CGContextAddLineToPoint(context, 24.0f, 4.0f);
    CGContextAddLineToPoint(context, 24.0f, 22.0f);
    CGContextClosePath(context);
    CGContextFillPath(context);
    // convert the context into a CGImageRef
    CGImageRef image = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    return image;
}
- (CGImageRef)newFwdArrowImageRef {
    CGContextRef context = [self newContext];
    // set the fill color
    CGColorRef fillColor = [[UIColor blackColor] CGColor];
    CGContextSetFillColor(context, CGColorGetComponents(fillColor));
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 16.0f, 13.0f);
    CGContextAddLineToPoint(context, 0.0f, 4.0f);
    CGContextAddLineToPoint(context, 0.0f, 22.0f);
    CGContextClosePath(context);
    CGContextFillPath(context);
    // convert the context into a CGImageRef
    CGImageRef image = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    return image;
}

- (UIBarButtonItem *)closeButton {
    CGImageRef theCGImage = [self newCloseImage];
    UIImage *closeImage = [[UIImage alloc] initWithCGImage:theCGImage];
    CGImageRelease(theCGImage);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithImage:closeImage
                                   style:UIBarButtonItemStylePlain
                                   target:self action:@selector(closeMVC)];
    closeImage = nil;
    return backButton;
}
- (UIBarButtonItem *)backButton {
    CGImageRef theCGImage = [self newBackArrowImageRef];
    UIImage *backImage = [[UIImage alloc] initWithCGImage:theCGImage];
    CGImageRelease(theCGImage);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithImage:backImage
                                   style:UIBarButtonItemStylePlain
                                   target:self action:@selector(goBack)];
    backImage = nil;
    [backButton setEnabled:NO];
    return backButton;
}
- (UIBarButtonItem *)reloadButton {
    UIBarButtonItem *reloadButton = [[UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                     target:self action:@selector(refresh)];
    return reloadButton;
}
- (UIBarButtonItem *)fwdButton {
    CGImageRef theCGImage = [self newFwdArrowImageRef];
    UIImage *backImage = [[UIImage alloc] initWithCGImage:theCGImage];
    CGImageRelease(theCGImage);
    UIBarButtonItem *fwdButton = [[UIBarButtonItem alloc]
                                  initWithImage:backImage
                                  style:UIBarButtonItemStylePlain
                                  target:self action:@selector(goFwd)];
    backImage = nil;
    [fwdButton setEnabled:NO];
    return fwdButton;
}
- (UIBarButtonItem *)safariButton {
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
            UIBarButtonSystemItemAction target:self action:@selector(openSafari)];
}
- (UIBarButtonItem *)flexiSpaceButton {
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
                               UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    return button;
}

#pragma mark UIView Life cycle methods

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden = NO;
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.toolbar.barStyle = UIBarStyleBlackOpaque;
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (isFirstLoad) {
        if (self.url) {
            isFirstLoad = NO;
            
            if (url) {
                [webView loadRequest:[NSURLRequest requestWithURL:url]];
            } else {
                NSLog(@"Malformed url formed in IMEMbeddedController,"
                            @"not able to load WebView with URL String:%@",
                            self.url);
            }
        }
    }
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (void)setNetworkActivityVisible:(BOOL)visible {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:visible];
}

#pragma mark WebView delegate methods

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType {
    BOOL retValue = YES;
    NSURL *reqURL = [request URL];
    if (![reqURL.scheme isEqualToString:@"http"] && ![reqURL.scheme isEqualToString:@"https"]) {
        //non http URL, cannot proceed.. open external
        retValue = NO;
    }
    if ([IMNativeAd isITunesURL:reqURL]) {
        retValue = NO;
        NSString *ID = [IMNativeAd iTunesIDFromURL:reqURL];
        //valid ID found, open skstore..
        if (ID) {
            //open sk store
            [self openSkStore:ID];
        } else {
            //open external
            [self openExternal:reqURL];
        }
    }
    //valid URL, continue loading as usual..
    return retValue;
}

- (void)webViewDidStartLoad:(UIWebView *)_webView {
    [self setNetworkActivityVisible:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)_webView {
    if (![_webView isLoading]) {
        //all frames have finished loading..
        [self checkButtonAction];
        [self setNetworkActivityVisible:NO];
    }
}

- (void) webView:(UIWebView *)_webView didFailLoadWithError:(NSError *)error {
    NSLog(@"errorCode=%@",[error localizedDescription]);
}

#pragma mark Util methods

- (void)openSkStore:(NSString *)ID {
    SKStoreProductViewController *controller = [[SKStoreProductViewController alloc] init];
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
    [controller loadProductWithParameters:[NSDictionary dictionaryWithObject:ID forKey:SKStoreProductParameterITunesItemIdentifier] completionBlock:^(BOOL result, NSError *error) {
        NSLog(@"result:%d,eror:%@",result,[error description]);
    }];
}

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    [viewController dismissViewControllerAnimated:NO completion:NULL];
    //dismiss self as well.. nothing else left to do.
    [self dismissViewControllerAnimated:NO completion:NULL];
}

- (void)openExternal:(NSURL *)_url {
    UIApplication *app = [UIApplication sharedApplication];
    if ([app canOpenURL:_url]) {
        [app openURL:_url];
    } else {
        NSLog(@"Cannot identify URL:%@",_url);
    }
}

@end
