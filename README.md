# JTProximitySDK Documentation

## Table of Contents

1. [Installation](#user-content-installation)
    1. [Installation using CocoaPods](#installation-using-cocoapods)
    2. [Manual Installation](#manual-installation)
2. [Permissions and Settings](#permissions-and-settings)
    1. [Important Notice](#important-notice)
    2. [User Tracking Permission](#user-tracking-permission)
    3. [Notifications Permission](#notifications-permission)
    4. [Location Permission](#location-permission)
3. [Initialization](#user-content-initialization)
    1. [Simple Initialization](#user-content-simple-initialization)
    2. [iOS 13 Scenes](#ios-13-scenes)
    3. [Handling Notifications](#user-content-handling-notifications)
4. [Advanced Configurations](#advanced-configurations)
    1. [Tracking User Identifiers](#user-content-tracking-user-identifiers)
    2. [Data Tags](#user-content-data-tags)
    2. [Programmatically Disable Advertising](#programmatically-disable-advertising)
    3. [Receive custom events](#user-content-receive-custom-events)
4. [User Consent and GDPR](#user-consent-and-gdpr)
    1. [Enabling the Consent Flow support](#user-consent-enabling-the-consent-flow-support)
    2. [Using Consent Management Platform](#user-consent-using-consent-management-platform)
    3. [Implementing a Custom Consent Flow](#user-consent-implementing-a-custom-consent-flow)

## Installation

### Installation using CocoaPods

1.  Install or update `CocoaPods` to version **1.9.0 or later**, which is
    essential for proper support of the new *xcframework* format.
2.  In your terminal execute `pod init` from your project directory, if the
    project is not already pod-enabled
3.  Edit your project Podfile and add `pod 'JTProximitySDK'` to your main
    application target
4.  In your terminal execute `pod install` from your project directory.

eg:

```ruby
target 'MyApp' do
  use_frameworks!
  pod 'JTProximitySDK'
end
```

More on [CocoaPods here](https://cocoapods.org/).

### Manual Installation

Jointag Proximity SDK is distribute as a compiled **xcframework** with binaries
for both device and simulator. To add it to your project, include the
*JTProximitySDK.xcframework* as follow:

1. Drag and drop the JTProximitySDK.xcframework framework folder into your Xcode
project (remember to check *"Copy items if needed"*).

2. Make sure the JTProximitySDK.xcframework appears in the **Frameworks,
Libraries, and Embedded Content** section of the **General** tab of your project
and that the *embed* mode is **Embed & Sign**

## Permissions and Settings

The following section describes the permissions required by the SDK, along with
the necessary keys that must be added to the application Info.plist file.

### Important Notice

Starting with SDK version **1.12.0**, all the required permissions are no longer
automatically requested when starting the SDK, but must be requested from the
user by the application itself. To simplify this process, the SDK exposes
helper methods to request them (such methods are presented below).

### User Tracking Permission

As describe [here](user-tracking-usage-description), user tracking
permission requires the following key to be added to the application
**Info.plist** file:

```xml
<key>NSUserTrackingUsageDescription</key>
<string>User Tracking Usage Description</string>
```

A helper method is provided to easily request tracking authorization:

**Swift**

```swift
Proximity.shared.requestTrackingAuthorization()
```

**Objective-C**

```objc
[JTProximitySDK.sharedInstance requestTrackingAuthorization];
```

### Notifications Permission

A helper method is provided to easily request notification authorization:

**Swift**

```swift
Proximity.shared.requestNotificationAuthorization()
```

**Objective-C**

```objc
[JTProximitySDK.sharedInstance requestNotificationAuthorization];
```

### Location Permission

As described [here](location-usage-description), user location permission
requires the following keys to be added to the application **Info.plist**
file:

```xml
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>Location usage description</string>
<key>NSLocationWhenInUseUsageDescription</key>
<string>Location usage description</string>
```

A helper method is provided to easily request location authorization:

**Objective-C**

```objc
[JTProximitySDK.sharedInstance requestLocationAuthorization];
```

**Swift**

```swift
Proximity.shared.requestLocationAuthorization()
```


## Initialization

Place the following code inside the `UIApplicationDelegate` of your application:

### Simple Initialization

**Objective-C**

```objc
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [JTProximitySDK.sharedInstance initWithLaunchOptions:launchOptions apiKey:@"YOUR_API_KEY" apiSecret:@"YOUR_API_SECRET"];
    // Other application logics
}
```

**Swift**

```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    ProximitySDK.shared.initWithLaunchOptions(launchOptions, apiKey: "YOUR_API_KEY", apiSecret: "YOUR_API_SECRET")
    // Other application logics
    return true
}
```

### iOS 13 Scenes

If your application make use of iOS 13 scenes, an additional requirement is to
update the SDK windowSceneDelegate reference with the current active
UIWindowSceneDelegate.

To do this you must add the following code to your current UIWindowSceneDelegate
`scene:willConnectToSession:options:` :

**Swift**

```swift
import UIKit
import JTProximitySDK

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        ProximitySDK.shared.windowSceneDelegate = self
        guard let _ = (scene as? UIWindowScene) else { return }
    }
}
```

### Handling Notifications

To enable the SDK to correctly send and manager advertising notifications, you
must implement the following method in your `UIApplicationDelegate`:

**Objective-C**

```objc
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    if ([JTProximitySDK.sharedInstance application:application didReceiveLocalNotification:notification]) {
        return;
    }
    // Other application logics
}
```

**Swift**

```swift
func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
    if (ProximitySDK.shared.application(application, didReceive: notification)) {
        return
    }
    // Other application logics
}
```

If you plan to support **iOS 10.0** or later, you must also add this code in
your `UNUserNotificationCenterDelegate` methods:

**Objective-C**

```objc
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler __IOS_AVAILABLE(10.0) {
    if ([JTProximitySDK.sharedInstance userNotificationCenter:center willPresentNotification:notification]) {
        completionHandler(UNNotificationPresentationOptionAlert|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound);
        return;
    }
    // Other application logics
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler __IOS_AVAILABLE(10.0) {
    if ([JTProximitySDK.sharedInstance userNotificationCenter:center didReceiveNotificationResponse:response]) {
        completionHandler();
        return;
    }
    // Other application logics
}
```

**Swift**

```swift
@available(iOS 10.0, *)
func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    if ProximitySDK.shared.userNotificationCenter(center, willPresent: notification) {
        completionHandler([.alert, .badge, .sound])
        return
    }
    // Other application logics
}

@available(iOS 10.0, *)
func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    if ProximitySDK.shared.userNotificationCenter(center, didReceive: response) {
        completionHandler()
        return
    }
    // Other application logics
}
```

## Advanced Configurations

### Tracking User Identifiers

#### Advertising ID and Installation ID

The SDK associates each tracked request with the *advertisingId*. If the
*advertisingId* is not available due to a user permission denial, the device can
be identified by the *installationId*. The *installationId* is a randomly
generated UUID created during the first initialization that hence identifies a
specific installation of the SDK for that application. If the app containing the
SDK is uninstalled and then installed again the *installationId* will be a
different one. You can retrieve the *installationId* after the initialization of
the SDK anywhere in your code with the following line:

**Objective-C**

```objc
JTProximitySDK.sharedInstance.installationId;
```

**Swift**

```swift
ProximitySDK.shared.installationId()
```

#### External User ID


The `externalUserId` is an identifier you set to pair a unique user identifier
of your choice with our` installationId`. Tipically this identifier must be set
after a user has signed in to your application, and must be removed after the
same user decides to sign out of you application.

You can choose any string of 255 characters or less as externalUserId.

Your **externalUserId** can be paired with multiple **installationId**, for
example if the same user uses your app on multiple devices, or if the same user
uninstalled and installed your app multiple times.

On the other hand, the same **installationId** can be associated with one and
only one **externalUserId**, usually the last one sent.

For example, you can use the user record id of your database or your CRM, or the
hash of an email address, or a third party platform identifier.

Use the `setExternalUserId` method to add your unique external user ids:

**Objective-C**

```objc
// Set
[JTProximitySDK.sharedInstance setExternalUserId: @"SOME ID"];
// Unset
[JTProximitySDK.sharedInstance setExternalUserId: nil];
```

**Swift**

```swift
// Set
ProximitySDK.shared.externalUserId = "SOME ID"
// Unset
ProximitySDK.shared.externalUserId = nil
```

### Data Tags

Tags are custom key-value pairs of `string`, `number`, `boolean` or `NSNull` type,
that can be sent to our server through the SDK methods and that allow you a more
effective campaigns targeting, or to receive personalized analysis based on the
characteristics of your users.

Tags can be set or unset (with a `null` value) using the following methods:

#### sendTag

The `sendTag` method allow to set or unset a single tag at a time.

The method can be called multiple times. When sending different keys, its
effects are cumulative. If the same key is used, the last value overwrites the
previous ones.

**Objective-C**

```objc
[JTProximitySDK.sharedInstance sendTag: @"value" forKey: "key1"];
// -> { "key1" : "value" }
[JTProximitySDK.sharedInstance sendTag:@1 forKey:@"key2"];
// -> { "key1" : "value", "key2" : 1 }
[JTProximitySDK.sharedInstance sendTag:@YES forKey:@"key3"];
// -> { "key1" : "value", "key2" : 1, "key3" : true }
[JTProximitySDK.sharedInstance sendTag:@NO forKey:@"key3"];
// -> { "key1" : "value", "key2" : 1, "key3" : false }
[JTProximitySDK.sharedInstance sendTag:nil forKey:@"key2"];
// -> { "key1" : "value", "key3" : false }
```

**Swift**

```swift
ProximitySDK.shared.sendTag("value", for: "key1");
// -> { "key1" : "value" }
ProximitySDK.shared.sendTag(1, for: "key2");
// -> { "key1" : "value", "key2" : 1 }
ProximitySDK.shared.sendTag(true, for: "key3");
// -> { "key1" : "value", "key2" : 1, "key3" : true }
ProximitySDK.shared.sendTag(false, for: "key3");
// -> { "key1" : "value", "key2" : 1, "key3" : false }
ProximitySDK.shared.sendTag(null, for: "key2");
// -> { "key1" : "value", "key3" : false }
```

#### sendTags

The `sendTags` method allow to set or unset a multiple tags at a time.

The method can be called multiple times. When sending different keys, its
effects are cumulative. If the same key is used, the last value overwrites the
previous ones.

> **Note**: To send a `null` value using a Dictionary you must pass the value
> using a `NSNull` instance.

**Objective-C**

```objc
[JTProximitySDK.sharedInstance sendTags:@{
    @"key1" : "value",
    @"key2" : @1,
    @"key3" : @YES,
}];
// -> { "key1" : "value", "key2" : 1, "key3" : true }
[JTProximitySDK.sharedInstance sendTags:@{
    @"key2" : [NSNull null],
    @"key3" : @NO,
}];
// -> { "key1" : "value", "key3" : false }
```

**Swift**

```swift
ProximitySDK.shared.sendTags([
    "key1" : "value",
    "key2" : 1,
    "key3" : true
])
// -> { "key1" : "value", "key2" : 1, "key3" : true }
ProximitySDK.shared.sendTags([
    "key2" : NSNull(),
    "key3" : false
])
// -> { "key1" : "value", "key3" : false }
```

### Programmatically Disable Advertising

It is possible to programmatically disable/enable the advertising delivery by
setting the SDK's `advertisingEnabled` property to `false`. It is useful for
example to disable the delivery of advertising for specific users of the
application. In that case, simply change the property as soon as the user sign
in or out of the application.
The default value for the property is `true`.

**Objective-C**

```objc
// disable advertising delivery
[JTProximitySDK.sharedInstance setAdvertisingEnabled:NO];
// enable advertising delivery
[JTProximitySDK.sharedInstance setAdvertisingEnabled:YES];
```

**Swift**

```swift
// disable advertising delivery
ProximitySDK.shared.advertisingEnabled = false
// enable advertising delivery
ProximitySDK.shared.advertisingEnabled = true
```

### Receive Custom Events

You can receive custom advertising events (if configured in the backend) to
integrate application-specific features by using the `customDelegate` property
of `ProximitySDK` instance.

When the application user interacts with a custom-action notification, the
`jtProximityDidReceiveCustomAction:` method is invoked by passing a
`customAction` NSString object.

## User Consent and GDPR

As a publisher, you should implement a user consent flow either **manually** or
using a **Consent Management Platform** (CMP) and request for vendor and purpose
consents as outlined in IAB Europe’s Mobile In-App CMP API v2.0: Transparency
& Consent Framework.

### Enabling the Consent Flow support

To ensure that the SDK support the handling of user-consent preferences when a
IAB-compatible CMP library is present, you must enable the feature through the
`ProximitySDK.setCmpEnabled:` method, which is `false` by default.

> ⚠️ **Attention**: This method must be called before the library
> `initWithLaunchOptions:apiKey:apiSecret:` method to guarantee an error-free
> process.

#### Using Consent Management Platform

When configuring a third-party CMP to use with the Jointag Proximity SDK, the
following requirements must be met:

- In order to enable the delivery of advertising, a `custom publisher purpose`
    **must be** configured in the CMP, and it **must be** the first custom
    purpose.

#### Implementing a Custom Consent Flow

If you need to handle the user consent flow manually without the use of a
IAB-compatible CMP library, or if the CMP you are using do not allow the
customization of **custom publisher purpose**, it is possibile to do so by
implementing an in-app consent screen and interacting with the SDK using the
following methods:

**Objective-C**

```objc
// Retrieve or update the manual user profiling consent
[JTProximitySDK.sharedInstance getManualConsentForType:JTPManualConsentProfiling];
[JTProximitySDK.sharedInstance setManualConsent:YES forType:JTPManualConsentProfiling];

// Retrieve or update the manual user monitoring consent
[JTProximitySDK.sharedInstance getManualConsentForType:JTPManualConsentMonitoring];
[JTProximitySDK.sharedInstance setManualConsent:YES forType:JTPManualConsentMonitoring];

// Retrieve or update the manual user advertising consent
[JTProximitySDK.sharedInstance getManualConsentForType:JTPManualConsentAdvertising];
[JTProximitySDK.sharedInstance setManualConsent:YES forType:JTPManualConsentAdvertising];

// Retrieve or update the manual user advanced tracking consent
[JTProximitySDK.sharedInstance getManualConsentForType:JTPManualConsentAdvancedTracking];
[JTProximitySDK.sharedInstance setManualConsent:YES forType:JTPManualConsentAdvancedTracking];
```

**Swift**

```swift
// Retrieve or update the manual user profiling consent
ProximitySDK.shared.getManualConsent(for: .profiling);
ProximitySDK.shared.setManualConsent(true, for: .profiling);

// Retrieve or update the manual user monitoring consent
ProximitySDK.shared.getManualConsent(for: .monitoring);
ProximitySDK.shared.setManualConsent(true, for: .monitoring);

// Retrieve or update the manual user advertising consent
ProximitySDK.shared.getManualConsent(for: .advertising);
ProximitySDK.shared.setManualConsent(true, for: .advertising);

// Retrieve or update the manual user advanced tracking consent
ProximitySDK.shared.getManualConsent(for: .advancedTracking);
ProximitySDK.shared.setManualConsent(true, for: .advancedTracking);
```

---

> ⚠️ **Attention**: When the **manual consent method** is used in the presence
> of a **CMP library**, the choices made using the above methods take precedence
> over the choices made by the user in the CMP library screen.

---

[user-tracking-usage-description]: https://developer.apple.com/documentation/bundleresources/information_property_list/nsusertrackingusagedescription
[location-usage-description]: https://developer.apple.com/documentation/bundleresources/information_property_list/nslocationalwaysandwheninuseusagedescription