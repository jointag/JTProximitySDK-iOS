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

extern NSString *const SDK_VERSION;
extern NSInteger const SDK_BUILD;

NS_SWIFT_NAME(ProximitySDK)
@interface JTProximitySDK : NSObject

@property (strong, nonatomic) NSString *apiKey;
@property (strong, nonatomic) NSString *apiSecret;
@property (nonatomic, assign, readonly) BOOL debug;

+ (instancetype)sharedInstance NS_SWIFT_NAME(instance());
- (void)setLogLevel:(JTPLogLevel)logLevel;
- (void)initWithLaunchOptions:(NSDictionary *)launchOptions apiKey:(NSString *)apiKey apiSecret:(NSString *)apiSecret;
- (void)initWithLaunchOptions:(NSDictionary *)launchOptions apiKey:(NSString *)apiKey apiSecret:(NSString *)apiSecret debug:(BOOL)debug;

// Pre iOS 10
- (BOOL)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification;

// iOS 10 only
- (BOOL)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification __IOS_AVAILABLE(10.0);
- (BOOL)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response __IOS_AVAILABLE(10.0);

- (NSString *)installationId;

@end
