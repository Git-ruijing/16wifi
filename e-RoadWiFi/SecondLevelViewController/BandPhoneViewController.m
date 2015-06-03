//
//  BandPhoneViewController.m
//  e-RoadWiFi
//
//  Created by QC on 15/2/9.
//  Copyright (c) 2015年 G.MING. All rights reserved.
//

#import "BandPhoneViewController.h"
#import "cityItem.h"
#import "MyDatabase.h"
#import "GetCMCCIpAdress.h"
#import "AppDelegate.h"
#import "MobClick.h"
@interface BandPhoneViewController ()

@end

@implementation BandPhoneViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIView * headerView=[[UIView alloc]initWithFrame:CGRectMake(0, SIZEFORLOGNAV, 320, 64)];
    UIImageView *headerBackground=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320,64)];
    [headerView addSubview:headerBackground];
    headerBackground.image=[[UIImage imageNamed:@"gm_nav"]stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    [self.view addSubview:headerView];
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(110, 10+SIZEABOUTIOSVERSION, 100, 30)];
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.font=[UIFont systemFontOfSize:20];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [headerView addSubview:titleLabel];
    titleLabel.text=@"手机号验证";
    
    [self creatVerifyView];
    [self buildLoadingAnimat];

    MyButton * goBack=[MyButton buttonWithType:UIButtonTypeCustom];
    goBack.frame=CGRectMake(0, SIZEABOUTIOSVERSION,50, 44);
    [goBack setNormalImage:[UIImage imageNamed:@"newBack"]];
    [goBack setSelectedImage:[UIImage imageNamed:@"newBack_d"]];
    [headerView addSubview:goBack];
    [goBack addTarget:self action:@selector(goBack)];
    
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


