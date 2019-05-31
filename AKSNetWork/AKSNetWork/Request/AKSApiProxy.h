//
//  AKSApiProxy.h
//  AKSNetWork
//
//  Created by simonssd on 2019/5/31.
//  Copyright © 2019 Acadsoc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AKSNetWorkRequestConfig;

NS_ASSUME_NONNULL_BEGIN

@interface AKSApiProxy : NSObject

+ (instancetype)sharedInstance;

- (void)callNetWorkRequestConfig:(AKSNetWorkRequestConfig *)requestConfig completion:(void(^)(NSError *error, id responseObject,AKSNetWorkRequestConfig *requestModel))completion;

@end

NS_ASSUME_NONNULL_END
