//
//  LoginViewController.m
//  e路WiFi
//
//  Created by JAY on 14-1-15.
//  Copyright (c) 2014年 HE ZHENJIE. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "ForgetPasswordViewController.h"
#import "AppDelegate.h"
#import "GetCMCCIpAdress.h"
#import "MobClick.h"
#define SYSTEMVERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define IOSVERSIONSMALL ([[[UIDevice currentDevice] systemVersion] floatValue]<7.0?20:0)
#define DEVICE_IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568)
#define SCREENHEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SIZEFORLOGNAV ([[[UIDevice currentDevice] systemVersion] floatValue]<7.0?(-20):0)
#define SECRETKEY @"ilovewififorfree"
#define IsIPhone4 (([[UIScreen mainScreen] bounds].size.height <568)?0:60)
@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize delegate,Ltag;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (BOOL)shouldAutorotate
{
    return NO;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
-(void)viewWillDisappear:(BOOL)animated
{
    if (loginDownloadFlag) {
        [loginHd cancel];
    }
    [MobClick endLogPageView:@"LoginIn"];
}
-(void)viewWillAppear:(BOOL)animated
{

    [MobClick beginLogPageView:@"LoginIn"];
   
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    loginDownloadFlag=0;
   
    BgScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, SCREENHEIGHT)];
    BgScrollView.backgroundColor=[UIColor clearColor];
    BgScrollView.tag=1110;
    BgScrollView.contentSize=CGSizeMake(SCREENWIDTH, (([[UIScreen mainScreen] bounds].size.height <568)?508:SCREENWIDTH));
    [self.view addSubview:BgScrollView];
   
    UIImageView *navView=[[UIImageView alloc]initWithFrame:CGRectMake(0, SIZEFORLOGNAV, 320, 64)];
    navView.image=[UIImage imageNamed:@"gm_nav"];
    navView.userInteractionEnabled=YES;
    [self.view addSubview:navView];
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(70, 20, 180, 44)];
    label.text=@"登录";
    label.backgroundColor=[UIColor clearColor];
    label.textAlignment =NSTextAlignmentCenter;
    label.font=[UIFont systemFontOfSize:20];
    label.textColor=[UIColor whiteColor];
    [navView addSubview:label];
    [self.view setBackgroundColor:[UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1.f]];
    
    MyButton *back=[MyButton buttonWithType:UIButtonTypeCustom];
    back.frame=CGRectMake(0, 20+SIZEFORLOGNAV, 50, 44);
    [back setNormalImage:[UIImage imageNamed:@"newBack"]];
    
    [back addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
    UIImageView *logoImage=[[UIImageView alloc]initWithFrame:CGRectMake(134, 30+64, 52, 57)];
    logoImage.image=[UIImage imageNamed:@"login-logo.png"];
    [BgScrollView addSubview:logoImage];
    
    UIView *textBg=[[UIView alloc]initWithFrame:CGRectMake(0, 120+64, 320, 90)];
    textBg.backgroundColor=[UIColor whiteColor];
    [BgScrollView addSubview:textBg];
    
    NSArray *images=@[@"iphone_icon",@"mima_icon"];
    
    for (int i=0; i<2; i++) {
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 90*i, 320, 0.5)];
        lineView.backgroundColor=[UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:0.8];
        [textBg addSubview:lineView];
        
        UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(10, 12+45*i, 18, 21)];
        image.image=[UIImage imageNamed:images[i]];
        [textBg addSubview:image];
        
    }

    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(10, 45, 310, 0.5)];
    lineView.backgroundColor=[UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:0.8];
    [textBg addSubview:lineView];
    
    numberTextfield=[[MHTextField alloc]initWithFrame:CGRectMake(10+30,120+64+10, 270,24)];
    [numberTextfield setKeyboardType:UIKeyboardTypePhonePad];
    numberTextfield.clearButtonMode=UITextFieldViewModeWhileEditing;
    [numberTextfield setPlaceholder:@"手机号 (首次使用,请先注册)"];
    numberTextfield.autocapitalizationType=NO;
    numberTextfield.autocorrectionType=NO;
    numberTextfield.textColor=[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
    numberTextfield.font=[UIFont systemFontOfSize:15];
    [BgScrollView addSubview:numberTextfield];
    
    passwordTextfield=[[MHTextField alloc]initWithFrame:CGRectMake(10+30,120+64+55, 270,24)];
    [passwordTextfield setKeyboardType:UIKeyboardTypeASCIICapable];
    passwordTextfield.autocapitalizationType=NO;
    passwordTextfield.autocorrectionType=NO;
    passwordTextfield.secureTextEntry=YES;
    passwordTextfield.textColor=[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
    passwordTextfield.clearButtonMode=UITextFieldViewModeWhileEditing;
    [passwordTextfield setPlaceholder:@"密码 (6-16位)"];
    passwordTextfield.font=[UIFont systemFontOfSize:15];
    [BgScrollView addSubview:passwordTextfield];
    
    [numberTextfield setup];
    [passwordTextfield setup];
    
    MyButton * logoButton=[MyButton buttonWithType:UIButtonTypeCustom];
    [logoButton setFrame:CGRectMake(10, 225+60, 300, 45)];
    [logoButton setNormalBackgroundImage:[[UIImage imageNamed:@"loginbut"]stretchableImageWithLeftCapWidth:10 topCapHeight:10]];
    [logoButton setHighlightedBackgroundImage:[[UIImage imageNamed:@"loginbut_d"]stretchableImageWithLeftCapWidth:10 topCapHeight:10]];
    [logoButton setNTitle:@"登录"];
    [logoButton setNTitleColor:[UIColor whiteColor]];
    [logoButton setTitleColor:[UIColor colorWithRed:255/255.f green:255/255.f blue:255/255.f alpha:0.3] forState:UIControlStateHighlighted];
    [logoButton.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [logoButton addTarget:self action:@selector(logoIn)];
    [BgScrollView addSubview:logoButton];
    
    
    fogetPassword=[MyButton buttonWithType:UIButtonTypeCustom];
    [fogetPassword setFrame:CGRectMake(237,270+64,80, 20)];
    [fogetPassword setNTitle:@"忘记密码？"];
    [fogetPassword setNTitleColor:[UIColor colorWithRed:0/255.f green:172/255.f blue:238/255.f alpha:1.0]];
    [fogetPassword setTitleColor:[UIColor colorWithRed:0/255.f green:172/255.f blue:238/255.f alpha:0.6] forState:UIControlStateHighlighted];
    [fogetPassword.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [fogetPassword addTarget:self action:@selector(goGetPassword)];
    [BgScrollView addSubview:fogetPassword];
    
    
    registerButton=[MyButton buttonWithType:UIButtonTypeCustom];
    [registerButton setFrame:CGRectMake(267, 20+SIZEFORLOGNAV, 50, 44)];
    [registerButton setNTitleColor:[UIColor colorWithRed:255/255.f green:255/255.f blue:255/255.f alpha:1.0]];
    [registerButton setTitleColor:[UIColor colorWithRed:255/255.f green:255/255.f blue:255/255.f alpha:0.6] forState:UIControlStateHighlighted];
    [registerButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [registerButton setNTitle:@"注册"];
    [registerButton addTarget:self action:@selector(goRegister)];
    [self.view addSubview:registerButton];
    
    noticeLabel=[[UILabel alloc]initWithFrame:CGRectMake(60, SCREENHEIGHT-130, 200, 26)];
    noticeLabel.layer.cornerRadius=5.f;
    noticeLabel.layer.masksToBounds=YES;
    noticeLabel.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    noticeLabel.textAlignment=NSTextAlignmentCenter;
    noticeLabel.font=[UIFont systemFontOfSize:13];
    noticeLabel.textColor=[UIColor whiteColor];
    [noticeLabel setHidden:YES];
    [self.view addSubview:noticeLabel];
    
    
    UILabel *tipsTitle=[[UILabel alloc]initWithFrame:CGRectMake(10, SCREENHEIGHT-130-IsIPhone4, 300, 20)];
    tipsTitle.text=@"登录说明";
    tipsTitle.backgroundColor=[UIColor clearColor];
    tipsTitle.textAlignment =NSTextAlignmentLeft;
    tipsTitle.font=[UIFont systemFontOfSize:15];
    [BgScrollView addSubview:tipsTitle];

    UILabel *tips=[[UILabel alloc]initWithFrame:CGRectMake(10, SCREENHEIGHT-110-IsIPhone4, 300, 70)];
    tips.text=@"1、一键上网前请先保持登录状态\n2、16WiFi环境下如果登录失败,请先开启蜂窝登录,然后再一键上网,成功率会更高\n3、只需登录一次,无需每天登录";
    tips.backgroundColor=[UIColor clearColor];
    tips.textAlignment =NSTextAlignmentLeft;
    tips.numberOfLines=0;
    tips.textColor=[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:0.6];
    tips.font=[UIFont systemFontOfSize:13];
    [BgScrollView addSubview:tips];
    
    [self CreatWXLoginBut];
    [self buildLoadingAnimat];
    // Do any additional setup after loading the view.
}
-(void)CreatWXLoginBut{

    if ([WXApi isWXAppInstalled]) {
        
        MyButton * WXLoginBut=[MyButton buttonWithType:UIButtonTypeCustom];
        [WXLoginBut setFrame:CGRectMake(72, SCREENHEIGHT-30-IsIPhone4, 175, 40)];
        [WXLoginBut setNormalBackgroundImage:[[UIImage imageNamed:@"but_wenxin"]stretchableImageWithLeftCapWidth:10 topCapHeight:10]];
        [WXLoginBut setHighlightedBackgroundImage:[[UIImage imageNamed:@"but_wenxin_d"]stretchableImageWithLeftCapWidth:10 topCapHeight:10]];
        [WXLoginBut setNTitle:@"微信登录"];
        [WXLoginBut setNTitleColor:[UIColor blackColor]];
        [WXLoginBut setTitleColor:[UIColor colorWithRed:255/255.f green:255/255.f blue:255/255.f alpha:0.3] forState:UIControlStateHighlighted];
        [WXLoginBut.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [WXLoginBut addTarget:self action:@selector(WXlogoIn)];
        [BgScrollView addSubview:WXLoginBut];
        
        UIImageView *icon=[[UIImageView alloc]initWithFrame:CGRectMake(15, 9, 21, 21)];
        icon.image=[UIImage imageNamed:@"icon_wenxin"];
        [WXLoginBut addSubview:icon];
        
    }else{
    
        
    }
    
}
-(void)WXlogoIn{

    AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    app.IsLogin=YES;
    [app sendAuthRequest];
    app.WXLogin=self;
    
}
-(void)backButtonClick{
    [self dismissViewControllerAnimated:YES completion:^{}];
    
}

-(void)goGetPassword{
    ForgetPasswordViewController * registerCtr=[[ForgetPasswordViewController alloc]init];
    registerCtr.login=self;
    [self presentViewController:registerCtr animated:YES completion:^{}];
}
-(void)goRegister{
    RegisterViewController * registerCtr=[[RegisterViewController alloc]init];
    registerCtr.login=self;
    registerCtr.RegisterType=1;
    [self presentViewController:registerCtr animated:YES completion:^{}];
}
-(void)logoIn{
    
    if ([numberTextfield isFirstResponder]) {
        [numberTextfield doneButtonIsClicked:nil];
    }
    if ([passwordTextfield isFirstResponder]) {
        [passwordTextfield doneButtonIsClicked:nil];
    }
    BOOL phoneNumberCheck0=numberTextfield.text.length==0;
 
    BOOL passwordCheck0=passwordTextfield.text.length==0;
    BOOL passwordCheck6=passwordTextfield.text.length<6;
    if (phoneNumberCheck0) {
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"请输入您的手机号码！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }else{
     
        BOOL phoneNumberCheck11=numberTextfield.text.length!=11;
        BOOL phoneNumberCheck1=[numberTextfield.text characterAtIndex:0]!='1';
        
        if(phoneNumberCheck1){
          
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"您输入正确的手机号码！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
            numberTextfield.text=@"";
            return;
        }else if(phoneNumberCheck11){
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"您输入正确的手机号码！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
            numberTextfield.text=@"";
            return;
        }

    }
    if(passwordCheck0){
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"" message:@"请输入登录密码！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }else if(passwordCheck6){
        //密码不足6位 请重新设置
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"" message:@"您输入密码不足6位，请重新输入" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        passwordTextfield.text=@"";
        return;
    }
    
    
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
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
    
    NSString *QString=[NSString stringWithFormat:@"mod=logintest&phone=%@&pass=%@&apmac=%@&mac=%@&city=%@&dev=1&model=%@&vname=%@&ntime=%@",numberTextfield.text,passwordTextfield.text,[GetCMCCIpAdress getBSSIDStandard],[RootUrl getIDFA],[def objectForKey:@"city"],[AppDelegate deviceString],[NSString stringWithFormat:@"%@_%d",Vname,[[def objectForKey:@"ProVersion"] intValue]*100],[dateformatter stringFromDate:[NSDate date]]];
    
    NSLog(@"登录%@",QString);
    
    NSData *secretData=[QString dataUsingEncoding:NSUTF8StringEncoding];
    NSData *qValueData=[secretData AES256EncryptWithKey:SECRETKEY];
    NSString *qValue=[qValueData newStringInBase64FromData];
    loginHd=[[HttpDownload alloc]init];
    loginHd.delegate=self;
    loginHd.tag=3333;
    loginHd.DFailed=@selector(downloadFailed:);
    loginHd.DComplete=@selector(downloadComplete:);

    //加入接入16wifi网络时CGI调用
    
    NSURL *downLoadUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@/app_api/userAccount/login.html?q=%@",NewBaseUrl,qValue]];
      if([RootUrl getIsNetOn]||[[GetCMCCIpAdress getSSID]isEqualToString:@"16wifi"]){
          [loginHd downloadFromUrl:downLoadUrl andWithTimeoutInterval:5];
              [self startAnimat];
      }else{
          UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"" message:@"当前网络不通，请切换后登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
          [alertView show];
          
      }
    loginDownloadFlag=1;
 
}
-(void)buildLoadingAnimat{
    aniBg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 77, 77)];
    aniBg.image=[UIImage imageNamed:@"jiazaibg"];
    NSArray *imageArray=[NSArray arrayWithObjects:[UIImage imageNamed:@"tu1"],[UIImage imageNamed:@"tu2"],[UIImage imageNamed:@"tu3"],[UIImage imageNamed:@"tu4"], nil];
    loadingAni=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 77, 77)];
    loadingAni.image=[UIImage imageNamed:@"tu1"];
    loadingAni.animationImages =imageArray;
    
    loadingAni.animationDuration = [loadingAni.animationImages count] * 1/5.0;
    loadingAni.animationRepeatCount = 100000;
    flag=0;
 
    loadingAni.center=aniBg.center;
    [aniBg addSubview:loadingAni];
    aniBg.center=CGPointMake(self.view.center.x, self.view.center.y-40);
    [self.view addSubview:aniBg];
    [aniBg setHidden:YES];
}
-(void)startAnimat{
    [aniBg setHidden:NO];
    loadingAni.animationRepeatCount = 100000;
    flag=1;
    [NSTimer scheduledTimerWithTimeInterval:50 target:self selector:@selector(stopAnimat) userInfo:nil repeats:NO];
    [loadingAni startAnimating];
}
-(void)stopAnimat{
    [aniBg setHidden:YES];
    flag=0;
    [loadingAni stopAnimating];
}
#pragma mark java登录后保存个人信息
-(void)downloadComplete:(HttpDownload *)hd{
    
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    
    if (hd.tag==10030) {
        
        NSError *error = nil;
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:hd.mData options:NSJSONReadingAllowFragments error:&error];
        if (error!=nil) {
            NSLog(@"json解析失败12");
        }else{
            NSNumber *num=[dic objectForKey:@"ReturnCode"];
            if([num intValue]==102){
                NSLog(@"上传token成功");
                [userDefaults setObject:@"1" forKey:@"PushToken"];
                [userDefaults synchronize];
            }else{
                NSLog(@"returnCode:%@",[dic objectForKey:@"ReturnCode"]);
                [userDefaults setObject:@"0" forKey:@"PushToken"];
                [userDefaults synchronize];
                
            }
        
        }
        
    }
    if (hd.tag==3333) {
        NSLog(@"请求完成");
        [self stopAnimat];
        loginDownloadFlag=0;
        
        NSError *error = nil;
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:hd.mData options:NSJSONReadingAllowFragments error:&error];
         NSLog(@"登录返回：%@",dic);
        if (error!=nil) {
            NSLog(@"json解析失败12");
        }else{
            NSNumber *num=[dic objectForKey:@"ReturnCode"];
            
            switch ([num intValue]) {
#pragma mark  登录成功
                    
                case 102:
                {
                   
        
                    [userDefaults setObject:@"2" forKey:@"isLogin"];
                    [userDefaults setObject:numberTextfield.text forKey:@"userPhone"];
                    [userDefaults setObject:passwordTextfield.text forKey:@"userPassword"];
                    [userDefaults setObject:[dic objectForKey:@"uid"] forKey:@"userID"];
                    //                [userDefaults setObject:[dic objectForKey:@"token"] forKey:@"token"];
                    [userDefaults setObject:[dic objectForKey:@"acpass"] forKey:@"acpass"];
                    [userDefaults setObject:[dic objectForKey:@"acname"] forKey:@"acname"];
                    [userDefaults setObject:@"0" forKey:@"LoginType"];
                    [userDefaults setObject:@"1" forKey:@"isExitLogin"];
                    [userDefaults synchronize];
                    [self showSuccessNotice:@"登录成功！"];
                  

                    [self pushToken];
                    
                    break;
                }
                case 103:{
                
                    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"" message:@"您输入的号码与密码不匹配！请重新输入！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alertView show];
                     numberTextfield.text=@"";
                    passwordTextfield.text=@"";
                    break;
                    
                }
                case 106:
                {
                    
                    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"" message:@"密码错误！请重新输入！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alertView show];
                    passwordTextfield.text=@"";
                    break;
                    
                    
                }
                case 107:
                {
                    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"" message:@"您输入的号码错误或不存在！请重新输入！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alertView show];
                    numberTextfield.text=@"";
                    passwordTextfield.text=@"";
                    break;
                    
                }
                default:
                    break;
            }
            

        }
}
    if (hd.tag==10040) {
        
        NSError *error;
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:hd.mData options:NSJSONReadingMutableContainers error:&error];
        NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
        
        NSLog(@"InvitePin%@",[dict objectForKey:@"InvitePin"]);
        
        if (dict) {
            [def setObject:[dict objectForKey:@"InvitePin"] forKey:@"InvitePin"];
            [def setObject:[dict objectForKey:@"data"] forKey:@"InviteData"];
            [def synchronize];
        }else{
            
            NSLog(@"error description:%@",[error description]);
        }
        
        
    }

    
}
-(void)getRecommendCode{
    
    //这里请求邀请码相关
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"hhmmss"];
    NSString *QString2=[NSString stringWithFormat:@"mod=friend&operation=myinvite&uid=%@&ntime=%@",[def objectForKey:@"userID"],[dateformatter stringFromDate:[NSDate date]]];
    NSData *secretData2=[QString2 dataUsingEncoding:NSUTF8StringEncoding];
    NSData *qValueData2=[secretData2 AES256EncryptWithKey:SECRETKEY];
    NSString *qValue2=[qValueData2 newStringInBase64FromData];
    HttpDownload *recommendCode=[[HttpDownload alloc]init];
    recommendCode.tag=10040;
    recommendCode.delegate=self;
    recommendCode.DFailed=@selector(downloadFailed:);
    recommendCode.DComplete=@selector(downloadComplete:);
    [recommendCode downloadFromUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@/app_api/userInfo/getMyFriendList.html?q=%@",NewBaseUrl,qValue2]]];
}


