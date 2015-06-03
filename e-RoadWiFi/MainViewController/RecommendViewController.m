//
//  RecommendViewController.m
//  e-RoadWiFi
//
//  Created by QC on 14-8-1.
//  Copyright (c) 2014年 G.MING. All rights reserved.
//

#import "RecommendViewController.h"
#import "HttpRequest.h"
#import "HttpManager.h"
#import "SearchViewController.h"
#import "ContentsItem.h"
#import "UIImageView+WebCache.h"
#import "LifeAssistantItem.h"
#import "QCLifeItem.h"
#import "MyImageView.h"
#import "EmptyItem.h"
#import "MyDatabase.h"
#import "GMHistoryItem.h"
#import "QCLifeCateItem.h"
#import "WebSubPagViewController.h"
#import "MobClick.h"
#import "BusInquiryBar.h"
#import "GetCMCCIpAdress.h"
#define appList @"http://m.16wifi.com/json/downloadAdvertising/desktop.json"

@interface RecommendViewController ()

@end

@implementation RecommendViewController

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
    if (SYSTEMVERSION>=7) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.navigationController.navigationBar.hidden=YES;
    self.view.backgroundColor=[UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1];
    isOpen=NO;
    isFinished=NO;
    canOpen=NO;
    NeedRefresh=YES;
    RefHisList=YES;
    AppLoadFailed=YES;
    //    IsFristView=YES;
    
    QCArray=[[NSMutableArray alloc]init];
    testArray=[[NSMutableArray alloc]init];
    AppArray=[[NSMutableArray alloc]init];
    IosApp  =[[NSMutableArray alloc]init];
    LocalApp=[[NSArray alloc]init];
    LocalApp=@[@"weixin://",@"taobao://",@"mqq://",@"sinaweibo://",@"tencent100273020://",@"rm434209233MojiWeather://",@"alipay://",@"youku://"];
    
    [self creatNav];
    
    [self creatTableView];
    
    [self creatFristView];
    
    [self creatSecondView];
    
    if (isPassed) {
        busBar.hidden=NO;
    }else{
        busBar.hidden=YES;
        [busBar.delegate selectType:1];
        myScrollView.scrollEnabled=NO;
    }
    
   	// Do any additional setup after loading the view.
}
-(void)creatTipsView{
    
    tipsImage=[[MyImageView alloc]init];
    tipsImage.backgroundColor=[UIColor colorWithRed:253/255.0f green:239/255.0f  blue:172/255.0f  alpha:1];
    tipsImage.userInteractionEnabled=YES;
    [tipsImage addTarget:self action:@selector(tipsImageClick:)];
    [self.view addSubview:tipsImage];
    
    UIImageView *help=[[UIImageView alloc]initWithFrame:CGRectMake(10, 7, 20, 20)];
    help.image=[UIImage imageNamed:@"tips"];
    [tipsImage addSubview:help];
    
    UIImageView *imView=[[UIImageView alloc]initWithFrame:CGRectMake(300, 12, 7, 11)];
    imView.image=[UIImage imageNamed:@"arrow"];
    [tipsImage addSubview:imView];
    
    tipsLabel=[[UILabel alloc]initWithFrame:CGRectMake(40, 7, 260, 20)];
    tipsLabel.backgroundColor=[UIColor clearColor];
    tipsLabel.textAlignment=NSTextAlignmentLeft;
    tipsLabel.font=[UIFont systemFontOfSize:13];
    [tipsImage addSubview:tipsLabel];
    
}
-(void)creatFristView{
    
    FristView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, dataTableView.frame.size.height)];
    FristView.backgroundColor=[UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1];
    bgScrollView=[[UIScrollView alloc]initWithFrame:FristView.frame];
    bgScrollView.showsHorizontalScrollIndicator=NO;
    bgScrollView.showsVerticalScrollIndicator=NO;
    bgScrollView.backgroundColor=[UIColor clearColor];
    [FristView addSubview:bgScrollView];
    
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    if ([def objectForKey:@"iosApp"]) {
        
        NSArray *appArray=[def objectForKey:@"iosApp"];
        for (int i=0; i<appArray.count; i++) {
            
            MyImageView *app=[[MyImageView alloc]initWithFrame:CGRectMake(20+(55+20)*(i%4), 20+(55+52)*(i/4), 55, 55)andWithRadius:10];
            app.image=[UIImage imageWithData:[NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",documentsDirectoryPath,appArray[i][@"linkName"]]]];
            app.tag=21000+i;
            [app addTarget:self action:@selector(AppImageClick:)];
            [bgScrollView addSubview:app];
            UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(15+(65+10)*(i%4), 85+(12+95)*(i/4), 65, 12)];
            title.text=appArray[i][@"linkName"];
            title.tag=22000+i;
            title.font=[UIFont systemFontOfSize:13];
            title.backgroundColor=[UIColor clearColor];
            title.textAlignment=NSTextAlignmentCenter;
            [bgScrollView addSubview:title];
        }
        
        bgScrollView.contentSize=CGSizeMake(320, 107*((appArray.count)%4==0?(appArray.count)/4:(appArray.count)/4+1)+2);
        RefreshAppIcon=NO;
    }else{
        NSArray *titles=@[@"微信",@"淘宝",@"QQ",@"微博",@"京东",@"墨迹天气",@"支付宝",@"优酷"];
        for (int i=0; i<titles.count; i++) {
            
            MyImageView *app=[[MyImageView alloc]initWithFrame:CGRectMake(20+(55+20)*(i%4), 20+(55+52)*(i/4), 55, 55)andWithRadius:10];
            app.image=[UIImage imageNamed:titles[i]];
            app.tag=21000+i;
            [app addTarget:self action:@selector(AppImageClick:)];
            [bgScrollView addSubview:app];
            
            UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(15+(65+10)*(i%4), 85+(12+95)*(i/4), 65, 12)];
            title.text=titles[i];
            title.tag=22000+i;
            title.font=[UIFont systemFontOfSize:13];
            title.backgroundColor=[UIColor clearColor];
            title.textAlignment=NSTextAlignmentCenter;
            
            [bgScrollView addSubview:title];
            
        }
        RefreshAppIcon=YES;
        AppLoadFailed=YES;
        
    }
    //先加载本地 然后判断是否需要加载网络数据
    
    if (AppLoadFailed) {
        if ([RootUrl getIsNetOn]) {
            [self addTask:appList action:@selector(AppListRequest:)];
        }else{
            AppLoadFailed=YES;
        }
    }
    
    [myScrollView addSubview:FristView];
    
}
-(void)creatSecondView{
    SecondView=[[UIView alloc]initWithFrame:CGRectMake(SCREENWIDTH, 0, SCREENWIDTH, dataTableView.frame.size.height)];
    SecondView.backgroundColor=[UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1];
    [SecondView addSubview:dataTableView];
    
    
    rowCount=[historyArray count]%2==0?[historyArray count]/2:[historyArray count]/2+1;
    if (historyArray.count) {
        TabHeadView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 270+44*(rowCount+1)+55-70+54)];
    }else{
        TabHeadView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 270+45-70+54)];
        
    }
    TabHeadView.backgroundColor=[UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1];
    
    [dataTableView setTableHeaderView:TabHeadView];
    
    [self addSearchBar];
