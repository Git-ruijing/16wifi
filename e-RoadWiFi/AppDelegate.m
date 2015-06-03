//
//  AppDelegate.m
//  e-RoadWiFi
//
//  Created by QC on 14-8-1.
//  Copyright (c) 2014年 G.MING. All rights reserved.
//
//  NSUserDefaults isLogin 字段值为0 未初始化设置此字段 字段值为1 未登录已初始化设置次字段 字段值为2 已登录未设置用户昵称等个人资料 字段值为3 已登录已设置个人资料
//友盟统计头
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#include "MobClick.h"
#import <AdSupport/AdSupport.h>
//友盟分享
#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialWechatHandler.h"
#import "GM-PushNewsViewController.h"
#import "AppDelegate.h"
#import "RootUrl.h"
#import "GetCMCCIpAdress.h"
#import "WebSubPagViewController.h"
#import "BasicViewController.h"
#import "LaunchPageViewController.h"
#import "FirstOpenAnimationViewController.h"
#import "MyDatabase.h"
#import "PushInfoItem.h"
#import "cityItem.h"
#import "BandPhoneViewController.h"
#import "ZhuanPanViewController.h"
#import "UserViewController.h"
#import "RelateWxViewController.h"
#import <CommonCrypto/CommonDigest.h> // Need to import for CC_MD5 access
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
#import <UIKit/UIPasteboard.h>
#import <UIKit/UIKit.h>
#else
#import <AppKit/NSPasteboard.h>
#endif
#import "sys/utsname.h"
//#define UMENG_APPKEY @"53ad3c0056240b6a0d039210"
#define UMENG_APPKEY @"544da7affd98c5b22206a91a"

