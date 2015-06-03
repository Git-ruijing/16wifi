//
//  SettingViewController.m
//  e-RoadWiFi
//
//  Created by QC on 14-8-18.
//  Copyright (c) 2014年 G.MING. All rights reserved.
//

#import "SettingViewController.h"
#import "UserGuiderViewController.h"
#import "AboutUsViewController.h"
#import "RootUrl.h"
#import "MobClick.h"
#import "AppDelegate.h"
#import "UMFeedback.h"
#import "UMFeedbackViewController.h"
@interface SettingViewController ()

@end

@implementation SettingViewController

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
    self.navigationController.navigationBar.hidden=YES;
    self.view.backgroundColor=[UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1];
    _scrollerView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 44, 320,SCREENHEIGHT-44)];
    _scrollerView.backgroundColor=[UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1];
    _scrollerView.showsHorizontalScrollIndicator=NO;
    _scrollerView.showsVerticalScrollIndicator=NO;
    _scrollerView.contentSize=CGSizeMake(320, SCREENHEIGHT-64-48);
    [self.view addSubview:_scrollerView];
    
    [self addNavAndTitle:@"设置" withFrame:CGRectMake(0, 0, 320, 44+SIZEABOUTIOSVERSION)];
    [self showPush];
    [self showHelp];
    [self aboutUs];
    
    
    
