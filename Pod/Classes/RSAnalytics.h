//
//  RSAnalytics.h
//
//  Created by Ric Santos on 24/05/14.
//

#import <Foundation/Foundation.h>

#define RSAnalyticsCategoryOneshot @"CategoryOneshot"
#define RSAnalyticsCategorySystem @"CategorySystem"
#define RSAnalyticsCategorySharing @"CategorySharing"
#define RSAnalyticsCategoryAppRadio @"CategoryAppRadio"
#define RSAnalyticsCategoryIAP @"CategoryIAP"

@interface RSAnalytics : NSObject

+ (void)setup;

+ (void)logEventWithCategory:(NSString *)category action:(NSString *)action;
+ (void)logEventWithCategory:(NSString *)category action:(NSString *)action label:(NSString *)label value:(NSNumber *)value;

+ (void)logAppLaunched;
+ (void)logUserHasAppRadio;

@end