//    [self creatLocalADView];
    [self creatLocalCategary];
    [self creatRecentVisit];
    
    
    [myScrollView addSubview:SecondView];
}
-(void)creatLocalADView{
    UIView *AdView=[[UIView alloc]initWithFrame:CGRectMake(0, 55, 320, 155+54)];
    AdView.backgroundColor=[UIColor whiteColor];
    AdView.userInteractionEnabled=YES;
    [TabHeadView addSubview:AdView];
    
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    headView.backgroundColor=[UIColor whiteColor];
    [AdView addSubview:headView];
    
    UIImageView *headimage=[[UIImageView alloc]initWithFrame:CGRectMake(10, 12, 21, 21)];
    headimage.image=[UIImage imageNamed:@"cy-shop"];
    [headView addSubview:headimage];
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(40, 0, 200, 44)];
    titleLabel.text=@"特价促销";
    titleLabel.font=[UIFont systemFontOfSize:15];
    titleLabel.textColor=[UIColor colorWithRed:51/255.0f green:51/255.0f  blue:51/255.0f  alpha:1];
    titleLabel.textAlignment=NSTextAlignmentLeft;
    [headView addSubview:titleLabel];
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0,0,320, 0.5)];
    lineView.backgroundColor=[UIColor colorWithRed:215/255.f green:217/255.f blue:223/255.f alpha:0.7];
    [headView addSubview:lineView];
    
    UIView *lineView1=[[UIView alloc]initWithFrame:CGRectMake(0,43,320, 0.5)];
    lineView1.backgroundColor=[UIColor colorWithRed:215/255.f green:217/255.f blue:223/255.f alpha:0.7];
    [headView addSubview:lineView1];
    
    
    MyImageView *leftImage=[[MyImageView alloc]initWithFrame:CGRectMake(10, 49, 148, 155)andWithRadius:0];
    leftImage.image=[UIImage imageNamed:@"left1.jpg"];
    leftImage.tag=32000;
    [leftImage addTarget:self action:@selector(imageClick:)];
    [AdView addSubview:leftImage];
    for (int i=0; i<2; i++) {
        MyImageView *rightImage=[[MyImageView alloc]initWithFrame:CGRectMake(10+155, 49+80*i, 147, 75)andWithRadius:0];
        rightImage.image=[UIImage  imageNamed:[NSString stringWithFormat:@"right%d.jpg",i+1]];
        rightImage.tag=32001+i;
        [rightImage addTarget:self action:@selector(imageClick:)];
        [AdView addSubview:rightImage];
    }
    
    UIView *lineView2=[[UIView alloc]initWithFrame:CGRectMake(0,155+54,320, 0.5)];
    lineView2.backgroundColor=[UIColor colorWithRed:215/255.f green:217/255.f blue:223/255.f alpha:0.7];
    [AdView addSubview:lineView2];
    
}
-(void)creatLocalCategary{
    
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 65, 320, 44)];
    headView.backgroundColor=[UIColor whiteColor];
    headView.userInteractionEnabled=YES;
    [TabHeadView addSubview:headView];
    
    UIImageView *headimage=[[UIImageView alloc]initWithFrame:CGRectMake(10, 12, 21, 21)];
    headimage.image=[UIImage imageNamed:@"cy-web"];
    [headView addSubview:headimage];
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(40, 0, 200, 44)];
    titleLabel.text=@"名站导航";
    titleLabel.font=[UIFont systemFontOfSize:15];
    titleLabel.textColor=[UIColor colorWithRed:51/255.0f green:51/255.0f  blue:51/255.0f  alpha:1];
    titleLabel.textAlignment=NSTextAlignmentLeft;
    [headView addSubview:titleLabel];
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0,0,320, 0.5)];
    lineView.backgroundColor=[UIColor colorWithRed:215/255.f green:217/255.f blue:223/255.f alpha:0.7];
    [headView addSubview:lineView];
    
    UIView *lineView1=[[UIView alloc]initWithFrame:CGRectMake(0,43,320, 0.5)];
    lineView1.backgroundColor=[UIColor colorWithRed:215/255.f green:217/255.f blue:223/255.f alpha:0.7];
    [headView addSubview:lineView1];
    
    NSMutableArray *array=[NSMutableArray arrayWithArray:[[MyDatabase sharedDatabase]readData:1 count:0 model:[[ContentsItem alloc]init] grounBy:nil orderBy:nil desc:NO]];
    for (int i=0; i<16; i++) {
        ContentsItem *item=[array objectAtIndex:i];
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.tag=3100+i;
        button.frame=CGRectMake(((80*(i%4))),((45*(i/4)+125-70+54)),80,45);
        button.backgroundColor=[UIColor whiteColor];
        
        UILabel *label=[[UILabel alloc]init];
        label.text=item.linkName;
        label.tag=24000+i;
        label.textAlignment=NSTextAlignmentCenter;
        label.textColor=[UIColor blackColor];
        label.font=[UIFont systemFontOfSize:12];
        label.frame=CGRectMake(30,10,50,25);
        [button addSubview:label];
        
        UIImageView *icon=[[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 16, 16)];
        icon.image=[UIImage imageNamed:item.linkName];
        icon.tag=25000+i;
        [button addSubview:icon];
        
        [TabHeadView addSubview:button];
        [button addTarget:self action:@selector(CategaryClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    UIView *lineView2=[[UIView alloc]initWithFrame:CGRectMake(0,((45*4)+125-70+54),320, 0.5)];
    lineView2.backgroundColor=[UIColor colorWithRed:215/255.f green:217/255.f blue:223/255.f alpha:0.7];
    [TabHeadView addSubview:lineView2];
    
}
-(void)creatScrollView{
    
    myScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 44+SIZEABOUTIOSVERSION+tipsImage.frame.size.height, SCREENWIDTH, dataTableView.frame.size.height)];
    myScrollView.pagingEnabled=YES;
    myScrollView.delegate=self;
    myScrollView.showsHorizontalScrollIndicator=NO;
    myScrollView.showsVerticalScrollIndicator=NO;
    [myScrollView setContentSize:CGSizeMake(SCREENWIDTH*2, dataTableView.frame.size.height)];
    [self.view addSubview:myScrollView];
    
    pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0,SCREENHEIGHT-95,320,20)];
    [pageControl setCurrentPageIndicatorTintColor:[UIColor whiteColor]];
    [pageControl setPageIndicatorTintColor:[UIColor colorWithRed:134/255.0f green:218/255.0f blue:251/255.0f alpha:1]];
    pageControl.numberOfPages =2;
    pageControl.currentPage =0;
    [pageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
    
}
-(void)creatTableView{
    
    [self creatTipsView];
    dataTableView=[[UITableView alloc] init];
    
    [self initWithDataTableView];
    
    [self creatScrollView];
    
#if 0
    _CurrentArray = [[NSMutableArray alloc]init];
    //这里的组数应该是获取数据的count,可以是一个请求的所有分类
    
    for (int i = 0; i < 2; i++) {
        
        NSMutableArray *arr=[[NSMutableArray alloc]init];
        
        for (int j = 0; j < 12; j++)
        {
            EmptyItem *item=[[EmptyItem alloc]init];
            [arr addObject:item];
        }
        [_CurrentArray addObject:arr];
    }
#else
    
    
#endif
}
-(void)pageTurn:(UIPageControl *)page {
    CGSize viewsize=myScrollView.frame.size;
    CGRect rect=CGRectMake(page.currentPage*viewsize.width, 0, viewsize.width, viewsize.height);
    [myScrollView scrollRectToVisible:rect animated:YES];
}

