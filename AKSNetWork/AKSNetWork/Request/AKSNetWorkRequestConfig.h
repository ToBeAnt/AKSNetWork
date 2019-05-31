//
//  AKSNetWorkRequestConfig.h
//  AKSNetWork
//
//  Created by simonssd on 2019/5/31.
//  Copyright © 2019 Acadsoc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AKSNetWorkRequestConfig : NSObject

/** 请求方法 */
@property (nonatomic, copy) NSString *method;

/** 请求链接 */
@property (nonatomic, copy) NSString *urlString;

/** 请求参数 */
@property (nonatomic, strong) NSMutableDictionary *params;

/** 请求的控制器名字 */
@property (nonatomic, copy) NSString *className;

/** 是否忽视缓存 */
@property (nonatomic, assign) BOOL shouldAllIgnoreCache;

@end

NS_ASSUME_NONNULL_END