-(void)creatVerifyView{
    
    getInforView=[[UIView alloc]initWithFrame:CGRectMake(0, 64+SIZEFORLOGNAV, 320, SCREENHEIGHT-64-SIZEFORLOGNAV)];
    getInforView.backgroundColor=[UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1.f];
    [self.view addSubview:getInforView];
    
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 20, 310, 21)];
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.font=[UIFont systemFontOfSize:15];
    titleLabel.textAlignment=NSTextAlignmentLeft;
    [getInforView addSubview:titleLabel];
    titleLabel.text=@"验证后,账户异常会短信提醒,账户更安全";

    UIView *textBg=[[UIView alloc]initWithFrame:CGRectMake(0, 51, 320, 90)];
    textBg.backgroundColor=[UIColor whiteColor];
    for (int i=0; i<2; i++) {
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 90*i, 320, 0.5)];
        lineView.backgroundColor=[UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:0.8];
        [textBg addSubview:lineView];
    }
    
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(10, 45, 310, 0.5)];
    line.backgroundColor=[UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:0.8];
    [textBg addSubview:line];
    [getInforView addSubview:textBg];
    
    
    UIScrollView *scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 51, 320, 90)];
    scrollView.backgroundColor=[UIColor clearColor];
    scrollView.tag=1110;
    [getInforView addSubview:scrollView];
    
    PhoneTextfield=[[MHTextField alloc]initWithFrame:CGRectMake(10,10, 200,24)];
    [PhoneTextfield setKeyboardType:UIKeyboardTypePhonePad];
    PhoneTextfield.font=[UIFont systemFontOfSize:15];
    PhoneTextfield.clearButtonMode=UITextFieldViewModeWhileEditing;
    [PhoneTextfield setPlaceholder:@"请输入手机号"];
    [scrollView addSubview:PhoneTextfield];
    
    
    SeCodeField =[[MHTextField alloc]initWithFrame:CGRectMake(10,55, 270,24)];
    [SeCodeField  setKeyboardType:UIKeyboardTypeASCIICapable];
    [SeCodeField setPlaceholder:@"请输入验证码"];
    SeCodeField.clearButtonMode=UITextFieldViewModeWhileEditing;
    SeCodeField.font=[UIFont systemFontOfSize:15];
    [scrollView addSubview:SeCodeField];
    [PhoneTextfield setup];
    [SeCodeField setup];
    
    
    getSecurityCodeButton=[MyButton buttonWithType:UIButtonTypeCustom];
    [getSecurityCodeButton setFrame:CGRectMake(230, 61, 70, 24)];
    [getSecurityCodeButton setNormalBackgroundImage:[[UIImage imageNamed:@"weixin_but_d"]stretchableImageWithLeftCapWidth:5 topCapHeight:5]];
    //    [getSecurityCodeButton setHighlightedBackgroundImage:[[UIImage imageNamed:@"loginbut_d"]stretchableImageWithLeftCapWidth:5 topCapHeight:5]];
    [getSecurityCodeButton setNTitle:@"获取验证码"];
    [getSecurityCodeButton setNTitleColor:[UIColor colorWithRed:0/255.0f green:172/255.0f blue:238/255.0f alpha:1]];
    [getSecurityCodeButton.titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
    [getSecurityCodeButton addTarget:self action:@selector(getSeCode)];
    [getInforView addSubview:getSecurityCodeButton];
    
    timeMachine=[[UILabel alloc]initWithFrame:CGRectMake(240,7,70,30)];
    timeMachine.backgroundColor=[UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:1.0];
    timeMachine.textAlignment=NSTextAlignmentCenter;
    timeMachine.layer.cornerRadius=5.f;
    timeMachine.layer.masksToBounds=YES;
    timeMachine.font=[UIFont systemFontOfSize:12];
    timeMachine.textColor=[UIColor whiteColor];
    timeMachine.numberOfLines=2;
    timeMachine.text=@" 60秒以后重新获取";
    timeMachine.hidden=YES;
    [scrollView addSubview:timeMachine];
    
    
    regetButton=[MyButton buttonWithType:UIButtonTypeCustom];
    [regetButton setNormalBackgroundImage:[[UIImage imageNamed:@"weixin_but_d"]stretchableImageWithLeftCapWidth:5 topCapHeight:5]];
    [regetButton setNTitle:@"重新获取"];
    [regetButton setNTitleColor:[UIColor colorWithRed:0/255.0f green:172/255.0f blue:238/255.0f alpha:1]];
    [regetButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
    regetButton.frame=CGRectMake(230, 10, 70, 24);
    [regetButton setHidden:YES];
    [regetButton addTarget:self action:@selector(regetSeCode)];
    [scrollView addSubview:regetButton];
    
    MyButton * FinishVerify=[MyButton buttonWithType:UIButtonTypeCustom];
    [FinishVerify setFrame:CGRectMake(10, 110+41, 300, 40)];
    [FinishVerify setNormalBackgroundImage:[[UIImage imageNamed:@"loginbut"]stretchableImageWithLeftCapWidth:10 topCapHeight:10]];
    [FinishVerify setHighlightedBackgroundImage:[[UIImage imageNamed:@"loginbut_d"]stretchableImageWithLeftCapWidth:10 topCapHeight:10]];
    [FinishVerify setNTitle:@"完成验证"];
    [FinishVerify setNTitleColor:[UIColor whiteColor]];
    [FinishVerify.titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
    [FinishVerify addTarget:self action:@selector(FinishVerify)];
    [getInforView addSubview:FinishVerify];
    
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

-(void)getSeCode{
    
    //获取验证码
    //需要先验证numberTextfield的输入内容是否合法
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"hhmmss"];
    
    if (PhoneTextfield.text.length) {
        if ([self checkIsPhoneNumber:PhoneTextfield.text]) {
            //输入合法的操作
            if ([PhoneTextfield isFirstResponder]) {
                [PhoneTextfield doneButtonIsClicked:nil];
            }
            NSString *QValueStr=[NSString stringWithFormat:@"mod=modpass&phone=%@&type=3&ntime=%@",PhoneTextfield.text,[dateformatter stringFromDate:[NSDate date]]];
            
            NSData *secretData=[QValueStr dataUsingEncoding:NSUTF8StringEncoding];
            NSData *qValueData=[secretData AES256EncryptWithKey:SECRETKEY];
            NSString *qValue=[qValueData newStringInBase64FromData];
            
            NSLog(@"%@",QValueStr);
            getSeCodeHD=[[HttpDownload alloc]init];
            getSeCodeHD.delegate=self;
            getSeCodeHD.DFailed=@selector(downloadFailed:);
            getSeCodeHD.DComplete=@selector(downloadComplete:);
            
      
            //加入接入16wifi网络时CGI调用
            NSURL *downLoadUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@/app_api/userAccount/getIdentifyingCode.html?q=%@",NewBaseUrl,qValue]];
            
            if([RootUrl getIsNetOn]||[[GetCMCCIpAdress getSSID]isEqualToString:@"16wifi"]){
                [getSeCodeHD downloadFromUrl:downLoadUrl];
                      [self startAnimat];
            }else{
                UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"" message:@"当前网络不通,请确认后重试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alertView show];
            }
            getSeCodeHD.tag=111222;
            httpDownloadFlag=1;
            
        }else{
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"" message:@"您输入正确的手机号码！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
            PhoneTextfield.text=@"";
        }
    }else{
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"" message:@"请输入您的手机号码！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        
    }
    
}
-(void)regetSeCode{

    [regetButton setHidden:YES];
    [timeMachine setHidden:NO];
    timeMachine.text=@"60秒以后重新获取";
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"hhmmss"];
    NSString *QValueStr=[NSString stringWithFormat:@"mod=modpass&phone=%@&type=3&ntime=%@",PhoneTextfield.text,[dateformatter stringFromDate:[NSDate date]]];
    NSData *secretData=[QValueStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData *qValueData=[secretData AES256EncryptWithKey:SECRETKEY];
    
    NSString *qValue=[qValueData newStringInBase64FromData];
    
    if (httpDownloadFlag) {
        httpDownloadFlag=0;
        [getSeCodeHD cancel];
    }
    getSeCodeHD=[[HttpDownload alloc]init];
    getSeCodeHD.delegate=self;
    getSeCodeHD.DFailed=@selector(downloadFailed:);
    getSeCodeHD.DComplete=@selector(downloadComplete:);
   
    //加入接入16wifi网络时CGI调用
    NSURL *downLoadUrl;
    downLoadUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@/app_api/userAccount/getIdentifyingCode.html?q=%@",NewBaseUrl,qValue]];
    if([RootUrl getIsNetOn]||[[GetCMCCIpAdress getSSID]isEqualToString:@"16wifi"]){
        [getSeCodeHD downloadFromUrl:downLoadUrl];
         [self startAnimat];
        getSeCodeHD.tag=111333;
        httpDownloadFlag=1;
        myTimerFlag=1;
        seconds=60;
        myTimer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reloadTime) userInfo:nil repeats:YES];

    }else{
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"" message:@"当前网络不通,请确认后重试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
   }
-(void)FinishVerify{
    if (myTimerFlag) {
        myTimerFlag=0;
        [myTimer invalidate];
    }
    [timeMachine setHidden:YES];
    [regetButton setHidden:NO];
    
    BOOL securityCodeCheck4=SeCodeField.text.length!=4;
    BOOL securityCodeCheck0=SeCodeField.text.length==0;
    if (securityCodeCheck0) {
        //请输入验证码
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"" message:@"请输入验证码！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
        
    }else if(securityCodeCheck4){
        //验证码输入位数不对
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"" message:@"验证码输入错误！请重新输入" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        SeCodeField.text=@"";
        return;
    }
    VerifyHD=[[HttpDownload alloc]init];
    VerifyHD.delegate=self;
    VerifyHD.DFailed=@selector(downloadFailed:);
    VerifyHD.DComplete=@selector(downloadComplete:);
    [self startAnimat];
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    HttpDownload *wxloginHd=[[HttpDownload alloc]init];
    wxloginHd.delegate=self;
    wxloginHd.tag=222333;
    wxloginHd.DFailed=@selector(downloadFailed:);
    wxloginHd.DComplete=@selector(downloadComplete:);
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"hhmmss"];
    NSString *str=[[NSString alloc]init];
    str=[NSString stringWithFormat:@"mod=wxreg&openid=%@&phone=%@&code=%@&nickname=%@&sex=%@&apmac=%@&mac=%@&city=%@&ntime=%@&action=bandphone&type=1&fromid=1",[def objectForKey:@"WXopenId"],PhoneTextfield.text,SeCodeField.text,[def objectForKey:@"WXnickname"],[def objectForKey:@"WXsex"],[GetCMCCIpAdress getBSSIDStandard],[RootUrl getIDFA],[def objectForKey:@"WXprovince"],[dateformatter stringFromDate:[NSDate date]]];
    
    NSData *secretData=[str dataUsingEncoding:NSUTF8StringEncoding];
    NSData *qValueData=[secretData AES256EncryptWithKey:SECRETKEY];
    NSString *qValue=[qValueData newStringInBase64FromData];
    NSURL *Load=[NSURL URLWithString:[NSString stringWithFormat:@"%@/usersystem/wxapi.php?q=%@",FormalBaseUrl,qValue]];
    if([RootUrl getIsNetOn]||[[GetCMCCIpAdress getSSID]isEqualToString:@"16wifi"]){
        [wxloginHd downloadFromUrl:Load];
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
        [timeMachine setHidden:YES];
        [regetButton setHidden:NO];
    }
    
}

