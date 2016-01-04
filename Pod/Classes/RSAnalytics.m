//
//  RSAnalytics.m
//
//  Created by Ric Santos on 24/05/14.
//

#import "RSAnalytics.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@implementation RSAnalytics

+ (void)setup
{
#ifdef DEBUG
    return;
#endif
    
    [GAI sharedInstance].trackUncaughtExceptions = NO;
    [GAI sharedInstance].dispatchInterval = 120;
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelWarning];
    [[GAI sharedInstance] trackerWithTrackingId:@"UA-43258429-5"];
    
    [Fabric with:@[CrashlyticsKit]];
}

+ (void)logEventWithCategory:(NSString *)category action:(NSString *)action
{
    [RSAnalytics logEventWithCategory:category action:action label:nil value:nil];
}

+ (void)logEventWithCategory:(NSString *)category action:(NSString *)action label:(NSString *)label value:(NSNumber *)value
{
 
#ifdef DEBUG
    NSLog(@"category: %@, action: %@, label: %@ %@", category, action, label, value);
    return;
#endif
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:category
                                                          action:action
                                                           label:label
                                                           value:nil] build]];
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    if (label) {
        attributes[@"label"] = label;
    }
    if (value) {
        attributes[@"value"] = value;
    }
    [Answers logCustomEventWithName:action
                   customAttributes:attributes];
    
    [FBSDKAppEvents logEvent:action];
}

+ (void)logAppLaunched
{
    [self logEventWithCategory:RSAnalyticsCategorySystem action:@"App Launched"];
    
    BOOL haveLoggedEvent = [[NSUserDefaults standardUserDefaults] boolForKey:@"AnalyticsHaveLoggedAppInstall"];
    if (!haveLoggedEvent) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"AnalyticsHaveLoggedAppInstall"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self logEventWithCategory:RSAnalyticsCategoryOneshot action:@"App Installed"];
    }
    
    [FBSDKAppEvents activateApp];
}

+ (void)logUserHasAppRadio
{
    BOOL haveLoggedEvent = [[NSUserDefaults standardUserDefaults] boolForKey:@"AnalyticsHaveLoggedUserHasAppRadio"];
    if (!haveLoggedEvent) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"AnalyticsHaveLoggedUserHasAppRadio"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self logEventWithCategory:RSAnalyticsCategoryOneshot action:@"AppRadio User"];
    }
}

@end
