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

- (NSURLRequest *)requestWithRequestConfig:(AKSNetWorkRequestConfig *)requestConfig {
    
    AFHTTPRequestSerializer *requestSerializer = [AKSNetWorkConfig netWorkConfig].sessionManager.requestSerializer;
    NSDictionary *params = requestConfig.params;
    NSString *method = requestConfig.method;
    NSString *urlString = requestConfig.urlString;
    NSError *serializationError = nil;
    
    NSMutableURLRequest *mutableRequest = [requestSerializer requestWithMethod:method URLString:urlString parameters:params error:&serializationError];
    mutableRequest.timeoutInterval = [AKSNetWorkConfig netWorkConfig].timeoutInterval;
    
    [self.HTTPRequestHeaders enumerateKeysAndObjectsUsingBlock:^(id field, id value, BOOL * __unused stop) {
        if (![mutableRequest valueForHTTPHeaderField:field]) {
            [mutableRequest setValue:value forHTTPHeaderField:field];
        }
    }];
    
    return mutableRequest;
}

- (void)callNetWorkRequestConfig:(AKSNetWorkRequestConfig *)requestConfig
                  uploadProgress:(AKSUploadBlock)upload
                downloadProgress:(AKSDownloadBlock)download
                      completion:(AKSCompletionBlock)completion
{
    NSURLRequest *request = [self requestWithRequestConfig:requestConfig];
    AFHTTPSessionManager *manager = [AKSNetWorkConfig netWorkConfig].sessionManager;
    AKSHTTPSessionModel *sessionModel = [[AKSHTTPSessionModel alloc] init];
    
    [sessionModel startLoadingRequest:request];
    
    __weak __typeof__(self) weakSelf = self;
    __block NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        /** 上传进度 */
        if (upload) {
            upload(uploadProgress);
        }
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        /** 请求进度 */
        if (download) {
            download(downloadProgress);
        }
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        NSString *requestID = dataTask.currentRequest.URL.absoluteString;
        AKSNetWorkRequestModel *requestModel = [self.requestManager AKS_valueForKeyRequestID:requestID];
        
        NSString *errorDescription = error.userInfo[@"NSLocalizedDescription"];
        [requestModel.sessionModel endLoadingResponse:response responseObject:responseObject ErrorDescription:errorDescription];
        
        [weakSelf.requestManager AKS_removeObjectRequestID:requestID];
        if (completion) {
            
            NSString *ResponseString = [weakSelf resultGetResponseStringWithResponseObject:responseObject response:response error:&error];
            NSString *ResponseObject = [weakSelf resultGetResponseStringWithResponseObject:responseObject response:response error:&error];
            NSNumber *requestIdentifier = @([dataTask taskIdentifier]);
            
            AKSURLResponse *AKSResponse = [[AKSURLResponse alloc] initWithResponseString:ResponseString requestId:requestIdentifier request:request requestConfig:requestConfig responseObject:ResponseObject error:error];
            
            completion(AKSResponse);
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

- (NSString *)resultGetResponseStringWithResponseObject:(id)responseObject response:(NSURLResponse *)response error:(NSError **)error
{
    if (*error || !responseObject) {
        return nil;
    }
    if ([responseObject isKindOfClass:[NSData class]]) {
        return [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
    } else {
        return nil;
    }
}

- (NSString *)resultGetResponseObjectWithResponseObject:(id)responseObject response:(NSURLResponse *)response error:(NSError **)error
{
    if (*error || !responseObject) {
        return nil;
    }
    if ([responseObject isKindOfClass:[NSData class]]) {
        return [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:NULL];
    }
    else {
        return responseObject;
    }
}

@end
