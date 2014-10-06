//
//  IMRequestResponse.m
//  Native ad sample
//

//

#import "IMRequestResponse.h"
#import "IMGTMBase64Private.h"
@implementation IMRequestResponse
@synthesize delegate;

- (NSDictionary *)generateRequestDictionary:(IMAdRequestData *)request type:(IMAdRequestType)type {
    NSMutableDictionary *mainDictionary = [[NSMutableDictionary alloc] init];
    
    //request format
    if (type != IMAdRequestTypeNative) {
        [mainDictionary setObject:@"axml" forKey:@"responseformat"];
    } else {
        [mainDictionary setObject:@"native" forKey:@"responseformat"];
    }

    
    //site format
    NSDictionary *siteDictionary = @{@"id": request.propertyObj.propertyId};
    [mainDictionary setObject:siteDictionary forKey:@"site"];
    
    NSMutableDictionary *bannerDictionary = [[NSMutableDictionary alloc] init];
    
    NSString *pos = request.impressionObj.bannerObj.position;
    if (pos != nil) {
        [bannerDictionary setObject:pos forKey:@"pos"];
    }
    if (type != IMAdRequestTypeNative) {
        [bannerDictionary setObject:[NSNumber numberWithInt:request.impressionObj.bannerObj.adSize] forKey:@"adsize"];
    }
    
    NSMutableDictionary *impressionDictionary = [[NSMutableDictionary alloc] init];
    [impressionDictionary setObject:[NSNumber numberWithInt:request.impressionObj.noOfAds] forKey:@"ads"];
    NSString *displayMgr = request.impressionObj.displayManager;
    if (displayMgr) {
        [impressionDictionary setObject:displayMgr forKey:@"displaymanager"];
    }
    NSString *displayMgrVer = request.impressionObj.displayManagerVersion;
    if (displayMgrVer) {
        [impressionDictionary setObject:displayMgrVer forKey:@"displaymanagerver"];
    }
    //adtype=int
    if (type == IMAdRequestTypeInterstitial) {
        [impressionDictionary setObject:@"int" forKey:@"adtype"];
    }
    // impression object is an array
    NSArray *impArray = [NSArray arrayWithObject:impressionDictionary];
    [mainDictionary setObject:impArray forKey:@"imp"];
    
    NSMutableDictionary *userDictionary = [[NSMutableDictionary alloc] init];
    IMUserObject *userobj = request.userObj;
    if (userobj.yob > 0) {
        [userDictionary setObject:[NSNumber numberWithInt:userobj.yob] forKey:@"yob"];
    }
    if (userobj.gender != IMGenderNone) {
        if (userobj.gender == IMGenderMale) {
            [userDictionary setObject:@"M" forKey:@"gender"];
        } else if(userobj.gender == IMGenderFemale) {
            [userDictionary setObject:@"F" forKey:@"gender"];
        }
    }
    NSMutableDictionary *dataDictionary = [[NSMutableDictionary alloc] init];
    IMDataObject *data = userobj.dataObj;
    if (data.ID > 0) {
        [dataDictionary setObject:[NSString stringWithFormat:@"%d",data.ID] forKey:@"id"];
    }
    if (data.name) {
        [dataDictionary setObject:data.name forKey:@"name"];
    }
    if (data.segmentObj) {
        [dataDictionary setObject:data.segmentObj.userSegmentArray forKey:@"segment"];
    }
    NSArray *dataArray = [NSArray arrayWithObject:dataDictionary];
    [userDictionary setObject:dataArray forKey:@"data"];
    [mainDictionary setObject:userDictionary forKey:@"user"];
    
    NSMutableDictionary *deviceDictionary = [[NSMutableDictionary alloc] init];
    
    [deviceDictionary setObject:request.deviceObj.carrierIP forKey:@"ip"];
    [deviceDictionary setObject:request.deviceObj.userAgent forKey:@"ua"];
    [deviceDictionary setObject:request.deviceObj.IDFA forKey:@"ida"];
    [deviceDictionary setObject:request.deviceObj.IDV forKey:@"idv"];
    [deviceDictionary setObject:[NSNumber numberWithInt:request.deviceObj.adt] forKey:@"adt"];
    
    IMGeoObject *geo = request.deviceObj.geoObj;
    if (geo.accu != 0) {
        NSMutableDictionary *geoDictionary = [[NSMutableDictionary alloc] init];
        [geoDictionary setValue:[NSString stringWithFormat:@"%f",geo.lat] forKey:@"lat"];
        [geoDictionary setValue:[NSString stringWithFormat:@"%f",geo.lon] forKey:@"lon"];
        [geoDictionary setValue:[NSString stringWithFormat:@"%d",geo.accu] forKey:@"accu"];
        
        [deviceDictionary setObject:geoDictionary forKey:@"geo"];
    }
    
    
    [mainDictionary setObject:deviceDictionary forKey:@"device"];
    
    return mainDictionary;
}

- (NSData *)serializeObject:(id)inObject error:(NSError **)outError {
    return  [NSJSONSerialization dataWithJSONObject:inObject options:0 error:outError];
}

- (void)sendSuccessCallback:(NSData *)data {
    if (delegate && [delegate respondsToSelector:@selector(requestResponse:finishedWithData:)]) {
        [delegate requestResponse:self finishedWithData:data];
    }
}
- (void)sendFailureCallback:(NSError *)error {
    if (delegate && [delegate respondsToSelector:@selector(requestResponse:failedToLoadWithError:)]) {
        [delegate requestResponse:self failedToLoadWithError:error];
    }
}

- (void)sendBannerRequest:(IMAdRequestData *)request type:(IMAdRequestType)type {
    
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSDictionary *requestDictionary = [self generateRequestDictionary:request type:type];
        if (requestDictionary) {
            NSData *postData = [self serializeObject:requestDictionary error:nil];
            //NSLog(@"%@",[[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding]);
            NSError *e = nil;
            NSMutableURLRequest *urlReq = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:IM_AD_SERVER_URL]];
            [urlReq setTimeoutInterval:60];
            urlReq.HTTPMethod = @"POST";
            urlReq.HTTPBody = postData;
            [urlReq setValue:@"application/json" forHTTPHeaderField:@"content-type"];
            [urlReq setValue:request.deviceObj.carrierIP forHTTPHeaderField:@"x-forwarded-for"];
            [urlReq setValue:request.deviceObj.userAgent forHTTPHeaderField:@"user-agent"];
            NSHTTPURLResponse *urlResponse = nil;
            NSData *responseData = [NSURLConnection sendSynchronousRequest:urlReq returningResponse:&urlResponse error:&e];
            long statusCode = [urlResponse statusCode];
            if (responseData && !e && statusCode == 200) {
                [self sendSuccessCallback:responseData];
            } else {
                if (!e) {
                    
                    e = [NSError errorWithDomain:@"Inmobi" code:4 userInfo:@{NSLocalizedDescriptionKey: [NSString stringWithFormat:@"Request failed with statusCode=%ld",statusCode]}];
                }
                [self sendFailureCallback:e];
            }

        } else {
            [self sendFailureCallback:[NSError errorWithDomain:@"Inmobi" code:3 userInfo:@{NSLocalizedDescriptionKey: @"Couldn't create a proper JSON request object."}]];
        }
            });
}

@end
