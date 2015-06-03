//
//  ChannelsViewController.m
//  e-RoadWiFi
//
//  Created by QC on 14-8-1.
//  Copyright (c) 2014年 G.MING. All rights reserved.
//
#import "ChannelsViewController.h"
#import "MobClick.h"
#import "UserShopViewController.h"
#import "VedioViewController.h"
#import "RootUrl.h"
#import "InviteViewController.h"
#import "WebSubPagViewController.h"
#import "VedioViewController.h"
#import "NewsChannelViewController.h"
#import "UIImageView+WebCache.h"
#import "UMFeedbackViewController.h"
#import "HttpManager.h"
#import "HttpRequest.h"
#import "SignInViewController.h"
#import "QeGuideViewController.h"
#import "MyImageView.h"
#import "DownListViewController.h"
#import "GetCMCCIpAdress.h"
#define DEVICE_IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568)
#define SCREENHEIGHT ([[UIScreen mainScreen] bounds].size.height)

#define SIZE ABOUTIOSVERSION ([[[UIDevice currentDevice] systemVersion] floatValue]<7.0?0:20)
#define IOSVERSIONSMALL ([[[UIDevice currentDevice] systemVersion] floatValue]<7.0?20:0)
#define SCALE [[UIScreen mainScreen] scale]

@interface ChannelsViewController ()

@end

@implementation ChannelsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden=YES;
    NumOfList =[[[NSUserDefaults standardUserDefaults] objectForKey:@"IsPass"] boolValue]?6:3;
    if (SYSTEMVERSION>=7) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    SignDateArray=[[NSMutableArray alloc]initWithArray:[def objectForKey:@"SignDate"]];
    FristList=[[NSArray alloc]init];
    SecondList=[[NSArray alloc]init];
    ThridList=[[NSArray alloc]init];
    
    [self creatNav];
    MyScrollView=[[UIScrollView alloc]init];
    MyScrollView.frame=CGRectMake(0, 64, 320, SCREENHEIGHT-64);
    MyScrollView.backgroundColor=[UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1];
    MyScrollView.showsHorizontalScrollIndicator=NO;
    MyScrollView.showsVerticalScrollIndicator=NO;

    [self.view addSubview:MyScrollView];

    
    if([RootUrl getIsNetOn]){
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"hhmmss"];
        
        NSString *LoadUrl=[NSString stringWithFormat:@"mod=checkin&uid=%@&dev=1&ntime=%@&action=gettimes",[def objectForKey:@"userID"],[dateformatter stringFromDate:[NSDate date]]];
        NSData *secretData=[LoadUrl dataUsingEncoding:NSUTF8StringEncoding];
        NSData *qValueData=[secretData AES256EncryptWithKey:SECRETKEY];
        NSString *qValue=[qValueData newStringInBase64FromData];
        
        if ([[def objectForKey:@"isLogin"]integerValue]>=2) {
            [self addTask:[NSString stringWithFormat:@"%@/app_api/userInfo/checkin.html?q=%@",NewBaseUrl,qValue] action:@selector(QdRequest:)];
        }

    }
    [self creatQdView];
    [self creatHeadView];
    [self creatSecondView];
    [self creatBottomView];
    
    MyScrollView.contentSize=CGSizeMake(320, 44*(FristList.count+NumOfList+ThridList.count+1)+70+10*4);
}
-(void)creatNav{
    UIImageView *navView=[[UIImageView alloc]init];
    
    navView.frame=CGRectMake(0, 0, 320, 64);
    navView.image=[UIImage imageNamed:@"gm_nav"];
    navView.userInteractionEnabled=YES;
    [self.view addSubview:navView];
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(120, 20, 80, 44)];
    titleLabel.text=@"赚豆";
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.font=[UIFont systemFontOfSize:20];
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.backgroundColor=[UIColor clearColor];
    [navView addSubview:titleLabel];
    
    UIButton *help=[[UIButton alloc]initWithFrame:CGRectMake(240, 20, 60, 44)];
    help.tag=12103;
    [help addTarget:self action:@selector(HelpBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:help];

    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 12, 60, 20)];
    label.text=@"赚豆攻略";
    label.font=[UIFont systemFontOfSize:15];
    label.textColor=[UIColor whiteColor];
    [help addSubview:label];
    
}

-(void)HelpBtnClick:(UIButton *)button{
    NSDictionary *dict = @{@"type" : @"赚币攻略"};
    [MobClick event:@"channel_select" attributes:dict];
    QeGuideViewController *QVC=[[QeGuideViewController alloc]init];
    QVC.HeadTitle=@"赚豆攻略";
    QVC.Index=button.tag-12100;
    [self.navigationController pushViewController:QVC animated:YES];
    
}

