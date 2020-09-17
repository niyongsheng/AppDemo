//
//  DBManager.m
//  BaseIOS
//
//  Created by 倪永胜 on 2020/7/18.
//  Copyright © 2020 niyongsheng. All rights reserved.
//

#import "DBManager.h"

@implementation DBManager

SINGLETON_FOR_CLASS(DBManager);

- (FMDatabaseQueue *)dbQueue {
    if (!_dbQueue) {
        NSInteger userId = NUpdateUserInfo.idField;
        
        // 数据库路径
        NSString *path = [[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
                           stringByAppendingPathComponent:@"BaseIOS"]
                          stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld", userId]];
        
        // 创建数据库保存路径
        if (![[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:NULL]) {
            NSError *error = nil;
            [[NSFileManager defaultManager] createDirectoryAtPath:path
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:&error];
        }
        
        NSString *dbPath = [path stringByAppendingString:@"BaseIOS.sqlite"];
        NLog(@"数据库路径:[%@]",dbPath);
        
        // 数据库队列
        _dbQueue = [[FMDatabaseQueue alloc] initWithPath:dbPath];
    }
    return _dbQueue;
}

/// 创建表
- (void)createTableWithSQL:(NSString *)sql {
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        BOOL result = [db executeUpdate:sql withArgumentsInArray:nil];
        if (result) {
            NLog(@"创建表格成功");
        } else {
            NLog(@"创建表格失败");
        }
    }];
}

/// 删除表格
- (void)dropTableWithSQL:(NSString *)sql {
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        BOOL result = [db executeUpdate:sql withArgumentsInArray:nil];
        if (result) {
            NLog(@"删除表格成功");
        } else {
            NLog(@"删除表格失败");
        }
    }];
}

/// 插入数据
- (void)insertDataWithSQL:(NSString *)sql {
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        BOOL result = [db executeUpdate:sql withArgumentsInArray:nil];
        if (result) {
            NLog(@"插入数据成功");
        } else {
            NLog(@"插入数据失败");
        }
    }];
}

/// 查询所有数据
- (void)queryAll {
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = @"select * from T_human";
        
        FMResultSet *resultSet = [db executeQuery:sql withArgumentsInArray:nil];
        
        while (resultSet.next) {
            NSString *name = [resultSet stringForColumn:@"name"];
            int age = [resultSet intForColumn:@"age"];
            double height = [resultSet doubleForColumn:@"height"];
            
            NLog(@"%@, %i, %lf", name, age, height);
        }
    }];
}

/// 执行多条语句
- (void)excuteStaments {
    
    NSString *sql = @"insert into T_human(name, age, height) values('wangwu', 15, 170);insert into T_human(name, age, height) values('zhaoliu', 13, 160);";
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        BOOL result = [db executeStatements:sql];
        if (result) {
            NLog(@"执行多条语句成功");
        } else {
            NLog(@"执行多条语句失败");
        }
    }];
}

/// 开启事务执行语句
- (void)transaction {
    
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = @"insert into T_human(name, age, height) values('wangwu', 15, 170);insert into T_human(name, age, height) values('zhaoliu', 13, 160);";
        NSString *sql2 = @"insert into T_human(name, age, height) values('zhaoliu', 13, 160);insert into T_human(name, age, height) values('wangwu', 15, 170);";
        
        BOOL result1 = [db executeUpdate:sql withArgumentsInArray:nil];
        BOOL result2 = [db executeUpdate:sql2 withArgumentsInArray:nil];
        
        if (result1 && result2) {
            NLog(@"执行成功");
        } else {
            [db rollback];
        }
    }];
}

@end
