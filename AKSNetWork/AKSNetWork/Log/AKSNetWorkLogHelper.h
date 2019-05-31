//
//  AKSNetWorkLogHelper.h
//  AKSNetWork
//
//  Created by simonssd on 2019/5/31.
//  Copyright © 2019 Acadsoc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AKSHTTPSessionModel;

NS_ASSUME_NONNULL_BEGIN

@interface AKSNetWorkLogHelper : NSObject

- (instancetype)initWithSessionModel:(AKSHTTPSessionModel *)sessionModel;

- (NSString *)printRequestLog;

@end

NS_ASSUME_NONNULL_END
