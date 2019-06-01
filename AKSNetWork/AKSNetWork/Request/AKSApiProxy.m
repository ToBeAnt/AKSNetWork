//
//  AKSApiProxy.m
//  AKSNetWork
//
//  Created by simonssd on 2019/5/31.
//  Copyright © 2019 Acadsoc. All rights reserved.
//

#import "AKSApiProxy.h"
#import "AKSNetWorkConfig.h"
#import "AKSHTTPSessionModel.h"
#import "AKSURLRequestManager.h"
#import "AKSNetWorkRequestConfig.h"

#if __has_include(<AFNetworking/AFNetworking.h>)
#import <AFNetworking/AFNetworking.h>
#else
#import "AFNetworking.h"
#endif

@interface AKSApiProxy()

@property (nonatomic, strong) AKSURLRequestManager *requestManager;

@end

@implementation AKSApiProxy

+ (instancetype)sharedInstance {
    static AKSApiProxy *apiProxy = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        apiProxy = [[[self class] alloc] init];
    });
    return apiProxy;
}

- (instancetype)init {
    if (self = [super init]) {
        _requestManager = [AKSURLRequestManager requestManager];
    }
    return self;
}

- (void)callNetWorkRequestConfig:(AKSNetWorkRequestConfig *)requestConfig completion:(nonnull void (^)(NSError * _Nonnull, id _Nonnull, AKSNetWorkRequestConfig * _Nonnull))completion {
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSDictionary *params = requestConfig.params;
    NSString *method = requestConfig.method;
    NSString *urlString = requestConfig.urlString;
    NSError *serializationError = nil;
    NSMutableURLRequest *mutableRequest = [[AKSNetWorkConfig netWorkConfig].sessionManager.requestSerializer requestWithMethod:method URLString:urlString parameters:params error:&serializationError];
    mutableRequest.timeoutInterval = [AKSNetWorkConfig netWorkConfig].timeoutInterval;
    
    [self.HTTPRequestHeaders enumerateKeysAndObjectsUsingBlock:^(id field, id value, BOOL * __unused stop) {
        if (![mutableRequest valueForHTTPHeaderField:field]) {
            [mutableRequest setValue:value forHTTPHeaderField:field];
        }
    }];
    
    AKSHTTPSessionModel *sessionModel = [[AKSHTTPSessionModel alloc] init];
    [sessionModel startLoadingRequest:mutableRequest];
    
    __block NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:mutableRequest uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        
        NSLog(@"%@",uploadProgress);
        
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        
        NSLog(@"%@",downloadProgress);
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        NSString *requestID = dataTask.currentRequest.URL.absoluteString;
        AKSNetWorkRequestModel *requestModel = [self.requestManager AKS_valueForKeyRequestID:requestID];
        
        NSString *errorDescription = error.userInfo[@"NSLocalizedDescription"];
        [requestModel.sessionModel endLoadingResponse:response responseObject:responseObject ErrorDescription:errorDescription];
        
        [self.requestManager AKS_removeObjectRequestID:requestID];
        if (completion) {
            completion(error,responseObject,requestModel.requestConfig);
        }
    }];
    [dataTask resume];
    
    NSString *requestID = dataTask.currentRequest.URL.absoluteString;
    AKSNetWorkRequestModel *model = [[AKSNetWorkRequestModel alloc] initWithRequestID:requestID ClassName:requestConfig.className dataTask:dataTask RequestConfig:requestConfig sessionModel:sessionModel];
    [self.requestManager AKS_addObjectRequestModel:model];
}

- (NSDictionary *)HTTPRequestHeaders {
    
    NSMutableDictionary *mutableHTTPRequestHeaders = [AKSNetWorkConfig netWorkConfig].mutableHTTPRequestHeaders;
    
    return [NSDictionary dictionaryWithDictionary:mutableHTTPRequestHeaders];
}

@end
