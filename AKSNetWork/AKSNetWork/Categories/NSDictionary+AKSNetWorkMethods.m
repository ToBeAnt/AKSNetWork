//
//  NSDictionary+AKSNetWorkMethods.m
//  AKSNetWork
//
//  Created by simonssd on 2019/5/6.
//  Copyright © 2019年 Acadsoc. All rights reserved.
//

#import "NSDictionary+AKSNetWorkMethods.h"

@implementation NSDictionary (AKSNetWorkMethods)

/** 字母排序之后形成的参数字符串 */
- (NSString *)AKS_paramsString {
    
    NSMutableString *paramString = [NSMutableString string];
    
    for (int i = 0; i < self.count; i ++) {
        NSString *string;
        if (i == 0) {
            string = [NSString stringWithFormat:@"?%@=%@", self.allKeys[i], self[self.allKeys[i]]];
        } else {
            string = [NSString stringWithFormat:@"&%@=%@", self.allKeys[i], self[self.allKeys[i]]];
        }
        [paramString appendString:string];
    }
    
    return paramString;
}

/** 数组变json */
- (NSString *)AKS_jsonString {
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:NULL];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}


@end
