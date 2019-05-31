//
//  AKSURLRequestManager.m
//  AKSNetWork
//
//  Created by simonssd on 2019/5/31.
//  Copyright © 2019 Acadsoc. All rights reserved.
//

#import "AKSURLRequestManager.h"
#import "AKSNetWorkRequestConfig.h"
#import "AKSHTTPSessionModel.h"

@implementation AKSNetWorkRequestModel

- (instancetype)initWithRequestID:(NSString *)requestID ClassName:(NSString *)className dataTask:(NSURLSessionDataTask *)dataTask RequestConfig:(AKSNetWorkRequestConfig *)requestConfig sessionModel:(AKSHTTPSessionModel *)model
{
    if (self = [super init]) {
        self.requestID = requestID;
        self.ClassName = className;
        self.dataTask = dataTask;
        self.requestConfig = requestConfig;
        self.sessionModel = model;
    }
    return self;
}

@end

@interface AKSURLRequestManager ()

@property (nonatomic, strong) NSMutableArray *requestIds;

@end

@implementation AKSURLRequestManager

+ (AKSURLRequestManager *)requestManager {
    static AKSURLRequestManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AKSURLRequestManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    if (self = [super init]) {
        _requestIds = [NSMutableArray arrayWithCapacity:1];
    }
    return self;
}

- (void)AKS_addObjectRequestModel:(AKSNetWorkRequestModel *)model {
    @synchronized (self) {
        [_requestIds addObject:model];
    }
}

- (void)AKS_removeObjectRequestID:(NSString *)requestID {
    @synchronized (self) {
        __block AKSNetWorkRequestModel *model = nil;
        [_requestIds enumerateObjectsUsingBlock:^(AKSNetWorkRequestModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.requestID isEqualToString:requestID]) {
                model = obj;
                *stop = YES;
            }
        }];
        if (model) {
            [self.requestIds removeObject:model];
        }
    }
}

- (AKSNetWorkRequestModel *)AKS_valueForKeyRequestID:(NSString *)requestID {
    @synchronized (self) {
        __block AKSNetWorkRequestModel *model = nil;
        [_requestIds enumerateObjectsUsingBlock:^(AKSNetWorkRequestModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.requestID isEqualToString:requestID]) {
                model = obj;
            }
        }];
        return model;
    }
}

- (void)AKS_cancelObjectRequestID:(NSString *)requestID {
    @synchronized (self) {
        __block AKSNetWorkRequestModel *model = nil;
        [_requestIds enumerateObjectsUsingBlock:^(AKSNetWorkRequestModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.requestID isEqualToString:requestID]) {
                *stop = YES;
                model = obj;
            }
        }];
        if (model) {
            [model.dataTask cancel];
            [self.requestIds removeObject:model];
        }
    }
}

- (void)AKS_cancelObjectClassName:(NSString *)className {
    @synchronized (self) {
        NSMutableArray *classRequests = [NSMutableArray arrayWithCapacity:1];
        [_requestIds enumerateObjectsUsingBlock:^(AKSNetWorkRequestModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.ClassName isEqualToString:className]) {
                [obj.dataTask cancel];
                [classRequests addObject:obj];
            }
        }];
        [classRequests enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.requestIds removeObject:obj];
        }];
    }
}

- (void)AKS_cancelAllRequest {
    
    [self.requestIds removeAllObjects];
}

@end