-(void)selectType:(int)type{
    
    switch (type) {
        case 0:
        {
            if (AppLoadFailed) {
                if ([RootUrl getIsNetOn]) {
                    [self addTask:appList action:@selector(AppListRequest:)];
                }else{
                    AppLoadFailed=YES;
                }
            }
            [pageControl setCurrentPage:0];
            [self pageTurn:pageControl];
            
        }
            break;
        case 1:
        {
            //这里默认是不加载的 只有点击或者滑动的时候加载
            
            if (NeedRefresh) {
                
                if ([RootUrl getIsNetOn]) {
                    [handleView removeFromSuperview];
                    shop.hidden=YES;
                    [self addHandleView];
                    [self addTask:LifeAssistant action:@selector(LifeAssistantRequest:)];
                }else{
                    NeedRefresh=YES;
                }
            }
            [pageControl setCurrentPage:1];
            [self pageTurn:pageControl];
        }
            break;
    }
}


-(void)tipsImageClick:(MyImageView *)image{
    [self.tabBarController setSelectedIndex:0];
}

-(void)initWithDataTableView{
    
    CGRect frame=[[UIScreen mainScreen] bounds];
    if ([AppDelegate isIOS7]) {
        tipsImage.frame=CGRectMake(0, 64, 320, 35);
    }else{
        tipsImage.frame=CGRectMake(0, 44, 320, 35);
    }
    
    if ([RootUrl getIsNetOn]) {
        tipsImage.frame=CGRectZero;
        tipsImage.hidden=YES;
    }else{
        tipsImage.hidden=NO;
        if ([[GetCMCCIpAdress getSSID]isEqualToString:@"16wifi"]) {
            tipsLabel.text=@"16wifi网络已连接,请点击一键上网";
        }else if([[GetCMCCIpAdress getSSID]isEqualToString:@"114 Free"]) {
            tipsLabel.text=@"114 Free网络已连接,请点击一键上网";
        }else{
            tipsLabel.text=@"请连接16wifi或114 Free后,点击一键上网";
        }
        
    }
    
    frame.size.height-=44+SIZEABOUTIOSVERSION+tipsImage.frame.size.height+49;
    
//        frame.origin.y+=tipsImage.frame.size.height;
    
    dataTableView.frame=frame;
    dataTableView.dataSource=self;
    dataTableView.delegate=self;
    dataTableView.backgroundColor=[UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1];
    dataTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
}

-(void)creatNav{
    UIImageView *navView=[[UIImageView alloc]init];
    if ([AppDelegate isIOS7]) {
        navView.frame=CGRectMake(0, 0, 320, 64);
    }else{
        navView.frame=CGRectMake(0, -20, 320, 64);
    }
    navView.image=[UIImage imageNamed:@"gm_nav"];
    navView.userInteractionEnabled=YES;
    [self.view addSubview:navView];
    
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    busBar=[[BusInquiryBar alloc]initWithFrame:CGRectMake(100, 25, 120, 30) andTag:@"1" andStretchCap:16 andWithDelegate:self];
    [busBar setButtonName:@"应用" andWithButtonIndex:1];
    [busBar setButtonName:@"导航" andWithButtonIndex:2];
    [navView addSubview:busBar];
    
    if ([[def objectForKey:@"ProVersion"] floatValue ]<6.0) {
        busBar.hidden=NO;
        isPassed=YES;
    }else{
        busBar.hidden=YES;
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(120, 20, 80, 44)];
        titleLabel.text=@"桌面";
        titleLabel.textAlignment=NSTextAlignmentCenter;
        titleLabel.font=[UIFont systemFontOfSize:20];
        titleLabel.textColor=[UIColor whiteColor];
        titleLabel.backgroundColor=[UIColor clearColor];
        [navView addSubview:titleLabel];
        isPassed=NO;
    }

    
}
-(void)addSearchBar{
    MySearchBar=[[UISearchBar alloc]initWithFrame:CGRectMake(10, 10,250, 35)];
    MySearchBar.tag=10001;
    MySearchBar.delegate=self;
    MySearchBar.placeholder=@"输入搜索关键字                            ";
    MySearchBar.backgroundImage=[[UIImage imageNamed:@"search"]stretchableImageWithLeftCapWidth:12 topCapHeight:12];
    MySearchBar.delegate=self;
    MySearchBar.contentMode=UIViewContentModeLeft;
    [TabHeadView addSubview:MySearchBar];
    
    if ([RootUrl getIsNetOn]) {
        [self addHandleView];
    }else{
        shop=[[MyImageView alloc]initWithFrame:CGRectMake(270, 77-70, 40, 40)];
        shop.tag=35001;
        shop.image=[UIImage imageNamed:@"shop"];
        [shop addTarget:self action:@selector(shopImageClick:)];
        [TabHeadView addSubview:shop];
        
    }
}
-(void)shopImageClick:(MyImageView *)image{
    
    AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [app setNotice:@"网络链接不可用，请稍后重试！"];
}

