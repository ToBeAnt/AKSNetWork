//
//  AKSNetWorkingDefines.h
//  AKSNetWork
//
//  Created by simonssd on 2019/5/31.
//  Copyright © 2019 Acadsoc. All rights reserved.
//

#ifndef AKSNetWorkingDefines_h
#define AKSNetWorkingDefines_h

#import <objc/runtime.h>
#import "AKSNetWorkConfig.h"

static inline void swizzling_exchangeMethod(Class _Nonnull clazz, SEL _Nonnull originalSelector, SEL _Nonnull swizzledSelector) {
    Method originalMethod = class_getInstanceMethod(clazz, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(clazz, swizzledSelector);
    
    BOOL success = class_addMethod(clazz, originalSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    if (success) {
        class_replaceMethod(clazz, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
    
    
}

typedef NS_ENUM(NSInteger,AKSApiManagerErrorType) {
    AKSApiManagerErrorTypeRefreshToken      = -1, /** 刷新token */
    AKSApiManagerErrorTypeLogin             = -2, /** 登录 */
    AKSApiManagerErrorTypeCanceled          = -3, /** 取消 */
    AKSApiManagerErrorTypeNoNetWork         = -4, /** 无网络 */
    AKSApiManagerErrorTypeTimeOut           = -5, /** 超时 */
    AKSApiManagerErrorTypeSuccess           = -6, /** 成功 */
    AKSApiManagerErrorTypeCacheExpire       = -7, /** 缓存溢出 */
    AKSApiManagerErrorTypeDateExpire        = -8, /** 数据溢出 */
    AKSApiManagerErrorTypeAppVersionExpire  = -9, /** 版本溢出 */
    AKSApiManagerErrorTypeInvaliData        = -10,/** 数据无效 */
};


#endif /* AKSNetWorkingDefines_h */
