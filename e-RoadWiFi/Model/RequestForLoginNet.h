//
//  RequestForLoginNet.h
//  e-RoadWiFi
//
//  Created by Jay on 14-9-25.
//  Copyright (c) 2014年 G.MING. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol RequestForLoginNetDelegate;
@interface RequestForLoginNet : NSObject<NSURLConnectionDataDelegate>
{
    //网络连接类实例
    NSURLConnection *mConnection;
    //下载的数据
    NSMutableData *mData;
    NSError *mError;
  
}
@property (nonatomic,readonly)NSMutableData *mData;
@property (nonatomic,readonly)NSError *mError;
@property (nonatomic,unsafe_unretained) id<RequestForLoginNetDelegate> delegate;
@property(nonatomic,readwrite)int tag;
//从指定的网址下载数据
-(void)cancel;
-(void)requestFromUrl:(NSURL *)url andWithTimeoutInterval:(NSTimeInterval)timeoutInterval;
@end


@protocol RequestForLoginNetDelegate
@optional
-(void)forLoginReceiveResponse:(NSURLResponse *)response andWith:(RequestForLoginNet*)hd;
-(void)forLoginRequestFaild:(RequestForLoginNet*)hd;
-(void)forLoginRequestComplete:(RequestForLoginNet*)hd;
@end
