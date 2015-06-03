//
//  HttpDownload.m
//  JsonDemo
//
//  Created by DuHaiFeng on 13-2-19.
//  Copyright (c) 2013年 dhf. All rights reserved.
//

#import "HttpDownload.h"

@implementation HttpDownload
@synthesize mData;
@synthesize tag,mError;
-(void)downloadFromUrl:(NSURL *)url andWithString:(NSString *)string
{
    
    mData=[[NSMutableData alloc] init];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSData *httpBody=[string dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:httpBody];
   
    //连接一旦建立，就启动了异步下载
    mConnection=[[NSURLConnection alloc]initWithRequest:request delegate:self];

}
-(void)downloadFromUrl:(NSURL *)url
{
  
    mData=[[NSMutableData alloc] init];
    NSURLRequest *request=[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    //连接一旦建立，就启动了异步下载

    mConnection=[[NSURLConnection alloc]initWithRequest:request delegate:self];
  
}
-(void)downloadFromUrl:(NSURL *)url andWithTimeoutInterval:(NSTimeInterval)timeoutInterval
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
    [mData setLength:0];

}
//收到服务器发送的数据,此就法会多次调用
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{

       [mData appendData:data];
    
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
  
    mError=error;
   
    if ([self.delegate respondsToSelector:self.DFailed]) {
        [self.delegate performSelector:self.DFailed withObject:self];
   
    }
    
   
}
//下载完成
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
   
    if ([self.delegate respondsToSelector:self.DComplete]) {
        [self.delegate performSelector:self.DComplete withObject:self];
       
    }
}
-(void)cancel{

    [mConnection cancel];
}
@end