#define SCREENHEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SECRETKEY @"ilovewififorfree"
#define SWITCHOFF @"http://192.100.100.100/?isTunnelOpen=0"
@implementation AppDelegate
{
    
    NSArray *classView;
}
@synthesize downingVideoArray,downManageIsIn;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    
  
    
    isNewUser=0;
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor=[UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1];
    //视频下载相关
    downManageIsIn=0;
    downingVideoArray=[[NSMutableArray alloc]initWithCapacity:0];
    //应用启动标记 当应用首次启动 网络为普通WIFI 直接跳转为畅游频道  激活不跳转
    openFlag=1;
    //设置启动标记
    cityChackFlag=0;
    //存储推送消息 暂时使用 后续需存入本地数据库
    notificationDic=[[NSMutableDictionary alloc]initWithCapacity:0];
    
    //openFlag 标记第一次打开是否需要跳转到推荐频道
    //NSUserDefaults 字段说明
    //IsFirstOpen 安装首次启动 每次存入当前版本号
    
    pushInfoArray=[[NSMutableArray alloc]init];
    NSString * appVersion=[[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *oldVersion=[defaults objectForKey:@"IsFirstOpen"];
    if (!oldVersion) {
        //首次安装应用 初始化数据
        NSLog(@"首次安装");
        isNewUser=1;
        
        [self chackCity];
        
        [self copyDatabaseToDocuments];
        
        NSArray * arr1=@[@"热点",@"娱乐",@"财经",@"汽车",@"科技",@"生活"];
        NSArray * arr2=@[@"/json/hotnews.json",@"/json/entertainment.json",@"/json/finance.json",@"/json/wificar.json",@"/json/technology.json",@"/json/life.json"];
        NSArray * arr3=@[@"300",@"301",@"302",@"306",@"304",@"305"];
        NSMutableArray *arr=[[NSMutableArray alloc]initWithCapacity:0];
        for (int i=0;i<arr1.count;i++) {
            NSDictionary *dic=[[NSDictionary alloc]initWithObjectsAndKeys:[arr1 objectAtIndex:i],@"name",[arr2 objectAtIndex:i],@"path",[arr3 objectAtIndex:i],@"channelId",nil];
            [arr addObject:dic];
        }
        
        NSArray *tableArray=[NSArray arrayWithObjects:@"searchItem",@"GMHistoryItem",@"PushInfoItem",nil];
        [[MyDatabase sharedDatabase]createTable:tableArray];
        [defaults setObject:appVersion forKey:@"IsFirstOpen"];
        [defaults setObject:@"0" forKey:@"city"];
        [RootUrl setRootUrl:ROOTURL];
        [defaults setObject:arr forKey:@"newsChannels"];
        [defaults setObject:@"1" forKey:@"isLogin"];
        [defaults setObject:@"" forKey:@"acname"];
        [defaults setObject:@"" forKey:@"acpass"];
//        [defaults setObject:@"" forKey:@"token"];
        [defaults setObject:@"" forKey:@"userID"];
        [defaults setObject:@"" forKey:@"userPhone"];
        [defaults setObject:@"" forKey:@"userPassword"];
        [defaults setObject:@"" forKey:@"userName"];
        [defaults setObject:@"" forKey:@"macStr"];
        [defaults setBool:NO forKey:@"userGenders"];
        [defaults setObject:@"" forKey:@"userEmail"];
        [defaults setObject:@"" forKey:@"userBirthday"];
        [defaults setObject:@"" forKey:@"SelectCityName"];
        [defaults setObject:@"2014-9-24" forKey:@"welStarTime"];
        [defaults setObject:@"2014-9-24" forKey:@"welEndTime"];
        [defaults setObject:@"2014-9-24" forKey:@"UMDateFlag"];
        [defaults setObject:@"0" forKey:@"UMLogTimeFlag"];
        [defaults setInteger:0 forKey:@"UMLogClickFlag"];

        //视频原始数据
        [defaults setObject:@"1" forKey:@"ShowUpDate"];
        [defaults setObject:nil forKey:@"video"];
        [defaults setBool:NO forKey:@"isOnNet"];
        
     
        [defaults synchronize];
        
        //启动动画
        

        
        [self.window setRootViewController:[[FirstOpenAnimationViewController alloc]init]];
        
    }else if([self compareVersionWithVersion:oldVersion andWithFlag:1]){
        

        [defaults setObject:@"1" forKey:@"ShowUpDate"];
        [defaults setObject:appVersion forKey:@"IsFirstOpen"];
        [defaults synchronize];
        //启动动画
        
        [self.window setRootViewController:[[FirstOpenAnimationViewController alloc]init]];
    }else{
        
        NSLog(@"IsFirstOpen%@",[defaults objectForKey:@"IsFirstOpen"]);
        NSString * starTimeString=[defaults objectForKey:@"welStarTime"];
        NSString * endTimeString=[defaults objectForKey:@"welEndTime"];
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *starDate=[dateFormatter dateFromString:starTimeString];
        NSDate *endDate=[dateFormatter dateFromString:endTimeString];
        
        NSTimeInterval starInterval=[starDate timeIntervalSinceReferenceDate];
        NSTimeInterval endInterval=[endDate timeIntervalSinceReferenceDate];
        NSTimeInterval nowInterval=[[NSDate date]timeIntervalSinceReferenceDate];
        NSString *nowDate=[dateFormatter stringFromDate:[NSDate date]];
        
        if (![nowDate isEqualToString:[defaults objectForKey:@"UMDateFlag"]]) {
#pragma mark  统计事件日活跃
            NSString *city=[defaults objectForKey:@"city"];
            
            if (city) {
                NSDictionary *dict = @{@"city" :city};
                [MobClick event:@"activety_city" attributes:dict];
            }
            
            [defaults setObject:nowDate forKey:@"UMDateFlag"];
            [defaults synchronize];
        }
        
        if ((nowInterval>starInterval)&&(nowInterval<endInterval)) {
            LaunchPageViewController * launchPage=[[LaunchPageViewController alloc]init];
            self.window.rootViewController=launchPage;
        }else{
            [self creatTabBarController];
        }

    }
#pragma mark //注册微信登录
    [WXApi registerApp:WXAPP_ID withDescription:@"weixin"];
    
//    [self ShowUpDateInfo];
    //启动友盟统计
    [self umengTrack];
    //设置友盟社会化分享
    [UMSocialData setAppKey:UMENG_APPKEY];
 
    [UMSocialWechatHandler setWXAppId:@"wxec18d96456cf5b87" appSecret:@"e32014b9477266bdda1cd13acba94f66" url:@"http://m.16wifi.com/thirdinfo/share/index.html" ];
    
    [UMSocialQQHandler setQQWithAppId:@"1101094886" appKey:@"nxnpUqv2EzAUYZZR" url:@"http://m.16wifi.com/thirdinfo/share/index.html"];
    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    //启动渠道分析
    NSString * appKey =UMENG_APPKEY;
    NSString * deviceName = [[[UIDevice currentDevice] name] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString * mac = [self macString];
    NSString * idfa = [self idfaString];
    NSString * idfv = [self idfvString];

    [defaults synchronize];
    [RootUrl setIDFA:idfa];
    NSString * urlString = [NSString stringWithFormat:@"http://log.umtrack.com/ping/%@/?devicename=%@&mac=%@&idfa=%@&idfv=%@", appKey, deviceName, mac, idfa, idfv];
    [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL: [NSURL URLWithString:urlString]] delegate:nil];
    //设置userAgent 用以识别
    [self setUserAgent];
    //推送相关、
    //推送标记检测
#pragma mark App没有运行是接到推送 这里也应该存本地
    
    if ([UIDevice currentDevice].systemVersion.doubleValue<8.0) {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge)];
    }
    else {
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil]];
    }
    
    
    
    //判断是否由远程消息通知触发应用程序启动
    if (launchOptions) {
        //获取应用程序消息通知标记数（即小红圈中的数字）
        NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
        if (badge>0) {
            //如果应用程序消息通知标记数（即小红圈中的数字）大于0，清除标记。
            badge--;
            //清除标记。清除小红圈中数字，小红圈中数字为0，小红圈才会消除。
            [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
            NSDictionary *pushInfo = [launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
            
            [notificationDic setDictionary:pushInfo[@"aps"]];
            
        }
        
    }
    //开启推送
    NSString *wifiId=[GetCMCCIpAdress getSSID];
    
    if (![wifiId isEqualToString:@"16wifi"]) {
    
        wifiId=@"other";
    }
    NSDictionary *dict = @{@"type" :wifiId};
    [MobClick event:@"starttype" attributes:dict];
    
    //网络状态监听
    [[UIApplication sharedApplication]setStatusBarHidden:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
    reach= [Reachability reachabilityWithHostName:@"www.apple.com"] ;
    [reach startNotifier];

    
    [self.window makeKeyAndVisible];
    return YES;
}
-(void)setTabBarSelected:(int)tag{
    [tbc setSelectedIndex:tag];
}

-(void)ShowUpDateInfo{
#pragma mark 更新提示
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    
    if ([[def objectForKey:@"ShowUpDate"]isEqualToString:@"1"]) {
        UIAlertView *malert =[[UIAlertView alloc] initWithTitle:@"版本更新提示" message:@"1、新增网络测速功能\n2、新增 114Free热点\n3、流量改为彩豆模式\n4、新增头像上传功能" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil] ;
        [malert show];
        
        [def setObject:@"0" forKey:@"ShowUpDate"];
        [def synchronize];
        
    }else{
        
    }
}
-(void)willPresentAlertView:(UIAlertView *)alertView{
    for( UIView * view in alertView.subviews )
        
    {  if( [view isKindOfClass:[UILabel class]] )
        
    {  UILabel* label = (UILabel*) view;
        
        label.textAlignment = NSTextAlignmentLeft;  }
        
    }
    
}
#pragma mark 加金币

-(void)AddCoinRequestWithType:(NSString *)ShareType  ContentId:(NSString *)contentid  UserId:(NSString *)user  CoinNum:(NSString *)coin {
    
    HttpDownload *httdD=[[HttpDownload alloc]init];
    httdD.delegate=self;
    httdD.DComplete=@selector(downloadComplete:);
    httdD.DFailed=@selector(downloadFailed:);
    httdD.tag=15301103;
    NSString *sign=[NSString stringWithFormat:@"%@%@%@",ShareType,contentid,user];
    NSString *subUrl=[NSString stringWithFormat:@"mod=downtocredit&fid=%@&gid=%@&uid=%@&amount=%@&sign=%@",ShareType,contentid,user,coin,[RootUrl md5:sign]];
    NSData *secretData=[subUrl dataUsingEncoding:NSUTF8StringEncoding];
    NSData *qValueData=[secretData AES256EncryptWithKey:SECRETKEY];
    NSString *qValue=[qValueData newStringInBase64FromData];
    if([RootUrl getIsNetOn]||[[GetCMCCIpAdress getSSID]isEqualToString:@"16wifi"]){//150414
        [httdD downloadFromUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@/app_api/credit/addCredit.html?q=%@",NewBaseUrl,qValue]]];
    }//150414
}
#pragma mark 微信代理方法
-(void)onResp:(BaseResp *)resp{
    
    NSLog(@"resq:%@",resp.class);
    
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        NSLog(@"%@",[NSString stringWithFormat:@"发送消息结果%d",resp.errCode]);
        if (resp.errCode==0) {
            [self setNotice:@"分享成功！"];
            NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
            
            if ( [[def objectForKey:@"ShareWxType"]isEqualToString:@"0"]) {
                
            }else{
                [self AddCoinRequestWithType:@"con_share_cr" ContentId:_ShareContentId UserId:[def objectForKey:@"userID"] CoinNum:@"2"];
            }
            
          }
    }else{
        [self getWeiXinCodeFinishedWithResp:resp];
    }
    
}
-(void)sendAuthRequest{
    SendAuthReq* req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_base,snsapi_userinfo,snsapi_friend"; // @"post_timeline,sns" ,snsapi_contact
    req.state = @"0744";
    if ([RootUrl getIsNetOn]) {
        [WXApi sendReq:req];
    }else{
        UIAlertView *malert =[[UIAlertView alloc] initWithTitle:nil message:@"网络不通畅,无法授权登录" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil] ;
        [malert show];
    }
    
}

- (void)getWeiXinCodeFinishedWithResp:(BaseResp *)resp
{
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    if (resp.errCode == 0){
        SendAuthResp *aresp = (SendAuthResp *)resp;
        [self getAccessTokenWithCode:aresp.code];
        [def setObject:aresp.code forKey:@"WXCode"];
        [def synchronize];
         [_WXLogin startAnimat];
    }else{
        UIAlertView *malert =[[UIAlertView alloc] initWithTitle:nil message:@"授权登录失败，请稍后重试" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil] ;
        [malert show];
        [def setObject:@"0" forKey:@"RelateWxTips"];
        [def synchronize];
        
        [_RelateWx.MySwitch setOn:NO];
        
    }
}
-(void)getAccessTokenWithCode:(NSString *)code{
    
    NSString *urlString =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",WXAPP_ID,WXAPP_SECRET,code];
    NSURL *url = [NSURL URLWithString:urlString];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *dataStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data)
            {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                if ([dict objectForKey:@"errcode"])
                {
                    //获取token错误
                }else{
                    //存储AccessToken OpenId RefreshToken以便下次直接登陆
                    [self getUserInfoWithAccessToken:[dict objectForKey:@"access_token"] andOpenId:[dict objectForKey:@"openid"]];
                    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
                    [def setObject:[dict objectForKey:@"refresh_token"] forKey:@"WeiXinRefreshToken"];
                    [def synchronize];
                }
            }
        });
    });
}
- (void)getUserInfoWithAccessToken:(NSString *)accessToken andOpenId:(NSString *)openId{
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    NSString *urlString =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",accessToken,openId];
    NSURL *url = [NSURL URLWithString:urlString];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *dataStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data)
            {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                if ([dict objectForKey:@"errcode"])
                {
                    //AccessToken失效
                    [self getAccessTokenWithRefreshToken:[[NSUserDefaults standardUserDefaults]objectForKey:@"WeiXinRefreshToken"]];
                }else{
                    //获取需要的数据
                    NSLog(@"openid%@",[dict objectForKey:@"openid"]);
                    [def setObject:[dict objectForKey:@"openid"] forKey:@"WXopenId"];
                    [def setObject:[dict objectForKey:@"nickname"] forKey:@"WXnickname"];
                    [def setObject:[dict objectForKey:@"sex"] forKey:@"WXsex"];
                    [def setObject:[dict objectForKey:@"province"] forKey:@"WXprovince"];
                    [def setObject:[dict objectForKey:@"city"] forKey:@"WXcity"];
                    [def setObject:[dict objectForKey:@"country"] forKey:@"WXcountry"];
                    [def setObject:[dict objectForKey:@"headimgurl"] forKey:@"WXheadimgurl"];
                    [def synchronize];
            
                        //加入接入16wifi网络时CGI调用
                    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
                    HttpDownload *wxloginHd=[[HttpDownload alloc]init];
                    wxloginHd.delegate=self;
                    wxloginHd.tag=333555;
                    wxloginHd.DFailed=@selector(downloadFailed:);
                    wxloginHd.DComplete=@selector(downloadComplete:);
                    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
                    [dateformatter setDateFormat:@"hhmmss"];
                    NSString *str=[[NSString alloc]init];
                    str=[NSString stringWithFormat:@"mod=wxreg&action=getconisbind&openid=%@",[def objectForKey:@"WXopenId"]];
                    NSData *secretData=[str dataUsingEncoding:NSUTF8StringEncoding];
                    NSData *qValueData=[secretData AES256EncryptWithKey:SECRETKEY];
                    NSString *qValue=[qValueData newStringInBase64FromData];
                    NSURL *Load=[NSURL URLWithString:[NSString stringWithFormat:@"%@/usersystem/wxapi.php?q=%@",FormalBaseUrl,qValue]];
                    [wxloginHd downloadFromUrl:Load];
                    [_RelateWx startAnimat];
                    
                }
            }
        });
        
    });
}
- (void)getAccessTokenWithRefreshToken:(NSString *)refreshToken
{
    
    NSString *urlString =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/refresh_token?appid=%@&grant_type=refresh_token&refresh_token=%@",WXAPP_ID,refreshToken];
    NSURL *url = [NSURL URLWithString:urlString];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *dataStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data)
            {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                if ([dict objectForKey:@"errcode"])
                {
                    //授权过期
                    NSLog(@"授权过期");
                    
                }else{
                    //重新使用AccessToken获取信息
                    NSLog(@"重新使用AccessToken获取信息");
                    
                }
            }
        });
    });
}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [WXApi handleOpenURL:url delegate:self]||[TencentOAuth HandleOpenURL:url]||[UMSocialSnsService handleOpenURL:url];
    
}
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    //browser
    NSString *handleUrl = [url absoluteString];
    if ([handleUrl hasPrefix:@"ewifibrowser://"]) {
        
        if ([handleUrl isEqualToString:@"ewifibrowser://"]) {
            return YES;
        }else{
            
            NSArray *array = [handleUrl componentsSeparatedByString:@"url="];
            
            UINavigationController *vc = (UINavigationController *)_window.rootViewController;
            if (vc == nil) {
                
                [self creatTabBarController];
            }
            
            if (array.count>1) {
                
                
                [[NSUserDefaults standardUserDefaults]setObject:[array lastObject] forKey:@"CallBackUrl"];
                
                ZhuanPanViewController *webSub=[[ZhuanPanViewController alloc]init];
                webSub.isPush=0;
                webSub.myRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:[array lastObject]]];
                
                NSLog(@"URL:%@",webSub.myRequest.URL);
                
                [[[tbc.viewControllers lastObject] visibleViewController]presentViewController:webSub animated:YES completion:nil];
                
            }
            
            return YES;
            
        }

        
    }else{

        return [WXApi handleOpenURL:url delegate:self]||[TencentOAuth HandleOpenURL:url]||[UMSocialSnsService handleOpenURL:url wxApiDelegate:self];
        
    }
    
}
-(void)copyDatabaseToDocuments
{
    NSString *fullPath=[MyDatabase filePath:@"BasicData.db"];
    NSFileManager *fm=[NSFileManager defaultManager];
    if (![fm fileExistsAtPath:fullPath]) {
        //源文件路径
        NSString *srcpath=[[NSBundle mainBundle] pathForResource:@"BasicData" ofType:@"db"];
        //拷贝文件到目标路径下
        [fm copyItemAtPath:srcpath toPath:fullPath error:nil];
    }
}
//底部通知
-(void)setNotice:(NSString*)str{
    [noticeView setHidden:NO];
    UILabel *la=(UILabel*)[noticeView viewWithTag:413];
    CGSize maxSize=CGSizeMake(250,20);
    #pragma mark 修改label宽度
//    CGSize realSize=[str sizeWithFont:la.font constrainedToSize:maxSize lineBreakMode:NSLineBreakByCharWrapping];
    CGSize realSize=[str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:la.font} context:nil].size;
    
    noticeView.frame=CGRectMake((310-realSize.width)/2, SCREENHEIGHT-44-35,realSize.width+10, 26);
    UIImageView *imagev=(UIImageView *)[noticeView viewWithTag:412];
    imagev.frame=CGRectMake(0, 0,realSize.width+10, 26);
    la.frame=CGRectMake(5, 0,realSize.width, 20);
    la.text=str;
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(setHidNotice) userInfo:nil repeats:NO];
}
-(void)loginForInfo{
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    
    
    int isLogin=[[def objectForKey:@"isLogin"]intValue];
    if (isLogin>1) {
        
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"hhmmss"];
        
        NSDictionary *infoDictonary=[[NSBundle mainBundle]infoDictionary];
        NSString * BundleId=[infoDictonary objectForKey:@"CFBundleIdentifier"];
        NSString *Vname=@"";
        if ([BundleId isEqualToString:@"16wifipro"]) {
            Vname=[NSString stringWithFormat:@"%@",BundleId];
        }else{
            Vname=@"16wifi";
        }
        
        
        NSString *QString=[NSString stringWithFormat:@"mod=logintest&phone=%@&pass=%@&apmac=%@&mac=%@&city=%@&dev=1&vname=%@&ntime=%@",[def objectForKey:@"userPhone"],[def objectForKey:@"userPassword"],[GetCMCCIpAdress getBSSIDStandard],[RootUrl getIDFA],[def objectForKey:@"city"],Vname,[dateformatter stringFromDate:[NSDate date]]];
        
        
        NSLog(@"Qstr:%@",QString);
        NSData *secretData=[QString dataUsingEncoding:NSUTF8StringEncoding];
        NSData *qValueData=[secretData AES256EncryptWithKey:SECRETKEY];
        
        NSString *qValue=[qValueData newStringInBase64FromData];
        
        HttpDownload *loginHd=[[HttpDownload alloc]init];
        loginHd.delegate=self;
        loginHd.tag=3333;
        loginHd.DFailed=@selector(downloadFailed:);
        loginHd.DComplete=@selector(downloadComplete:);
        
        NSURL *downLoadUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@/app_api/userAccount/login.html?q=%@",NewBaseUrl,qValue]];
        
        if([RootUrl getIsNetOn]||[[GetCMCCIpAdress getSSID]isEqualToString:@"16wifi"]){//150414
        
            [loginHd downloadFromUrl:downLoadUrl andWithTimeoutInterval:5];
        }//150414
    }
    
}
-(void)setHidNotice{
    [noticeView setHidden:YES];
}
//底部通知