-(void)addHandleView{
    
    handleView = [[UMUFPHandleView alloc] initWithFrame:CGRectMake(270, 13, 30,30) appKey:nil slotId:@"60849" currentViewController:self];
    handleView.delegate = (id<UMUFPHandleViewDelegate>)self;
    
    [TabHeadView addSubview:handleView];
    [handleView requestPromoterDataInBackground];
    
    
}
-(void)creatAppList{
    for (int i=0; i<LocalApp.count; i++) {
        
        MyImageView *app=(MyImageView *)[bgScrollView viewWithTag:21000+i];
        [app removeFromSuperview];
        UILabel *title=(UILabel *)[bgScrollView viewWithTag:22000+i];
        [title removeFromSuperview];
    }
    for (int i=0; i<IosApp.count; i++) {
        
        MyImageView *app=[[MyImageView alloc]initWithFrame:CGRectMake(20+(55+20)*(i%4), 20+(55+52)*(i/4), 55, 55)andWithRadius:10.0];
        app.tag=21000+i;
        NSString *LeftUrl;
        if ([IosApp[i][@"icon"] hasPrefix:@"http"]) {
                 LeftUrl=[NSString stringWithFormat:@"%@",IosApp[i][@"icon"]];
        }else{
        
                LeftUrl=[NSString stringWithFormat:@"%@%@",RootConnectUrl,IosApp[i][@"icon"]];
        }
   
        [app setImageWithURL:[NSURL URLWithString:LeftUrl] placeholderImage:[UIImage imageNamed:@"loading"]];
        [app addTarget:self action:@selector(AppImageClick:)];
        [bgScrollView addSubview:app];
        
        UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(15+(65+10)*(i%4), 85+(12+95)*(i/4), 65, 12)];
        title.text=[IosApp [i] objectForKey:@"linkName"];
        title.tag=22000+i;
        title.font=[UIFont systemFontOfSize:13];
        title.backgroundColor=[UIColor clearColor];
        title.textAlignment=NSTextAlignmentCenter;
        
        [bgScrollView addSubview:title];
        
    }
    
    bgScrollView.contentSize=CGSizeMake(320, 107*((IosApp.count)%4==0?(IosApp.count)/4:(IosApp.count)/4+1)+2);
    
}
-(void)creatWebADView{
    
    NSString *Url;
    if ([headArray[1][@"advtiseImg"] hasPrefix:@"http"]) {
            Url=[NSString stringWithFormat:@"%@",headArray[1][@"advtiseImg"]];
    }else{
    
          Url=[NSString stringWithFormat:@"%@%@",RootConnectUrl,headArray[1][@"advtiseImg"]];
    }

    UIImageView *leftImage=(UIImageView *)[TabHeadView viewWithTag:32000];
    [leftImage setImageWithURL:[NSURL URLWithString:Url]placeholderImage:[UIImage imageNamed:@"gm-biaoqing"]];
    
    for (int i=0; i<2; i++) {
        
        NSString *LeftUrl;
        if ([headArray[0][@"advtiseImg"] hasPrefix:@"http"]) {
            LeftUrl=[NSString stringWithFormat:@"%@",headArray[0][@"advtiseImg"]];
        }else{
        LeftUrl=[NSString stringWithFormat:@"%@%@",RootConnectUrl,headArray[0][@"advtiseImg"]];
        }

        NSString *LeftUrl2;
        if ([headArray[2][@"advtiseImg"]hasPrefix:@"http"]) {
            LeftUrl2=[NSString stringWithFormat:@"%@",headArray[2][@"advtiseImg"]];

        }else{
            LeftUrl2=[NSString stringWithFormat:@"%@%@",RootConnectUrl,headArray[2][@"advtiseImg"]];

        }
        
        NSArray *array=@[LeftUrl,LeftUrl2];
        UIImageView *rightImage=(UIImageView *)[TabHeadView viewWithTag:32001+i];
        [rightImage setImageWithURL:[NSURL URLWithString:array[i]] placeholderImage:[UIImage imageNamed:@"biaoqing"]];
    }
    
    [self addTask:WebCategary action:@selector(CategaryRequestFinished:)];
    
}
-(void)creatWebCategary{
    
    NSInteger count=dataArray.count;
    rowCount=[historyArray count]%2==0?[historyArray count]/2:[historyArray count]/2+1;
    if (rowCount) {
        TabHeadView.frame= CGRectMake(0, 0, 320, 270+44*(rowCount+1)+55-70+54);
    }else{
        TabHeadView.frame= CGRectMake(0, 0, 320, 270+45-70+54);
    }
    
    for (int i=0; i<count; i++) {
        ContentsItem *item=[dataArray objectAtIndex:i];
        
        UILabel *label=(UILabel *)[TabHeadView viewWithTag:24000+i];
        label.text=item.linkName;
        
        UIImageView *icon=(UIImageView *)[TabHeadView viewWithTag:25000+i];
        NSString *iconUrl;
        if ([item.icon hasPrefix:@"http"]) {
            iconUrl=[NSString stringWithFormat:@"%@",item.icon];
        }else{
            iconUrl=[NSString stringWithFormat:@"%@%@",RootConnectUrl,item.icon];
            
        }

        [icon setImageWithURL:[NSURL URLWithString:iconUrl]];
        
    }
    [self addTask:QiCaiLife action:@selector(QiCaiLifeRequest:)];
    
}

