//
//  EmbeddedViewController.h
//  uigridview
//

//
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

@interface EmbeddedWebViewController : UIViewController <UIWebViewDelegate,UIActionSheetDelegate,SKStoreProductViewControllerDelegate> {
    UIWebView *webView;
    UIBarButtonItem *safari, *close, *back, *fwd, *reload;
    UIActionSheet *actionSheet;
    BOOL isFirstLoad,dismissFlag;
}

- (id)initWithURL:(NSURL *)url;

@property (nonatomic,strong) UIBarButtonItem *safari,*close,*back,*fwd,*reload;
@property(nonatomic,copy) NSURL *url;
@property(nonatomic,strong) UIWebView *webView;

@end