//
//  RegisterViewController.m
//  e路WiFi
//
//  Created by JAY on 2/18/14.
//  Copyright (c) 2014 HE ZHENJIE. All rights reserved.
//

#import "RegisterViewController.h"
#import "WebSubPagViewController.h"
#import "RootUrl.h"
#import "ForgetPasswordViewController.h"
#import "MyDatabase.h"
#import "cityItem.h"
#import "CityListViewController.h"
#import "AppDelegate.h"
#import "GetCMCCIpAdress.h"

#define SYSTEMVERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define IOSVERSIONSMALL ([[[UIDevice currentDevice] systemVersion] floatValue]<7.0?20:0)
#define DEVICE_IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568)
#define SCREENHEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SIZEFORLOGNAV ([[[UIDevice currentDevice] systemVersion] floatValue]<7.0?(-20):0)
#define SECRETKEY @"ilovewififorfree"

@interface RegisterViewController ()

@end

@implementation RegisterViewController
@synthesize login;
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
- (void)viewDidLoad
{
    [super viewDidLoad];
    httpDownloadFlag=0;
    registerFlag=0;
    myTimerFlag=0;
    
    UIImageView *navView=[[UIImageView alloc]initWithFrame:CGRectMake(0, SIZEFORLOGNAV, 320, 64)];
    navView.image=[UIImage imageNamed:@"gm_nav"];
    navView.userInteractionEnabled=YES;
    [self.view addSubview:navView];
    title=[[UILabel alloc]initWithFrame:CGRectMake(70, 20, 180, 44)];
    title.text=@"注册";
    title.textAlignment =NSTextAlignmentCenter;
    title.backgroundColor=[UIColor clearColor];
    title.font=[UIFont systemFontOfSize:20];
    title.textColor=[UIColor whiteColor];
    [navView addSubview:title];
    
    MyButton *back=[MyButton buttonWithType:UIButtonTypeCustom];
    back.frame=CGRectMake(0, 20, 50, 44);
    [back setNormalImage:[UIImage imageNamed:@"newBack"]];
    [back addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:back];
    [self.view setBackgroundColor:[UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1.f]];
    
    [self inputPhoneNumAndPW];

    [self setCityAndInvite];
    
    [self buildLoadingAnimat];
    
	// Do any additional setup after loading the view.
}
#pragma mark 输入注册手机号码
-(void)inputPhoneNumAndPW{

    getInforView=[[UIView alloc]initWithFrame:CGRectMake(0, 64, 320, SCREENHEIGHT-64-IOSVERSIONSMALL)];
    getInforView.backgroundColor=[UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1.f];
    [self.view addSubview:getInforView];
    
    UIView *textBg=[[UIView alloc]initWithFrame:CGRectMake(0, 10, 320, 45*3)];
    textBg.backgroundColor=[UIColor whiteColor];
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 0.5)];
    lineView.backgroundColor=[UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:0.8];
    [textBg addSubview:lineView];
    
    for (int i=0; i<2; i++) {
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(10, 45+45*i, 310, 0.5)];
        lineView.backgroundColor=[UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:0.8];
        [textBg addSubview:lineView];
    }
    
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, 45*3, 320, 0.5)];
    line.backgroundColor=[UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:0.8];
    [textBg addSubview:line];
    [getInforView addSubview:textBg];
    
    NSArray *images=@[@"iphone_icon",@"lianjie_icon",@"mima_icon"];
    for (int j=0; j<3; j++) {
        
        UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(10, 12+45*j, 18, 21)];
        image.image=[UIImage imageNamed:images[j]];
        [textBg addSubview:image];

        
    }
    
    UIScrollView *scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 10, 320, 45*3)];
    scrollView.backgroundColor=[UIColor clearColor];
    scrollView.tag=1110;
    [getInforView addSubview:scrollView];
    
    numberTextfield=[[MHTextField alloc]initWithFrame:CGRectMake(10+30,10, 270,24)];
    [numberTextfield setKeyboardType:UIKeyboardTypePhonePad];
    numberTextfield.font=[UIFont systemFontOfSize:15];
    numberTextfield.clearButtonMode=UITextFieldViewModeWhileEditing;
    [numberTextfield setPlaceholder:@"请输入手机号"];
    [scrollView addSubview:numberTextfield];
    
    
    getSecurityCodeButton=[MyButton buttonWithType:UIButtonTypeCustom];
    [getSecurityCodeButton setFrame:CGRectMake(240, 17, 70, 30)];
    [getSecurityCodeButton setNormalBackgroundImage:[[UIImage imageNamed:@"loginbut"]stretchableImageWithLeftCapWidth:5 topCapHeight:5]];
    [getSecurityCodeButton setNTitle:@"获取验证码"];
    [getSecurityCodeButton setNTitleColor:[UIColor whiteColor]];
    [getSecurityCodeButton.titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
    [getSecurityCodeButton addTarget:self action:@selector(getSecurityCode)];
    [getInforView addSubview:getSecurityCodeButton];

    
    timeMachine=[[UILabel alloc]initWithFrame:CGRectMake(240,7,70,30)];
    timeMachine.backgroundColor=[UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:1.0];
    timeMachine.textAlignment=NSTextAlignmentCenter;
    timeMachine.layer.cornerRadius=5.f;
    timeMachine.layer.masksToBounds=YES;
    timeMachine.font=[UIFont systemFontOfSize:12];
    timeMachine.textColor=[UIColor whiteColor];
    timeMachine.numberOfLines=0;
    timeMachine.hidden=YES;
    timeMachine.text=@" 60秒以后重新获取";
    
    [scrollView addSubview:timeMachine];
    
    regetButton=[MyButton buttonWithType:UIButtonTypeCustom];
    [regetButton setNormalBackgroundImage:[[UIImage imageNamed:@"loginbut"]stretchableImageWithLeftCapWidth:10 topCapHeight:10]];
    [regetButton setNTitle:@"重新获取"];
    [regetButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
    regetButton.frame=CGRectMake(252, 10, 65, 25);
    [regetButton setHidden:YES];
    [regetButton addTarget:self action:@selector(regetSecurityCode)];
    [scrollView addSubview:regetButton];
    
    
    securityCodeField=[[MHTextField alloc]initWithFrame:CGRectMake(10+30,55, 200,24)];
    [securityCodeField setKeyboardType:UIKeyboardTypePhonePad];
    securityCodeField.clearButtonMode=UITextFieldViewModeWhileEditing;
    [securityCodeField setPlaceholder:@"请输入验证码"];
    securityCodeField.font=[UIFont systemFontOfSize:15];
    securityCodeField.backgroundColor=[UIColor clearColor];
    [scrollView addSubview:securityCodeField];

    
    passwordTextfield=[[MHTextField alloc]initWithFrame:CGRectMake(10+30,55+45, 270,24)];
    [passwordTextfield setKeyboardType:UIKeyboardTypeASCIICapable];
    passwordTextfield.autocapitalizationType=NO;
    passwordTextfield.autocorrectionType=NO;
    passwordTextfield.backgroundColor=[UIColor clearColor];
    passwordTextfield.secureTextEntry=YES;
    passwordTextfield.font=[UIFont systemFontOfSize:15];
    passwordTextfield.clearButtonMode=UITextFieldViewModeWhileEditing;
    [passwordTextfield setPlaceholder:@"请设置您的密码 (6-16位)"];
    [scrollView addSubview:passwordTextfield];
    

    MyButton * SureButton=[MyButton buttonWithType:UIButtonTypeCustom];
    [SureButton setFrame:CGRectMake(10, 110+45, 300, 40)];
    [SureButton setNormalBackgroundImage:[[UIImage imageNamed:@"loginbut"]stretchableImageWithLeftCapWidth:10 topCapHeight:10]];
    [SureButton setHighlightedBackgroundImage:[[UIImage imageNamed:@"loginbut_d"]stretchableImageWithLeftCapWidth:10 topCapHeight:10]];
    [SureButton setNTitle:@"确认"];

    [SureButton setNTitleColor:[UIColor whiteColor]];
    [SureButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
    [SureButton addTarget:self action:@selector(SureButtonClick:)];
    [getInforView addSubview:SureButton];

    
    
    UILabel *introdution=[[UILabel alloc]initWithFrame:CGRectMake(10, 155+45, 300, 20)];
    introdution.text=@"点击上面的“获取验证码”按钮,即表示您同意: ";
    introdution.backgroundColor=[UIColor clearColor];
    introdution.textColor=[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1];
    introdution.font=[UIFont systemFontOfSize:12];
    [getInforView addSubview:introdution];
    
    MyButton *agreement=[MyButton buttonWithType:UIButtonTypeCustom];
    agreement.frame=CGRectMake(10, 175+45, 120, 20);
    [agreement setNTitle:@"《16WiFi用户协议》"];
    agreement.titleLabel.textAlignment=NSTextAlignmentLeft;
    [agreement setNTitleColor:[UIColor colorWithRed:0/255.0f green:172/255.0f blue:238/255.0f alpha:1]];
    agreement.titleLabel.font=[UIFont systemFontOfSize:12];
    [agreement addTarget:self action:@selector(agreementClick)];
    [getInforView addSubview:agreement];
    
    [numberTextfield setup];
    [securityCodeField setup];
    [passwordTextfield setup];
    
    
    UILabel *Tips=[[UILabel alloc]initWithFrame:CGRectMake(10, SCREENHEIGHT-64-IOSVERSIONSMALL-65, 300, 25)];
    Tips.text=@"注册,只为上网安全 ";
    Tips.textAlignment=NSTextAlignmentCenter;
    Tips.backgroundColor=[UIColor clearColor];
    Tips.textColor=[UIColor blackColor];
    [getInforView addSubview:Tips];
    
    
    UILabel *Tips1=[[UILabel alloc]initWithFrame:CGRectMake(10, SCREENHEIGHT-64-IOSVERSIONSMALL-40, 300, 20)];
    Tips1.text=@"免费使用16WiFi服务,只需注册您的手机号 ";
    Tips1.backgroundColor=[UIColor clearColor];
        Tips1.textAlignment=NSTextAlignmentCenter;
    Tips1.textColor=[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1];
    Tips1.font=[UIFont systemFontOfSize:12];
    [getInforView addSubview:Tips1];
    
    
}
-(void)SureButtonClick:(MyButton *)buttton{

    if (myTimerFlag) {
        myTimerFlag=0;
        [myTimer invalidate];
    }
    [timeMachine setHidden:YES];
//    [regetButton setHidden:NO];
    
    
    BOOL securityCodeCheck4=securityCodeField.text.length!=4;
    BOOL securityCodeCheck0=securityCodeField.text.length==0;
    BOOL passwordCheck0=passwordTextfield.text.length==0;
    BOOL passwordCheck6=passwordTextfield.text.length<6;
    BOOL passwordCheck16=passwordTextfield.text.length>16;
    if (securityCodeCheck0) {
        //请输入验证码
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"" message:@"验证码不能为空，请输入验证码！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        securityCodeField.text=@"";
        passwordTextfield.text=@"";
        return;
        
    }else if(securityCodeCheck4){
        //验证码输入位数不对
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"" message:@"验证码输入错误！请重新输入" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        securityCodeField.text=@"";
        passwordTextfield.text=@"";
        return;
    }else if(passwordCheck0){
        //请设置密码
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"" message:@"密码不能为空，请设置登录密码！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }else if(passwordCheck6){
        //密码不足6位 请重新设置
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"" message:@"您设置的密码不足6位，请重新设置" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        passwordTextfield.text=@"";
        return;
    }else if (passwordCheck16){
        //密码超过16位 请重新设置
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"" message:@"您设置的密码过长，请重新设置" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        passwordTextfield.text=@"";
        return;
    }
    //完成
    
    if ([passwordTextfield isFirstResponder]) {
        [passwordTextfield doneButtonIsClicked:nil];
    }
    if ([securityCodeField isFirstResponder]) {
        [securityCodeField doneButtonIsClicked:nil];
    }
    
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"hhmmss"];
    
    NSString *qString=@"";

    qString=[NSString stringWithFormat:@"mod=getValidate&phone=%@&code=%@&ntime=%@",numberTextfield.text,securityCodeField.text,[dateformatter stringFromDate:[NSDate date]]];

    NSData *secretData=[qString dataUsingEncoding:NSUTF8StringEncoding];
    NSData *qValueData=[secretData AES256EncryptWithKey:SECRETKEY];
    
    NSString *qValue=[qValueData newStringInBase64FromData];
    
    YzRegisterHD=[[HttpDownload alloc]init];
    YzRegisterHD.delegate=self;
    YzRegisterHD.DFailed=@selector(downloadFailed:);
    YzRegisterHD.DComplete=@selector(downloadComplete:);
    [self startAnimat];
    //加入接入16wifi网络时CGI调用
    
    NSURL *downLoadUrl;
    downLoadUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@/app_api/userAccount/checkIdentifyingCode.html?q=%@",NewBaseUrl,qValue]];
    [YzRegisterHD downloadFromUrl:downLoadUrl];
    YzRegisterHD.tag=22233;
    registerFlag=1;
}

#pragma 设置chengshi
-(void)setCityAndInvite{
    
    
    CityAndInviteView=[[UIView alloc]initWithFrame:CGRectMake(0, 74, 320, SCREENHEIGHT-SIZEABOUTIOSVERSION-64)];
    CityAndInviteView.backgroundColor=[UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1.f];
    [self.view addSubview:CityAndInviteView];
    [CityAndInviteView setHidden:YES];
    
    UIView *textBg2=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 90)];
    textBg2.backgroundColor=[UIColor whiteColor];
    [CityAndInviteView addSubview:textBg2];
    
    for (int i=0; i<2; i++) {
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 90*i, 320, 0.5)];
        lineView.backgroundColor=[UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:0.8];
        [textBg2 addSubview:lineView];
    }
    UIView *lineView2=[[UIView alloc]initWithFrame:CGRectMake(10, 45, 310, 0.5)];
    lineView2.backgroundColor=[UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:0.8];
    [textBg2 addSubview:lineView2];
    
    UIScrollView *scrollView2=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 90)];
    scrollView2.tag=1112;
    [CityAndInviteView addSubview:scrollView2];
    
    
    InvitationCodefiled =[[MHTextField alloc]initWithFrame:CGRectMake(10,10, 270,24)];
    [InvitationCodefiled  setKeyboardType:UIKeyboardTypeASCIICapable];
    [InvitationCodefiled setPlaceholder:@"邀请码（输入可获取彩豆奖励）"];
    InvitationCodefiled.backgroundColor=[UIColor clearColor];
    InvitationCodefiled.clearButtonMode=UITextFieldViewModeWhileEditing;
    InvitationCodefiled.font=[UIFont systemFontOfSize:15];
    [CityAndInviteView addSubview:InvitationCodefiled];
    
    [InvitationCodefiled setup];
