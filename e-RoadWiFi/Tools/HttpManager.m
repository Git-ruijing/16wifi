//
//  HttpManager.m
//  e-RoadWiFi
//
//  Created by QC on 14-8-6.
//  Copyright (c) 2014年 G.MING. All rights reserved.
//

#import "HttpManager.h"
#import "HttpRequest.h"
@implementation HttpManager
+(HttpManager *)sharedManager{
    static HttpManager *manager;
    if (!manager) {
        manager=[[HttpManager alloc]init];
    }
    return manager;
}
-(id)init{
    if (self=[super init]) {
        taskDict=[[NSMutableDictionary alloc]init];
    }
    return self;
}
-(void)addTask:(NSString *)url delegate:(id)delegate action:(SEL)action{
    HttpRequest *request=[taskDict objectForKey:url];
    if (!request) {
        request=[[HttpRequest alloc]init];
        request.delegate=delegate;
        request.method=action;
        request.httpUrl=url;
        if ([url hasSuffix:@"16wifi.apk"]) {
            request.tag=1616;
        }
        [request requestFromUrl];
        

        [taskDict setObject:request forKey:url];
    }else{
        NSLog(@"任务已存在%@",url);
    }
}
-(void)stopAllTask:(NSDictionary *)dict{
    
    for (NSString *url in dict) {
        HttpRequest *request=[taskDict objectForKey:url];
        [request stop];
        [taskDict removeObjectForKey:url];
    }
}
-(void)removeTask:(NSString *)url{

    HttpRequest *request=[taskDict objectForKey:url];
    if (request) {
        [request stop];
        [taskDict removeObjectForKey:url];
    }else{
        NSLog(@"任务已删除%@",url);
    }
    
}
@end
