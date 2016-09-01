//
//  ZJFDBManager.m
//  ZJF-FMDB
//
//  Created by zjf on 16/9/1.
//  Copyright © 2016年 ctfo. All rights reserved.
//

#import "ZJFDBManager.h"
#import "FMDatabase.h"

//判断数据库操作是否成功
#define RET_ERROR(a, str) {\
if (a) {\
NSLog(@"%@成功!\n", str);\
} else {\
NSLog(@"%@失败!\n", str);\
}\
}

@implementation ZJFDBManager
{
    FMDatabase * _dataBase;
}

- (void)dealloc
{
    if (_dataBase) {
        [_dataBase close];
    }
}

//初始化
- (instancetype)initWithPath:(NSString *)path
{
    if (self = [super init]) {
        if (_dataBase == nil) {
            _dataBase = [[FMDatabase alloc] initWithPath:path];
            BOOL ret = [_dataBase open];
            RET_ERROR(ret, @"打开数据库");
        }
    }
    return self;
}

//创建表单：将列写入字典进行传参，值是列的类型，键是列的名称，第三个参数是主键列的名字
- (void)createList:(NSString *)listName columns:(NSDictionary *)dict primaryKey:(NSString *)keyName
{
    //构建SQL
    NSMutableString * sqlStr = [NSMutableString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(", listName];
    
    BOOL isFirst = YES;
    //遍历字典，找到每个列
    for (NSString * colName in dict) {
        //拼接逗号
        if (isFirst == YES) {
            isFirst = NO;
        } else {
            [sqlStr appendString:@", "];
        }
        [sqlStr appendFormat:@"%@ %@", colName, dict[colName]];
        //判断主键列
        if ([colName isEqualToString:keyName] == YES) {
            [sqlStr appendString:@" PRIMARY KEY"];
        }
    }
    
    [sqlStr appendString:@");"];
    NSLog(@"%@",sqlStr);
    BOOL ret = [_dataBase executeUpdate:sqlStr];
    RET_ERROR(ret, @"创建表单");
}

//插入记录：将表单名，和字段名为键，值为值的字典。
- (BOOL)insertRecordFromDictionary:(NSDictionary *)dict intoList:(NSString *)listName
{
    //拼接sql
    NSMutableString * sqlStr = [NSMutableString stringWithFormat:@"INSERT INTO %@", listName];
    //字段
    NSMutableString * variable = [NSMutableString stringWithFormat:@"("];
    //值
    NSMutableString * value = [NSMutableString stringWithString:@"VALUES("];
    
    BOOL isFirst = YES;
    for (NSString * variableName in dict) {
        if (isFirst == YES) {
            isFirst = NO;
        }else {
            [variable appendString:@","];
            [value appendString:@","];
        }
        [variable appendString:variableName];
        [value appendString:dict[variableName]];
    }
    
    [sqlStr appendFormat:@"%@) %@);", variable, value];
    
    BOOL ret = [_dataBase executeUpdate:sqlStr];
    RET_ERROR(ret, @"插入记录");
    
    return ret;
}

//查找数据
- (FMResultSet *)select:(NSArray *)cloumns fromList:(NSString *)listName where:(NSString *)where
{
    NSString * cloumnstr = nil;
    if (cloumns == nil) {
        cloumnstr = @"*";
    } else {
        cloumnstr = [cloumns componentsJoinedByString:@", "];
    }
    NSMutableString * sqlStr = [NSMutableString stringWithFormat:@"SELECT %@ FROM %@ ", cloumnstr, listName];
    if (where) {
        [sqlStr appendString:where];
    }
    [sqlStr appendString:@";"];
    
    return [_dataBase executeQuery:sqlStr];
}

//删除记录
- (void)deleteRecord:(NSDictionary *)dict fromList:(NSString *)listName
{
    NSMutableString * sqlStr = [NSMutableString stringWithFormat:@"DELETE FROM %@ ", listName];
    if (dict != nil) {
        NSMutableString * whereStr = [NSMutableString stringWithString:@"WHERE "];
        
        BOOL isFirst = YES;
        for (NSString * key in dict) {
            if (isFirst == YES) {
                isFirst = NO;
            } else {
                [whereStr appendString:@" and "];
            }
            NSRange range = [dict[key] rangeOfString:@"%%"];
            if (range.location == NSNotFound) {
                [whereStr appendFormat:@"%@ = %@", key, dict[key]];
            } else {
                [whereStr appendFormat:@"%@ LIKE %@", key, dict[key]];
            }
        }
        [sqlStr appendString:whereStr];
    }
    [sqlStr appendString:@";"];
    
    BOOL ret = [_dataBase executeUpdate:sqlStr];
    RET_ERROR(ret, @"删除记录");
}

//删除记录
- (void)deleteRecordsWhere:(NSString *)whereStr fromList:(NSString *)listName
{
    NSMutableString * sqlStr = [NSMutableString stringWithFormat:@"DELETE FROM %@ ", listName];
    if (whereStr != nil) {
        [sqlStr appendString:whereStr];
    }
    [sqlStr appendString:@";"];
    
    BOOL ret = [_dataBase executeUpdate:sqlStr];
    RET_ERROR(ret, @"删除记录");
}

//删除表单
- (void)deleteList:(NSString *)listName
{
    NSString * sqlStr = [NSString stringWithFormat:@"DROP TABLE %@;", listName];
    BOOL ret = [_dataBase executeUpdate:sqlStr];
    RET_ERROR(ret, @"删除表单");
}

//更新数据
- (BOOL)updateDictionary:(NSDictionary *)dict fromList:(NSString *)listName where:(NSDictionary *)whereDict
{
    NSMutableArray * xArray = [NSMutableArray array];
    for (NSString * key in dict) {
        [xArray addObject:[NSString stringWithFormat:@"%@ = %@", key, dict[key]]];
    }
    NSString * columns = [xArray componentsJoinedByString:@", "];
    
    NSMutableString * whereStr;
    if (whereDict != nil) {
        whereStr = [NSMutableString stringWithString:@"WHERE "];
        
        BOOL isFirst = YES;
        for (NSString * key in whereDict) {
            if (isFirst == YES) {
                isFirst = NO;
            } else {
                [whereStr appendString:@" and "];
            }
            NSRange range = [whereDict[key] rangeOfString:@"%%"];
            if (range.location == NSNotFound) {
                [whereStr appendFormat:@"%@ = %@", key, whereDict[key]];
            } else {
                [whereStr appendFormat:@"%@ LIKE %@", key, whereDict[key]];
            }
        }
    }else {
        whereStr = (NSMutableString *)@"";
    }
    
    NSString * sqlStr = [NSString stringWithFormat:@"UPDATE %@ SET %@ %@;",listName, columns, whereStr];
    
    BOOL ret = [_dataBase executeUpdate:sqlStr];
    RET_ERROR(ret, @"更新数据");
    return ret;
}

@end
