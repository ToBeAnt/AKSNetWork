//
//  UIViewController+AKSNetWork.m
//  AKSNetWork
//
//  Created by simonssd on 2019/5/31.
//  Copyright © 2019 Acadsoc. All rights reserved.
//

#import "UIViewController+AKSNetWork.h"
#import "AKSNetWorkingDefines.h"
#import "AKSURLRequestManager.h"

@implementation UIViewController (AKSNetWork)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        swizzling_exchangeMethod([self class],@selector(dismissViewControllerAnimated:completion:), @selector(AKS_dismissViewControllerAnimated:completion:));
    });
}

- (void)AKS_dismissViewControllerAnimated: (BOOL)flag completion: (void (^ __nullable)(void))completion {
    
    [self AKS_dismissViewControllerAnimated:flag completion:completion];
    
    [self canceledClassRequest];
}

- (void)canceledClassRequest {
    
    [[AKSURLRequestManager requestManager] AKS_cancelObjectClassName:NSStringFromClass([self class])];
}

@end
