//
//  AKSNetWorkHelper.h
//  AKSNetWork
//
//  Created by simonssd on 2019/5/31.
//  Copyright © 2019 Acadsoc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AKSNetWorkHelper : NSObject

/** 获取当前时间 */
+ (NSDate *)AKS_currentDate;

/** 获取App版本 */
+ (NSString *)AKS_appVersion;

/** 获取当前时间的字符串 */
+ (NSString *)AKS_currentTimeString;

/** 设置时间样式 */
+ (NSDateFormatter *)AKS_dateFormatter;

/** 将当前时间与另一个日期大小进行比较 */
+ (BOOL)AKS_ratherCurrentTimeWithAnotherTime:(NSDate *)anotherDate;

/** 两个时间比较大小 */
+ (BOOL)AKS_ratherCurrentTimeDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay;

/** 网络是否连接 */
+ (BOOL)AKS_isReachable;


@end

NS_ASSUME_NONNULL_END
