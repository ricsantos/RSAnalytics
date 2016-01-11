# RSAnalytics
iOS Analytics event wrapper for Google Analytics, Fabric and Facebook.

## Installation

Install via CocoaPods:

	pod 'RSAnalytics'

## Setup

At app launch, typically in the `UIApplicationDelegate application:didFinishLaunchingWithOptions` method, add the required providers to the `RSAnalytics sharedInstance`:

    [[RSAnalytics sharedInstance] addProvider:RSAnalyticsProviderGoogle withKey:@"UA-12345678-9"];
    [[RSAnalytics sharedInstance] addProvider:RSAnalyticsProviderFabric withKey:nil];
    [[RSAnalytics sharedInstance] addProvider:RSAnalyticsProviderFacebook withKey:nil];

Optionally, log the app launch:

    [RSAnalytics logAppLaunched];

## Event Logging

Log regular events with a category (String) and an (optional) action (String):

	[RSAnalytics logEventWithCategory:@"Main menu" action:@"Close button tapped"];

Oneshot events will only ever be logged once per app install. User defaults are used to record that the event has been logged. They use the event category `RSAnalyticsCategoryOneshot`.

    [RSAnalytics logOneshotEventWithAction:@"Pro User" andUserDefaultsKey:@"AnalyticsHaveLoggedUserIsPro"];

