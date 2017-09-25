//
//  JTAppDelegate.m
//  JTProximitySDK
//
//  Created by Marco Fraccaroli on 09/25/2017.
//  Copyright (c) 2017 Marco Fraccaroli. All rights reserved.
//

#import "JTAppDelegate.h"

@import JTProximitySDK;
@import UserNotifications;

@interface JTAppDelegate()<UNUserNotificationCenterDelegate>

@end

@implementation JTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[JTProximitySDK sharedInstance] setLogLevel:JTPLogLevelVerbose];
    [[JTProximitySDK sharedInstance] initWithLaunchOptions:launchOptions apiKey:@"598322107a5b646fd1785fd9" apiSecret:@"qxUe5vECy5DPeXmeFhPHOerVYdVDg34/StHkV3IPNdA927v4" debug:YES];
    if (@available(iOS 10.0, *)) {
        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    }
    // Override point for customization after application launch.
    return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    if ([[JTProximitySDK sharedInstance] application:application didReceiveLocalNotification:notification]) {
        return;
    }
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler __IOS_AVAILABLE(10.0) {
    if ([[JTProximitySDK sharedInstance] userNotificationCenter:center willPresentNotification:notification]) {
        completionHandler(UNNotificationPresentationOptionAlert|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound);
        return;
    }
    completionHandler(UNNotificationPresentationOptionAlert);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler __IOS_AVAILABLE(10.0) {
    if ([[JTProximitySDK sharedInstance] userNotificationCenter:center didReceiveNotificationResponse:response]) {

    }
    completionHandler();
}

@end