-(void)creatQdView{
    NSArray *titles=@[@"已经连续签到     天",@"签到有奖励，连续签到更多惊喜~"];
    NSArray *headImage=@[@"day"];
    
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 10, SCREENWIDTH, 65)];
    bgView.backgroundColor=[UIColor whiteColor];
    [MyScrollView addSubview:bgView];
    
    UIView *lineView1=[[UIView alloc]initWithFrame:CGRectMake(0,0,320, 0.5)];
    lineView1.backgroundColor=[UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:0.7];
    [bgView addSubview:lineView1];
    
    UIView *lineView3=[[UIView alloc]initWithFrame:CGRectMake(0,65,320, 0.5)];
    lineView3.backgroundColor=[UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:0.7];
    [bgView addSubview:lineView3];
    
        
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0, 10, 320, 65);
    button.tag=2500;
    [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:button];
        
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(50, 2, 170, 20)];
    label.text=titles[0];
    label.font=[UIFont systemFontOfSize:15];
    label.textColor=[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
    [button addSubview:label];
        
    
    UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(50, 25, 210, 20)];
    label1.text=titles[1];
    label1.font=[UIFont systemFontOfSize:12];
    label1.textColor=[UIColor colorWithRed:128/255.0f green:128/255.0f blue:128/255.0f alpha:1];
    [button addSubview:label1];
    
    
    QdTimes=[[UILabel alloc]initWithFrame:CGRectMake(135, 2, 30, 20)];
    QdTimes.text=@"0";
    QdTimes.font=[UIFont systemFontOfSize:20];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"QdTimes"]) {
        
        QdTimes.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"QdTimes"]];
        
    }
    QdTimes.textAlignment=NSTextAlignmentCenter;
    QdTimes.textColor=[UIColor colorWithRed:0 green:172/255.f blue:238/255.f alpha:1.0];
    [button addSubview:QdTimes];
    
    
    UIImageView *head=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 24, 24)];
    head.image=[UIImage imageNamed:headImage[0]];
    [button addSubview:head];
    
    
    
    tipsView=[[MyImageView alloc]initWithFrame:CGRectMake(242, 7, 67, 30)];
    tipsView.image=[[UIImage imageNamed:@"qiandao"]stretchableImageWithLeftCapWidth:15 topCapHeight:5];
    tipsView.userInteractionEnabled=YES;
    [tipsView addTarget:self action:@selector(tipsViewClick:)];
    [button addSubview:tipsView];
    
    tipsLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 5, 67, 20)];
    tipsLabel.textAlignment=NSTextAlignmentCenter;
    tipsLabel.font=[UIFont systemFontOfSize:15];
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    if ([[def objectForKey:@"IsCheck"] integerValue]) {
   
        tipsLabel.text=@"已签到";
        tipsView.image=[[UIImage imageNamed:@"qiandao_d"]stretchableImageWithLeftCapWidth:15 topCapHeight:5];
        tipsLabel.textColor=[UIColor colorWithRed:128/255.0f green:128/255.0f blue:128/255.0f alpha:1];
        tipsView.userInteractionEnabled=NO;
        
    }else{
        tipsLabel.text=@"签到";
        tipsView.image=[[UIImage imageNamed:@"qiandao"]stretchableImageWithLeftCapWidth:15 topCapHeight:5];
        tipsLabel.textColor=[UIColor colorWithRed:0 green:172/255.f blue:238/255.f alpha:1.0];
        tipsView.userInteractionEnabled=YES;

    }
    [tipsView addSubview:tipsLabel];
}
-(void)tipsViewClick:(MyImageView *)QdtipsView{
    NSDictionary *dict = @{@"type" : @"签到_不去签到页"};
    [MobClick event:@"channel_select" attributes:dict];
    
    NSDictionary *dict1 = @{@"type" : @"外部(赚币页)签到"};
    [MobClick event:@"earn_click" attributes:dict1];
    if ([RootUrl getIsNetOn]) {
        
        
        NSUserDefaults * userDefault=[NSUserDefaults standardUserDefaults];
        int isLogin=[[userDefault objectForKey:@"isLogin"]intValue];
        
        if (isLogin<2) {
            LoginViewController *loginCtr=[[LoginViewController alloc]init];
            loginCtr.delegate=self;
            loginCtr.Ltag=6;
            [self presentViewController:loginCtr animated:YES completion:^{
                [loginCtr showNotice:@"请您先登录"];
            }];
        }else{
            NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
            [dateformatter setDateFormat:@"hhmmss"];
            NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
            NSString *LoadUrl=[NSString stringWithFormat:@"mod=checkin&uid=%@&dev=1&ntime=%@",[def objectForKey:@"userID"],[dateformatter stringFromDate:[NSDate date]]];
            NSData *secretData=[LoadUrl dataUsingEncoding:NSUTF8StringEncoding];
            NSData *qValueData=[secretData AES256EncryptWithKey:SECRETKEY];
            NSString *qValue=[qValueData newStringInBase64FromData];
            [self addTask:[NSString stringWithFormat:@"%@//app_api/userInfo/checkin.html?q=%@",NewBaseUrl,qValue] action:@selector(QdSignRequest:)];
            tipsView.userInteractionEnabled=NO;
            tipsLabel.text=@"已签到";
            tipsView.image=[[UIImage imageNamed:@"qiandao_d"]stretchableImageWithLeftCapWidth:15 topCapHeight:5];
            tipsLabel.textColor=[UIColor colorWithRed:128/255.0f green:128/255.0f blue:128/255.0f alpha:1];
            
        }
    }else{
        
        UIAlertView *alterView=[[UIAlertView alloc]initWithTitle:@"" message:@"当前网络不通，请检查网络设置" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [alterView show];
    }
}
-(void)QdSignRequest:(HttpRequest *)request{

    [curTaskDict removeObjectForKey:request.httpUrl];
    
    NSString *str=[[NSString alloc]initWithData:request.downloadData encoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary * sssdic=[NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding]options:NSJSONReadingAllowFragments error:&error];
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    if (error!=nil) {
        NSLog(@"json解析失败144");
        tipsView.userInteractionEnabled=YES;
        
        UIAlertView *alterView=[[UIAlertView alloc]initWithTitle:@"" message:@"网路不给力，签到失败，请重试。" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [alterView show];
        [userDefaults setObject:@"0" forKey:@"IsCheck"];
        [userDefaults synchronize];
        tipsLabel.text=@"签到";
        tipsView.image=[[UIImage imageNamed:@"qiandao"]stretchableImageWithLeftCapWidth:15 topCapHeight:5];
        tipsLabel.textColor=[UIColor colorWithRed:0 green:172/255.f blue:238/255.f alpha:1.0];
        tipsView.userInteractionEnabled=YES;
    }else{
        
        int returnCode=[[sssdic objectForKey:@"ReturnCode"]intValue];
        switch (returnCode) {
            case 102:
            {
                [userDefaults setObject:[sssdic objectForKey:@"times"] forKey:@"QdTimes"];
                [userDefaults setObject:@"1" forKey:@"IsCheck"];
                [userDefaults setObject:@"1" forKey:@"isExitLogin"];
                
                
                tipsLabel.text=@"已签到";
                QdTimes.text=[NSString stringWithFormat:@"%@",[sssdic objectForKey:@"times"]];
                tipsView.image=[[UIImage imageNamed:@"qiandao_d"]stretchableImageWithLeftCapWidth:15 topCapHeight:5];
                tipsLabel.textColor=[UIColor colorWithRed:128/255.0f green:128/255.0f blue:128/255.0f alpha:1];
                tipsView.userInteractionEnabled=NO;
                
                
                //在这判断最后一次签到时间
                NSString *SignDay=@"";
                NSString *SignMonth=@"";
                NSString *SignYear=@"";
                NSDateFormatter* ff = [[NSDateFormatter alloc] init];
                [ff setDateFormat:@"yyyyMMdd"];
                NSString* date = [ff stringFromDate:[NSDate date]];
                SignDay=[NSString stringWithFormat:@"%@",[date substringFromIndex:date.length-2 ]] ;
                SignMonth=[NSString stringWithFormat:@"%@",[date substringWithRange:NSMakeRange(4, 2)]] ;
                SignYear=[NSString stringWithFormat:@"%@",[date substringToIndex:4]];
                [SignDateArray addObject:[NSString stringWithFormat:@"%@%@",[userDefaults objectForKey:@"userID"],date]];
                
                [userDefaults setObject:SignDateArray forKey:@"SignDate"];
                [userDefaults setObject:SignDay forKey:@"SignDay"];
                [userDefaults setObject:SignMonth forKey:@"SignMonth"];
                [userDefaults setObject:SignYear forKey:@"SignYear"];
                [userDefaults synchronize];

                int aaa=[[sssdic objectForKey:@"amount"] intValue];
                if (aaa) {
                    UIImageView *goldBg=[[UIImageView alloc]initWithFrame:CGRectMake(132,SCREENHEIGHT, 56, 56)];
                    goldBg.tag=9090;
                    goldBg.image=[UIImage imageNamed:@"round.png"];
                    [self.view addSubview:goldBg];
                    UILabel *goldLabel=[[UILabel alloc]initWithFrame:CGRectMake(5,18,43,20)];
                    goldLabel.backgroundColor=[UIColor clearColor];
                    goldLabel.textAlignment=NSTextAlignmentCenter;
                    goldLabel.textColor=[UIColor whiteColor];
                    if ([[sssdic objectForKey:@"amount"] integerValue]>=100) {
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
                
                break;
            }
            default:
                break;
        }
    }

    
}
-(void)creatHeadView{

    FristList=@[@"兑换中心",@"幸运抽奖"];
    NSArray *headImage=@[@"gm-change",@"gm-gain"];
    
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 10+75, SCREENWIDTH, 44*FristList.count)];
    bgView.backgroundColor=[UIColor whiteColor];
    [MyScrollView addSubview:bgView];
    
    UIView *lineView1=[[UIView alloc]initWithFrame:CGRectMake(0,0,320, 0.5)];
    lineView1.backgroundColor=[UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:0.7];
    [bgView addSubview:lineView1];
    
    UIView *lineView2=[[UIView alloc]initWithFrame:CGRectMake(10,45,310, 0.5)];
    lineView2.backgroundColor=[UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:0.7];
    [bgView addSubview:lineView2];
    
    UIView *lineView3=[[UIView alloc]initWithFrame:CGRectMake(0,88,320, 0.5)];
    lineView3.backgroundColor=[UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:0.7];
    [bgView addSubview:lineView3];
    
    for (int i=0; i<FristList.count; i++) {
        
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(0, 45*i, 320, 44);
        button.tag=2200+i;
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:button];
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(50, 12, 100, 20)];
        label.text=FristList[i];
        label.font=[UIFont systemFontOfSize:15];
        label.textColor=[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
        [button addSubview:label];
        
        UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(300, 17, 7, 11)];
        image.image=[UIImage imageNamed:@"arrow"];
        [button addSubview:image];
        
        UIImageView *head=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 24, 24)];
        head.image=[UIImage imageNamed:headImage[i]];
        [button addSubview:head];

    }
    
}
-(void)creatSecondView{

    SecondList=@[@"看资讯",@"看视频",@"在线小游戏",@"看小说",@"下游戏",@"装应用"];
    NSArray *headImage=@[@"kanzixun",@"kanshipin",@"play",@"xiaoshuo",@"youxi",@"yingyong"];
    
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 10+44*FristList.count+10+75, SCREENWIDTH, 44*NumOfList)];
    bgView.backgroundColor=[UIColor whiteColor];
    [MyScrollView addSubview:bgView];
    
    UIView *lineView1=[[UIView alloc]initWithFrame:CGRectMake(0,0,320, 0.5)];
    lineView1.backgroundColor=[UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:0.7];
    [bgView addSubview:lineView1];
    for (int i=0; i<NumOfList-1; i++) {
        UIView *lineView2=[[UIView alloc]initWithFrame:CGRectMake(10,44+44*i,310, 0.5)];
        lineView2.backgroundColor=[UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:0.7];
        [bgView addSubview:lineView2];
    }
    UIView *lineView3=[[UIView alloc]initWithFrame:CGRectMake(0,44*NumOfList,320, 0.5)];
    lineView3.backgroundColor=[UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:0.7];
    [bgView addSubview:lineView3];
    
    for (int i=0; i<NumOfList; i++) {
        
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(0, 44*i, 320, 44);
        button.tag=2300+i;
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:button];
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(50, 12, 100, 20)];
        label.text=SecondList[i];
        label.font=[UIFont systemFontOfSize:15];
        label.textColor=[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
        [button addSubview:label];
        
        UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(300, 17, 7, 11)];
        image.image=[UIImage imageNamed:@"arrow"];
        [button addSubview:image];
        
        UIImageView *head=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 24, 24)];
        head.image=[UIImage imageNamed:headImage[i]];
        [button addSubview:head];
        
    }

    
}

