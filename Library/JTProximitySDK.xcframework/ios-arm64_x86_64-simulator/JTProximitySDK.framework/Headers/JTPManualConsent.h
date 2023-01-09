//
//  JTPManualConsent.h
//  JTProximitySDK
//
//  Created by Marco Fraccaroli on 18/03/21.
//  Copyright © 2021 Jointag. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, JTPManualConsent) {
    JTPManualConsentProfiling = 1 << 0,
    JTPManualConsentMonitoring = 1 << 1,
    JTPManualConsentAdvertising = 1 << 2,
    JTPManualConsentAdvancedTracking = 1 << 3,
} NS_SWIFT_NAME(ManualConsent);
