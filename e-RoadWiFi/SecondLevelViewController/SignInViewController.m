//
//  SignInViewController.m
//  e-RoadWiFi
//
//  Created by QC on 15/2/27.
//  Copyright (c) 2015年 G.MING. All rights reserved.
//

#import "SignInViewController.h"
#import "UIViewController+setTabBarStatus.h"
#import "MyButton.h"
#import "HttpManager.h"
#import "HttpRequest.h"
#import "RootUrl.h"
#import "Encryption.h"
#import "MobClick.h"
@interface SignInViewController ()

@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    SignDateArray=[[NSMutableArray alloc]initWithArray:[def objectForKey:@"SignDate"]];
    NSLog(@"SignDate:%@",SignDateArray);
    
    self.view.backgroundColor=[UIColor colorWithRed:252/255.0f green:60/255.0f blue:76/255.0f alpha:1];
    _scrollerView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 44, 320,SCREENHEIGHT-44)];
    _scrollerView.backgroundColor=[UIColor colorWithRed:248/255.0f green:59/255.0f blue:75/255.0f alpha:0.3];
    _scrollerView.showsHorizontalScrollIndicator=NO;
    _scrollerView.showsVerticalScrollIndicator=NO;
    _scrollerView.contentSize=CGSizeMake(320, 460);
    [self.view addSubview:_scrollerView];
    
    UIView * headerView=[[UIView alloc]initWithFrame:CGRectMake(0, SIZEFORLOGNAV, 320, 64)];
    UIImageView *headerBackground=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320,64)];
    [headerView addSubview:headerBackground];
    headerBackground.image=[[UIImage imageNamed:@"gm_nav"]stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    [self.view addSubview:headerView];
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(60, 10+SIZEABOUTIOSVERSION, 200, 30)];
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.font=[UIFont systemFontOfSize:20];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [headerView addSubview:titleLabel];
    titleLabel.text=@"签到";
    
    MyButton* goBack=[MyButton buttonWithType:UIButtonTypeCustom];
    goBack.frame=CGRectMake(0, SIZEABOUTIOSVERSION,50, 44);
    [goBack setNormalImage:[UIImage imageNamed:@"newBack"]];
    [goBack setSelectedImage:[UIImage imageNamed:@"newBack_d"]];
    [headerView addSubview:goBack];
    [goBack addTarget:self action:@selector(goBackToSuperPage)];
    
    [self creatHeadView];
    [self creatMidView];
    [self creatBottomView];
    
    
}
-(void)creatHeadView{
    
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    tips=[[UILabel alloc]initWithFrame:CGRectMake(40, 20, 240, 20)];
    if ([def objectForKey:@"QdTimes"]) {
        tips.text=[NSString stringWithFormat:@"连续签到 %@ 天啦，坚持有惊喜哦~",[def objectForKey:@"QdTimes"]];
    }else{
        tips.text=[NSString stringWithFormat:@"连续签到 0 天啦，坚持有惊喜哦~"];
    }
    
    tips.font=[UIFont systemFontOfSize:15];
    tips.textColor=[UIColor whiteColor];
    [_scrollerView addSubview:tips];
    
    
    SignView=[[MyImageView alloc]initWithFrame:CGRectMake(93, 50, 135, 39)];
    [SignView addTarget:self action:@selector(SignInClick:)];
    [_scrollerView addSubview:SignView];
    
    SignLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 135, 39)];
    SignLabel.textAlignment=NSTextAlignmentCenter;
    SignLabel.font=[UIFont systemFontOfSize:17];
    [SignView addSubview:SignLabel];
    
    if ([[def objectForKey:@"IsCheck"] integerValue]!=0) {
        SignLabel.text=@"已签到";
        SignView.image=[[UIImage imageNamed:@"grey_but"]stretchableImageWithLeftCapWidth:18 topCapHeight:10];
        SignLabel.textColor=[UIColor whiteColor];
        SignView.userInteractionEnabled=NO;
    }else{
        
        SignView.userInteractionEnabled=YES;
        SignLabel.text=@"签到";
        SignView.image=[[UIImage imageNamed:@"yellow_but"]stretchableImageWithLeftCapWidth:18 topCapHeight:10];
        SignLabel.textColor=[UIColor colorWithRed:102/255.0f green:20/255.0f blue:20/255.0f alpha:1];
    }
    
}


