//
//  AKSNetWorkConfig.m
//  AKSNetWork
//
//  Created by simonssd on 2019/5/31.
//  Copyright © 2019 Acadsoc. All rights reserved.
//

#import "AKSNetWorkConfig.h"

#if __has_include(<AFNetworking/AFNetworking.h>)
#import <AFNetworking/AFNetworking.h>
#else
#import "AFNetworking.h"
#endif

@implementation AKSNetWorkConfig

+ (instancetype)netWorkConfig{
    static AKSNetWorkConfig *netWorkConfig = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        netWorkConfig = [[self alloc] init];
    });
    
    return netWorkConfig;
}

- (instancetype)init {
    if (self = [super init]) {
        
        /** 超时时间30秒 */
        _timeoutInterval = 30;
        
        /** 缓存过期时间3，超过次数认为已过期 */
        _cacheTimeInSeconds = @"3";
        
        /** 缓存版本1 */
        _memoryCacheVersion = @"1";
        
        /** 缓存最大版本数5 */
        _countLimit = 5;
        
        /** 默认打印日志 */
        _dubugLogeEnable = YES;
        
        /** 自定义请求头 */
        _mutableHTTPRequestHeaders = [NSMutableDictionary dictionaryWithCapacity:1];
        
        /** 缓存登录密码 */
        _ne_sqlitePassword = @"AKSNetwork";
        
        /** 设置最大总缓存数量 */
        _ne_saveRequestMaxCount = 300;
        
        /** 数据库日志默认打开 */
        _SQLLogEnable = YES;
        
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        _sessionManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:sessionConfiguration];
        
        _sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        
        _sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/css", @"text/xml", @"text/plain", @"application/javascript", @"image/*", nil];
        
    }
    return self;
}

@end
