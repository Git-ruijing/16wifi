//
//  ForgetPasswordViewController.m
//  e路WiFi
//
//  Created by JAY on 2/25/14.
//  Copyright (c) 2014 HE ZHENJIE. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "RootUrl.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "MobClick.h"
#import "GetCMCCIpAdress.h"
#define SYSTEMVERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define IOSVERSIONSMALL ([[[UIDevice currentDevice] systemVersion] floatValue]<7.0?20:0)
#define DEVICE_IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568)
#define SCREENHEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SECRETKEY @"ilovewififorfree"
#define SIZEFORLOGNAV ([[[UIDevice currentDevice] systemVersion] floatValue]<7.0?(-20):0)
@interface ForgetPasswordViewController ()
{
    UILabel *title;
}
@end
@implementation ForgetPasswordViewController
@synthesize login;
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
    httpDownloadFlag=0;
    registerFlag=0;
    myTimerFlag=0;
    [self.view setBackgroundColor:[UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1.f]];
    
    
    UIImageView *navView=[[UIImageView alloc]initWithFrame:CGRectMake(0, SIZEFORLOGNAV, 320, 64)];
    navView.image=[UIImage imageNamed:@"gm_nav"];
    navView.userInteractionEnabled=YES;
    [self.view addSubview:navView];
    
    MyButton *back=[MyButton buttonWithType:UIButtonTypeCustom];
    back.frame=CGRectMake(0, 20, 50, 44);
    [back setNormalImage:[UIImage imageNamed:@"newBack"]];
    [back addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:back];

    title=[[UILabel alloc]initWithFrame:CGRectMake(70, 20, 180, 44)];
    if (_TypeTag) {
        title.text=@"修改密码";
        [self ChangePassWord];
    }else{
        title.text=@"找回密码";
        [self ForgetPassWord];
    }
    title.backgroundColor=[UIColor clearColor];
    title.textAlignment =NSTextAlignmentCenter;
    title.font=[UIFont systemFontOfSize:17];
    title.textColor=[UIColor whiteColor];
    [navView addSubview:title];
    
    [self buildLoadingAnimat];
	// Do any additional setup after loading the view.
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

