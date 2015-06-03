//
//  UserViewController.m
//  e-RoadWiFi
//
//  Created by QC on 14-8-15.
//  Copyright (c) 2014年 G.MING. All rights reserved.
//
#import "UserViewController.h"
#import "SettingViewController.h"
#import "HttpManager.h"
#import "HttpRequest.h"
#import "UserShopViewController.h"
#import "MyVideoViewController.h"
#import "UserDataViewController.h"
#import "MyInforItem.h"
#import "GM-PushInfoViewController.h"
#import "GM-PushNewsViewController.h"
#import "PushInfoItem.h"
#import "MyDatabase.h"
#import "cityItem.h"
#import "InviteViewController.h"
#import "MobClick.h"
#import "GetCMCCIpAdress.h"
#import "HttpDownLoad.h"
#import "MyOwnObjectViewController.h"
#import "SearchViewController.h"
@interface UserViewController ()

@end

@implementation UserViewController
{
    UILabel * Tips;
    UIButton *loginBtn;
    UIButton *LVbutton;
}
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
    NumOfShowList=[[[NSUserDefaults standardUserDefaults] objectForKey:@"IsPass"] boolValue]?0:1;
    
    MyScrollView=[[UIScrollView alloc]init];
    MyScrollView.backgroundColor=[UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1];
    MyScrollView.showsHorizontalScrollIndicator=NO;
    MyScrollView.showsVerticalScrollIndicator=NO;
    
    [self creatNav];
    [self.view addSubview:MyScrollView];
    [self creatHeadView];
    [self creatBottomView];
    [self addMyInfo];
    [self addUserName];
    

//    [self creatComView];
    
    // Do any additional setup after loading the view.
}

-(void)creatNav{
    UIImageView *navView=[[UIImageView alloc]init];
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7) {
        navView.frame=CGRectMake(0, 0, 320, 64);
        MyScrollView.frame=CGRectMake(0, 64, 320, SCREENHEIGHT-64);
        MyScrollView.contentSize=CGSizeMake(320, SCREENHEIGHT-48);
        
    }else{
        navView.frame=CGRectMake(0, -20, 320, 64);
        MyScrollView.frame=CGRectMake(0, 44, 320, SCREENHEIGHT-112);
        MyScrollView.contentSize=CGSizeMake(320, SCREENHEIGHT-92);
    }
    navView.image=[UIImage imageNamed:@"gm_nav"];
    navView.userInteractionEnabled=YES;
    [self.view addSubview:navView];
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(120, 20, 80, 44)];
    titleLabel.text=@"我";
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.font=[UIFont systemFontOfSize:20];
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.backgroundColor=[UIColor clearColor];
    [navView addSubview:titleLabel];
    
    MyButton * shareButton=[MyButton buttonWithType:UIButtonTypeCustom];
    shareButton.frame=CGRectMake(SCREENWIDTH-55, SIZEABOUTIOSVERSION,50, 44);
    [shareButton setNormalImage:[UIImage imageNamed:@"set"]];
    [shareButton addTarget:self action:@selector(SetButtonClick)];
    [navView addSubview:shareButton];

    
}

-(void)SetButtonClick{

    SettingViewController *svc=[[SettingViewController alloc]init];
    [self.navigationController pushViewController:svc animated:YES];
}

