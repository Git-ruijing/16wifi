
#import "NetPlayViewController.h"
#import "GetCMCCIpAdress.h"
#import "NSString+Hashing.h"
#import "UserGuiderViewController.h"
#import "WebSubPagViewController.h"
#import "AppDelegate.h"
#import "UserShopViewController.h"
#import "InviteViewController.h"
#import "UMFeedbackViewController.h"
#import "VedioViewController.h"
#import "NewsChannelViewController.h"
#import "SpeedViewController.h"

#define APPLEURL @"http://www.apple.com/"
#define SCREENWIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREENHEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SECRETKEY @"ilovewififorfree"
#define SWITCHON @"http://192.100.100.100/?isTunnelOpen=1"
#define SWITCHOFF @"http://192.100.100.100/?isTunnelOpen=0"
#define REQURLBEIJING @"http://www.qq.com/"
#define REQURLBEIJING2 @"http://www.baidu.com/"
#define TOOLHEIGHT 180.f
#define FREE114IN @"http://wifi.gd118114.cn/login.ajax"
#define FREE114OUT @"http://wifi.gd118114.cn/logout.ajax"
@interface NetPlayViewController ()

@end
//解决冲突域
@implementation NetPlayViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
-(void)viewWillDisappear:(BOOL)animated{
    [MobClick endLogPageView:@"netPlay"];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}
-(void)viewWillAppear:(BOOL)animated{
    NSDictionary *dict = @{@"type" : @"上网"};
    [MobClick event:@"page_select" attributes:dict];
    [MobClick beginLogPageView:@"netPlay"];

    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.navigationController setNavigationBarHidden:YES];
    self.tabBarController.tabBar.hidden=NO;
    if ([JNetStatusLabel1.text isEqualToString:@"正在检测网络"]) {
        AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
        [app resetNetChack];
    }
  
}
-(void)chacknetwith:(int)flag{
    RequestForLoginNet *ddd=[[RequestForLoginNet alloc]init];
    ddd.delegate=self;
    ddd.tag=92500+flag;
    isInNetCheck=1;
    [ddd requestFromUrl:[NSURL URLWithString:@"http://www.baidu.com/"]  andWithTimeoutInterval:5];
}
//以下认证动画
-(void)startAnimat{
    [WiFiRoundInImage setHidden:YES];
    [aniImage setHidden:NO];
    aniTimer=[NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(aniTranstorm) userInfo:nil repeats:YES];
    angle=0;
}
-(void)aniTranstorm{
    angle+=1;
    
    CGAffineTransform endAngle = CGAffineTransformMakeRotation(11*angle * (M_PI / 180.0f));
    [UIView animateWithDuration:0.03 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        aniImage.transform =endAngle;
    } completion:^(BOOL finished) {
        
    }];
    
}

-(void)stopAnimat{
    [aniTimer invalidate];
    [aniImage setHidden:YES];
    [WiFiRoundInImage setHidden:NO];
}
//以上认证动画
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden=YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    checkVersion=1;

    isInNetCheck=0;
    [self setNetStatus];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UIView* BGView=[[UIView alloc]initWithFrame:CGRectMake(0, 20, SCREENWIDTH, SCREENHEIGHT-69)];
    
    BGView.backgroundColor=[UIColor whiteColor];
    
    [self.view addSubview:BGView];
    
    UIImageView* J16icon=[[UIImageView alloc]initWithFrame:CGRectMake(15,10, 50, 15)];
    J16icon.image=[UIImage imageNamed:@"Jay16logo"];
    J16icon.backgroundColor=[UIColor clearColor];
    [BGView addSubview:J16icon];
#pragma mark  LOGO行工具栏UI
    logOutBut=[MyButton buttonWithType:UIButtonTypeCustom];
    logOutBut.frame=CGRectMake(SCREENWIDTH-88,10,24,24);
    [logOutBut setNormalImage:[UIImage imageNamed:@"quitnet"]];
    [logOutBut addTarget:self action:@selector(goLogOut)];
    [BGView addSubview:logOutBut];
    [logOutBut setHidden:YES];
        MyButton  *toolBut=[MyButton buttonWithType:UIButtonTypeCustom];
        toolBut.frame=CGRectMake(SCREENWIDTH-44,10,24,24);
        [toolBut setNormalImage:[UIImage imageNamed:@"sharenet"]];
        [toolBut addTarget:self action:@selector(shareImage)];
        [BGView addSubview:toolBut];


#pragma mark  网络状态部分UI
    StatusIcon=[[UIImageView alloc]initWithFrame:CGRectMake(125,85,20, 20)];
    StatusIcon.backgroundColor=[UIColor clearColor];
    [BGView addSubview:StatusIcon];
    [StatusIcon setHidden:YES];
    JNetStatusLabel1=[[UILabel alloc]initWithFrame:CGRectMake(150, 80, SCREENWIDTH-155, 30)];
    JNetStatusLabel1.backgroundColor=[UIColor clearColor];
    JNetStatusLabel1.font=[UIFont systemFontOfSize:18];
    [self statuseLabelSetTextWithString:@"正在检测网络" andWithFlag:0];
    JNetStatusLabel1.textAlignment=NSTextAlignmentLeft;
    [BGView addSubview:JNetStatusLabel1];
    JNetStatusLabel2=[[UILabel alloc]initWithFrame:CGRectMake(125, 110, SCREENWIDTH-125, 20)];
    JNetStatusLabel2.backgroundColor=[UIColor clearColor];
    JNetStatusLabel2.font=[UIFont systemFontOfSize:13];
    JNetStatusLabel2.textColor=[UIColor colorWithRed:153/255.f green:153/255.f blue:153/255.f alpha:1.0];
    JNetStatusLabel2.textAlignment=NSTextAlignmentLeft;
    [BGView addSubview:JNetStatusLabel2];
    
#pragma mark  一键上网部分UI
    loginNetBg=[[UIView alloc]initWithFrame:CGRectMake(27,60,87, 87)];
    [BGView addSubview:loginNetBg];
    
    UIImageView *blueRoundBg=[[UIImageView alloc]initWithFrame:CGRectMake(0,0, 87, 87)];
    blueRoundBg.image=[UIImage imageNamed:@"JayBlueRoundBG"];
    blueRoundBg.backgroundColor=[UIColor clearColor];
    [loginNetBg addSubview:blueRoundBg];
    
    WiFiRoundInImage=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,87,87)];
    WiFiRoundInImage.image=[UIImage imageNamed:@"Jaykongxin"];
    WiFiRoundInImage.backgroundColor=[UIColor clearColor];
    [loginNetBg addSubview:WiFiRoundInImage];
    
    wifiIcon=[[UIImageView alloc]initWithFrame:CGRectMake(20,24, 46, 40)];
    wifiIcon.backgroundColor=[UIColor clearColor];
    wifiIcon.image=[UIImage imageNamed:@"jayWifiIcon"];
    [wifiIcon setHidden:YES];
    [blueRoundBg addSubview:wifiIcon];
    
    
    
    
    aniImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 87, 87)];
    aniImage.image=[UIImage imageNamed:@"JayAniImage"];
    aniImage.backgroundColor=[UIColor clearColor];
    [aniImage setHidden:YES];
    [loginNetBg addSubview:aniImage];
    
    goNetButton=[MyButton buttonWithType:UIButtonTypeCustom];
    
    goNetButton.frame=CGRectMake(5, 5,77,77);
    [goNetButton setNormalImage:[UIImage imageNamed:@"jayWifiIcon"]];
    [goNetButton setNTitle:@"一键上网"];
    
    [goNetButton setNTitleColor:[UIColor whiteColor]];
    [goNetButton.titleLabel setFont:[UIFont boldSystemFontOfSize:10]];
    [goNetButton setImageEdgeInsets:UIEdgeInsetsMake(15,20,30,20)];
    [goNetButton setTitleEdgeInsets:UIEdgeInsetsMake(35,-35,0,10)];
    [goNetButton addTarget:self action:@selector(goLoginNet)];
    [loginNetBg addSubview:goNetButton];
    
    
