//
//  FriendsInforViewController.m
//  e-RoadWiFi
//
//  Created by MacMini on 15/4/27.
//  Copyright (c) 2015年 G.MING. All rights reserved.
//

#import "FriendsInforViewController.h"
#import "UIImageView+WebCache.h"
#import "GetCMCCIpAdress.h"
#import "Encryption.h"
#import "RootUrl.h"
#import "HttpRequest.h"
#import "HttpManager.h"
#import "MyDatabase.h"
#import "cityItem.h"
@interface FriendsInforViewController ()

@end

@implementation FriendsInforViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self addNavAndTitle:@"我的好友" withFrame:CGRectMake(0, 0, 320, 44+SIZEABOUTIOSVERSION)];
    
    _scrollerView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 44+SIZEABOUTIOSVERSION, 320,SCREENHEIGHT-44-SIZEABOUTIOSVERSION)];
//    _scrollerView.backgroundColor=[UIColor whiteColor];
    _scrollerView.backgroundColor=[UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1];
    _scrollerView.showsHorizontalScrollIndicator=NO;
    _scrollerView.showsVerticalScrollIndicator=NO;
    _scrollerView.contentSize=CGSizeMake(320, SCREENHEIGHT-44-SIZEABOUTIOSVERSION);
    [self.view addSubview:_scrollerView];
    
    [self creatInfo];
    // Do any additional setup after loading the view.
}

-(void)creatInfo{

    UIImageView*  HeadPhoto=[[UIImageView alloc]initWithFrame:CGRectMake(10, 11+5, 54, 54)];
    if ([[_DataDic objectForKey:@"headphoto"]hasPrefix:@"http"]) {
            [HeadPhoto setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[_DataDic objectForKey:@"headphoto"]]] placeholderImage:[UIImage imageNamed:@"gm_photo"]];
    }else{
    
            [HeadPhoto setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FormalBaseUrl,[_DataDic objectForKey:@"headphoto"]]] placeholderImage:[UIImage imageNamed:@"gm_photo"]];
    }

    HeadPhoto.tag=15042600;
    [_scrollerView addSubview:HeadPhoto];
    
    
    UIImageView *bgimage=[[UIImageView alloc]initWithFrame:CGRectMake(10, 11+5, 54, 54)];
    bgimage.image=[UIImage imageNamed:@"HeadPhoto00"];
    [_scrollerView addSubview:bgimage];
    
    UILabel *name=[[UILabel alloc]initWithFrame:CGRectMake(10+54+15, 10+5, 100, 25)];
    name.backgroundColor=[UIColor clearColor];
    name.font=[UIFont systemFontOfSize:15];
    name.tag=15042601;
    if ([[_DataDic objectForKey:@"nick"]isEqualToString:@""]) {
        name.text=@"昵称";
    }else{
        name.text=[_DataDic objectForKey:@"nick"];
    }
    
    CGSize maxSize=CGSizeMake(SCREENWIDTH-10-54-15-65,25);
    
    CGSize realSize=[name.text boundingRectWithSize:maxSize  options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:name.font} context:nil].size;
    name.frame=CGRectMake(10+54+15, 10+5, realSize.width, 25);
    name.textAlignment=NSTextAlignmentLeft;
    [_scrollerView addSubview:name];
    
    
    UILabel *introduce=[[UILabel alloc]initWithFrame:CGRectMake(10+54+15, 10+35, 220, 25)];
    introduce.backgroundColor=[UIColor clearColor];
    introduce.textAlignment=NSTextAlignmentLeft;
    introduce.tag=15042602;
    if ([[_DataDic objectForKey:@"detail"]isEqualToString:@""]) {
        introduce.text=@"还没介绍自己";
    }else{
        introduce.text=[_DataDic objectForKey:@"detail"];
    }
    
    introduce.textColor=[UIColor colorWithRed:80/255.0f green:80/255.0f blue:80/255.0f alpha:1];
    introduce.font=[UIFont systemFontOfSize:13];
    [_scrollerView addSubview:introduce];
    
    
    UIImageView *level=[[UIImageView alloc]initWithFrame:CGRectMake(85+name.frame.size.width, 12+5, 55, 18)];
    level.image=[[UIImage imageNamed:@"huiyuan"]stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    [_scrollerView addSubview:level];
    
    
    UILabel *lv=[[UILabel alloc]initWithFrame:CGRectMake(1, 0, 45, 18)];
    lv.backgroundColor=[UIColor clearColor];
    lv.textColor=[UIColor whiteColor];
    lv.textAlignment=NSTextAlignmentCenter;
    lv.tag=15042603;
    lv.text=[NSString stringWithFormat:@"%@",[_DataDic objectForKey:@"lv"]];
    lv.font=[UIFont systemFontOfSize:12];
    [level addSubview:lv];

    [self creatDetail];
}

