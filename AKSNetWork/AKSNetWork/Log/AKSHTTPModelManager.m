//
//  AKSHTTPModelManager.m
//  AKSNetWork
//
//  Created by simonssd on 2019/5/31.
//  Copyright © 2019 Acadsoc. All rights reserved.
//

#import "AKSHTTPModelManager.h"
#import "AKSHTTPSessionModel.h"
#import "AKSNetWorkConfig.h"

#if FMDB_SQLCipher
#include "sqlite3.h"
#import "FMDB.h"
#endif

#define kSTRDoubleMarks @"\""
#define kSQLDoubleMarks @"\"\""
#define kSTRShortMarks  @"'"
#define kSQLShortMarks  @"''"

@interface AKSHTTPModelManager () {
    NSMutableArray *allMapRequests;
#if FMDB_SQLCipher
    FMDatabaseQueue *sqliteDatabase;
#endif
    
}
@end

@implementation AKSHTTPModelManager

- (id)init {
    self = [super init];
    if (self) {
        _sqlitePassword = [AKSNetWorkConfig netWorkConfig].ne_sqlitePassword;
        self.saveRequestMaxCount = [AKSNetWorkConfig netWorkConfig].ne_saveRequestMaxCount;;
        allRequests = [NSMutableArray arrayWithCapacity:1];
        allMapRequests = [NSMutableArray arrayWithCapacity:1];
#if FMDB_SQLCipher
        enablePersistent = YES;
#else
        enablePersistent = NO;
#endif
    }
    return self;
}

+ (instancetype)defaultManager {
    
    static AKSHTTPModelManager *staticManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        staticManager = [[AKSHTTPModelManager alloc] init];
        [staticManager createTable];
    });
    return staticManager;
    
}

+ (NSString *)filename {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *ducumentsDirectory = [paths objectAtIndex:0];
    NSString *str = [[NSString alloc] initWithFormat:@"%@/networkeye.sqlite",ducumentsDirectory];
    
    return  str;
}

- (void)createTable {
    
    NSMutableString *init_sqls = [NSMutableString stringWithCapacity:1024];
    [init_sqls appendFormat:@"create table if not exists nenetworkhttpeyes(myID double primary key,startDateString text,endDateString text,requestURLString text,requestCachePolicy text,requestTimeoutInterval double,requestHTTPMethod text,requestAllHTTPHeaderFields text,requestHTTPBody text,responseMIMEType text,responseExpectedContentLength text,responseTextEncodingName text,responseSuggestedFilename text,responseStatusCode int,responseAllHeaderFields text,receiveJSONData text);"];
#if FMDB_SQLCipher
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[AKSHTTPModelManager filename]];
    [queue inDatabase:^(FMDatabase *db) {
        [db setKey:_sqlitePassword];
        [db executeUpdate:init_sqls];
    }];
#endif
}

- (void)addModel:(AKSHTTPSessionModel *)aModel {
    
    if ([aModel.responseMIMEType isEqualToString:@"text/html"]) {
        aModel.receiveJSONData = @"";
    }
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"nenetworkhttpeyecache"] isEqualToString:@"a"]) {
        [self deleteAllItem];
        [[NSUserDefaults standardUserDefaults] setObject:@"b" forKey:@"nenetworkhttpeyecache"];
    }
    
    BOOL isNull;
    isNull = (aModel.receiveJSONData == nil);
    if (isNull) {
        aModel.receiveJSONData = @"";
    }
    NSString *receiveJSONData;
    receiveJSONData = [self stringToSQLFilter:aModel.receiveJSONData];
    if (enablePersistent) {
#if FMDB_SQLCipher
        
        NSString *sql = [NSString stringWithFormat:@"insert into nenetworkhttpeyes values('%lf','%@','%@','%@','%@','%lf','%@','%@','%@','%@','%@','%@','%@','%d','%@','%@')",aModel.ID,aModel.startDateString,aModel.endDateString,aModel.requestURLString,aModel.requestCachePolicy,aModel.requestTimeoutInterval,aModel.requestHTTPMethod,aModel.requestAllHTTPHeaderFields,aModel.requestHTTPBody,aModel.responseMIMEType,aModel.responseExpectedContentLength,aModel.responseTextEncodingName,aModel.responseSuggestedFilename,aModel.responseStatusCode,[self stringToSQLFilter:aModel.responseAllHeaderFields],receiveJSONData];
        
        FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[AKSHTTPModelManager filename]];
        [queue inDatabase:^(FMDatabase *db) {
            [db setKey:_sqlitePassword];
            [db executeUpdate:sql];
        }];
