//
//  VedioViewController.m
//  16wifipro
//
//  Created by JAY on 14-7-9.
//  Copyright (c) 2014年 HE ZHENJIE. All rights reserved.
//

#import "VedioViewController.h"
#import "VedioItem.h"
#import "MyCellForVedio.h"
#import "RootUrl.h"
#import "MobClick.h"
#import "WebSubPagViewController.h"
#import "UIImageView+WebCache.h"
#import "SubOfVedioViewController.h"
#import "UIViewController+setTabBarStatus.h"
#define DEVICE_IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568)
#define SCREENHEIGHT ([[UIScreen mainScreen] bounds].size.height)
@interface VedioViewController ()

@end

@implementation VedioViewController
@synthesize jTabView;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)gohome{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)goBackToFront{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    if (failImageFlag) {
        [failImageView removeFromSuperview];
    }
    [MobClick beginLogPageView:@"video"];
    [self hideTabBar];
    self.tabBarController.tabBar.hidden=YES;
    [self.navigationController setNavigationBarHidden:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [MobClick endLogPageView:@"video"];
    self.tabBarController.tabBar.hidden=NO;

    [loadingAni stopAnimating];

}
-(void)selectButtonIndex:(int)index
{
    if (failImageFlag) {
        failImageFlag=0;
        [failImageView removeFromSuperview];
    }
    switch (index) {
        case 0:
        {
            NSDictionary *dict = @{@"type" : @"搞笑"};
            [MobClick event:@"video_select" attributes:dict];
            NSURL * murl=[NSURL URLWithString:[NSString stringWithFormat:@"%@/json/funny.json",[RootUrl getContentUrl]]];
            mhd=[[HttpDownload alloc]init];
            mhd.delegate=self;
            mhd.DFailed=@selector(downloadFailed:);
            mhd.DComplete=@selector(downloadComplete:);

            [mhd downloadFromUrl:murl];
            [self startAnimat];
            break;
        }
        case 1:
        {
            NSDictionary *dict = @{@"type" : @"娱乐"};
            [MobClick event:@"video_select" attributes:dict];
            NSURL * murl=[NSURL URLWithString:[NSString stringWithFormat:@"%@/json/amusement.json",[RootUrl getContentUrl]]];
            mhd=[[HttpDownload alloc]init];
            mhd.delegate=self;
            mhd.DFailed=@selector(downloadFailed:);
            mhd.DComplete=@selector(downloadComplete:);
            [mhd downloadFromUrl:murl];
            [self startAnimat];
            break;
        }
        case 2:
        {
            NSDictionary *dict = @{@"type" : @"微电影"};
            [MobClick event:@"video_select" attributes:dict];
            NSURL * murl=[NSURL URLWithString:[NSString stringWithFormat:@"%@/json/microfilms.json",[RootUrl getContentUrl]]];
            mhd=[[HttpDownload alloc]init];
            mhd.delegate=self;
            mhd.DFailed=@selector(downloadFailed:);
            mhd.DComplete=@selector(downloadComplete:);
            [mhd downloadFromUrl:murl];
            [self startAnimat];
            break;
        }
        case 3:
        {
            NSDictionary *dict = @{@"type" : @"综合"};
            [MobClick event:@"video_select" attributes:dict];
            NSURL * murl=[NSURL URLWithString:[NSString stringWithFormat:@"%@/json/cartoons.json",[RootUrl getContentUrl]]];
            mhd=[[HttpDownload alloc]init];
            mhd.delegate=self;
            mhd.DFailed=@selector(downloadFailed:);
            mhd.DComplete=@selector(downloadComplete:);
            [mhd downloadFromUrl:murl];
            [self startAnimat];
            break;
        }
            
        default:
            break;
    }
    pflag=index+1;

    
    [jTabView reloadData];
    
}
-(void)downloadFailed:(HttpDownload *)hd{
    [self stopAnimat];
    if (failImageFlag==0) {
        failImageFlag=1;
        [self.view addSubview:failImageView];
    }
    
}
-(void)downloadComplete:(HttpDownload*)hd{
    [self stopAnimat];

    [ContentArr removeAllObjects];
    NSError *error = nil;
    NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:hd.mData options:NSJSONReadingAllowFragments error:&error];
    if (error!=nil) {
        NSLog(@"json解析失败25");
    }else{
    
        NSArray *jContentArray=[[[dict objectForKey:@"info"]objectAtIndex:0]objectForKey:@"contents"];
        for(NSDictionary *item in jContentArray){
            VedioItem *itemV=[[VedioItem alloc]init];
            itemV.vedioDescription=[item objectForKey:@"contentISubTitle"];
            itemV.vedioUrl=[item objectForKey:@"downLoadPath"];
            itemV.vedioImage=[item objectForKey:@"titleImagePath"];
            itemV.vedioTitle=[item objectForKey:@"contenTItitle"];
            itemV.vedioDuration=[item objectForKey:@"mediaLenth"];
            itemV.vedioLabel=[item objectForKey:@"tag"];
            itemV.gold=[item objectForKey:@"goldMoney"];
            itemV.contentId=[item objectForKey:@"contentId"];
            itemV.contentIFilePath=[item objectForKey:@"contentIFilePath"];
            [ContentArr addObject:itemV];
            
        }
        
        self.jTabView.separatorStyle=UITableViewCellSeparatorStyleNone;
        if ([[[UIDevice currentDevice]systemVersion]floatValue] <7) {
            self.jTabView.frame =CGRectMake(0, 93, 320, SCREENHEIGHT-113);
        }else{
            self.jTabView.frame=CGRectMake(0, 93, 320, SCREENHEIGHT-53);
        }
        
        [self.jTabView reloadData];
        self.jTabView.contentOffset=CGPointMake(0, -SIZEABOUTIOSVERSION);
    }
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    failImageFlag=0;
    failImageView=[[UIView alloc]initWithFrame:CGRectMake(0,95+SIZEABOUTIOSVERSION,SCREENWIDTH,SCREENHEIGHT-95-SIZEABOUTIOSVERSION)];
    failImageView.backgroundColor=[UIColor whiteColor];
    UIImageView *imge=[[UIImageView alloc]initWithFrame:CGRectMake((SCREENWIDTH-167)/2,(SCREENHEIGHT-95-SIZEABOUTIOSVERSION-200)/2,167,90)];
    imge.image=[UIImage imageNamed:@"biaoqing.png"];
    [failImageView addSubview:imge];
   
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0) {
        
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    self.view.backgroundColor=[UIColor whiteColor];
    
    
    UIView* headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 95+SIZEABOUTIOSVERSION)];
    UIImageView *headerBackground=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320,95+SIZEABOUTIOSVERSION)];
    [headerView addSubview:headerBackground];
    
    headerBackground.image=[[UIImage imageNamed:@"gm_nav"]stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    
    
    UILabel * titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(110, 10+SIZEABOUTIOSVERSION, 100, 30)];
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.font=[UIFont systemFontOfSize:20];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [headerView addSubview:titleLabel];
    
    titleLabel.text=@"看吧";
    
    MyButton * goBack=[MyButton buttonWithType:UIButtonTypeCustom];
        goBack.frame=CGRectMake(0, SIZEABOUTIOSVERSION,50, 44);
    [goBack setNormalImage:[UIImage imageNamed:@"newBack"]];
    [goBack setSelectedImage:[UIImage imageNamed:@"newBack_d"]];
    [headerView addSubview:goBack];
    [goBack addTarget:self action:@selector(goBackToFront)];
    
    
    
    MyTitleScrollBar *titleSrollBar=[[MyTitleScrollBar alloc]initWithFrame:CGRectMake(10, 45+SIZEABOUTIOSVERSION,300, 35) andWithDelegate:self];
    
    self.jTabView=[[UITableView alloc]initWithFrame:CGRectMake(0,85+SIZEABOUTIOSVERSION,0, 0)];
    self.jTabView.delegate=self;
    self.jTabView.dataSource=self;
    self.jTabView.bounces=NO;
    self.jTabView.backgroundColor=[UIColor colorWithRed:242/255.f green:242/255.f blue:242/255.f alpha:1.0];
    [self.view addSubview:self.jTabView];
    [self.view addSubview:headerView];

    
    [self.view addSubview:titleSrollBar];
    
   

    ContentArr=[[NSMutableArray alloc]initWithCapacity:0];
    pflag=1;
    isFirst=0;
    NSDictionary *dict = @{@"type" : @"搞笑"};
    [MobClick event:@"video_select" attributes:dict];
    
    NSURL * murl=[NSURL URLWithString:[NSString stringWithFormat:@"%@/json/funny.json",[RootUrl getContentUrl]]];
    
    
    mhd=[[HttpDownload alloc]init];
    mhd.delegate=self;
    mhd.DFailed=@selector(downloadFailed:);
    mhd.DComplete=@selector(downloadComplete:);
    [mhd downloadFromUrl:murl];
    [self buildLoadingAnimat];
	// Do any additional setup after loading the view.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SubOfVedioViewController *vedioPage=[[SubOfVedioViewController alloc]init];

    vedioPage.itemArray=ContentArr;
    
    vedioPage.channel=pflag;
    vedioPage.inPages=(int)indexPath.row;
    
    VedioItem *item=[ContentArr objectAtIndex:indexPath.row];
  
    NSDictionary *dict = @{@"type" : item.vedioTitle};
    [MobClick event:@"video_list_select" attributes:dict];
    NSString *str=[RootUrl getContentUrl];
    NSString *murl;
    if ([item.vedioUrl hasPrefix:@"http"]) {
        
             murl=item.vedioUrl;

    }else{
        
        if ([str isEqualToString:@"http://192.100.100.100"]) {
            
            murl=[NSString stringWithFormat:@"%@:8090%@",str,item.vedioUrl];
            
        }else{
            murl=[NSString stringWithFormat:@"%@%@",str,item.vedioUrl];
        }
        
    }
    NSLog(@"vedioUrl：%@",murl);
    vedioPage.vedioUrl=[NSURL URLWithString:murl];
    
    if (![murl hasSuffix:@".mp4"]) {
        UIAlertView *myAlert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"您访问的视频文件已删除或损坏，请选择其他视频资源！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [myAlert show];
        return;
    }
    
    [self.navigationController.view setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController pushViewController:vedioPage animated:YES];
    
}

