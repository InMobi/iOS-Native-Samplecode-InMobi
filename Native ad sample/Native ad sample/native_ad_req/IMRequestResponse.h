//
//  IMRequestResponse.h
//  Native ad sample
//
//

#import <Foundation/Foundation.h>
#import "IMAdRequestData.h"


@class IMRequestResponse;
/**
 * Delegate callbacks for success/failure of ad-format response
 */
@protocol IMRequestResponseDelegate <NSObject>

- (void)requestResponse:(IMRequestResponse *)response finishedWithData:(NSData *)data;
- (void)requestResponse:(IMRequestResponse *)response failedToLoadWithError:(NSError *)error;
@end

/**
 * Can be used to make request & obtain response for all ad-formats.
 */
@interface IMRequestResponse : NSObject

@property(nonatomic,assign) id<IMRequestResponseDelegate> delegate;
- (void)sendBannerRequest:(IMAdRequestData *)request type:(IMAdRequestType)type;

@end