#pragma mark  运营商及推荐部分UI
    
    toolViewScroll=[[UIScrollView alloc]initWithFrame:CGRectMake(0,TOOLHEIGHT, SCREENWIDTH,SCREENHEIGHT-TOOLHEIGHT)];
    [toolViewScroll setShowsVerticalScrollIndicator:NO];
    toolViewScroll.bounces=NO;
    
    toolViewScroll.backgroundColor=[UIColor whiteColor];
    [BGView addSubview:toolViewScroll];
    UIView *Tline1=[[UIView alloc]initWithFrame:CGRectMake(0,0,320,0.5)];
    Tline1.backgroundColor=[UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:1.f];
    [toolViewScroll addSubview:Tline1];
    UIView *Tline2=[[UIView alloc]initWithFrame:CGRectMake(0,25,320,0.5)];
    Tline2.backgroundColor=[UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:1.f];
    [toolViewScroll addSubview:Tline2];
    UIView *Tline3=[[UIView alloc]initWithFrame:CGRectMake(0,70,320,0.5)];
    Tline3.backgroundColor=[UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:1.f];
    [toolViewScroll addSubview:Tline3];
    UIView *Tline4=[[UIView alloc]initWithFrame:CGRectMake(0,95,320,0.5)];
    Tline4.backgroundColor=[UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:1.f];
    [toolViewScroll addSubview:Tline4];
    UILabel  *yunyingshang=[[UILabel alloc]initWithFrame:CGRectMake(10,2,150, 21)];
    yunyingshang.font=[UIFont systemFontOfSize:11];
    yunyingshang.textColor=[UIColor colorWithRed:51/255.f green:51/255.f blue:51/255.f alpha:1.f];
    yunyingshang.textAlignment=NSTextAlignmentLeft;
    yunyingshang.text=@"运营商WiFi";
    [toolViewScroll addSubview:yunyingshang];
    
    UIImageView *wifiFive=[[UIImageView alloc]initWithFrame:CGRectMake(70,37,100, 20)];
    wifiFive.image=[UIImage imageNamed:@"wifi_five"];
    [toolViewScroll addSubview:wifiFive];
    UILabel  *xuanzewangluo=[[UILabel alloc]initWithFrame:CGRectMake(190,37,100, 21)];
    xuanzewangluo.font=[UIFont systemFontOfSize:15];
    xuanzewangluo.textColor=[UIColor colorWithRed:51/255.f green:51/255.f blue:51/255.f alpha:1.f];
    xuanzewangluo.textAlignment=NSTextAlignmentLeft;
    xuanzewangluo.text=@"选择网络";
    [toolViewScroll addSubview:xuanzewangluo];
    UIImageView *wifiFivearro=[[UIImageView alloc]initWithFrame:CGRectMake(245,38,20, 20)];
    wifiFivearro.image=[UIImage imageNamed:@"goodarrows"];
    [toolViewScroll addSubview:wifiFivearro];
    MyButton *changeGuideButton=[MyButton buttonWithType:UIButtonTypeCustom];
    changeGuideButton.frame=CGRectMake(70,26,210,43);
    [changeGuideButton addTarget:self action:@selector(showGuide)];
    [toolViewScroll addSubview:changeGuideButton];

    
    UILabel  *tuijian=[[UILabel alloc]initWithFrame:CGRectMake(10,72,150, 21)];
    tuijian.font=[UIFont systemFontOfSize:11];
    tuijian.textColor=[UIColor colorWithRed:51/255.f green:51/255.f blue:51/255.f alpha:1.f];
    tuijian.textAlignment=NSTextAlignmentLeft;
    tuijian.text=@"热门推荐";
    [toolViewScroll addSubview:tuijian];
    NSArray *toolImageArray=@[@"jaytoolicon7",@"jaytoolicon3",@"jaytoolicon6",@"jaytoolicon2",@"jaytoolicon8",@"jaytoolicon9"];
    NSArray *toolnameArray=@[@"网络测速",@"兑换中心",@"百宝箱",@"本地资讯",@"意见反馈",@"用户指南"];
    for (int i=0; i<toolnameArray.count; i++) {
        MyButton *toolbutton=[MyButton buttonWithType:UIButtonTypeCustom];
        
        toolbutton.tag=104102+i;
        [toolbutton setNormalImage:[UIImage imageNamed:[toolImageArray objectAtIndex:i]]];
        
        [toolbutton setImageEdgeInsets:UIEdgeInsetsMake(20,SCREENWIDTH/6-20,30, SCREENWIDTH/6-20)];
        [toolbutton setTitleEdgeInsets:UIEdgeInsetsMake(40,-20,-15, 20)];
        [toolbutton setNTitleColor:[UIColor colorWithRed:51/255.f green:51/255.f blue:51/255.f alpha:1.f]];
        [toolbutton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [toolbutton setNTitle:[toolnameArray objectAtIndex:i]];
        toolbutton.frame=CGRectMake(SCREENWIDTH/3*(i<3?i:i-3),90+90*(i<3?0:1),SCREENWIDTH/3,90);
        [toolbutton addTarget:self action:@selector(buttonClick:)];
        [toolViewScroll addSubview:toolbutton];
    }
    
    toolViewScroll.contentSize=CGSizeMake(SCREENWIDTH,340);
    
    //网络设置引导页面
    guideView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, -SCREENHEIGHT, 320, SCREENHEIGHT)];
    guideView.delegate=self;
    UIView * gdbg=[[UIView alloc]initWithFrame:CGRectMake(0, 0,320,840)];
    [guideView addSubview:gdbg];
    guideView.bounces=NO;
    UIImageView *imageBackground=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 840)];
    imageBackground.image=[UIImage imageNamed:@"miji"];
    [gdbg addSubview:imageBackground];
    MyButton *hidButton=[MyButton buttonWithType:UIButtonTypeCustom];
    [hidButton setFrame:CGRectMake(110, 793, 100, 32)];
    UIImage *buttonImage=[[UIImage imageNamed:@"ll-white"]stretchableImageWithLeftCapWidth:5 topCapHeight:10];
    UIImage *button_d=[[UIImage imageNamed:@"ll-white_d"]stretchableImageWithLeftCapWidth:5 topCapHeight:10];
    [hidButton setNormalBackgroundImage:buttonImage];
    [hidButton setNTitle:@"我知道了"];
    [hidButton setNTitleColor:[UIColor colorWithRed:0/255.0f green:172/255.0f blue:238/255.0f alpha:1]];
    [hidButton setHighlightedBackgroundImage:button_d];
    [hidButton addTarget:self action:@selector(goHidden)];
    [gdbg addSubview:hidButton];
    [self.tabBarController.view addSubview:guideView];
    guideView.contentSize=CGSizeMake(320, 840);
    [guideView setHidden:YES];
    showMoreImage=[[UIImageView alloc]initWithFrame:CGRectMake(0,SCREENHEIGHT-60, SCREENWIDTH,60)];
    [showMoreImage setImage:[UIImage imageNamed:@"jaychakan"]];
    [showMoreImage setHidden:YES];
    [self.tabBarController.view addSubview:showMoreImage];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y>224) {
        [showMoreImage setHidden:YES];
    }else{
        [showMoreImage setHidden:NO];
    }
    
}
-(void)shareImage{
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    [def setObject:@"1" forKey:@"ShareWxType"];
    [def synchronize];
    
    if ([RootUrl getIsNetOn]) {
        int isLogin=[[def objectForKey:@"isLogin"]intValue];
        NSString *shareText;
        if (isLogin<2) {
            shareText=@"我一直在用16WiFi，走到那里，都能免费上网!";
        }else{
            shareText=[NSString stringWithFormat:@"赞！走那，都能免费上WiFi了，邀请码:%@",[def objectForKey:@"InvitePin"]];
        }
        NSString *murl=@"http://m.16wifi.com/thirdinfo/share/index.html";
        [UMSocialData defaultData].extConfig.wechatTimelineData.shareText=shareText;
        [UMSocialData defaultData].extConfig.wechatSessionData.shareText=shareText;
        [UMSocialData defaultData].extConfig.qzoneData.shareText=shareText;
        [UMSocialData defaultData].extConfig.sinaData.shareText=[NSString stringWithFormat:@"%@\n%@",shareText,murl];
        [UMSocialData defaultData].extConfig.qqData.shareText=shareText;
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
        
        [UMSocialData defaultData].extConfig.wechatSessionData.url = murl;
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = murl;
        [UMSocialData defaultData].extConfig.qzoneData.url = murl;
        [UMSocialData defaultData].extConfig.qqData.url = murl;
        [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeDefault url:murl];
        
        
        
        
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:UMENG_APPKEY
                                          shareText:[NSString stringWithFormat:@"%@\n%@",shareText,murl]
                                         shareImage:[self imageFromView:self.tabBarController.view]
                                    shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQzone,UMShareToQQ,UMShareToSina,nil]
                                           delegate:self];
        
        //        AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
        //        app.ShareContentId=[NSString stringWithFormat:@"%@",newitem.myNewsID];
        
    }else{
        UIAlertView *alterView=[[UIAlertView alloc]initWithTitle:nil message:@"当前网络不给力,请确认网络连接后重试" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [alterView show];
    }
}

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    NSLog(@"share success%@",response);
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
        
        NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
        
        if ( [[def objectForKey:@"ShareWxType"]isEqualToString:@"0"]) {
            
        }else{
//            AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
//            [app AddCoinRequestWithType:@"con_share" ContentId:newitem.myNewsID UserId:[def objectForKey:@"userID"]CoinNum:@"2"];
        }
        
    }
}
- (UIImage *)imageFromView: (UIView *) theView
{
    
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}
-(void)showGuide{
    NSDictionary *dict = @{@"type" : @"连接指南"};
    [MobClick event:@"main_function" attributes:dict];
    [guideView setHidden:NO];
    
    [UIView animateWithDuration:0.5 animations:^{
        guideView.frame=CGRectMake(0, 0, 320, SCREENHEIGHT);
    } completion:^(BOOL finished){
        [showMoreImage setHidden:NO];
    }];
}
-(void)goHidden{
   
    guideView.contentOffset=CGPointMake(0, 0);
    [showMoreImage setHidden:YES];
    [UIView animateWithDuration:0.5 animations:^{
        guideView.frame=CGRectMake(0, -SCREENHEIGHT, 320, SCREENHEIGHT);
    } completion:^(BOOL finished){
    }];
    
}
//以下初始化数据
-(void)setNetStatus{
    netLogOutFlag=0;
    logInUrl=@"";
    logInHttpBody=@"";
    isNetLogInOn=0;
    isNetLogOutOn=0;
    
}
//以上初始化数据
-(void)payCaidou{
    HttpDownload *chackLiuliangHd=[[HttpDownload alloc]init];
    chackLiuliangHd.delegate=self;
    chackLiuliangHd.tag=770770;
    chackLiuliangHd.DFailed=@selector(downloadFailed:);
    chackLiuliangHd.DComplete=@selector(downloadComplete:);
   
    
    NSString *LoadUrl=[NSString stringWithFormat:@"mod=cutcredittoday&uid=%@&mac=%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"userID"],[RootUrl getIDFA]];
    
    NSData *secretData=[LoadUrl dataUsingEncoding:NSUTF8StringEncoding];
    NSData *qValueData=[secretData AES256EncryptWithKey:SECRETKEY];
    NSString *qValue=[qValueData newStringInBase64FromData];
    
    NSString *urlstr=[NSString stringWithFormat:@"%@/app_api/credit/deleteCreditOneTime.html?q=%@",NewBaseUrl,qValue];
    NSLog(@"kkdd:%@",urlstr);
    [chackLiuliangHd downloadFromUrl:[NSURL URLWithString:urlstr]];
}

//以下设置网络状态界面显示
-(void)setNetStatusWithTag:(int)tag{
    
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    [def setObject:[NSString stringWithFormat:@"%d",tag] forKey:@"NetStatusTag"];
    [def synchronize];
    
    if (aniTimer) {
        if (aniTimer.isValid) {
            [self stopAnimat];
        }
    }
    
    switch (tag) {
        case 0:
        {
            [self setNetStatus];
            [self statuseLabelSetTextWithString:@"网络未连接" andWithFlag:1];
            JNetStatusLabel2.text=@"无法访问网络";
            [goNetButton setHidden:YES];
            [wifiIcon setImage:[UIImage imageNamed:@"jayNoNetIcon"]];
            [wifiIcon setHidden:NO];
            [logOutBut setHidden:YES];
            break;
        }
        case 1:
        {
            
            [self setNetStatus];
            if (checkVersion) {
                checkVersion=0;
                [self checkAppVersion];
            }
            [self statuseLabelSetTextWithString:@"已连接蜂窝网络" andWithFlag:2];
            JNetStatusLabel2.text=@"将消耗您的4G/3G/2G流量";
            [goNetButton setHidden:YES];
            [wifiIcon setImage:[UIImage imageNamed:@"Jay3g"]];
            [wifiIcon setHidden:NO];
            [logOutBut setHidden:YES];
            break;
        }
        case 2:
        {
            
            
            [self setNetStatus];
            
            if (checkVersion) {
                checkVersion=0;
                [self checkAppVersion];
            }
            if ([GetCMCCIpAdress getSSID].length) {
                [self statuseLabelSetTextWithString:[NSString stringWithFormat:@"已连接%@",[GetCMCCIpAdress getSSID]] andWithFlag:2];
            }else{
                
                [self statuseLabelSetTextWithString:@"未知网络" andWithFlag:2];
            }
            JNetStatusLabel2.text=@"可正常访问互联网";
            [goNetButton setHidden:YES];
            [wifiIcon setImage:[UIImage imageNamed:@"jayWifiIcon"]];
            [wifiIcon setHidden:NO];
            [logOutBut setHidden:YES];
            break;
        }
            
        case 3:
        {
            
            
            if (checkVersion) {
                checkVersion=0;
                [self checkAppVersion];
            }
            isNetLogInOn=0;
            isNetLogOutOn=0;
            
            [self statuseLabelSetTextWithString:@"已连接16wifi" andWithFlag:3];
            JNetStatusLabel2.text=@"点击一键上网访问互联网";
            [goNetButton setHidden:NO];
            [goNetButton setNTitle:@"一键上网"];
              [logOutBut setHidden:YES];
            [wifiIcon setHidden:YES];
            break;
        }
        case 4:
        {
            
            
     
            isNetLogInOn=0;
            isNetLogOutOn=0;
            
            [self statuseLabelSetTextWithString:@"已连接114 Free" andWithFlag:3];
            JNetStatusLabel2.text=@"点击一键上网访问互联网";
            [goNetButton setHidden:NO];
            [goNetButton setNTitle:@"一键上网"];
              [logOutBut setHidden:YES];
            [wifiIcon setHidden:YES];
            break;
        }
        case 5:
        {
            
            
            
            isNetLogInOn=0;
            isNetLogOutOn=0;
            
            [self statuseLabelSetTextWithString:@"已连接ChinaNet" andWithFlag:3];
            JNetStatusLabel2.text=@"点击一键上网访问互联网";
            [goNetButton setHidden:NO];
            [goNetButton setNTitle:@"一键上网"];
            [wifiIcon setHidden:YES];
              [logOutBut setHidden:YES];
            break;
        }
        default:
            break;
    }
}

-(void)getPortalUrlWith:(int)flag{
    switch (flag) {
        case 0:
        {
            NSURL *url = [NSURL URLWithString:SWITCHON];
            ASIHTTPRequest *request= [ASIHTTPRequest requestWithURL:url];
            request.tag=110120;
            request.delegate=self;
            [request startAsynchronous];
            JNetStatusLabel2.text=@"正在检测网络状态";
            if (aniTimer) {
                if (aniTimer.isValid) {
                    [self stopAnimat];
                }
            }
            NSLog(@"getPortal2");
            break;
        }
        case 1:
        {

            JNetStatusLabel2.text=@"正在检测网络状态";
            if (aniTimer) {
                if (aniTimer.isValid) {
                    [self stopAnimat];
                }
            }
            [self chacknetwith:5];
            NSLog(@"getPortal1");
            break;
        }
            
        default:
            break;
    }

    
}
-(void)goLoginNet{
#pragma mark  用户点击一键上网方法
    if(isInNetCheck){
        AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
        [app setNotice:@"正在检测网络状态，请稍后重试！"];
        return;
    }
    
    if ([[GetCMCCIpAdress getSSID]isEqualToString:@"16wifi"]) {
#pragma mark  统计事件一上网点击
        
        
        NSUserDefaults * userDefault=[NSUserDefaults standardUserDefaults];
        int isLogin=[[userDefault objectForKey:@"isLogin"]intValue];
        NSDictionary *dict = @{@"type" : [NSString stringWithFormat:@"%@-16wifi",[userDefault objectForKey:@"city"]]};
        [MobClick event:@"login" attributes:dict];
        if (isLogin<2) {
                
            LoginViewController *loginCtr=[[LoginViewController alloc]init];
            loginCtr.delegate=self;
            
            loginCtr.Ltag=3;
            [self presentViewController:loginCtr animated:YES completion:^{
                [loginCtr showNotice:@"请您先登录，即刻享有一键上网特权"];
            }];
            
        }else{
            if (isNetLogInOn==0) {
                isNetLogInOn=1;
            }else{
                return;
            }
            [goNetButton setNTitle:@"正在认证"];
            JNetStatusLabel2.text=@"正在认证网络...";
            [self startAnimat];
            
#pragma mark  上网通道检查中
            TT=[[NSDate date]timeIntervalSince1970];
            
            if ([RootUrl getIsBeiJingHuaWei]) {
                
                [self loginBeiJing1];
            }else{
                
                [self loginNetStep1];
            }
        }
        
        
    }else if([[RootUrl getNetStatus]hasPrefix:@"114 Free"]){
        NSUserDefaults * userDefault=[NSUserDefaults standardUserDefaults];
        int isLogin=[[userDefault objectForKey:@"isLogin"]intValue];
        NSDictionary *dict = @{@"type" :[NSString stringWithFormat:@"%@-114 Free",[userDefault objectForKey:@"city"]]};
        [MobClick event:@"login" attributes:dict];
        if (isLogin<2) {
            
            UIAlertView *alertV=[[UIAlertView alloc]initWithTitle:@"" message:@"请您先登录(需先切换到蜂窝网络登录)，即刻享有一键上网特权" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
            [alertV show];
        }else{
            if (isNetLogInOn==0) {
                isNetLogInOn=1;
            }else{
                return;
            }
            [goNetButton setNTitle:@"正在认证"];
            JNetStatusLabel2.text=@"正在认证网络...";
            [self startAnimat];
            
#pragma mark  上网通道检查中
    
            [self loginnet114Free];
          
        }

    }else if([[RootUrl getNetStatus]hasPrefix:@"ChinaNet"]){
        NSUserDefaults * userDefault=[NSUserDefaults standardUserDefaults];
        int isLogin=[[userDefault objectForKey:@"isLogin"]intValue];
        NSDictionary *dict = @{@"type" :[NSString stringWithFormat:@"%@ChinaNet",[userDefault objectForKey:@"city"]]};
        [MobClick event:@"login" attributes:dict];
        if (isLogin<2) {
            
            UIAlertView *alertV=[[UIAlertView alloc]initWithTitle:@"" message:@"请您先登录(需先切换到蜂窝网络登录)，即刻享有一键上网特权" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
            [alertV show];
        }else{
            if (isNetLogInOn==0) {
                isNetLogInOn=1;
            }else{
                return;
            }
            [goNetButton setNTitle:@"正在认证"];
            JNetStatusLabel2.text=@"正在认证网络...";
            [self startAnimat];
            
#pragma mark  电信上网
            
            [self loginChinaNet];
            
        }
        
    }else if([[RootUrl getNetStatus]isEqualToString:@"wifi"]){
        AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
        [app setNotice:@"WiFi网络已连接！"];
        [self setNetStatusWithTag:2];
    }else if([[RootUrl getNetStatus]isEqualToString:@"4G/3G/2G"]){
        AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
        [app setNotice:@"正在使用蜂窝网络！"];
        
    }else{
        AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
        [app setNotice:@"当前网络不可用!请连接到16wifi！"];
    }
    
}
-(void)loginChinaNet{
}
-(void)loginnet114Free{
    _mData=[[NSMutableData alloc]init];
    NSURL *url = [NSURL URLWithString:REQURLBEIJING];
    ASIHTTPRequest *request= [ASIHTTPRequest requestWithURL:url];
    request.tag=82502;
    request.delegate=self;
    [request startAsynchronous];
}
//以下认证第一步 先请求通用接口认证
-(void)loginBeiJing1{
    NSUserDefaults *userDef=[NSUserDefaults standardUserDefaults];
    NSString *acname=[userDef objectForKey:@"acname"];
    
    if(acname.length>10){
        [self getBeiJingPortal];
    }else{
        AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
        [app setNotice:@"未分配上网账号，正在获取!"];
        HttpDownload *beijingHD=[[HttpDownload alloc]init];
        beijingHD.delegate=self;
        beijingHD.tag=88088088;
        beijingHD.DFailed=@selector(downloadFailed:);
        beijingHD.DComplete=@selector(downloadComplete:);
        NSString *QValueStr=[NSString stringWithFormat:@"mod=getOtherAC&uid=%@",[userDef objectForKey:@"userID"]];
        NSLog(@"获取账号：%@",QValueStr);
        NSData *secretData=[QValueStr dataUsingEncoding:NSUTF8StringEncoding];
        NSData *qValueData=[secretData AES256EncryptWithKey:SECRETKEY];
        
        NSString *qValue=[qValueData newStringInBase64FromData];
        

        NSURL *downLoadUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@/app_api/userAccount/getBeijingACUser.html?q=%@",NewBaseUrl,qValue]];
        [beijingHD downloadFromUrl:downLoadUrl];

    }

}
-(void)loginBeiJing2:(NSString*)str{
    logInUrl=@"";
    logInHttpBody=@"";
    NSString *frameSrc1=[[str componentsSeparatedByString:@"<frame src='"]lastObject];
    NSArray *jGetUrlArr=[frameSrc1 componentsSeparatedByString:@"'"];
    NSString *firstGetUrl;
    if (jGetUrlArr.count) {
        firstGetUrl=[jGetUrlArr objectAtIndex:0];
    }
    
    NSString *returnString=[NSString stringWithContentsOfURL:[NSURL URLWithString:firstGetUrl] encoding:NSUTF8StringEncoding error:nil];
    
    NSArray *jReturnStringArr=[[[returnString componentsSeparatedByString:@"<div><form id=\"staticloginid\" name=\"staticlogin\""]lastObject]componentsSeparatedByString:@"</form>"];
    NSString *staticLoginAbout;
    if (jReturnStringArr.count) {
        staticLoginAbout=[jReturnStringArr objectAtIndex:0];
    }
    NSArray *jLoginUrlArr=[[[staticLoginAbout componentsSeparatedByString:@"action=\""]lastObject]componentsSeparatedByString:@"\""];
    
    if (jLoginUrlArr.count) {
        logInUrl=[jLoginUrlArr objectAtIndex:0];
    }
    NSArray * inputArray=[staticLoginAbout componentsSeparatedByString:@"<input"];
    for (NSString *subString in inputArray) {
        NSString *subString1=[[subString componentsSeparatedByString:@"/>"]objectAtIndex:0];
        NSRange ran=[subString1 rangeOfString:@"name=\""];
        NSRange ran2=[subString1 rangeOfString:@"value=\""];
        if (ran.location!=NSNotFound&&ran2.location!=NSNotFound) {
            NSString *name=[[[[subString1 componentsSeparatedByString:@"name=\""]lastObject]componentsSeparatedByString:@"\""]objectAtIndex:0];
            logInHttpBody=[NSString stringWithFormat:@"%@&%@",logInHttpBody,name];
            
            NSString *value=[[[[subString1 componentsSeparatedByString:@"value=\""]lastObject]componentsSeparatedByString:@"\""]objectAtIndex:0];
            
            logInHttpBody=[NSString stringWithFormat:@"%@=%@",logInHttpBody,value];
        }
        
    }
    if (![logInUrl isEqualToString:@""]) {
        //成功获取参数
        NSLog(@"成功获取参数%@%@",logInUrl,logInHttpBody);
        [self loginBeiJing3];
        
        
    }
    
}
-(void)loginBeiJing3{

    HttpDownload *beijingHD=[[HttpDownload alloc]init];
    beijingHD.delegate=self;
    beijingHD.tag=111010;
    beijingHD.DFailed=@selector(downloadFailed:);
    beijingHD.DComplete=@selector(downloadComplete:);
    NSURL *reqUrl=[NSURL URLWithString:logInUrl];
    NSUserDefaults *userDef=[NSUserDefaults standardUserDefaults];
    
    NSLog(@"北京认证开始:%@",[NSString stringWithFormat:@"staticusername=%@&staticpassword=%@%@",[userDef objectForKey:@"acname"],[userDef objectForKey:@"acpass"],logInHttpBody]);
    [beijingHD downloadFromUrl:reqUrl andWithString:[NSString stringWithFormat:@"staticusername=%@&staticpassword=%@%@",[userDef objectForKey:@"acname"],[userDef objectForKey:@"acpass"],logInHttpBody]];
    
}
-(void)getBeiJingPortal{
    RequestForLoginNet *jRequest=[[RequestForLoginNet alloc]init];
    jRequest.delegate=self;
    jRequest.tag=92502;
    [jRequest requestFromUrl:[NSURL URLWithString:REQURLBEIJING] andWithTimeoutInterval:8];

}
-(void)loginNetStep1{
    
    HttpDownload *maipuHD=[[HttpDownload alloc]init];
    maipuHD.tag=8111;
    maipuHD.delegate=self;
    maipuHD.DFailed=@selector(downloadFailed:);
    maipuHD.DComplete=@selector(downloadComplete:);
    NSUserDefaults *userDef=[NSUserDefaults standardUserDefaults];
    NSString * userName=[userDef objectForKey:@"userPhone"];
    NSString * userPassWord=[[[NSString stringWithFormat:@"%@16wifi",[[[userDef objectForKey:@"userPassword"]MD5Hash]lowercaseString]]MD5Hash]lowercaseString];
    NSString *logMaipuUrl=[NSString stringWithFormat:@"http://m.16wifi.com:4990/smp/webauthservlet?kind=preLogin&username=%@&password=%@&sign=kasdf3jr3asdjfdf",userName,userPassWord];
    NSLog(@"log:%@",logMaipuUrl);
    [maipuHD downloadFromUrl:[NSURL URLWithString:logMaipuUrl] andWithTimeoutInterval:20];
    
}



-(void)goLogOut{
 
    if (isNetLogOutOn==0) {
        isNetLogOutOn=1;
    }else{
        return;
    }
    [self startAnimat];
#pragma mark  统计事件断开网络
    
    JNetStatusLabel2.text=@"正在断开网络...";
    if ([[GetCMCCIpAdress getSSID]isEqualToString:@"16wifi"]) {
        if ([RootUrl getIsBeiJingHuaWei]) {
            [self logOutBeiJing1];
        }else{
            [self logOutNetStep1];
        }
    }else if([[RootUrl getNetStatus]hasPrefix:@"114 Free"]){
        [self logOut114Free];
    }else if([[RootUrl getNetStatus]hasPrefix:@"ChinaNet"]){
        [self logOutChinaNet];
    }
    

  
}
-(void)logOutChinaNet{
  
}
-(void)logOut114Free{
    HttpDownload* registerHD=[[HttpDownload alloc]init];
    registerHD.delegate=self;
    registerHD.tag=11402;
    registerHD.DFailed=@selector(downloadFailed:);
    registerHD.DComplete=@selector(downloadComplete:);

    

    NSURL *downLoadUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@?%@",FREE114OUT, [RootUrl getFreeLogOutReq]]];
    NSLog(@"114下线请求：%@",downLoadUrl);
    [registerHD downloadFromUrl:downLoadUrl];

}
-(void)logOutBeiJing1{
    
    HttpDownload *httpDl=[[HttpDownload alloc]init];
    httpDl.delegate=self;
    httpDl.DFailed=@selector(downloadFailed:);
    httpDl.DComplete=@selector(downloadComplete:);
    httpDl.tag=222010;
    [httpDl downloadFromUrl:[NSURL URLWithString:[RootUrl getBeiJingLogOutReq]] andWithTimeoutInterval:10];
}

-(void)logOutBeiJing2:(NSString *)str{
    NSString *frameSrc1=[[str componentsSeparatedByString:@"<form name=\"portal\" method=\"post\" action=\""]lastObject];
    NSString *frameSrc2=[[frameSrc1 componentsSeparatedByString:@"</form>"]objectAtIndex:0];
    NSString *logOutUrl=[[frameSrc2 componentsSeparatedByString:@"\""]objectAtIndex:0];
    NSArray * inputArray=[frameSrc2 componentsSeparatedByString:@"<input"];
    //获取有值 切值不为空的参数
    NSString *logOutHttpBody;
    for (NSString *subString in inputArray) {
        NSString *subString1=[[subString componentsSeparatedByString:@"/>"]objectAtIndex:0];
        NSRange ran=[subString1 rangeOfString:@"name=\""];
        NSRange ran2=[subString1 rangeOfString:@"value=\""];
        if (ran.location!=NSNotFound&&ran2.location!=NSNotFound) {
            NSString *name=[[[[subString1 componentsSeparatedByString:@"name=\""]lastObject]componentsSeparatedByString:@"\""]objectAtIndex:0];
            
            
            NSString *value=[[[[subString1 componentsSeparatedByString:@"value=\""]lastObject]componentsSeparatedByString:@"\""]objectAtIndex:0];
            if( (![name isEqualToString:@""])&&(![value isEqualToString:@""])) {
                logOutHttpBody=[NSString stringWithFormat:@"%@&%@",logOutHttpBody,name];
                logOutHttpBody=[NSString stringWithFormat:@"%@=%@",logOutHttpBody,value];
            }
            
        }
        
    }
    NSLog(@"获取参数:%@",logOutHttpBody);
    logOutHttpBody=[logOutHttpBody substringFromIndex:1];
    [RootUrl setBeiJingLogOutReq:[NSString stringWithFormat:@"%@?%@",logOutUrl,logOutHttpBody]];
}

-(void)logOutNetStep1{
    HttpDownload *logOutNetMaipu=[[HttpDownload alloc]init];
    logOutNetMaipu.tag=8222;
    logOutNetMaipu.delegate=self;
    logOutNetMaipu.DFailed=@selector(downloadFailed:);
    logOutNetMaipu.DComplete=@selector(downloadComplete:);
    NSUserDefaults *userDef=[NSUserDefaults standardUserDefaults];
    NSString *userName=[userDef objectForKey:@"userPhone"];
    if ([userName isEqual:[NSNull null]]) {
        userName=[userDef objectForKey:@"userPhone"];
    }
    NSString *logMaipuUrl=[NSString stringWithFormat:@"http://m.16wifi.com:4990/smp/webauthservlet?kind=logout&username=%@&logoutCode=1",userName];
    [logOutNetMaipu downloadFromUrl:[NSURL URLWithString:logMaipuUrl] andWithTimeoutInterval:8];
}

-(void)showNetOnViewWithWifiId:(NSString *)wifiId{
    [self stopAnimat];
    isNetLogInOn=0;
    isNetLogOutOn=0;
    [RootUrl setIsNetOn:YES];
    [self statuseLabelSetTextWithString:[NSString stringWithFormat:@"已连接%@",wifiId] andWithFlag:2];
    JNetStatusLabel2.text=@"可正常访问网络";
    [goNetButton setHidden:YES];
    [logOutBut setHidden:NO];
    [wifiIcon setImage:[UIImage imageNamed:@"jayWifiIcon"]];
    [wifiIcon setHidden:NO];

}
-(void)statuseLabelSetTextWithString:(NSString *)str andWithFlag:(int)n{

    JNetStatusLabel1.text=str;
    switch (n) {
        case 0:
            [StatusIcon setHidden:YES];
            break;
        case 1:
        {
            [StatusIcon setHidden:NO];
            [StatusIcon setImage:[UIImage imageNamed:@"erro"]];
            break;
        }
        case 2:
        {
            [StatusIcon setHidden:NO];
            [StatusIcon setImage:[UIImage imageNamed:@"right"]];
            break;
        }
        case 3:
        {
            [StatusIcon setHidden:NO];
            [StatusIcon setImage:[UIImage imageNamed:@"warn"]];
            break;
        }
        default:
            break;
    }
}

-(void)showNetOffViewWithWifiId:(NSString *)wifiId{
    [self stopAnimat];
    isNetLogInOn=0;
    isNetLogOutOn=0;
    [RootUrl setIsNetOn:NO];
    [self statuseLabelSetTextWithString:[NSString stringWithFormat:@"已连接%@",wifiId] andWithFlag:3];
    JNetStatusLabel2.text=@"点击一键上网访问互联网";
    [goNetButton setSelected:NO];
    [goNetButton setHidden:NO];
    [logOutBut setHidden:YES];
    [goNetButton setNTitle:@"一键上网"];
    [wifiIcon setHidden:YES];

    
}

-(void)buttonClick:(MyButton *)button{
    switch (button.tag) {
            
        case 104102:
        {
            
            NSDictionary *dict = @{@"type" : @"网络测速"};
            [MobClick event:@"main_function" attributes:dict];
            [MobClick event:@"earn_click" attributes:dict];
            if([RootUrl getIsNetOn]){
                SpeedViewController *speed=[[SpeedViewController alloc]init];
                [self.navigationController pushViewController:speed animated:YES];
                
            }else{
                
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"网络未连接" message:@"未连接，或未认证网络，无法测速！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
                [alert show];
            }
        }
            break;
        case 104103:
        {
            NSLog(@"兑换流量");
            NSDictionary *dict = @{@"type" : @"兑换流量"};
            [MobClick event:@"main_function" attributes:dict];
            UserShopViewController *userShop=[[UserShopViewController alloc]init];
            
            [self.navigationController pushViewController:userShop animated:YES];
        }
            break;
        case 104104:
        {
     
            NSDictionary *dict = @{@"type" : @"百宝箱"};
            [MobClick event:@"main_function" attributes:dict];
            [MobClick event:@"earn_click" attributes:dict];
            NSUserDefaults * userDefault=[NSUserDefaults standardUserDefaults];
            int isLogin=[[userDefault objectForKey:@"isLogin"]intValue];
            
            if (isLogin<2) {
                
                LoginViewController *loginCtr=[[LoginViewController alloc]init];
                loginCtr.delegate=self;
                loginCtr.Ltag=1;
                [self presentViewController:loginCtr animated:YES completion:^{
                    [loginCtr showNotice:@"请您先登录"];
                }];
            }else{
                ZhuanPanViewController *wvc=[[ZhuanPanViewController alloc]init];
                
                wvc.myRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://clienthtml.16wifi.com/baibaoxiang/index.html?phone=%@&city=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userPhone"],[RootUrl getCity]]]];
                [self presentViewController:wvc animated:YES completion:nil];
            }
        }
            break;
            
            
            
            
        case 104105:
        {
            NSDictionary *dict = @{@"type" : @"看资讯"};
            [MobClick event:@"main_function" attributes:dict];
            [MobClick event:@"earn_click" attributes:dict];
            WebSubPagViewController *subPage=[[WebSubPagViewController alloc]init];
            subPage.isPush=0;
            [subPage setName:@"资讯"];
            if ([RootUrl getIsNetOn]) {
                    subPage.myRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:[RootUrl getRootUrl]]];
            }else{
            
                    subPage.myRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:[RootUrl getContentUrl]]];
            }
        
            [self.navigationController presentViewController:subPage animated:YES completion:^{}];
            
            
        }
            break;
        case 104106:
        {
            NSDictionary *dict = @{@"type" : @"意见反馈"};
            [MobClick event:@"main_function" attributes:dict];
            [MobClick event:@"earn_click" attributes:dict];
            UMFeedbackViewController *feedbackViewController = [[UMFeedbackViewController alloc] init];
            feedbackViewController.appkey = UMENG_APPKEY;
            [self.navigationController presentViewController:feedbackViewController animated:YES completion:nil];
            
        }
            break;
        case 104107:
        {
            
            NSDictionary *dict = @{@"type" : @"用户指南"};
            [MobClick event:@"main_function" attributes:dict];
            [MobClick event:@"earn_click" attributes:dict];
            UserGuiderViewController *guide=[[UserGuiderViewController alloc]init];
            [self.navigationController pushViewController:guide animated:YES];
        }
            break;
        default:
            break;
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
     NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    if (buttonIndex==1) {
        [def setObject:@"1" forKey:@"ShowUpDate"];
        [def synchronize];
        
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/us/app/id893920240"]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.16wifi.com/3gapi/ua.html"]];
        
    }else{
    
        [def setObject:@"0" forKey:@"ShowUpDate"];
        [def synchronize];
    }
}
//处理网络判断
-(void)forLoginRequestComplete:(RequestForLoginNet *)hd{
  
    if (hd.tag==92502) {
        NSString * str=[[NSString alloc]initWithData:hd.mData encoding:NSUTF8StringEncoding];
    
        NSString *wlanacname=[[[[str componentsSeparatedByString:@"name=\"wlanacname\" value=\""]lastObject]componentsSeparatedByString:@"\""]objectAtIndex:0];
        NSString *wlanuserip=[[[[str componentsSeparatedByString:@"name=\"wlanuserip\" value=\""]lastObject]componentsSeparatedByString:@"\""]objectAtIndex:0];
        if (wlanacname.length<2||wlanuserip.length<2) {
#pragma mark  统计事件一上网失败 bj
            NSDictionary *dict = @{@"type" : @"bj_getPortalFail"};
            [MobClick event:@"loginNetFailedBJ" attributes:dict];
            NSUserDefaults *userDef=[NSUserDefaults standardUserDefaults];
            NSString *mobValue=[NSString stringWithFormat:@"bj_getPortalFail_phone:%@_ac:%@",[userDef objectForKey:@"userPhone"],[userDef objectForKey:@"acname"]];
            NSDictionary *dict3 = @{@"type" : mobValue};
            [MobClick event:@"internet_error" attributes:dict3];
            AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
            [app setNotice:@"认证失败，请点击一键上网重新认证!"];
            
            [self showNetOffViewWithWifiId:@"16wifi"];
            return;
        }
        NSString *reqUrl=[NSString stringWithFormat:@"http://211.136.25.213/index.php?wlanuserip=%@&wlanacname=%@&ssid=16wifi",wlanuserip,wlanacname];
        NSLog(@"bbb%@",reqUrl);
        HttpDownload *getBeijing=[[HttpDownload alloc]init];
        getBeijing.delegate=self;
        getBeijing.tag=92503;
        getBeijing.DFailed=@selector(downloadFailed:);
        getBeijing.DComplete=@selector(downloadComplete:);
        [getBeijing downloadFromUrl:[NSURL URLWithString:reqUrl] andWithTimeoutInterval:5];
        
    }

    
}
#pragma 第一步
-(void)forLoginRequestFaild:(RequestForLoginNet *)hd{
    if (hd.tag==92501||hd.tag==92505) {
         NSLog(@"响应未登入2");
        [self stopAnimat];
        [RootUrl setIsNetOn:NO];
        JNetStatusLabel2.text=@"点击一键上网访问互联网";
        isInNetCheck=0;
    }
    
    if (hd.tag==92502) {
#pragma mark  统计事件一上网失败 bj
        NSDictionary *dict = @{@"type" : @"bj_getPortalFail"};
        [MobClick event:@"loginNetFailedBJ" attributes:dict];
        NSUserDefaults *userDef=[NSUserDefaults standardUserDefaults];
        NSString *mobValue=[NSString stringWithFormat:@"bj_getPortalFail_phone:%@_ac:%@",[userDef objectForKey:@"userPhone"],[userDef objectForKey:@"acname"]];
        NSDictionary *dict3 = @{@"type" : mobValue};
        [MobClick event:@"internet_error" attributes:dict3];
        [self showNetOffViewWithWifiId:@"16wifi"];
        AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
        [app setNotice:@"认证失败，请点击一键上网重新认证!"];
        
    }

    
}
#pragma mark 这里有问题
-(void)forLoginReceiveResponse:(NSURLResponse *)response andWith:(RequestForLoginNet *)hd{
    if (hd.tag==92501||hd.tag==92505) {
        NSLog(@"响应1");
        if ([response.textEncodingName isEqualToString:@"utf-8"]&&[response.suggestedFilename isEqualToString:@"www.baidu.com.html"]) {
            [RootUrl setIsNetOn:YES];
#pragma mark 是不是要加显示状态
            isInNetCheck=0;
            [self showNetOnViewWithWifiId:@"16wifi"];
             NSLog(@"响应登入");
            AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
            [app setNotice:@"您已登入网络"];
            
        }else{
#pragma mark   程序开始
            NSLog(@"响应未登入");
            [RootUrl setIsNetOn:NO];
            JNetStatusLabel2.text=@"点击一键上网访问互联网";
            isInNetCheck=0;
        }
        [hd cancel];
    }
    if (hd.tag==92505) {
        NSLog(@"响应2");
        if ([response.textEncodingName isEqualToString:@"utf-8"]&&[response.suggestedFilename isEqualToString:@"www.baidu.com.html"]) {
            [RootUrl setIsNetOn:YES];
#pragma mark 是不是要加显示状态
            isInNetCheck=0;
            [self showNetOnViewWithWifiId:@"114 Free"];
            NSLog(@"响应登入");
            AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
            [app setNotice:@"您已登入网络"];
            
        }else{
#pragma mark   程序开始
            NSLog(@"响应未登入");
            [RootUrl setIsNetOn:NO];
            JNetStatusLabel2.text=@"点击一键上网访问互联网";
            isInNetCheck=0;
        }
        [hd cancel];
    }
    if (hd.tag==92502) {
        
        if ([response.URL.description hasPrefix:@"http://211.136.25.213/index.php?"]) {
            NSString *str=[NSString stringWithContentsOfURL:response.URL encoding:NSUTF8StringEncoding error:nil];
            [hd cancel];
            NSLog(@"ssss:%@",response.URL);
            [self loginBeiJing2:str];
            
        }
    }


}