-(void)pushToken{
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"hhmmss"];
    
    NSString *token=[NSString stringWithFormat:@"%@",[def objectForKey:@"token"]];
    NSLog(@"***************%@",token);
    NSString *QString=[NSString stringWithFormat:@"uid=%@&token=%@&ntime=%@",[def objectForKey:@"userID"],token,[dateformatter stringFromDate:[NSDate date]]];
    NSString *MD5=[RootUrl md5:QString];
    
    HttpDownload *pushtoken=[[HttpDownload alloc]init];
    pushtoken.tag=10030;
    pushtoken.delegate=self;
    pushtoken.DFailed=@selector(downloadFailed:);
    pushtoken.DComplete=@selector(downloadComplete:);
    [self startAnimat];
    //加入接入16wifi网络时CGI调用
    NSString *LoadUrl=[NSString stringWithFormat:@"mod=setpushtoken&uid=%@&token=%@&ntime=%@&sign=%@&dev=1&city=%@",[def objectForKey:@"userID"],[def objectForKey:@"token"],[dateformatter stringFromDate:[NSDate date]],MD5,[def objectForKey:@"city"]];
    
    NSData *secretData=[LoadUrl dataUsingEncoding:NSUTF8StringEncoding];
    NSData *qValueData=[secretData AES256EncryptWithKey:SECRETKEY];
    NSString *qValue=[qValueData newStringInBase64FromData];
    
    NSURL *downLoadUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@/app_api/userInfo/setpushtoken.html?q=%@",NewBaseUrl,qValue]];
     if([RootUrl getIsNetOn]||[[GetCMCCIpAdress getSSID]isEqualToString:@"16wifi"]){
         [pushtoken downloadFromUrl:downLoadUrl];
     }else{
         [def setObject:@"0" forKey:@"PushToken"];
         [def synchronize];
     }
}

