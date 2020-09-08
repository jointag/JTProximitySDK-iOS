//
//  JTPLogger.h
//  JTProximitySDK
//
//  Copyright © 2020 Jointag Srl. All rights reserved.
//
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, JTPLogLevel) {
    JTPLogLevelVerbose,
    JTPLogLevelDebug,
    JTPLogLevelInfo,
    JTPLogLevelWarn,
    JTPLogLevelError
};

@interface JTPLogger : NSObject

// Shorthand methods
+ (void)v:(NSString *)format, ...;
+ (void)d:(NSString *)format, ...;
+ (void)i:(NSString *)format, ...;
+ (void)w:(NSString *)format, ...;
+ (void)e:(NSString *)format, ...;
+ (void)logWithLogLevel:(JTPLogLevel)level andFormat:(NSString *)format, ...;
+ (void)setLogLevel:(JTPLogLevel)newLogLevel;
+ (void)setWriteLogToFile:(BOOL)newWriteLogToFile;

@end
