//
//  AboutUsViewController.m
//  e路WiFi
//
//  Created by JAY on 13-11-18.
//  Copyright (c) 2013年 HE ZHENJIE. All rights reserved.
//

#import "AboutUsViewController.h"
#import "MobClick.h"
@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.view setBackgroundColor:[UIColor whiteColor]];
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
-(void)viewWillAppear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden=YES;
    [self.navigationController setNavigationBarHidden:YES];
    
    [MobClick beginLogPageView:@"AboutUs"];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [MobClick endLogPageView:@"aboutUs"];
    self.tabBarController.tabBar.hidden=NO;
    [self.navigationController setNavigationBarHidden:NO];
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 48+SIZEABOUTIOSVERSION)];
    UIImageView *headerBackground=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320,48+SIZEABOUTIOSVERSION)];
    [headerView addSubview:headerBackground];
    headerBackground.image=[[UIImage imageNamed:@"gm_nav"]stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    [self.view addSubview:headerView];
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(110, 10+SIZEABOUTIOSVERSION, 100, 30)];
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.font=[UIFont systemFontOfSize:20];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [headerView addSubview:titleLabel];
    titleLabel.text=@"关于我们";
    
    
    MyButton * goBack=[MyButton buttonWithType:UIButtonTypeCustom];
    goBack.frame=CGRectMake(0, SIZEABOUTIOSVERSION,50, 44);
    [goBack setNormalImage:[UIImage imageNamed:@"newBack"]];
    [goBack setSelectedImage:[UIImage imageNamed:@"newBack_d"]];
    [goBack addTarget:self action:@selector(gohome)];
    [headerView addSubview:goBack];
    UIImageView *icon=[[UIImageView alloc]initWithFrame:CGRectMake(131, 48+SIZEABOUTIOSVERSION+65,57, 79)];
    icon.image=[UIImage imageNamed:@"logo"];
    [self.view addSubview:icon];
    
    UILabel *VersionLabel=[[UILabel alloc]initWithFrame:CGRectMake(131, 48+SIZEABOUTIOSVERSION+65+79, 57, 25)];
    VersionLabel.text=[NSString stringWithFormat:@"V%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    VersionLabel.textAlignment=NSTextAlignmentCenter;
    VersionLabel.textColor=[UIColor colorWithRed:76/255.f green:76/255.f blue:76/255.f alpha:1.0];
    [VersionLabel setFont:[UIFont systemFontOfSize:15]];
    VersionLabel.backgroundColor=[UIColor clearColor];
    [self.view addSubview:VersionLabel];
    
    
    UILabel *telLabel=[[UILabel alloc]initWithFrame:CGRectMake(60, 48+SIZEABOUTIOSVERSION+185, 200, 25)];
    telLabel.text=@"官方电话：400-161-1616";
    telLabel.textAlignment=NSTextAlignmentCenter;
    telLabel.textColor=[UIColor colorWithRed:76/255.f green:76/255.f blue:76/255.f alpha:1.0];
    [telLabel setFont:[UIFont systemFontOfSize:15]];
    telLabel.backgroundColor=[UIColor clearColor];
    [self.view addSubview:telLabel];
    
    MyButton *telBut=[MyButton buttonWithType:UIButtonTypeCustom];
    [telBut setFrame:CGRectMake(60, 48+SIZEABOUTIOSVERSION+185, 200, 25)];
    
    [telBut addTarget:self action:@selector(callUs)];
    [self.view addSubview:telBut];
    UILabel *workTime=[[UILabel alloc]initWithFrame:CGRectMake(150,255+SIZEABOUTIOSVERSION, 100, 15)];
    workTime.text=@"(9:00--17:30)";
    workTime.textColor=[UIColor colorWithRed:128/255.f green:128/255.f blue:128/255.f alpha:1.0];
    [workTime setFont:[UIFont systemFontOfSize:11]];
    workTime.backgroundColor=[UIColor clearColor];
    
    
    [self.view addSubview:workTime];
    
    UILabel *webUrl=[[UILabel alloc]initWithFrame:CGRectMake(60,SCREENHEIGHT-SIZEABOUTIOSVERSION-65, 200, 20)];
    webUrl.text=@"官方网址：www.16wifi.com";
    webUrl.textAlignment=NSTextAlignmentCenter;
    webUrl.textColor=[UIColor colorWithRed:128/255.f green:128/255.f blue:128/255.f alpha:1.0];
    [webUrl setFont:[UIFont systemFontOfSize:15]];
    webUrl.backgroundColor=[UIColor clearColor];
    [self.view addSubview:webUrl];
    
    UILabel *copyRight=[[UILabel alloc]initWithFrame:CGRectMake(45,SCREENHEIGHT-SIZEABOUTIOSVERSION-45, 230, 15)];
    copyRight.text=@"copyright ©2015 16wifi.com All rights Reserved";
    copyRight.textAlignment=NSTextAlignmentCenter;
    copyRight.textColor=[UIColor colorWithRed:128/255.f green:128/255.f blue:128/255.f alpha:1.0];
    [copyRight setFont:[UIFont systemFontOfSize:10]];
    copyRight.backgroundColor=[UIColor clearColor];
    
    [self.view addSubview:copyRight];
    // Do any additional setup after loading the view.
}
-(void)callUs{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4001611616"]];
}
-(void)gohome{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
