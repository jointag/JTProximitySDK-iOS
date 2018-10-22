# JTProximitySDK Documentation

## Table of Contents

1. [Installation](#user-content-installation)
    1. [CocoaPods](#user-content-cocoapods)
    2. [Manual](#user-content-manual)
2. [Project settings](#user-content-project-settings)
    1. [Location usage description](#user-content-location-usage-description)
3. [Initialization](#user-content-initialization)
    1. [Simple Initialization](#user-content-simple-initialization)
    2. [Handling Notifications](#user-content-handling-notifications)
    3. [Tracking users](#user-content-tracking-users)
    4. [Disable automatic permission requests](#user-content-disable-automatic-permission-requests)
4. [Receive custom events](#user-content-receive-custom-events)

## Installation

### CocoaPods

Add `pod JTProximitySDK` to your Podfile and run `pod install`. More on [CocoaPods here](https://cocoapods.org/).

### Manual

Jointag Proximity SDK is distribute as a compiled **framework** and a **resource bundle**. To add it to your project, include the *JTProximitySDK.framework* and *JTProximitySDK.bundle* files to get started:

1. Drag and drop JTProximitySDK.framework and JTProximitySDK.bundle files into your Xcode project (remember to check *"Copy items if needed"*). It will automatically show up in your project navigator and will be added to *"Linked Frameworks and Libraries"* and *"Copy Bundle Resources"* sections in project settings.

2. Jointag Proximity SDK depends on the following Apple frameworks to work, so you should include them in your project too.
    - Foundation.framework
    - CFNetwork.framework
    - CoreBluetooth.framework
    - CoreLocation.framework
    - MobileCoreServices.framework
    - SystemConfiguration.framework
    - libsqlite3.tbd

## Project settings
You have to put in the `Info.plist` of your project the following settings:

### Location usage description

```xml
<key>NSLocationAlwaysUsageDescription</key>
<string>Location usage description</string>
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>Location usage description</string>
<key>NSLocationWhenInUseUsageDescription</key>
<string>Location usage description</string>
```

## Initialization

Place the following code inside the `UIApplicationDelegate` of your application:

### Simple Initialization

##### Objective-C

```objc
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[JTProximitySDK sharedInstance] initWithLaunchOptions:launchOptions apiKey:@"YOUR_API_KEY" apiSecret:@"YOUR_API_SECRET"];
    // Other application logics
}
```
##### Swift

```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    ProximitySDK.instance().initWithLaunchOptions(launchOptions, apiKey: "YOUR_API_KEY", apiSecret: "YOUR_API_SECRET")
    // Other application logics
    return true
}
```

### Handling Notifications

To enable the SDK to correctly send and manager advertising notifications, you must implement the following method in your `UIApplicationDelegate`:

##### Objective-C

```objc
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    if ([[JTProximitySDK sharedInstance] application:application didReceiveLocalNotification:notification]) {
        return;
    }
    // Other application logics
}
```

##### Swift

```swift
func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
    if (ProximitySDK.instance().application(application, didReceive: notification)) {
        return
    }
    // Other application logics
}
```

If you plan to support **iOS 10.0** or later, you must also add this code in your `UNUserNotificationCenterDelegate` methods:

##### Objective-C

```objc
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler __IOS_AVAILABLE(10.0) {
    if ([[JTProximitySDK sharedInstance] userNotificationCenter:center willPresentNotification:notification]) {
        completionHandler(UNNotificationPresentationOptionAlert|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound);
        return;
    }
    // Other application logics
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler __IOS_AVAILABLE(10.0) {
    if ([[JTProximitySDK sharedInstance] userNotificationCenter:center didReceiveNotificationResponse:response]) {
        completionHandler();
        return;
    }
    // Other application logics
}
```

##### Swift

```swift
@available(iOS 10.0, *)
func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    if ProximitySDK.instance().userNotificationCenter(center, willPresent: notification) {
        completionHandler([.alert, .badge, .sound])
        return
    }
    // Other application logics
}

@available(iOS 10.0, *)
func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    if ProximitySDK.instance().userNotificationCenter(center, didReceive: response) {
        completionHandler()
        return
    }
    // Other application logics
}
```

### Tracking users

The SDK associates each tracked event with the *IDFA*. If the *IDFA* is not available due to a user permission denial, the device can be identified by the *installationId*. The *installationId* identifies in particular a specific installation of the SDK in a certain app on a certain device. If the app containing the SDK is uninstalled and then installed again the *installationId* will be a different one. You can retrieve the *installationId* after the initialization of the SDK anywhere in your code with the following line:

##### Objective-C

```objc
[JTProximitySDK sharedInstance].installationId;
```

##### Swift

```swift
ProximitySDK.instance().installationId()
```

### Disable automatic permission requests

You can disable the SDK automatic location and notification permission requests during initialization by setting to NO the following properties on `JTProximitySDK.sharedInstance`:

- `promptForPushNotifications` : set to `NO` to disable the automatic request for user notifications permission
- `promptForLocationAuthorization` : set to `NO` to disable the automatic request for user location permission

Note: the properties must be set before calling any `initWithLaunchOptions:apiKey:apiSecret:` method.

## Receive custom events

You can receive custom advertising events (if configured in the backend) to integrate application-specific features by using the `customDelegate` property of `ProximitySDK` instance.

When the application user interacts with a custom-action notification, the `jtProximityDidReceiveCustomAction:` method is invoked by passing a `customAction` NSString object.
