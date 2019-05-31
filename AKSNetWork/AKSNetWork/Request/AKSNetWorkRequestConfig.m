//
//  AKSNetWorkRequestConfig.m
//  AKSNetWork
//
//  Created by simonssd on 2019/5/31.
//  Copyright © 2019 Acadsoc. All rights reserved.
//

#import "AKSNetWorkRequestConfig.h"

@implementation AKSNetWorkRequestConfig

- (instancetype)init {
    if (self = [super init]) {
        _shouldAllIgnoreCache = NO;
        _params = [NSMutableDictionary dictionaryWithCapacity:1];
    }
    return self;
}

@end
