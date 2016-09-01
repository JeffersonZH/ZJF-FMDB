//
//  ZJFDBManager.h
//  ZJF-FMDB
//
//  Created by zjf on 16/9/1.
//  Copyright © 2016年 ctfo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMResultSet.h"

//对FMDB进行二次封装
@interface ZJFDBManager : NSObject

// 1 初始化
- (instancetype)initWithPath:(NSString *)path;

// 2 创建表单
- (void)createList:(NSString *)listName columns:(NSDictionary *)dict primaryKey:(NSString *)keyName;

// 3 插入记录
- (BOOL)insertRecordFromDictionary:(NSDictionary *)dic intoList:(NSString *)listName;

// 4 查找所需的数据
- (FMResultSet *)select:(NSArray *)columns fromList:(NSString *)listName where:(NSString *)where;

// 5 删除记录
- (void)deleteRecord:(NSDictionary *)dict fromList:(NSString *)listName;

// 6 删除记录
- (void)deleteRecordsWhere:(NSString *)whereStr fromList:(NSString *)listName;

// 7 删除表单
- (void)deleteList:(NSString *)listName;

//更新数据
- (BOOL)updateDictionary:(NSDictionary *)dict fromList:(NSString *)listName where:(NSDictionary *)whereDict;



@end