#pragma mark 修改密码
-(void)ChangePassWord{

    registerView=[[UIView alloc]initWithFrame:CGRectMake(0,64, 320, SCREENHEIGHT-64-IOSVERSIONSMALL)];
    registerView.backgroundColor=[UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1.f];
    [self .view addSubview:registerView];
    
    UIScrollView *scrollView1=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, SCREENHEIGHT-64)];
    scrollView1.backgroundColor=[UIColor clearColor];
    scrollView1.tag=15042201;
    [registerView addSubview:scrollView1];
    
    
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
    [scrollView1 addSubview:textBg];
 
    numberTextfield=[[MHTextField alloc]initWithFrame:CGRectMake(10,20, 270,24)];
    [numberTextfield setKeyboardType:UIKeyboardTypeASCIICapable];
    numberTextfield.clearButtonMode=UITextFieldViewModeWhileEditing;
    [numberTextfield setPlaceholder:@"请输入原始密码"];
    numberTextfield.autocapitalizationType=NO;
    numberTextfield.autocorrectionType=NO;
    numberTextfield.secureTextEntry=YES;
    numberTextfield.font=[UIFont systemFontOfSize:15];
    [scrollView1 addSubview:numberTextfield];
    
    
    securityCodeField=[[MHTextField alloc]initWithFrame:CGRectMake(10,10+55, 200,24)];
    [securityCodeField setKeyboardType:UIKeyboardTypeASCIICapable];
    securityCodeField.clearButtonMode=UITextFieldViewModeWhileEditing;
    [securityCodeField setPlaceholder:@"请输入新密码(6-16位)"];
    securityCodeField.autocapitalizationType=NO;
    securityCodeField.autocorrectionType=NO;
     securityCodeField.secureTextEntry=YES;
    securityCodeField.font=[UIFont systemFontOfSize:15];
    securityCodeField.backgroundColor=[UIColor clearColor];
    [scrollView1 addSubview:securityCodeField];
    

    passwordTextfield=[[MHTextField alloc]initWithFrame:CGRectMake(10,55+55, 270,24)];
    [passwordTextfield setKeyboardType:UIKeyboardTypeASCIICapable];
    passwordTextfield.autocapitalizationType=NO;
    passwordTextfield.autocorrectionType=NO;
    passwordTextfield.secureTextEntry=YES;
    passwordTextfield.font=[UIFont systemFontOfSize:15];
    passwordTextfield.clearButtonMode=UITextFieldViewModeWhileEditing;
    [passwordTextfield setPlaceholder:@"请确认新密码"];
    [scrollView1 addSubview:passwordTextfield];
    
    
    [numberTextfield setup];
    [securityCodeField setup];
    [passwordTextfield setup];
    
    MyButton * nextButton=[MyButton buttonWithType:UIButtonTypeCustom];
    [nextButton setFrame:CGRectMake(10, 155, 300, 45)];
    [nextButton setNormalBackgroundImage:[[UIImage imageNamed:@"loginbut"]stretchableImageWithLeftCapWidth:10 topCapHeight:10]];
    [nextButton setHighlightedBackgroundImage:[[UIImage imageNamed:@"loginbut_d"]stretchableImageWithLeftCapWidth:10 topCapHeight:10]];
    [nextButton setNTitle:@"完成"];
    [nextButton setNTitleColor:[UIColor whiteColor]];
    [nextButton setTitleColor:[UIColor colorWithRed:255/255.f green:255/255.f blue:255/255.f alpha:0.3] forState:UIControlStateHighlighted];
    [nextButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
    [nextButton addTarget:self action:@selector(ChanegButtonClick)];
    [scrollView1 addSubview:nextButton];
    
}
-(void)ChanegButtonClick{
    
    BOOL OriginalPassWord0=numberTextfield.text.length==0;
    BOOL OriginalPassWord6=numberTextfield.text.length<6;
    BOOL OriginalPassWord16=numberTextfield.text.length>16;
    
    BOOL NewPassWord0=securityCodeField.text.length==0;
    BOOL NewPassWord6=securityCodeField.text.length<6;
    BOOL NewPassWord16=securityCodeField.text.length>16;
    
    BOOL isSame=[securityCodeField.text isEqualToString:passwordTextfield.text];
    
    if (OriginalPassWord0) {
        
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"" message:@"请输入原始密码！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        [numberTextfield becomeFirstResponder];
        return;
        
    }else if(OriginalPassWord6){
   
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"" message:@"原始密码少于6位！请重新输入" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        numberTextfield.text=@"";
        passwordTextfield.text=@"";
        securityCodeField.text=@"";
        [numberTextfield becomeFirstResponder];
        return;
    }else if (OriginalPassWord16){
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"" message:@"原始密码多于16位！请重新输入" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        numberTextfield.text=@"";
        passwordTextfield.text=@"";
        securityCodeField.text=@"";
        [numberTextfield becomeFirstResponder];
        return;
        
    }else if(NewPassWord0){
        //请设置密码
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"" message:@"请设置登录密码！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        [securityCodeField becomeFirstResponder];
        return;
    }else if(NewPassWord6){
        //密码不足6位 请重新设置
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"" message:@"您设置的密码不足6位，请重新设置" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        securityCodeField.text=@"";
         passwordTextfield.text=@"";
        [securityCodeField becomeFirstResponder];
        return;
    } else if (NewPassWord16){
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"" message:@"您设置的密码过长，请重新设置" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        securityCodeField.text=@"";
        passwordTextfield.text=@"";
        [securityCodeField becomeFirstResponder];
        return;
    }else if (!isSame){
    
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"" message:@"两次输入密码不一致，请重新设置" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        passwordTextfield.text=@"";
        securityCodeField.text=@"";
        [securityCodeField becomeFirstResponder];
        
        return;
    }else if ([numberTextfield.text isEqualToString:passwordTextfield.text]&&[passwordTextfield.text isEqualToString:securityCodeField.text]){
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"" message:@"设置的新旧密码相同，请重新设置" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        passwordTextfield.text=@"";
        securityCodeField.text=@"";
        [securityCodeField becomeFirstResponder];
        
    }
    else{
        //完成
        if ([numberTextfield isFirstResponder]) {
            [numberTextfield doneButtonIsClicked:nil];
        }
        if ([passwordTextfield isFirstResponder]) {
            [passwordTextfield doneButtonIsClicked:nil];
        }
        if ([securityCodeField isFirstResponder]) {
            [securityCodeField doneButtonIsClicked:nil];
        }
        
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"hhmmss"];
        NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
        NSString *qString=[[NSString alloc]init];
        if (![[def objectForKey:@"userPhone"]isEqualToString:@""]) {
            qString=[NSString stringWithFormat:@"mod=member&uid=%@&pass=%@&newpass=%@&ntime=%@",[def objectForKey:@"userID"],[RootUrl md5:numberTextfield.text],[RootUrl md5:securityCodeField.text],[dateformatter stringFromDate:[NSDate date]]];
        }
        NSLog(@"个人资料修改密码参数：%@",qString);
        NSData *secretData=[qString dataUsingEncoding:NSUTF8StringEncoding];
        NSData *qValueData=[secretData AES256EncryptWithKey:SECRETKEY];
        
        NSString *qValue=[qValueData newStringInBase64FromData];
        
        registerHD=[[HttpDownload alloc]init];
        registerHD.delegate=self;
        registerHD.DFailed=@selector(downloadFailed:);
        registerHD.DComplete=@selector(downloadComplete:);
        //加入接入16wifi网络时CGI调用
        NSURL *downLoadUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@/app_api/userAccount/modifyPassword.html?q=%@",NewBaseUrl,qValue]];
        NSLog(@"%@",downLoadUrl);
        if([RootUrl getIsNetOn]||[[GetCMCCIpAdress getSSID]isEqualToString:@"16wifi"]){
            
            [registerHD downloadFromUrl:downLoadUrl];
            [self startAnimat];
        }else{
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"" message:@"当前网络不通,暂不支持修好密码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
            
        }
        
        registerHD.tag=15042213;
        registerFlag=1;
        
    }
    
}

