//
//  UserDataViewController.m
//  e路WiFi
//
//  Created by JAY on 3/6/14.
//  Copyright (c) 2014 HE ZHENJIE. All rights reserved.
//

#import "UserDataViewController.h"
#import "AppDelegate.h"
#import "CityListViewController.h"
#import "MyDatabase.h"
#import "cityItem.h"
#import "ForgetPasswordViewController.h"
#import "RelateWxViewController.h"
#import "GMImagePreview.h"
#import "HeadImageCropperViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "GetCMCCIpAdress.h"
#import "WebSubPagViewController.h"
#import "MyCoinBillViewController.h"
#define ORIGINAL_MAX_WIDTH 640.0f

@interface UserDataViewController ()

@end

@implementation UserDataViewController

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
- (void)viewDidLoad
{
    [super viewDidLoad];
    downflag=0;
    self.view.backgroundColor=[UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1];
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    UIScrollView *scrollBg=[[UIScrollView alloc]initWithFrame:CGRectMake(0,44+SIZEABOUTIOSVERSION, 320, SCREENHEIGHT-44-SIZEABOUTIOSVERSION)];
    scrollBg.backgroundColor=[UIColor clearColor];
    scrollBg.userInteractionEnabled=YES;
    scrollBg.contentSize=CGSizeMake(320, 45*9+75+30+55+90);
    [self.view addSubview:scrollBg];
    
    
    headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 44+SIZEABOUTIOSVERSION)];
    UIImageView *headerBackground=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320,44+SIZEABOUTIOSVERSION)];
    [headerView addSubview:headerBackground];
    headerBackground.image=[[UIImage imageNamed:@"gm_nav"]stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    [self.view addSubview:headerView];
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(110, SIZEABOUTIOSVERSION, 100, 44)];
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.font=[UIFont systemFontOfSize:20];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [headerView addSubview:titleLabel];
    titleLabel.text=@"个人资料";
    MyButton * goBack=[MyButton buttonWithType:UIButtonTypeCustom];
    goBack.frame=CGRectMake(0, SIZEABOUTIOSVERSION,50, 44);
    [goBack setNormalImage:[UIImage imageNamed:@"newBack"]];
    [goBack setSelectedImage:[UIImage imageNamed:@"newBack_d"]];
    [headerView addSubview:goBack];
    [goBack addTarget:self action:@selector(gohome)];
    
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"0" forKey:@"isUpdateCity"];
    //内容页面
    
    UIButton *changePW=[UIButton buttonWithType:UIButtonTypeCustom];
    changePW.frame=CGRectMake(0, 290+45+45+75+90, 320,45);
    changePW.backgroundColor=[UIColor whiteColor];
    [changePW addTarget:self action:@selector(ChangePassWordBtn) forControlEvents:UIControlEventTouchUpInside];
    [scrollBg addSubview:changePW];
    
    UIView *lineView2=[[UIView alloc]initWithFrame:CGRectMake(0,45,320, 0.5)];
    lineView2.backgroundColor=[UIColor colorWithRed:215/255.f green:217/255.f blue:223/255.f alpha:0.7];
    [changePW addSubview:lineView2];
    
    UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(300, 17, 7, 11)];
    image.image=[UIImage imageNamed:@"arrow"];
    [changePW addSubview:image];
    
    UILabel *user=[[UILabel alloc]initWithFrame:CGRectMake(12,0, 80,45)];
    user.text=@"修改密码";
    user.textAlignment=NSTextAlignmentLeft;
    user.font=[UIFont systemFontOfSize:15];
    user.backgroundColor=[UIColor clearColor];
    [changePW addSubview:user];

    
    UIButton *relateWX=[UIButton buttonWithType:UIButtonTypeCustom];
    relateWX.frame=CGRectMake(0, 290+45+75+90, 320,45);
    relateWX.backgroundColor=[UIColor whiteColor];
    [relateWX addTarget:self action:@selector(RelateWithWX) forControlEvents:UIControlEventTouchUpInside];
    [scrollBg addSubview:relateWX];
    
    UIView *lineView4=[[UIView alloc]initWithFrame:CGRectMake(10,45,310, 0.5)];
    lineView4.backgroundColor=[UIColor colorWithRed:215/255.f green:217/255.f blue:223/255.f alpha:0.7];
    [relateWX addSubview:lineView4];
    
    UIImageView *image4=[[UIImageView alloc]initWithFrame:CGRectMake(300, 17, 7, 11)];
    image4.image=[UIImage imageNamed:@"arrow"];
    [relateWX addSubview:image4];
    
    UILabel *user4=[[UILabel alloc]initWithFrame:CGRectMake(12,0, 80,45)];
    user4.text=@"微信账号";
    user4.textAlignment=NSTextAlignmentLeft;
    user4.font=[UIFont systemFontOfSize:15];
    user4.backgroundColor=[UIColor clearColor];
    [relateWX addSubview:user4];
    
    UILabel *relate=[[UILabel alloc]initWithFrame:CGRectMake(80, 0, 210, 45)];
    relate.backgroundColor=[UIColor clearColor];
    relate.tag=62120;
    relate.font=[UIFont systemFontOfSize:15];
    relate.textAlignment=NSTextAlignmentRight;
    relate.textColor=[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1];

    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    if ([[def objectForKey:@"LoginType"]isEqualToString:@"0"]) {
    //手机登陆
        if ([[def objectForKey:@"RelateWxTips"]isEqualToString:@"0"]) {
            relate.text=@"未绑定";
        }else{
            relate.text=@"已绑定";
        }
    }else{
        //weixin denglu
            relate.text=@"已绑定";
    }
    
    [relateWX addSubview:relate];
    
    UIButton *setPhone=[UIButton buttonWithType:UIButtonTypeCustom];
    setPhone.frame=CGRectMake(0, 290+75+90, 320,45);
    setPhone.backgroundColor=[UIColor whiteColor];
    [setPhone addTarget:self action:@selector(setPhoneBtn) forControlEvents:UIControlEventTouchUpInside];
    [scrollBg addSubview:setPhone];
    
    UILabel *phone=[[UILabel alloc]initWithFrame:CGRectMake(12,0, 80,45)];
    phone.text=@"手机号";
    phone.textAlignment=NSTextAlignmentLeft;
   phone.font=[UIFont systemFontOfSize:15];
    phone.backgroundColor=[UIColor clearColor];
    [setPhone addSubview:phone];
    
    UIView *lineView1=[[UIView alloc]initWithFrame:CGRectMake(0,0,320, 0.5)];
    lineView1.backgroundColor=[UIColor colorWithRed:215/255.f green:217/255.f blue:223/255.f alpha:0.7];
    [setPhone addSubview:lineView1];
    
    UIView *lineView3=[[UIView alloc]initWithFrame:CGRectMake(10,45,310, 0.5)];
    lineView3.backgroundColor=[UIColor colorWithRed:215/255.f green:217/255.f blue:223/255.f alpha:0.7];
    [setPhone addSubview:lineView3];
        
    UIImageView *image2=[[UIImageView alloc]initWithFrame:CGRectMake(300, 17, 7, 11)];
    image2.image=[UIImage imageNamed:@"arrow"];
    [setPhone addSubview:image2];
    
    
    UILabel *userNumber=[[UILabel alloc]initWithFrame:CGRectMake(80, 0, 210, 45)];
    userNumber.backgroundColor=[UIColor clearColor];
    userNumber.textAlignment=NSTextAlignmentRight;
    userNumber.font=[UIFont systemFontOfSize:15];
    userNumber.textColor=[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1];
    
    
    if ([[userDefaults objectForKey:@"userPhone"] hasPrefix:@"1"]) {
        NSMutableString *str=[NSMutableString stringWithString:[userDefaults objectForKey:@"userPhone"]];
        [str replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        userNumber.text=[NSString stringWithFormat:@"%@",str];
    }else{
        userNumber.text=@"未绑定";
    }
    [setPhone addSubview:userNumber];
    
    
    for (int i=0; i<9; i++) {
        
        UIView *bgview=[[UIView alloc]init];
        if (i==0) {

            bgview. frame=CGRectMake(0, 10, 320, 75);

        }else{
            
        bgview.frame=CGRectMake(0, 45*(i-1)+10+75, 320, 45);
            
        }
        bgview.backgroundColor=[UIColor whiteColor];
        [scrollBg addSubview:bgview];
        
        UIImageView *image=[[UIImageView alloc]init];
        if (i==0) {
               image.frame=CGRectMake(300, 32, 7, 11);
        }else{
            image.frame=CGRectMake(300, 17, 7, 11);
        }
    
        image.image=[UIImage imageNamed:@"arrow"];
        [bgview addSubview:image];
        
    }
    UIView *lineView6=[[UIView alloc]initWithFrame:CGRectMake(0,10,320, 0.5)];
    lineView6.backgroundColor=[UIColor colorWithRed:215/255.f green:217/255.f blue:223/255.f alpha:0.7];
    [scrollBg addSubview:lineView6];
    
    UIView *lineView5=[[UIView alloc]initWithFrame:CGRectMake(0,45*6+10+75,320, 0.5)];
    lineView5.backgroundColor=[UIColor colorWithRed:215/255.f green:217/255.f blue:223/255.f alpha:0.7];
    [scrollBg addSubview:lineView5];
    
    for (int j=1 ;j<9; j++) {
        
        UIView *lineView1=[[UIView alloc]initWithFrame:CGRectMake(10,45*(j-1)+10+75,310, 0.5)];
        lineView1.backgroundColor=[UIColor colorWithRed:215/255.f green:217/255.f blue:223/255.f alpha:0.7];
        [scrollBg addSubview:lineView1];
        
    }
    

    UIButton *HeadBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    HeadBtn.frame=CGRectMake(0, 10, 320,75);
    [HeadBtn addTarget:self action:@selector(HeadBtn) forControlEvents:UIControlEventTouchUpInside];
    [scrollBg addSubview:HeadBtn];
    
    UILabel *HeadTitle=[[UILabel alloc]initWithFrame:CGRectMake(12,15, 40,45)];
    HeadTitle.text=@"头像";
    HeadTitle.textAlignment=NSTextAlignmentLeft;
    HeadTitle.font=[UIFont systemFontOfSize:15];
    HeadTitle.backgroundColor=[UIColor clearColor];
    [HeadBtn addSubview:HeadTitle];

//    HeadPhoto=[[UIImageView alloc]initWithFrame:CGRectMake(230, 11, 54, 54)];
//    HeadPhoto.image=[UIImage imageNamed:@"gm_photo"];
//    [HeadBtn addSubview:HeadPhoto];
    
    [scrollBg addSubview:self.portraitImageView];
       [self loadPortrait];
    
    UILabel *nickname=[[UILabel alloc]initWithFrame:CGRectMake(12,10+75, 40,45)];
    nickname.text=@"昵称";
    nickname.textAlignment=NSTextAlignmentLeft;
    nickname.font=[UIFont systemFontOfSize:15];
    nickname.backgroundColor=[UIColor clearColor];
    [scrollBg addSubview:nickname];
    
    nicknameTextField=[[MHTextField alloc]initWithFrame:CGRectMake(70, 20+75, 220,25)];
    nicknameTextField.textFieldDelegate=self;
    nicknameTextField.backgroundColor=[UIColor clearColor];
    [nicknameTextField setKeyboardType:UIKeyboardTypeDefault];
    nicknameTextField.font=[UIFont systemFontOfSize:15];
    nicknameTextField.autocapitalizationType=NO;
    nicknameTextField.autocorrectionType=NO;
    nicknameTextField.textAlignment=NSTextAlignmentRight;
    nicknameTextField.textColor=[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1];
    nicknameTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
    [nicknameTextField setPlaceholder:@"起个响亮的名字"];
    nicknameTextField.text=[userDefaults objectForKey:@"userName"];
    [scrollBg addSubview:nicknameTextField];
    
    
    UIButton *djbutton=[UIButton buttonWithType:UIButtonTypeCustom];
    djbutton.frame=CGRectMake(0, 55+75, 320,45);
    [djbutton addTarget:self action:@selector(DjlocationBtn) forControlEvents:UIControlEventTouchUpInside];
    [scrollBg addSubview:djbutton];
    
    UILabel *level=[[UILabel alloc]initWithFrame:CGRectMake(12,55+75, 80,45)];
    level.text=@"等级";
    level.textAlignment=NSTextAlignmentLeft;
    level.font=[UIFont systemFontOfSize:15];
    level.backgroundColor=[UIColor clearColor];
    [scrollBg addSubview:level];
    
    UIImageView *levelImg=[[UIImageView alloc]initWithFrame:CGRectMake(235,55+75+13, 55, 18)];
    levelImg.image=[[UIImage imageNamed:@"huiyuan"]stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    [scrollBg addSubview:levelImg];
    
    
    UILabel *lv=[[UILabel alloc]initWithFrame:CGRectMake(1, 0, 45, 18)];
    lv.backgroundColor=[UIColor clearColor];
    lv.textColor=[UIColor whiteColor];
    lv.textAlignment=NSTextAlignmentCenter;
    lv.text=[NSString stringWithFormat:@"%@",[def objectForKey:@"Userlv"]];
    lv.font=[UIFont systemFontOfSize:12];
    [levelImg addSubview:lv];


    UIButton *wwbutton=[UIButton buttonWithType:UIButtonTypeCustom];
    wwbutton.frame=CGRectMake(0, 55+75+45, 320,45);
    [wwbutton addTarget:self action:@selector(WwlocationBtn) forControlEvents:UIControlEventTouchUpInside];
    [scrollBg addSubview:wwbutton];
    
    UILabel *WwLevel=[[UILabel alloc]initWithFrame:CGRectMake(12,55+75+45, 80,45)];
    WwLevel.text=@"威望";
    WwLevel.textAlignment=NSTextAlignmentLeft;
    WwLevel.font=[UIFont systemFontOfSize:15];
    WwLevel.backgroundColor=[UIColor clearColor];
    [scrollBg addSubview:WwLevel];
    
    UILabel *relateWw=[[UILabel alloc]initWithFrame:CGRectMake(80, 55+75+45, 210, 45)];
    relateWw.backgroundColor=[UIColor clearColor];
    relateWw.font=[UIFont systemFontOfSize:15];
    relateWw.textAlignment=NSTextAlignmentRight;
    relateWw.textColor=[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1];
    relateWw.text=[NSString stringWithFormat:@"%@",[def objectForKey:@"UserData"]];
    [scrollBg addSubview:relateWw];
    
    
    
    UILabel *gendersLabel=[[UILabel alloc]initWithFrame:CGRectMake(12, 55+75+90, 40,45)];
    gendersLabel.text=@"性别";
    gendersLabel.font=[UIFont systemFontOfSize:15];
    gendersLabel.textAlignment=NSTextAlignmentLeft;
    gendersLabel.backgroundColor=[UIColor clearColor];
    [scrollBg addSubview:gendersLabel];
    
    
    gendersTextField=[[MHTextField alloc]initWithFrame:CGRectMake(50,65+75+90, 240,25)];
    gendersTextField.textFieldDelegate=self;
    [gendersTextField setKeyboardType:UIKeyboardTypeDefault];
    gendersTextField.autocapitalizationType=NO;
    gendersTextField.autocorrectionType=NO;
    gendersTextField.font=[UIFont systemFontOfSize:15];
    gendersTextField.textColor=[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1];
    gendersTextField.textAlignment=NSTextAlignmentRight;
    gendersTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
    [gendersTextField setPlaceholder:@"女"];
    
    if ([userDefaults boolForKey:@"userGenders"]) {
        gendersTextField.text=@"男";
    }else{
        
        gendersTextField.text=@"女";
    }
    
    [gendersTextField setGendersField:YES];
    [scrollBg addSubview:gendersTextField];
    
    
    UILabel *birthdayLabel=[[UILabel alloc]initWithFrame:CGRectMake(12, 100+75+90, 40,45)];
    birthdayLabel.text=@"生日";
    birthdayLabel.textAlignment=NSTextAlignmentLeft;
    birthdayLabel.font=[UIFont systemFontOfSize:15];
    birthdayLabel.backgroundColor=[UIColor clearColor];
    [scrollBg addSubview:birthdayLabel];
    
    
    birthdayTextField=[[MHTextField alloc]initWithFrame:CGRectMake(50,110+75+90, 240,25)];
    birthdayTextField.textFieldDelegate=self;
    [birthdayTextField setKeyboardType:UIKeyboardTypeDefault];
    birthdayTextField.autocapitalizationType=NO;
    birthdayTextField.autocorrectionType=NO;
    birthdayTextField.textAlignment=NSTextAlignmentRight;
    birthdayTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
    birthdayTextField.font=[UIFont systemFontOfSize:15];
    [birthdayTextField setPlaceholder:@"2004-02-02"];
    birthdayTextField.text=[userDefaults objectForKey:@"userBirthday"];
    birthdayTextField.textColor=[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1];
    [birthdayTextField setDateField:YES];
    [scrollBg addSubview:birthdayTextField];
    
    
    UILabel *emailLabel=[[UILabel alloc]initWithFrame:CGRectMake(12, 145+75+90, 40,45)];
    emailLabel.text=@"邮箱";
    emailLabel.font=[UIFont systemFontOfSize:15];
    emailLabel.textAlignment=NSTextAlignmentLeft;
    emailLabel.backgroundColor=[UIColor clearColor];
    [scrollBg addSubview:emailLabel];
    
    emailTextField=[[MHTextField alloc]initWithFrame:CGRectMake(80,155+75+90, 210,25)];
    emailTextField.textFieldDelegate=self;
    [emailTextField setKeyboardType:UIKeyboardTypeEmailAddress];
    emailTextField.autocapitalizationType=NO;
    emailTextField.font=[UIFont systemFontOfSize:15];
    emailTextField.autocorrectionType=NO;
    emailTextField.textAlignment=NSTextAlignmentRight;
    emailTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
    emailTextField.backgroundColor=[UIColor clearColor];
    [emailTextField setPlaceholder:@"输入常用邮箱"];
    [emailTextField setText:[userDefaults objectForKey:@"userEmail"]];
    emailTextField.textColor=[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1];
    [emailTextField setEmailField:YES];
    [scrollBg addSubview:emailTextField];
    
    
    UILabel *introLabel=[[UILabel alloc]initWithFrame:CGRectMake(12, 190+75+90, 40,45)];
    introLabel.text=@"简介";
    introLabel.textAlignment=NSTextAlignmentLeft;
    introLabel.font=[UIFont systemFontOfSize:15];
    introLabel.backgroundColor=[UIColor clearColor];
    [scrollBg addSubview:introLabel];
    
    introTextField=[[MHTextField alloc]initWithFrame:CGRectMake(70, 200+75+90, 220,25)];
    introTextField.textFieldDelegate=self;
    [introTextField setKeyboardType:UIKeyboardTypeDefault];
    introTextField.autocapitalizationType=NO;
    introTextField.autocorrectionType=NO;
    introTextField.font=[UIFont systemFontOfSize:15];
    introTextField.textAlignment=NSTextAlignmentRight;
    introTextField.backgroundColor=[UIColor clearColor];
    introTextField.textColor=[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1];
    introTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
    [introTextField setPlaceholder:@"用一句话描述自己"];
    introTextField.text=[userDefaults objectForKey:@"introduce"];
    NSLog(@"introduce%@",[userDefaults objectForKey:@"introduce"]);
    [scrollBg addSubview:introTextField];
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0, 235+75+90, 320,45);
    [button addTarget:self action:@selector(locationBtn) forControlEvents:UIControlEventTouchUpInside];
    [scrollBg addSubview:button];
    
    UILabel *location=[[UILabel alloc]initWithFrame:CGRectMake(12,235+75+90, 60,45)];
    location.text=@"所在地";
    location.font=[UIFont systemFontOfSize:15];
    location.backgroundColor=[UIColor clearColor];
    location.textAlignment=NSTextAlignmentLeft;
    [scrollBg addSubview:location];
    
    LocationTextField=[[UILabel alloc]initWithFrame:CGRectMake(70,235+75+90, 220,45)];
    LocationTextField.textAlignment=NSTextAlignmentRight;
    LocationTextField.backgroundColor=[UIColor clearColor];
    LocationTextField.font=[UIFont systemFontOfSize:15];
    LocationTextField.textColor=[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1];
    if ([userDefaults objectForKey:@"SelectCityName"]) {
        LocationTextField.text=[userDefaults objectForKey:@"SelectCityName"];
        //        LocationTextField.textColor=[UIColor blackColor];
    }else{
        LocationTextField.text=@"选择所在城市";
        LocationTextField.textColor=[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1];
    }
    NSLog(@"SelectCityName%@",[userDefaults objectForKey:@"SelectCityName"]);
    [scrollBg addSubview:LocationTextField];
    
    [nicknameTextField setup];
    [gendersTextField setup];
    [birthdayTextField setup];
    [emailTextField setup];
    [introTextField setup];
    //内容页面
    
    exitButton=[MyButton buttonWithType:UIButtonTypeCustom];
    exitButton.frame=CGRectMake(10,350+45+45+75+90, 300, 40);
    [exitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [exitButton setNTitleColor:[UIColor colorWithRed:229/255.f green:94/255.f blue:72/255.f alpha:1.f]];
    [exitButton setNormalBackgroundImage:[[UIImage imageNamed:@"exit.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10]];
    [exitButton setHighlightedBackgroundImage:[[UIImage imageNamed:@"exit_d.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10]];
    [exitButton setNTitle:@"退出登录"];
    [exitButton addTarget:self action:@selector(exitLogin)];
    [scrollBg addSubview:exitButton];
    
    submButton=[MyButton buttonWithType:UIButtonTypeCustom];
    submButton.frame=CGRectMake(10,350+45+45+75+90, 300, 40);
    [submButton setNTitleColor:[UIColor colorWithRed:0/255.f green:172/255.f blue:238/255.f alpha:1.f]];
    
    [submButton setNormalBackgroundImage:[[UIImage imageNamed:@"register.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10]];
    [submButton setHighlightedBackgroundImage:[[UIImage imageNamed:@"register_d.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10]];
    [submButton setNTitle:@"提交"];
    [submButton addTarget:self action:@selector(submitUserInfo)];
    [submButton setHidden:YES];
    [scrollBg addSubview:submButton];
    
    
    noticeLabel=[[UILabel alloc]initWithFrame:CGRectMake(60, SCREENHEIGHT-130, 200, 26)];
    noticeLabel.layer.cornerRadius=5.f;
    noticeLabel.layer.masksToBounds=YES;
    noticeLabel.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    noticeLabel.textAlignment=NSTextAlignmentCenter;
    noticeLabel.font=[UIFont systemFontOfSize:12];
    noticeLabel.textColor=[UIColor whiteColor];
    [noticeLabel setHidden:YES];
    [self.view addSubview:noticeLabel];
    [self buildLoadingAnimat];
    // Do any additional setup after loading the view.
}
-(void)DjlocationBtn{

    WebSubPagViewController *web=[[WebSubPagViewController alloc]init];
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"account" ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    web.myRequest=[NSURLRequest requestWithURL:url];
    //    web.titleLabel.text=@"用户协议";
    [self presentViewController:web animated:YES completion:nil];
    
}

-(void)WwlocationBtn{
    
    MyCoinBillViewController *myCoin=[[MyCoinBillViewController alloc]init];
    //获取的总彩豆数
    //myCoin.myCoinNumber=coinNumber;
    myCoin.Type=@"0";
    myCoin.IsPresent=YES;
    [self presentViewController:myCoin animated:YES completion:nil];
    
}
- (void)loadPortrait {
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"hhmmss"];
    NSUserDefaults *userDef=[NSUserDefaults standardUserDefaults];
    NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *path=[NSString stringWithFormat:@"%@/%@-%@",documentsDirectoryPath,[userDef objectForKey:@"userPhone"],[userDef objectForKey:@"Newheadphoto"]];
    
    if ([fileManager fileExistsAtPath:path]) {
        
        self.portraitImageView.image=[UIImage imageWithData:[NSData dataWithContentsOfFile:path]];
        
    }else{
        self.portraitImageView.image=[UIImage imageNamed:@"gm_photo"];
        
    }
    
}

-(void)HeadBtn{

    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册中选取", nil];
    [choiceSheet showInView:self.view];
    
}

- (void)editPortrait {

    [GMImagePreview showImage:self.portraitImageView];
}

#pragma mark 保存图片到本地
- (void)imageCropper:(HeadImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    self.portraitImageView.image = editedImage;
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    [def setObject:@"1" forKey:@"updatePhoto"];
    [def synchronize];
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    
    NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *path=[NSString stringWithFormat:@"%@/%@-%@",documentsDirectoryPath,[def objectForKey:@"userPhone"],[def objectForKey:@"Newheadphoto"]];

    if ([fileManager fileExistsAtPath:path]) {
        
        [fileManager removeItemAtPath:path error:nil];
        
    }
    
    [UIImageJPEGRepresentation(self.portraitImageView.image, 0.5) writeToFile:path atomically:NO];
    
}
- (void)imageCropperDidCancel:(HeadImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // 拍照
        if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([self isFrontCameraAvailable]) {
                controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            }
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"拍照");
                             }];
        }
        
    } else if (buttonIndex == 1) {
        // 从相册中选取
        if ([self isPhotoLibraryAvailable]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"相册");
                             }];
        }
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];

        HeadImageCropperViewController *imgEditorVC = [[HeadImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        imgEditorVC.delegate = self;
        [self presentViewController:imgEditorVC animated:YES completion:^{

        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}

- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark portraitImageView getter  中间视图
- (UIImageView *)portraitImageView {
    //    HeadPhoto=[[UIImageView alloc]initWithFrame:CGRectMake(230, 11, 54, 54)];
    //    HeadPhoto.image=[UIImage imageNamed:@"gm_photo"];
    //    [HeadBtn addSubview:HeadPhoto];
    
    if (!_portraitImageView) {
        CGFloat w = 54.0f; CGFloat h = w;
        _portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(230, 11+10, w, h)];
        [_portraitImageView.layer setCornerRadius:(_portraitImageView.frame.size.height/2)];
        [_portraitImageView.layer setMasksToBounds:YES];
        [_portraitImageView setContentMode:UIViewContentModeScaleAspectFill];
        [_portraitImageView setClipsToBounds:YES];
        _portraitImageView.layer.shadowColor = [UIColor blackColor].CGColor;
        _portraitImageView.layer.shadowOffset = CGSizeMake(4, 4);
        _portraitImageView.layer.shadowOpacity = 0.5;
                _portraitImageView.layer.shadowRadius = 2.0;
//        _portraitImageView.layer.borderColor = [[UIColor blackColor] CGColor];
//        _portraitImageView.layer.borderWidth = 0.5f;
        _portraitImageView.userInteractionEnabled = YES;
        _portraitImageView.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *portraitTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editPortrait)];
        [_portraitImageView addGestureRecognizer:portraitTap];
    }
    return _portraitImageView;
}



-(void)RelateWithWX{
    
    RelateWxViewController *rvc=[[RelateWxViewController alloc]init];
    [self presentViewController:rvc animated:YES completion:nil];
}

-(void)setPhoneBtn{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    
    NSLog(@"%@",[userDefaults objectForKey:@"userPhone"]);
    
    if ([[userDefaults objectForKey:@"userPhone"]hasPrefix:@"1"]) {
       
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"绑定手机暂不支持修改" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
}
-(void)ChangePassWordBtn{
    
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    
    if ([[userDefaults objectForKey:@"userPhone"]hasPrefix:@"1"]) {
        
        ForgetPasswordViewController *fvc=[[ForgetPasswordViewController alloc]init];
        fvc.TypeTag=1;
        [self presentViewController:fvc animated:YES completion:nil];
        
    }else{
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"手机绑定后才可修改密码。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
    
}
-(void)locationBtn{
    
    CityListViewController *city=[[CityListViewController alloc]init];
    [self presentViewController:city animated:YES completion:nil];
    
}


-(void)gohome{
    [self dismissViewControllerAnimated:YES completion:^{}];
}
-(void)downloadComplete:(HttpDownload *)hd{
    
    downflag=0;
    [self stopAnimat];
    
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
                [self showNotice:@"更新成功！"];
                [submButton setHidden:YES];
                [exitButton setHidden:NO];
                NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
                [userDefaults setObject:@"3" forKey:@"isLogin"];
                [userDefaults setObject:nicknameTextField.text forKey:@"userName"];
                [userDefaults setBool:[gendersTextField.text isEqualToString:@"男"] forKey:@"userGenders"];
                
                [userDefaults setObject:emailTextField.text forKey:@"userEmail"];
                [userDefaults setObject:birthdayTextField.text forKey:@"userBirthday"];
                [userDefaults setObject:LocationTextField.text forKey:@"SelectCityName"];
                [userDefaults setObject:introTextField.text forKey:@"introduce"];
                
                AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
                [app checkChannelsData];
                [userDefaults setObject:@"0" forKey:@"isUpdateCity"];
                [userDefaults synchronize];
                
                break;
            }
            case 103:
            {
                [self showNotice:@"信息更新失败！请重新提交"];
                break;
            }
                
            default:
                break;
        }
    }
}
-(void)showNotice:(NSString*)str{
    
    [noticeLabel setHidden:NO];
    
    CGSize maxSize=CGSizeMake(250,20);
//    CGSize realSize=[str sizeWithFont:noticeLabel.font constrainedToSize:maxSize lineBreakMode:NSLineBreakByCharWrapping];
    
    CGSize realSize=[str boundingRectWithSize:maxSize  options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:noticeLabel.font} context:nil].size;
    noticeLabel.frame=CGRectMake((310-realSize.width)/2, SCREENHEIGHT-130,realSize.width+10, 26);
    noticeLabel.text=str;
    [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(setHidNotice) userInfo:nil repeats:NO];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [MobClick endLogPageView:@"userData"];
    [self stopAnimat];
    if (downflag) {
        [submitHd cancel];
    }
}
-(void)setHidNotice{
    [noticeLabel setHidden:YES];
}
-(void)downloadFailed:(HttpDownload *)hd{
    
    downflag=0;
    [self stopAnimat];
    [self showNotice:@"数据更新失败，请重新提交！"];
}
#pragma mark 设置上传个人信息
-(void)submitUserInfo{
    
    NSMutableArray *array=[NSMutableArray arrayWithArray: [[MyDatabase sharedDatabase]readData:1 count:0 model:[[cityItem alloc]init] where:@"city_name" value:LocationTextField.text]];
    
    if ([gendersTextField.text isEqualToString:@""]) {
        [self showNotice:@"请输入！"];
        return;
    }else{
        NSLog(@"：%@",gendersTextField.text);
        int sex = 0;
        if ([gendersTextField.text isEqualToString:@"男"]) {
            sex=1;
        }
        if([gendersTextField.text isEqualToString:@"女"]){
            sex=2;
        }
        NSLog(@"：%d",sex);
        NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
        
        submitHd=[[HttpDownload alloc]init];
        submitHd.delegate=self;
        submitHd.DFailed=@selector(downloadFailed:);
        submitHd.DComplete=@selector(downloadComplete:);
        NSString *parameterString=[[NSString alloc]init];
        
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"hhmmss"];
        
        if (array.count) {
            cityItem *item=array[0];
            
            [RootUrl setCity:item.city_id];

            parameterString=[NSString stringWithFormat:@"mod=userinfo&uid=%@&nick=%@&birth=%@&sex=%d&email=%@&city=%@&detail=%@&type=1&ntime=%@",[userDefaults objectForKey:@"userID"],nicknameTextField.text,birthdayTextField.text,sex,emailTextField.text,item.city_id,introTextField.text,[dateformatter stringFromDate:[NSDate date]]];
            
            switch ([item.city_id intValue]) {
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


        }else{
            parameterString=[NSString stringWithFormat:@"mod=userinfo&uid=%@&nick=%@&birth=%@&sex=%d&email=%@&city=%@&detail=%@&type=1&ntime=%@",[userDefaults objectForKey:@"userID"],nicknameTextField.text,birthdayTextField.text,sex,emailTextField.text,@"0",introTextField.text,[dateformatter stringFromDate:[NSDate date]]];
            
        }
        NSLog(@"intro:%@",introTextField.text);
        
        NSData *secretData=[parameterString dataUsingEncoding:NSUTF8StringEncoding];
        NSData *qValueData=[secretData AES256EncryptWithKey:SECRETKEY];
        NSString *qValue=[qValueData newStringInBase64FromData];
        
        NSURL *downLoadUrl1=[NSURL URLWithString:[NSString stringWithFormat:@"%@/app_api/userInfo/modifyUserInfo.html?q=%@",NewBaseUrl,qValue]];
        if([RootUrl getIsNetOn]||[[GetCMCCIpAdress getSSID]isEqualToString:@"16wifi"]){
            [submitHd downloadFromUrl:downLoadUrl1];
            [self startAnimat];
            downflag=1;
        }else{
        
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"" message:@"当前网络不通,暂不支持上传更新" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
        }

        
    }
    
}
-(void)exitLogin{
    
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
    [self dismissViewControllerAnimated:YES completion:^{
        AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
        [app loginOrExitSucceedWithFlag:1];
    }];
}
-(void)editComplete{
    // 判断资料是否修改
    //    userGenders  userEmail  userBirthday userName isLogin userPhone userPassword
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    NSString *str;
    if ([userDefaults boolForKey:@"userGenders"]) {
        str=@"男";
    }else{
        str=@"女";
    }
    NSLog(@"STR:%@  Gem:%@",str,gendersTextField.text);
    BOOL nameBool=[[userDefaults objectForKey:@"userName"]isEqualToString:nicknameTextField.text];
    BOOL emailBool=[[userDefaults objectForKey:@"userEmail"]isEqualToString:emailTextField.text];
    BOOL gendersBool=[str isEqualToString:gendersTextField.text];
    BOOL birthdayBool=[[userDefaults objectForKey:@"userBirthday"]isEqualToString:birthdayTextField.text];
    BOOL introBool=[[userDefaults objectForKey:@"introduce"]isEqualToString:introTextField.text];
    BOOL nameLong=nicknameTextField.text.length>0;
    if (!nameLong) {
        nicknameTextField.text=[userDefaults objectForKey:@"userName"];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"昵称不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        nameBool=YES;
    }
    if (nameBool&&emailBool&&gendersBool&&birthdayBool&&introBool) {
        [submButton setHidden:YES];
        [exitButton setHidden:NO];
        return;
    }else{
        //修改，更新
        [exitButton setHidden:YES];
        [submButton setHidden:NO];
    }
    
}

-(void)viewWillAppear:(BOOL)animated{

    [MobClick beginLogPageView:@"userData"];
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    if ([def objectForKey:@"SelectCityName"]) {
        LocationTextField.text=[def objectForKey:@"SelectCityName"];
        //        LocationTextField.textColor=[UIColor blackColor];
    }else{
        LocationTextField.text=@"选择所在城市";
        LocationTextField.textColor=[UIColor colorWithRed:178/255.0f green:178/255.0f blue:178/255.0f alpha:1];
    }
    UILabel *relate=(UILabel *)[self.view viewWithTag:62120];
    if ([[def objectForKey:@"LoginType"]isEqualToString:@"0"]) {
        //手机登陆
        if ([[def objectForKey:@"RelateWxTips"]isEqualToString:@"0"]) {
            relate.text=@"未绑定";
        }else{
            relate.text=@"已绑定";
        }
    }else{
        //weixin denglu
        relate.text=@"已绑定";
    }
    
    if ([[def objectForKey:@"isUpdateCity"]isEqualToString:@"1"]) {
#if  0
#else
        //修改，更新
        [exitButton setHidden:YES];
        [submButton setHidden:NO];

#endif
    }
    
    if ([[def objectForKey:@"isLogin"] isEqualToString:@"1"]) {
        
        [self dismissViewControllerAnimated:YES completion:^{
            AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
            [app loginOrExitSucceedWithFlag:1];
        }];
        
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
