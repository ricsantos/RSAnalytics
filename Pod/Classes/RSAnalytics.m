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

NSString *const RSAnalyticsProviderFabric = @"RSAnalyticsProviderFabric";
NSString *const RSAnalyticsProviderFacebook = @"RSAnalyticsProviderFacebook";
NSString *const RSAnalyticsProviderGoogle = @"RSAnalyticsProviderGoogle";

@interface RSAnalytics ()

@property (nonatomic, strong) NSMutableArray *providers;

@end

@implementation RSAnalytics

+ (RSAnalytics *)sharedInstance {
    static RSAnalytics *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (instancetype)init {
    self = [super init];
    
    self.providers = [NSMutableArray array];
    
    return self;
}

- (void)addProvider:(NSString *)provider withKey:(NSString *)key {
    if (provider == RSAnalyticsProviderFabric) {
        [Fabric with:@[CrashlyticsKit]];
        
    } else if (provider == RSAnalyticsProviderFacebook) {
        // no init required
        
    } else if (provider == RSAnalyticsProviderGoogle) {
        [GAI sharedInstance].trackUncaughtExceptions = NO;
        [GAI sharedInstance].dispatchInterval = 120;
        [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelWarning];
        [[GAI sharedInstance] trackerWithTrackingId:key];
        
    } else {
        NSLog(@"ERROR: No valid provider supplied.");
        return;
    }

    [self.providers addObject:provider];
}

+ (void)logEventWithCategory:(NSString *)category action:(NSString *)action {
    [RSAnalytics logEventWithCategory:category action:action label:nil value:nil];
}

+ (void)logEventWithCategory:(NSString *)category action:(NSString *)action label:(NSString *)label value:(NSNumber *)value {
    [[self sharedInstance] logEventWithCategory:category action:action label:label value:value];
}

- (void)logEventWithCategory:(NSString *)category action:(NSString *)action label:(NSString *)label value:(NSNumber *)value {
    NSLog(@"category: %@, action: %@, label: %@ %@", category, action, label, value);
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    if (label) {
        attributes[@"label"] = label;
    }
    if (value) {
        attributes[@"value"] = value;
    }

    if ([self.providers containsObject:RSAnalyticsProviderFabric]) {
        [Answers logCustomEventWithName:action
                       customAttributes:attributes];
    }

    if ([self.providers containsObject:RSAnalyticsProviderGoogle]) {
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:category
                                                              action:action
                                                               label:label
                                                               value:nil] build]];
    }
    
    if ([self.providers containsObject:RSAnalyticsProviderFacebook]) {
        [FBSDKAppEvents logEvent:action];
    }
}

+ (void)logAppLaunched {
    [self logEventWithCategory:RSAnalyticsCategorySystem action:@"App Launched"];
    
    BOOL haveLoggedEvent = [[NSUserDefaults standardUserDefaults] boolForKey:@"AnalyticsHaveLoggedAppInstall"];
    if (!haveLoggedEvent) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"AnalyticsHaveLoggedAppInstall"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self logEventWithCategory:RSAnalyticsCategoryOneshot action:@"App Installed"];
    }
    
    [FBSDKAppEvents activateApp];
}

+ (void)logOneshotEventWithAction:(NSString *)action andUserDefaultsKey:(NSString *)userDefaultsKey {
    BOOL haveLoggedEvent = [[NSUserDefaults standardUserDefaults] boolForKey:userDefaultsKey];
    if (!haveLoggedEvent) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:userDefaultsKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self logEventWithCategory:RSAnalyticsCategoryOneshot action:action];
    }
}

@end
