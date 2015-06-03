//
//  MyObject.m
//  e-RoadWiFi
//
//  Created by QC on 14-8-8.
//  Copyright (c) 2014年 G.MING. All rights reserved.
//

#import "MyObject.h"
#import <objc/runtime.h>
@implementation MyObject
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"forUndefinedKey::%@",key);
}

-(NSString*)keySqlString:(NSArray *)nameArray
{
    NSDictionary *dict=[self propertyList:NO];
    
    NSString *sql= [[dict allKeys] componentsJoinedByString:@" text,"];
    
    sql=[sql substringToIndex:[sql length]-1];
    
    NSLog(@"%@",sql);
    return sql;
}
- (NSDictionary *)toDictionary
{
    NSMutableDictionary *dictionaryFormat = [NSMutableDictionary dictionary];

    Class cls = [self class];
    
    unsigned int ivarsCnt = 0;
    Ivar *ivars = class_copyIvarList(cls, &ivarsCnt);

    for (const Ivar *p = ivars; p < ivars + ivarsCnt; ++p)
    {
        Ivar const ivar = *p;

        NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];

        id value = [self valueForKey:key];
        
        const char *type = ivar_getTypeEncoding(ivar);
        
        NSLog(@"%@ type:%@",key,[NSString stringWithCString:type encoding:NSUTF8StringEncoding]);
        
        if (value)
        {
            [dictionaryFormat setObject:value forKey:key];
        }
    }
    return dictionaryFormat;
}
- (NSDictionary *)propertyList:(BOOL)isWrite
{
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    unsigned int outCount, i;

    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i<outCount; i++) {

        objc_property_t property = properties[i];
        
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding] ;
        
        id propertyValue = [self valueForKey:(NSString *)propertyName];
        if (isWrite) {
            if (propertyValue)
            {
                [props setObject:propertyValue forKey:propertyName];
            }
        }
        else{
            [props setObject:[NSNull null] forKey:propertyName];
        }
        
    }
    free(properties);
    return props;
}

@end
