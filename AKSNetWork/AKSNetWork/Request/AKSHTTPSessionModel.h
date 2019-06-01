//
//  AKSHTTPSessionModel.h
//  AKSNetWork
//
//  Created by simonssd on 2019/5/31.
//  Copyright © 2019 Acadsoc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AKSHTTPSessionModel : NSObject

/** 请求体 */
@property (nonatomic, strong) NSURLRequest          *ne_request;

/** 请求结果 */
@property (nonatomic, strong) NSHTTPURLResponse     *ne_response;

/** 请求的ID */
@property (nonatomic, assign) double                ID;

/** 开始请求的时间 */
@property (nonatomic, strong) NSString              *startDateString;

/** 结束请求的时间 */
@property (nonatomic, strong) NSString              *endDateString;

#pragma mark - Request

/** 请求链接 */
@property (nonatomic, strong) NSString              *requestURLString;

/** 创建请求的缓存策略 */
@property (nonatomic, strong) NSString              *requestCachePolicy;

/** 请求超时时间 */
@property (nonatomic, assign) double                requestTimeoutInterval;

/** 请求方式 */
@property (nonatomic, nullable, strong) NSString    *requestHTTPMethod;

/** 请求头列表 */
@property (nonatomic, nullable, strong) NSString    *requestAllHTTPHeaderFields;

/** 请求体 */
@property (nonatomic, nullable, strong) NSString    *requestHTTPBody;

#pragma mark - Response

/** 数据返回格式 */
@property (nonatomic, nullable, strong) NSString    *responseMIMEType;

/** 数据预期大小 */
@property (nonatomic, strong) NSString              *responseExpectedContentLength;

/** 数据编码类型 */
@property (nonatomic, nullable, strong) NSString    *responseTextEncodingName;

/** 资源文件名 */
@property (nullable, nonatomic, strong) NSString    *responseSuggestedFilename;

/** 请求状态码 0未建立连接 200请求成功、303重定向、400请求错误、401未授权、403禁止访问、404文件未找到、500服务器错误 */
@property (nonatomic, assign) NSInteger             responseStatusCode;

/** 响应头列表 */
@property (nonatomic, nullable, strong) NSString    *responseAllHeaderFields;

#pragma mark - JSONData

/** JSON数据 */
@property (nonatomic, strong) NSString              *receiveJSONData;

/** 错误描述 */
@property (nonatomic, strong) NSString              *errorDescription;

- (void)startLoadingRequest:(NSURLRequest *)request;

- (void)endLoadingResponse:(NSURLResponse *)response responseObject:(id)responseObject ErrorDescription:(NSString *)errorDescription;

@end

NS_ASSUME_NONNULL_END
