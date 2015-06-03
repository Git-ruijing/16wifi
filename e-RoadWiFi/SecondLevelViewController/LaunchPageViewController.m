//
//  LaunchPageViewController.m
//  e路WiFi
//
//  Created by JAY on 14-4-18.
//  Copyright (c) 2014年 HE ZHENJIE. All rights reserved.
//

#import "LaunchPageViewController.h"
#define DEVICE_IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568)

@interface LaunchPageViewController ()

@end

@implementation LaunchPageViewController

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
-(void)viewWillAppear:(BOOL)animated{
    [[UIApplication sharedApplication]setStatusBarHidden:YES];

    [MobClick beginLogPageView:@"LauchPage"];
    
}
-(void)viewWillDisappear:(BOOL)animated{
     [MobClick endLogPageView:@"LauchPage"];
    [[UIApplication sharedApplication]setStatusBarHidden:NO];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    duration=3;
    self.view.backgroundColor=[UIColor whiteColor];
  
    UIImageView * launchImage=[[UIImageView alloc]initWithFrame:CGRectMake(0,0, 320,[[UIScreen mainScreen] bounds].size.height)];
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    NSString *beginTime=[userDefaults objectForKey:@"welStarTime"];
    NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    if (DEVICE_IS_IPHONE5) {
        [launchImage setImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@i5",documentsDirectoryPath,beginTime]]];
    }else{
         [launchImage setImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",documentsDirectoryPath,beginTime]]];
    }
    [self.view addSubview:launchImage];
    timerLabel=[[UILabel alloc]initWithFrame:CGRectMake(300, 20,15, 15)];
    timerLabel.backgroundColor=[UIColor clearColor];
    timerLabel.font=[UIFont fontWithName:@"DBLCDTempBlack" size:15];
    timerLabel.text=[NSString stringWithFormat:@"%d",duration];
    timerLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:timerLabel];
    myTimer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeTimer) userInfo:nil repeats:YES];
    
    // Do any additional setup after loading the view.
}
-(void)changeTimer{
    duration--;
    if (duration) {
        timerLabel.text=[NSString stringWithFormat:@"%d",duration];
    }else{
        [myTimer invalidate];
        [self goMainPage];
    }
}
-(void)goMainPage{
    AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [app resetNetChack];
    [app creatTabBarController];
    
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
