//
//  NSObject+GmingAdd.h
//  e-RoadWiFi
//
//  Created by QC on 14-8-7.
//  Copyright (c) 2014年 G.MING. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (GmingAdd)
-(NSDictionary *)propertyList:(BOOL)isWrite;
- (NSDictionary *)toDictionary;
-(void)setValue:(id)value forUndefinedKey:(NSString *)key;

@end