#pragma mark  选择城市
    
    
    choseCity =[[UIButton alloc]initWithFrame:CGRectMake(0, 45, 320, 45)];
    [choseCity addTarget:self action:@selector(choseCity) forControlEvents:UIControlEventTouchUpInside];
    [scrollView2 addSubview:choseCity];
    
    UILabel *location=[[UILabel alloc]initWithFrame:CGRectMake(10, 55, 200, 24)];
    location.text=@"选择所在城市";
    location.font=[UIFont systemFontOfSize:15];
    location.textAlignment=NSTextAlignmentLeft;
    location.textColor=[UIColor colorWithRed:178/255.0f green:178/255.0f blue:178/255.0f alpha:1];
    [scrollView2 addSubview:location];
    
    city=[[UILabel alloc]initWithFrame:CGRectMake(210, 55, 90, 24)];
    city.text=@"定位中...";
    city.textColor=[UIColor redColor];
    city.textAlignment=NSTextAlignmentCenter;
    city.font=[UIFont systemFontOfSize:15];
    [scrollView2 addSubview:city];
    
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    
#pragma mark  注册---城市定位
    // City 是定位到城市
   NSMutableArray *array=[NSMutableArray arrayWithArray: [[MyDatabase sharedDatabase]readData:1 count:0 model:[[cityItem alloc]init] where:@"city_id" value:[def objectForKey:@"GPS"]]];
    NSLog(@"gpsCity:%@",[def objectForKey:@"GPS"]);
    if (array.count) {
           cityItem *item=array[0];
            city.text=[NSString stringWithFormat:@"%@(GPS)",item.city_name];
    }else{
            NSLog(@"city:%@",city.text);
            city.text=@"定位中...";
        
    }
    NSLog(@"city:%@",city.text);
    
    UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(300, 17, 7, 11)];
    image.image=[UIImage imageNamed:@"arrow"];
    [choseCity addSubview:image];
    
    MyButton * doneButton=[MyButton buttonWithType:UIButtonTypeCustom];
    [doneButton setFrame:CGRectMake(10, 105, 300, 45)];
    [doneButton setNormalBackgroundImage:[[UIImage imageNamed:@"loginbut"]stretchableImageWithLeftCapWidth:10 topCapHeight:10]];
    [doneButton setHighlightedBackgroundImage:[[UIImage imageNamed:@"loginbut_d"]stretchableImageWithLeftCapWidth:10 topCapHeight:10]];
    [doneButton setNTitle:@"完成"];
    [doneButton setNTitleColor:[UIColor whiteColor]];
    [doneButton.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    [doneButton setTitleColor:[UIColor colorWithRed:255/255.f green:255/255.f blue:255/255.f alpha:0.3] forState:UIControlStateHighlighted];
    [doneButton addTarget:self action:@selector(doneBuntunClick)];
    [CityAndInviteView addSubview:doneButton];
    

    
    MyButton * PassButton=[MyButton buttonWithType:UIButtonTypeCustom];
    [PassButton setFrame:CGRectMake(270, 155, 40, 20)];
    [PassButton setNTitle:@"跳过>"];
    PassButton.titleLabel.textAlignment=NSTextAlignmentCenter;
     [PassButton setNTitleColor:[UIColor colorWithRed:0/255.f green:172/255.f blue:238/255.f alpha:1.0]];
    [PassButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
    [PassButton setTitleColor:[UIColor colorWithRed:0/255.f green:172/255.f blue:238/255.f alpha:0.6] forState:UIControlStateHighlighted];
    [PassButton addTarget:self action:@selector(doneBuntunClick)];
    [CityAndInviteView addSubview:PassButton];
    
    
}

-(void)choseCity{
    CityListViewController *cityList=[[CityListViewController alloc]init];
    [self presentViewController:cityList animated:YES completion:nil];
    
}
-(void)agreementClick{
    WebSubPagViewController *web=[[WebSubPagViewController alloc]init];
    
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"agreement" ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:filePath];
   web.myRequest=[NSURLRequest requestWithURL:url];
//    web.titleLabel.text=@"用户协议";
    [self presentViewController:web animated:YES completion:nil];
    
}
-(void)backButtonClick{
    [self dismissViewControllerAnimated:YES completion:^{}];
    
}