-(void)buildLoadingAnimat{
    aniBg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 77, 77)];
    aniBg.image=[UIImage imageNamed:@"jiazaibg"];
    NSArray *imageArray=[NSArray arrayWithObjects:[UIImage imageNamed:@"tu1"],[UIImage imageNamed:@"tu2"],[UIImage imageNamed:@"tu3"],[UIImage imageNamed:@"tu4"], nil];
    loadingAni=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 77,77)];
    loadingAni.image=[UIImage imageNamed:@"tu1"];
    loadingAni.animationImages =imageArray;
    
    loadingAni.animationDuration = [loadingAni.animationImages count] * 1/5.0;
    [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(stopAnimat) userInfo:nil repeats:NO];
    loadingAni.animationRepeatCount = 100000;

    [loadingAni startAnimating];
    loadingAni.center=aniBg.center;
    [aniBg addSubview:loadingAni];
    aniBg.center=CGPointMake(self.view.center.x, self.view.center.y+40);
    [self.view addSubview:aniBg];
    
    
}

-(void)startAnimat{
    [aniBg setHidden:NO];
    loadingAni.animationRepeatCount = 100000;

    [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(stopAnimat) userInfo:nil repeats:NO];
    [loadingAni startAnimating];
}
-(void)stopAnimat{
    [aniBg setHidden:YES];
    [loadingAni stopAnimating];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyCellForVedio *myCell=[tableView dequeueReusableCellWithIdentifier:@"myCell"];
    if (myCell==nil) {
        myCell=[[MyCellForVedio alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myCell" iconWeight:78 IconHeight:60 andHeight:80];

    }else{
        myCell.bigImage.image=nil;
        myCell.title.text=@"";
        myCell.content.text=@"";
        [myCell.goldImage setHidden:NO];
        [myCell.goldLabel setHidden:NO];
    }

    VedioItem *itemArt;
    itemArt=[ContentArr objectAtIndex:indexPath.row];
    myCell.title.text=itemArt.vedioTitle;
    myCell.content.text=itemArt.vedioDescription.length>26?[itemArt.vedioDescription substringToIndex:26]:itemArt.vedioDescription;
    if ([itemArt.vedioImage hasPrefix:@"http"]) {
            [myCell.bigImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",itemArt.vedioImage]] placeholderImage:[UIImage imageNamed:@"down_2"]];
    }else{
    
            [myCell.bigImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[RootUrl getContentUrl],itemArt.vedioImage]] placeholderImage:[UIImage imageNamed:@"down_2"]];
    }

    if ([itemArt.gold intValue]>0) {
        myCell.goldLabel.text=itemArt.gold;
    }else{
        [myCell.goldLabel setHidden:YES];
        [myCell.goldImage setHidden:YES];
    }
    return myCell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

 

    return ContentArr.count;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    return 80.0f;
}


@end
