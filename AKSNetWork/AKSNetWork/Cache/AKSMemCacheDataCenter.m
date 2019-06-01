//
//  AKSMemCacheDataCenter.m
//  AKSNetWork
//
//  Created by simonssd on 2019/5/31.
//  Copyright © 2019 Acadsoc. All rights reserved.
//

#import "AKSMemCacheDataCenter.h"
#import "AKSNetWorkConfig.h"
#import "AKSNetWorkHelper.h"

#if __has_include(<YYCache/YYCache.h>)
#import <YYCache/YYCache.h>
#else
#import "YYCache.h"
#endif

#pragma mark - AKSMemCacheConfigModel

@interface AKSMemCacheConfigModel ()

@end

@implementation AKSMemCacheConfigModel

- (instancetype)initWithCacheTime:(NSDate *)cacheTime {
    if (self = [super init]) {
        self.cacheTime = cacheTime;
        self.cacheVersion = [AKSNetWorkConfig netWorkConfig].memoryCacheVersion;
        self.appVersion = [AKSNetWorkHelper AKS_appVersion];
    }
    return self;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.cacheVersion forKey:NSStringFromSelector(@selector(cacheVersion))];
    [coder encodeObject:self.cacheTime forKey:NSStringFromSelector(@selector(cacheTime))];
    [coder encodeObject:self.appVersion forKey:NSStringFromSelector(@selector(appVersion))];
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.appVersion = [aDecoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(appVersion))];
        self.cacheTime = [aDecoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(cacheTime))];
        self.cacheVersion = [aDecoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(cacheVersion))];
    }
    return self;
}

@end

#pragma mark - AKSMemCacheDataCenter

@interface AKSMemCacheDataCenter ()

@property (nonatomic, strong) YYCache *configMemoryCache;
@property (nonatomic, strong) YYCache *responseMemoryCache;
@property (nonatomic, strong) YYCache *requestcMemoryCache;

@end

@implementation AKSMemCacheDataCenter

+ (instancetype)shareInstance {
    static AKSMemCacheDataCenter *center = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        center = [[AKSMemCacheDataCenter alloc] init];
    });
    return center;
}

- (instancetype)init {
    if (self = [super init]) {
        _responseMemoryCache = [[YYCache alloc] initWithName:NSStringFromClass([self class])];
        _responseMemoryCache.memoryCache.countLimit = [AKSNetWorkConfig netWorkConfig].countLimit;
        _responseMemoryCache.diskCache.countLimit = [AKSNetWorkConfig netWorkConfig].countLimit;;
        _configMemoryCache = [[YYCache alloc] initWithName: NSStringFromClass([AKSMemCacheConfigModel class])];
        _configMemoryCache.memoryCache.countLimit = [AKSNetWorkConfig netWorkConfig].countLimit;
        _configMemoryCache.diskCache.countLimit = [AKSNetWorkConfig netWorkConfig].countLimit;;
    }
    return self;
}

- (void)AKS_configSetObject:(id<NSCoding>)object forKey:(NSString *)key {
    [_configMemoryCache setObject:object forKey:key];
}
- (id<NSCoding>)AKS_configObjectForKey:(NSString *)key {
    return [_configMemoryCache objectForKey:key];
}
- (void)AKS_configRemoveObjectForKey:(NSString *)key {
    [_configMemoryCache removeObjectForKey:key];
}
- (void)AKS_configRemoveAllObjects {
    [_configMemoryCache removeAllObjects];
}

- (void)AKS_responseSetObject:(id<NSCoding>)object forKey:(NSString *)key {
    [_responseMemoryCache setObject:object forKey:key];
}
- (id)AKS_responseObjectForKey:(NSString *)key {
    return [_responseMemoryCache objectForKey:key];
}
- (void)AKS_responseRemoveObjectForKey:(NSString *)key {
    [_responseMemoryCache removeObjectForKey:key];
}
- (void)AKS_responseRemoveAllObjects {
    [_responseMemoryCache removeAllObjects];
}

- (void)AKS_responseAndConfigRemoveAllObjects {
    [_configMemoryCache removeAllObjects];
    [_responseMemoryCache removeAllObjects];
}


@end
