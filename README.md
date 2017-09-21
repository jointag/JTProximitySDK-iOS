# JTProximitySDK Documentation
Version 1.2.0

## SDK iOS

Minimum deployment target: iOS 8.0

### Dependencies
After importing the `JTProximitySDK` file into your project, from Xcode select your XCode project file and select your target. Then select **Build Phases** and in the section **Link Binary with Libraries** add the following frameworks and libraries:

```
Foundation.framework
CFNetwork.framework
CoreBluetooth.framework
CoreLocation.framework
MobileCoreServices.framework
SystemConfiguration.framework
libsqlite3.tbd
JTProximitySDK.framework
```

### Project settings
You have to put in the Info.plist of your project the following settings:

#### Location usage description

```xml
<key>NSLocationAlwaysUsageDescription</key>
<string>Location usage description</string>
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>Location usage description</string>
<key>NSLocationWhenInUseUsageDescription</key>
<string>Location usage description</string>
```

#### Transport security (**ONLY FOR ALPHA SDK VERSION**)

```xml
<key>NSAppTransportSecurity</key>
<dict>
  <key>NSAllowsArbitraryLoads</key>
  <true/>
</dict>
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

During the development process it's possible to initialize the SDK in debug mode. This way all the data will be sent to a sandbox server, preventing to put test data in production databases.

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