-(void)requestFailed:(ASIHTTPRequest *)request{
    if (request.tag==82502) {
#pragma mark  统计事件一上网失败 bj
        NSDictionary *dict = @{@"type" : @"114_getPortalFail"};
        [MobClick event:@"loginNetFailedBJ" attributes:dict];
        NSUserDefaults *userDef=[NSUserDefaults standardUserDefaults];
        NSString *mobValue=[NSString stringWithFormat:@"114_getPortalFail_phone:%@_ac:%@",[userDef objectForKey:@"userPhone"],[userDef objectForKey:@"acname"]];
        NSDictionary *dict3 = @{@"type" : mobValue};
        [MobClick event:@"internet_error" attributes:dict3];
        [self showNetOffViewWithWifiId:@"114 Free"];
        AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
        [app setNotice:@"认证失败，请点击一键上网重新认证!"];
        
    }
    

    if (request.tag==110120) {
        
        
        [RootUrl setIsBeiJingHuaWei:NO];
        if (isInNetCheck==0) {
            [self chacknetwith:1];
        }
        
    }
}
-(void)log114NoAcName{
    NSUserDefaults *userDef=[NSUserDefaults standardUserDefaults];
    ;
    ASIFormDataRequest *formDataRequest = [ASIFormDataRequest requestWithURL:nil];
    
    
    NSString *qValue1=[SecurityUtil encryptAESData:[userDef objectForKey:@"userPhone"] app_key:@"fromthirdboxwifi"];
    
    NSString *qValue=[formDataRequest encodeURL:qValue1];;
    
    //        NSString *qValue=[[secretData AES128EncryptWithKey:@"fromthirdboxwifi" iv:@""] newStringInBase64FromData];
    //        NSLog(@"phone:%@ ,V:%@",[userDef objectForKey:@"userPhone"],qValue);
    HttpDownload* registerHD=[[HttpDownload alloc]init];
    registerHD.delegate=self;
    registerHD.tag=11401;
    registerHD.DFailed=@selector(downloadFailed:);
    registerHD.DComplete=@selector(downloadComplete:);
    
    //加入接入16wifi网络时CGI调用
    
    NSURL *downLoadUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@?thrid=16wifi&username=%@",FREE114IN,qValue]];
    NSLog(@"durl:%@",downLoadUrl);
    [RootUrl setFreeLogOutReq:nil];
    [registerHD downloadFromUrl:downLoadUrl];
}
-(void)requestFinished:(ASIHTTPRequest *)request{
    if (request.tag==82502) {
        NSString *str=[[NSString alloc]initWithData:_mData encoding:NSUTF8StringEncoding];
        NSRange ranip=[str rangeOfString:@"wlanuserip="];
         NSLog(@"user:%@",str);
        if (ranip.location!=NSNotFound) {
            NSString *userip=[[[[str componentsSeparatedByString:@"wlanuserip="]objectAtIndex:1]componentsSeparatedByString:@"&"]objectAtIndex:0];
            NSLog(@"userip:%@",userip);
            NSString *acip=[[[[str componentsSeparatedByString:@"wlanacip="]objectAtIndex:1]componentsSeparatedByString:@"&"]objectAtIndex:0];
            NSLog(@"acip:%@",acip);
            NSString *usermac=[[[[str componentsSeparatedByString:@"wlanusermac="]objectAtIndex:1]componentsSeparatedByString:@"&"]objectAtIndex:0];
            NSLog(@"usermac:%@",usermac);
            NSUserDefaults *userDef=[NSUserDefaults standardUserDefaults];
            ;
            if (userip.length&&acip.length&&usermac.length) {
                ASIFormDataRequest *formDataRequest = [ASIFormDataRequest requestWithURL:nil];
                
                
                NSString *qValue1=[SecurityUtil encryptAESData:[userDef objectForKey:@"userPhone"] app_key:@"fromthirdboxwifi"];
                
                NSString *qValue=[formDataRequest encodeURL:qValue1];
                
                
                HttpDownload* registerHD=[[HttpDownload alloc]init];
                registerHD.delegate=self;
                registerHD.tag=11401;
                registerHD.DFailed=@selector(downloadFailed:);
                registerHD.DComplete=@selector(downloadComplete:);
                
                //加入接入16wifi网络时CGI调用
                NSString *bodyQ=[NSString stringWithFormat:@"wlanuserip=%@&wlanusermac=%@&wlanacip=%@",userip,usermac,acip];
                NSURL *downLoadUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@?thrid=16wifi&username=%@&%@",FREE114IN,qValue,bodyQ]];
                NSLog(@"durl:%@",downLoadUrl);
                [RootUrl setFreeLogOutReq:bodyQ];
                [registerHD downloadFromUrl:downLoadUrl];
                return;
            }
           
        }
        [self log114NoAcName];
   
        
    }
}
-(void)request:(ASIHTTPRequest *)request didReceiveData:(NSData *)data{
    if (request.tag==82502) {
        [_mData appendData:data];
        
    }

}

