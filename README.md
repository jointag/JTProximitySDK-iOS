# JTProximitySDK Documentation

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

### Project settings
You have to put in the `Info.plist` of your project the following settings:

#### Location usage description

```xml
<key>NSLocationAlwaysUsageDescription</key>
<string>Location usage description</string>
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>Location usage description</string>
<key>NSLocationWhenInUseUsageDescription</key>
<string>Location usage description</string>
```

### Initialization

Place the following code inside the `UIApplicationDelegate` of your application:

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

### Debug Mode

During the development process it's possible to initialize the SDK in debug mode. This way all the data will be sent to a sandbox server, preventing to put test data in production databases.

Before enabling the debug mode, you must add the the following setting to your application `Info.plist` file:

```xml
<key>NSAppTransportSecurity</key>
<dict>
  <key>NSAllowsArbitraryLoads</key>
  <true/>
</dict>
```

To initialize the SDK in debug mode please use the following lines of code instead of the previous ones:

##### Objective-C

```objc
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[JTProximitySDK sharedInstance] initWithLaunchOptions:launchOptions apiKey:@"YOUR_API_KEY" apiSecret:@"YOUR_API_SECRET" debug:YES];
    // Other application logics
}
```

##### Swift

```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    ProximitySDK.instance().initWithLaunchOptions(launchOptions, apiKey: "YOUR_API_KEY", apiSecret: "YOUR_API_SECRET", debug: true)
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

## Receive custom events

You can receive custom advertising events (if configured in the backend) to integrate application-specific features by using the `customDelegate` property of `ProximitySDK` instance.

When the application user interacts with a custom-action notification, the `jtProximityDidReceiveCustomAction:` method is invoked by passing a `customAction` NSString object.
