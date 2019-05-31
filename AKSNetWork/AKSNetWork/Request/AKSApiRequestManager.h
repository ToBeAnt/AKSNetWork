//
//  AKSApiRequestManager.h
//  AKSNetWork
//
//  Created by simonssd on 2019/5/31.
//  Copyright © 2019 Acadsoc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AKSNetWorkRequestConfig;

NS_ASSUME_NONNULL_BEGIN

@interface AKSApiRequestManager : NSObject

+ (instancetype)requestManager;

- (void)AKS_networkRequestConfig:(AKSNetWorkRequestConfig *)config completion:(void(^)(NSError *error, id responseObject))completion;

@end

NS_ASSUME_NONNULL_END
