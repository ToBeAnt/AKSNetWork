//
//  AKSNetWorkConfig.h
//  AKSNetWork
//
//  Created by simonssd on 2019/5/31.
//  Copyright © 2019 Acadsoc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AFHTTPSessionManager;

NS_ASSUME_NONNULL_BEGIN

@interface AKSNetWorkConfig : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

+ (instancetype)netWorkConfig;

/** 设置最大缓存版本限制 */
@property (readwrite, nonatomic, assign) NSInteger countLimit;

/** 是否启用日志打印 */
@property (readwrite, nonatomic, assign) BOOL dubugLogeEnable;

/** 是否启用数据库日志 */
@property (readwrite, nonatomic, assign) BOOL SQLLogEnable;

/** 设置网络超时时间 */
@property (readwrite, nonatomic, assign) NSInteger timeoutInterval;

/** 内存缓存版本 */
@property (readwrite, nonatomic, assign) NSString *memoryCacheVersion;

/** 缓存过期时间 */
@property (readwrite, nonatomic, assign) NSString *cacheTimeInSeconds;

/** 数据库登录密码 */
@property (readwrite, nonatomic, assign) NSString *ne_sqlitePassword;

/** 设置最大缓存限制 */
@property (readwrite, nonatomic, assign) NSInteger ne_saveRequestMaxCount;

/** 请求头 */
@property (readwrite, nonatomic, strong) NSMutableDictionary *mutableHTTPRequestHeaders;

@property (readwrite, nonatomic, strong) AFHTTPSessionManager *sessionManager;
@property (readwrite, nonatomic, strong) NSURLSessionConfiguration *sessionConfiguration;

@end

NS_ASSUME_NONNULL_END
