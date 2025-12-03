//
//  JTAppDelegate.m
//  JTProximitySDK
//
//  Created by Marco Fraccaroli on 09/25/2017.
//  Copyright (c) 2020 Jointag S.r.l. All rights reserved.
//

#import "JTAppDelegate.h"
#import <JTProximitySDK/JTProximitySDK.h>

@import UserNotifications;

@interface JTAppDelegate()<UNUserNotificationCenterDelegate,JTProximityCustomDelegate>

@end

@implementation JTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Enable gallery notifications support
    [JTProximitySDK.sharedInstance setContentExtensionCategories:JTContentExtensionCategoryGallery];
    [JTProximitySDK.sharedInstance setLogLevel:JTPLogLevelVerbose];
    [JTProximitySDK.sharedInstance setCustomDelegate:self];
    [JTProximitySDK.sharedInstance setExternalUserId:@"some-external-id"];
    [JTProximitySDK.sharedInstance initWithLaunchOptions:launchOptions apiKey:@"598322107a5b646fd1785fd9" apiSecret:@"qxUe5vECy5DPeXmeFhPHOerVYdVDg34/StHkV3IPNdA927v4"];
    [JTProximitySDK.sharedInstance sendTag:@"blue" forKey:@"color"];
    [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    return YES;
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

- (void)jtProximityDidReceiveCustomAction:(NSString *)customAction {
    NSLog(@"Received custom action %@", customAction);
}

@end
