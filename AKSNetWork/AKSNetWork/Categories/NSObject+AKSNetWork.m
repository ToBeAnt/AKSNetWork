//
//  NSObject+AKSNetWork.m
//  AKSNetWork
//
//  Created by simonssd on 2019/6/4.
//  Copyright © 2019 Acadsoc. All rights reserved.
//

#import "NSObject+AKSNetWork.h"

@implementation NSObject (AKSNetWork)

- (id)AKS_defaultValue:(id)defaultData
{
    if (![defaultData isKindOfClass:[self class]]) {
        return defaultData;
    }
    
    if ([self AKS_isEmptyObject]) {
        return defaultData;
    }
    
    return self;
}

- (BOOL)AKS_isEmptyObject
{
    if ([self isEqual:[NSNull null]]) {
        return YES;
    }
    
    if ([self isKindOfClass:[NSString class]]) {
        if ([(NSString *)self length] == 0) {
            return YES;
        }
    }
    
    if ([self isKindOfClass:[NSArray class]]) {
        if ([(NSArray *)self count] == 0) {
            return YES;
        }
    }
    
    if ([self isKindOfClass:[NSDictionary class]]) {
        if ([(NSDictionary *)self count] == 0) {
            return YES;
        }
    }
    
    return NO;
}

@end