-(void)HeadPhotoRequest:(HttpRequest *)photoRequest{
    
    [curTaskDict removeObjectForKey:photoRequest.httpUrl];
    NSString *str=[[NSString alloc]initWithData:photoRequest.downloadData encoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary * sssdic=[NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding]options:NSJSONReadingAllowFragments error:&error];
    if (error!=nil) {
        NSLog(@"HeadPhotoRequest解析失败144");
    }else{
    
        int returnCode=[[sssdic objectForKey:@"ReturnCode"]intValue];
        switch (returnCode) {
            case 200:
            {
            
                NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
                
                NSFileManager *fileManager=[NSFileManager defaultManager];
                
                NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                
                NSString *path=[NSString stringWithFormat:@"%@/%@-%@",documentsDirectoryPath,[def objectForKey:@"userPhone"],[def objectForKey:@"Newheadphoto"]];
                
                if ([fileManager fileExistsAtPath:path]) {
                    
                    HeadPhoto.image=[UIImage imageWithData:[NSData dataWithContentsOfFile:path]];
                    NSLog(@"加载本地头像成功");
                }else{
                    
                    NSLog(@"updatePhoto%@",[def objectForKey:@"updatePhoto"]);
                    if ([[def objectForKey:@"updatePhoto"]isEqualToString:@"1"]) {
                        HeadPhoto.image=[UIImage imageNamed:@"gm_photo"];
                    }else {
                       
                        HttpDownload *hd=[[HttpDownload alloc]init];
                        hd.tag=150403;
                        hd.delegate=self;
                        hd.DFailed=@selector(downloadFailed:);
                        hd.DComplete=@selector(downloadComplete:);
                        [hd downloadFromUrl:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.16wifi.com%@",[sssdic objectForKey:@"photo"]]]];
                        NSLog(@"Loadpath%@",[NSString stringWithFormat:@"http://www.16wifi.com%@",[sssdic objectForKey:@"photo"]]);
 
                    }
                }

                        }
                break;
                
            case 201:
            {
                   HeadPhoto.image=[UIImage imageNamed:@"gm_photo"];
            }
                break;
                
        }
    }
}
-(void)downloadFailed:(HttpDownload *)hd{

    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"当前网络不通，下载头像失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
    
}

-(void)downloadComplete:(HttpDownload*)hd{
    //本地保存
    if (hd.tag==150403) {
        
        if (hd.mData.length) {
            UIImage * imim=[UIImage imageWithData:hd.mData];
            
            NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
            
            NSFileManager *fileManager=[NSFileManager defaultManager];
            
            NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            
            NSString *path=[NSString stringWithFormat:@"%@/%@-%@",documentsDirectoryPath,[def objectForKey:@"userPhone"],[def objectForKey:@"Newheadphoto"]];
            
            if ([fileManager fileExistsAtPath:path]) {
                
                [fileManager removeItemAtPath:path error:nil];
                
            }
            
            [UIImageJPEGRepresentation(imim, 0.5) writeToFile:path atomically:NO];
            HeadPhoto.image=[UIImage imageWithData:[NSData dataWithContentsOfFile:path]];

        }else{
        
              HeadPhoto.image=[UIImage imageNamed:@"gm_photo"];
        }
        
    }
}

-(void)NewUserInfoRequest:(HttpRequest *)infoRequest{

    [curTaskDict removeObjectForKey:infoRequest.httpUrl];
    
    NSString *str=[[NSString alloc]initWithData:infoRequest.downloadData encoding:NSUTF8StringEncoding];
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
                
                if (sssdic) {
                    [dataArray removeAllObjects];
                    MyInforItem *info=[[MyInforItem alloc]init];
                    [info setValuesForKeysWithDictionary:sssdic];
                    [dataArray addObject:info];
                    [userDefaults setObject:sssdic forKey:@"UserInfo"];
                    [userDefaults setObject:info.lv  forKey:@"Userlv"];
                    [userDefaults setObject:[NSString stringWithFormat:@"%@",info.num ]forKey:@"coinNumber"];
                    [userDefaults synchronize];
                    isLoading=NO;
                    [self addMyInfo];
                }else{
                    
                    NSLog(@"%@",error);
                    
                }
                
                if ([[userDefaults objectForKey:@"userName"]isEqualToString:@""]) {
                    status.text=@"加载中";
                }else{
                    status.text=[userDefaults objectForKey:@"userName"];
                }
                LVbutton.hidden=NO;
                UILabel *Userlv=(UILabel *)[backView viewWithTag:52003];
                if ([userDefaults objectForKey:@"Userlv"]) {
                    Userlv.text=[NSString stringWithFormat:@"%@",[userDefaults objectForKey:@"Userlv"]];
                }else{
                    Userlv.text=@"1";
                }
                
                [userDefaults setObject:@"3" forKey:@"isLogin"];
                NSString* string4 = [[sssdic objectForKey:@"nick"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [userDefaults setObject:string4 forKey:@"userName"];
                [userDefaults setBool:[[sssdic objectForKey:@"sex"]intValue]==1?1:0 forKey:@"userGenders"];
                [userDefaults setObject:[sssdic objectForKey:@"email"] forKey:@"userEmail"];
                [userDefaults setObject:[sssdic objectForKey:@"birth"] forKey:@"userBirthday"];
                [userDefaults setObject:[sssdic objectForKey:@"detail"] forKey:@"introduce"];
                [userDefaults setObject:[sssdic objectForKey:@"bindtype"] forKey:@"RelateWxTips"];
                [userDefaults setObject:[sssdic objectForKey:@"city"] forKey:@"city"];
                if (![[sssdic objectForKey:@"headphoto"]isEqualToString:@""]) {
                    NSArray *arr=[[sssdic objectForKey:@"headphoto"]  componentsSeparatedByString:@"/"];
                    NSString *name=[NSString stringWithFormat:@"%@%@",arr[arr.count-2],[arr lastObject]];
                    [userDefaults setObject:name forKey:@"Newheadphoto"];
                }

                [userDefaults setObject:[NSString stringWithFormat:@"%@",[sssdic objectForKey:@"ww"] ]forKey:@"UserData"];
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
                
                [userDefaults synchronize];
                
                [self addUserName];
                
                
#pragma mark 获取头像
                if ([[userDefaults objectForKey:@"updatePhoto"]isEqualToString:@"1"]) {
                    HeadPhoto.image=[UIImage imageNamed:@"gm_photo"];
                }else {
                    if ([ RootUrl getIsNetOn]) {
                        [self loadHeadPhoto];
                    }
                }
                
                
                switch ([[sssdic objectForKey:@"city"] intValue]) {
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
                
                AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
                [app checkChannelsData];
                
                BackButton.hidden=NO;
                BackButton.userInteractionEnabled=YES;
                
                break;
            }
            default:
                break;
        }
    }
}
-(void)creatComView{
    
    NSLog(@"--------------creatComView");
    
    status.text=@"未登录";
    for (int i=0; i<3; i++) {
        UILabel *label=(UILabel *)[backView viewWithTag:52000+i];
        NSArray *title=@[@"0彩豆",@"0威望",@"消息"];
        label.text=title[i];
    }
    Tips.hidden=NO;
    loginBtn.hidden=NO;
    LVbutton.hidden=YES;
    UIImageView  *IMA=(UIImageView *)[backView viewWithTag:5210];
    IMA.hidden=YES;
    BackButton.hidden=YES;
    BackButton.userInteractionEnabled=NO;
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    
//    NSMutableArray * array=[NSMutableArray arrayWithArray:[[MyDatabase sharedDatabase] readData:1 count:0 model:[[PushInfoItem alloc]init] where:@"read" value:@"0"]];
    PushNews.hidden=YES;
    if ([[def objectForKey:@"newsNO"] integerValue] !=0) {
        PushNews.hidden=NO;
        UILabel *label=(UILabel *)[backView viewWithTag:53004];
        label.text=[NSString stringWithFormat:@"%@",[def objectForKey:@"newsNO"]];
    }else{
        PushNews.hidden=YES;
        UILabel *label=(UILabel *)[backView viewWithTag:53004];
        label.text=@"";
    }
    
}
-(void)creatHeadView{
    
    backView=[[UIView alloc]initWithFrame:CGRectMake(0,10, 320, 90+72)];
    //    backView.backgroundColor=[UIColor redColor];
    [MyScrollView addSubview:backView];
 
    
    HeadPhoto=[[UIImageView alloc]initWithFrame:CGRectMake(10, 18, 54, 54)];
    HeadPhoto.image=[UIImage imageNamed:@"gm_photo"];
    backView.backgroundColor=[UIColor whiteColor];
    backView.userInteractionEnabled=YES;
    [backView addSubview:HeadPhoto];
    
    UIImageView *bgimage=[[UIImageView alloc]initWithFrame:CGRectMake(10, 18, 54, 54)];
    bgimage.image=[UIImage imageNamed:@"HeadPhoto"];
    [backView addSubview:bgimage];
    
    status=[[UILabel alloc]initWithFrame:CGRectMake(80, 25, 200, 25)];
    status.textColor=[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
    status.font=[UIFont systemFontOfSize:17];
    status.tag=5110;
    [backView addSubview:status];
    
    BackButton=[[UIButton alloc]initWithFrame:CGRectMake(0,0, 320, 90)];
    [BackButton addTarget:self action:@selector(headBtn:) forControlEvents:UIControlEventTouchUpInside];
    [MyScrollView addSubview:BackButton];
    
    
    Tips=[[UILabel alloc]initWithFrame:CGRectMake(80, 50, 150, 20)];
    Tips.text=@"登录享受免费上网特权";
    Tips.textColor=[UIColor colorWithRed:128/255.0f green:128/255.0f blue:128/255.0f alpha:1];
    Tips.font=[UIFont systemFontOfSize:12];
    [backView addSubview:Tips];
    
    
    UIImage *image=[[UIImage imageNamed:@"gm_but"]stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    loginBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame=CGRectMake(230, 30, 80, 30);
    //    loginBtn.backgroundColor=[UIColor redColor];
    
    [loginBtn setBackgroundImage:image forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(LoginClick:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:loginBtn];
    
    //从add/Info移动到这
    im=[[UIImageView alloc]initWithFrame:CGRectMake(300, 44, 7, 11)];
    im.image=[UIImage imageNamed:@"arrow"];
    im.tag=5210;
    [backView addSubview:im];
    
    
    UIImage *level=[[UIImage imageNamed:@"huiyuan"]stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    LVbutton=[UIButton buttonWithType:UIButtonTypeCustom];
    LVbutton.frame=CGRectMake(80, 50, 55, 18);
    [LVbutton setBackgroundImage:level forState:UIControlStateNormal];
    [backView addSubview:LVbutton];
    
    
    
    UILabel *lv=[[UILabel alloc]initWithFrame:CGRectMake(1, 0, 45, 18)];
    lv.tag=52003;
    lv.backgroundColor=[UIColor clearColor];
    lv.textColor=[UIColor whiteColor];
    lv.textAlignment=NSTextAlignmentCenter;
    lv.font=[UIFont systemFontOfSize:12];
    [LVbutton addSubview:lv];
    
    
    ///////////////
    
    for (int i=0; i<3; i++) {
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(107*i+8, 135, 90, 20)];
        label.textAlignment=NSTextAlignmentCenter;
        label.font=[UIFont systemFontOfSize:14];
        label.backgroundColor=[UIColor clearColor];
        label.tag=52000+i;
        label.textColor=[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
        [backView addSubview:label];
    }
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 30)];
    label.textColor=[UIColor whiteColor];
    label.backgroundColor=[UIColor clearColor];
    label.textAlignment=NSTextAlignmentCenter;
    label.font=[UIFont systemFontOfSize:14];
    label.text=@"登录/注册";
    [loginBtn addSubview:label];
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0,0,320, 0.5)];
    lineView.backgroundColor=[UIColor colorWithRed:215/255.f green:217/255.f blue:223/255.f alpha:0.7];
    [backView addSubview:lineView];
    
    UIView *lineView1=[[UIView alloc]initWithFrame:CGRectMake(0,90,320, 0.5)];
    lineView1.backgroundColor=[UIColor colorWithRed:215/255.f green:217/255.f blue:223/255.f alpha:0.7];
    [backView addSubview:lineView1];
    
    UIView *lineView2=[[UIView alloc]initWithFrame:CGRectMake(0,90+72,320, 0.5)];
    lineView2.backgroundColor=[UIColor colorWithRed:215/255.f green:217/255.f blue:223/255.f alpha:0.7];
    [backView addSubview:lineView2];
    
    NSArray *images=@[@"gm_jinbi",@"vip",@"xiaoxi"];
    for (int i=0; i<3; i++) {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(36+107*i, 100, 32, 32);
        [button setBackgroundImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(btn:) forControlEvents:UIControlEventTouchUpInside];
        button.tag=5001+i;
        [backView addSubview:button];
        
        UIView *lineView1=[[UIView alloc]initWithFrame:CGRectMake(107*((i%2)+1),105,0.5, 42)];
        lineView1.backgroundColor=[UIColor colorWithRed:215/255.f green:217/255.f blue:223/255.f alpha:0.7];
        [backView addSubview:lineView1];
    }
    
    
    PushNews=[[UIImageView alloc]initWithFrame:CGRectMake(273, 100, 20, 15)];
    PushNews.image=[UIImage imageNamed:@"bg_red"];
    [backView addSubview:PushNews];
    
    UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(247+25, 99, 20, 15)];
    label2.textAlignment=NSTextAlignmentCenter;
    label2.font=[UIFont systemFontOfSize:13];
    label2.backgroundColor=[UIColor clearColor];
    label2.textColor=[UIColor whiteColor];
    label2.tag=53004;
    [backView addSubview:label2];
    
}
-(void)headBtn:(UIButton *)button{
    
    //用户资料 调用
    UserDataViewController *userData=[[UserDataViewController alloc]init];
    
    [self.navigationController presentViewController:userData animated:YES completion:^{}];
    
}
-(void)addUserName{
    
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    
    if ([[def objectForKey:@"userName"]isEqualToString:@""]) {
        status.text=@"起个响亮的名字";
    }else{
        status.text=[def objectForKey:@"userName"];
        
    }
    LVbutton.hidden=NO;
    UILabel *label=(UILabel *)[backView viewWithTag:52003];
    if ([def objectForKey:@"Userlv"]) {
        label.text=[NSString stringWithFormat:@"%@",[def objectForKey:@"Userlv"]];
    }else{
        label.text=@"1";
    }
    
    
    UILabel *label2=(UILabel *)[backView viewWithTag:52001];
    label2.textAlignment=NSTextAlignmentCenter;
    if ([def objectForKey:@"UserData"]) {
        label2.text=[NSString stringWithFormat:@"%@威望",[def objectForKey:@"UserData"]];
        
    }else{
        label2.text=@"0威望";
    }

    
}
-(void)addMyInfo{
    
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    
    UILabel *label=(UILabel *)[backView viewWithTag:52000];
    label.textAlignment=NSTextAlignmentCenter;
    if ([def objectForKey:@"coinNumber"]) {
        label.text=[NSString stringWithFormat:@"%@彩豆",[def objectForKey:@"coinNumber"]];
    }else{
        label.text=@"0彩豆";
    }
    
    UILabel *label2=(UILabel *)[backView viewWithTag:52002];
    label2.textAlignment=NSTextAlignmentCenter;
    label2.text=@"消息";
    PushNews.hidden=YES;
    if ([[def objectForKey:@"newsNO"] integerValue] !=0) {
        PushNews.hidden=NO;
        UILabel *label=(UILabel *)[backView viewWithTag:53004];
        label.text=[NSString stringWithFormat:@"%@",[def objectForKey:@"newsNO"]];
    }else{
            
        PushNews.hidden=YES;
        UILabel *label=(UILabel *)[backView viewWithTag:53004];
        label.text=@"";
    }
    
}

