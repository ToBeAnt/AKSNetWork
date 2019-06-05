//
//  AKSApiProxy.h
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

@interface AKSApiProxy : NSObject

+ (instancetype)sharedInstance;

- (void)callNetWorkRequestConfig:(AKSNetWorkRequestConfig *)requestConfig
                  uploadProgress:(AKSUploadBlock)upload
                downloadProgress:(AKSDownloadBlock)download
                      completion:(AKSCompletionBlock)completion;

@end

NS_ASSUME_NONNULL_END