#if 0
    //这种效果需要修改背景图片
    UIButton *back=[UIButton buttonWithType:UIButtonTypeCustom];
    back.frame=CGRectMake(-20, 20, 50, 44);
    back.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"newBack_d"]];
    [back addTarget:self action:@selector(getBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item=[[UIBarButtonItem alloc]initWithCustomView:back];
    self.navigationItem.leftBarButtonItem=item;
#else
    
#endif
    
    
    
    // Do any additional setup after loading the view.
}
-(void)showPush{
    
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    
    UIImageView *textBg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 320,90)];
    textBg.backgroundColor=[UIColor whiteColor];
    textBg.userInteractionEnabled=YES;
    [_scrollerView addSubview:textBg];
    
    NSArray *titles=@[@"新闻消息推送",@"流量消耗提示",@"清空本地缓存"];
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0,0,320, 0.5)];
    lineView.backgroundColor=[UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:0.7];
    [textBg addSubview:lineView];
    
    UIView *lineView1=[[UIView alloc]initWithFrame:CGRectMake(10,45,310, 0.5)];
    lineView1.backgroundColor=[UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:0.7];
    [textBg addSubview:lineView1];
    
    UIView *lineView2=[[UIView alloc]initWithFrame:CGRectMake(10,90,310, 0.5)];
    lineView2.backgroundColor=[UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:0.7];
    [textBg addSubview:lineView2];
    
    /*
     UIView *lineView3=[[UIView alloc]initWithFrame:CGRectMake(0,90+45,320, 0.5)];
     lineView3.backgroundColor=[UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:0.7];
     [textBg addSubview:lineView3];
     
     
     for (int i=0; i<2; i++) {
     
     UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(20, 7+45*i, 200, 30)];
     label.text=titles[i];
     label.textColor=[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
     label.font=[UIFont systemFontOfSize:17];
     label.textAlignment=NSTextAlignmentLeft ;
     [textBg addSubview:label];
     
     UISwitch *MySwitch=[[UISwitch alloc]initWithFrame:CGRectMake(260, 7+45*i, 40, 30)];
     [textBg addSubview:MySwitch];
     [MySwitch addTarget:self action:@selector(switchClick:) forControlEvents:UIControlEventValueChanged];
     
     MySwitch.tag=53021+i;
     
     }
     */
    
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 7, 200, 30)];
    label.text=titles[1];
    label.textColor=[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
    label.font=[UIFont systemFontOfSize:15];
    label.textAlignment=NSTextAlignmentLeft ;
    [textBg addSubview:label];
    
    UISwitch *MySwitch=[[UISwitch alloc]initWithFrame:CGRectMake(240, 7, 40, 30)];
    [textBg addSubview:MySwitch];
    [MySwitch addTarget:self action:@selector(switchClick:) forControlEvents:UIControlEventValueChanged];
    MySwitch.tag=53021+1;
    
    if ([[def objectForKey:@"StatisticsTips"]isEqualToString:@"1"]) {
        [MySwitch setOn:YES];
        
    }
    
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(clearCache:) forControlEvents:UIControlEventTouchUpInside];
    button.frame=CGRectMake(0, 97-45, 320, 45);
    button.tag=5302;
    [textBg addSubview:button];
    
    UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 180, 30)];
    label1.text=titles[2];
    label1.font=[UIFont systemFontOfSize:15];
    label1.textColor=[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
    label1.textAlignment=NSTextAlignmentLeft ;
    [button addSubview:label1];
    
    UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(190, 0, 100, 30)];
    
    path=NSHomeDirectory();
    path=[path stringByAppendingPathComponent:@"Library/Caches"];
    
    label2.text=[NSString stringWithFormat:@"已使用%.1fM",[self folderSizeAtPath:path]];
    NSLog(@"huancun%@",[NSString stringWithFormat:@"已使用%.1fM",[self folderSizeAtPath:path]]);
    label2.textColor=[UIColor colorWithRed:128/255.0f green:128/255.0f blue:128/255.0f alpha:1];
    label2.font=[UIFont systemFontOfSize:15];
    label2.tag=53020;
    label2.backgroundColor=[UIColor clearColor];
    label2.textAlignment=NSTextAlignmentRight ;
    [button addSubview:label2];
    
    UIImageView *im=[[UIImageView alloc]initWithFrame:CGRectMake(300, 107-45, 7, 11)];
    im.image=[UIImage imageNamed:@"arrow"];
    [textBg addSubview:im];
    
    
    
}
-(void)showHelp{
    
    UIImageView *textBg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 110, 320,90)];
    //    textBg.image=[[UIImage imageNamed:@"denglu_bg"]stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    textBg.backgroundColor=[UIColor whiteColor];
    textBg.userInteractionEnabled=YES;
    [_scrollerView addSubview:textBg];
    
    NSArray *titles=@[@"使用帮助",@"意见反馈"];
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0,0,320, 0.5)];
    lineView.backgroundColor=[UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:0.7];
    [textBg addSubview:lineView];
    UIView *lineView1=[[UIView alloc]initWithFrame:CGRectMake(10,45,310, 0.5)];
    lineView1.backgroundColor=[UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:0.7];
    [textBg addSubview:lineView1];
    
    UIView *lineView2=[[UIView alloc]initWithFrame:CGRectMake(0,90,320, 0.5)];
    lineView2.backgroundColor=[UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:0.7];
    [textBg addSubview:lineView2];
    
    for (int i=0; i<2; i++) {
        
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.frame=CGRectMake(0, 45*i, 320, 45);
        button.tag=5303+i;
        [textBg addSubview:button];
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 7, 200, 30)];
        label.text=titles[i];
        label.textAlignment=NSTextAlignmentLeft ;
        label.textColor=[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
        label.font=[UIFont systemFontOfSize:15];
        [button addSubview:label];
        
        UIImageView *im=[[UIImageView alloc]initWithFrame:CGRectMake(300, 17, 7, 11)];
        im.image=[UIImage imageNamed:@"arrow"];
        [button addSubview:im];
        
    }
    
}

-(void)aboutUs{
    
    UIImageView *textBg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 210, 320,90)];
    //    textBg.image=[[UIImage imageNamed:@"denglu_bg"]stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    textBg.backgroundColor=[UIColor whiteColor];
    textBg.userInteractionEnabled=YES;
    [_scrollerView addSubview:textBg];
    
    NSArray *titles=@[@"关于我们",@"请鼓励一下"];
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0,0,320, 0.5)];
    lineView.backgroundColor=[UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:0.7];
    [textBg addSubview:lineView];
    UIView *lineView1=[[UIView alloc]initWithFrame:CGRectMake(10,45,310, 0.5)];
    lineView1.backgroundColor=[UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:0.7];
    [textBg addSubview:lineView1];
    
    UIView *lineView2=[[UIView alloc]initWithFrame:CGRectMake(0,90,320, 0.5)];
    lineView2.backgroundColor=[UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:0.7];
    [textBg addSubview:lineView2];
    
    for (int i=0; i<2; i++) {
        
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(aboutUs:) forControlEvents:UIControlEventTouchUpInside];
        button.frame=CGRectMake(0, 45*i, 320, 45);
        button.tag=5304+i;
        [textBg addSubview:button];
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 7, 200, 30)];
        label.text=titles[i];
        label.textColor=[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
        label.font=[UIFont systemFontOfSize:15];
        label.textAlignment=NSTextAlignmentLeft ;
        [button addSubview:label];
        
        UIImageView *im=[[UIImageView alloc]initWithFrame:CGRectMake(300, 17, 7, 11)];
        im.image=[UIImage imageNamed:@"arrow"];
        [button addSubview:im];
        
        
        if (i==0) {
            
            UILabel *VersionLabel=[[UILabel alloc]initWithFrame:CGRectMake(190, 8, 100, 30)];
            VersionLabel.text=[NSString stringWithFormat:@"V%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
            [VersionLabel setFont:[UIFont systemFontOfSize:15]];
            VersionLabel.backgroundColor=[UIColor clearColor];
            VersionLabel.textColor=[UIColor colorWithRed:128/255.0f green:128/255.0f blue:128/255.0f alpha:1];
            VersionLabel.font=[UIFont systemFontOfSize:15];
            VersionLabel.textAlignment=NSTextAlignmentRight ;
            [button addSubview:VersionLabel];
            
            
        }
        
    }
}