-(void)chackCity{
    

    
    if (cityChackFlag==0) {
        cityChackFlag=1;
        locationFlag=1;
        gpsManager =[[CLLocationManager alloc]init];
        gpsManager.desiredAccuracy=kCLLocationAccuracyBest;
        if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
            [gpsManager requestWhenInUseAuthorization];
        }
        gpsManager.delegate=self;
        [gpsManager startUpdatingLocation];
    }
    
    
}
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
    NSString * jingdu=[[NSNumber numberWithDouble:newLocation.coordinate.longitude]stringValue];
    NSString * weidu=[[NSNumber numberWithDouble:newLocation.coordinate.latitude]stringValue];
    
    if (locationFlag) {
        locationFlag=0;
        HttpDownload *hd=[[HttpDownload alloc]init];
        hd.delegate=self;
        hd.tag=916;
        hd.DFailed=@selector(downloadFailed:);
        hd.DComplete=@selector(downloadComplete:);
        [hd downloadFromUrl:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.16wifi.com/usersystem/location/getlocation.php?pos=%@,%@",weidu,jingdu]]];
    }
    [gpsManager stopUpdatingLocation];
    
}
//以下为网络监听检测
- (void)reachabilityChanged:(NSNotification*)note {
    NSLog(@"网络监测reachability调用");
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    
    [self setStatusWithNetWork:netStatus];
    
}
//以上为网络监听检测
-(void)setStatusWithNetWork:(NetworkStatus)netStatus{

    switch (netStatus)
    {
        case NotReachable:
        {
            NSString *ssid=[GetCMCCIpAdress getSSID];
            NSLog(@"网络监测无网:%@",ssid);
            if ([ssid isEqualToString:@"16wifi"]) {
                [RootUrl setNetStatus:@"16wifi"];
                [RootUrl setIsNetOn:NO];
                [netPlay setNetStatusWithTag:3];
                [RootUrl setUMLogClickFlag:0];
                [RootUrl setUMLogTimeFlag:@"0"];
                [self checkChannelsData];
                [RootUrl setIsBeiJingHuaWei:NO];
                [netPlay getPortalUrlWith:0];
                
            }else if ([ssid hasPrefix:@"114 Free"]) {
                [RootUrl setNetStatus:@"114 Free"];
                [RootUrl setIsNetOn:NO];
                [netPlay setNetStatusWithTag:4];
                [RootUrl setUMLogClickFlag:0];
                [RootUrl setUMLogTimeFlag:@"0"];
                [RootUrl setIsBeiJingHuaWei:NO];
                [netPlay getPortalUrlWith:1];
                
            }else if ([ssid hasPrefix:@"ChinaNet"]) {
                [RootUrl setNetStatus:@"ChinaNet"];
                [RootUrl setIsNetOn:NO];
                [netPlay setNetStatusWithTag:5];
                [RootUrl setUMLogClickFlag:0];
                [RootUrl setUMLogTimeFlag:@"0"];
                [RootUrl setIsBeiJingHuaWei:NO];
                [netPlay getPortalUrlWith:1];
                
            }else{
                [RootUrl setNetStatus:@"noNet"];
                [RootUrl setIsNetOn:NO];
                [netPlay setNetStatusWithTag:0];
                [RootUrl setUMLogClickFlag:0];
                [RootUrl setUMLogTimeFlag:@"0"];
                [RootUrl setIsBeiJingHuaWei:NO];
            }
            
            break;
        }
        case ReachableViaWWAN:
        {
            [netPlay setNetStatus];
            [RootUrl setNetStatus:@"4G/3G/2G"];
            [RootUrl setIsNetOn:YES];
            [netPlay setNetStatusWithTag:1];
            [RootUrl setUMLogClickFlag:0];
            [RootUrl setUMLogTimeFlag:@"0"];
            [self checkChannelsData];
            [RootUrl setIsBeiJingHuaWei:NO];
            [self chackCity];
            [self checkChannelsData];
            break;
        }
        case ReachableViaWiFi:
        {
            NSString *ssid=[GetCMCCIpAdress getSSID];
            NSLog(@"网络监测WiFi:%@",ssid);
            if ([ssid isEqualToString:@"16wifi"]) {
                [RootUrl setNetStatus:@"16wifi"];
                [RootUrl setIsNetOn:NO];
                [netPlay setNetStatusWithTag:3];
                [RootUrl setUMLogClickFlag:0];
                [RootUrl setUMLogTimeFlag:@"0"];
                [RootUrl setIsBeiJingHuaWei:NO];
                [self checkChannelsData];
                [netPlay getPortalUrlWith:0];
                
                
            }else if ([ssid hasPrefix:@"114 Free"]) {
                [RootUrl setNetStatus:@"114 Free"];
                [RootUrl setIsNetOn:NO];
                [netPlay setNetStatusWithTag:4];
                [RootUrl setUMLogClickFlag:0];
                [RootUrl setUMLogTimeFlag:@"0"];
                [RootUrl setIsBeiJingHuaWei:NO];
                [netPlay getPortalUrlWith:1];
                
            }else if ([ssid hasPrefix:@"ChinaNet"]) {
                [RootUrl setNetStatus:@"ChinaNet"];
                [RootUrl setIsNetOn:NO];
                [netPlay setNetStatusWithTag:5];
                [RootUrl setUMLogClickFlag:0];
                [RootUrl setUMLogTimeFlag:@"0"];
                [RootUrl setIsBeiJingHuaWei:NO];
                [netPlay getPortalUrlWith:1];
                
            }else{
                [self chackCity];
                [netPlay setNetStatus];
                [RootUrl setNetStatus:@"wifi"];
                [RootUrl setIsNetOn:YES];
                [netPlay setNetStatusWithTag:2];
                [RootUrl setIsBeiJingHuaWei:NO];
                [self checkChannelsData];
                [RootUrl setUMLogClickFlag:0];
                [RootUrl setUMLogTimeFlag:@"0"];
                //跳转畅游频道
                if (openFlag) {
                    openFlag=0;
                    [tbc setSelectedIndex:2];
                }
                
            }
            break;
        }
    }
}
//以下设置userAgent
-(void)setUserAgent{
    UIWebView * jTestWeb=[[UIWebView alloc]initWithFrame:CGRectMake(-10000,0 , 1, 1)];
    jTestWeb.delegate=self;
    [self.window addSubview:jTestWeb];
    [jTestWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.apple.com"]]];
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *userAgent=[request valueForHTTPHeaderField:@"User-Agent"];
    NSRange ran=[userAgent rangeOfString:@"ewifibrowser"];
    if (ran.location==NSNotFound) {
        NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@; ewifibrowser",userAgent], @"UserAgent", nil];
        [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
    }
    return NO;
}
//以上设置userAgent
//以下友盟统计开启
- (void)umengTrack {
    
    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:(ReportPolicy) SEND_ON_EXIT channelId:nil];
    [MobClick updateOnlineConfig];  //在线参数配置
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineConfigCallBack:) name:UMOnlineConfigDidFinishedNotification object:nil];
    
}
- (void)onlineConfigCallBack:(NSNotification *)note {
    
}
//以上友盟统计开启
//以下激光推送处理
#pragma mark 方法一
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    
    NSString* dt = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    NSString * stringStr = [dt stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [def setObject:stringStr forKey:@"token"];
    [def synchronize];

    
}
#pragma mark 方法二
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSString *error_str = [NSString stringWithFormat: @"%@", error];
    NSLog(@"Failed to get token, error:%@", error_str);
}


