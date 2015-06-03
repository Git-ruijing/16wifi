//
//  MyDatabase.m
//  e-RoadWiFi
//
//  Created by QC on 14-8-1.
//  Copyright (c) 2014年 G.MING. All rights reserved.
//
#import "MyDatabase.h"
#import "NSObject+GmingAdd.h"
@implementation MyDatabase
+(NSString*)filePath:(NSString *)fileName
{
    NSString *path=NSHomeDirectory();
    path=[path stringByAppendingPathComponent:@"Documents"];
    
    NSFileManager *fm=[NSFileManager defaultManager];
    if ([fm fileExistsAtPath:path]) {
        if (fileName&& [fileName length]!=0) {
            path=[path stringByAppendingPathComponent:fileName];
        }
    }
    else{
        NSLog(@"指定目录不存在");
    }
    
    return path;
}
+(MyDatabase*)sharedDatabase
{
    static MyDatabase *database;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        database=[[MyDatabase alloc] init];
    });
    return database;
}
//根据模型获得创建它的表语句
-(NSString*)createTablePropertyListSQL:(id)modelObject
{
    NSDictionary *dict=[modelObject propertyList:NO];
    NSString *sql= [[dict allKeys] componentsJoinedByString:@" text,"];
    sql=[sql stringByAppendingString:@" text"];
    return sql;
}

-(void)createTable:(NSArray *)modelNameArray
{
    NSString * tableSql=@"CREATE TABLE IF NOT EXISTS %@(no integer PRIMARY KEY AUTOINCREMENT,%@)";
    //获得每一个横型类名字符串
    for (NSString *modelName in modelNameArray) {
        //转成类
        Class newClass=NSClassFromString(modelName);
        
        if (newClass) {
            //获得对应这个模型的建表语句
            NSString *createSql=[self createTablePropertyListSQL:[[newClass alloc] init]];
            NSString *sql=[NSString stringWithFormat:tableSql,modelName,createSql];
            BOOL sucess=[GMDatabase executeUpdate:sql];
            if (!sucess) {
                NSLog(@"创建表失败:%@",[GMDatabase lastErrorMessage]);
            }
        }
        
    }
}
-(instancetype)init
{
    if (self=[super init]) {
        fullPath=[MyDatabase filePath:@"BasicData.db"];
        NSLog(@"%@",fullPath);
        //创建数据库，如果文件不存在
        GMDatabase=[[FMDatabase alloc] initWithPath:fullPath];
        
        //打开数据库
        if ([GMDatabase open]) {
            //创建表
            [self createTable:nil];
            
        }
        
    }
    return self;
}

-(void)insertItem:(id)object{
    NSString *tableName=NSStringFromClass([object class]);
    NSLog(@"tableName：%@",tableName);
    NSDictionary *propertyDict=[object propertyList:YES];
    NSArray *propertyList=[propertyDict allKeys];
    NSArray *propertyValue=[propertyDict allValues];
    NSString *itemsql=[propertyList componentsJoinedByString:@","];
    
    NSMutableString *valueSql=[NSMutableString string];
    for (int i=0;i<[propertyList count];i++) {
        if (i==0) {
            [valueSql appendFormat:@"?"];
        }
        else{
            [valueSql appendFormat:@",?"];
        }
    }
    NSString *sql=[NSString stringWithFormat:@"INSERT INTO %@(%@) VALUES (%@)",tableName,itemsql,valueSql];
    NSLog(@"sql------>:%@",sql);
    BOOL success=[GMDatabase executeUpdate:sql withArgumentsInArray:propertyValue];
    if (!success) {
        NSLog(@"插入失败:%@",[GMDatabase lastErrorMessage]);
    }
}
-(void)deleteTable:(id)object{
    
    NSString *tableName=NSStringFromClass([object class]);
    NSLog(@"tableName：%@",tableName);
    //类名就是表名
    NSString *sql=[NSString stringWithFormat:@"DELETE FROM  %@",tableName];
    
    BOOL success=[GMDatabase executeUpdate:sql];
    if (!success) {
        NSLog(@"删除失败");
    }else{
        NSLog(@"成功");
    }
    
}
-(void)deleteTableName:(id)tableName where:(id)object value:(id)values{
    NSString *table=NSStringFromClass([tableName class]);
    NSLog(@"tableName：%@",tableName);
    //类名就是表名
    NSString *sql=[NSString stringWithFormat:@"DELETE  FROM  %@ where %@=%@",table,object,values];
    BOOL success=[GMDatabase executeUpdate:sql];
    if (!success) {
        NSLog(@"删除失败");
    }else{
        NSLog(@"成功");
    }
    NSLog(@"sql:%@",sql);
    
}
-(void)updataTable:(id)tableName setField:(id)field Value:(id)value where:(id)object value:(id)values{
    NSString *table=NSStringFromClass([tableName class]);
    NSLog(@"tableName：%@",tableName);
    NSString *sql=[NSString stringWithFormat:@"UPDATE %@ set %@=%@",table,field, value];
    if (object) {
        sql=[NSString stringWithFormat:@"%@ where %@=%@",sql,object,values];
    }
    BOOL success=[GMDatabase executeUpdate:sql];
    if (!success) {
        NSLog(@"失败");
    }else{
        NSLog(@"成功");
    }
    
}

