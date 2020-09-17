//
//  DBManager.h
//  BaseIOS
//
//  Created by 倪永胜 on 2020/7/18.
//  Copyright © 2020 niyongsheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDB.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBManager : NSObject

SINGLETON_FOR_HEADER(DBManager);

@property (nonatomic, strong) FMDatabaseQueue *dbQueue;

/// 创建表
- (void)createTableWithSQL:(NSString *)sql;

/// 删除表格
- (void)dropTableWithSQL:(NSString *)sql;

/// 插入数据
- (void)insertDataWithSQL:(NSString *)sql;

/// 查询所有数据
- (void)queryAll;

/// 执行多条语句
- (void)excuteStaments;

/// 开启事务执行语句
- (void)transaction;

@end

NS_ASSUME_NONNULL_END
