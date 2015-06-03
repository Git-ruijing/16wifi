//
//  RelateWxViewController.m
//  e-RoadWiFi
//
//  Created by QC on 15-1-22.
//  Copyright (c) 2015年 G.MING. All rights reserved.
//

#import "RelateWxViewController.h"
#import "MyButton.h"
#import "AppDelegate.h"
#import "HttpDownLoad.h"

@interface RelateWxViewController ()

@end

@implementation RelateWxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    titleLabel.text=@"绑定微信";
    
    goBack=[MyButton buttonWithType:UIButtonTypeCustom];
    goBack.frame=CGRectMake(0, SIZEABOUTIOSVERSION,50, 44);
    [goBack setNormalImage:[UIImage imageNamed:@"newBack"]];
    [goBack setSelectedImage:[UIImage imageNamed:@"newBack_d"]];
    [headerView addSubview:goBack];
    [goBack addTarget:self action:@selector(goBackToSuperPage)];
    
    mainInforView=[[UIView alloc]initWithFrame:CGRectMake(0, 64+SIZEFORLOGNAV, 320, SCREENHEIGHT-64-SIZEFORLOGNAV)];
    mainInforView.backgroundColor=[UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1.f];
    [self.view addSubview:mainInforView];
    
    [self creatRelateSwitch];
    [self buildLoadingAnimat];
    
    // Do any additional setup after loading the view.
}
-(void)creatRelateSwitch{

    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 10, SCREENWIDTH, 44)];
    bgView.backgroundColor=[UIColor whiteColor];
    [mainInforView addSubview:bgView];
    
    UIView *lineView1=[[UIView alloc]initWithFrame:CGRectMake(0,0,320, 0.5)];
    lineView1.backgroundColor=[UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:0.7];
    [bgView addSubview:lineView1];
    
    UIView *lineView2=[[UIView alloc]initWithFrame:CGRectMake(0,45,320, 0.5)];
    lineView2.backgroundColor=[UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:0.7];
    [bgView addSubview:lineView2];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(45, 12, 120, 20)];
    label.text=@"绑定微信账号";

    [bgView addSubview:label];
    
    _MySwitch=[[UISwitch alloc]initWithFrame:CGRectMake(240, 7, 40, 30)];
    [bgView addSubview:_MySwitch];
    [_MySwitch addTarget:self action:@selector(RrelateSwitchClick:) forControlEvents:UIControlEventValueChanged];
    _MySwitch.tag=62121;
    
    if ([[def objectForKey:@"RelateWxTips"]isEqualToString:@"0"]) {
        [_MySwitch setOn:NO];
    }else{
    
        [_MySwitch setOn:YES];
    }
    
    UIImageView *head=[[UIImageView alloc]initWithFrame:CGRectMake(10, 11, 21, 21)];
    head.image=[UIImage imageNamed:@"icon_wenxin"];
    [bgView addSubview:head];
    
}
-(void)goBackToSuperPage{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)RrelateSwitchClick:(UISwitch *)Switch{
    
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    if ([[def objectForKey:@"LoginType"]isEqualToString:@"0"]) {
        if (Switch.isOn) {
            NSLog(@"%ld开启状态",(long)_MySwitch.tag);
            
           
           
            
            if ([WXApi isWXAppInstalled]) {
                AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
                app.IsLogin=NO;
                app.RelateWx=self;
                [app sendAuthRequest];
            }else{
            }
        }else{
            NSLog(@"%ld关闭状态",(long)_MySwitch.tag);
          
            
            [self startAnimat];
            HttpDownload *RelateWx=[[HttpDownload alloc]init];
            RelateWx.delegate=self;
            RelateWx.tag=8888;
            RelateWx.DFailed=@selector(downloadFailed:);
            RelateWx.DComplete=@selector(downloadComplete:);
            NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
            [dateformatter setDateFormat:@"hhmmss"];
            NSString *str=[[NSString alloc]init];
            str=[NSString stringWithFormat:@"mod=wxreg&action=unbandwx&openid=%@&phone=%@&ntime=%@",[def objectForKey:@"WXopenId"],[def objectForKey:@"userPhone"],[dateformatter stringFromDate:[NSDate date]]];
            NSString *newUrlStr = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSData *secretData2=[newUrlStr dataUsingEncoding:NSUTF8StringEncoding];
            NSData *qValueData2=[secretData2 AES256EncryptWithKey:SECRETKEY];
            NSString *qValue2=[qValueData2 newStringInBase64FromData];
            NSURL *Load=[NSURL URLWithString:[NSString stringWithFormat:@"%@/usersystem/wxapi.php?q=%@",FormalBaseUrl,qValue2]];
            [RelateWx downloadFromUrl:Load];
            
        }
    }else{
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"微信登陆,暂不支持解绑;请手机登陆后重试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
      
    }
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
          [self goBackToSuperPage];
    }
    
}
-(void)downloadComplete:(HttpDownload *)hd{
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    
    if (hd.tag==8888) {
        [self stopAnimat];
        NSError *error = nil;
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:hd.mData options:NSJSONReadingAllowFragments error:&error];
        if (error!=nil) {
            NSLog(@"json解析失败20");
        }else{
            NSNumber *num=[dic objectForKey:@"ReturnCode"];
            [def setObject:@"0" forKey:@"RelateWxTips"];
            [_MySwitch setOn:NO];
            [def synchronize];
            
            switch ([num intValue]) {
                case 104:
                {
                    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"" message:@"解除绑定失败请重试！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alertView show];
                    break;
                }
                case 102:
                {
                    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"" message:@"您已解除账号与微信的绑定关系" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alertView show];
                    break;
                }
            }
        }
    }
}
-(void)downloadFailed:(HttpDownload *)hd{

    
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
    goBack.userInteractionEnabled=NO;
}
-(void)stopAnimat{
    [aniBg setHidden:YES];
    flag=0;
    [loadingAni stopAnimating];
    goBack.userInteractionEnabled=YES;
}
-(void)viewDidDisappear:(BOOL)animated
{
       [MobClick endLogPageView:@"RelateWx"];
}
-(void)viewWillAppear:(BOOL)animated{


    [MobClick beginLogPageView:@"RelateWx"];


    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    NSLog(@"RelateWxTips%@",[def objectForKey:@"RelateWxTips"]);
    
    
    if ([[def objectForKey:@"RelateWxTips"]isEqualToString:@"0"]) {
        [_MySwitch setOn:NO];
    }else{
        [_MySwitch setOn:YES];
    }
    
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