-(void)creatBottomView{

    ThridList=@[@"邀请好友",@"问题反馈"];
    NSArray *headImage=@[@"yaoqing",@"fankui"];
    
    NSInteger count;
    
    if (NumOfList==6) {
        count=ThridList.count;
    }else{
        count=ThridList.count-1;
        
    }
    
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 10+44*FristList.count+10+10+44*NumOfList+75, SCREENWIDTH, 44*ThridList.count)];
    bgView.backgroundColor=[UIColor whiteColor];
    [MyScrollView addSubview:bgView];
    
    UIView *lineView1=[[UIView alloc]initWithFrame:CGRectMake(0,0,320, 0.5)];
    lineView1.backgroundColor=[UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:0.7];
    [bgView addSubview:lineView1];
    for (int i=0; i<ThridList.count-1; i++) {
        UIView *lineView2=[[UIView alloc]initWithFrame:CGRectMake(10,45+45*i,310, 0.5)];
        lineView2.backgroundColor=[UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:0.7];
        [bgView addSubview:lineView2];
    }
    UIView *lineView3=[[UIView alloc]initWithFrame:CGRectMake(0,44*ThridList.count,320, 0.5)];
    lineView3.backgroundColor=[UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:0.7];
    [bgView addSubview:lineView3];
    
    for (int i=0; i<ThridList.count; i++) {
        
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(0, 45*i, 320, 44);
        button.tag=2400+i;
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:button];
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(50, 12, 100, 20)];
        label.text=ThridList[i];
        label.font=[UIFont systemFontOfSize:15];
        label.textColor=[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
        [button addSubview:label];
        
        UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(300, 17, 7, 11)];
        image.image=[UIImage imageNamed:@"arrow"];
        [button addSubview:image];
        
        UIImageView *head=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 24, 24)];
        head.image=[UIImage imageNamed:headImage[i]];
        [button addSubview:head];
        
    }
    
}
//
-(void)QdRequest:(HttpRequest *)QdRequest{
    
    [curTaskDict removeObjectForKey:QdRequest.httpUrl];
    
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    NSString *str=[[NSString alloc]initWithData:QdRequest.downloadData encoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary * sssdic=[NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding]options:NSJSONReadingAllowFragments error:&error];
    if (error!=nil) {
        NSLog(@"json解析失败144");
    }else{
        

        int returnCode=[[sssdic objectForKey:@"ReturnCode"]intValue];
        switch (returnCode) {
            case 101:{
            
                
                [userDefaults setObject:@"0" forKey:@"QdTimes"];
                [userDefaults setObject:@"0" forKey:@"IsCheck"];
                [userDefaults setObject:@"1" forKey:@"isExitLogin"];
                [userDefaults synchronize];
                QdTimes.text=@"0";
                tipsLabel.text=@"签到";
                tipsView.image=[[UIImage imageNamed:@"qiandao"]stretchableImageWithLeftCapWidth:15 topCapHeight:5];
                tipsLabel.textColor=[UIColor colorWithRed:0 green:172/255.f blue:238/255.f alpha:1.0];
                tipsView.userInteractionEnabled=YES;
                 break;
            }
            case 102:
            {
                
                [userDefaults setObject:[sssdic objectForKey:@"times"] forKey:@"QdTimes"];
                [userDefaults setObject:[sssdic objectForKey:@"ischeck"] forKey:@"IsCheck"];
                [userDefaults setObject:@"0" forKey:@"isExitLogin"];
                [userDefaults synchronize];

                if ([[sssdic objectForKey:@"ischeck"] integerValue]!=0) {
                    tipsLabel.text=@"已签到";
                    tipsView.image=[[UIImage imageNamed:@"qiandao_d"]stretchableImageWithLeftCapWidth:15 topCapHeight:5];
                    tipsLabel.textColor=[UIColor colorWithRed:128/255.0f green:128/255.0f blue:128/255.0f alpha:1];
                    tipsView.userInteractionEnabled=NO;
                }else{
                
                    tipsLabel.text=@"签到";
                    tipsView.image=[[UIImage imageNamed:@"qiandao"]stretchableImageWithLeftCapWidth:15 topCapHeight:5];
                    tipsLabel.textColor=[UIColor colorWithRed:0 green:172/255.f blue:238/255.f alpha:1.0];
                    tipsView.userInteractionEnabled=YES;
                }
                
                QdTimes.text=[NSString stringWithFormat:@"%@",[sssdic objectForKey:@"times"]];
                break;
            }
            default:
                break;
        }
    }
    

    
        if ([[userDefaults objectForKey:@"IsCheck"] integerValue]) {
//当天已签到
            
            //在这判断最后一次签到时间
            NSString *SignDay=@"";
            NSString *SignMonth=@"";
            NSString *SignYear=@"";

            NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyyMMdd"];
            NSString* date = [formatter stringFromDate:[NSDate date]];
    
            SignDay=[NSString stringWithFormat:@"%@",[date substringFromIndex:date.length-2 ]] ;
            SignMonth=[NSString stringWithFormat:@"%@",[date substringWithRange:NSMakeRange(4, 2)]] ;
            SignYear=[NSString stringWithFormat:@"%@",[date substringToIndex:4]];
            
            [userDefaults setObject:SignDay forKey:@"SignDay"];
            [userDefaults setObject:SignMonth forKey:@"SignMonth"];
            [userDefaults setObject:SignYear forKey:@"SignYear"];
            [userDefaults synchronize];
            
        }else{
//当天为签到
            NSString *SignDay=@"";
            NSString *SignMonth=@"";
            NSString *SignYear=@"";
            
            NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyyMMdd"];
            NSString* date = [formatter stringFromDate:[NSDate dateWithTimeInterval:-24*60*60 sinceDate:[NSDate date]]];
            
            SignDay=[NSString stringWithFormat:@"%@",[date substringFromIndex:date.length-2 ]] ;
            SignMonth=[NSString stringWithFormat:@"%@",[date substringWithRange:NSMakeRange(4, 2)]] ;
            SignYear=[NSString stringWithFormat:@"%@",[date substringToIndex:4]];
            
            [userDefaults setObject:SignDay forKey:@"SignDay"];
            [userDefaults setObject:SignMonth forKey:@"SignMonth"];
            [userDefaults setObject:SignYear forKey:@"SignYear"];
            [userDefaults synchronize];
            
        }
        
//    }

}

