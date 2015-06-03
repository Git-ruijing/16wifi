//
//  JAYDownload.h
//  e路WiFi
//
//  Created by JAY on 13-11-21.
//  Copyright (c) 2013年 HE ZHENJIE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VedioItem.h"
@protocol JAYDownloadDelegate;
@interface JAYDownload : NSObject<NSURLConnectionDataDelegate>
{
    //网络连接类实例
    NSURLConnection *mConnection;
    //下载的数据
    NSMutableData *mData;
    
    
    
}
@property (nonatomic,readonly)NSMutableData *mData;
@property (nonatomic,strong)NSString *vName;
@property (nonatomic,strong)UIImage *videoImage;
@property (nonatomic,strong)NSString *vLabel;
@property (nonatomic,strong)NSString *vTime;
@property (nonatomic,strong)NSString *vImage;
@property(nonatomic,readwrite)int tag;
@property(nonatomic,readwrite)float a;
@property(nonatomic,strong)NSString *schedule;
@property (nonatomic,unsafe_unretained) id<JAYDownloadDelegate> delegate;
//从指定的网址下载数据
-(void)downloadFromUrl:(NSURL*)url;
-(void)cancel;
@end

@protocol JAYDownloadDelegate
@optional
-(void)downloadFinish;
-(void)setValue:(NSString *)sch andWithTag:(int)tag;
@end

