//
//  AKSURLResponse.m
//  AKSNetWork
//
//  Created by simonssd on 2019/6/4.
//  Copyright © 2019 Acadsoc. All rights reserved.
//

#import "AKSURLResponse.h"
#import "NSObject+AKSNetWork.h"

@interface AKSURLResponse()

@property (nonatomic, assign, readwrite) AKSURLResponseStatus status;
@property (nonatomic, strong, readwrite) AKSNetWorkRequestConfig *requestConfig;
@property (nonatomic, copy, readwrite)   NSString *contentString;
@property (nonatomic, copy, readwrite)   id content;
@property (nonatomic, assign, readwrite) NSInteger requestId;
@property (nonatomic, copy, readwrite)   NSURLRequest *request;
@property (nonatomic, strong, readwrite) NSString *errorMessage;

@end

@implementation AKSURLResponse

#pragma mark - life cycle

- (instancetype)initWithResponseString:(NSString *)responseString
                             requestId:(NSNumber *)requestId
                               request:(NSURLRequest *)request
                         requestConfig:(AKSNetWorkRequestConfig *)requestConfig
                        responseObject:(id)responseObject
                                 error:(NSError *)error
{
    self = [super init];
    if (self) {
        self.contentString = [responseString AKS_defaultValue:@""];
        self.requestId = [requestId integerValue];
        self.request = request;
        self.requestConfig = requestConfig;
        self.status = [self responseStatusWithError:error];
        self.content = responseObject ? responseObject : @{};
        self.errorMessage = [NSString stringWithFormat:@"%@", error];
    }
    return self;
}

- (instancetype)initWithResponseObject:(id)responseObject error:(NSError *)error
{
    self = [super init];
    if (self) {
        self.content = responseObject;
        self.errorMessage = [NSString stringWithFormat:@"%@", error];
    }
    return self;
}

#pragma mark - private methods

- (AKSURLResponseStatus)responseStatusWithError:(NSError *)error
{
    if (error) {
        AKSURLResponseStatus result = AKSURLResponseStatusErrorNoNetwork;
        
        /** 除了超时以外，所有错误都当成是无网络 */ 
        if (error.code == NSURLErrorTimedOut) {
            result = AKSURLResponseStatusErrorTimeout;
        }
        if (error.code == NSURLErrorCancelled) {
            result = AKSURLResponseStatusErrorCancel;
        }
        if (error.code == NSURLErrorNotConnectedToInternet) {
            result = AKSURLResponseStatusErrorNoNetwork;
        }
        return result;
    }
    else {
        return AKSURLResponseStatusSuccess;
    }
}

@end
