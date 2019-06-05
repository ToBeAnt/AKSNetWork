//
//  AKSApiRequestManager.h
//  AKSNetWork
//
//  Created by simonssd on 2019/5/31.
//  Copyright © 2019 Acadsoc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AKSURLResponse.h"

@class AKSNetWorkRequestConfig;

NS_ASSUME_NONNULL_BEGIN

typedef void(^AKSUploadBlock)(NSProgress * _Nonnull uploadProgress);
typedef void(^AKSDownloadBlock)(NSProgress * _Nonnull downloadProgress);
typedef void(^AKSCompletionBlock)(AKSURLResponse *response);

@interface AKSApiRequestManager : NSObject

+ (instancetype)requestManager;

/**
 默认请求方式

 @param config 请求配置
 @param completion 请求结果Block
 */
- (void)AKS_networkRequestConfig:(AKSNetWorkRequestConfig *)config completion:(AKSCompletionBlock)completion;

/**
 带上传进度的请求方式

 @param config 请求配置
 @param upload 上传进度Block
 @param completion 请求结果Block
 */
- (void)AKS_networkRequestConfig:(AKSNetWorkRequestConfig *)config uploadProgress:(AKSUploadBlock)upload completion:(AKSCompletionBlock)completion;

/**
 带下载进度的请求方式

 @param config 请求配置
 @param download 下载进度Block
 @param completion 请求结果Block
 */
- (void)AKS_networkRequestConfig:(AKSNetWorkRequestConfig *)config downloadProgress:(AKSDownloadBlock)download completion:(AKSCompletionBlock)completion;

@end

NS_ASSUME_NONNULL_END
