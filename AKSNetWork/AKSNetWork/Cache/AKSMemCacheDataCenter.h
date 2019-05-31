//
//  AKSMemCacheDataCenter.h
//  AKSNetWork
//
//  Created by simonssd on 2019/5/31.
//  Copyright © 2019 Acadsoc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AKSMemCacheConfigModel : NSObject<NSSecureCoding>

@property (nonatomic, copy) NSString *cacheVersion;
@property (nonatomic, copy) NSDate   *cacheTime;
@property (nonatomic, copy) NSString *appVersion;

- (instancetype)initWithCacheTime:(NSDate*)cacheTime;

@end

@interface AKSMemCacheDataCenter : NSObject

+ (instancetype)shareInstance;

- (void)AKS_configSetObject:(id<NSCoding>)object forKey:(NSString *)key;
- (id)AKS_configObjectForKey:(NSString *)key;
- (void)AKS_configRemoveObjectForKey:(NSString *)key;
- (void)AKS_configRemoveAllObjects;

- (void)AKS_responseSetObject:(id<NSCoding>)object forKey:(NSString *)key;
- (id)AKS_responseObjectForKey:(NSString *)key;
- (void)AKS_responseRemoveObjectForKey:(NSString *)key;
- (void)AKS_responseRemoveAllObjects;

- (void)AKS_responseAndConfigRemoveAllObjects;

@end

NS_ASSUME_NONNULL_END
