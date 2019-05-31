//
//  AKSURLRequestManager.h
//  AKSNetWork
//
//  Created by simonssd on 2019/5/31.
//  Copyright © 2019 Acadsoc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AKSNetWorkRequestConfig.h"
#import "AKSHTTPSessionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AKSNetWorkRequestModel : NSObject

@property (nonatomic, copy) NSString *requestID;
@property (nonatomic, copy) NSString *ClassName;
@property (nonatomic, strong) NSURLSessionDataTask *dataTask;
@property (nonatomic, strong) AKSNetWorkRequestConfig *requestConfig;
@property (nonatomic, strong) AKSHTTPSessionModel *sessionModel;

- (instancetype)initWithRequestID:(NSString *)requestID ClassName:(NSString *)className dataTask:(NSURLSessionDataTask *)dataTask RequestConfig:(AKSNetWorkRequestConfig *)requestConfig sessionModel:(AKSHTTPSessionModel *)model;

@end

@interface AKSURLRequestManager : NSObject

+ (AKSURLRequestManager *)requestManager;

- (void)AKS_cancelAllRequest;
- (void)AKS_removeObjectRequestID:(NSString *)requestID;
- (void)AKS_cancelObjectRequestID:(NSString *)requestID;
- (void)AKS_cancelObjectClassName:(NSString *)className;
- (void)AKS_addObjectRequestModel:(AKSNetWorkRequestModel *)model;

- (AKSNetWorkRequestModel *)AKS_valueForKeyRequestID:(NSString *)requestID;

@end

NS_ASSUME_NONNULL_END
