//
//  RSAnalytics.h
//
//  Created by Ric Santos on 24/05/14.
//

#import <Foundation/Foundation.h>

#define RSAnalyticsCategoryOneshot @"CategoryOneshot"
#define RSAnalyticsCategorySystem @"CategorySystem"
#define RSAnalyticsCategorySharing @"CategorySharing"
#define RSAnalyticsCategoryIAP @"CategoryIAP"

extern NSString *const RSAnalyticsProviderFabric;
extern NSString *const RSAnalyticsProviderFacebook;
extern NSString *const RSAnalyticsProviderGoogle;

@interface RSAnalytics : NSObject

+ (RSAnalytics *)sharedInstance;

- (void)addProvider:(NSString *)provider withKey:(NSString *)key;

+ (void)logEventWithCategory:(NSString *)category action:(NSString *)action;
+ (void)logEventWithCategory:(NSString *)category action:(NSString *)action label:(NSString *)label value:(NSNumber *)value;
+ (void)logEventWithAction:(NSString *)action attributes:(NSDictionary *)attributes;

+ (void)logAppLaunched;
+ (void)logOneshotEventWithAction:(NSString *)action andUserDefaultsKey:(NSString *)userDefaultsKey;

@end
