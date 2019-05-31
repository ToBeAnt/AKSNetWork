//
//  NEHTTPModelManager.h
//  AKSNetWork
//
//  Created by simonssd on 2019/5/31.
//  Copyright © 2019 Acadsoc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AKSHTTPSessionModel;

NS_ASSUME_NONNULL_BEGIN

@interface NEHTTPModelManager : NSObject
{
    NSMutableArray *allRequests;
    BOOL enablePersistent;
}

/** 数据库密码 */
@property(nonatomic, strong) NSString *sqlitePassword;

/** 缓存数量上限 */
@property(nonatomic, assign) NSInteger saveRequestMaxCount;

/** 获取已记录的请求的SQLite文件名 */
+ (NSString *)filename;

/** 获取单例对象 */
+ (instancetype)defaultManager;

/** 创建表 */
- (void)createTable;

/** 数据库添加对象操作 */
- (void)addModel:(AKSHTTPSessionModel *) aModel;

/** 获取数据库所有对象 */
- (NSMutableArray *)allobjects;

/** 删除所有记录 */
- (void) deleteAllItem;

- (NSMutableArray *)allMapObjects;

- (void)addMapObject:(AKSHTTPSessionModel *)mapReq;

- (void)removeMapObject:(AKSHTTPSessionModel *)mapReq;

- (void)removeAllMapObjects;

@end

NS_ASSUME_NONNULL_END
