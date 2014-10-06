//
//  NativeAdHolderView.m
//

#import "NativeAdHolderView.h"
#import <QuartzCore/QuartzCore.h>

@implementation NativeAdHolderView
@synthesize nativeAd;

- (void)awakeFromNib {
    
    [self prepare];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self prepare];
        
    }
    return self;
}
- (void)prepare {
    UIColor *color = [UIColor whiteColor];
    //[UIColor colorWithRed:32/255.0 green:95/255.0 blue:13/255.0 alpha:1];
    imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 58, 58)];
    imgView.layer.masksToBounds = YES;
    imgView.layer.cornerRadius = 4.0;
    [self addSubview:imgView];
    //[imgView setImage:[UIImage imageNamed:@"tictactoe_57.png"]];
    sponsored = [[UILabel alloc] initWithFrame:CGRectMake(240, 0, 80, 20)];
    sponsored.font = [UIFont fontWithName:@"Marker Felt" size:12];
    sponsored.backgroundColor = [UIColor clearColor];
    sponsored.textColor = color;
    
    [self addSubview:sponsored];
    
    title = [[UILabel alloc] initWithFrame:CGRectMake(78, 20, self.frame.size.width - 88, 20)];
    title.font = [UIFont fontWithName:@"Marker Felt" size:17];
    title.backgroundColor = [UIColor clearColor];
    title.textColor = color;
    //[UIColor colorWithRed:32/255.0 green:95/255.0 blue:13/255.0 alpha:1];
    
    [self addSubview:title]; //title.text = @"This is a title";
    
    //rating
    star1 = [[UIImageView alloc] initWithFrame:CGRectMake(78 + 0* 22, 30, 18, 18)];
    star2 = [[UIImageView alloc] initWithFrame:CGRectMake(78 + 1* 22, 30, 18, 18)];
    star3 = [[UIImageView alloc] initWithFrame:CGRectMake(78 + 2* 22, 30, 18, 18)];
    star4 = [[UIImageView alloc] initWithFrame:CGRectMake(78 + 3* 22, 30, 18, 18)];
    star5 = [[UIImageView alloc] initWithFrame:CGRectMake(78 + 4* 22, 30, 18, 18)];
    [self addSubview:star1];
    [self addSubview:star2];
    [self addSubview:star3];
    [self addSubview:star4];
    [self addSubview:star5];

    desc = [[UILabel alloc] initWithFrame:CGRectMake(78, 70, self.frame.size.width - 88, 45)];
    desc.font = [UIFont fontWithName:@"Marker Felt" size:12]; desc.numberOfLines = 3;
    desc.textColor = title.textColor;
    desc.backgroundColor = title.backgroundColor;
    //desc.text = @"This is a description.This is a description.This is a description.This is a description.";
    download = [[UIButton alloc] initWithFrame:CGRectMake(205, 42,90 ,25 )];
    [download setBackgroundColor:color];
    download.titleLabel.font =[UIFont fontWithName:@"Marker Felt" size:20];
    [download setTitle:@"Download" forState:UIControlStateNormal];
    download.alpha = 0;
    [download addTarget:self action:@selector(download) forControlEvents:UIControlEventTouchUpInside];
    [download setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self addSubview:download];
    [self addSubview:desc];
    //[nativeAd handleClick:nil];
}

- (void)prepareStarRating:(float)rating {
    if (rating > 1.0) {
        rating -= 1.0;
        [star1 setImage:[UIImage imageNamed:@"gold.png"]];
        if (rating > 0.5) {
            [star2 setImage:[UIImage imageNamed:@"gold.png"]];
            rating -= 1.0;
            if (rating > 0.5) {
               [star3 setImage:[UIImage imageNamed:@"gold.png"]];
                rating -= 1.0;
                if (rating > 0.5) {
                    [star4 setImage:[UIImage imageNamed:@"gold.png"]];
                    rating -= 1.0;
                    if (rating > 0.5) {
                        [star5 setImage:[UIImage imageNamed:@"gold.png"]];
                    } else {
                        if (rating > 0) {
                            [star5 setImage:[UIImage imageNamed:@"gold-half.png"]];
                        }
                    }
                } else {
                    if (rating > 0) {
                        [star4 setImage:[UIImage imageNamed:@"gold-half.png"]];
                    }
                }
            } else {
                if (rating > 0) {
                    [star3 setImage:[UIImage imageNamed:@"gold-half.png"]];
                }
            }
        } else {
            if (rating > 0) {
                [star2 setImage:[UIImage imageNamed:@"gold-half.png"]];
            }
        }
    } else {
        //[star1 setImage:[UIImage imageNamed:@"gold-half.png"]];
    }
}

- (void)download {
    [nativeAd countClick:nil];
}

#pragma mark native ads delegate
- (void)nativeAd:(IMNativeAd *)nativeAd failedToLoadWithError:(NSError *)error {
    NSLog(@"native ad failed - %@",[error description]);
}
- (void)nativeAdFinishedLoading:(IMNativeAd *)native {
    NSLog(@"native ad finished loading");
    //[native populateNativeAdMetadata];
    //NSLog(@"is valid json:%@",[json description]);
    NativeAdUIData *metadata = nativeAd.metadata;
    
    if (metadata) {
        dispatch_async(dispatch_get_main_queue(), ^{
            title.text = metadata.title;
            desc.text = metadata.desc;
            download.alpha = 1.0;
            sponsored.text = @"Sponsored";
            [self prepareStarRating:[metadata.rating floatValue]];
            [native countImpression];
        });
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSError *e = nil;
            NSData *imgData = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:metadata.img_url]] returningResponse:nil error:&e];
            if (imgData && !e) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    imgView.image = [UIImage imageWithData:imgData];
                    
                });
            }
        });
    }
    //[native attachToView:self];
    //[native handleClick:[NSDictionary dictionaryWithObject:@"object" forKey:@"key"]];
    
}

- (void)setHidden:(BOOL)hidden {
    NSLog(@"set hidden:%d", hidden);
    [super setHidden:hidden];
    if (!hidden) {
        //[nativeAd loadAd];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