#pragma mark 前台后台运行是接到推送
#pragma mark 方法四

#ifdef __IPHONE_7_0
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    
    
    [notificationDic setDictionary: userInfo[@"aps"]];
    
    NSString *notificationTitle=[notificationDic objectForKey:@"alert"];
    NSString *notificationMassige=[notificationDic objectForKey:@"m"];
    
    
    
    //推送 正在前台弹出提醒
    
    UIAlertView *malert =[[UIAlertView alloc] initWithTitle:notificationTitle message:notificationMassige delegate:self cancelButtonTitle:@"放弃查看" otherButtonTitles:@"立即查看", nil] ;
    malert.tag=90909090;
    [malert show];
    //完成为什么要通知系统？
    completionHandler(UIBackgroundFetchResultNewData);
    
}

#endif


#pragma mark -web调用


- (void)networkDidReceiveMessage:(NSNotification *)notification {
    
}
#pragma mark -PushMessage
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(alertView.tag==191919){
        if (buttonIndex) {
            
            if (isNewUser) {
                isNewUser=0;
#pragma mark  统计事件日新增
                NSDictionary *dict = @{@"city" :getCityCode};
                [MobClick event:@"newUser_city" attributes:dict];
                [MobClick event:@"activety_city" attributes:dict];
            }
            switch ([getCityCode intValue]) {
                case 131:
                    [RootUrl setRootUrl:@"http://bj.16wifi.com"];
                    break;
                case 138:
                    [RootUrl setRootUrl:@"http://fs.16wifi.com"];
                    break;
                case 158:
                    [RootUrl setRootUrl:@"http://cs.16wifi.com"];
                    break;
                case 240:
                    [RootUrl setRootUrl:@"http://my.16wifi.com"];
                    break;
                case 289:
                    [RootUrl setRootUrl:@"http://sh.16wifi.com"];
                    break;
                case 315:
                    [RootUrl setRootUrl:@"http://nj.16wifi.com"];
                    break;
                default:
                    [RootUrl setRootUrl:ROOTURL];
                    break;
            }
            [RootUrl setCity:getCityCode];
            
            [self checkChannelsData];
            
            NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
            NSString *parameterString=[[NSString alloc]init];
            NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
            [dateformatter setDateFormat:@"hhmmss"];
            
            update =[[HttpDownload alloc]init];
            update.delegate=self;
            update.tag=515151;
            update.DFailed=@selector(downloadFailed:);
            update.DComplete=@selector(downloadComplete:);
            parameterString=[NSString stringWithFormat:@"mod=userinfo&uid=%@&nick=%@&birth=%@&sex=%@&email=%@&city=%@&type=1&ntime=%@",[def objectForKey:@"userID"],[def objectForKey:@"userName"],[def objectForKey:@"userBirthday"],[def objectForKey:@"userGenders"],[def objectForKey:@"userEmail"],getCityCode,[dateformatter stringFromDate:[NSDate date]]];
            NSData *secretData=[parameterString dataUsingEncoding:NSUTF8StringEncoding];
            NSData *qValueData=[secretData AES256EncryptWithKey:SECRETKEY];
            NSString *qValue=[qValueData newStringInBase64FromData];
            NSURL *downLoadUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@/app_api/userInfo/modifyUserInfo.html?q=%@",NewBaseUrl,qValue]];
            if([RootUrl getIsNetOn]||[[GetCMCCIpAdress getSSID]isEqualToString:@"16wifi"]){//150414
                [update downloadFromUrl:downLoadUrl];
            }//150414
        }
        
    }
    if (alertView.tag==90909090) {
        
#pragma mark 存储推送消息
        [pushInfoArray removeAllObjects];
        PushInfoItem *pushInfo=[[PushInfoItem alloc]init];
        [pushInfo setValue:[notificationDic objectForKey:@"h"] forKey:@"h"];//链接
        [pushInfo setValue:[notificationDic objectForKey:@"alert"] forKey:@"t"];//标题
        [pushInfo setValue:[notificationDic objectForKey:@"t"] forKey:@"_j_msgid"];//时间戳
        [pushInfo setValue:[notificationDic objectForKey:@"m"] forKey:@"m"];//详情
        [pushInfo setValue:[notificationDic objectForKey:@"y"] forKey:@"type"];//类型
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY-MM-dd"];
        [pushInfo setValue:[dateFormatter stringFromDate:[NSDate date]] forKey:@"time"];
        
        NSLog(@"notificationDic:%@",notificationDic);
        NSLog(@"pushinfo%@",pushInfo);
        
        if (buttonIndex) {
            
            [pushInfo setValue:@"1" forKey:@"read"];
            [pushInfoArray addObject:pushInfo];
            [[MyDatabase sharedDatabase]insertArray:pushInfoArray];
            //查看推送
            
            if ([[notificationDic objectForKey:@"h"]isEqualToString:@""]) {
                GM_PushNewsViewController *gvc=[[GM_PushNewsViewController alloc]init];
                gvc.isPush=0;
                 [[[tbc.viewControllers lastObject] visibleViewController]presentViewController:gvc animated:YES completion:nil];
            }else{
                WebSubPagViewController *webSub=[[WebSubPagViewController alloc]init];
//                ZhuanPanViewController *webSub=[[ZhuanPanViewController alloc]init];
                webSub.isPush=0;
                if ([[notificationDic  objectForKey:@"h"]hasPrefix:@"http"]) {
                    webSub.myRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:[notificationDic objectForKey:@"h"]]];
                }else{
                    webSub.myRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",[RootUrl getContentUrl],[notificationDic objectForKey:@"h"]]]];
                }
                NSLog(@"URL:%@",webSub.myRequest.URL);
                
                [[[tbc.viewControllers lastObject] visibleViewController]presentViewController:webSub animated:YES completion:nil];
            }
            
        }else{
            [pushInfo setValue:@"0" forKey:@"read"];
            
            [pushInfoArray addObject:pushInfo];
            
            [[MyDatabase sharedDatabase]insertArray:pushInfoArray];
            //未查看推送
        }
        
        NSMutableArray * array=[NSMutableArray arrayWithArray:[[MyDatabase sharedDatabase] readData:1 count:0 model:[[PushInfoItem alloc]init] where:@"read" value:@"0"]];
        NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
        [def setObject:[NSString stringWithFormat:@"%lu",(unsigned long)array.count] forKey:@"newsNO"];
        [def synchronize];
        
        return;
    }
    
}
//获取频道模块数据
-(void)checkChannelsData{
    HttpDownload *jHd=[[HttpDownload alloc]init];
    jHd.delegate=self;
    jHd.tag=911911;
    jHd.DFailed=@selector(downloadFailed:);
    jHd.DComplete=@selector(downloadComplete:);
    [jHd downloadFromUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@/json/innerColumnList.json",[RootUrl getContentUrl]]]];
    NSLog(@"aaa:%@",[NSString stringWithFormat:@"%@/json/innerColumnList.json",[RootUrl getContentUrl]]);
    
    HttpDownload *jHd2=[[HttpDownload alloc]init];
    jHd2.delegate=self;
    jHd2.tag=911912;
    jHd2.DFailed=@selector(downloadFailed:);
    jHd2.DComplete=@selector(downloadComplete:);
    [jHd2 downloadFromUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@/json/advertiseList.json",[RootUrl getContentUrl]]]];
    NSLog(@"RequestUrl:%@",[NSString stringWithFormat:@"%@/json/advertiseList.json",[RootUrl getContentUrl]]);
    
    //需要判断是否指向了北京服务器 未解决域名问题
}
//下载数据处理
-(void)downloadComplete:(HttpDownload *)hd{
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    if (hd.tag==15301103) {
        
        NSError *error = nil;
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:hd.mData options:NSJSONReadingAllowFragments error:&error];
        if (error!=nil) {
            NSLog(@"json解析失败32");
        }else{
            NSNumber *num=[dic objectForKey:@"ReturnCode"];
            NSLog(@"分享成功奖励 %@",num);
            
            int aaa=[[dic objectForKey:@"amount"] intValue];
            if (aaa) {
                UIImageView *goldBg=[[UIImageView alloc]initWithFrame:CGRectMake(132,SCREENHEIGHT, 56, 56)];
                goldBg.tag=9090;
                goldBg.image=[UIImage imageNamed:@"round.png"];
                if ([[[tbc.viewControllers lastObject] visibleViewController]isKindOfClass:[UserViewController class]]) {
                    [tbc.view addSubview:goldBg];
                }else{
                    [[[tbc.viewControllers lastObject] visibleViewController].view addSubview:goldBg];
                }
                NSLog(@"ViewController%@",[[tbc.viewControllers lastObject] visibleViewController]);
                NSLog(@"rootView%@",self.window.rootViewController);
                
                UILabel *goldLabel=[[UILabel alloc]initWithFrame:CGRectMake(5,18,43,20)];
                goldLabel.backgroundColor=[UIColor clearColor];
                goldLabel.textAlignment=NSTextAlignmentCenter;
                goldLabel.textColor=[UIColor whiteColor];
                if ([[dic objectForKey:@"amount"] integerValue]>=100) {
                    goldLabel.font=[UIFont boldSystemFontOfSize:14];
                }else{
                    goldLabel.font=[UIFont boldSystemFontOfSize:17];
                }
                [goldBg addSubview:goldLabel];
                goldLabel.text=[NSString stringWithFormat:@"+ %d",aaa];
                [UIView animateWithDuration:0.9 animations:^{
                    goldBg.frame=CGRectMake(132,SCREENHEIGHT-116, 56, 56);
                } completion:^(BOOL finished){
                    [UIView animateWithDuration:1.5 animations:^{
                        goldBg.alpha=0;
                    } completion:^(BOOL finished){
                        [goldBg removeFromSuperview];
                    }];
                }];
            }
            
        }
    }
    if (hd.tag==7777) {
        [_RelateWx stopAnimat];
        NSError *error = nil;
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:hd.mData options:NSJSONReadingAllowFragments error:&error];
        if (error!=nil) {
            NSLog(@"json解析失败12");
        }else{
            
            int ReturnCode=[[dic objectForKey:@"ReturnCode"]intValue];
            switch (ReturnCode) {
                case 102:
                {
                    [def setObject:@"1" forKey:@"RelateWxTips"];
                    [def synchronize];
                    UIAlertView *malert =[[UIAlertView alloc] initWithTitle:nil message:@"您已成功绑定微信。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil] ;
                    [malert show];
                }
                    break;
                    
                default:
                {
                
                    [def setObject:@"0" forKey:@"RelateWxTips"];
                    [def synchronize];
                    UIAlertView *malert =[[UIAlertView alloc] initWithTitle:nil message:@"绑定微信失败，请重试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil] ;
                    [malert show];
                }
                    break;
            }

            
        }
        
    }
    if (hd.tag==333555) {
        NSError *error = nil;
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:hd.mData options:NSJSONReadingAllowFragments error:&error];
        if (error!=nil) {
            NSLog(@"json解析失败12");
        }else{
              int bindtype=[[dic objectForKey:@"bindtype"]intValue];
            if (bindtype==0) {

                if (_IsLogin) {
                    BandPhoneViewController *bvc=[[BandPhoneViewController alloc]init];
                    bvc.WXLogin=_WXLogin;
                    [_WXLogin presentViewController:bvc animated:YES completion:nil];
                    [_WXLogin stopAnimat];
                }else{
                    HttpDownload *RelateWx=[[HttpDownload alloc]init];
                    RelateWx.delegate=self;
                    RelateWx.tag=7777;
                    RelateWx.DFailed=@selector(downloadFailed:);
                    RelateWx.DComplete=@selector(downloadComplete:);
                    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
                    [dateformatter setDateFormat:@"hhmmss"];
                    NSString *str=[[NSString alloc]init];
                    str=[NSString stringWithFormat:@"%mod=wxreg&action=bandwx&openid=%@&phone=%@&ntime=%@",[def objectForKey:@"WXopenId"],[def objectForKey:@"userPhone"],[dateformatter stringFromDate:[NSDate date]]];
                    NSString *newUrlStr = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    NSData *secretData=[newUrlStr dataUsingEncoding:NSUTF8StringEncoding];
                    NSData *qValueData=[secretData AES256EncryptWithKey:SECRETKEY];
                    NSString *qValue=[qValueData newStringInBase64FromData];
                    NSURL *Load=[NSURL URLWithString:[NSString stringWithFormat:@"%@/usersystem/wxapi.php?q=%@",FormalBaseUrl,qValue]];
                    [RelateWx downloadFromUrl:Load];
//                    [_RelateWx startAnimat];
                }
            }else{
                if (_IsLogin) {
                    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
                    HttpDownload *wxloginHd=[[HttpDownload alloc]init];
                    wxloginHd.delegate=self;
                    wxloginHd.tag=6666;
                    wxloginHd.DFailed=@selector(downloadFailed:);
                    wxloginHd.DComplete=@selector(downloadComplete:);
                    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
                    [dateformatter setDateFormat:@"hhmmss"];
                    NSString *str=[[NSString alloc]init];
                    str=[NSString stringWithFormat:@"mod=wxreg&openid=%@&type=1&fromid=1&ntime=%@&nickname=%@&sex=%@&apmac=%@&mac=%@&city=%@",[def objectForKey:@"WXopenId"],[dateformatter stringFromDate:[NSDate date]],[def objectForKey:@"WXnickname"],[def objectForKey:@"WXsex"],[GetCMCCIpAdress getBSSIDStandard],[RootUrl getIDFA],[def objectForKey:@"WXprovince"]];
                    NSData *secretData=[str dataUsingEncoding:NSUTF8StringEncoding];
                    NSData *qValueData=[secretData AES256EncryptWithKey:SECRETKEY];
                    NSString *qValue=[qValueData newStringInBase64FromData];
                    NSURL *Load=[NSURL URLWithString:[NSString stringWithFormat:@"%@/usersystem/wxapi.php?q=%@",FormalBaseUrl,qValue]];
                    [wxloginHd downloadFromUrl:Load];
                }else{
                    
                    [_RelateWx stopAnimat];
                    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"" message:@"该微信号码已绑定其他手机,请解绑后重试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    alertView.tag=5555;
                    [alertView show];
                    
                    [def setObject:@"0" forKey:@"RelateWxTips"];
                    [def synchronize];
                    [_RelateWx.MySwitch setOn:NO];
                    
                }
            
            }
            
        }
    }
    if (hd.tag==6666) {
        NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
        NSError *error = nil;
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:hd.mData options:NSJSONReadingAllowFragments error:&error];
        if (error!=nil) {
            NSLog(@"json解析失败12");
        }else{
            if ([[dic objectForKey:@"acname"]length]>10) {
                [userDefaults setObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"phone"]] forKey:@"userPhone"];
                [userDefaults setObject:[dic objectForKey:@"uid"] forKey:@"userID"];
                [userDefaults setObject:[dic objectForKey:@"acpass"] forKey:@"acpass"];
                [userDefaults setObject:[dic objectForKey:@"acname"] forKey:@"acname"];
                [userDefaults setObject:@"1" forKey:@"LoginType"];
                [userDefaults setObject:@"1" forKey:@"RelateWxTips"];
                [userDefaults synchronize];
                [_WXLogin stopAnimat];
                [_WXLogin showSuccessNotice:@"微信登陆成功"];
            }
     
        }
        
    }
    if (hd.tag==6000) {
        [netPlay setNetStatusWithTag:3];
        [netPlay chacknetwith:1];
        [RootUrl setIsNetOn:NO];
    }
    if (hd.tag==3333) {
        
        NSError *error = nil;
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:hd.mData options:NSJSONReadingAllowFragments error:&error];
        NSLog(@"启动登录:%@",dic);
        if (error!=nil) {
            NSLog(@"json解析失败12");
        }else{
            NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
            if ([[dic objectForKey:@"ReturnCode"]intValue]==102) {
                NSLog(@"数据修改");
                [userDefaults setObject:[dic objectForKey:@"uid"] forKey:@"userID"];
                //            [userDefaults setObject:[dic objectForKey:@"token"] forKey:@"token"];
                [userDefaults setObject:[dic objectForKey:@"acpass"] forKey:@"acpass"];
                [userDefaults setObject:[dic objectForKey:@"acname"] forKey:@"acname"];
                [userDefaults synchronize];
            }else{
            
                NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
                [userDefaults setObject:@"1" forKey:@"isLogin"];
                [userDefaults setObject:@"" forKey:@"userPassword"];
                [userDefaults setObject:@"" forKey:@"userName"];
                [userDefaults setObject:@"" forKey:@"userPhone"];
                [userDefaults setBool:NO forKey:@"userGenders"];
                [userDefaults setObject:@"" forKey:@"userEmail"];
                [userDefaults setObject:@"" forKey:@"userBirthday"];
                [userDefaults setObject:@"" forKey:@"SelectCityName"];
                [userDefaults setObject:@"" forKey:@"introduce"];
                [userDefaults setObject:@"" forKey:@"userID"];
                [userDefaults setObject:@"" forKey:@"acpass"];
                [userDefaults setObject:@"" forKey:@"acname"];
                [userDefaults setObject:@"1" forKey:@"isExitLogin"];
                [userDefaults setObject:@"0" forKey:@"QdTimes"];
                [userDefaults setObject:@"0" forKey:@"city"];
                [userDefaults setObject:@"" forKey:@"UserData"];
                [userDefaults setObject:@"" forKey:@"UserInfo"];
                [userDefaults synchronize];
                [self setNotice:@"账户信息变更，已退出登录！"];
            }
            NSLog(@"3333token:%@",[userDefaults objectForKey:@"token"]);
            
        }
    }
    if (hd.tag==916) {
        NSError *error = nil;
        NSDictionary * jLoctionDataDic=[NSJSONSerialization JSONObjectWithData:hd.mData options:NSJSONReadingAllowFragments error:&error];
        
        if (error!=nil) {
            NSLog(@"json解析失败1");
            return;
        }else{
            getCityCode=[[[jLoctionDataDic objectForKey:@"result"]objectForKey:@"cityCode"]stringValue];
            
            NSString *cityName=[[[jLoctionDataDic objectForKey:@"result"]objectForKey:@"addressComponent"]objectForKey:@"city"];
            NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
            [def setObject:getCityCode  forKey:@"GPS"];
            [def synchronize];
           
            int isLogin=[[def objectForKey:@"isLogin"]intValue];
            
            if ([getCityCode intValue]!=[[RootUrl getCity] intValue]&&isLogin>1) {
                NSString *str11=[NSString stringWithFormat:@"是否切换到当前定位城市：%@",cityName];
                UIAlertView *malert =[[UIAlertView alloc] initWithTitle:@"城市定位" message:str11 delegate:self cancelButtonTitle:@"不要切换" otherButtonTitles:@"立即切换", nil] ;
                malert.tag=191919;
                [malert show];
            }

        }
    }
    if (hd.tag==911911) {
        NSError *error = nil;
        NSDictionary * jChannelDataDic=[NSJSONSerialization JSONObjectWithData:hd.mData options:NSJSONReadingAllowFragments error:&error];
        if (error!=nil) {
            NSLog(@"json解析失败1911");
        }else{
            NSArray* jchannelArr=[jChannelDataDic objectForKey:@"info"];
            NSMutableArray *dataArr=[[NSMutableArray alloc]init];
            for (NSDictionary* dic in jchannelArr) {
                if ([[dic objectForKey:@"name"]isEqualToString:@"news"]) {
                    NSArray *subChannel=[dic objectForKey:@"children"];
                    for (NSDictionary *dic2 in subChannel) {
                        NSDictionary *dic3=[[NSDictionary alloc]initWithObjectsAndKeys:[dic2 objectForKey:@"chineseName"],@"name",[dic2 objectForKey:@"indexPath"],@"path",[dic2 objectForKey:@"channelId"],@"channelId", nil];
                        [dataArr addObject:dic3];
                    }
                    break;
                }
            }
            
            NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
            [userDefaults setObject:dataArr forKey:@"newsChannels"];
            [userDefaults synchronize];
            
        }
        
    }
    if (hd.tag==911912) {
        
        NSError *error = nil;
        NSDictionary * jAdvertiseDataDic=[NSJSONSerialization JSONObjectWithData:hd.mData options:NSJSONReadingAllowFragments error:&error];
        if (error!=nil) {
            NSLog(@"json解析失败11");
        }else{
            NSArray* jAdvertiseArr=[jAdvertiseDataDic objectForKey:@"info"];
            NSMutableDictionary *jDic=[[NSMutableDictionary alloc]initWithCapacity:0];
            
            if (jAdvertiseArr.count>0) {
                for (NSDictionary *dic in jAdvertiseArr) {
                    NSString * advertiseId=[dic objectForKey:@"id"];
                    
                    if ([advertiseId isEqualToString:@"10"]) {
                        NSArray *contentsArr=[dic objectForKey:@"contents"];
                        NSMutableArray *contentarr=[[NSMutableArray alloc]initWithCapacity:0];
                        for (NSDictionary * contentId in contentsArr) {
                            
                            NSString *str=[contentId objectForKey:@"showLocation"];
                            NSRange rannnn=[str rangeOfString:@"ios"];
                            if (rannnn.location!=NSNotFound) {
                                [contentarr addObject:contentId];
                            }
                            
                        }
                        if (contentarr.count>0) {
                            [jDic setObject:contentarr forKey:@"newAdv"];
                        }
                    }
                    
                    
                    if ([advertiseId isEqualToString:@"15"]) {
                        NSArray *contentsArr=[dic objectForKey:@"contents"];
                        NSMutableArray *contentarr=[[NSMutableArray alloc]initWithCapacity:0];
                        for (NSDictionary * contentId in contentsArr) {
                            
                            NSString *str=[contentId objectForKey:@"showLocation"];
                            NSRange rannnn=[str rangeOfString:@"ios"];
                            if (rannnn.location!=NSNotFound) {
                                [contentarr addObject:contentId];
                            }
                            
                        }
                        if (contentarr.count>0) {
                            [jDic setObject:contentarr forKey:@"GameAdv"];
                        }
                    }
                    
                    if ([advertiseId isEqualToString:@"16"]) {
                        NSArray *contentsArr=[dic objectForKey:@"contents"];
                        NSMutableArray *contentarr=[[NSMutableArray alloc]initWithCapacity:0];
                        for (NSDictionary * contentId in contentsArr) {
                            
                            NSString *str=[contentId objectForKey:@"showLocation"];
                            NSRange rannnn=[str rangeOfString:@"ios"];
                            if (rannnn.location!=NSNotFound) {
                                [contentarr addObject:contentId];
                            }
                            
                        }
                        if (contentarr.count>0) {
                            [jDic setObject:contentarr forKey:@"AppAdv"];
                        }
                    }
                    
                }
                
                NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
                [userDefaults setObject:jDic forKey:@"advertise"];
                [userDefaults synchronize];
            }
            

        }
  }
    if (hd.tag==52011) {
        NSString *str=[[NSString alloc]initWithData:hd.mData encoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary * sssdic=[NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding]options:NSJSONReadingAllowFragments error:&error];
        if (error!=nil) {
            NSLog(@"json解析失败12011");
        }else{
            NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
            int returnCode=[[sssdic objectForKey:@"ReturnCode"]intValue];
            switch (returnCode){
                case 102:
                {
                    [userDefaults setObject:@"3" forKey:@"isLogin"];
                    NSString* string4 = [[sssdic objectForKey:@"nick"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    [userDefaults setObject:string4 forKey:@"userName"];
                    NSLog(@"%@",[userDefaults objectForKey:@"userName"]);
                    [userDefaults setBool:[[sssdic objectForKey:@"sex"]intValue]==1?1:0 forKey:@"userGenders"];
                    [userDefaults setObject:[sssdic objectForKey:@"email"] forKey:@"userEmail"];
                    [userDefaults setObject:[sssdic objectForKey:@"birth"] forKey:@"userBirthday"];
                    [userDefaults synchronize];
                    
                    NSMutableArray *array=[[NSMutableArray alloc]init];
#pragma mark 设置城市
                    if ([[sssdic objectForKey:@"city"]isEqualToString:@"1"]||[[sssdic objectForKey:@"city"]isEqualToString:@"0"]) {
                        array=[NSMutableArray arrayWithArray: [[MyDatabase sharedDatabase]readData:1 count:0 model:[[cityItem alloc]init] where:@"city_id" value:@"0"]];
                    }else{
                        array=[NSMutableArray arrayWithArray: [[MyDatabase sharedDatabase]readData:1 count:0 model:[[cityItem alloc]init] where:@"city_id" value:[sssdic objectForKey:@"city"]]];
                    }
                    
                    if (array.count) {
                        cityItem *item=array[0];
                        [userDefaults setObject:item.city_name forKey:@"SelectCityName"];
                    }
                    
                    [userDefaults synchronize];
                    
                    break;
                }
                case 107:
                    [self setNotice:@"获取个人资料失败，用户不存在或ID错误"];
                    break;
                default:
                    break;
            }

            
        }
        
    }
    if (hd.tag==515151) {
        [update cancel];
        NSString *str=[[NSString alloc]initWithData:hd.mData encoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&error];
        if (error!=nil) {
            NSLog(@"json解析失败25");
        }else{
        
            NSNumber *num=[dic objectForKey:@"ReturnCode"];
            switch ([num intValue]) {
                case 102:
                {
                    NSLog(@"515151更新成功");
                    break;
                }
                case 103:
                {
                    break;
                }
                default:
                    break;
            }
        }
 
    }
}
-(void)downloadFailed:(HttpDownload *)hd{
    if (hd.tag==6000) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"认证注销失败！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
}


#pragma mark 方法三

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    for (id key in userInfo) {
        NSLog(@"key: %@, value: %@", key, [userInfo objectForKey:key]);
    }
    
}

