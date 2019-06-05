//
//  AKSEncryptionManager.h
//  AKSNetWork
//
//  Created by simonssd on 2019/6/4.
//  Copyright © 2019 Acadsoc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AKSEncryptionManager : NSObject

#pragma mark - 获取Sign

/**
 直接使用这个方法获取Sign即可
 */
+ (NSString *)AKS_SignWithMD5AllParameter:(NSDictionary *)parameterDict;

/**
 直接使用这个方法获取添加了Sign和AppID后的body
 */
+ (NSDictionary *)AKS_SupplementParameter:(NSDictionary *)parameterDict;

#pragma mark - 加密参数处理

/** 获取加密后的字符串 */
+ (NSString *)AKS_AESEncryptWithValue:(NSString *)value;

/** 参数key值小写 */
+ (NSString *)AKS_parameterLowerCase:(NSString *)parameter;

/** 根据keyName进行排序 */
+ (NSArray *)AKS_letterSortWithKeyNameArray:(NSArray *)keyNameArr;

/** 排序拼接参数 */
+ (NSString *)AKS_parameterJoint:(NSDictionary *)parameterDict;

/** 去掉为空参数 */
+ (NSDictionary *)AKS_parameterThin:(NSDictionary *)parameterDict;

@end

NS_ASSUME_NONNULL_END