-(void)LoginClick:(UIButton *)button{
    NSLog(@"登录");
    
    LoginViewController *login =[[LoginViewController alloc]init];
    //设置loginTag为1登录成功后调用代理方法
    login.delegate=self;
    [self presentViewController:login animated:YES completion:^{}];
    
}
-(void)loginSuccessWithTag:(int)tag{
    
    NSLog(@"登录成功");
    
    //推送消息 接受到得方法在Appdelegate里- (void)networkDidReceiveMessage:(NSNotification *)notification   可以和用户体系消息一起存到一个数据库表中
}

-(void)requestFinished:(HttpRequest *)request{
    
    [curTaskDict removeObjectForKey:request.httpUrl];
    NSError *error;
    NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:request.downloadData options:NSJSONReadingMutableContainers error:&error];
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    
    if (dict) {
        isLoading=NO;
        [def setObject:[dict objectForKey:@"InvitePin"] forKey:@"InvitePin"];
        [def setObject:[dict objectForKey:@"data"] forKey:@"InviteData"];
        [def synchronize];
    }else{  
        
        NSLog(@"error description:%@",[error description]);
    }
    
}

-(void)creatBottomView{
    
    UIView *setBag=[[UIView alloc]initWithFrame:CGRectMake(0, 182, 320,44)];
    setBag.backgroundColor=[UIColor whiteColor];
    [MyScrollView addSubview:setBag];
    
    
    UIView *lineView5=[[UIView alloc]initWithFrame:CGRectMake(0,0,320, 0.5)];
    lineView5.backgroundColor=[UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:0.7];
    [setBag addSubview:lineView5];
    
    UIView *lineView4=[[UIView alloc]initWithFrame:CGRectMake(0,44,320, 0.5)];
    lineView4.backgroundColor=[UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:0.7];
    [setBag addSubview:lineView4];
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0, 0, 320, 44);
    button.tag=5200;
    [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [setBag addSubview:button];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(52, 12, 100, 20)];
    label.text=@"兑换中心";
    label.textColor=[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
    label.font=[UIFont systemFontOfSize:15];
    [button addSubview:label];
    
    UIImageView *imView=[[UIImageView alloc]initWithFrame:CGRectMake(300, 17, 7, 11)];
    imView.image=[UIImage imageNamed:@"arrow"];
    [button addSubview:imView];
    
    UIImageView *head=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 24, 24)];
    head.image=[UIImage imageNamed:@"gm_store"];
    [button addSubview:head];
    
    if (NumOfShowList) {
        [self creatInvitation];
    }
    
    [self creatNewView];
    
