//
//  AppDelegate.h
//  e-RoadWiFi
//
//  Created by QC on 14-8-1.
//  Copyright (c) 2014年 G.MING. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Reachability.h"
#import "NetPlayViewController.h"
#import "ASIHTTPRequest.h"
#import "TabBarViewController.h"
#import "WXApi.h"
#import "LoginViewController.h"
#import "RelateWxViewController.h"
#import "UMSocial.h"
@interface AppDelegate : UIResponder <UIAlertViewDelegate,UIApplicationDelegate,UIWebViewDelegate,ASIHTTPRequestDelegate,CLLocationManagerDelegate,WXApiDelegate,UMSocialUIDelegate>
{
    NSMutableDictionary *notificationDic;
    Reachability *reach;
    UITabBarController *tbc;
    NetPlayViewController *netPlay;
    int openFlag;
    int cityChackFlag;
    UIView *noticeView;
    CLLocationManager *gpsManager;
    NSMutableArray *pushInfoArray;
    int locationFlag;
    int isNewUser;
    NSString * getCityCode;
    HttpDownload *update;
}
@property (strong, nonatomic) UIWindow *window;
@property (readwrite, nonatomic)int downManageIsIn;
@property (retain, nonatomic) NSMutableArray *downingVideoArray;
@property (strong, nonatomic) LoginViewController *WXLogin;
@property (strong, nonatomic) RelateWxViewController *RelateWx;
@property (assign, nonatomic) BOOL IsLogin;
@property (strong, nonatomic) NSString *ShareContentId;
@property (strong ,nonatomic) UIViewController *delegateView;
-(void)setTabBarSelected:(int)tag;
-(void)setNotice:(NSString*)str;
-(void)creatTabBarController;
-(void)resetNetChack;
-(void)loginOrExitSucceedWithFlag:(int)flag;
-(void)chackCity;
-(void)checkChannelsData;
-(void)sendAuthRequest;
+(BOOL)isIOS7;
+(NSString*)deviceString;
-(void)AddCoinRequestWithType:(NSString *)ShareType  ContentId:(NSString *)contentid  UserId:(NSString *)user  CoinNum:(NSString *)coin;
-(NSString*)uploadImage:(NSString*)url param:(NSMutableDictionary*)params format:(NSString*)fmat;
-(void)ShowUpDateInfo;
@end