-(void)LoginQdRequest:(HttpRequest *)LoginQdRequest{
    
    [curTaskDict removeObjectForKey:LoginQdRequest.httpUrl];
    
    NSString *str=[[NSString alloc]initWithData:LoginQdRequest.downloadData encoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary * sssdic=[NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding]options:NSJSONReadingAllowFragments error:&error];
    if (error!=nil) {
        NSLog(@"json解析失败144");
    }else{
        
        NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
        int returnCode=[[sssdic objectForKey:@"ReturnCode"]intValue];
        switch (returnCode) {
            case 102:
            {
                
                [userDefaults setObject:[sssdic objectForKey:@"times"] forKey:@"QdTimes"];
                [userDefaults setObject:[sssdic objectForKey:@"ischeck"] forKey:@"IsCheck"];
                [userDefaults setObject:@"0" forKey:@"isExitLogin"];
                [userDefaults synchronize];
                
                if ([[sssdic objectForKey:@"ischeck"] integerValue]!=0) {
                    tipsLabel.text=@"已签到";
                    tipsView.image=[[UIImage imageNamed:@"qiandao_d"]stretchableImageWithLeftCapWidth:15 topCapHeight:5];
                    tipsLabel.textColor=[UIColor colorWithRed:128/255.0f green:128/255.0f blue:128/255.0f alpha:1];
                    tipsView.userInteractionEnabled=NO;
                }else{
                    
                    tipsLabel.text=@"签到";
                    tipsView.image=[[UIImage imageNamed:@"qiandao"]stretchableImageWithLeftCapWidth:15 topCapHeight:5];
                    tipsLabel.textColor=[UIColor colorWithRed:0 green:172/255.f blue:238/255.f alpha:1.0];
                    tipsView.userInteractionEnabled=YES;
                }
                
                SignInViewController *sign=[[SignInViewController alloc]init];
                [self.navigationController pushViewController:sign animated:YES];
                
                QdTimes.text=[NSString stringWithFormat:@"%@",[sssdic objectForKey:@"times"]];
                break;
            }
            default:
                break;
        }
    }
}