#pragma mark 忘记密码
-(void)ForgetPassWord{
 
    registerView=[[UIView alloc]initWithFrame:CGRectMake(0,64, 320, SCREENHEIGHT-64-IOSVERSIONSMALL)];
    registerView.backgroundColor=[UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1.f];
    [self .view addSubview:registerView];
    registerView.hidden=NO;

    UIScrollView *scrollView1=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, SCREENHEIGHT-64)];
    scrollView1.backgroundColor=[UIColor clearColor];
    scrollView1.tag=150422;
    [registerView addSubview:scrollView1];
    

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
    [scrollView1 addSubview:textBg];
    
    NSArray *images=@[@"iphone_icon",@"lianjie_icon",@"mima_icon"];
    for (int j=0; j<3; j++) {
        
        UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(10, 12+45*j, 18, 21)];
        image.image=[UIImage imageNamed:images[j]];
        [textBg addSubview:image];
    }
    
    numberTextfield=[[MHTextField alloc]initWithFrame:CGRectMake(10+30,20, 270,24)];
    [numberTextfield setKeyboardType:UIKeyboardTypePhonePad];
    numberTextfield.clearButtonMode=UITextFieldViewModeWhileEditing;
    [numberTextfield setPlaceholder:@"请输入手机号码"];
    numberTextfield.font=[UIFont systemFontOfSize:15];
    if (_UserPhone) {
        numberTextfield.text=_UserPhone;
    }
    [scrollView1 addSubview:numberTextfield];

    
    
    getSecurityCodeButton=[MyButton buttonWithType:UIButtonTypeCustom];
    [getSecurityCodeButton setFrame:CGRectMake(240, 17, 70, 30)];
    [getSecurityCodeButton setNormalBackgroundImage:[[UIImage imageNamed:@"loginbut"]stretchableImageWithLeftCapWidth:5 topCapHeight:5]];
    [getSecurityCodeButton setNTitleColor:[UIColor whiteColor]];
    [getSecurityCodeButton setTitleColor:[UIColor colorWithRed:255/255.f green:255/255.f blue:255/255.f alpha:0.3] forState:UIControlStateHighlighted];
    [getSecurityCodeButton setNTitle:@"获取验证码"];
    [getSecurityCodeButton.titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
    [getSecurityCodeButton addTarget:self action:@selector(getSecurityCode)];
    [registerView addSubview:getSecurityCodeButton];
    
    
    securityCodeField=[[MHTextField alloc]initWithFrame:CGRectMake(10+30,10+55, 200,24)];
    [securityCodeField setKeyboardType:UIKeyboardTypePhonePad];
    securityCodeField.clearButtonMode=UITextFieldViewModeWhileEditing;
    [securityCodeField setPlaceholder:@"请输入验证码"];
    securityCodeField.autocapitalizationType=NO;
    securityCodeField.autocorrectionType=NO;
    securityCodeField.font=[UIFont systemFontOfSize:15];
    securityCodeField.backgroundColor=[UIColor clearColor];
    [scrollView1 addSubview:securityCodeField];
   
    
    
    timeMachine=[[UILabel alloc]initWithFrame:CGRectMake(240,7+10,70,30)];
    timeMachine.backgroundColor=[UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:1.0];
    timeMachine.textAlignment=NSTextAlignmentCenter;
    timeMachine.layer.cornerRadius=5.f;
    timeMachine.layer.masksToBounds=YES;
    timeMachine.font=[UIFont systemFontOfSize:12];
    timeMachine.textColor=[UIColor whiteColor];
    timeMachine.numberOfLines=2;
    timeMachine.hidden=YES;
    timeMachine.text=@" 60秒以后重新获取";

    [scrollView1 addSubview:timeMachine];
    
    regetButton=[MyButton buttonWithType:UIButtonTypeCustom];
    [regetButton setNormalBackgroundImage:[[UIImage imageNamed:@"loginbut"]stretchableImageWithLeftCapWidth:10 topCapHeight:10]];
    [regetButton setNTitle:@"重新获取"];
    [regetButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
    regetButton.frame=CGRectMake(252, 10+10, 65, 25);
    [regetButton setHidden:YES];
    [regetButton addTarget:self action:@selector(regetSecurityCode)];
    [scrollView1 addSubview:regetButton];
    
    
    passwordTextfield=[[MHTextField alloc]initWithFrame:CGRectMake(10+30,55+55, 270,24)];
    [passwordTextfield setKeyboardType:UIKeyboardTypeASCIICapable];
    passwordTextfield.autocapitalizationType=NO;
    passwordTextfield.autocorrectionType=NO;
    passwordTextfield.secureTextEntry=YES;
    passwordTextfield.font=[UIFont systemFontOfSize:15];
    passwordTextfield.clearButtonMode=UITextFieldViewModeWhileEditing;
    [passwordTextfield setPlaceholder:@"请输入新密码 (6-16位)"];
    [scrollView1 addSubview:passwordTextfield];
   
    
    [numberTextfield setup];
    [securityCodeField setup];
    [passwordTextfield setup];
    
    
    
    MyButton * nextButton=[MyButton buttonWithType:UIButtonTypeCustom];
    [nextButton setFrame:CGRectMake(10, 155, 300, 45)];
    [nextButton setNormalBackgroundImage:[[UIImage imageNamed:@"loginbut"]stretchableImageWithLeftCapWidth:10 topCapHeight:10]];
    [nextButton setHighlightedBackgroundImage:[[UIImage imageNamed:@"loginbut_d"]stretchableImageWithLeftCapWidth:10 topCapHeight:10]];
    [nextButton setNTitle:@"完成"];
    [nextButton setNTitleColor:[UIColor whiteColor]];
    [nextButton setTitleColor:[UIColor colorWithRed:255/255.f green:255/255.f blue:255/255.f alpha:0.3] forState:UIControlStateHighlighted];
    [nextButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
    [nextButton addTarget:self action:@selector(ForgetButtonClick)];
    [scrollView1 addSubview:nextButton];
    
    
}
-(void)backButtonClick{
    [self dismissViewControllerAnimated:YES completion:^{}];
    
}

-(void)ForgetButtonClick{
    if (myTimerFlag) {
        
        myTimerFlag=0;
        [myTimer invalidate];
        [timeMachine setHidden:YES];
        [regetButton setHidden:NO];

    }
    BOOL securityCodeCheck4=securityCodeField.text.length!=4;
    BOOL securityCodeCheck0=securityCodeField.text.length==0;
    BOOL passwordCheck0=passwordTextfield.text.length==0;
    BOOL passwordCheck6=passwordTextfield.text.length<6;
    BOOL passwordCheck16=passwordTextfield.text.length>16;
    
    if (securityCodeCheck0) {
        //请输入验证码
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"" message:@"请输入验证码！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
        
    }else if(securityCodeCheck4){
        //验证码输入位数不对
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"" message:@"验证码输入错误！请重新输入" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        securityCodeField.text=@"";
        return;
    }else if(passwordCheck0){
        //请设置密码
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"" message:@"请设置登录密码！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }else if(passwordCheck6){
        //密码不足6位 请重新设置
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"" message:@"您设置的密码不足6位，请重新设置" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        passwordTextfield.text=@"";
        return;
    } else if (passwordCheck16){
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"" message:@"您设置的密码过长，请重新设置" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        passwordTextfield.text=@"";
        return;
    }
        else{
        //完成
        
        if ([passwordTextfield isFirstResponder]) {
            [passwordTextfield doneButtonIsClicked:nil];
        }
        if ([securityCodeField isFirstResponder]) {
            [securityCodeField doneButtonIsClicked:nil];
        }
        
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"hhmmss"];
            NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
            NSString *qString=[[NSString alloc]init];
            if (![[def objectForKey:@"userPhone"]isEqualToString:@""]) {
            qString=[NSString stringWithFormat:@"mod=regnew&phone=%@&rand=%@&pass=%@&fromid=1&type=1&ntime=%@",[def objectForKey:@"userPhone"],securityCodeField.text,passwordTextfield.text,[dateformatter stringFromDate:[NSDate date]]];
            }else{
            qString=[NSString stringWithFormat:@"mod=regnew&phone=%@&rand=%@&pass=%@&fromid=1&type=1&ntime=%@",numberTextfield.text,securityCodeField.text,passwordTextfield.text,[dateformatter stringFromDate:[NSDate date]]];
            }
     
        NSLog(@"参数：%@",qString);
        NSData *secretData=[qString dataUsingEncoding:NSUTF8StringEncoding];
        NSData *qValueData=[secretData AES256EncryptWithKey:SECRETKEY];
        
        NSString *qValue=[qValueData newStringInBase64FromData];
        
        registerHD=[[HttpDownload alloc]init];
        registerHD.delegate=self;
        registerHD.DFailed=@selector(downloadFailed:);
        registerHD.DComplete=@selector(downloadComplete:);
        //加入接入16wifi网络时CGI调用
        NSURL *downLoadUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@/app_api/userAccount/register.html?q=%@",NewBaseUrl,qValue]];
        NSLog(@"%@",downLoadUrl);
        if([RootUrl getIsNetOn]||[[GetCMCCIpAdress getSSID]isEqualToString:@"16wifi"]){

            [registerHD downloadFromUrl:downLoadUrl];
            [self startAnimat];
        }else{
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"" message:@"当前网络不通,暂不支持修好密码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
            
        }
        
        registerHD.tag=15042212;
        registerFlag=1;
        
    }
    
}

-(void)regetSecurityCode{
    [regetButton setHidden:YES];
    [timeMachine setHidden:NO];

    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"hhmmss"];
    
    timeMachine.text=@"60秒以后重新获取";
    timeMachine.numberOfLines=2;
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    NSString *QValueStr=[[NSString alloc]init];
    if (![[def objectForKey:@"userPhone"]isEqualToString:@""]) {
        QValueStr=[NSString stringWithFormat:@"mod=modpass&phone=%@&type=1&ntime=%@",[def objectForKey:@"userPhone"],[dateformatter stringFromDate:[NSDate date]]];
    }else{
        QValueStr=[NSString stringWithFormat:@"mod=modpass&phone=%@&type=1&ntime=%@",numberTextfield.text,[dateformatter stringFromDate:[NSDate date]]];
    }
    NSData *secretData=[QValueStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData *qValueData=[secretData AES256EncryptWithKey:SECRETKEY];
    
    NSString *QValue=[qValueData newStringInBase64FromData];

 

    if (httpDownloadFlag) {
        httpDownloadFlag=0;
        [getSecurityCodeHD cancel];
    }
    getSecurityCodeHD=[[HttpDownload alloc]init];
    getSecurityCodeHD.delegate=self;
    getSecurityCodeHD.DFailed=@selector(downloadFailed:);
    getSecurityCodeHD.DComplete=@selector(downloadComplete:);
    NSURL *downLoadUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@/app_api/userAccount/getIdentifyingCode.html?q=%@",NewBaseUrl,QValue]];
    if([RootUrl getIsNetOn]||[[GetCMCCIpAdress getSSID]isEqualToString:@"16wifi"]){

        [getSecurityCodeHD downloadFromUrl:downLoadUrl];
        getSecurityCodeHD.tag=1504221;
        httpDownloadFlag=1;
        myTimerFlag=1;
        seconds=60;
        [self startAnimat];
    }else{
    
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"" message:@"当前网络不通,请确认后重试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
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
    [MobClick endLogPageView:@"ForgetPW"];

}
-(void)viewWillAppear:(BOOL)animated{

    [MobClick beginLogPageView:@"ForgetPW"];
}
-(void)gohome{
    [self dismissViewControllerAnimated:YES completion:^{}];
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
 
    if (hd.tag==1504221) {
        [self stopAnimat];
        httpDownloadFlag=0;
        NSString *str=[[NSString alloc]initWithData:hd.mData encoding:NSUTF8StringEncoding];
        NSLog(@"aa%@",str);
        NSError *error = nil;
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:hd.mData options:NSJSONReadingAllowFragments error:&error];
        if (error!=nil) {
            NSLog(@"json解析失败5");
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
                case 104:
                {
                    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"" message:@"您输入的号码格式不正确！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alertView show];
                    break;
                    
                }
                case 107:
                {
                    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"" message:@"你输入的号码未注册，请先注册！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alertView show];
                }
                default:
                    break;
            }
        }
    }else if(hd.tag==15042212){
        [self stopAnimat];
        
        registerFlag=0;
        NSString  *str=[[NSString alloc]initWithData:hd.mData encoding:NSUTF8StringEncoding];
        NSLog(@"sss%@",str);
        NSError *error = nil;
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:hd.mData options:NSJSONReadingAllowFragments error:&error];
        if (error!=nil) {
            NSLog(@"json解析失败6");
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
#pragma mark 密码修改成功
                    
                    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
                    
                    NSRange rannnn=[numberTextfield.text rangeOfString:@"****"];
                    if (rannnn.location!=NSNotFound) {
                        
                    }else{
                        [userDefaults setObject:numberTextfield.text forKey:@"userPhone"];
                    }
                    [userDefaults setObject:passwordTextfield.text forKey:@"userPassword"];
                    [userDefaults setObject:[dic objectForKey:@"uid"] forKey:@"userID"];
                    [userDefaults synchronize];
                    
                    [userDefaults setObject:@"1" forKey:@"isLogin"];
                    [userDefaults setObject:@"" forKey:@"userPhone"];
                    [userDefaults setObject:@"" forKey:@"userPassword"];
                    [userDefaults setObject:@"" forKey:@"userName"];
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
                    [userDefaults synchronize];
                    
                    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"密码修改成功,请重新登录." delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alertView show];
                    
                    [self dismissViewControllerAnimated:NO completion:^{
                    
                    }];
                    
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
                    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"" message:@"当前密码与原密码重复！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alertView show];
                    numberTextfield.text=@"";
                    break;
                }
                default:
                    break;
            }
        }
    }else if(hd.tag==15042213){
    
        [self stopAnimat];
        NSError *error = nil;
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:hd.mData options:NSJSONReadingAllowFragments error:&error];
        if (error!=nil) {
            NSLog(@"json解析失败6");
        }else{
            NSNumber *num=[dic objectForKey:@"ReturnCode"];
            switch ([num intValue]) {
                case 102:
                {
#pragma mark 密码修改成功
                    
                    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];

                    [userDefaults setObject:@"1" forKey:@"isLogin"];
                    [userDefaults setObject:@"" forKey:@"userPhone"];
                    [userDefaults setObject:@"" forKey:@"userPassword"];
                    [userDefaults setObject:@"" forKey:@"userName"];
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
                    [userDefaults synchronize];
                    
                    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"密码修改成功,请重新登录." delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alertView show];
                    
                    [self dismissViewControllerAnimated:NO completion:^{
                        
                    }];
                    
                    break;
                }
                case 106:
                {
                    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"" message:@"原始密码输入错误，请确认后重试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alertView show];
                    numberTextfield.text=@"";
                    break;
                }
                case 107:
                {
                    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"" message:@"手机号码不存在或错误，请确认后重试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
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
}
-(void)downloadFailed:(HttpDownload *)hd{
    [self stopAnimat];
    if (hd.tag==1504221) {
        httpDownloadFlag=0;
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"" message:@"获取失败！请稍后重新获取！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
    if (hd.tag==15042212) {
        registerFlag=0;
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"" message:@"修改密码失败！请稍后重试！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
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
#pragma mark 点击获取验证码
-(void)getSecurityCode{
    //获取验证码
    //需要先验证numberTextfield的输入内容是否合法
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"hhmmss"];
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    if (numberTextfield.text.length) {
        if ([self checkIsPhoneNumber:numberTextfield.text]) {
            //输入合法的操作
            [numberTextfield doneButtonIsClicked:nil];
            NSString *QValueStr=[[NSString  alloc]init];
            NSLog(@"userPhone:%@",[def objectForKey:@"userPhone"]);
            if (![[def objectForKey:@"userPhone"]isEqualToString:@""]) {
                QValueStr=[NSString stringWithFormat:@"mod=modpass&phone=%@&type=1&ntime=%@",[def objectForKey:@"userPhone"],[dateformatter stringFromDate:[NSDate date]]];
            }else{
                QValueStr=[NSString stringWithFormat:@"mod=modpass&phone=%@&type=1&ntime=%@",numberTextfield.text,[dateformatter stringFromDate:[NSDate date]]];
            }
     
            
            NSLog(@"参数%@",QValueStr);
            
            NSData *secretData=[QValueStr dataUsingEncoding:NSUTF8StringEncoding];
            NSData *qValueData=[secretData AES256EncryptWithKey:SECRETKEY];
            
            NSString *qValue=[qValueData newStringInBase64FromData];
           
            getSecurityCodeHD=[[HttpDownload alloc]init];
            getSecurityCodeHD.delegate=self;
            [self startAnimat];
            getSecurityCodeHD.DFailed=@selector(downloadFailed:);
            getSecurityCodeHD.DComplete=@selector(downloadComplete:);
            NSURL *downLoadUrl;
            downLoadUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@/app_api/userAccount/getIdentifyingCode.html?q=%@",NewBaseUrl,qValue]];
            [getSecurityCodeHD downloadFromUrl:downLoadUrl];
            getSecurityCodeHD.tag=1504221;
            httpDownloadFlag=1;

        }else{
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"您输入正确的手机号码！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
            numberTextfield.text=@"";
        }
    }else{
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"请输入您的手机号码！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        
    }
    
    
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
