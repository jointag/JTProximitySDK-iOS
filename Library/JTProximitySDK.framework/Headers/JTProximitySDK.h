//
//  JTProximitySDK.h
//  JTProximitySDK
//
//  Created by Michele Ambrosi on 06/07/17.
//  Copyright © 2017 Jointag Srl. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000

#import <UserNotifications/UserNotifications.h>

#endif
typedef NS_ENUM(NSInteger, JTPLogLevel) {
    JTPLogLevelVerbose,
    JTPLogLevelDebug,
    JTPLogLevelInfo,
    JTPLogLevelWarn,
    JTPLogLevelError
};
extern NSString * _Nonnull const SDK_VERSION;
extern NSInteger const SDK_BUILD;

@protocol JTProximityCustomDelegate<NSObject>

- (void)jtProximityDidReceiveCustomAction:(nullable NSString *)customAction;

@end

NS_SWIFT_NAME(ProximitySDK)
@interface JTProximitySDK : NSObject

@property (readonly, nonatomic, nullable) NSString *apiKey;

@property (readonly, nonatomic, nullable) NSString *apiSecret;

@property (readonly, nonatomic) BOOL debug;

@property (assign, nonatomic) BOOL promptForPushNotifications;

@property (assign, nonatomic) BOOL promptForLocationAuthorization;

@property (weak, nonatomic, nullable) id<JTProximityCustomDelegate> customDelegate;

+ (nonnull instancetype)sharedInstance NS_SWIFT_NAME(instance());

- (void)setLogLevel:(JTPLogLevel)logLevel;

- (void)initWithLaunchOptions:(nullable NSDictionary *)launchOptions apiKey:(nonnull NSString *)apiKey apiSecret:(nonnull NSString *)apiSecret;

- (void)initWithLaunchOptions:(nullable NSDictionary *)launchOptions apiKey:(nonnull NSString *)apiKey apiSecret:(nonnull NSString *)apiSecret debug:(BOOL)debug;

// Pre iOS 10
- (BOOL)application:(nonnull UIApplication *)application didReceiveLocalNotification:(nonnull UILocalNotification *)notification;

// iOS 10 only
- (BOOL)userNotificationCenter:(nonnull UNUserNotificationCenter *)center willPresentNotification:(nonnull UNNotification *)notification __IOS_AVAILABLE(10.0);

- (BOOL)userNotificationCenter:(nonnull UNUserNotificationCenter *)center didReceiveNotificationResponse:(nonnull UNNotificationResponse *)response __IOS_AVAILABLE(10.0);

- (nonnull NSString *)installationId;

- (nullable NSString *)advertisingId;

- (void)requestLocationAuthorization;

@end
