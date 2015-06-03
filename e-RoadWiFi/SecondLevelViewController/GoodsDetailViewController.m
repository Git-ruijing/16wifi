//
//  GoodsDetailViewController.m
//  e路WiFi
//
//  Created by JAY on 14-3-26.
//  Copyright (c) 2014年 HE ZHENJIE. All rights reserved.
//

#import "GoodsDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "MobClick.h"
#import "RootUrl.h"
#import "GetCMCCIpAdress.h"
#import "MyOwnObjectViewController.h"
#define ROOTURLFORBANNER @"http://111.13.47.155/usersystem/"
@interface GoodsDetailViewController ()

@end

@implementation GoodsDetailViewController
@synthesize goodsItem,isGet,GoodsStatus;
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

    [MobClick beginLogPageView:@"gooddetail"];
    self.tabBarController.tabBar.hidden=YES;
    [self.navigationController setNavigationBarHidden:YES];
    [self hideTabBar];
}
- (void)hideTabBar {
    if (self.tabBarController.tabBar.hidden == YES) {
        return;
    }
    UIView *contentView;
    if ( [[self.tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] ){
        contentView = [self.tabBarController.view.subviews objectAtIndex:1];
    }
    else{
        contentView = [self.tabBarController.view.subviews objectAtIndex:0];
        contentView.frame = CGRectMake(contentView.bounds.origin.x,  contentView.bounds.origin.y,  contentView.bounds.size.width, contentView.bounds.size.height + self.tabBarController.tabBar.frame.size.height);
        self.tabBarController.tabBar.hidden = YES;
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [MobClick endLogPageView:@"gooddetail"];
}
-(void)buildLoadingAnimat{
    aniBg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 77, 77)];
    aniBg.image=[UIImage imageNamed:@"jiazaibg"];
    NSArray *imageArray=[NSArray arrayWithObjects:[UIImage imageNamed:@"tu1"],[UIImage imageNamed:@"tu2"],[UIImage imageNamed:@"tu3"],[UIImage imageNamed:@"tu4"], nil];
    loadingAni=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 77,77)];
    loadingAni.image=[UIImage imageNamed:@"tu1"];
    loadingAni.animationImages =imageArray;
    loadingAni.animationDuration = [loadingAni.animationImages count] * 1/5.0;
    loadingAni.animationRepeatCount = 100000;
    flag=0;
    loadingAni.center=aniBg.center;
    [aniBg addSubview:loadingAni];
    aniBg.center=CGPointMake(self.view.center.x, self.view.center.y+40);
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
    self.view.backgroundColor=[UIColor whiteColor];
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    UIView * headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 44+SIZEABOUTIOSVERSION)];
    UIImageView *headerBackground=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320,44+SIZEABOUTIOSVERSION)];
    [headerView addSubview:headerBackground];
    headerBackground.image=[[UIImage imageNamed:@"gm_nav"]stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    [self.view addSubview:headerView];
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(110, 10+SIZEABOUTIOSVERSION, 100, 30)];
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.font=[UIFont systemFontOfSize:20];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [headerView addSubview:titleLabel];
    titleLabel.text=@"商品详情";
    
    MyButton * goBack=[MyButton buttonWithType:UIButtonTypeCustom];
    goBack.frame=CGRectMake(0, SIZEABOUTIOSVERSION,50, 44);
    [goBack setNormalImage:[UIImage imageNamed:@"newBack"]];
    [goBack setSelectedImage:[UIImage imageNamed:@"newBack_d"]];
    [headerView addSubview:goBack];
    [goBack addTarget:self action:@selector(goBackToSuperPage)];
    
    UIScrollView *scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0,44+SIZEABOUTIOSVERSION, 320, SCREENHEIGHT-44-SIZEABOUTIOSVERSION-54)];
    scrollView.backgroundColor=[UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1];
    [self.view addSubview:scrollView];
    
    UIView *bgview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 160)];
    bgview.backgroundColor=[UIColor whiteColor];
    [scrollView addSubview:bgview];
    
    UIImageView * bigImageOfGoods=[[UIImageView alloc]initWithFrame:CGRectMake(36,14,248,132)];
    NSURL *bigImageUrl;
    if ([[goodsItem.goodsImagesArray objectAtIndex:1]hasPrefix:@"http"]) {
        bigImageUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[goodsItem.goodsImagesArray objectAtIndex:1]]];
    }else{
        bigImageUrl=[NSURL URLWithString:[NSString stringWithFormat:@"http://m.16wifi.com/recommend/shoplist/%@",[goodsItem.goodsImagesArray objectAtIndex:1]]];
        
    }

    [bigImageOfGoods setImageWithURL:bigImageUrl placeholderImage:[UIImage imageNamed:@"down_1"]];
    [bgview addSubview:bigImageOfGoods];
    
    UILabel * goodsNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 160+143-134,300,25)];
    goodsNameLabel.backgroundColor=[UIColor clearColor];
    goodsNameLabel.textColor=[UIColor blackColor];
    goodsNameLabel.font=[UIFont systemFontOfSize:17 ];
    goodsNameLabel.text=goodsItem.goodsName;
    CGSize maxsize=CGSizeMake(250, 25);
    CGSize nameSize=[goodsItem.goodsName boundingRectWithSize:maxsize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:goodsNameLabel.font} context:nil].size;
    
