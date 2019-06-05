//
//  AKSURLResponse.h
//  AKSNetWork
//
//  Created by simonssd on 2019/6/4.
//  Copyright © 2019 Acadsoc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AKSNetWorkRequestConfig.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, AKSURLResponseStatus) {
    /** 请求成功，作为底层，请求是否成功只考虑是否成功收到服务器反馈 */
    AKSURLResponseStatusSuccess,
    /** 请求超时 */
    AKSURLResponseStatusErrorTimeout,
    /** 请求取消 */
    AKSURLResponseStatusErrorCancel,
    /** 网络错误，超时外的错误都归入网络错误*/
    AKSURLResponseStatusErrorNoNetwork
};

@interface AKSURLResponse : NSObject

/** 请求状态 */
@property (nonatomic, assign, readonly) AKSURLResponseStatus status;

/** 请求配置 */
@property (nonatomic, strong, readonly) AKSNetWorkRequestConfig *requestConfig;

/** 请求结果 */
@property (nonatomic, copy, readonly)   NSString *contentString;

/** 请求返回的数据 */
@property (nonatomic, copy, readonly)   id content;

/** 请求ID */
@property (nonatomic, assign, readonly) NSInteger requestId;

/** 具体请求 */
@property (nonatomic, copy, readonly)   NSURLRequest *request;

/** 错误信息 */
@property (nonatomic, strong, readonly) NSString *errorMessage;


- (instancetype)initWithResponseString:(NSString *)responseString
                             requestId:(NSNumber *)requestId
                               request:(NSURLRequest *)request
                         requestConfig:(AKSNetWorkRequestConfig *)requestConfig
                        responseObject:(id)responseObject
                                 error:(NSError *)error;

- (instancetype)initWithResponseObject:(id)responseObject error:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