-(void)updataTable:(id)tableName setField:(id)field Value:(id)value where:(id)object FieldType:(NSString *)type{
    NSString *table=NSStringFromClass([tableName class]);
    NSLog(@"tableName：%@",tableName);
    NSString *sql=[NSString stringWithFormat:@"UPDATE %@ set %@=%@+1 ",table,field, value];
    if (object) {
        sql=[NSString stringWithFormat:@"%@ where %@='%@' ",sql,object,type];
    }
    NSLog(@"sql---%@",sql);
    BOOL success=[GMDatabase executeUpdate:sql];
    if (!success) {
        NSLog(@"失败");
    }else{
        NSLog(@"成功");
    }
    
}
-(void)insertArray:(NSArray *)array{
    [GMDatabase beginTransaction];
    NSLog(@"插入数据%@",array);
    for (id object in array){
        [self insertItem:object];
    }
    [GMDatabase commit];
}

-(NSArray*)readData:(NSInteger)startIndex count:(NSInteger)count model:(id)model grounBy:(NSString *)groupBy orderBy:(NSString *)orderBy desc:(BOOL)desc
{
    //类名就是表名
    NSString *tableName=NSStringFromClass([model class]);
    //    NSString *sql=[NSString stringWithFormat:@"SELECT %@ FROM %@",itemsql,tableName];
    
    
    NSString *sql=[NSString stringWithFormat:@"SELECT * FROM %@",tableName];
    
    NSLog(@"sql:-----%@",sql);
    if (groupBy) {
        sql=[NSString stringWithFormat:@"%@ GROUP BY %@",sql,groupBy];
    }
    if (desc) {
        if (orderBy) {
            sql=[NSString stringWithFormat:@"%@ ORDER BY %@ desc",sql,orderBy];
        }
    }else{
        if (orderBy) {
            sql=[NSString stringWithFormat:@"%@ ORDER BY %@",sql,orderBy];
        }
    }
    //如果读取的数据条数不为零，加查询限制
    if (count!=0) {
        sql=[NSString stringWithFormat:@"%@ LIMIT %ld,%ld",sql,(long)startIndex,(long)count];
    }
    
    FMResultSet *rs;
    //    if (whereStr) {
    //        rs=[GMDatabase executeQuery:sql,[model valueForKey:whereStr]];
    //    }
    //    else{
    //        rs=[GMDatabase executeQuery:sql];
    //    }
    rs=[GMDatabase executeQuery:sql];
    NSMutableArray *resultArray=[NSMutableArray array];
    while ([rs next]) {
        NSDictionary *dict=[rs resultDictionary];
        id object=[[[model class] alloc] init];
        [object setValuesForKeysWithDictionary:dict];
        [resultArray addObject:object];
    }
    return resultArray;
}
-(NSArray *)readData:(NSInteger)startIndex count:(NSInteger)count model:(id)model where:(id)object value:(id)value{
    
    //类名就是表名
    NSString *tableName=NSStringFromClass([model class]);
    //    NSString *sql=[NSString stringWithFormat:@"SELECT %@ FROM %@",itemsql,tableName];
    NSString *sql=[NSString stringWithFormat:@"SELECT * FROM %@",tableName];
    
    if (object) {
        sql=[NSString stringWithFormat:@"%@ where %@='%@' ",sql ,object,value];
        
    }
    //如果读取的数据条数不为零，加查询限制
    if (count!=0) {
        sql=[NSString stringWithFormat:@"%@ LIMIT %ld,%ld",sql,(long)startIndex,(long)count];
    }
    
    NSLog(@"sql:-----%@",sql);
    
    FMResultSet *rs;
    rs=[GMDatabase executeQuery:sql];
    NSMutableArray *resultArray=[NSMutableArray array];
    while ([rs next]) {
        NSDictionary *dict=[rs resultDictionary];
        id object=[[[model class] alloc] init];
        [object setValuesForKeysWithDictionary:dict];
        [resultArray addObject:object];
    }
    return resultArray;
    
}
-(NSArray *)readData:(NSInteger)startIndex count:(NSInteger)count model:(id)model where:(id)object value:(id)value andWhere:(id)object2 andValue:(id)value2 orderBy:(NSString *)orderBy desc:(BOOL)desc{

    //类名就是表名
    NSString *tableName=NSStringFromClass([model class]);
    //    NSString *sql=[NSString stringWithFormat:@"SELECT %@ FROM %@",itemsql,tableName];
    NSString *sql=[NSString stringWithFormat:@"SELECT * FROM %@",tableName];
    
    if (object2) {
        sql=[NSString stringWithFormat:@"%@ where %@='%@' and %@='%@'",sql ,object,value,object2,value2];
        
    }else{
        sql=[NSString stringWithFormat:@"%@ where %@='%@' ",sql ,object,value];
        
    }
    if (desc) {
        if (orderBy) {
            sql=[NSString stringWithFormat:@"%@ ORDER BY %@ desc",sql,orderBy];
        }
    }else{
        if (orderBy) {
            sql=[NSString stringWithFormat:@"%@ ORDER BY %@",sql,orderBy];
        }
    }
    //如果读取的数据条数不为零，加查询限制
    if (count!=0) {
        sql=[NSString stringWithFormat:@"%@ LIMIT %ld,%ld",sql,(long)startIndex,(long)count];
    }
    
    NSLog(@"sql:-----%@",sql);
    
    FMResultSet *rs;
    rs=[GMDatabase executeQuery:sql];
    NSMutableArray *resultArray=[NSMutableArray array];
    while ([rs next]) {
        NSDictionary *dict=[rs resultDictionary];
        id object=[[[model class] alloc] init];
        [object setValuesForKeysWithDictionary:dict];
        [resultArray addObject:object];
    }
    return resultArray;
    
}
-(NSArray*)selectData:(NSString *)title subtitle:(NSString *)subtitle keyWord:(NSString *)keyWord model:(id)model
{
    NSMutableArray *array=[NSMutableArray array];
    
    NSDictionary *propertyDict=[model propertyList:NO];
    NSArray *propertyList=[propertyDict allKeys];
    NSString *itemsql=[propertyList componentsJoinedByString:@","];
    
    //类名就是表名
    NSString *tableName=NSStringFromClass([model class]);
    NSString *sql=[NSString stringWithFormat:@"SELECT %@ FROM %@",itemsql,tableName];
    
    //    NSString *str1;
    //    NSString *str2;
    //    if (title) {
    //        str1=[NSString stringWithFormat:@"%@=?",title];
    //    }
    //    if (subtitle) {
    //        str2=[NSString stringWithFormat:@"%@=?",subtitle];
    //    }
    if (title && subtitle && keyWord) {
        NSString *key=[NSString stringWithFormat:@"%@%@%@",@"%%",keyWord,@"%%"];
        sql=[NSString stringWithFormat:@"%@ WHERE %@=? AND %@=? AND title like ?",sql,title,subtitle];
        
        FMResultSet *rs;
        rs=[GMDatabase executeQuery:sql,[model valueForKey:title],[model valueForKey:subtitle],key];
        
        while ([rs next]) {
            NSDictionary *dict=[rs resultDictionary];
            id object=[[[model class] alloc] init];
            [object setValuesForKeysWithDictionary:dict];
            [array addObject:object];
        }
    }
    
    return array;
}
-(NSInteger)CheckInfoCount:(id)object{
    NSString *tableName=NSStringFromClass([object class]);
    NSLog(@"tableName：%@",tableName);
    //类名就是表名
    NSString *countSql =[NSString stringWithFormat:@"SELECT count(*) FROM %@",tableName];
    FMResultSet *rs = [GMDatabase executeQuery:countSql];
    //行数 就一个值
    NSInteger count = 0;
    while ([rs next]) {
        count = [rs intForColumnIndex:0];
    }
    return count;
    
}
@end
