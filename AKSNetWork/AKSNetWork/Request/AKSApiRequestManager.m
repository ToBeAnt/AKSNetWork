//
//  AKSApiRequestManager.m
//  AKSNetWork
//
//  Created by simonssd on 2019/5/31.
//  Copyright © 2019 Acadsoc. All rights reserved.
//

#import "AKSApiRequestManager.h"
#import "AKSNetWorkConfig.h"
#import "AKSApiProxy.h"
#import "AKSNetWorkingDefines.h"
#import "NSString+AKSNetWork.h"
#import "AKSMemCacheDataCenter.h"
#import "AKSNetWorkHelper.h"
#import "NSDictionary+AKSNetWork.h"
#import "AKSHTTPSessionModel.h"
#import "AKSURLRequestManager.h"
#import "AKSNetWorkRequestConfig.h"

NSString * const AKSRequestCacheErrorDomain = @"com.sxnetwork.request.caching";
NSString * const AKSNetworknFailingDataErrorKey = @"com.network.error.data";

static NSError * AKSErrorWithUnderlyingError(NSError *error, NSError *underlyingError) {
    if (!error) {
        return underlyingError;
    }
    
    if (!underlyingError || error.userInfo[NSUnderlyingErrorKey]) {
        return error;
    }
    
    NSMutableDictionary *mutableUserInfo = [error.userInfo mutableCopy];
    mutableUserInfo[NSUnderlyingErrorKey] = underlyingError;
    
    return [[NSError alloc] initWithDomain:error.domain code:error.code userInfo:mutableUserInfo];
}

@interface AKSApiRequestManager ()

@property (nonatomic, assign) AKSApiManagerErrorType errorType;
@property (nonatomic, strong) NSString *cachePath;
@property (nonatomic, strong) AKSURLRequestManager *requestManager;
@property (nonatomic, strong) AKSNetWorkConfig *netWorkConfig;
@property (nonatomic, strong) AKSNetWorkRequestConfig *requestConfig;

@end

@implementation AKSApiRequestManager

+ (instancetype)requestManager {
    static AKSApiRequestManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AKSApiRequestManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    if (self = [super init]) {
        _requestManager = [AKSURLRequestManager requestManager];
        _netWorkConfig = [AKSNetWorkConfig netWorkConfig];
    }
    return self;
}


/** 默认请求方式 */
- (void)AKS_networkRequestConfig:(AKSNetWorkRequestConfig *)config completion:(nonnull AKSCompletionBlock)completion
{
    [self AKS_defaultNetworkRequestConfig:config uploadProgress:nil downloadProgress:nil completion:completion];
}

/** 带上传进度的请求方式 */
- (void)AKS_networkRequestConfig:(AKSNetWorkRequestConfig *)config uploadProgress:(nonnull AKSUploadBlock)upload completion:(nonnull AKSCompletionBlock)completion
{
    [self AKS_defaultNetworkRequestConfig:config uploadProgress:upload downloadProgress:nil completion:completion];
}

/** 带下载进度的请求方式 */
- (void)AKS_networkRequestConfig:(AKSNetWorkRequestConfig *)config downloadProgress:(nonnull AKSDownloadBlock)download completion:(nonnull AKSCompletionBlock)completion
{
    [self AKS_defaultNetworkRequestConfig:config uploadProgress:nil downloadProgress:download completion:completion];
}

/** 统一请求处理 */
- (void)AKS_defaultNetworkRequestConfig:(AKSNetWorkRequestConfig *)config
                         uploadProgress:(AKSUploadBlock)upload
                       downloadProgress:(AKSDownloadBlock)download
                             completion:(AKSCompletionBlock)completion
{
    self.requestConfig = config;
    NSError *validationError = nil;
    id json = nil;
    
    if (![AKSNetWorkHelper AKS_isReachable]) {
        NSMutableDictionary *mutableUserInfo = [@{
                                                  NSLocalizedDescriptionKey: [NSString stringWithFormat:@"Request failed: not network"],
                                                  } mutableCopy];
        validationError = AKSErrorWithUnderlyingError([NSError errorWithDomain:AKSRequestCacheErrorDomain code:AKSApiManagerErrorTypeNoNetWork userInfo:mutableUserInfo], validationError);
        AKSURLResponse *AKSResponse = [[AKSURLResponse alloc] initWithResponseObject:json error:validationError];
        completion(AKSResponse);
        return;
    }
    
    validationError = [self loadMemoryCacheData];
    if (!validationError) {
        json = [self getResponseObjectData];
    }
    
    if (json) {
        AKSURLResponse *AKSResponse = [[AKSURLResponse alloc] initWithResponseObject:json error:validationError];
        completion(AKSResponse);
        return;
    }
    
    [[AKSApiProxy sharedInstance] callNetWorkRequestConfig:config
                                            uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
                                                if (upload) {
                                                    upload(uploadProgress);
                                                }
                                            }
                                          downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
                                              if (download) {
                                                  download(downloadProgress);
                                              }
                                          }
                                                completion:^(AKSURLResponse * _Nonnull response) {
                                                    self.requestConfig = response.requestConfig;
                                                    if (completion) {
                                                        completion(response);
                                                    }
                                                    if (response.status == AKSURLResponseStatusSuccess) {
                                                        [self saveCacheConfig];
                                                        [self saveResponseObject:response.content];
                                                    }
                                                }];
}

