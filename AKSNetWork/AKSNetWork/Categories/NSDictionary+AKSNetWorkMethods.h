//
//  NSDictionary+AKSNetWorkMethods.h
//  AKSNetWork
//
//  Created by simonssd on 2019/5/6.
//  Copyright © 2019年 Acadsoc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (AKSNetWorkMethods)

/** 字母排序之后形成的参数字符串 */
- (NSString *)AKS_transformToUrlParamString;

/** 数组变json */
- (NSString *)AKS_jsonString;

@end

NS_ASSUME_NONNULL_END
