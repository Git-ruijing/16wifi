//
//  HttpDownload.h
//  JsonDemo
//
//  Created by DuHaiFeng on 13-2-19.
//  Copyright (c) 2013年 dhf. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HttpDownload : NSObject<NSURLConnectionDataDelegate>
{
    //网络连接类实例
    NSURLConnection *mConnection;
    //下载的数据
    NSMutableData *mData;
    NSError *mError;
   
  
}
@property (nonatomic,readonly)NSMutableData *mData;
@property (nonatomic,readonly)NSError *mError;
@property (nonatomic,unsafe_unretained) id delegate;
@property(nonatomic,readwrite)int tag;
@property(nonatomic,assign) SEL DComplete;
@property(nonatomic,assign) SEL DFailed;
//从指定的网址下载数据
-(void)downloadFromUrl:(NSURL *)url andWithString:(NSString *)string;
-(void)downloadFromUrl:(NSURL*)url;
-(void)cancel;
-(void)downloadFromUrl:(NSURL *)url andWithTimeoutInterval:(NSTimeInterval)timeoutInterval;
@end