-(void)creatRecentVisit{
    
    if (historyArray.count) {
        rowCount=[historyArray count]%2==0?[historyArray count]/2:[historyArray count]/2+1;
        recent=[[UIView alloc]initWithFrame:CGRectMake(0, 190+125-70+54, 320, 44*(rowCount+1))];
        recent.backgroundColor=[UIColor whiteColor];
        recent.userInteractionEnabled=YES;
        [TabHeadView addSubview:recent];
        
        UIImageView *headimage=[[UIImageView alloc]initWithFrame:CGRectMake(10, 12, 21, 21)];
        headimage.image=[UIImage imageNamed:@"gm_history"];
        [recent addSubview:headimage];
        
        MyImageView *delete=[[MyImageView alloc]initWithFrame:CGRectMake(279, 0, 45, 45)andWithRadius:0];
        delete.image=[UIImage imageNamed:@"cy_delete"];
        [delete addTarget:self action:@selector(deleteClick:)];
        [recent addSubview:delete];
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(40, 0, 200, 44)];
        titleLabel.text=@"最常访问";
        titleLabel.font=[UIFont systemFontOfSize:15];
        titleLabel.textColor=[UIColor colorWithRed:51/255.0f green:51/255.0f  blue:51/255.0f  alpha:1];
        titleLabel.textAlignment=NSTextAlignmentLeft;
        [recent addSubview:titleLabel];
        
        for (int i=0; i<historyArray.count; i++) {
            
            GMHistoryItem *item=[historyArray objectAtIndex:i];
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            button.tag=3200+i;
            button.frame=CGRectMake(((160*(i%2))),(44+(44*(i/2))),160,44);
            button.backgroundColor=[UIColor whiteColor];
            
            UILabel *label=[[UILabel alloc]init];
            label.text=item.name;
            label.textAlignment=NSTextAlignmentLeft;
            label.textColor=[UIColor colorWithRed:51/255.f green:51/255.f blue:51/255.f alpha:1];
            label.font=[UIFont systemFontOfSize:15];
            label.frame=CGRectMake(45,10,100,25);
            [button addSubview:label];
            
            UIImageView *icon=[[UIImageView alloc]initWithFrame:CGRectMake(20, 14, 16, 16)];\
            NSLog(@"icon:%@",item.icon);
            if ([item.icon isEqualToString:@"moren"]) {
                icon.image=[UIImage imageNamed:@"moren"];
            }else{
                [icon setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[RootUrl getContentUrl],item.icon]]];
                //                icon.image=[UIImage imageNamed:item.name];
                NSLog(@"iconname:%@",item.name);
            }
            
            [button addSubview:icon];
            
            [recent addSubview:button];
            [button addTarget:self action:@selector(RercentClick:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        
        NSLog(@"%ld",(long)rowCount);
        
        for (int i=0; i<rowCount+2; i++) {
            UIView *lineView1=[[UIView alloc]initWithFrame:CGRectMake(0,44*i,320, 0.5)];
            lineView1.backgroundColor=[UIColor colorWithRed:215/255.f green:217/255.f blue:223/255.f alpha:0.7];
            [recent addSubview:lineView1];
        }
        for (int i=0; i<3; i++) {
            UIView *lineView2=[[UIView alloc]initWithFrame:CGRectMake((160*(i)),44,0.5, 44*(rowCount))];
            lineView2.backgroundColor=[UIColor colorWithRed:215/255.f green:217/255.f blue:223/255.f alpha:0.7];
            [recent addSubview:lineView2];
            
        }
    }
}

-(void)AppImageClick:(MyImageView *)icon{
    

    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    NSArray *appArray=[def objectForKey:@"iosApp"];
    
    if (appArray.count) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[appArray[icon.tag-21000] objectForKey:@"iosUrlScheme"]]];
        
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }else{
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[appArray[icon.tag-21000] objectForKey:@"iosLinkPath"]]];
            NSLog(@"linkPath:%@",[appArray[icon.tag-21000] objectForKey:@"iosLinkPath"]);
        }
        
        NSString *ClickType=[NSString stringWithFormat:@"%@",[appArray [icon.tag-21000] objectForKey:@"linkName"]];
        NSDictionary *dict = @{@"type" : ClickType};
        [MobClick event:@"recommend_app" attributes:dict];
        
        NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
        AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
        [app AddCoinRequestWithType:@"con_desk" ContentId:[appArray[icon.tag-21000] objectForKey:@"linkId"] UserId:[def objectForKey:@"userID"]CoinNum:@"2"];
         app.delegateView=self;
    }else{
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",LocalApp[icon.tag-21000]]];
        
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }else{
            
            UIAlertView *alterView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您的手机暂未安装该应用" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
            [alterView show];
        }
        
    }
    
}

-(void)deleteClick:(MyImageView *)image{
    UIAlertView *alterView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"是否清空历史搜素记录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认" ,nil];
    [alterView show];
    RefHisList=YES;
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.cancelButtonIndex == buttonIndex) {
        NSLog(@"取消");
    }else{
        NSLog(@"确定");
        [[MyDatabase sharedDatabase]deleteTable:[[GMHistoryItem alloc]init]];
        [historyArray removeAllObjects];
        [recent removeFromSuperview];
        TabHeadView.frame=CGRectMake(0, 0, 320, 260+55-70+54);
        [dataTableView setTableHeaderView:TabHeadView];
    }
}

-(void)CategaryClick:(UIButton *)button{
    if ([RootUrl getIsNetOn]&&isFinished) {
        
        ContentsItem *item=dataArray[button.tag-3100];
        GMHistoryItem  *History=[[GMHistoryItem alloc]init];
        [History setValue:item.linkPath forKey:@"keyPath"];
        [History setValue:item.icon forKey:@"icon"];
        [History setValue:item.linkName forKey:@"name"];
        [History  setValue:@"1" forKey:@"count"];
        [historyArray removeAllObjects];
        [historyArray addObject:History];
        
        NSMutableArray *array=[NSMutableArray arrayWithArray:[[MyDatabase sharedDatabase]readData:0 count:0 model:[[GMHistoryItem alloc]init] where:@"name" value:item.linkName]];
        
        if (array.count) {
            
            [[MyDatabase sharedDatabase]updataTable:[[GMHistoryItem alloc]init] setField:@"count" Value:@"count" where:@"name" FieldType:item.linkName];
            
        }else{
            
            [[MyDatabase sharedDatabase]insertArray:historyArray];
            
        }
        
        NSDictionary *dict = @{@"type" : item.linkName};
        [MobClick event:@"recommend_web" attributes:dict];
        
        NSString *strUrl = [item.linkPath stringByReplacingOccurrencesOfString:@" " withString:@""];
        WebSubPagViewController *wvc=[[WebSubPagViewController alloc]init];
        wvc.myRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
        //        wvc.titleLabel.text=item.linkName;
        [self presentViewController:wvc animated:YES completion:nil];
        
        RefHisList=YES;
        
        
        NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
        AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
        [app AddCoinRequestWithType:@"con_guide" ContentId:item.linkId UserId:[def objectForKey:@"userID"]CoinNum:@"2"];
         app.delegateView=self;


        
    }else{
        AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
        [app setNotice:@"网络链接不可用，请稍后重试！"];
    }
    
}
-(void)RercentClick:(UIButton *)button{
    if ([RootUrl getIsNetOn]) {
        
        
        GMHistoryItem *item=[historyArray objectAtIndex:button.tag-3200];
        NSDictionary *dict = @{@"type" : item.name};
        [MobClick event:@"recommend_web" attributes:dict];
        
        WebSubPagViewController *wvc=[[WebSubPagViewController alloc]init];
        NSString *newUrlStr = [item.keyPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        wvc.myRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:newUrlStr]];
        //        wvc.titleLabel.text=item.name;
        [self presentViewController:wvc animated:YES completion:nil];
        

        
        RefHisList=YES;
        
    }else{
        AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
        [app setNotice:@"网络链接不可用，请稍后重试！"];
        
    }
}