//    [self creatTest];
}

-(void)creatTest{

    
    UIView *setBag=[[UIView alloc]initWithFrame:CGRectMake(0, 182+44+10+44+10+100, 320,44)];
    setBag.backgroundColor=[UIColor whiteColor];
    [MyScrollView addSubview:setBag];
    
    
    UIView *lineView5=[[UIView alloc]initWithFrame:CGRectMake(0,0,320, 0.5)];
    lineView5.backgroundColor=[UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:0.7];
    [setBag addSubview:lineView5];
    
    UIView *lineView4=[[UIView alloc]initWithFrame:CGRectMake(0,44,320, 0.5)];
    lineView4.backgroundColor=[UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:0.7];
    [setBag addSubview:lineView4];
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0, 0, 320, 44);
    button.tag=5209;
    [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [setBag addSubview:button];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(52, 12, 100, 20)];
    label.text=@"站点测试";
    label.textColor=[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
    label.font=[UIFont systemFontOfSize:15];
    [button addSubview:label];
    
    UIImageView *imView=[[UIImageView alloc]initWithFrame:CGRectMake(300, 17, 7, 11)];
    imView.image=[UIImage imageNamed:@"arrow"];
    [button addSubview:imView];
    
    UIImageView *head=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 24, 24)];
    head.image=[UIImage imageNamed:@"gm_store"];
    [button addSubview:head];
    
}
-(void)creatNewView{
    NSArray *titles=@[@"我的卡包",@"我的下载"];
    NSArray *headImage=@[@"kabao",@"gm_down"];
    
    UIView *textBg=[[UIView alloc]initWithFrame:CGRectMake(0, 182+44*NumOfShowList+10*NumOfShowList+44+10, 320,135-44)];
    textBg.backgroundColor=[UIColor whiteColor];
    [MyScrollView addSubview:textBg];
    
    UIView *lineView1=[[UIView alloc]initWithFrame:CGRectMake(0,0,320, 0.5)];
    lineView1.backgroundColor=[UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:0.7];
    [textBg addSubview:lineView1];
    
    UIView *lineView2=[[UIView alloc]initWithFrame:CGRectMake(10,45,310, 0.5)];
    lineView2.backgroundColor=[UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:0.7];
    [textBg addSubview:lineView2];
    
    UIView *lineView3=[[UIView alloc]initWithFrame:CGRectMake(0,90  ,320, 0.5)];
    lineView3.backgroundColor=[UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:0.7];
    [textBg addSubview:lineView3];
    
    
    
    redPoint=[[UIImageView alloc]initWithFrame:CGRectMake(110,12, 6 ,6 )];
    redPoint.image=[UIImage imageNamed:@"redPoind"];
    [textBg addSubview:redPoint];
    redPoint.hidden=YES;
    
    
    for (int i=0; i<2; i++) {
        
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(0, 45*i, 320, 44);
        button.tag=5202+i;
        
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [textBg addSubview:button];
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(50, 12, 100, 20)];
        label.text=titles[i];
        label.textColor=[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
        label.font=[UIFont systemFontOfSize:15];
        [button addSubview:label];
        
        UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(300, 17, 7, 11)];
        image.image=[UIImage imageNamed:@"arrow"];
        [button addSubview:image];
        
        UIImageView *head=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 24, 24)];
        head.image=[UIImage imageNamed:headImage[i]];
        [button addSubview:head];
    }

    
}
-(void)creatInvitation{
    
    UIView *setBag=[[UIView alloc]initWithFrame:CGRectMake(0, 182+44+10, 320,44)];
    setBag.backgroundColor=[UIColor whiteColor];
    [MyScrollView addSubview:setBag];
    
    UIView *lineView5=[[UIView alloc]initWithFrame:CGRectMake(0,0,320, 0.5)];
    lineView5.backgroundColor=[UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:0.7];
    [setBag addSubview:lineView5];
    
    UIView *lineView4=[[UIView alloc]initWithFrame:CGRectMake(0,44,320, 0.5)];
    lineView4.backgroundColor=[UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:0.7];
    [setBag addSubview:lineView4];
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0, 0, 320, 44);
    button.tag=5201;
    [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [setBag addSubview:button];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(52, 12, 100, 20)];
    label.text=@"我的好友";
    label.textColor=[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
    label.font=[UIFont systemFontOfSize:15];
    [button addSubview:label];
    
    UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(170, 12, 120, 20)];
    label2.text=@"邀请成功获取彩豆";
    label2.textAlignment=NSTextAlignmentRight;
    label2.textColor=[UIColor colorWithRed:80/255.0f green:80/255.0f blue:80/255.0f alpha:1];
    label2.font=[UIFont systemFontOfSize:13];
    [button addSubview:label2];
    
    UIImageView *imView=[[UIImageView alloc]initWithFrame:CGRectMake(300, 17, 7, 11)];
    imView.image=[UIImage imageNamed:@"arrow"];
    [button addSubview:imView];
    
    UIImageView *head=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 24, 24)];
    head.image=[UIImage imageNamed:@"icon_fri"];
    [button addSubview:head];
    
}
-(void)btn:(UIButton *)button{
    
    
    NSUserDefaults * userDefault=[NSUserDefaults standardUserDefaults];
    int isLogin=[[userDefault objectForKey:@"isLogin"]intValue];
    
    if (isLogin>1) {
        switch (button.tag-5001) {
            case 0:
            {
                MyCoinBillViewController *myCoin=[[MyCoinBillViewController alloc]init];
                //获取的总彩豆数
                //myCoin.myCoinNumber=coinNumber;
                myCoin.Type=@"1";
                [self.navigationController pushViewController:myCoin animated:YES];
                
            }
                break;
            case 1:
            {
                
                MyCoinBillViewController *myCoin=[[MyCoinBillViewController alloc]init];
                //获取的总彩豆数
                //myCoin.myCoinNumber=coinNumber;
                myCoin.Type=@"0";
                [self.navigationController pushViewController:myCoin animated:YES];
                
                
            }
                break;

                
            default:
                break;
        }
    }else{
        
        AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
        [app setNotice:@"未登录，请先登录/注册"];
    }
    if (button.tag==5003) {
        
        GM_PushNewsViewController *gvc=[[GM_PushNewsViewController alloc]init];
     
        [self.navigationController pushViewController:gvc animated:YES];
    }
    
}
-(void)btnClick:(UIButton *)button{
    
    NSLog(@"%ld",(long)button.tag);
    
    switch (button.tag-5200) {
        case 0:
        {
            
            UserShopViewController *userShop=[[UserShopViewController alloc]init];
            
            NSLog(@"商城");
            [self.navigationController pushViewController:userShop animated:YES];
            
        }
            break;
        case 1:
        {
            NSDictionary *dict = @{@"type" : @"邀请好友"};
            [MobClick event:@"earn_click" attributes:dict];
            NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
            if ([[def objectForKey:@"isLogin"]integerValue]<2) {
                
                LoginViewController *login =[[LoginViewController alloc]init];
                //设置loginTag为1登录成功后调用代理方法
                
                login.delegate=self;
                [self presentViewController:login animated:YES completion:^{}];
                
                
            }else{
                InviteViewController *ivc=[[InviteViewController alloc]init];
                [self.navigationController pushViewController:ivc animated:YES];
            }
            
        }
            break;
        case 2:
        {
            
            MyOwnObjectViewController *modelViewCtr=[[MyOwnObjectViewController alloc]init];
            [self.navigationController pushViewController:modelViewCtr animated:YES];
            
              [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"addGoods"];
            
        }
            break;
        case 3:
        {
            MyVideoViewController *guide=[[MyVideoViewController alloc]init];
            
            [self.navigationController pushViewController:guide animated:YES];

        }
            break;
            
        case 9:
        {
            SearchViewController *searchCtr=[[SearchViewController alloc]init];
            searchCtr.isLineOfTurn=1;
            searchCtr.tag=430;
            //   [self presentViewController:searchCtr animated:YES completion:^{}];
            [self.navigationController pushViewController:searchCtr animated:YES];
            
        }
            break;
            
        default:
            break;
    }
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [MobClick endLogPageView:@"user"];
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    if ([[def objectForKey:@"newsNO"] integerValue] !=0) {
    
        [[self.tabBarController.tabBar viewWithTag:250120]setHidden:NO];
    }else{

        [[self.tabBarController.tabBar viewWithTag:250120]setHidden:YES];
    }
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    NumOfShowList=[[[NSUserDefaults standardUserDefaults] objectForKey:@"IsPass"] boolValue]?0:1;
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    
    if ([[def objectForKey:@"newsNO"] integerValue] !=0) {
        PushNews.hidden=NO;
        UILabel *label=(UILabel *)[backView viewWithTag:53004];
        label.text=[NSString stringWithFormat:@"%@",[def objectForKey:@"newsNO"]];
        [[self.tabBarController.tabBar viewWithTag:250120]setHidden:NO];
    }else{
        PushNews.hidden=YES;
        UILabel *label=(UILabel *)[backView viewWithTag:53004];
        label.text=@"";
        [[self.tabBarController.tabBar viewWithTag:250120]setHidden:YES];
    }
    
    NSDictionary *dict = @{@"type" : @"我"};
    [MobClick event:@"page_select" attributes:dict];
    [MobClick beginLogPageView:@"user"];
    if ([RootUrl getUMLogClickFlag]) {
        NSDictionary *dict2 = @{@"type" : @"inuser"};
        [MobClick event:@"loginNet_isRun" attributes:dict2];
        [RootUrl setUMLogClickFlag:0];
    }
    self.tabBarController.tabBar.hidden=NO;
    self.navigationController.navigationBar.hidden=YES;
    
    NSLog(@"viewWillApper:%@",[def objectForKey:@"isLogin"]);
    
    if ([[def objectForKey:@"isLogin"]integerValue]<2) {
        UIImageView  *IMA=(UIImageView *)[backView viewWithTag:5210];
        IMA.hidden=YES;
        BackButton.hidden=YES;
        BackButton.userInteractionEnabled=NO;
        [self creatComView];
        status.text=@"未登录";
        im.hidden=YES;
        LVbutton.hidden=YES;
        HeadPhoto.image=[UIImage imageNamed:@"gm_photo"];
        if([RootUrl getIsNetOn]){
            
           [[HttpManager sharedManager]stopAllTask:curTaskDict];
        }
        //        [BackButton removeFromSuperview];
        
    }else{
        loginBtn.hidden=YES;
        Tips.hidden=YES;
        im.hidden=NO;
        LVbutton.hidden=NO;
        status.hidden=NO;
        
#pragma mark 这里请求用户的信息
        //这里请求用户的信息
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"hhmmss"];
        NSUserDefaults *userDef=[NSUserDefaults standardUserDefaults];
        NSString *QString=[NSString stringWithFormat:@"mod=getwwuserinfo&phone=%@&ntime=%@",[userDef objectForKey:@"userPhone"],[dateformatter stringFromDate:[NSDate date]]];
        NSData *secretData=[QString dataUsingEncoding:NSUTF8StringEncoding];
        NSData *qValueData=[secretData AES256EncryptWithKey:SECRETKEY];
        NSString *qValue=[qValueData newStringInBase64FromData];

        if([RootUrl getIsNetOn]||[[GetCMCCIpAdress getSSID]isEqualToString:@"16wifi"]){
    
            [self addTask:[NSString stringWithFormat:@"%@/app_api/userInfo/getUserInfo.html?q=%@",NewBaseUrl,qValue] action:@selector(NewUserInfoRequest:)];
            
            [self getRecommendCode];

        }

    }
    
    
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"addGoods"]isEqualToString:@"1"]) {
        
        redPoint.hidden=NO;
        
    }else{
        
        redPoint.hidden=YES;
    }
    
    
