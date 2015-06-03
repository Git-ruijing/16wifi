//
//  HttpRequest.h
//  e-RoadWiFi
//
//  Created by QC on 14-8-6.
//  Copyright (c) 2014年 G.MING. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpRequest : NSObject<NSURLConnectionDataDelegate>
{
    NSURLConnection *httpConnection;
    
    NSTimer *timer;
    
    float CurrentSpeed;
    float Total;
    float Current;
    int count;
}
//保存下载数据
@property (nonatomic,readonly)NSMutableData *downloadData;
//请求接口
@property (nonatomic,copy)NSString *httpUrl;
//处理请求结果的对象
@property (nonatomic,assign )id delegate;
//处理结果对象的某个方法
@property(nonatomic,assign) SEL method;

@property (nonatomic,assign )int tag;

-(void)requestFromUrl;
-(void)stop;


@end