//    goodsNameLabel.frame=CGRectMake(10, 160+143-134, nameSize.width+20, 25);
    [scrollView addSubview:goodsNameLabel];
    UILabel * goodsSpec=[[UILabel alloc]initWithFrame:CGRectMake(5+nameSize.width,167+138-134,200, 17)];
    goodsSpec.backgroundColor=[UIColor clearColor];
    goodsSpec.font=[UIFont systemFontOfSize:13];
    goodsSpec.text=goodsItem.goodsAbout;
    goodsSpec.textColor=[UIColor colorWithRed:128/255.f green:128/255.f blue:128/255.f alpha:1.0];
    CGSize specSize=[goodsSpec.text boundingRectWithSize:maxsize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:goodsSpec.font} context:nil].size;
    
    goodsSpec.frame=CGRectMake(5+nameSize.width,167+138,specSize.width, 17);
    //商品分类
//    [scrollView addSubview:goodsSpec];
    
    UILabel * duihuanjine=[[UILabel alloc]initWithFrame:CGRectMake(10,192+138-134,100,20)];
    duihuanjine.text=@"兑换金额：";
    duihuanjine.font=[UIFont systemFontOfSize:15];
    duihuanjine.textColor=[UIColor blackColor];
    [scrollView addSubview:duihuanjine];
    
    UILabel * jine=[[UILabel alloc]initWithFrame:CGRectMake(85,192+138-134,100,20)];
    jine.font=[UIFont systemFontOfSize:15];
    jine.textColor=[UIColor redColor];
    jine.text=[NSString stringWithFormat:@"%@彩豆",goodsItem.oldPrice];
    CGSize jineMaxSize=CGSizeMake(100,20);
