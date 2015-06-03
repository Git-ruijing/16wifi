//
//  GetCMCCIpAdress.m
//  GetJson
//
//  Created by JAY on 13-8-16.
//  Copyright (c) 2013年 HE ZHENJIE. All rights reserved.
//

#import "GetCMCCIpAdress.h"

@implementation GetCMCCIpAdress
+(NSString*)getBSSIDStandard{
    NSArray *ifs = (__bridge id)CNCopySupportedInterfaces();
    
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        
        if (info && [info count]) {
            break;
        }
        
    }

    //得到BSSID
    NSString *ssid=[(NSDictionary*)info objectForKey:@"SSID"];
    if ([ssid isEqualToString:@"(null)"]) {
        return @"nil";
    }
    NSString * macAdress=[(NSDictionary*)info objectForKey:@"BSSID"];
    //将所得BSSID转换成标准查询格式 XXXX-XXXX-XXXX
    NSArray *arr=[macAdress componentsSeparatedByString:@":"];
    NSString *newMacAdress;
    int i;
    for (i=0; i<arr.count; i++) {
        NSString *str=[arr objectAtIndex:i];
        if (str.length<2) {
            str=[NSString stringWithFormat:@"0%@",str];
        }
        if (i==0) {
            newMacAdress=str;
        }else{
            if ((i%2)==0) {
                newMacAdress=[NSString stringWithFormat:@"%@-%@",newMacAdress,str];
            }else{
                newMacAdress=[NSString stringWithFormat:@"%@%@",newMacAdress,str];
            }
        }
    }
    //得到查询标准格式BSSID
    newMacAdress=[newMacAdress uppercaseString];
    return  newMacAdress;

}

+(NSString *)getSSID{ 
    NSArray *ifs = (__bridge id)CNCopySupportedInterfaces();
    
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info && [info count]) {
            break;
        }
       
    }
 
    NSString * apSSIDAdress=[(NSDictionary*)info objectForKey:@"SSID"];
    return apSSIDAdress;
}
@end