//以上激光推送

//以下友盟渠道分析
- (NSString * )macString{
    
    int 				mib[6];
    size_t 				len;
    char 				*buf;
    unsigned char	 	*ptr;
    struct if_msghdr 	*ifm;
    struct sockaddr_dl 	*sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *macString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return macString;
    
    
}

- (NSString *)idfaString {
    
    NSBundle *adSupportBundle = [NSBundle bundleWithPath:@"/System/Library/Frameworks/AdSupport.framework"];
    [adSupportBundle load];
    
    if (adSupportBundle == nil) {
        return @"";
    }
    else{
        
        Class asIdentifierMClass = NSClassFromString(@"ASIdentifierManager");
        
        if(asIdentifierMClass == nil){
            return @"";
        }
        else{
            
            //for no arc
            //ASIdentifierManager *asIM = [[[asIdentifierMClass alloc] init] autorelease];
            //for arc
            ASIdentifierManager *asIM = [[asIdentifierMClass alloc] init];
            
            if (asIM == nil) {
                return @"";
            }
            else{
                
                if(asIM.advertisingTrackingEnabled){
                    return [asIM.advertisingIdentifier UUIDString];
                }
                else{
                    return [asIM.advertisingIdentifier UUIDString];
                }
            }
        }
    }
}

- (NSString *)idfvString
{
    if([[UIDevice currentDevice] respondsToSelector:@selector(identifierForVendor)]) {
        return [[UIDevice currentDevice].identifierForVendor UUIDString];
    }
    
    return @"";
}