#pragma mark 修改label宽度
    CGSize realJineSize=[jine.text boundingRectWithSize:jineMaxSize  options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:jine.font} context:nil].size;
    
    [jine setFrame:CGRectMake(85, 192+138-134,realJineSize.width, 20)];
    [scrollView addSubview:jine];
    UILabel * yuanjia=[[UILabel alloc]initWithFrame:CGRectMake(90+realJineSize.width,195+138-134,100, 17)];
    yuanjia.font=[UIFont systemFontOfSize:13];
    yuanjia.text=goodsItem.realPrice;
    yuanjia.textColor=[UIColor colorWithRed:128/255.f green:128/255.f blue:128/255.f alpha:1.0];

    CGSize yuanjiaSize=[yuanjia.text boundingRectWithSize:jineMaxSize  options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:yuanjia.font} context:nil].size;
    
    yuanjia.frame=CGRectMake(90+realJineSize.width,195+138-134,yuanjiaSize.width, 17);
    [scrollView addSubview:yuanjia];
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0,8,yuanjiaSize.width,1)];
    line.backgroundColor=[UIColor colorWithRed:178/255.f green:178/255.f blue:178/255.f alpha:1.0];
    [yuanjia addSubview:line];
    
    
    UILabel * huodongshijian=[[UILabel alloc]initWithFrame:CGRectMake(10,217+138-134,100,20)];
    huodongshijian.text=@"活动时间：";
    huodongshijian.font=[UIFont systemFontOfSize:15];
    huodongshijian.textColor=[UIColor blackColor];
    [scrollView addSubview:huodongshijian];
    
    UILabel * huodongshijian2=[[UILabel alloc]initWithFrame:CGRectMake(85,217+138-134,200,20)];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString* startdate=[dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[goodsItem.startTime doubleValue]]];
    NSString *endDate=[dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[goodsItem.endTime doubleValue]]];

    huodongshijian2.text=[NSString stringWithFormat:@"%@ 至 %@",startdate,endDate];
    huodongshijian2.font=[UIFont systemFontOfSize:15];
    huodongshijian2.textColor=[UIColor blackColor];
    [scrollView addSubview:huodongshijian2];
    
    UILabel * xianshiqiangdui=[[UILabel alloc]initWithFrame:CGRectMake(10,242+138-134,100,20)];
    xianshiqiangdui.text=@"限时抢兑：";
    xianshiqiangdui.font=[UIFont systemFontOfSize:15];
    xianshiqiangdui.textColor=[UIColor blackColor];
    [scrollView addSubview:xianshiqiangdui];
    
    UILabel * xianshiqiangdui2=[[UILabel alloc]initWithFrame:CGRectMake(85,242+138-134,200,20)];
    xianshiqiangdui2.text=[NSString stringWithFormat:@"每天%@个名额",goodsItem.goodsTotalNumber];
    xianshiqiangdui2.font=[UIFont systemFontOfSize:15];
    xianshiqiangdui2.textColor=[UIColor blackColor];
    [scrollView addSubview:xianshiqiangdui2];
    
    UIView *fengexian=[[UIView alloc]initWithFrame:CGRectMake(10,274+138-134,300,1)];
 fengexian.backgroundColor=[UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:0.7];
    [scrollView addSubview:fengexian];
    
    UILabel * lingqutishi=[[UILabel alloc]initWithFrame:CGRectMake(10,288+138-134,100,20)];
    lingqutishi.text=@"领取提示";
    lingqutishi.font=[UIFont systemFontOfSize:15];
    lingqutishi.textColor=[UIColor blackColor];
    [scrollView addSubview:lingqutishi];
    
    
    NSString* getstartdate=[dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[goodsItem.getStartTime doubleValue]]];
    NSString *getendDate=[dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[goodsItem.getEndTime doubleValue]]];
    UILabel * lingqushijian=[[UILabel alloc]initWithFrame:CGRectMake(10,312+138-134,300,20)];
    lingqushijian.text=[NSString stringWithFormat:@"自提商品领取时间：%@ 至 %@",getstartdate,getendDate];
    lingqushijian.font=[UIFont systemFontOfSize:13];
    lingqushijian.textColor=[UIColor colorWithRed:128/255.f green:128/255.f blue:128/255.f alpha:1.0];
    [scrollView addSubview:lingqushijian];
    
    lingqudizhi=[[UILabel alloc]initWithFrame:CGRectMake(10,330+138-134,300,45)];
    if (isGet) {
        lingqudizhi.text=goodsItem.usecontent;
    }else{
        lingqudizhi.text=goodsItem.goodsIntroduce;
        
    }
    CGSize maxSize=CGSizeMake(250,85);
    CGSize realSize=[lingqudizhi.text boundingRectWithSize:maxSize  options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:lingqudizhi.font} context:nil].size;
    lingqudizhi.frame=CGRectMake(10, 330+138-134, 300, realSize.height);
    
    lingqudizhi.numberOfLines=0;
    lingqudizhi.font=[UIFont systemFontOfSize:13];
    lingqudizhi.textColor=[UIColor colorWithRed:128/255.f green:128/255.f blue:128/255.f alpha:1.0];
    [scrollView addSubview:lingqudizhi];
    
    getGoodsButton=[MyButton buttonWithType:UIButtonTypeCustom];
    getGoodsButton.frame=CGRectMake(10,SCREENHEIGHT-55,300, 45);
    getGoodsButton.titleLabel.font=[UIFont systemFontOfSize:17];
    [getGoodsButton addTarget:self action:@selector(getGoods)];
    [self checkStatus];
    [self.view addSubview:getGoodsButton];
    
    [scrollView setContentSize:CGSizeMake(320,450+138-134-55-54+lingqudizhi.frame.size.height)];
    

    noticeLabel=[[UILabel alloc]initWithFrame:CGRectMake(60, SCREENHEIGHT-110, 200, 26)];
    noticeLabel.layer.cornerRadius=5.f;
    noticeLabel.layer.masksToBounds=YES;
    noticeLabel.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    noticeLabel.textAlignment=NSTextAlignmentCenter;
    noticeLabel.font=[UIFont systemFontOfSize:13];
    noticeLabel.textColor=[UIColor whiteColor];
    [noticeLabel setHidden:YES];
    [self.view addSubview:noticeLabel];
    [self buildLoadingAnimat];
    // Do any additional setup after loading the view.
}

