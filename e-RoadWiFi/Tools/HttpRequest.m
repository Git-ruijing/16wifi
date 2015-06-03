//
//  HttpRequest.m
//  e-RoadWiFi
//
//  Created by QC on 14-8-6.
//  Copyright (c) 2014年 G.MING. All rights reserved.
//

#import "HttpRequest.h"
#import "HttpManager.h"
@implementation HttpRequest
-(id)init
{
    if (self=[super init]) {
        _downloadData=[[NSMutableData alloc]init];
        count=0;
       }
    return self;
}
-(void)requestFromUrl{
    if (httpConnection) {
        [httpConnection cancel];
        httpConnection=nil;
    }
#pragma mark 转换中文
    NSString *newUrlStr = [self.httpUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url=[NSURL URLWithString:newUrlStr];
    
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    
    httpConnection=[[NSURLConnection alloc]initWithRequest:request delegate:self];
    //   [self showLoading];
    
}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    //获取数据的长度
    if (self.tag==1616) {
        Total=response.expectedContentLength/1024;  //KB
        NSDateFormatter *date=[[NSDateFormatter alloc] init];
        [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
        [def setValue:[date stringFromDate:[NSDate date]] forKey:@"RequestDate"];
        [def synchronize];
        
        timer=[NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(SaveCurrentSpeed) userInfo:nil repeats:YES];

    }
      [_downloadData setLength:0];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    //接收下载数据

    
    if (self.tag==1616) {
        Current=_downloadData.length/1024;
        
        NSDateFormatter *date=[[NSDateFormatter alloc] init];
        [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
        NSDate *d=[date dateFromString:[def objectForKey:@"RequestDate"]];
        NSTimeInterval late=[d timeIntervalSince1970]*1;
        NSTimeInterval cha=[[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970]*1-late;
        CurrentSpeed=(Current/cha);
    }
    [_downloadData appendData:data];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    if ([self.delegate respondsToSelector:self.method]) {
        [self.delegate performSelector:self.method withObject:self];
       
    }
    [[HttpManager sharedManager] removeTask:self.httpUrl];
}
-(void)SaveCurrentSpeed{
    
    if (count++<=35) {
        NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
        [def setObject:[NSString stringWithFormat:@"%f",CurrentSpeed] forKey:@"CurrentSpeed"];
        [def synchronize];
        NSLog(@"LoadSpeed%f ",CurrentSpeed);
    }else{
    
        [[HttpManager sharedManager] removeTask:self.httpUrl];
        [timer invalidate];
        timer = nil;
        count=0;
    }

}

-(void)stop{
    if (httpConnection) {
        [httpConnection cancel];
        httpConnection=nil;
        self.delegate=nil;
    }
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"请求失败");
    [_downloadData setLength:0];
    if ([self.delegate respondsToSelector:self.method]) {
        [self.delegate performSelector:self.method withObject:self];
    }
}
@end
