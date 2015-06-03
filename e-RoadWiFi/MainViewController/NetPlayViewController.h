//
//  NetPlayViewController.h
//  e-RoadWiFi
//
//  Created by QC on 14-8-1.
//  Copyright (c) 2014年 G.MING. All rights reserved.
//


#import "BasicViewController.h"
#import "ZhuanPanViewController.h"
#import "MyButton.h"
#import "HttpDownLoad.h"
#import "RootUrl.h"
#import "LoginViewController.h"
#import "ASIHTTPRequest.h"
#import "RequestForLoginNet.h"
#import "MobClick.h"
#import "UMSocial.h"
#import "SecurityUtil.h"
#import "GTMBase64.h"
#import "ASIFormDataRequest.h"
#define SIZEABOUTIOSVERSION ([[[UIDevice currentDevice] systemVersion] floatValue]<7.0?0:20)
@interface NetPlayViewController : BasicViewController<loginNoticeDelegate,ASIHTTPRequestDelegate,RequestForLoginNetDelegate,UMSocialUIDelegate,UIScrollViewDelegate>
{
    UIView *loginNetBg;
    
    UIImageView * showMoreImage;
    UIScrollView *guideView;
    UIImageView *StatusIcon;
    double TT;
    int isNetLogOutOn;
    int isNetLogInOn;
    int isInNetCheck;
    int checkVersion;
    
    
    NSString * logInUrl;
    NSString * logInHttpBody;
    
    UIView *goNetButBg;
    MyButton *goNetButton;
    MyButton  *logOutBut;
    int angle;
    NSTimer *aniTimer;
    UIImageView *aniImage;
    //netLogOutFlag 下线按键标记
    int netLogOutFlag;

    UIImageView *WiFiRoundInImage;
    UIImageView *wifiIcon;
    UILabel * JNetStatusLabel1;
    UILabel * JNetStatusLabel2;
  
    UIScrollView *toolViewScroll;

}
@property (nonatomic,readonly)NSMutableData *mData;
-(void)getPortalUrlWith:(int)flag;
-(void)setNetStatusWithTag:(int)tag;
-(void)setNetStatus;
-(void)chacknetwith:(int)flag;
-(void)goLogOut;

@end