-(void)creatMidView{
    UIImageView *bgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 125, SCREENWIDTH, 568)];
    bgView.image=[[UIImage imageNamed:@"ye-line"]stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    bgView.userInteractionEnabled=YES;
    [_scrollerView addSubview:bgView];
    
    UIView *WhiteView=[[UIView alloc]initWithFrame:CGRectMake(6, 153, 308, 215)];
    WhiteView.backgroundColor=[UIColor whiteColor];
    [_scrollerView addSubview:WhiteView];
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(6, 153, 308, 3)];
    lineView.backgroundColor=[UIColor colorWithRed:252/255.0f green:207/255.0f blue:40/255.0f alpha:1];
    [_scrollerView addSubview:lineView];
    
    UIView *lineView2=[[UIView alloc]initWithFrame:CGRectMake(6, 368, 308, 3)];
    lineView2.backgroundColor=[UIColor colorWithRed:252/255.0f green:207/255.0f blue:40/255.0f alpha:1];
    [_scrollerView addSubview:lineView2];
    
    UIView *lineView3=[[UIView alloc]initWithFrame:CGRectMake(6, 153, 3, 215)];
    lineView3.backgroundColor=[UIColor colorWithRed:252/255.0f green:207/255.0f blue:40/255.0f alpha:1];
    [_scrollerView addSubview:lineView3];
    
    UIView *lineView4=[[UIView alloc]initWithFrame:CGRectMake(311, 153, 3, 215)];
    lineView4.backgroundColor=[UIColor colorWithRed:252/255.0f green:207/255.0f blue:40/255.0f alpha:1];
    [_scrollerView addSubview:lineView4];
    
    DateView = [[PWSCalendarView alloc] initWithFrame:CGRectMake(9, 127, 302, 70) CalendarType:en_calendar_type_month];
    [DateView setBackgroundColor:[UIColor clearColor]];
    [_scrollerView addSubview:DateView];
    [DateView setDelegate:self];
    
}

-(void)creatBottomView{
    
    
    
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 368+25, 60, 1)];
    lineView.backgroundColor=[UIColor colorWithRed:227/255.0f green:210/255.0f blue:158/255.0f alpha:1];
    [_scrollerView addSubview:lineView];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(60, 368+15, 200, 20)];
    label.text=@"连续签到可领取额外奖励";
    label.font=[UIFont systemFontOfSize:15];
    label.textAlignment=NSTextAlignmentCenter;
    [_scrollerView addSubview:label];
    
    
    UIView *lineView2=[[UIView alloc]initWithFrame:CGRectMake(260, 368+25, 60, 1)];
    lineView2.backgroundColor=[UIColor colorWithRed:227/255.0f green:210/255.0f blue:158/255.0f alpha:1];
    [_scrollerView addSubview:lineView2];
    
    
    for (int i=1; i<5; i++) {
        
        MyImageView *bag =  [[MyImageView alloc]initWithFrame:CGRectMake(23+(51+23)*(i-1), 368+45, 51, 58)];
        bag.tag=152300+i;
        bag.image=[UIImage imageNamed:[NSString stringWithFormat:@"bag0%d",i]];
        [bag addTarget:self action:@selector(BagImageClick:)];
        [_scrollerView addSubview:bag];
        
        UILabel *label =[[UILabel alloc]initWithFrame:CGRectMake(23+(51+23)*(i-1), 368+105, 51, 20)];
        label.textAlignment=NSTextAlignmentCenter;
        label.text=[NSString stringWithFormat:@"%d天",7*i];
        label.font=[UIFont systemFontOfSize:15];
        [_scrollerView addSubview:label];
        
    }
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    for (int j=1; j<([[def objectForKey:@"QdTimes"] integerValue]/7)+1; j++) {
        
        MyImageView *bag=(MyImageView *)[_scrollerView viewWithTag:152300+j];
        bag.image=[UIImage imageNamed:[NSString stringWithFormat:@"bag0%d_0",j]];
        
    }

    
}