#pragma mark searchBarDelegate
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    if ([RootUrl getIsNetOn]) {
        SearchViewController *searchCtr=[[SearchViewController alloc]init];
        searchCtr.isLineOfTurn=1;
        searchCtr.tag=410;
        //   [self presentViewController:searchCtr animated:YES completion:^{}];
        [self.navigationController pushViewController:searchCtr animated:YES];
        
    }else{
        AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
        [app setNotice:@"网络链接不可用，请稍后重试！"];
        
    }
    
    return NO;
}

-(void)desClick:(UIButton *)desClick{
    if ([RootUrl getIsNetOn]) {
        WebSubPagViewController *wvc=[[WebSubPagViewController alloc]init];
        //        wvc.titleLabel.text=@"精品推荐";
        switch (desClick.tag-33000) {
            case 0:
            {
                wvc.myRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:headArray[3][@"advtisePath"]]];
                
            }
                break;
            case 1:
            {
                wvc.myRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:headArray[4][@"advtisePath"]]];
            }
                break;
                
            case 2:
            {
                wvc.myRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:headArray[5][@"advtisePath"]]];
                
            }
                break;
        }
        [self presentViewController:wvc animated:YES completion:^{}];
        
        RefHisList=YES;
        
        
    }else{
        
        AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
        [app setNotice:@"网络链接不可用，请稍后重试！"];
        
    }
    
}
-(void)imageClick:(MyImageView *)image{
    if ([RootUrl getIsNetOn]&&isFinished) {
        WebSubPagViewController *wvc=[[WebSubPagViewController alloc]init];
        //        wvc.titleLabel.text=@"精品推荐";
        NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
        AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
        
        switch (image.tag-32000) {
            case 0:
            {
                
                wvc.myRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:headArray[1][@"advtisePath"]]];
                NSDictionary *dict = @{@"type" : headArray[1][@"advtiseTitle"]};
                [MobClick event:@"recommend_web" attributes:dict];
                
                [app AddCoinRequestWithType:@"con_guide" ContentId:headArray[1][@"advtiseId"] UserId:[def objectForKey:@"userID"]CoinNum:@"2"];
                 app.delegateView=self;

            }
                break;
            case 1:
            {
                wvc.myRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:headArray[0][@"advtisePath"]]];
                NSDictionary *dict = @{@"type" : headArray[0][@"advtiseTitle"]};
                [MobClick event:@"recommend_web" attributes:dict];
                 [app AddCoinRequestWithType:@"con_guide" ContentId:headArray[0][@"advtiseId"] UserId:[def objectForKey:@"userID"]CoinNum:@"2"];
                 app.delegateView=self;
            }
                break;
                
            case 2:
            {
                wvc.myRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:headArray[2][@"advtisePath"]]];
                NSDictionary *dict = @{@"type" : headArray[2][@"advtiseTitle"]};
                [MobClick event:@"recommend_web" attributes:dict];
                 [app AddCoinRequestWithType:@"con_guide" ContentId:headArray[2][@"advtiseId"] UserId:[def objectForKey:@"userID"]CoinNum:@"2"];
                 app.delegateView=self;
            }
                break;
        }
        
        [self presentViewController:wvc animated:YES completion:^{}];
        
        RefHisList=YES;
        
    }else{
        
        AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
        [app setNotice:@"网络链接不可用，请稍后重试！"];
    }
}
-(void)btn:(UIButton *)button{
    NSLog(@"=======%ld",(long)button.tag);
    
    GMHistoryItem  *History=[[GMHistoryItem alloc]init];
    [History setValue:[QCArray objectAtIndex:((button.tag-3300)/100)][(button.tag-3300)%100][@"linkPath"] forKey:@"keyPath"];
    [History setValue:@"moren" forKey:@"icon"];
    [History setValue:[QCArray objectAtIndex:((button.tag-3300)/100)][(button.tag-3300)%100][@"linkName"] forKey:@"name"];
    [History  setValue:@"1" forKey:@"count"];
    [historyArray removeAllObjects];
    [historyArray addObject:History];
    
    NSMutableArray *array=[NSMutableArray arrayWithArray:[[MyDatabase sharedDatabase]readData:0 count:0 model:[[GMHistoryItem alloc]init] where:@"name" value:[QCArray objectAtIndex:((button.tag-3300)/100)][(button.tag-3300)%100][@"linkName"]]];
    if (array.count) {
        [[MyDatabase sharedDatabase]updataTable:[[GMHistoryItem alloc]init] setField:@"count" Value:@"count" where:@"name" FieldType:[QCArray objectAtIndex:((button.tag-3300)/100)][(button.tag-3300)%100][@"linkName"]];
    }else{
        [[MyDatabase sharedDatabase]insertArray:historyArray];
    }
    if ([RootUrl getIsNetOn]&&isFinished) {
        
        NSDictionary *dict = @{@"type" : [QCArray objectAtIndex:((button.tag-3300)/100)][(button.tag-3300)%100][@"linkName"]};
        [MobClick event:@"recommend_web" attributes:dict];
        
        WebSubPagViewController *wvc=[[WebSubPagViewController alloc]init];
        NSString *url=[QCArray objectAtIndex:((button.tag-3300)/100)][(button.tag-3300)%100][@"linkPath"];
        NSString *strUrl = [url stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString *newUrlStr = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        wvc.myRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:newUrlStr]];
        [self presentViewController:wvc animated:YES completion:nil];
        RefHisList=YES;
        
        
    
        NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
        AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
        [app AddCoinRequestWithType:@"con_guide" ContentId:[QCArray objectAtIndex:((button.tag-3300)/100)][(button.tag-3300)%100][@"linkId"] UserId:[def objectForKey:@"userID"]CoinNum:@"2"];
        app.delegateView=self;
        
    }else{
        
        AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
        [app setNotice:@"网络链接不可用，请稍后重试！"];
        
    }
    
    
}

