
//
//  JAYDownload.m
//  e路WiFi
//
//  Created by JAY on 13-11-21.
//  Copyright (c) 2013年 HE ZHENJIE. All rights reserved.
//

#import "JAYDownload.h"
#import "RootUrl.h"
#import "AppDelegate.h"
#import "MobClick.h"
@implementation JAYDownload
@synthesize mData;
@synthesize tag,vImage,vLabel,vName,vTime,a,videoImage,schedule,delegate;
-(void)downloadFromUrl:(NSURL *)url
{
    AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [app.downingVideoArray addObject:self];
    mData=[[NSMutableData alloc] init];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    //连接一旦建立，就启动了异步下载
    mConnection=[[NSURLConnection alloc]initWithRequest:request delegate:self];
}

//收到服务器的回应
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    a=response.expectedContentLength/1024;

    //清空旧数据
    [mData setLength:0];
}
//收到服务器发送的数据,此就法会多次调用
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    float b=mData.length/1024;
    
    schedule=[NSString stringWithFormat:@"%f",b/a];
    AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    if(app.downManageIsIn){
       
     
             [delegate setValue:schedule andWithTag:self.tag];
        
    }
    
    
    

    
    [mData appendData:data];
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [app.downingVideoArray removeObject:self];
}


//下载完成
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    NSString *sandBoxPath=NSHomeDirectory();
    NSString *vieoPath=[sandBoxPath stringByAppendingPathComponent:@"Library/Caches"];
    NSString *filePath=[vieoPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",vName]];
    [mData writeToFile:filePath atomically:YES];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSMutableArray *arr=[NSMutableArray arrayWithArray:[defaults objectForKey:@"video"]];
    NSDictionary *dictionary=[[NSDictionary alloc]initWithObjectsAndKeys:vName,@"title",UIImagePNGRepresentation(videoImage),@"image",vLabel,@"label",vTime,@"time", nil];
    [arr addObject:dictionary];
    [defaults setObject:arr forKey:@"video"];
    [defaults synchronize];
    
    NSString *strNotice;
    if (vName.length>11) {
        strNotice=[NSString stringWithFormat:@"%@...",[vName substringToIndex:10]];
    }else{
        strNotice=[NSString stringWithString:vName];
    }
    AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [app.downingVideoArray removeObject:self];
    [app setNotice:[NSString stringWithFormat:@"%@ 下载完成",vName]];
#pragma mark  广告位点击统计
    NSDictionary *dict = @{@"type" :@"finish",@"name":vName};
    [MobClick event:@"video_down" attributes:dict];
    if(app.downManageIsIn){

             [delegate downloadFinish];
       
    }
    //是否能响应（实现）指定方法
}
-(void)cancel{
    AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [app.downingVideoArray removeObject:self];
    [mConnection cancel];
}

@end
