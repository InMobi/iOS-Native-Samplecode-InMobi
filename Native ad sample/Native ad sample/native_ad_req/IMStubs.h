//
//  IMStubs.h
//  Native ad sample
//
// This class is split into various data structures,
// based on the JSON request format of InMobi API 2.0
// Visit https://www.inmobi.com/support/art/26555436/22465648/api-2-0-integration-guidelines/


#import <Foundation/Foundation.h>


/**
 * Gender type description. Use this object to send user gender info.
 */
typedef enum {
    IMGenderMale,
    IMGenderFemale,
    IMGenderNone
} IMGender;

/**
 * Internal object, used to store property Id
 */
@interface IMPropertyObject : NSObject
/*
 * The Property ID, as obtained from Inmobi.
 */
@property(nonatomic,copy) NSString *propertyId;
@end

@class IMBannerObject;
/*
 * This class stores the 'imp' object, as part of the InMobi API 2.0
 */
@interface IMImpressionObject : NSObject

@property(nonatomic,assign) int noOfAds;
@property(nonatomic,assign) BOOL isInterstitial;
@property(nonatomic,copy) NSString *displayManager;
@property(nonatomic,copy) NSString *displayManagerVersion;
@property(nonatomic,retain) IMBannerObject *bannerObj;

@end
@class IMGeoObject;
/*
 * This class stores the 'device' object, as part of InMobi API 2.0
 */
@interface IMDeviceObject : NSObject

@property(nonatomic,copy) NSString *carrierIP;
@property(nonatomic,copy) NSString *userAgent;
@property(nonatomic,copy) NSString *IDFA,*IDV;
@property(nonatomic,assign) int adt;
@property(nonatomic,retain) IMGeoObject *geoObj;
@end

/*
 * This class stores the 'geo' object, within the 'device' object.
 */
@interface IMGeoObject : NSObject
@property(nonatomic,assign) double lat,lon;
@property(nonatomic,assign) int accu;
@end

@class IMDataObject;
/*
 * This class stores the 'user' object, as part of InMobi API 2.0
 */
@interface IMUserObject : NSObject

@property(nonatomic,assign) int yob;
@property(nonatomic,assign) IMGender gender;
@property(nonatomic,retain) IMDataObject *dataObj;
@end
/*
 * This class store the required banner info, as part of the 'imp' object
 */
@interface IMBannerObject : NSObject

@property(nonatomic,assign) int adSize;
@property(nonatomic,copy) NSString *position;
@end


@class IMUserSegmentObject;
/*
 * This class stores the 'data' object, within the 'user' object
 */
@interface IMDataObject : NSObject

@property(nonatomic,assign) int ID;
@property(nonatomic,copy) NSString *name;
@property(nonatomic,retain) IMUserSegmentObject *segmentObj;
@end

/*
 * This class stores the 'segment' object, within the 'data' object
 */
@interface IMUserSegmentObject : NSObject
@property(nonatomic,retain) NSArray *userSegmentArray;
@end