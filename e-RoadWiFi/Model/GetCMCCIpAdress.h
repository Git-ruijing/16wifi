//
//  GetCMCCIpAdress.h
//  GetJson
//
//  Created by JAY on 13-8-16.
//  Copyright (c) 2013年 HE ZHENJIE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/CaptiveNetwork.h>


@interface GetCMCCIpAdress : NSObject

+(NSString *)getSSID;
+(NSString*)getBSSIDStandard;
@end