//以上友盟渠道分析
//以下创建视图控制器
-(void)creatTabBarController{
    [self loginForInfo];
    tbc=[[TabBarViewController alloc]init];
    NSMutableArray *viewArr=[NSMutableArray array];
    
    classView=@[@"NetPlayViewController",@"ChannelsViewController",@"RecommendViewController",@"ActivityViewController",@"UserViewController"];
    
    NSArray *images=@[@"g-wifi",@"zhuanbi",@"changyou",@"huodong",@"my"];
    for (int i=0; i<classView.count; i++) {
        Class class=NSClassFromString([classView objectAtIndex:i]);
        if (class) {
            UINavigationController *nvc;
            BasicViewController *lvc;
            if (i==0) {
                netPlay=[[NetPlayViewController alloc]init];
                nvc=[[UINavigationController alloc]initWithRootViewController:netPlay];
                [nvc setNavigationBarHidden:YES];
            }else{
                lvc=[[class alloc]init];
                
                nvc=[[UINavigationController alloc]initWithRootViewController:lvc];
                
            }
            
            [nvc.tabBarController.tabBar setBackgroundImage:[UIImage imageNamed:@"bottomBackground"]];
            
            if ([[[UIDevice currentDevice]systemVersion] floatValue]>=7) {
                nvc.tabBarItem.image=[[UIImage imageNamed:images[i]]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                nvc.tabBarItem.selectedImage=[[UIImage imageNamed:[NSString stringWithFormat:@"%@_d",images[i]]]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            }else{
                
                tbc.tabBar.backgroundImage=[UIImage imageNamed:@"nav"];
                tbc.tabBar.selectedImageTintColor=[UIColor clearColor];
                tbc.tabBar.selectionIndicatorImage=[[UIImage alloc]init];
                
                nvc.tabBarItem.image=[UIImage imageNamed:images[i]];
                nvc.tabBarItem.selectedImage=[UIImage imageNamed:[NSString stringWithFormat:@"%@_d",images[i]]];
            }
            
            [viewArr addObject:nvc];
        }
        
    }
    UIImageView * redPoint=[[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-20,6, 6 ,6 )];
    redPoint.image=[UIImage imageNamed:@"redPoind"];
    redPoint.tag=250120;
    [tbc.tabBar addSubview:redPoint];
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    if ([[def objectForKey:@"newsNO"] integerValue] !=0) {
        
        [redPoint setHidden:NO];
    }else{
        
        [redPoint setHidden:YES];
    }
    
    tbc.viewControllers=viewArr;
    tbc.selectedIndex=0;
    noticeView=[[UIView alloc]initWithFrame:CGRectMake(60, SCREENHEIGHT-44-35, 200, 26)];
    UIImageView *imageBg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 200, 26)];
    imageBg.image=[[UIImage imageNamed:@"tishi.png"]stretchableImageWithLeftCapWidth:10 topCapHeight:5];
    imageBg.tag=412;
    [noticeView addSubview:imageBg];
    [imageBg setAlpha:0.7];
    UILabel *notice=[[UILabel alloc]initWithFrame:CGRectMake(5, 0,190, 20)];
    notice.tag=413;
    notice.backgroundColor=[UIColor clearColor];
    notice.textAlignment=NSTextAlignmentCenter;
    notice.font=[UIFont systemFontOfSize:13];
    notice.textColor=[UIColor whiteColor];
    [noticeView addSubview:notice];
    [tbc.view addSubview:noticeView];
    [noticeView setHidden:YES];
    [self.window setRootViewController:tbc];
    
}
//以下对比版本
-(BOOL)compareVersionWithVersion:(NSString *)str andWithFlag:(int)flag{
    
    //方法说明 flag=0 判断是否升级 flag=1 判断是否是新版本首次打开
    NSDictionary *infoDictonary=[[NSBundle mainBundle]infoDictionary];
    NSString * appVersion=[infoDictonary objectForKey:@"CFBundleShortVersionString"];
    if (flag) {
        for (int i=0;i<str.length;i++) {
            if (appVersion.length>i) {
                if ([str characterAtIndex:i]<[appVersion characterAtIndex:i]) {
                    return YES;
                }
            }
            
        }
        return NO;
    }else{
        for (int i=0;i<str.length;i++) {
            if (appVersion.length>i) {
                if ([str characterAtIndex:i]>[appVersion characterAtIndex:i]) {
                    return YES;
                }
            }
            
        }
        return NO;
    }
}
#pragma mark 这里的type=0是干嘛用的？