-(void)checkStatus{

   
    if (isGet) {
        
        if ([_Type isEqualToString:@"0"]) {
            getGoodsButton.backgroundColor=[UIColor colorWithRed:241/255.0f green:66/255.0f  blue:66/255.0f  alpha:1];
            [getGoodsButton setNTitle:@"使用"];
            getGoodsButton.userInteractionEnabled=YES;
            
        }else if ([_Type isEqualToString:@"1"]){
            getGoodsButton.backgroundColor=[UIColor grayColor];
            [getGoodsButton setNTitle:@"已使用"];
            getGoodsButton.userInteractionEnabled=NO;
        }else{
            getGoodsButton.backgroundColor=[UIColor grayColor];
            [getGoodsButton setNTitle:@"已过期"];
            getGoodsButton.userInteractionEnabled=NO;
            
        }
    }else{
    
        
        if ([GoodsStatus isEqualToString:@"1"]) {
            getGoodsButton.backgroundColor=[UIColor grayColor];
            [getGoodsButton setNTitle:@"抢光了"];
            getGoodsButton.userInteractionEnabled=NO;
        }else if([GoodsStatus isEqualToString:@"2"]){
            getGoodsButton.backgroundColor=[UIColor grayColor];
            [getGoodsButton setNTitle:@"已结束"];
            getGoodsButton.userInteractionEnabled=NO;
        }else{
            getGoodsButton.backgroundColor=[UIColor colorWithRed:241/255.0f green:66/255.0f  blue:66/255.0f  alpha:1];
            [getGoodsButton setNTitle:@"兑换"];
            getGoodsButton.userInteractionEnabled=YES;
        }
        
    }
}
-(void)getGoods{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    if ([[userDefaults objectForKey:@"isLogin"]intValue]<2) {
        [self showNotice:@"请先登录！"];
        return;
    }
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"hhmmss"];
    
    HttpDownload *hhh=[[HttpDownload alloc]init];
    hhh.delegate=self;
    hhh.DFailed=@selector(downloadFailed:);
    hhh.DComplete=@selector(downloadComplete:);
    
    NSString *qString;
    
    if (isGet) {
    
        qString=[NSString stringWithFormat:@"mod=setmystuffstatus&uid=%@&sid=%@&ntime=%@",[userDefaults objectForKey:@"userID"],goodsItem.sid,[dateformatter stringFromDate:[NSDate date]]];
        
        
    }else{
         qString=[NSString stringWithFormat:@"mod=changenew&uid=%@&tid=%@&operation=join&token=%@&ntime=%@",[userDefaults objectForKey:@"userID"],goodsItem.goodsID,[userDefaults objectForKey:@"token"],[dateformatter stringFromDate:[NSDate date]]];
        
    }

    NSData *secretData=[qString dataUsingEncoding:NSUTF8StringEncoding];
    NSData *qValueData=[secretData AES256EncryptWithKey:SECRETKEY];
    NSString *qValue=[qValueData newStringInBase64FromData];
    NSURL *downLoadUrl;
    
    if (isGet) {
        
        downLoadUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@/app_api/shop/setmystuffstatus.html?q=%@",NewBaseUrl,qValue]];
    }else{
        downLoadUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@/app_api/shop/exchange.html?q=%@",NewBaseUrl,qValue]];
        
    }

    if([RootUrl getIsNetOn]||[[GetCMCCIpAdress getSSID]isEqualToString:@"16wifi"]){
        [hhh downloadFromUrl:downLoadUrl];
        [self startAnimat];
    }
    

    
}
-(void)showNotice:(NSString*)str{
    
    [noticeLabel setHidden:NO];
    
    CGSize maxSize=CGSizeMake(250,20);
//    CGSize realSize=[str sizeWithFont:noticeLabel.font constrainedToSize:maxSize lineBreakMode:NSLineBreakByCharWrapping];
    CGSize realSize=[str boundingRectWithSize:maxSize  options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:noticeLabel.font} context:nil].size;

    noticeLabel.frame=CGRectMake((310-realSize.width)/2, SCREENHEIGHT-110,realSize.width+10, 26);
    noticeLabel.text=str;
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setHiddenNoticeAndBack) userInfo:nil repeats:NO];

   }