-(void)getBack{
    //    self.tabBarController.tabBar.hidden=NO;
    //    self.navigationController.navigationBar.hidden=NO;
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)switchClick:(UISwitch *)MySwitch{
    
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    
    if (MySwitch.tag==53021) {
        if (MySwitch.isOn) {
            NSLog(@"%ld开启状态",(long)MySwitch.tag);
        }else{
            NSLog(@"%ld关闭状态",(long)MySwitch.tag);
        }
        
    }else{
        if (MySwitch.isOn) {
            NSLog(@"%ld开启状态",(long)MySwitch.tag);
            [def setObject:@"1" forKey:@"StatisticsTips"];
        }else{
            NSLog(@"%ld关闭状态",(long)MySwitch.tag);
            [def setObject:@"0" forKey:@"StatisticsTips"];
        }
        
    }
    [def synchronize];
    
    
}
- (void)click:(UIAlertView *)view{
    [view dismissWithClickedButtonIndex:0 animated:YES];
}
-(void)clearCache:(UIButton *)button{
    
    UIAlertView *alterView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"是否清空本地缓存" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认" ,nil];
    [alterView show];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.cancelButtonIndex == buttonIndex) {
        NSLog(@"取消");
    }else{
        NSLog(@"确定");
        
        [self clearCache];
        
        
        NSLog(@"path:----%@",path);
        
        UILabel *label=(UILabel *)[self.view viewWithTag:53020];
        
        label.text=[NSString stringWithFormat:@"已使用0M"];
        
    }
    
}
-(void)buttonClick:(UIButton *)button{
    switch (button.tag-5303) {
        case 0:
        {
            NSLog(@"X%ld",(long)button.tag);
            UserGuiderViewController *guide=[[UserGuiderViewController alloc]init];
            [self.navigationController pushViewController:guide animated:YES];
        }
            break;
        case 1:
        {
            NSLog(@"X%ld",(long)button.tag);
            [self showNativeFeedbackWithAppkey:UMENG_APPKEY];
        }
            break;
    }
    
}
- (void)showNativeFeedbackWithAppkey:(NSString *)appkey {
    //友盟意见反馈页面
    UMFeedbackViewController *feedbackViewController = [[UMFeedbackViewController alloc] init];
    feedbackViewController.appkey = appkey;
    [self.navigationController presentViewController:feedbackViewController animated:YES completion:nil];
    
}
-(void)aboutUs:(UIButton *)button{
    
    switch (button.tag-5304) {
        case 0:
        {
            AboutUsViewController *aboutUs=[[AboutUsViewController alloc]init];
            [self.navigationController pushViewController:aboutUs animated:YES];
        }
            break;
        case 1:
        {
            
            NSLog(@"A%ld",(long)button.tag);
            NSString *str;
            if ([[[UIDevice currentDevice] systemVersion] floatValue]<7) {
                str= [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d",893920240];
            }else{
                
                str=[NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%d",893920240];
            }
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            
            
        }
            break;
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    [MobClick event:@"setting_click"];
    [MobClick beginLogPageView:@"setting"];
    self.tabBarController.tabBar.hidden=YES;
    self.navigationController.navigationBar.hidden=YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden=NO;
    self.navigationController.navigationBar.hidden=NO;
    [MobClick endLogPageView:@"setting"];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