#pragma mark 修改后上传头像
    if ([[def objectForKey:@"updatePhoto"]isEqualToString:@"1"]) {
        
        NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *path=[NSString stringWithFormat:@"%@/%@-%@",documentsDirectoryPath,[def objectForKey:@"userPhone"],[def objectForKey:@"Newheadphoto"]];
        
        NSMutableDictionary *pa = [NSMutableDictionary dictionaryWithCapacity:1];
        [pa setValue:@"setheadphoto" forKey:@"mod"];
        [pa setValue:path forKey:@"headphoto"];
        [pa setValue:[def objectForKey:@"userID"] forKey:@"uid"];
        
        if ([RootUrl getIsNetOn]) {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

                dispatch_async(dispatch_get_main_queue(), ^{

                    AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
                    [app uploadImage: [NSString stringWithFormat:@"%@/app_api/userInfo/uploadHeadPhoto.html",NewBaseUrl] param:pa format:@"image/jpg"];
            
                });
            });
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
 
    [self addTask:[NSString stringWithFormat:@"%@/app_api/userInfo/getMyFriendList.html?q=%@",NewBaseUrl,qValue2] action:@selector(requestFinished:)];
}


-(void)loadHeadPhoto{
    
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"hhmmss"];
    NSUserDefaults *userDef=[NSUserDefaults standardUserDefaults];
    
    NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *path=[NSString stringWithFormat:@"%@/%@-%@",documentsDirectoryPath,[userDef objectForKey:@"userPhone"],[userDef objectForKey:@"Newheadphoto"]];
    
    HeadPhoto.image=[UIImage imageWithData:[NSData dataWithContentsOfFile:path]];
    
    NSString *QString2=[NSString stringWithFormat:@"mod=loadheadphoto&uid=%@&ntime=%@",[userDef objectForKey:@"userID"],[dateformatter stringFromDate:[NSDate date]]];
    NSData *secretData2=[QString2 dataUsingEncoding:NSUTF8StringEncoding];
    NSData *qValueData2=[secretData2 AES256EncryptWithKey:SECRETKEY];
    NSString *qValue2=[qValueData2 newStringInBase64FromData];
    [self addTask:[NSString stringWithFormat:@"%@/app_api/userInfo/getHeadPhoto.html?q=%@",NewBaseUrl,qValue2] action:@selector(HeadPhotoRequest:)];
    
}

-(void)dealloc{

    [[HttpManager sharedManager]stopAllTask:curTaskDict];
    
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