-(void)regetSecurityCode{
    [regetButton setHidden:YES];
    [timeMachine setHidden:NO];
    
    timeMachine.text=@"60秒以后重新获取";
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"hhmmss"];

    NSString *QValueStr=[NSString stringWithFormat:@"mod=modpass&phone=%@&type=2&ntime=%@",numberTextfield.text,[dateformatter stringFromDate:[NSDate date]]];

    NSData *secretData=[QValueStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData *qValueData=[secretData AES256EncryptWithKey:SECRETKEY];
    
    NSString *qValue=[qValueData newStringInBase64FromData];

    if (httpDownloadFlag) {
        httpDownloadFlag=0;
        [getSecurityCodeHD cancel];
    }
    getSecurityCodeHD=[[HttpDownload alloc]init];
    getSecurityCodeHD.delegate=self;
    getSecurityCodeHD.DFailed=@selector(downloadFailed:);
    getSecurityCodeHD.DComplete=@selector(downloadComplete:);
    [self startAnimat];
       //加入接入16wifi网络时CGI调用
    NSURL *downLoadUrl;
 
        
    downLoadUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@/app_api/userAccount/getIdentifyingCode.html?q=%@",NewBaseUrl,qValue]];
   
    [getSecurityCodeHD downloadFromUrl:downLoadUrl];
    getSecurityCodeHD.tag=11111;
    httpDownloadFlag=1;
    myTimerFlag=1;
    seconds=60;
}
#pragma mark JAVA 注册 上传个人注册信息
-(void)doneBuntunClick{
  
    NSString *GpsCity;
    if ([city.text isEqualToString:@"定位中..."]) {
        GpsCity=@"其他";
    }else{
        if ([city.text hasSuffix:@"(GPS)"]) {
            GpsCity=[NSString stringWithFormat:@"%@",[city.text substringToIndex:city.text.length-5]];
        }else{
            GpsCity=city.text;
        }
    }
    NSMutableArray *array=[NSMutableArray arrayWithArray: [[MyDatabase sharedDatabase]readData:1 count:0 model:[[cityItem alloc]init] where:@"city_name" value:GpsCity]];
     NSString *qString=@"";
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"hhmmss"];
    
    
    if (array.count) {
        cityItem *item=array[0];
        qString=[NSString stringWithFormat:@"mod=regnew&phone=%@&rand=%@&pass=%@&city=%@&invitepin=%@&model=%@&apmac=%@&mac=%@&fromid=1&type=0&ntime=%@",numberTextfield.text,securityCodeField.text,passwordTextfield.text,item.city_id,InvitationCodefiled.text,[AppDelegate deviceString],[GetCMCCIpAdress getBSSIDStandard],[RootUrl getIDFA],[dateformatter stringFromDate:[NSDate date]]];
    }else{
        
        qString=[NSString stringWithFormat:@"mod=regnew&phone=%@&rand=%@&pass=%@&city=%@&invitepin=%@&model=%@&apmac=%@&mac=%@&fromid=1&type=0&ntime=%@",numberTextfield.text,securityCodeField.text,passwordTextfield.text,@"0",InvitationCodefiled.text,[AppDelegate deviceString],[GetCMCCIpAdress getBSSIDStandard],[RootUrl getIDFA],[dateformatter stringFromDate:[NSDate date]]];
        
    }
    
    NSData *secretData=[qString dataUsingEncoding:NSUTF8StringEncoding];
    NSData *qValueData=[secretData AES256EncryptWithKey:SECRETKEY];
    
    NSString *qValue=[qValueData newStringInBase64FromData];
 
    registerHD=[[HttpDownload alloc]init];
    registerHD.delegate=self;
    registerHD.DFailed=@selector(downloadFailed:);
    registerHD.DComplete=@selector(downloadComplete:);
    [self startAnimat];
       //加入接入16wifi网络时CGI调用

    NSURL *downLoadUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@/app_api/userAccount/register.html?q=%@",NewBaseUrl,qValue]];
    
    [registerHD downloadFromUrl:downLoadUrl];
    registerHD.tag=22222;
    registerFlag=1;
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
-(void)downloadComplete:(HttpDownload *)hd{
    [self stopAnimat];
    if (hd.tag==22233) {
        registerFlag=0;
        NSError *error = nil;
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:hd.mData options:NSJSONReadingAllowFragments error:&error];
        if (error!=nil) {
            NSLog(@"json解析失败22");
        }else{
            NSNumber *num=[dic objectForKey:@"ReturnCode"];
            
            switch ([num intValue]) {
                case 101:
                {
                    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"" message:@"对不起您输入的验证码错误，请重新输入！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alertView show];
                    securityCodeField.text=@"";
                    passwordTextfield.text=@"";
                   
                    myTimerFlag=0;
                    [myTimer invalidate];
                    [timeMachine setHidden:YES];
                    [regetButton setHidden:NO];
                    
                    
                    break;
                }
                case 102:
                {
                    [CityAndInviteView setHidden:NO];
            
                    break;
                }
                case 103:
                {
                    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"" message:@"输入超时，请重新获取验证码！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alertView show];
                    securityCodeField.text=@"";
                    passwordTextfield.text=@"";
                   
                    myTimerFlag=0;
                    [myTimer invalidate];
                    [timeMachine setHidden:YES];
                    [regetButton setHidden:NO];
                    
                    
                    break;
                }
                case 104:
                {
                    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"" message:@"您输入的号码已注册，如您忘记密码可返还登录页面找回密码！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alertView show];
                    numberTextfield.text=@"";
                    securityCodeField.text=@"";
                    passwordTextfield.text=@"";
                    
                    break;
                }
                default:
                    break;
            }
        }
    }
    if (hd.tag==11111) {
        httpDownloadFlag=0;
        NSError *error = nil;
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:hd.mData options:NSJSONReadingAllowFragments error:&error];
        if (error!=nil) {
            NSLog(@"json解析失败20");
        }else{
            NSNumber *num=[dic objectForKey:@"ReturnCode"];
            
            switch ([num intValue]) {
                case 101:
                {
                    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"" message:@"验证码获取失败，请重新获取！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alertView show];
                    break;
                }
                case 102:
                {
                    getSecurityCodeButton.hidden=YES;
                    myPhoneNumberLabel.text=numberTextfield.text;
                    seconds=60;
                    [timeMachine setHidden:NO];
                    regetButton.hidden=YES;
                    myTimer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reloadTime) userInfo:nil repeats:YES];
                    break;
                }
                case 103:
                {
                    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"" message:@"您输入的号码已注册成为会员！" delegate:self cancelButtonTitle:@"登录" otherButtonTitles:@"忘记密码",nil];
                    [alertView show];
                    alertView.tag=10010;
                    numberTextfield.text=@"";
                    InvitationCodefiled.text=@"";
                    
                    break;
                    
                }
                case 104:
                {
                    
                    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"" message:@"您输入的号码格式不正确" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alertView show];
                    break;
                }
                    
                default:
                    break;
            }
        }
    }else if(hd.tag==22222){
        registerFlag=0;
        NSError *error = nil;
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:hd.mData options:NSJSONReadingAllowFragments error:&error];
        if (error!=nil) {
            NSLog(@"json解析失败22");
        }else{
            NSNumber *num=[dic objectForKey:@"ReturnCode"];
            
            switch ([num intValue]) {
                case 101:
                {
                    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"" message:@"对不起您输入的验证码错误，请重新输入！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alertView show];
                    securityCodeField.text=@"";
                    break;
                }
                case 102:
                {
                    NSLog(@"注册返回：%@",dic);
                    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
                    [userDefaults setObject:@"2" forKey:@"isLogin"];
                    [userDefaults setObject:numberTextfield.text forKey:@"userPhone"];
                    [userDefaults setObject:passwordTextfield.text forKey:@"userPassword"];
                    [userDefaults setObject:[dic objectForKey:@"uid"] forKey:@"userID"];
                    [userDefaults setObject:[dic objectForKey:@"acpass"] forKey:@"acpass"];
                    [userDefaults setObject:[dic objectForKey:@"acname"] forKey:@"acname"];
                    [userDefaults synchronize];
#pragma mark GM-Add
                    AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
                   
                    if (_RegisterType==0) {
                        
                        [self dismissViewControllerAnimated:NO completion:^{[login showSuccessNotice:@"注册成功，已登录！"];
                            
                            [app creatTabBarController];
                            
                        }];
                    }else{
                    
                        [self dismissViewControllerAnimated:NO completion:^{[login showSuccessNotice:@"注册成功，已登录！"];
                            
                        }];
                    
                    }
                    
                    
                    break;
                }
                case 103:
                {
                    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"" message:@"输入超时，请重新获取验证码！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alertView show];
                    securityCodeField.text=@"";
                    
                    break;
                }
                case 104:
                {
                    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"" message:@"您输入的号码已注册，如您忘记密码可返还登录页面找回密码！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alertView show];
                    numberTextfield.text=@"";
                    break;
                }
                default:
                    break;
            }
        }
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==10010) {
            [self dismissViewControllerAnimated:YES completion:^{}];
            NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
            [def setObject:@"0" forKey:@"RegisterBack"];

    }
    

}
-(void)downloadFailed:(HttpDownload *)hd{
    
    [self stopAnimat];
    if (hd.tag==11111) {
        httpDownloadFlag=0;
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"" message:@"获取失败！请稍后重新获取！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
    if (hd.tag==22222) {
        registerFlag=0;
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"" message:@"注册失败！请稍后重试！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }

    
}
-(BOOL)checkIsPhoneNumber:(NSString *)str{
    if ([str characterAtIndex:0]!='1') {
        return NO;
    }else if (str.length!=11) {
        //长度不对
        
        return NO;
    }else{
        return YES;
    }
}
#pragma mark 获取验证码

-(void)getSecurityCode{

    //获取验证码
    //需要先验证numberTextfield的输入内容是否合法
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"hhmmss"];
    
    if (numberTextfield.text.length) {
        if ([self checkIsPhoneNumber:numberTextfield.text]) {
            //输入合法的操作
            if ([numberTextfield isFirstResponder]) {
                [numberTextfield doneButtonIsClicked:nil];
            }
            NSString *QValueStr=[NSString stringWithFormat:@"mod=modpass&phone=%@&type=2&ntime=%@",numberTextfield.text,[dateformatter stringFromDate:[NSDate date]]];

            NSData *secretData=[QValueStr dataUsingEncoding:NSUTF8StringEncoding];
            NSData *qValueData=[secretData AES256EncryptWithKey:SECRETKEY];
            
            NSString *qValue=[qValueData newStringInBase64FromData];
            
            
            NSLog(@"%@",QValueStr);
            getSecurityCodeHD=[[HttpDownload alloc]init];
            getSecurityCodeHD.delegate=self;
            getSecurityCodeHD.DFailed=@selector(downloadFailed:);
            getSecurityCodeHD.DComplete=@selector(downloadComplete:);
            [self startAnimat];
               //加入接入16wifi网络时CGI调用
            NSURL *downLoadUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@/app_api/userAccount/getIdentifyingCode.html?q=%@",NewBaseUrl,qValue]];
            
            
            [getSecurityCodeHD downloadFromUrl:downLoadUrl];
            getSecurityCodeHD.tag=11111;
            httpDownloadFlag=1;
       
        }else{
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"" message:@"您输入正确的手机号码！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
            numberTextfield.text=@"";
        }
    }else{
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"" message:@"请输入您的手机号码！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        
    }
    
}
-(void)reloadTime{
    if (seconds) {
        seconds--;
        timeMachine.text=[NSString stringWithFormat:@" %d秒以后重新获取",seconds];
    }else if([myTimer isValid]){
        myTimerFlag=0;
        [myTimer invalidate];
        myTimer=nil;
        [timeMachine setHidden:YES];
        [regetButton setHidden:NO];
    }
    
}
-(void)viewWillDisappear:(BOOL)animated{
    if (myTimerFlag) {
        myTimerFlag=0;
        [myTimer invalidate];
        
    }
    if (httpDownloadFlag) {
        httpDownloadFlag=0;
        [getSecurityCodeHD cancel];
    }
    if (registerFlag) {
        registerFlag=0;
        [registerHD cancel];
    }
    [MobClick endLogPageView:@"Regsiter"];
}
-(void)viewWillAppear:(BOOL)animated{

    [MobClick beginLogPageView:@"Regsiter"];

    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    if (![[def objectForKey:@"SelectCityName"]isEqualToString:@""]) {
        city.text=[def objectForKey:@"SelectCityName"];
    }else{
        if ([def objectForKey:@"city"]){
            
            NSMutableArray *array=[NSMutableArray arrayWithArray: [[MyDatabase sharedDatabase]readData:1 count:0 model:[[cityItem alloc]init] where:@"city_id" value:[def objectForKey:@"city"]]];
            if (array.count) {
                cityItem *item=array[0];
                city.text=[NSString stringWithFormat:@"%@(GPS)",item.city_name];
            }
        }else{
            city.text=@"定位中...";
        }
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