#pragma mark - ActionMethord
- (void)expand:(UIButton*)btn
{
    if ([RootUrl getIsNetOn]&&canOpen) {
        NSInteger section=(long)btn.tag-3400;
        
        if(isOpen)
        {
            isOpen=NO;
        }else
        {
            isOpen=YES;
        }
        NSIndexSet *indexSet =[[NSIndexSet alloc]initWithIndex:section];
        [dataTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
        if (isOpen) {
            
            [dataTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    }else{
        AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
        [app setNotice:@"网络链接不可用，请稍后重试！"];
        /*
         UIAlertView *alterView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请先链接16wifi" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
         [alterView show];
         */
    }
}

-(void)CategaryRequestFinished:(HttpRequest *)request{
    
    [curTaskDict removeObjectForKey:request.httpUrl];
    NSError *error;
    NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:request.downloadData options:NSJSONReadingMutableContainers error:&error];
    if (dict) {
        [dataArray removeAllObjects];
        NSDictionary *info=dict[@"info"];
        NSArray *array=info[@"contents"];
        for (NSDictionary *contents in array) {
            ContentsItem *item=[[ContentsItem alloc]init];
            [item setValuesForKeysWithDictionary:contents];
            [dataArray addObject:item];
        }
        isLoading=NO;
        [dataTableView reloadData];
        NeedRefresh=NO;
    }else{
        
        NSLog(@"%@",error);
        NeedRefresh=YES;
    }
    
    [self creatWebCategary];
    
    
}


-(void)QiCaiLifeRequest:(HttpRequest *)QCRequest{
    [curTaskDict removeObjectForKey:QCRequest.httpUrl];
    NSError *error;
    NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:QCRequest.downloadData options:NSJSONReadingMutableContainers error:&error];
    if (dict) {
        [QCArray removeAllObjects];
        [testArray removeAllObjects];
        NSDictionary *info=dict[@"info"];
        NSArray *array=info[@"contents"];
        
        for (NSDictionary *dic in array) {
            
            QCLifeItem *item=[[QCLifeItem alloc]init];
            [item setValuesForKeysWithDictionary:dic];
            [testArray addObject:item];
            
            //这里的dic是所有的数据  另外一种解析方法
            NSArray *contents=dic[@"contents"];
            [QCArray addObject:contents];
            
        }
        isLoading=NO;
        canOpen=YES;
        
        if (headArray.count) {
            isFinished=YES;
            isOpen=YES;
            NSIndexSet *indexSet =[[NSIndexSet alloc]initWithIndex:0];
            [dataTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
        }
        [dataTableView reloadData];
        NeedRefresh=NO;
    }else{
        NSLog(@"%@",error);
        NeedRefresh=YES;
    }
}
-(void)LifeAssistantRequest:(HttpRequest *)request{
    
    [curTaskDict removeObjectForKey:request.httpUrl];
    NSError *error;
    NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:request.downloadData options:NSJSONReadingMutableContainers error:&error];
    if (dict) {
        
        NSDictionary *info=dict[@"info"];
        headArray=info[@"contents"];
        isLoading=NO;
        [dataTableView reloadData];
        NeedRefresh=NO;
    }else{
        NSLog(@"%@",error);
        NeedRefresh=YES;
    }
    
    [self creatWebADView];
    
}

-(void)AppListRequest:(HttpRequest *)appRequest{
    
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    NSArray *oldAppIcon=[def objectForKey:@"iosApp"];
    [curTaskDict removeObjectForKey:appRequest.httpUrl];
    NSError *error;
    NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:appRequest.downloadData options:NSJSONReadingMutableContainers error:&error];
    if (dict) {
        [IosApp removeAllObjects];
        NSDictionary *info=dict[@"info"];
        AppArray=info[@"contents"];
        NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        for (int i=0;i<AppArray.count;i++) {
            NSDictionary *app=[AppArray objectAtIndex:i];
            NSString *str=[app objectForKey:@"isClientType"];
            NSRange rannnn=[str rangeOfString:@"ios"];
            
            if (rannnn.location!=NSNotFound) {
                [IosApp addObject:app];
            }
        }
  
        [def setValue:IosApp forKey:@"iosApp"];
        [def synchronize];
        
        for (int j=0; j<IosApp.count; j++) {
            NSString *appName=[IosApp[j] objectForKey:@"linkName"];
            UIImage *appIcon=[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",documentsDirectoryPath,appName]];
            NSString *appIconPath=[IosApp[j] objectForKey:@"icon"];
            if (appIcon) {
                NSString *oldIconPath=@"";
                for (NSDictionary * oldDic in oldAppIcon) {
                    if ([[oldDic objectForKey:@"linkName"]isEqualToString:appName]) {
                        oldIconPath= [oldDic objectForKey:@"icon"];
                    }
                }
                if (![oldIconPath isEqualToString:appIconPath]) {
                    HttpDownload *hd=[[HttpDownload alloc]init];
                    hd.tag=53200+j;
                    hd.delegate=self;
                    hd.DFailed=@selector(downloadFailed:);
                    hd.DComplete=@selector(downloadComplete:);
                    [hd downloadFromUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[RootUrl getContentUrl],appIconPath]]];
                }
            }else{
                HttpDownload *hd=[[HttpDownload alloc]init];
                hd.tag=53200+j;
                hd.delegate=self;
                hd.DFailed=@selector(downloadFailed:);
                hd.DComplete=@selector(downloadComplete:);
                [hd downloadFromUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[RootUrl getContentUrl],appIconPath]]];
            }
            
        }
        
        AppLoadFailed=NO;
        if (IosApp.count) {
            if (RefreshAppIcon) {
                [self creatAppList];
                NSLog(@"刷新app展示");
            }else{
            
                [self RefreshAppIconAndName];
            }
        }else{
            AppLoadFailed=YES;
        }
    }else{
        AppLoadFailed=YES;
        NSLog(@"%@",error);
    }
}
-(void)RefreshAppIconAndName{

    for (int i=0; i<IosApp.count; i++) {
        
        MyImageView *app=(MyImageView *)[bgScrollView viewWithTag:21000+i];
        NSString *LeftUrl=[NSString stringWithFormat:@"%@%@",RootConnectUrl,IosApp[i][@"icon"]];
        [app setImageWithURL:[NSURL URLWithString:LeftUrl] placeholderImage:[UIImage imageNamed:@"loading"]];
        
        UILabel *title=(UILabel *)[bgScrollView viewWithTag:22000+i];
        title.text=[IosApp [i] objectForKey:@"linkName"];
    }

}
-(void)downloadComplete:(HttpDownload*)hd{
    //本地保存
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    NSArray *IosAppArr=[userDefaults objectForKey:@"iosApp"];
    if ((hd.tag/100)==532) {
        UIImage * imim=[UIImage imageWithData:hd.mData];
        NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        [UIImagePNGRepresentation(imim) writeToFile:[documentsDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",[[IosAppArr objectAtIndex:hd.tag-53200] objectForKey:@"linkName"]]] atomically:NO];
    }
}

-(void)downloadFailed:(HttpDownload *)hd{
    
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGPoint offset=scrollView.contentOffset;
    CGRect bounds=scrollView.frame;
    NSLog(@"%f",offset.x/bounds.size.width);
    NSLog(@"%d",NeedRefresh);
    
    [pageControl setCurrentPage:offset.x/bounds.size.width];
    
    if (pageControl.currentPage==0&&bounds.origin.y!=0) {
        [busBar.delegate selectType:0];
        
        [busBar changeNavCtr:(MyButton *)[busBar viewWithTag:800]];
    }else if (pageControl.currentPage==1&&bounds.origin.y!=0) {
        [busBar.delegate selectType:1];
        [busBar changeNavCtr:(MyButton *)[busBar viewWithTag:801]];
        busBar.redPoint.hidden=YES;
    }
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 320,44);
    btn.backgroundColor=[UIColor whiteColor];
    
    btn.tag = section+3400;
    NSArray *titles=@[@"生活助手"];
    NSArray *images=@[@"gm_live_d"];
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(40, 12, 150, 20)];
    label.text=titles[section];
    label.font=[UIFont systemFontOfSize:15];
    label.textAlignment=NSTextAlignmentLeft;
    [btn addSubview:label];
    
    UIImageView *headimage=[[UIImageView alloc]initWithFrame:CGRectMake(10, 12, 21, 21)];
    headimage.image=[UIImage imageNamed:images[section]];
    headimage.userInteractionEnabled=YES;
    
    [btn addSubview:headimage];
    btn.selected=YES;
    [btn addTarget:self action:@selector(expand:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *expand=[[UIImageView alloc ]initWithFrame:CGRectMake(290, 12, 21, 21)];
    expand.backgroundColor=[UIColor clearColor];
    expand.tag=10086;
    if (isOpen) {
        if (isRefresh) {
            [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
        }
        expand.image=[UIImage imageNamed:@"gm_up-Arrow04"];
        label.textColor=[UIColor colorWithRed:176/255.0f green:109/255.0f  blue:208/255.0f  alpha:1] ;
        
    }else{
        expand.image=[UIImage imageNamed:@"gm_down-Arrow"];
        label.textColor=[UIColor colorWithRed:64/255.0f green:78/255.0f  blue:87/255.0f  alpha:1];
        
    }
    [btn addSubview:expand];
    
    for (int i=0; i<2; i++) {
        
        UIView *lineView1=[[UIView alloc]initWithFrame:CGRectMake(0,44*i,320, 0.5)];
        lineView1.backgroundColor=[UIColor colorWithRed:215/255.f green:217/255.f blue:223/255.f alpha:0.7];
        [btn addSubview:lineView1];
        
    }
    return btn;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    
    QCLifeItem *item=[testArray objectAtIndex:indexPath.row];
    NSArray *array=[NSArray  arrayWithArray:item.contents];
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0, 0,58, 44);
    button.tag=3300;
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, 38, 44)];
    label.textColor=[UIColor colorWithRed:25/255.f green:191/255.f blue:255/255.f alpha:1];
    label.font=[UIFont systemFontOfSize:15];
    label.backgroundColor=[UIColor clearColor];
    label.text=item.categoryName;
    [button addSubview:label];
    
    UIView *lineView2=[[UIView alloc]initWithFrame:CGRectMake(55,12,0.5, 20)];
    lineView2.backgroundColor=[UIColor colorWithRed:215/255.f green:217/255.f blue:223/255.f alpha:0.7];
    [button addSubview:lineView2];
    
    [cell addSubview:button];
    
    for (int i=0; i<array.count; i++) {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(58+58*(i%4), 0+44*(i/4),58, 44);
        button.tag=3300+indexPath.row*100+i;
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 44)];
        label.textColor=[UIColor colorWithRed:51/255.f green:51/255.f blue:51/255.f alpha:1];
        label.font=[UIFont systemFontOfSize:12];
        label.text=array[i][@"linkName"];
        label.textAlignment=NSTextAlignmentCenter;
        label.backgroundColor=[UIColor clearColor];
        [button addSubview:label];
        [cell addSubview:button];
        [button addTarget:self action:@selector(btn:) forControlEvents:UIControlEventTouchUpInside];
    }
    cell.backgroundColor=[UIColor whiteColor];
    return cell;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 