-(void)BagImageClick:(MyImageView *)BagImage{
    
    
}
-(void)SignInClick:(MyImageView *) SignImageView{
    
    if ([RootUrl getIsNetOn]) {

        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"hhmmss"];
        NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
        NSString *LoadUrl=[NSString stringWithFormat:@"mod=checkin&uid=%@&dev=1&ntime=%@",[def objectForKey:@"userID"],[dateformatter stringFromDate:[NSDate date]]];
        NSData *secretData=[LoadUrl dataUsingEncoding:NSUTF8StringEncoding];
        NSData *qValueData=[secretData AES256EncryptWithKey:SECRETKEY];
        NSString *qValue=[qValueData newStringInBase64FromData];
        [self addTask:[NSString stringWithFormat:@"%@/app_api/userInfo/checkin.html?q=%@",NewBaseUrl,qValue] action:@selector(SignRequest:)];
        SignView.userInteractionEnabled=NO;
        SignLabel.text=@"已签到";
        
    }else{
        
        UIAlertView *alterView=[[UIAlertView alloc]initWithTitle:@"" message:@"当前网络不通，请检查网络设置" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [alterView show];
    }
  }

-(void)SignRequest:(HttpRequest *)SignRequest{
    
    
    [curTaskDict removeObjectForKey:SignRequest.httpUrl];
    
    NSString *str=[[NSString alloc]initWithData:SignRequest.downloadData encoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary * sssdic=[NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding]options:NSJSONReadingAllowFragments error:&error];
    if (error!=nil) {
        NSLog(@"json解析失败144");
        SignView.userInteractionEnabled=YES;
        UIAlertView *alterView=[[UIAlertView alloc]initWithTitle:@"" message:@"网路不给力，签到失败，请重试。" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [alterView show];
        
        SignLabel.text=@"签到";
        SignView.image=[[UIImage imageNamed:@"yellow_but"]stretchableImageWithLeftCapWidth:18 topCapHeight:10];
        SignLabel.textColor=[UIColor colorWithRed:102/255.0f green:20/255.0f blue:20/255.0f alpha:1];
    }else{
        
        NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
        int returnCode=[[sssdic objectForKey:@"ReturnCode"]intValue];
        switch (returnCode) {
            case 102:
            {
                [userDefaults setObject:[sssdic objectForKey:@"times"] forKey:@"QdTimes"];
                [userDefaults setObject:@"1" forKey:@"isExitLogin"];
                [userDefaults setObject:@"1" forKey:@"IsCheck"];
                
                SignLabel.text=@"已签到";
                tips.text=[NSString stringWithFormat:@"连续签到 %@ 天啦，坚持有惊喜哦~",[userDefaults objectForKey:@"QdTimes"]];
                SignView.image=[[UIImage imageNamed:@"grey_but"]stretchableImageWithLeftCapWidth:18 topCapHeight:10];
                SignLabel.textColor=[UIColor whiteColor];
                
                 [DateView.m_view_calendar reloadData];
            
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
                
                
                
                for (int j=0; j<([[userDefaults objectForKey:@"QdTimes"] integerValue]/7)+1; j++) {
                    
                    if (j==0) {
                        
                        for (int i=1; i<5; i++) {
                            MyImageView *bag=(MyImageView *)[_scrollerView viewWithTag:152300+i];
                            bag.image=[UIImage imageNamed:[NSString stringWithFormat:@"bag0%d",i]];
                        }
                        
                    }else{
                        
                        MyImageView *bag=(MyImageView *)[_scrollerView viewWithTag:152300+j];
                        bag.image=[UIImage imageNamed:[NSString stringWithFormat:@"bag0%d_0",j]];
                    }
                    
                }
                
                
                break;
                
                
            }
            default:
                break;
        }
    }

}

// delegate

- (void) PWSCalendar:(PWSCalendarView*)_calendar didSelecteDate:(NSDate*)_date
{
    NSLog(@"select = %@", _date);
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

-(void)goBackToSuperPage{
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    
    [MobClick beginLogPageView:@"SignIn"];
    [self hideTabBar];
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [MobClick endLogPageView:@"SignIn"];
    
}
-(void)didReceiveMemoryWarning {
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
