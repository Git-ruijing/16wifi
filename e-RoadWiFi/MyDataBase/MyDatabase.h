//
//  MyDatabase.h
//  e-RoadWiFi
//
//  Created by QC on 14-8-1.
//  Copyright (c) 2014年 G.MING. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "FMDatabase.h"
@interface MyDatabase : NSObject
{
    FMDatabase *GMDatabase;
    NSString *fullPath;
}

+(NSString*)filePath:(NSString*)fileName;

+(MyDatabase*)sharedDatabase;

-(NSArray *)readData:(NSInteger)startIndex count:(NSInteger)count model:(id)model grounBy:(NSString*)groupBy orderBy:(NSString *)orderBy desc:(BOOL )desc;
-(NSArray *)readData:(NSInteger)startIndex count:(NSInteger)count model:(id)model where:(id)object value:(id)value;
-(NSArray *)readData:(NSInteger)startIndex count:(NSInteger)count model:(id)model where:(id)object value:(id)value andWhere:(id)object2 andValue:(id)value2 orderBy:(NSString *)orderBy desc:(BOOL)desc;
//插入一条记录
-(void)insertItem:(id)object;
//插入多条记录
-(void)insertArray:(NSArray*)array;

-(void)deleteTable:(id)object;
-(NSArray *)selectData:(NSString*)title subtitle:(NSString*)subtitle keyWord:(NSString*)keyWord model:(id)model;
-(void)createTable:(NSArray*)modelNameArray;
- (NSInteger)CheckInfoCount:(id)object;
-(void)deleteTableName:(id)tableName where:(id)object value:(id)values;
-(void)updataTable:(id)tableName setField:(id)field  Value:(id)value where:(id)object value:(id)values;
-(void)updataTable:(id)tableName setField:(id)field  Value:(id)value where:(id)object FieldType:(NSString *)type;

@end
