//
//  JTNotificationGalleryView.h
//  JTProximitySDK
//
//  Created by Marco Fraccaroli on 17/06/25.
//  Copyright © 2025 Jointag. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>

NS_ASSUME_NONNULL_BEGIN

@interface JTNotificationGalleryView : UIView

- (void)configureWithNotification:(UNNotification *)notification inExtensionContext:(nullable NSExtensionContext *)context;

@end

NS_ASSUME_NONNULL_END