-(void)btnClick:(UIButton *)button{

    NSLog(@"button.tag:%ld",(long)button.tag);
    
    switch (button.tag-2200) {
        case 0:
        {
            NSDictionary *dict = @{@"type" : @"兑换中心_商城"};
            [MobClick event:@"channel_select" attributes:dict];
            UserShopViewController *userShop=[[UserShopViewController alloc]init];
            NSLog(@"商城");
            [self.navigationController pushViewController:userShop animated:YES];
//            [self.navigationController presentViewController:userShop animated:YES completion:nil];
        }
            break;
        case 1:
        {

            
            NSLog(@"幸运抽奖");
            NSDictionary *dict = @{@"type" : @"幸运抽奖"};
            [MobClick event:@"earn_click" attributes:dict];
            [MobClick event:@"channel_select" attributes:dict];
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
                
                wvc.myRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://clienthtml.16wifi.com/zhuanpan/index.html?phone=%@&city=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userPhone"],[RootUrl getCity]]]];
                [self presentViewController:wvc animated:YES completion:nil];
            }
            
        }
            break;
        case 100:
        {
        
            NSDictionary *dict = @{@"type" : @"看资讯"};
            [MobClick event:@"earn_click" attributes:dict];
            [MobClick event:@"channel_select" attributes:dict];
            NewsChannelViewController *news=[[NewsChannelViewController alloc]init];
            
            [self.navigationController pushViewController:news animated:YES];
        }
            break;
        case 101:
        {
            NSDictionary *dict = @{@"type" : @"看视频"};
            [MobClick event:@"earn_click" attributes:dict];
            [MobClick event:@"channel_select" attributes:dict];
            VedioViewController *vedio=[[VedioViewController alloc]init];
            [self.navigationController pushViewController:vedio animated:YES];
        }
            break;
        case 102:
        {
            NSDictionary *dict = @{@"type" : @"在线小游戏"};
            [MobClick event:@"earn_click" attributes:dict];
            [MobClick event:@"channel_select" attributes:dict];
            NSUserDefaults * userDefault=[NSUserDefaults standardUserDefaults];
            int isLogin=[[userDefault objectForKey:@"isLogin"]intValue];
            
            if (isLogin<2) {
                
                LoginViewController *loginCtr=[[LoginViewController alloc]init];
                loginCtr.delegate=self;
                loginCtr.Ltag=4;
                [self presentViewController:loginCtr animated:YES completion:^{
                    [loginCtr showNotice:@"请您先登录"];
                }];
                
            }else{

            ZhuanPanViewController *subPage=[[ZhuanPanViewController alloc]init];
            [subPage setName:@"在线小游戏"];
            subPage.myRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://clienthtml.16wifi.com/youxi/index.html?phone=%@&city=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userPhone"],[RootUrl getCity]]]];
                
            [self presentViewController:subPage animated:YES completion:^{}];
                
            }
        }
            break;
        case 103:
        {
        
            NSDictionary *dict = @{@"type" : @"看小说"};
            [MobClick event:@"channel_select" attributes:dict];
            [MobClick event:@"earn_click" attributes:dict];
            WebSubPagViewController *subPage=[[WebSubPagViewController alloc]init];
            subPage.isPush=0;
            [subPage setName:@"看小说"];
            subPage.myRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://ks.baidu.com/?v=4&fr=xs_16wif"]];
            [self presentViewController:subPage animated:YES completion:^{}];

        }
            break;
        case 104:
        {
            DownListViewController *dvc=[[DownListViewController alloc]init];
            dvc.HeadTitle=@"游戏下载";
            dvc.IndexTag=@"1";
            dvc.TypeStr=@"GameDown";
            [self.navigationController pushViewController:dvc animated:YES];
        }
            break;
        case 105:
        {
            
            DownListViewController *dvc=[[DownListViewController alloc]init];
            dvc.HeadTitle=@"应用下载";
            dvc.IndexTag=@"0";
            dvc.TypeStr=@"AppDown";
            [self.navigationController pushViewController:dvc animated:YES];
        }
            break;
            
        case 200:
        {
            if (NumOfList==3) {
                
                NSDictionary *dict = @{@"type" : @"问题反馈"};
                [MobClick event:@"earn_click" attributes:dict];
                [MobClick event:@"channel_select" attributes:dict];
                
                [self showNativeFeedbackWithAppkey:UMENG_APPKEY];
                
            }else{
                NSDictionary *dict = @{@"type" : @"邀请好友"};
                [MobClick event:@"earn_click" attributes:dict];
                [MobClick event:@"channel_select" attributes:dict];
                NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
                if ([[def objectForKey:@"isLogin"]integerValue]<2) {
                    
                    LoginViewController *login =[[LoginViewController alloc]init];
                    //设置loginTag为1登录成功后调用代理方法
                    login.delegate=self;
                    login.Ltag=2;
                    [self presentViewController:login animated:YES completion:^{}];
                    
                }else{
                    
                    InviteViewController *ivc=[[InviteViewController alloc]init];
                    [self.navigationController pushViewController:ivc animated:YES];
                    
                }
                
                
            }

            
        }
            break;
        case 201:
        {
            NSDictionary *dict = @{@"type" : @"问题反馈"};
            [MobClick event:@"earn_click" attributes:dict];
            [MobClick event:@"channel_select" attributes:dict];
            
            [self showNativeFeedbackWithAppkey:UMENG_APPKEY];
        }
            break;
            
        case 300:
        {
            NSDictionary *dict = @{@"type" : @"签到_去签到页"};
            [MobClick event:@"channel_select" attributes:dict];
            NSDictionary *dict1 = @{@"type" : @"内部(签到页)签到"};
            [MobClick event:@"earn_click" attributes:dict1];
            NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
            if ([[def objectForKey:@"isLogin"]integerValue]<2) {
                
                LoginViewController *login =[[LoginViewController alloc]init];
                //设置loginTag为1登录成功后调用代理方法
                login.delegate=self;
                login.Ltag=3;
                [self presentViewController:login animated:YES completion:^{}];
            }else{
                //直接到这说明之前已经登录了 viewdidLoad 已经请求到数据
                SignInViewController *sign=[[SignInViewController alloc]init];
                [self.navigationController pushViewController:sign animated:YES];
            }
        }
            break;
        default:
            break;
    }
}
-(void)loginSuccessWithTag:(int)tag{
    switch (tag) {
            
        case 1:
        {
            ZhuanPanViewController *wvc=[[ZhuanPanViewController alloc]init];
            
            wvc.myRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://clienthtml.16wifi.com/zhuanpan/index.html?phone=%@&city=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userPhone"],[RootUrl getCity]]]];
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
            
            NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
            [dateformatter setDateFormat:@"hhmmss"];
            NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
            NSString *LoadUrl=[NSString stringWithFormat:@"mod=checkin&uid=%@&dev=1&ntime=%@&action=gettimes",[def objectForKey:@"userID"],[dateformatter stringFromDate:[NSDate date]]];
            NSData *secretData=[LoadUrl dataUsingEncoding:NSUTF8StringEncoding];
            NSData *qValueData=[secretData AES256EncryptWithKey:SECRETKEY];
            NSString *qValue=[qValueData newStringInBase64FromData];
            if([RootUrl getIsNetOn]||[[GetCMCCIpAdress getSSID]isEqualToString:@"16wifi"]){
            
                [self addTask:[NSString stringWithFormat:@"%@/app_api/userInfo/checkin.html?q=%@",NewBaseUrl,qValue] action:@selector(LoginQdRequest:)];
            
            }

        }
            break;
        case 4:
        {
            
            ZhuanPanViewController *subPage=[[ZhuanPanViewController alloc]init];
            [subPage setName:@"在线小游戏"];
            subPage.myRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://clienthtml.16wifi.com/youxi/index.html?phone=%@&city=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userPhone"],[RootUrl getCity]]]];
            [self presentViewController:subPage animated:YES completion:^{}];
            
        }
            break;
        case 5:
        {
            [self showNativeFeedbackWithAppkey:UMENG_APPKEY];
        }
            break;
        case 6:{
            
            NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
            [dateformatter setDateFormat:@"hhmmss"];
            NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
            NSString *LoadUrl=[NSString stringWithFormat:@"mod=checkin&uid=%@&dev=1&ntime=%@",[def objectForKey:@"userID"],[dateformatter stringFromDate:[NSDate date]]];
            NSData *secretData=[LoadUrl dataUsingEncoding:NSUTF8StringEncoding];
            NSData *qValueData=[secretData AES256EncryptWithKey:SECRETKEY];
            NSString *qValue=[qValueData newStringInBase64FromData];
            if([RootUrl getIsNetOn]||[[GetCMCCIpAdress getSSID]isEqualToString:@"16wifi"]){
                [self addTask:[NSString stringWithFormat:@"%@/app_api/userInfo/checkin.html?q=%@",NewBaseUrl,qValue] action:@selector(QdSignRequest:)];
            }
            tipsView.userInteractionEnabled=NO;
            tipsLabel.text=@"已签到";
            tipsView.image=[[UIImage imageNamed:@"qiandao_d"]stretchableImageWithLeftCapWidth:15 topCapHeight:5];
            tipsLabel.textColor=[UIColor colorWithRed:128/255.0f green:128/255.0f blue:128/255.0f alpha:1];
        }
            break;

        default:
            break;
    }
    
    
}


