//
//  RequestForLoginNet.m
//  e-RoadWiFi
//
//  Created by Jay on 14-9-25.
//  Copyright (c) 2014年 G.MING. All rights reserved.
//

#import "RequestForLoginNet.h"

@implementation RequestForLoginNet
@synthesize mData;
@synthesize tag,mError;


-(void)requestFromUrl:(NSURL *)url andWithTimeoutInterval:(NSTimeInterval)timeoutInterval
{
    
    mData=[[NSMutableData alloc] init];
    NSURLRequest *request=[[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData  timeoutInterval:timeoutInterval];
    //连接一旦建立，就启动了异步下载
    mConnection=[[NSURLConnection alloc]initWithRequest:request delegate:self];
    
}
//收到服务器的回应
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
    //清空旧数据

        [_delegate forLoginReceiveResponse:response andWith:self];
    
  
    [mData setLength:0];
    
}
//收到服务器发送的数据,此就法会多次调用
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
    [mData appendData:data];
    
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    mError=error;
        [_delegate forLoginRequestFaild:self];
   
   
}
//下载完成
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
        [_delegate forLoginRequestComplete:self ];
    

    
}
-(void)cancel{
    
    [mConnection cancel];
}
@end