#endif
    } else {
        [allRequests addObject:aModel];
    }
    
    return ;
    
}

- (NSMutableArray *)allobjects {
    
    if (!enablePersistent) {
        if (allRequests.count >= self.saveRequestMaxCount) {
            [[NSUserDefaults standardUserDefaults] setObject:@"a" forKey:@"nenetworkhttpeyecache"];
        }
        return allRequests;
    }
#if FMDB_SQLCipher
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[AKSHTTPModelManager filename]];
    NSString *sql = [NSString stringWithFormat:@"select * from nenetworkhttpeyes order by myID desc"];
    NSMutableArray *array = [NSMutableArray array];
    [queue inDatabase:^(FMDatabase *db) {
        [db setKey:_sqlitePassword];
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            NEHTTPModel *model = [[NEHTTPModel alloc] init];
            model.myID = [rs doubleForColumn:@"myID"];
            model.startDateString = [rs stringForColumn:@"startDateString"];
            model.endDateString = [rs stringForColumn:@"endDateString"];
            model.requestURLString = [rs stringForColumn:@"requestURLString"];
            model.requestCachePolicy = [rs stringForColumn:@"requestCachePolicy"];
            model.requestTimeoutInterval = [rs doubleForColumn:@"requestTimeoutInterval"];
            model.requestHTTPMethod = [rs stringForColumn:@"requestHTTPMethod"];
            model.requestAllHTTPHeaderFields = [rs stringForColumn:@"requestAllHTTPHeaderFields"];
            model.requestHTTPBody = [rs stringForColumn:@"requestHTTPBody"];
            model.responseMIMEType = [rs stringForColumn:@"responseMIMEType"];
            model.responseExpectedContentLength = [rs stringForColumn:@"responseExpectedContentLength"];
            model.responseTextEncodingName = [rs stringForColumn:@"responseTextEncodingName"];
            model.responseSuggestedFilename = [rs stringForColumn:@"responseSuggestedFilename"];
            model.responseStatusCode = [rs intForColumn:@"responseStatusCode"];
            model.responseAllHeaderFields = [self stringToSQLFilter:[rs stringForColumn:@"responseAllHeaderFields"]];
            model.receiveJSONData = [self stringToOBJFilter:[rs stringForColumn:@"receiveJSONData"]];
            [array addObject:model];
        }
    }];
    
    if (array.count> = self.saveRequestMaxCount) {
        [[NSUserDefaults standardUserDefaults] setObject:@"a" forKey:@"nenetworkhttpeyecache"];
    }
    
    return array;
#endif
    return nil;
}

- (void)deleteAllItem {
    
    if (!enablePersistent) {
        [allRequests removeAllObjects];
        return;
    }
#if FMDB_SQLCipher
    
    NSString *sql = [NSString stringWithFormat:@"delete from nenetworkhttpeyes"];
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[AKSHTTPModelManager filename]];
    [queue inDatabase:^(FMDatabase *db) {
        [db setKey:_sqlitePassword];
        [db executeUpdate:sql];
    }];
    
    return;
#endif
}

#pragma mark - Utils

- (id)stringToSQLFilter:(id)str {
    
    if ([str respondsToSelector:@selector(stringByReplacingOccurrencesOfString:withString:)]) {
        id temp = str;
        temp = [temp stringByReplacingOccurrencesOfString:kSTRShortMarks withString:kSQLShortMarks];
        temp = [temp stringByReplacingOccurrencesOfString:kSTRDoubleMarks withString:kSQLDoubleMarks];
        return temp;
    }
    return str;
}

- (id)stringToOBJFilter:(id)str {
    
    if ([str respondsToSelector:@selector(stringByReplacingOccurrencesOfString:withString:)]) {
        id temp = str;
        temp = [temp stringByReplacingOccurrencesOfString:kSQLShortMarks withString:kSTRShortMarks];
        temp = [temp stringByReplacingOccurrencesOfString:kSQLDoubleMarks withString:kSTRDoubleMarks];
        return temp;
    }
    return str;
}

@end
