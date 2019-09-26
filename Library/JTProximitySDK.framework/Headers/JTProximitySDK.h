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

/**
Automatically request Notifications Authorization on start

Default to YES
*/
@property (assign, nonatomic) BOOL promptForPushNotifications;

/**
 Automatically request Location Authorization on start

 Default to YES
 */
@property (assign, nonatomic) BOOL promptForLocationAuthorization;

/**
 Enable CMP support for GDPR compliance.

 @note MUST be set before calling initWithLaunchOptions:apiKey:apiSecret:
 */
@property (assign, nonatomic) BOOL cmpEnabled;

/**
 Delegate for custom advertising actions

 @see JTProximityCustomDelegate
 */
@property (weak, nonatomic, nullable) id<JTProximityCustomDelegate> customDelegate;


/**
 UISceneDelegate for iOS 13
 */

@property (weak, nonatomic, nullable) id<UIWindowSceneDelegate> windowSceneDelegate API_AVAILABLE(ios(13.0));


/**
 Singleton instance for JTProximitySDK
 */
+ (nonnull instancetype)sharedInstance NS_SWIFT_NAME(instance());

- (void)setLogLevel:(JTPLogLevel)logLevel;

/**
 Initialization method

 Must be called from UIApplicationDelegate's application:didFinishLaunchingWithOptions: method
 */
- (void)initWithLaunchOptions:(nullable NSDictionary *)launchOptions apiKey:(nonnull NSString *)apiKey apiSecret:(nonnull NSString *)apiSecret;

// Pre iOS 10
- (BOOL)application:(nonnull UIApplication *)application didReceiveLocalNotification:(nonnull UILocalNotification *)notification;

// iOS 10 only
- (BOOL)userNotificationCenter:(nonnull UNUserNotificationCenter *)center willPresentNotification:(nonnull UNNotification *)notification __IOS_AVAILABLE(10.0);

- (BOOL)userNotificationCenter:(nonnull UNUserNotificationCenter *)center didReceiveNotificationResponse:(nonnull UNNotificationResponse *)response __IOS_AVAILABLE(10.0);

/**
 Unique installation identifier
 */
- (nonnull NSString *)installationId;

/**
 Platform-specific advertising identifier
 */
- (nullable NSString *)advertisingId;

/**
 Manually request for Location Authorization.

 @note This method can be used to manually request Location Authorization if the
 automatic request has been disabled.

 @see promptForLocationAuthorization
 */
- (void)requestLocationAuthorization;

/**
 Set the GDPR consent manually for the current installation.
 This method is intended as a replacement for the implementation of a IAB-compatible CMP platform

 @note cmpEnabled must be set to YES before using this method
 @see cmpEnabled
 */
- (void)setGDPRConsent:(BOOL)consent forVendor:(int)vendorId;

/**
 Get current installation GDPR consent status.

 @return true if the user consent has been given manually, or through a
 IAB-compatible CMP platform if present and the user is subjected to GDPR
 regulation.
 */
- (BOOL)getGDPRConsentForVendor:(int) vendorId;

@end


