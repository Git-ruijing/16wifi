//
//  RootUrl.h
//  e路WiFi
//
//  Created by JAY on 13-11-1.
//  Copyright (c) 2013年 HE ZHENJIE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RootUrl : NSObject
+(NSString*)getContentUrl;
+(void)setIsBeiJingHuaWei:(BOOL)flag;
+(BOOL)getIsBeiJingHuaWei;
+(void)setRootUrl:(NSString *)url;
+(NSString *)getRootUrl;
+(void)setIsNetOn:(BOOL)net;
+(BOOL)getIsNetOn;
+(void)setNetStatus:(NSString *)net;
+(NSString *)getNetStatus;
+(NSString *)getFeedBackDate;
+(void)setFeedBackDate:(NSString *)net;
+(void)setFreeLogOutReq:(NSString *)logOutReq;
+(NSString *)getFreeLogOutReq;
+(void)setBeiJingLogOutReq:(NSString *)logOutReq;
+(NSString *)getBeiJingLogOutReq;
+(NSString *)getCity;
+(void)setCity:(NSString *)city;
+(NSString *)md5:(NSString *)str;
+(NSInteger)getUMLogClickFlag;
+(NSString *)getUMLogTimeFlag;
+(void)setUMLogClickFlag:(NSInteger)tag;
+(void)setUMLogTimeFlag:(NSString *)flag;
+(void)setIDFA:(NSString *)flag;
+(NSString *)getIDFA;
@end
