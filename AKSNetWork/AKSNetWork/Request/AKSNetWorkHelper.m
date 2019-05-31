//
//  AKSNetWorkHelper.m
//  AKSNetWork
//
//  Created by simonssd on 2019/5/31.
//  Copyright © 2019 Acadsoc. All rights reserved.
//

#import "AKSNetWorkHelper.h"
#import "NSDictionary+AKSNetWork.h"
#import "NSString+AKSNetWork.h"
#import "AKSNetWorkConfig.h"
#import <UIKit/UIKit.h>

#if __has_include(<AFNetworking/AFNetworkReachabilityManager.h>)
#import <AFNetworking/AFNetworkReachabilityManager.h>
#else
#import "AFNetworkReachabilityManager.h"
#endif

@implementation AKSNetWorkHelper

+ (NSDate *)AKS_currentDate {
    return [NSDate date];
}

+ (NSString *)AKS_appVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+ (BOOL)AKS_ratherCurrentTimeDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay {
    
    NSTimeInterval delta  = [oneDay timeIntervalSinceDate:anotherDay];
    CGFloat minutes = [[AKSNetWorkConfig netWorkConfig].cacheTimeInSeconds floatValue];
    
    if (delta > 60 * minutes) {
        return NO;
    }
    return YES;
}

+ (BOOL)AKS_ratherCurrentTimeWithAnotherTime:(NSDate *)anotherDate {
    NSDate *now = [self AKS_currentDate];
    return [self AKS_ratherCurrentTimeDay:now withAnotherDay:anotherDate];
}

+ (NSString *)AKS_currentTimeString {
    return [[self AKS_dateFormatter] stringFromDate:[self AKS_currentDate]];
}

+ (NSDateFormatter *)AKS_dateFormatter {
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-mm-dd hh:mm:ss zzz"];
    });
    return formatter;
}

+ (BOOL)AKS_isReachable {
    __block BOOL reachable = YES;
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager  sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusUnknown || status == AFNetworkReachabilityStatusNotReachable) {
            reachable = NO;
        }
    }];
    return reachable;
}

@end