-(void)showNoBackNotice:(NSString*)str{
    
    [noticeLabel setHidden:NO];
    
    CGSize maxSize=CGSizeMake(250,20);
//    CGSize realSize=[str sizeWithFont:noticeLabel.font constrainedToSize:maxSize lineBreakMode:NSLineBreakByCharWrapping];
    CGSize realSize=[str boundingRectWithSize:maxSize  options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:noticeLabel.font} context:nil].size;
    noticeLabel.frame=CGRectMake((310-realSize.width)/2, SCREENHEIGHT-110,realSize.width+10, 26);
    noticeLabel.text=str;
   
        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(setHiddenNotice) userInfo:nil repeats:NO];

}
-(void)setHiddenNotice{
    [noticeLabel setHidden:YES];

}
-(void)setHiddenNoticeAndBack{
    [noticeLabel setHidden:YES];
 
    [self.navigationController popViewControllerAnimated:YES];

}
-(void)downloadComplete:(HttpDownload *)hd{
    [self stopAnimat];

    NSError *error = nil;
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:hd.mData options:NSJSONReadingAllowFragments error:&error];
    if (error!=nil) {
        NSLog(@"json解析失败8");
    }else{
        if (isGet) {
            
            switch ([[dic objectForKey:@"ReturnCode"]intValue]) {
                case 200:
                {
                    [self showNoBackNotice:@"已成功使用,请返回后查看"];
                    
                    getGoodsButton.backgroundColor=[UIColor grayColor];
                    [getGoodsButton setNTitle:@"已使用"];
                    getGoodsButton.userInteractionEnabled=NO;
                    _MyObj.IsRefresh=YES;
                    break;
                }
                case 201:
                {
                    [self showNotice:@"使用失败！请先重试"];
                    
                    break;
                }
                default:
                    break;
            }
        
        }else{
        
            switch ([[dic objectForKey:@"ReturnCode"]intValue]) {
                case 101:
                {
                    [self showNotice:@"兑换成功！请到我的卡包页面查看！"];
                    [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"addGoods"];
                    
                    break;
                }
                case 102:
                {
                    [self showNotice:@"兑换失败！请先登录！"];
                    break;
                }
                case 107:
                {
                    [self showNotice:@"兑换失败！您的彩豆不足！"];
                    break;
                }
                default:
                {
                    
                    [self showNotice:[dic objectForKey:@"message"]];
                    break;
                }
            }
        }

    }
    
    
}
-(void)downloadFailed:(HttpDownload *)hd{
    [self stopAnimat];
    [self showNoBackNotice:@"网络错误，兑换失败！"];
}
-(void)goBackToSuperPage{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)goHome{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{}];
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