-(void)downloadFailed:(HttpDownload *)hd{
    [self stopAnimat];
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    if (hd.tag==10030) {
        NSLog(@"pushtoken 上传失败");
        [def setObject:@"0" forKey:@"PushToken"];
        [def synchronize];
        
    }else{
        loginDownloadFlag=0;
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"" message:@"登录失败！请稍后重新获取！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
}
-(void)showSuccessNotice:(NSString*)str{
    
    NSUserDefaults * def =[NSUserDefaults standardUserDefaults];
    [def setObject:@"2" forKey:@"isLogin"];
    [def synchronize];
    
    [self getRecommendCode];
    
    [noticeLabel setHidden:NO];
    
    CGSize maxSize=CGSizeMake(250,20);
//    CGSize realSize=[str sizeWithFont:noticeLabel.font constrainedToSize:maxSize lineBreakMode:NSLineBreakByCharWrapping];
    CGSize realSize=[str boundingRectWithSize:maxSize  options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:noticeLabel.font} context:nil].size;
    noticeLabel.frame=CGRectMake((310-realSize.width)/2, SCREENHEIGHT-130,realSize.width+10, 26);
    noticeLabel.text=str;
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setHidNoticeAndBack) userInfo:nil repeats:NO];
    
}
-(void)setHidNoticeAndBack{
    [noticeLabel setHidden:YES];
        [self dismissViewControllerAnimated:NO completion:^{
          
            [self.delegate loginSuccessWithTag:Ltag];
        }];

    
}


- (BOOL)validateInputInView:(UIView*)view
{
    for(UIView *subView in view.subviews){
        if ([subView isKindOfClass:[UIScrollView class]])
            return [self validateInputInView:subView];
        
        if ([subView isKindOfClass:[MHTextField class]]){
            if (![(MHTextField*)subView validate]){
                return NO;
            }
        }
    }
    
    return YES;
}
-(void)showNotice:(NSString*)str{
    NSLog(@"显示通知aaaa");
    [noticeLabel setHidden:NO];
    
    CGSize maxSize=CGSizeMake(250,20);
//    CGSize realSize=[str sizeWithFont:noticeLabel.font constrainedToSize:maxSize lineBreakMode:NSLineBreakByCharWrapping];
    CGSize realSize=[str boundingRectWithSize:maxSize  options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:noticeLabel.font} context:nil].size;
    noticeLabel.frame=CGRectMake((310-realSize.width)/2, SCREENHEIGHT-130,realSize.width+10, 26);
    noticeLabel.text=str;
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(setHidNotice) userInfo:nil repeats:NO];
    
    
}
-(void)setHidNotice{
    [noticeLabel setHidden:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