- (void)saveCacheConfig {
    
    AKSMemCacheConfigModel *config = [[AKSMemCacheConfigModel alloc] initWithCacheTime:[NSDate date]];
    [[AKSMemCacheDataCenter shareInstance] AKS_configSetObject:config forKey:self.cachePath];
}

- (NSError *)loadMemoryCacheData {
    
    NSString *key = self.cachePath;
    AKSMemCacheConfigModel *model = [[AKSMemCacheDataCenter shareInstance] AKS_configObjectForKey:key];
    NSError *validationError = nil;
    
    if (!model) {
        NSMutableDictionary *mutableUserInfo = [@{
                                                  NSLocalizedDescriptionKey: [NSString stringWithFormat:@"failed: not cache data"],
                                                  } mutableCopy];
        validationError = AKSErrorWithUnderlyingError([NSError errorWithDomain:AKSRequestCacheErrorDomain code:AKSApiManagerErrorTypeInvaliData userInfo:mutableUserInfo], validationError);
        return validationError;
    }
    
    BOOL isExpire = [AKSNetWorkHelper AKS_ratherCurrentTimeWithAnotherTime:model.cacheTime];
    if (!isExpire) {
        NSMutableDictionary *mutableUserInfo = [@{
                                                  NSLocalizedDescriptionKey: [NSString stringWithFormat:@"failed: cache data date expire"],
                                                  } mutableCopy];
        validationError = AKSErrorWithUnderlyingError([NSError errorWithDomain:AKSRequestCacheErrorDomain code:AKSApiManagerErrorTypeCacheExpire userInfo:mutableUserInfo], validationError);
        return validationError;
    }
    
    NSString *appVersion = [AKSNetWorkHelper AKS_appVersion];
    NSString *currentAppVersion = model.appVersion;
    if (appVersion.length != currentAppVersion.length || ![appVersion isEqualToString: currentAppVersion]) {
        NSMutableDictionary *mutableUserInfo = [@{
                                                  NSLocalizedDescriptionKey: [NSString stringWithFormat:@"failed: cache data version expire"],
                                                  } mutableCopy];
        validationError = AKSErrorWithUnderlyingError([NSError errorWithDomain:AKSRequestCacheErrorDomain code:AKSApiManagerErrorTypeAppVersionExpire userInfo:mutableUserInfo], validationError);
        return validationError;
    }
    
    if (validationError) {
        [[AKSMemCacheDataCenter shareInstance] AKS_responseRemoveObjectForKey:key];
        [[AKSMemCacheDataCenter shareInstance] AKS_configRemoveObjectForKey:key];
    }
    
    return validationError;
}

- (void)saveResponseObject:(id)object {
    
    /** 判断缓存时间和是否忽略缓存 */
    if ([_netWorkConfig.cacheTimeInSeconds integerValue] <= 0 || self.requestConfig.shouldAllIgnoreCache) {
        return;
    }
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:nil];
    if (!data || data.length < 1) {
        return;
    }
    NSString *key = self.cachePath;
    [[AKSMemCacheDataCenter shareInstance] AKS_responseSetObject:data forKey:key];
}

- (id)getResponseObjectData {
    
    NSError *validationError = nil;
    if ([_netWorkConfig.cacheTimeInSeconds integerValue] <= 0 || self.requestConfig.shouldAllIgnoreCache) {
        NSMutableDictionary *mutableUserInfo = [@{
                                                  NSLocalizedDescriptionKey: [NSString stringWithFormat:@"failed: cacheTimeInSeconds and IgnoreCache"],
                                                  } mutableCopy];
        validationError = AKSErrorWithUnderlyingError([NSError errorWithDomain:AKSRequestCacheErrorDomain code:AKSApiManagerErrorTypeCacheExpire userInfo:mutableUserInfo], validationError);
        return nil;
    }
    
    NSString *key = self.cachePath;
    NSData *data = [[AKSMemCacheDataCenter shareInstance] AKS_responseObjectForKey:key];
    if (!data || data.length < 1) {
        NSMutableDictionary *mutableUserInfo = [@{
                                                  NSLocalizedDescriptionKey: [NSString stringWithFormat:@"failed: invaliData"],
                                                  } mutableCopy];
        validationError = AKSErrorWithUnderlyingError([NSError errorWithDomain:AKSRequestCacheErrorDomain code:AKSApiManagerErrorTypeInvaliData userInfo:mutableUserInfo], validationError);
        return nil;
    }
    
    NSError *error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    if (!error) {
        return json;
    }
    
    return nil;
}

- (NSString *)cachePath {
    
    NSString *requestString = [NSString stringWithFormat:@"method:%@ url:%@ params:%@",_requestConfig.method,_requestConfig.urlString,_requestConfig.params];
    
    return [requestString AKS_MD5Encrypt];
}


@end
