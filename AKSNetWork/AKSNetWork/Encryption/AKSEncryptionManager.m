//
//  AKSEncryptionManager.m
//  AKSNetWork
//
//  Created by simonssd on 2019/6/4.
//  Copyright © 2019 Acadsoc. All rights reserved.
//

#import "AKSEncryptionManager.h"
#import "NSString+AKSNetWork.h"

/** AES 加密KEY */
static NSString *AESEncryptKey = @"aw8QlrPF6mVQR6CF6j0hiQjFJPEWIa3b";

/** Sign 加密Serect */
static NSString *SignEncryptSerect = @"067823ff-5c5c-45a3-9218-af01e9f4640b";

/** 签名 AppID */
static NSString *SignEncryptAppID = @"Acadsoc.IES.Api";

@implementation AKSEncryptionManager

#pragma mark - 获取Sign

/** 获取Sign */
+ (NSString *)AKS_SignWithMD5AllParameter:(NSDictionary *)parameterDict {
    
    parameterDict = [AKSEncryptionManager AKS_parameterThin:parameterDict];
    
    if (!parameterDict) {
        return [[SignEncryptSerect AKS_MD5Encrypt] uppercaseString];
    }
    
    if (![parameterDict isKindOfClass:[NSDictionary class]]) {
        return [[SignEncryptSerect AKS_MD5Encrypt] uppercaseString];
    }
    
    if (parameterDict.allKeys.count == 0) {
        return [[SignEncryptSerect AKS_MD5Encrypt] uppercaseString];
    }
    
    NSString *jointStr = [AKSEncryptionManager AKS_parameterJoint:parameterDict];
    
    return [[jointStr AKS_MD5Encrypt] uppercaseString];
}

/** 直接使用这个方法获取添加了Sign和AppID后的body */
+ (NSDictionary *)AKS_SupplementParameter:(NSDictionary *)parameterDict {
    
    NSString *sign = [AKSEncryptionManager AKS_SignWithMD5AllParameter:parameterDict];
    
    NSMutableDictionary *allParameter = [NSMutableDictionary dictionary];
    
    [allParameter addEntriesFromDictionary:[AKSEncryptionManager AKS_parameterThin:parameterDict]];
    [allParameter setObject:sign forKey:@"Sign"];
    [allParameter setObject:SignEncryptAppID forKey:@"AppID"];
    
    return allParameter;
}

#pragma mark - 加密参数处理

/** 获取加密后的字符串 */
+ (NSString *)AKS_AESEncryptWithValue:(NSString *)value {
    
    if (value && [value isKindOfClass:[NSString class]]) {

        return [value AKS_AES256EncryptWithKey:AESEncryptKey];
    }
    return @"";
}

/** 参数key值小写 */
+ (NSString *)AKS_parameterLowerCase:(NSString *)parameter {
    
    if (parameter && [parameter isKindOfClass:[NSString class]]) {
        
        return [parameter lowercaseString];
    }
    
    return @"";
}

/** 根据keyName进行排序 */
+ (NSArray *)AKS_letterSortWithKeyNameArray:(NSArray *)keyNameArr {
    
    NSStringCompareOptions comparisonOptions = NSCaseInsensitiveSearch | NSNumericSearch | NSWidthInsensitiveSearch | NSForcedOrderingSearch;
    
    NSComparator sort = ^(NSString *obj1,NSString *obj2){
        
        NSRange range = NSMakeRange(0,obj1.length);
        
        return [obj1 compare:obj2 options:comparisonOptions range:range];
    };
    
    NSArray *resultArray = [keyNameArr sortedArrayUsingComparator:sort];
    
    return resultArray;
}

/** 排序拼接参数 */
+ (NSString *)AKS_parameterJoint:(NSDictionary *)parameterDict {
    
    parameterDict = [AKSEncryptionManager AKS_parameterThin:parameterDict];
    
    if (!parameterDict) {
        return SignEncryptSerect;
    }
    
    if (![parameterDict isKindOfClass:[NSDictionary class]]) {
        return SignEncryptSerect;
    }
    
    if (parameterDict.allKeys.count == 0) {
        return SignEncryptSerect;
    }
    
    NSArray *unSortArr = parameterDict.allKeys;
    NSArray *sortArr = [self AKS_letterSortWithKeyNameArray:unSortArr];
    
    NSString *jointStr = @"";
    for (NSInteger i = 0; i < sortArr.count; i++) {
        
        NSString *keyStr = [sortArr objectAtIndex:i];
        NSString *valueStr = [parameterDict objectForKey:keyStr];
        
        if (i == 0) {
            jointStr = [jointStr stringByAppendingFormat:@"%@=%@",[AKSEncryptionManager AKS_parameterLowerCase:keyStr],valueStr];
        } else {
            jointStr = [jointStr stringByAppendingFormat:@"&%@=%@",[AKSEncryptionManager AKS_parameterLowerCase:keyStr],valueStr];
        }
    }
    
    return [jointStr stringByAppendingFormat:@"&%@",SignEncryptSerect];
}

/** 去掉为空参数 */
+ (NSDictionary *)AKS_parameterThin:(NSDictionary *)parameterDict {
    
    if (!parameterDict) {
        return nil;
    }
    
    if (![parameterDict isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    if (parameterDict.allKeys.count == 0) {
        return nil;
    }
    
    NSMutableDictionary *mutParameter = [NSMutableDictionary dictionaryWithDictionary:parameterDict];
    
    [mutParameter enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        if (!obj) {
            [mutParameter removeObjectForKey:key];
        }
        if ([obj isEqualToString:@""]) {
            [mutParameter removeObjectForKey:key];
        }
        if ([obj isEqual:[NSNull null]]) {
            [mutParameter removeObjectForKey:key];
        }
    }];
    
    return mutParameter;
}

@end