- (void)showNativeFeedbackWithAppkey:(NSString *)appkey {
    //友盟意见反馈页面
    UMFeedbackViewController *feedbackViewController = [[UMFeedbackViewController alloc] init];
    feedbackViewController.appkey = appkey;
    [self.navigationController presentViewController:feedbackViewController animated:YES completion:nil];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [MobClick endLogPageView:@"channels"];
}
-(void)viewWillAppear:(BOOL)animated{
    
    NumOfList =[[[NSUserDefaults standardUserDefaults] objectForKey:@"IsPass"] boolValue]?6:3;
    
    if ([RootUrl getUMLogClickFlag]) {
        NSDictionary *dict2 = @{@"type" : @"inchannels"};
        [MobClick event:@"loginNet_isRun" attributes:dict2];
        [RootUrl setUMLogClickFlag:0];
        
    }
    
    [MobClick beginLogPageView:@"channels"];

    if([RootUrl getIsNetOn]){
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"hhmmss"];
        NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
        NSString *LoadUrl=[NSString stringWithFormat:@"mod=checkin&uid=%@&dev=1&ntime=%@&action=gettimes",[def objectForKey:@"userID"],[dateformatter stringFromDate:[NSDate date]]];
        NSData *secretData=[LoadUrl dataUsingEncoding:NSUTF8StringEncoding];
        NSData *qValueData=[secretData AES256EncryptWithKey:SECRETKEY];
        NSString *qValue=[qValueData newStringInBase64FromData];
        
        if ([[def objectForKey:@"isExitLogin"]isEqualToString:@"1"]) {
            
            [self addTask:[NSString stringWithFormat:@"%@/app_api/userInfo/checkin.html?q=%@",NewBaseUrl,qValue] action:@selector(QdRequest:)];
            
        }
        

    }
    self.navigationController.navigationBar.hidden=YES;
    [self.tabBarController.tabBar setHidden:NO];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