#if 0
    NSMutableArray *subArray = _CurrentArray[section];
    
    if (subArray.count) {
        if (isOpen) {
            return subArray.count;
        }
    }
    return 0;
#else
    
    if (testArray.count) {
        if (isOpen) {
            return testArray.count;
        }
    }
    return 0;
    
#endif
}
//设置区头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (testArray.count) {
        QCLifeItem *item=[testArray objectAtIndex:indexPath.row];
        NSArray *array=[NSArray arrayWithArray:item.contents];
        
        if (array.count>4) {
            NSInteger row=[array count]%4==0?[array count]/4:[array count]/4+1;
            
            return 44*row;
        }else{
            return  44;
        }
    }
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section) {
        return 10.0f;
    }else{
        return 0.0f;
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [MobClick endLogPageView:@"recommend"];

}
-(void)viewWillAppear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    NSDictionary *dict = @{@"type" : @"桌面/畅游"};
    [MobClick event:@"page_select" attributes:dict];
  
    [MobClick beginLogPageView:@"recommend"];
    self.tabBarController.tabBar.hidden=NO;
    
    //每次都需要判断是否有网络
    [self initWithDataTableView];
    
    myScrollView.frame=CGRectMake(0, 44+SIZEABOUTIOSVERSION+tipsImage.frame.size.height, SCREENWIDTH, dataTableView.frame.size.height);
    
    FristView.frame=CGRectMake(0, 0, SCREENWIDTH, dataTableView.frame.size.height);
    bgScrollView.frame=FristView.frame;
    SecondView.frame=CGRectMake(SCREENWIDTH, 0, SCREENWIDTH, dataTableView.frame.size.height);
    [myScrollView setContentSize:CGSizeMake(SCREENWIDTH*2, dataTableView.frame.size.height)];
    //这里判断是否需要加载最常访问
    if (RefHisList){
        historyArray=[NSMutableArray arrayWithArray:[[MyDatabase sharedDatabase]readData:0 count:4 model:[[GMHistoryItem alloc]init]grounBy:nil orderBy:@"count" desc:YES]];
        rowCount=[historyArray count]%2==0?[historyArray count]/2:[historyArray count]/2+1;
        [recent removeFromSuperview];
        if (rowCount) {
            TabHeadView.frame=CGRectMake(0, 0, 320, 270+44*(rowCount+1)+55-70+54);
            [self creatRecentVisit];
        }else{
            TabHeadView.frame=CGRectMake(0, 0, 320, 270+45-70+54);
        }
        [dataTableView setTableHeaderView:TabHeadView];
        [dataTableView reloadData];
        RefHisList=NO;
    }
    
    //判断没网的时候 提示刷新全部页面
    if ([RootUrl getIsNetOn]) {
        if (isPassed) {
            if (NeedRefresh) {
                [busBar.delegate selectType:1];
            }
            if (AppLoadFailed) {
                [busBar.delegate selectType:0];
            }
        }else{
            if (NeedRefresh) {
                [busBar.delegate selectType:1];
            }
        }
    }else{
        NeedRefresh=YES;
        AppLoadFailed=YES;
    }
    
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
