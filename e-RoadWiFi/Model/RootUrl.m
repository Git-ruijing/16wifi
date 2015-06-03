//
//  RootUrl.m
//  e路WiFi
//
//  Created by JAY on 13-11-1.
//  Copyright (c) 2013年 HE ZHENJIE. All rights reserved.
//

#import "RootUrl.h"
#import "GetCMCCIpAdress.h"
#import <CommonCrypto/CommonDigest.h>

@implementation RootUrl

+(NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ]; 
}

+(NSString*)getContentUrl{
    NSString *contentRootUrl;
    if ([[GetCMCCIpAdress getSSID]isEqualToString:@"16wifi"]) {
        if ([self getIsBeiJingHuaWei]) {
            contentRootUrl=@"http://192.100.100.100";
        }else{
            contentRootUrl=@"http://m.16wifi.com";
        }
    }else{
        NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
        contentRootUrl= [userDefaults objectForKey:@"rootUrl"];
        
    }
    return contentRootUrl;
}
+(void)setIsBeiJingHuaWei:(BOOL)flag{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setBool:flag forKey:@"isBeiJingHuaWei"];
    [userDefaults synchronize];

}
+(BOOL)getIsBeiJingHuaWei{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    
    return  [userDefaults boolForKey:@"isBeiJingHuaWei"];
}
+(void)setIsNetOn:(BOOL)net{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setBool:net forKey:@"isOnNet"];
    [userDefaults synchronize];
}
+(BOOL)getIsNetOn{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    
    return  [userDefaults boolForKey:@"isOnNet"];
}
+(void)setCity:(NSString *)city{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setObject:city forKey:@"city"];
    [userDefaults synchronize];
}
+(NSString *)getCity{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    NSString *string=[userDefaults objectForKey:@"city"];
    return string;
}
+(void)setRootUrl:(NSString *)url{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setObject:url forKey:@"rootUrl"];
    [userDefaults synchronize];
}
+(NSString *)getRootUrl{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    NSString *string=[userDefaults objectForKey:@"rootUrl"];
    return string;
}
+(void)setFreeLogOutReq:(NSString *)logOutReq{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setObject:logOutReq forKey:@"freeLogOut"];
    [userDefaults synchronize];
}
+(NSString *)getFreeLogOutReq{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    NSString *string=[userDefaults objectForKey:@"freeLogOut"];
    return string;
}
+(void)setBeiJingLogOutReq:(NSString *)logOutReq{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setObject:logOutReq forKey:@"beijingLogOut"];
    [userDefaults synchronize];
}
+(NSString *)getBeiJingLogOutReq{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    NSString *string=[userDefaults objectForKey:@"beijingLogOut"];
    return string;
}
+(NSString *)getNetStatus{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    NSString *string=[userDefaults objectForKey:@"netStatus"];
    return string;
}
+(void)setNetStatus:(NSString *)net{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setObject:net forKey:@"netStatus"];
    [userDefaults synchronize];
}
+(NSString *)getFeedBackDate{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    NSString *string=[userDefaults objectForKey:@"feedBackDate"];
    return string;
}
+(void)setFeedBackDate:(NSString *)net{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setObject:net forKey:@"feedBackDate"];
    [userDefaults synchronize];
}

+(void)setUMLogTimeFlag:(NSString *)flag{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setObject:flag forKey:@"UMLogTimeFlag"];
    [userDefaults synchronize];
}
+(void)setUMLogClickFlag:(NSInteger)tag{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
      [userDefaults setInteger:tag forKey:@"UMLogClickFlag"];
    [userDefaults synchronize];
}
+(NSString *)getUMLogTimeFlag{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    NSString *string=[userDefaults objectForKey:@"UMLogTimeFlag"];
    return string;
}
+(NSInteger)getUMLogClickFlag{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    NSInteger string=[userDefaults integerForKey:@"UMLogClickFlag"];
    return string;
}
+(NSString *)getIDFA{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    NSString *string=[userDefaults objectForKey:@"idfa"];
    return string;
}
+(void)setIDFA:(NSString *)flag{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setObject:flag forKey:@"idfa"];
    [userDefaults synchronize];
}
@end