#pragma mark 后台之后第一步
- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders{
    
#pragma mark 第二部
    NSString * responseMassage=[request responseStatusMessage];
    if (request.tag==82502) {
        [_mData setLength:0];
        NSLog(@"114portal:%@",responseHeaders);
        NSLog(@"114portal:%@",responseMassage);
    
    }
    if (request.tag==110120) {
        AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
        if ([responseMassage isEqualToString:@"HTTP/1.0 200 OK:Connection=1"]) {
            
            [RootUrl setIsBeiJingHuaWei:YES];
        }else{
            [RootUrl setIsBeiJingHuaWei:NO];
        }
        
        if (isInNetCheck==0) {
            [self chacknetwith:1];
        }
        [app checkChannelsData];
        [app chackCity];
        [request cancel];
    }
    
   
}


-(void)downloadFailed:(HttpDownload *)hd{
    if (hd.tag==88088088) {
#pragma mark  统计事件一上网账号获取失败 bj
        [self showNetOffViewWithWifiId:@"16wifi"];
        AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
        [app setNotice:@"账号获取失败，请点击一键上网重新认证!"];
    }
    if (hd.tag==11401) {
        [self showNetOffViewWithWifiId:@"114 Free"];
        AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
        [app setNotice:@"上线请求超时，请重新请求！（114Free）"];
        NSLog(@"114f:%@",hd.mError);
        
    }
    if (hd.tag==11402) {
        [self showNetOnViewWithWifiId:@"114 Free"];
        AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
        [app setNotice:@"下线请求超时，请重新请求！（114Free）"];
        NSLog(@"114f:%@",hd.mError);
        
    }
    if (hd.tag==92503) {
#pragma mark  统计事件一上网失败 bj
        [self showNetOffViewWithWifiId:@"16wifi"];
        AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
        [app setNotice:@"认证失败，请点击一键上网重新认证!"];
        
        
    }
    
    if (hd.tag==111010) {
#pragma mark  统计事件一上网失败 bj
        NSDictionary *dict = @{@"type" : @"bj_timeout"};
        [MobClick event:@"loginNetFailedBJ" attributes:dict];
        NSUserDefaults *userDef=[NSUserDefaults standardUserDefaults];
        NSString *mobValue=[NSString stringWithFormat:@"bj_timeout_phone:%@_ac:%@",[userDef objectForKey:@"userPhone"],[userDef objectForKey:@"acname"]];
        NSDictionary *dict3 = @{@"type" : mobValue};
        [MobClick event:@"internet_error" attributes:dict3];
        [self showNetOffViewWithWifiId:@"16wifi"];
        AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
        [app setNotice:@"认证失败，请点击一键上网重新认证!"];

    }
    if (hd.tag==222010) {
#pragma mark  统计事件断开 北京
        
        [self showNetOnViewWithWifiId:@"16wifi"];
        AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
        [app setNotice:@"下线请求超时，请重新请求！"];
        
        
    }
    if (hd.tag==8222) {

        
#pragma mark  统计事件断开 通用
            
            [self showNetOnViewWithWifiId:@"16wifi"];
            AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
            [app setNotice:@"下线请求超时，请重新请求！"];
            NSLog(@"通用下线请求失败");

    }
    

    if (hd.tag==8111) {
#pragma mark  统计事件一上网失败 ty
        NSDictionary *dict = @{@"type" : @"ty_timeout"};
        [MobClick event:@"loginNetFailedBJ" attributes:dict];
        NSUserDefaults *userDef=[NSUserDefaults standardUserDefaults];
        NSString *mobValue=[NSString stringWithFormat:@"ty_timeout_phone:%@",[userDef objectForKey:@"userPhone"]];
        NSDictionary *dict3 = @{@"type" : mobValue};
        [MobClick event:@"internet_error" attributes:dict3];
        [self showNetOffViewWithWifiId:@"16wifi"];
        AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
        [app setNotice:@"认证超时，请稍后重试！（TY）"];
    }
    
    
}
-(void)downloadComplete:(HttpDownload *)hd{
    AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    UIButton *fail=(UIButton *)[self.view viewWithTag:1234];
    fail.hidden=YES;
    if (hd.tag==88088088) {
#pragma mark  统计事件一上网账号获取成功bj
        NSError *error = nil;
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:hd.mData options:NSJSONReadingAllowFragments error:&error];
        NSLog(@"登录返回：%@",dic);
        if (error!=nil) {
            NSLog(@"json解析失败12");
        }
        int num=[[dic objectForKey:@"ReturnCode"]intValue];
        if(num==102){
            NSUserDefaults *userDef=[NSUserDefaults standardUserDefaults];
            [userDef setObject:[dic objectForKey:@"acpass"] forKey:@"acpass"];
            [userDef setObject:[dic objectForKey:@"acname"] forKey:@"acname"];
            [userDef synchronize];
            AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
            [app setNotice:@"已获取上网账号，正在认证！"];
            [self getBeiJingPortal];
        }else{
            AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
            [app setNotice:@"账号获取失败，请点击一键上网重新认证!"];
            [self showNetOffViewWithWifiId:@"16wifi"];
        }
    }
    if (hd.tag==11401) {
#pragma mark  统计事件一上网成功 114
        NSString *strrr=[[NSString alloc]initWithData:hd.mData encoding:NSUTF8StringEncoding];
        NSLog(@"114:%@",strrr);
        NSRange ran114=[strrr rangeOfString:@"登录成功"];
        if (ran114.location!=NSNotFound) {
            [MobClick event:@"login_success"];
            [self payCaidou];
            [self showNetOnViewWithWifiId:@"114 Free"];
            [app setNotice:@"认证成功"];
            
            [self.tabBarController setSelectedIndex:2];
        }else{
            NSUserDefaults *userDef=[NSUserDefaults standardUserDefaults];
            NSString *mobValue=[NSString stringWithFormat:@"114free_failed_phone:%@_ac:%@_em:%@",[userDef objectForKey:@"userPhone"],[userDef objectForKey:@"acname"],strrr];
            NSDictionary *dict3 = @{@"type" : mobValue};
            [MobClick event:@"internet_error" attributes:dict3];
            [self showNetOffViewWithWifiId:@"114 Free"];
            [app setNotice:@"认证失败，请稍后重试"];
          
        }
    }
    if (hd.tag==11402) {
        
        NSString *strrr=[[NSString alloc]initWithData:hd.mData encoding:NSUTF8StringEncoding];
        NSLog(@"114下线：%@",strrr);
        NSRange ran114=[strrr rangeOfString:@"下线成功"];
        if (ran114.location!=NSNotFound) {
            [self showNetOffViewWithWifiId:@"114 Free"];
            AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
            [app setNotice:@"已注销网络认证"];
        }else{
            NSUserDefaults *userDef=[NSUserDefaults standardUserDefaults];
            NSString *mobValue=[NSString stringWithFormat:@"114free_Logoutfailed_phone:%@_ac:%@_em:%@",[userDef objectForKey:@"userPhone"],[userDef objectForKey:@"acname"],strrr];
            NSDictionary *dict3 = @{@"type" : mobValue};
            [MobClick event:@"internet_error" attributes:dict3];
            [self showNetOnViewWithWifiId:@"114 Free"];
            AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
            [app setNotice:@"断开网络失败，请重试！"];
            
        }
    }

    if (hd.tag==770770){
        
        NSError *error = nil;
        
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:hd.mData options:NSJSONReadingAllowFragments error:&error];
        NSLog(@"豆豆：%@",dic);
        if (error!=nil) {
            NSLog(@"json解析失败9");
        }
        switch ([[dic objectForKey:@"ReturnCode"]intValue]) {
            case 200:
            {
            if([[dic objectForKey:@"CutCredit"]intValue]>0){
                NSLog(@"ggg");
                    UIImageView *goldBg=[[UIImageView alloc]initWithFrame:CGRectMake(132,SCREENHEIGHT, 56, 56)];
                    goldBg.tag=9090;
                    
                    goldBg.image=[UIImage imageNamed:@"cut_gold_bg.png"];
                    [self.tabBarController.view addSubview:goldBg];
                    UILabel *goldLabel=[[UILabel alloc]initWithFrame:CGRectMake(5,18,43,20)];
                    goldLabel.backgroundColor=[UIColor clearColor];
                    goldLabel.textAlignment=NSTextAlignmentCenter;
                    goldLabel.textColor=[UIColor whiteColor];
                    goldLabel.font=[UIFont boldSystemFontOfSize:17];
                    [goldBg addSubview:goldLabel];
                    goldLabel.text=[NSString stringWithFormat:@"- %@",[dic objectForKey:@"CutCredit"]];
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
                break;
            }
            case 203:
            {
                [self goLogOut];
                UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"" message:@"您的彩豆余额不足！正在断开网络，请前往赚豆获取彩豆！" delegate:self cancelButtonTitle:@"知道了！" otherButtonTitles: nil];
                [alert show];

                break;
            }
            default:
                break;
        }
        
   

 
    }
    if (hd.tag==92503) {
        NSString *str=[[NSString alloc]initWithData:hd.mData encoding:NSUTF8StringEncoding];
        
        [self loginBeiJing2:str];
        return;
    }
    if (hd.tag==111010) {
        [self stopAnimat];
        NSString *str=[[NSString alloc]initWithData:hd.mData encoding:NSUTF8StringEncoding];
        
        NSRange ran=[str rangeOfString:@"您已登录成功"];
        NSRange ran2=[str rangeOfString:@"登录认证失败"];
        if (ran2.location!=NSNotFound) {
#pragma mark  统计事件一上网失败 北京
            
            
            NSString *masErr=[[[[str componentsSeparatedByString:@"登录认证失败，"]lastObject]componentsSeparatedByString:@"';"]objectAtIndex:0 ];
            NSDictionary *dict2 =@{@"type" : masErr};
            [MobClick event:@"loginNetFailedBJ" attributes:dict2];
            NSDictionary *dict = @{@"type" : @"bj_loginfailed"};
            [MobClick event:@"loginNetFailedBJ" attributes:dict];
            
            NSUserDefaults *userDef=[NSUserDefaults standardUserDefaults];
            NSString *mobValue=[NSString stringWithFormat:@"bj_failed_phone:%@_ac:%@_em:%@",[userDef objectForKey:@"userPhone"],[userDef objectForKey:@"acname"],masErr];
            NSDictionary *dict3 = @{@"type" : mobValue};
            [MobClick event:@"internet_error" attributes:dict3];
            [self showNetOffViewWithWifiId:@"16wifi"];
            [app setNotice:[NSString stringWithFormat:@"登录认证失败:%@",masErr]];
            
            
            
        }
        if (ran.location!=NSNotFound) {
            
#pragma mark  统计事件一上网成功 北京
            if (TT) {
                int dd=[[NSDate date]timeIntervalSince1970]-TT;
                NSDictionary *dict = @{@"type" : @"BJOK"};
                [self umengEvent:@"loginTimeBJ" attributes:dict number:@(dd)];
                NSLog(@"%d",dd);
            }
            
            [MobClick event:@"login_success"];
            [RootUrl setUMLogClickFlag:2];
            NSString * date=[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
            [RootUrl setUMLogTimeFlag:date];
            
            [self logOutBeiJing2:str];
            
            [self showNetOnViewWithWifiId:@"16wifi"];
            [self payCaidou];
            [app setNotice:@"认证成功"];
            [self.tabBarController setSelectedIndex:2];
            
        }
        
    }
    if (hd.tag==222010) {
        [self stopAnimat];
        NSString *str=[[NSString alloc]initWithData:hd.mData encoding:NSUTF8StringEncoding];
        NSRange ran=[str rangeOfString:@"下线成功"];
        NSLog(@"北京下线");
        if (ran.location!=NSNotFound) {
#pragma mark  统计事件断开 北京
            
            [self showNetOffViewWithWifiId:@"16wifi"];
            [app setNotice:@"已注销网络认证"];
            
            
        }
        
        
    }
    
    if(hd.tag==8111){
        //通用认证接口认证
        
        NSError *error = nil;
        
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:hd.mData options:NSJSONReadingAllowFragments error:&error];
        if (error!=nil) {
            NSLog(@"json解析失败9");
        }
        NSString *logOutValue=[dic objectForKey:@"login"];
        if (!logOutValue) {
            
#pragma mark  统计事件一上网失败 ty
            NSDictionary *dict = @{@"type" : @"returnnull"};
            [MobClick event:@"loginNetFailedBJ" attributes:dict];
            NSUserDefaults *userDef=[NSUserDefaults standardUserDefaults];
            NSString *mobValue=[NSString stringWithFormat:@"ty_returnnull_phone:%@",[userDef objectForKey:@"userPhone"]];
            NSDictionary *dict3 = @{@"type" : mobValue};
            [MobClick event:@"internet_error" attributes:dict3];
            [self showNetOffViewWithWifiId:@"16wifi"];
            AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
            [app setNotice:@"服务器响应异常，请稍后重试！（TY）"];
            
        }
        
        if ([logOutValue isEqualToString:@"true"]) {
#pragma mark  统计事件一上网成功 通用
            if (TT) {
                int dd=[[NSDate date]timeIntervalSince1970]-TT;
                NSDictionary *dict = @{@"type" : @"TYOK"};
                [self umengEvent:@"loginTimeTY" attributes:dict number:@(dd)];
                NSLog(@"%d",dd);
            }
            [MobClick event:@"login_success"];
            [RootUrl setUMLogClickFlag:2];
            NSString * date=[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
            [RootUrl setUMLogTimeFlag:date];
   
            [self showNetOnViewWithWifiId:@"16wifi"];
            [self payCaidou];
            [app setNotice:@"认证成功"];
            
            [self.tabBarController setSelectedIndex:2];

            
        }
        if ([logOutValue isEqualToString:@"false"]) {
#pragma mark  统计事件一上网失败 通用
            NSLog(@"tt:%@",dic);
            NSDictionary *dict = @{@"type" : @"ty-false"};
            [MobClick event:@"loginNetFailedBJ" attributes:dict];
            NSUserDefaults *userDef=[NSUserDefaults standardUserDefaults];
            NSString *mobValue=[NSString stringWithFormat:@"ty_false_phone:%@",[userDef objectForKey:@"userPhone"]];
            NSDictionary *dict3 = @{@"type" : mobValue};
            [MobClick event:@"internet_error" attributes:dict3];
            [self showNetOffViewWithWifiId:@"16wifi"];
            AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
            [app setNotice:@"认证失败，请稍后重新认证！"];
            
            
        }
        if ([logOutValue isEqualToString:@"off"]) {
#pragma mark  统计事件一上网失败 通用
            NSDictionary *dict = @{@"type" : @"ty-off"};
            [MobClick event:@"loginNetFailedBJ" attributes:dict];
            NSUserDefaults *userDef=[NSUserDefaults standardUserDefaults];
            NSString *mobValue=[NSString stringWithFormat:@"ty_off_phone:%@",[userDef objectForKey:@"userPhone"]];
            NSDictionary *dict3 = @{@"type" : mobValue};
            [MobClick event:@"internet_error" attributes:dict3];
            [self showNetOffViewWithWifiId:@"16wifi"];
            AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
            [app setNotice:@"信号异常，请稍后重新认证！"];
            
            
            
        }
        
    }
    if(hd.tag==8222){
        //        [self stopAnimat];
        NSError *error = nil;
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:hd.mData options:NSJSONReadingAllowFragments error:&error];
        if (error!=nil) {
            NSLog(@"json解析失败9");
        }
        NSString *logOutValue=[dic objectForKey:@"logout"];
        NSLog(@"迈普下线认证：%@",logOutValue);
        if (!logOutValue) {
            
        }
        if ([logOutValue isEqualToString:@"true"]) {
#pragma mark  统计事件断开 通用
            [RootUrl setIsNetOn:NO];
            
            [self showNetOffViewWithWifiId:@"16wifi"];
            AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
            [app setNotice:@"已注销网络认证"];
            
        }
        if ([logOutValue isEqualToString:@"false"]) {
#pragma mark  统计事件断开 通用
            
            [self showNetOnViewWithWifiId:@"16wifi"];
            AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
            [app setNotice:@"断开网络失败，请重试！"];
            
        }
    }
    
    
    

    
    if ((hd.tag/100)==38) {
        
        NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
        NSString * starTimeString=[userDefaults objectForKey:@"welStarTime"];
        switch (hd.tag) {
            case 3801:
            {
                
                UIImage * imim=[UIImage imageWithData:hd.mData];
                NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                [UIImagePNGRepresentation(imim) writeToFile:[documentsDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",starTimeString]] options:NSAtomicWrite error:nil];
                break;
            }
            case 3802:
            {
                
                UIImage * imim=[UIImage imageWithData:hd.mData];
                NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                [UIImagePNGRepresentation(imim) writeToFile:[documentsDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@i5",starTimeString]] options:NSAtomicWrite error:nil];
                break;
            }
                
            default:
                break;
        }
        
    }
    
#pragma mark 修改iOSVersion
    if (hd.tag==1902) {
        
        NSError *error = nil;
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:hd.mData options:NSJSONReadingAllowFragments error:&error];
        if (error!=nil) {
            NSLog(@"json解析失败18");
        }else{
            NSDictionary *infoDictonary=[[NSBundle mainBundle]infoDictionary];
            
            NSString *newVersion=[dict objectForKey:@"iOSInHouseVersion"];
            NSString * appVersion=[infoDictonary objectForKey:@"CFBundleVersion"];
            
            NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
            NSString * starTimeOldString=[userDefaults objectForKey:@"welStarTime"];
            NSString * starTimeNewString=[dict objectForKey:@"begintime"];
            NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSDate *starDateOld=[dateFormatter dateFromString:starTimeOldString];
            NSDate *starDateNew=[dateFormatter dateFromString:starTimeNewString];
            [userDefaults setObject:newVersion forKey:@"ProVersion"];
            
            BOOL ISNEW=[starDateNew timeIntervalSinceReferenceDate]>[starDateOld timeIntervalSinceReferenceDate];
            
            if (ISNEW) {
                NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                NSFileManager *fileManager=[NSFileManager defaultManager];
                NSString *filePath1=[NSString stringWithFormat:@"%@/%@",documentsDirectoryPath,starTimeOldString];
                BOOL file1IsIn= [fileManager fileExistsAtPath:filePath1];
                if (file1IsIn) {
                    //
                    
                    NSError *err;
                    [fileManager removeItemAtPath:filePath1 error:&err];
                }
                NSString *filePath2=[NSString stringWithFormat:@"%@/%@i5",documentsDirectoryPath,starTimeOldString];
                BOOL file2IsIn= [fileManager fileExistsAtPath:filePath2];
                if (file2IsIn) {
                    //
                    NSError *err;
                    [fileManager removeItemAtPath:filePath2 error:&err];
                    
                }
                [userDefaults setObject:starTimeNewString forKey:@"welStarTime"];
                [userDefaults setObject:[dict objectForKey:@"endtime"] forKey:@"welEndTime"];
                [userDefaults synchronize];
                HttpDownload *imagehd2=[[HttpDownload alloc]init];
                imagehd2.tag=3801;
                imagehd2.delegate=self;
                imagehd2.DFailed=@selector(downloadFailed:);
                imagehd2.DComplete=@selector(downloadComplete:);
                [imagehd2 downloadFromUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@/recommend/%@.png",[RootUrl getRootUrl],starTimeNewString]]];
                HttpDownload *imagehd3=[[HttpDownload alloc]init];
                imagehd3.tag=3802;
                imagehd3.delegate=self;
                imagehd3.DFailed=@selector(downloadFailed:);
                imagehd3.DComplete=@selector(downloadComplete:);
                [imagehd3 downloadFromUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@/recommend/%@i5.png",[RootUrl getRootUrl],starTimeNewString]]];
            }
            float v=[appVersion floatValue];//本版本
            float nv=[newVersion floatValue];//请求的新版本
            if ([RootUrl getIsNetOn] ) {
                if (v<nv){
                    UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"更新" message:@"有新的版本更新，是否前往更新？" delegate:self cancelButtonTitle:@"下次再说" otherButtonTitles:@"立即更新", nil] ;
                    [alert show];
                }
            }else{
                if (v<nv) {
                    UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"更新" message:@"有新的版本更新，请在连接公网后更新应用，体验更多精彩内容！" delegate:self cancelButtonTitle:@"知道了！" otherButtonTitles: nil];
                    [alert show];
                }
            }
            
        }
  
    }
}
-(void)loginSuccessWithTag:(int)tag{
    switch (tag) {
            
        case 1:
        {
            ZhuanPanViewController *wvc=[[ZhuanPanViewController alloc]init];
            
            wvc.myRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://clienthtml.16wifi.com/baibaoxiang/index.html?phone=%@&city=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userPhone"],[RootUrl getCity]]]];
            [self presentViewController:wvc animated:YES completion:nil];
        }
            break;
        case 2:
        {
            InviteViewController *ivc=[[InviteViewController alloc]init];
            [self.navigationController pushViewController:ivc animated:YES];
        }
            break;
        case 3:
        {
            AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
            [app setNotice:@"正在认证..."];
            [self goLoginNet];
        }
            break;
        default:
            break;
    }
    
    
}
-(void)checkAppVersion{
    
    HttpDownload *getVersion=[[HttpDownload alloc]init];
    getVersion.delegate=self;
    getVersion.DFailed=@selector(downloadFailed:);
    getVersion.DComplete=@selector(downloadComplete:);
    getVersion.tag=1902;
   
    if ([RootUrl getIsNetOn]) {
         [getVersion downloadFromUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@/recommend/version.json",[RootUrl getRootUrl]]]];
    }else{
        [getVersion downloadFromUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@/recommend/version.json",[RootUrl getContentUrl]]]];
    }
}
-(void)umengEvent:(NSString *)eventId attributes:(NSDictionary *)attributes number:(NSNumber *)number{
    NSString *numberKey = @"__ct__";
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithDictionary:attributes];
    [mutableDictionary setObject:[number stringValue] forKey:numberKey];
    [MobClick event:eventId attributes:mutableDictionary];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