-(void)loginOrExitSucceedWithFlag:(int)flag{
    //    userGenders  userEmail  userBirthday userName isLogin userPhone userPassword
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"hhmmss"];
    
    switch (flag) {
        case 0:
        {
            HttpDownload * getUserInfo=[[HttpDownload alloc]init];
            NSUserDefaults *userDef=[NSUserDefaults standardUserDefaults];
            NSString *QString=[NSString stringWithFormat:@"mod=userinfo&uid=%@&type=0&ntime=%@",[userDef objectForKey:@"userID"],[dateformatter stringFromDate:[NSDate date]]];
            NSData *secretData=[QString dataUsingEncoding:NSUTF8StringEncoding];
            NSData *qValueData=[secretData AES256EncryptWithKey:SECRETKEY];
            
            NSString *qValue=[qValueData newStringInBase64FromData];
            getUserInfo.delegate=self;
            getUserInfo.DFailed=@selector(downloadFailed:);
            getUserInfo.DComplete=@selector(downloadComplete:);
            NSURL *downLoadUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@/app_api/userInfo/modifyUserInfo.html?q=%@",NewBaseUrl,qValue]];
            
            if([RootUrl getIsNetOn]||[[GetCMCCIpAdress getSSID]isEqualToString:@"16wifi"]){//150414
                [getUserInfo downloadFromUrl:downLoadUrl];
            }//150414
            getUserInfo.tag=52011;
            break;
        }
        case 1:
        {
            if([RootUrl getIsNetOn]&&[[GetCMCCIpAdress getSSID]isEqualToString:@"16wifi"]){
                if ([RootUrl getIsBeiJingHuaWei]) {
                    HttpDownload *httpDl=[[HttpDownload alloc]init];
                    httpDl.delegate=self;
                    httpDl.tag=6000;
                    httpDl.DFailed=@selector(downloadFailed:);
                    httpDl.DComplete=@selector(downloadComplete:);
                    
                    [httpDl downloadFromUrl:[NSURL URLWithString:[RootUrl getBeiJingLogOutReq]] andWithTimeoutInterval:5];
                }else{
                    HttpDownload *logOutNetMaipu=[[HttpDownload alloc]init];
                    logOutNetMaipu.delegate=self;
                    logOutNetMaipu.tag=6000;
                    logOutNetMaipu.DFailed=@selector(downloadFailed:);
                    logOutNetMaipu.DComplete=@selector(downloadComplete:);
                    NSUserDefaults *userDef=[NSUserDefaults standardUserDefaults];
                    NSString * userName=[userDef objectForKey:@"userPhone"];
                    NSString *logMaipuUrl=[NSString stringWithFormat:@"http://m.16wifi.com:4990/smp/webauthservlet?kind=logout&username=%@&logoutCode=1",userName];
                    NSLog(@"通用：%@",logMaipuUrl);
                    [logOutNetMaipu downloadFromUrl:[NSURL URLWithString:logMaipuUrl] andWithTimeoutInterval:5];
                }
                
            }else if([[RootUrl getNetStatus]hasPrefix:@"114 Free"]){
                HttpDownload* registerHD=[[HttpDownload alloc]init];
                registerHD.delegate=self;
                registerHD.tag=6000;
                registerHD.DFailed=@selector(downloadFailed:);
                registerHD.DComplete=@selector(downloadComplete:);
                
                
                
                NSURL *downLoadUrl=[NSURL URLWithString:[NSString stringWithFormat:@"http://wifi.gd118114.cn/logout.ajax?%@", [RootUrl getFreeLogOutReq]]];
                NSLog(@"114下线请求：%@",downLoadUrl);
                [registerHD downloadFromUrl:downLoadUrl];

            }
            
            [self setNotice:@"已退出登录"];
            break;
        }
            
        default:
            break;
    }
    
}

