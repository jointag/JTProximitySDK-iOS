//
//  JTViewController.m
//  JTProximitySDK
//
//  Created by Marco Fraccaroli on 09/25/2017.
//  Copyright (c) 2020 Jointag S.r.l. All rights reserved.
//

#import "JTViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <UserNotifications/UserNotifications.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>

@interface JTViewController ()<CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;

@property (weak, nonatomic) IBOutlet UIButton *trackingPermissionButton;
@property (weak, nonatomic) IBOutlet UIImageView *trackingPermissionView;
@property (weak, nonatomic) IBOutlet UIButton *notificationPermissionButton;
@property (weak, nonatomic) IBOutlet UIImageView *notificationPermissionView;
@property (weak, nonatomic) IBOutlet UIButton *locationPermissionButton;
@property (weak, nonatomic) IBOutlet UIImageView *locationPermissionView;

@end

@interface UIImageView (Toggle)

- (void)toggle:(BOOL)state;

@end

@implementation JTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (@available(iOS 14, *)) {
        [self.locationPermissionButton setEnabled:self.locationManager.authorizationStatus == kCLAuthorizationStatusNotDetermined];
        [self.locationPermissionView toggle:self.locationManager.authorizationStatus == kCLAuthorizationStatusAuthorizedAlways];
        [self.trackingPermissionButton setEnabled:ATTrackingManager.trackingAuthorizationStatus == ATTrackingManagerAuthorizationStatusNotDetermined];
        [self.trackingPermissionView toggle:ATTrackingManager.trackingAuthorizationStatus == ATTrackingManagerAuthorizationStatusAuthorized];
    } else {
        [self.locationPermissionButton setEnabled:CLLocationManager.authorizationStatus == kCLAuthorizationStatusNotDetermined];
        [self.locationPermissionView toggle:CLLocationManager.authorizationStatus == kCLAuthorizationStatusAuthorizedAlways];
        [self.trackingPermissionButton setEnabled:NO];
        [self.trackingPermissionView toggle:YES];
    }
    [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.notificationPermissionButton setEnabled:(settings.authorizationStatus == UNAuthorizationStatusNotDetermined)];
            [self.notificationPermissionView toggle:settings.authorizationStatus == UNAuthorizationStatusAuthorized];
        });
    }];
}

- (IBAction)requestTrackingPermissions:(id)sender {
    if (@available(iOS 14, *)) {
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.trackingPermissionButton setEnabled:status == ATTrackingManagerAuthorizationStatusNotDetermined];
                [self.trackingPermissionView toggle:status == ATTrackingManagerAuthorizationStatusAuthorized];
            });
        }];
    }
}

- (IBAction)requestNotificationPermissions:(id)sender {
    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionSound|UNAuthorizationOptionAlert|UNAuthorizationOptionBadge completionHandler:^(BOOL granted, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.notificationPermissionButton setEnabled:NO];
            [self.notificationPermissionView toggle:granted];
        });
    }];
}

- (IBAction)requestLocationPermissions:(id)sender {
    [self.locationManager requestAlwaysAuthorization];
}

#pragma mark - CLLocationManagerDelegate


- (void)locationManagerDidChangeAuthorization:(CLLocationManager *)manager __IOS_AVAILABLE(14.0) {
    [self locationManager:manager didChangeAuthorizationStatus:manager.authorizationStatus];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    [self.locationPermissionButton setEnabled:status == kCLAuthorizationStatusNotDetermined];
    [self.locationPermissionView toggle:status == kCLAuthorizationStatusAuthorizedAlways];
}

@end

@implementation UIImageView (Toggle)

- (void)toggle:(BOOL)state {
    self.image = [UIImage imageNamed:state ? @"ic_check_box" : @"ic_check_box_outline_blank"];
}

@end