-(void)creatDetail{


    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    
    NSArray *titles=@[@"地区",@"性别",@"威望",@"加入时间",@"状态"];
    NSArray *keys=@[@"FsCity",@"FsSex",@"weiwang"];
    UIView *textBg=[[UIView alloc]initWithFrame:CGRectMake(0, 92, 320,45*5)];

    
    textBg.backgroundColor=[UIColor whiteColor];
    [_scrollerView addSubview:textBg];
    
    UIView *lineView1=[[UIView alloc]initWithFrame:CGRectMake(0,0,320, 0.5)];
    lineView1.backgroundColor=[UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:0.7];
    [textBg addSubview:lineView1];
    
    for (int i=0; i<4; i++) {
        
        UIView *lineView2=[[UIView alloc]initWithFrame:CGRectMake(10,45*i+45,310, 0.5)];
        lineView2.backgroundColor=[UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:0.7];
        [textBg addSubview:lineView2];
        
    }

    UIView *lineView3=[[UIView alloc]initWithFrame:CGRectMake(0,45*5  ,320, 0.5)];
    lineView3.backgroundColor=[UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:0.7];
    [textBg addSubview:lineView3];


    for (int i=0; i<titles.count; i++) {
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 12+45*i, 100, 20)];
        label.text=titles[i];
        label.font=[UIFont systemFontOfSize:15];
        [textBg addSubview:label];
        
        UILabel *Detaillabel=[[UILabel alloc]initWithFrame:CGRectMake(110, 12+45*i, 100, 20)];
        Detaillabel.textColor=[UIColor colorWithRed:80/255.0f green:80/255.0f blue:80/255.0f alpha:0.6];
        Detaillabel.font=[UIFont systemFontOfSize:15];
        Detaillabel.tag=15042510+i;
        [textBg addSubview:Detaillabel];
       
        NSLog(@"friendsInfo%@",[def objectForKey:@"friendsInfo"]);
        
        if ([[[def objectForKey:@"friendsInfo"]objectForKey:@"new"]isEqualToString:@"1"]) {
            
            if (i<=2) {
                Detaillabel.text=[[def objectForKey:@"friendsInfo"] objectForKey:keys[i]];
            }

        }else{
            if (i<=2) {
                Detaillabel.text=@"加载中";
                _Refresh=YES;
            }
            
        }
        
        if (i==3) {
               Detaillabel.text=[_DataDic objectForKey:@"dateline"];
        }
        if (i==4) {
               Detaillabel.text=@"已是好友";
        }
        
    }
    
    
}
-(void)viewDidAppear:(BOOL)animated{

    if (_Refresh) {
        
        //这里请求用户的信息
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"hhmmss"];
        NSString *QString=[NSString stringWithFormat:@"mod=getwwuserinfo&phone=%@&ntime=%@",[_DataDic objectForKey:@"phone"],[dateformatter stringFromDate:[NSDate date]]];
        NSData *secretData=[QString dataUsingEncoding:NSUTF8StringEncoding];
        NSData *qValueData=[secretData AES256EncryptWithKey:SECRETKEY];
        NSString *qValue=[qValueData newStringInBase64FromData];
        if([RootUrl getIsNetOn]||[[GetCMCCIpAdress getSSID]isEqualToString:@"16wifi"]){
            [self addTask:[NSString stringWithFormat:@"%@/app_api/userInfo/getUserInfo.html?q=%@",NewBaseUrl,qValue] action:@selector(ListuserInfoRequest:)];
        }
        

        
    }
}

-(void)viewWillDisappear:(BOOL)animated{

    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]initWithDictionary:[def objectForKey:@"friendsInfo"]];
    [dic setObject:@"0" forKey:@"new"];
    
    [def setObject:dic forKey:@"friendsInfo"];
    [def synchronize];
    
}
-(void)ListuserInfoRequest:(HttpRequest *)infoRequest{
    
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
                NSLog(@"q修改资料");
                
#pragma mark 设置城市 性别
                NSMutableArray *array=[[NSMutableArray alloc]init];
                NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
                
                if ([[sssdic objectForKey:@"city"]isEqualToString:@"1"]||[[sssdic objectForKey:@"city"]isEqualToString:@"0"]) {
                    array=[NSMutableArray arrayWithArray: [[MyDatabase sharedDatabase]readData:1 count:0 model:[[cityItem alloc]init] where:@"city_id" value:@"0"]];
                }else{
                    array=[NSMutableArray arrayWithArray: [[MyDatabase sharedDatabase]readData:1 count:0 model:[[cityItem alloc]init] where:@"city_id" value:[sssdic objectForKey:@"city"]]];
                }
                if (array.count) {
                    cityItem *item=array[0];
                    [dic setObject:item.city_name forKey:@"FsCity"];
                    
                }
                
                if ([[sssdic objectForKey:@"sex"] integerValue]==1) {
                     [dic setObject:@"男"forKey:@"FsSex"];
                  
                }else{
                     [dic setObject:@"女" forKey:@"FsSex"];
                }
                
                [dic setObject:[NSString stringWithFormat:@"%@",[sssdic objectForKey:@"ww"] ]forKey:@"weiwang"];
                [dic setObject:@"1" forKey:@"new"];
                [userDefaults setObject:dic forKey:@"friendsInfo"];
                [userDefaults synchronize];
                
                [self addValue];
                break;
            }
            default:
                break;
        }
    }
}

-(void)addValue{

    NSArray *keys=@[@"FsCity",@"FsSex",@"weiwang"];
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    for (int i=0; i<3; i++) {
        UILabel *label=(UILabel *)[self.view viewWithTag:15042510+i];
        label.text=[[def objectForKey:@"friendsInfo"] objectForKey:keys[i]];
        NSLog(@"text%@  def%@",label.text,[def objectForKey:@"friendsInfo"]);
        _Refresh=NO;
        
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