//上传图片方法
-(NSString*)uploadImage:(NSString*)url param:(NSMutableDictionary*)params format:(NSString*)fmat
{
    //分界线的标识符
    
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    
    
    NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
    //根据url初始化request
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:10];
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    //要上传的图片
    
    UIImage *image=[UIImage imageNamed:[params objectForKey:@"headphoto"]];
    //得到图片的data
    //        NSData* data = UIImagePNGRepresentation(image);
    NSData* data = UIImageJPEGRepresentation(image, 0.5);
    //http body的字符串
    NSMutableString *body=[[NSMutableString alloc]init];
    //参数的集合的所有key的集合
    NSArray *keys= [params allKeys];
    
    //遍历keys
    for(int i=0;i<[keys count];i++)
    {
        //得到当前key
        NSString *key=[keys objectAtIndex:i];
        //如果key不是pic，说明value是字符类型，比如name：Boris
        if(![key isEqualToString:@"headphoto"])
        {
            //添加分界线，换行
            [body appendFormat:@"%@\r\n",MPboundary];
            //添加字段名称，换2行
            [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
            //添加字段的值
            [body appendFormat:@"%@\r\n",[params objectForKey:key]];
        }
        
    }
    
    ////添加分界线，换行
    [body appendFormat:@"%@\r\n",MPboundary];
    //声明pic字段，文件名为boris.png
    //[body appendFormat:@"Content-Disposition: form-data; name=\"pic\"; filename=\"text02.png\"\r\n"];
    
    [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",@"headphoto",[params objectForKey:@"headphoto"]];
    
    //声明上传文件的格式
    //[body appendFormat:@"Content-Type: image/png,image/jpeg\r\n\r\n"];
    NSString *contype = [NSString stringWithFormat:@"Content-Type: %@\r\n\r\n",fmat];
    NSLog(@"content type=%@",contype);
    [body appendFormat:@"Content-Type: %@\r\n\r\n",fmat];
    
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    //将image的data加入
    [myRequestData appendData:data];
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    
    //设置http body
    [request setHTTPBody:myRequestData];
    
    //http method
    [request setHTTPMethod:@"POST"];
    
    //建立连接，设置代理
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    //设置接受response的data
    if (conn) {
        NSHTTPURLResponse *urlResponese = nil;
        NSError *error;
        NSData* resultData = [NSURLConnection sendSynchronousRequest:request   returningResponse:&urlResponese error:&error];
        NSString* result= [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
        NSLog(@"返回结果=====%@ resuct code=%ld ",result,(long)[urlResponese statusCode]);
        
        [def setObject:@"0" forKey:@"updatePhoto"];
        [def synchronize];
        
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"头像上传成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        
        [self AddCoinRequestWithType:@"con_upload" ContentId:@"uploadphoto" UserId:[def objectForKey:@"userID"]CoinNum:@"2"];
        
        //        [self loadHeadPhoto];
        
        return result;
        
    }else{
        
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"头像上传失败，请稍后重试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        [def setObject:@"1" forKey:@"updatePhoto"];
        [def synchronize];
        
    }
    
    return nil;
    
}

-(void)resetNetChack{
    
    [reach stopNotifier];
    [reach startNotifier];
}
- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders{
    NSString * responseMassage=[request responseStatusMessage];
    if (request.tag==110122) {
        if ([responseMassage isEqualToString:@"HTTP/1.0 200 OK:Connection=0"]) {
            NSLog(@"认证通道关闭成功");
            
        }else{
            
            NSURL *url = [NSURL URLWithString:SWITCHOFF];
            ASIHTTPRequest *request= [ASIHTTPRequest requestWithURL:url];
            request.delegate=self;
            [request startAsynchronous];
            
        }
        
    }
    [request cancel];
}
-(void)umengEvent:(NSString *)eventId attributes:(NSDictionary *)attributes number:(NSNumber *)number{
    NSString *numberKey = @"__ct__";
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithDictionary:attributes];
    [mutableDictionary setObject:[number stringValue] forKey:numberKey];
    [MobClick event:eventId attributes:mutableDictionary];
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    
    double dd=[[RootUrl getUMLogTimeFlag]doubleValue];
    
    if (dd) {
        int tt=[[NSDate date]timeIntervalSince1970]-dd;
        [RootUrl setUMLogTimeFlag:@"0"];
        [RootUrl setUMLogClickFlag:0];
        NSLog(@"tt:%d",tt);
        NSDictionary *dict = @{@"type" : @"clickHome"};
        [self umengEvent:@"loginNet_runTime" attributes:dict number:@(tt)];
        
    }
    
    if ([[RootUrl getNetStatus]isEqualToString:@"16wifi"]&&(![RootUrl getIsNetOn])&&[RootUrl getIsBeiJingHuaWei]) {
        
        NSURL *url = [NSURL URLWithString:SWITCHOFF];
        ASIHTTPRequest *request= [ASIHTTPRequest requestWithURL:url];
        request.tag=110122;
        request.delegate=self;
        [request startAsynchronous];
    }
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}
- (NSUInteger)application:(UIApplication*)application supportedInterfaceOrientationsForWindow:(UIWindow*)window
{
    // iPhone doesn't support upside down by default, while the iPad does.  Override to allow all orientations always, and let the root view controller decide what's allowed (the supported orientations mask gets intersected).
//    return UIInterfaceOrientationMaskAll;
    return UIInterfaceOrientationMaskPortrait;
    
}
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    openFlag=0;
    
    [application setApplicationIconBadgeNumber:0];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

+(NSString*)deviceString
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"iPad2,5"])      return @"iPad mini";
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    
    NSLog(@"NOTE: Unknown device type: %@", deviceString);
    
    return deviceString;

}

+(BOOL)isIOS7
{
    return [[[UIDevice currentDevice] systemVersion] floatValue]>=7;
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [UMSocialSnsService  applicationDidBecomeActive];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    //重启网络监测
    [self resetNetChack];

    NetworkStatus netStatus = [reach currentReachabilityStatus];
    
    [self setStatusWithNetWork:netStatus];
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
