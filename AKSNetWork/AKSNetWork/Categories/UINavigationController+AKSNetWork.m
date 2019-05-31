//
//  UINavigationController+AKSNetWork.m
//  AKSNetWork
//
//  Created by simonssd on 2019/5/31.
//  Copyright © 2019 Acadsoc. All rights reserved.
//

#import "UINavigationController+AKSNetWork.h"
#import "AKSNetWorkingDefines.h"
#import "AKSURLRequestManager.h"

@implementation UINavigationController (AKSNetWork)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        swizzling_exchangeMethod([self class],@selector(popViewControllerAnimated:), @selector(AKS_popViewControllerAnimated:));
        swizzling_exchangeMethod([self class],@selector(popToRootViewControllerAnimated:), @selector(AKS_popToRootViewControllerAnimated:));
        swizzling_exchangeMethod([self class],@selector(popToViewController:animated:), @selector(AKS_popToViewController:animated:));
    });
}

- (nullable UIViewController *)AKS_popViewControllerAnimated:(BOOL)animated {
    
    [self canceledClassRequest];
    
    return [self AKS_popViewControllerAnimated:animated];
}

- (nullable NSArray<__kindof UIViewController *> *)AKS_popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    [self canceledClassRequest];
    
    return [self AKS_popToViewController:viewController animated:animated];
}

- (nullable NSArray<__kindof UIViewController *> *)AKS_popToRootViewControllerAnimated:(BOOL)animated {
    
    [self canceledClassRequest];
    
    return [self AKS_popToRootViewControllerAnimated:animated];
}

- (void)canceledClassRequest {
    
    [[AKSURLRequestManager requestManager] AKS_cancelObjectClassName:NSStringFromClass([self.topViewController class])];
}

@end
