//
//  NSObject+GmingAdd.m
//  e-RoadWiFi
//
//  Created by QC on 14-8-7.
//  Copyright (c) 2014年 G.MING. All rights reserved.
//

#import "NSObject+GmingAdd.h"
#import <objc/runtime.h>
@implementation NSObject (GmingAdd)
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"forUndefinedKey::%@",key);
}

- (NSDictionary *)toDictionary
{
    NSMutableDictionary *dictionaryFormat = [NSMutableDictionary dictionary];
    
    Class cls = [self class];
    
    //父类
    //cls = class_getSuperclass(cls);
    //    if (cls==[NSObject class]) {
    //        return;
    //    }
    unsigned int ivarsCnt = 0;

    Ivar *ivars = class_copyIvarList(cls, &ivarsCnt);

    for (const Ivar *p = ivars; p < ivars + ivarsCnt; ++p)
    {
        Ivar const ivar = *p;
 
        NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];

        id value = [self valueForKey:key];

        const char *type = ivar_getTypeEncoding(ivar);
        
        NSLog(@"key type:%@",[NSString stringWithCString:type encoding:NSUTF8StringEncoding]);
        
        if (value)
        {
            [dictionaryFormat setObject:value forKey:key];
        }
    }
    NSLog(@"%@",dictionaryFormat);
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