-(void)downloadComplete:(HttpDownload *)hd{
    
    if (hd.tag==111222) {
        [self stopAnimat];
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
                    seconds=60;
                    [timeMachine setHidden:NO];
                    regetButton.hidden=YES;
                    myTimer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reloadTime) userInfo:nil repeats:YES];
                    break;
                }
                case 103:
                {
                    break;
                }
                case 104:
                {
                    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"" message:@"您输入的号码格式不正确！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alertView show];
                    break;
                }
            }
        }
    }else if(hd.tag==111333){
        [self stopAnimat];
        httpDownloadFlag=0;
        NSError *error = nil;
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:hd.mData options:NSJSONReadingAllowFragments error:&error];
        if (error!=nil) {
            NSLog(@"json解析失败21");
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
                    seconds=60;
                    myTimer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reloadTime) userInfo:nil repeats:YES];
                    break;
                }
                default:
                    break;
            }

        }
    }else if (hd.tag==222333){
        [self stopAnimat];
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
                    SeCodeField.text=@"";
                    break;
                }
                case 102:
                {
                    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
                    [userDefaults setObject:[dic objectForKey:@"phone"] forKey:@"userPhone"];
                    [userDefaults setObject:[dic objectForKey:@"uid"] forKey:@"userID"];
                    [userDefaults setObject:[dic objectForKey:@"acpass"] forKey:@"acpass"];
                    [userDefaults setObject:[dic objectForKey:@"acname"] forKey:@"acname"];
                    [userDefaults synchronize];
                    [self getUserInfo];
                    break;
                }
                case 103:
                {
                    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"" message:@"输入超时，请重新获取验证码！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alertView show];
                    SeCodeField.text=@"";
                    break;
                }
                case 104:
                {
                    break;
                }
                case 120:
                {
                    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"" message:@"您输入的手机号已绑定，请更换绑定号码！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alertView show];
                    PhoneTextfield.text=@"";
                    SeCodeField.text=@"";
                }
                    break;
                    
                default:
                    break;
            }
            
        }
        
    }else if (hd.tag==222444){
        [self stopAnimat];
        NSString *str=[[NSString alloc]initWithData:hd.mData encoding:NSUTF8StringEncoding];
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
                    NSLog(@"Verify修改资料");
                    [userDefaults setObject:@"3" forKey:@"isLogin"];
                    NSString* string4 = [[sssdic objectForKey:@"nick"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    [userDefaults setObject:string4 forKey:@"userName"];
                    [userDefaults setBool:[[sssdic objectForKey:@"sex"]intValue]==1?1:0 forKey:@"userGenders"];
                    [userDefaults setObject:[sssdic objectForKey:@"email"] forKey:@"userEmail"];
                    [userDefaults setObject:[sssdic objectForKey:@"birth"] forKey:@"userBirthday"];
                    [userDefaults setObject:[sssdic objectForKey:@"detail"] forKey:@"introduce"];
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
                    [self goBackToSuperPage];
                    [userDefaults setObject:@"1" forKey:@"LoginType"];
                    [userDefaults setObject:@"1" forKey:@"RelateWxTips"];
                    [userDefaults synchronize];
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
    if (hd.tag==111222) {
        httpDownloadFlag=0;
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"" message:@"获取失败！请稍后重新获取！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
}
-(void)getUserInfo{
    
    HttpDownload *userInfo=[[HttpDownload alloc]init];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"hhmmss"];
    NSUserDefaults *userDef=[NSUserDefaults standardUserDefaults];
    NSString *QString=[NSString stringWithFormat:@"mod=getwwuserinfo&phone=%@&ntime=%@",[userDef objectForKey:@"userPhone"],[dateformatter stringFromDate:[NSDate date]]];
    NSData *secretData=[QString dataUsingEncoding:NSUTF8StringEncoding];
    NSData *qValueData=[secretData AES256EncryptWithKey:SECRETKEY];
    NSString *qValue=[qValueData newStringInBase64FromData];
    NSURL *downLoadUrl;
    downLoadUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@/app_api/userInfo/getUserInfo.html?q=%@",NewBaseUrl,qValue]];
    userInfo.tag=222444;
    userInfo.delegate=self;
    userInfo.DFailed=@selector(downloadFailed:);
    userInfo.DComplete=@selector(downloadComplete:);
    [userInfo downloadFromUrl:downLoadUrl];
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
-(void)goBack{
    [UIView animateWithDuration:0 animations:^{
        [self dismissViewControllerAnimated:NO completion:nil];
    } completion:^(BOOL finished){
        
    }];
    
}
-(void)goBackToSuperPage{

    [UIView animateWithDuration:0 animations:^{
        [self dismissViewControllerAnimated:NO completion:nil];
    } completion:^(BOOL finished){

            [_WXLogin showSuccessNotice:@"微信登陆成功"];
    }];


}
-(void)viewWillAppear:(BOOL)animated{
    

    [MobClick beginLogPageView:@"bandPhone"];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    if (myTimerFlag) {
        myTimerFlag=0;
        [myTimer invalidate];
    }
    if (httpDownloadFlag) {
        httpDownloadFlag=0;
        [getSeCodeHD cancel];
    }
     [MobClick endLogPageView:@"bandPhone"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
