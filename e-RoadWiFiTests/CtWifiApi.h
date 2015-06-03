//
//  CtWifiApi.h
//  CtWifiApi
//
//  Created by akazam on 13-6-28.
//  Copyright (c) 2013年 akazam. All rights reserved.
//

#import <Foundation/Foundation.h>



/**
 *  登录登出的错误信息
 */

typedef NS_ENUM(NSInteger, TY_ERROR_CODE)
{
    /**
     *  登录或登出时，与ChinaNet热点未连接
     */
    TY_AP_NOTCONN_ERROR = -1000,
    /**
     *  卡格式错误
     */
    TY_CARD_FORMAT_ERROR ,
    
    /**
     *  证书错误
     */
    TY_LICENCE_ERROR,
    
    /**
     *  还在登陆中
     */
    TY_WAIT_LAST_LOGIN_ERROR,
    
    /**
     *  找不到入口地址
     */
    TY_FIND_ENTRY_ERROR,
    
    /**
     *  服务器无响应
     */
    TY_NO_RESPONSE_ERROR,
    
    /**
     *  登录失败
     */
    TY_LOGIN_ERROR,
    
    /**
     *  卡密不正确
     */
    TY_INVALID_ACCOUNT_ERROR,
    
    /**
     *  Radius服务器错误
     */
    TY_RADIUS_ERROR,
    
    /**
     *  网关错误
     */
    TY_GATEWAY_ERROR,
    
    /**
     *  登出错误
     */
    TY_LOGOUT_ERROR,
};

/**
 *  登录登出的进行状态
 */
typedef NS_ENUM(NSInteger, TYWIFI_STATE){

    /**
     *  正在登录
     */
    TY_LOGING,
    
    /**
     *  正在查找入口
     */
    TY_FINDING_ENTRY,

    /**
     *  正在认证
     */
    TY_AUTHING,
    
    /**
     *  正在登出
     */
    TY_LOGOUTING,
};



/**
 *  检测手机与Chinanet热点之间的连接状态
 */
typedef NS_ENUM(NSInteger, TY_NET_CONNECT)
{
    /**
     *  没有连接到热点
     */
   
    TY_CONNECT_NONE,
    
    /**
     *  连接到热点但是不能上网
     */

    TY_CONNECT_AP,

    /**
     *  连接到热点，且认证通过，能够上网
     */
   
    TY_CONNECT_CHINANET,

    /**
     *  从连接状态断开与ChinaNet的连接
     */
   
    TY_CONNECT_DISCONNECT,

};

/**
 *  检测状态变化的回调
 *
 *  @param state  状态码 对应TY_NET_CONNECT 和 TYWIFI_STATE
 *  @param status 状态说明
 */
typedef void(^TYWiFiProgressBlock)(int state,NSString *status);


/**
 *  登录登出的结果回调 errorInfo为nil表示没有错误产生
 *
 *  @param errorInfo code:对应枚举TY_ERROR_CODE localizedDescription：对应错误说明
 */
typedef void(^TYWiFiCompleteBlock)(NSError *errorInfo);




@interface CtWifiApi : NSObject{

}


/**
 *   天翼认证SDK单例
 *
 *  @return CtWifiApi单例
 */

+ (instancetype) sharedAPI;

/**
 *  打开Log 方便调试
 *
 *  @param enable TRUE 打开  FALSE 关闭
 */
+(void)setLogEnable:(BOOL)enable;


/**
 *  得到登录时间
 *
 *  @return 登录时间 long型
 */

-(long) getLoginTime;

/**
 *  得到剩余时长，涉及到网络操作，所以用回调形式
 *
 *  @param timeBlock 
 */

-(void) getTimeLeft:(void (^)(long timeleft))timeBlock;



/**
 *  登录时间已返回整形 现已经deprecated
 *
 *  @return 登录时间 NSString型
 */


- (NSString*) getLoginTimeString  __attribute__ ((deprecated));



/**
 *  剩余时长 已返回整形 现已经deprecated
 *
 *  @return 剩余时长 NSString型
 */

-(NSString*) getTimeLeftString __attribute__ ((deprecated));


/**
 *  是否登录
 *
 *  @return TRUE 登录 FALSE 没有登录
 */

-(BOOL) isLogin;


/**
 *  是否连接上因特网
 *
 *  @param connBlock 返回连接因特网状态
 */

-(void) isNetWorkReachable:(void(^)(BOOL isInternetConnect))connBlock;

/**
 *  是否连接上ChinaNet热点
 *
 *  @return TRUE 已连上ChinaNet FALSE 未连上
 */

-(BOOL) isApConnected;



/**
 *  登录，只有成功和失败得回调，没有过程回调
 *
 *  @param username      用户名
 *  @param password      密码
 *  @param completeBlock 登录结果回调  errorInfo为nil表示没有错误产生，登陆成功
 */

-(void) login:(NSString *)username password:(NSString *)password completeBlock:(TYWiFiCompleteBlock)completeBlock;

/**
 *  登录，有过程回调和完成状态回调
 *
 *  @param username      用户名
 *  @param password      密码
 *  @param progressBlock 登录过程回调 状态码 对应TYWIFI_STATE
 *  @param completeBlock 登录结果回调  errorInfo为nil表示没有错误产生，登陆成功
 */

-(void) login:(NSString *)username password:(NSString *)password progressBlock:(TYWiFiProgressBlock)progressBlock completeBlock:(TYWiFiCompleteBlock)completeBlock;


/**
 *  有回调结果的logout 如果不想有回调 block为nil即可
 *
 *  @param block 登出结果回调  errorInfo为nil表示没有错误产生,登出成功
 */
-(void)logout:(TYWiFiCompleteBlock)block;

@end
