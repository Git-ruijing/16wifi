//
//  HttpManager.h
//  e-RoadWiFi
//
//  Created by QC on 14-8-6.
//  Copyright (c) 2014年 G.MING. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpManager : NSObject
{
    //保存请求任务
    NSMutableDictionary *taskDict;
}

+(HttpManager *)sharedManager;
-(void)addTask:(NSString *)url delegate :(id)delegate action:(SEL)action;
-(void)removeTask:(NSString *)url;
-(void)stopAllTask:(NSDictionary *)dict;

@end
