//
//  NSArray+AKSNetWorkMethods.m
//  AKSNetWork
//
//  Created by simonssd on 2019/5/6.
//  Copyright © 2019年 Acadsoc. All rights reserved.
//

#import "NSArray+AKSNetWorkMethods.h"

@implementation NSArray (AKSNetWorkMethods)

/** 字母排序之后形成的参数字符串 */
- (NSString *)AKS_paramsString {
    
    NSMutableString *paramString = [[NSMutableString alloc] init];
    NSArray *sortedParams = [self sortedArrayUsingSelector:@selector(compare:)];
    
    [sortedParams enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([paramString length] == 0) {
            [paramString appendFormat:@"%@", obj];
        } else {
            [paramString appendFormat:@"&%@", obj];
        }
    }];
    
    return paramString;
}

/** 数组变json */
- (NSString *)AKS_jsonString {
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:NULL];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end
