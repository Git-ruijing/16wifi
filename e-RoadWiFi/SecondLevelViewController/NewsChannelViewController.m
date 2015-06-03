//
//  NewsChannelViewController.m
//  e路WiFi
//
//  Created by JAY on 13-12-26.
//  Copyright (c) 2013年 HE ZHENJIE. All rights reserved.
//

#import "NewsChannelViewController.h"
#import "MyButton.h"
#import "RootUrl.h"
#import "NewItem.h"
#import "UIImageView+WebCache.h"
#import "MyCellForVedio.h"
#import "MyCellForNewsTwo.h"
#import "NewsSubViewController.h"
#import "HttpRequest.h"
#import "HttpManager.h"
#import "WebSubPagViewController.h"
#import "AppDelegate.h"
#import "GetCMCCIpAdress.h"
#import "ZhuanPanViewController.h"
#define DEVICE_IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568)
#define SCREENHEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SIZEABOUTIOSVERSION ([[[UIDevice currentDevice] systemVersion] floatValue]<7.0?0:20)
#define IOSVERSIONSMALL ([[[UIDevice currentDevice] systemVersion] floatValue]<7.0?20:0)
@interface NewsChannelViewController ()

@end

@implementation NewsChannelViewController
@synthesize isPush;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor=[UIColor colorWithRed:249/252.f green:249/252.f blue:249/252.f alpha:1.f];
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
-(void)viewWillDisappear:(BOOL)animated{
    [MobClick endLogPageView:@"news"];
    [loadingAni stopAnimating];
    
    [mhd cancel];
    self.tabBarController.tabBar.hidden=NO;
//    [self.navigationController setNavigationBarHidden:NO];
}
-(void)viewWillAppear:(BOOL)animated{

    [MobClick beginLogPageView:@"news"];
    
    if (failImageFlag) {
        failImageFlag=0;
        [failImageView removeFromSuperview];
    }
    [self hideTabBar];
    self.tabBarController.tabBar.hidden=YES;
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)selectButIndex:(int)index{
    
    needLoadMore=YES;
    [_loadMoreRefreshView egoRefreshScrollViewDataSourceDidFinishedLoading:tabView];
    if (downloadflag) {
        [mhd cancel];
    }
    if (failImageFlag) {
        failImageFlag=0;
        [failImageView removeFromSuperview];
    }
    NSDictionary *dict = @{@"type" : [[SubChannels objectAtIndex:index]objectForKey:@"name"]};
    [MobClick event:@"news_select" attributes:dict];
    NSURL * murl;
    if ([[[SubChannels objectAtIndex:index] objectForKey:@"path"]hasPrefix:@"http"]) {
        murl=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[SubChannels objectAtIndex:index] objectForKey:@"path"]]];
    }else{
        murl=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[RootUrl getContentUrl],[[SubChannels objectAtIndex:index] objectForKey:@"path"]]];
    }
    
    if (index==0) {
        isReDian=1;
    }else{
        isReDian=0;
    }
    
    channelIsIn=index;
    downloadflag=1;
//    tabView.frame=CGRectZero;
    [mhd downloadFromUrl:murl];
    
    [self startAnimat];
 
    
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
    flag=1;
    [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(stopAnimat) userInfo:nil repeats:NO];
    [loadingAni startAnimating];
    loadingAni.center=aniBg.center;
    [aniBg addSubview:loadingAni];
     aniBg.center=CGPointMake(self.view.center.x, self.view.center.y+50);
    [self.view addSubview:aniBg];
    
}
-(void)startAnimat{
    [aniBg setHidden:NO];
    [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(stopAnimat) userInfo:nil repeats:NO];
    loadingAni.animationRepeatCount = 100000;
    flag=1;
    [loadingAni startAnimating];
}
-(void)stopAnimat{
    [aniBg setHidden:YES];
    flag=0;
    [loadingAni stopAnimating];
}
-(void)downloadFailed:(HttpDownload *)hd{
    NSLog(@"aa");
    [self stopAnimat];
    if (failImageFlag==0) {
        failImageFlag=1;
        [self.view addSubview:failImageView];
    }
  
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

-(void)downloadComplete:(HttpDownload*)hd{
    [self stopAnimat];
    [articlesArr removeAllObjects];
    downloadflag=0;
    NSError *error = nil;
    NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:hd.mData options:NSJSONReadingAllowFragments error:&error];
    if (error!=nil) {
        NSLog(@"json解析失败019");
    }else{
    
        NSArray *array2=[[[dict objectForKey:@"info"]objectAtIndex:0]objectForKey:@"contents"];
        
#pragma mark 这里存了内容ID 从articlesArr 数组中取得
        
        for(NSDictionary *item in array2){
            NewItem *newsItem=[[NewItem alloc]init];
            newsItem.myNewsTitle=[item objectForKey:@"contenTItitle"];
            newsItem.myNewsImage=[item objectForKey:@"titleImagePath"];
            newsItem.myNewsDescription=[item objectForKey:@"contentISubTitle"];
            newsItem.myNewsType=[NSString stringWithFormat:@"%d",((newsItem.myNewsImage.length>3)?0:1)];
            newsItem.myNewsID=[item objectForKey:@"contentIFilePath"];
            newsItem.gold=[item objectForKey:@"goldMoney"];
            newsItem.contentId=[item objectForKey:@"contentId"];
            [articlesArr addObject:newsItem];
            NSLog(@"contentId:%@",newsItem.contentId);
        }
        NSLog(@"articlesArr%lu",(unsigned long)articlesArr.count);
        
        //    tabView.contentOffset=CGPointMake(0, -SIZEABOUTIOSVERSION);
        
        tabView.frame=CGRectMake(0,84+SIZEABOUTIOSVERSION, 320, SCREENHEIGHT-106);
        tabView.bounces=YES;
        [tabView reloadData];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    failImageFlag=0;
    failImageView=[[UIView alloc]initWithFrame:CGRectMake(0,84+SIZEABOUTIOSVERSION,SCREENWIDTH,SCREENHEIGHT-84-SIZEABOUTIOSVERSION)];
    failImageView.backgroundColor=[UIColor whiteColor];
    UIImageView *imge=[[UIImageView alloc]initWithFrame:CGRectMake((SCREENWIDTH-167)/2,(SCREENHEIGHT-84-SIZEABOUTIOSVERSION-200)/2,167,90)];
    imge.image=[UIImage imageNamed:@"biaoqing.png"];
    [failImageView addSubview:imge];
    UIView* headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 44+SIZEABOUTIOSVERSION)];
    UIImageView *headerBackground=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320,44+SIZEABOUTIOSVERSION)];
    [headerView addSubview:headerBackground];
    
    headerBackground.image=[[UIImage imageNamed:@"gm_nav"]stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    
    
    UILabel * titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(110, 10+SIZEABOUTIOSVERSION, 100, 30)];
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.font=[UIFont systemFontOfSize:20];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [headerView addSubview:titleLabel];
    
    titleLabel.text=@"资讯";
 
    MyButton * goBack=[MyButton buttonWithType:UIButtonTypeCustom];
        goBack.frame=CGRectMake(0, SIZEABOUTIOSVERSION,50, 44);
    [goBack setNormalImage:[UIImage imageNamed:@"newBack"]];
    [goBack setSelectedImage:[UIImage imageNamed:@"newBack_d"]];
    [headerView addSubview:goBack];
    [goBack addTarget:self action:@selector(goBackToFront)];

    [self.view addSubview:headerView];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
         self.edgesForExtendedLayout =UIRectEdgeNone;
        
    }
    needLoadMore=YES;
    channelIsIn=0;
    isReDian=1;
    downloadflag=1;
    AdvertiseArr=[[NSMutableArray alloc]initWithCapacity:0];
    articlesArr=[[NSMutableArray alloc]initWithCapacity:0];
    scrollTitle=[[NSMutableArray alloc]initWithObjects:@"加载中...", nil];
   [self getAdvertiseData];
    
  
    
    MyScorllBar *myScroll=[[MyScorllBar alloc]initWithFrame:CGRectMake(0, 44+SIZEABOUTIOSVERSION, SCREENWIDTH, 40) andWithDelegate:self];
    [self.view addSubview:myScroll];
    
    tabView=[[UITableView alloc]init];
    tabView.bounces=NO;
    tabView.delegate=self;
    tabView.dataSource=self;
    tabView.separatorStyle=UITableViewCellSeparatorStyleNone;
    tabView.frame=CGRectMake(0,84+SIZEABOUTIOSVERSION, 320, SCREENHEIGHT-84-SIZEABOUTIOSVERSION);
    tabView.backgroundColor=[UIColor colorWithRed:249/255.f green:249/255.f blue:249/255.f alpha:1.0];
    [self.view addSubview:tabView];

    _loadMoreRefreshView = [[LoadMoreTableFooterView alloc] init];
    _loadMoreRefreshView.frame=CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 180);
    _loadMoreRefreshView.delegate = self;
    [tabView addSubview:_loadMoreRefreshView];
    
//    [self getSiteID];
    
  [self buildLoadingAnimat];
	// Do any additional setup after loading the view.
}
-(void)getAdvertiseData{
    
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    NSDictionary *jAdvertiseDic=[userDefaults objectForKey:@"advertise"];
    SubChannels=[NSMutableArray arrayWithArray:[userDefaults objectForKey:@"newsChannels"]];
    NSLog(@"SubChannels.count:%lu",(unsigned long)SubChannels.count);
    NSArray *contentsArr=[jAdvertiseDic objectForKey:@"newAdv"];
    [scrollTitle removeAllObjects];
    [AdvertiseArr removeAllObjects];
    for (NSDictionary * contentId in contentsArr) {
        NewItem *newsItem=[[NewItem alloc]init];
        NSString *str=[contentId objectForKey:@"advtiseTitle"];
        newsItem.banderTitle=str;
        newsItem.banderImageUrl=[contentId objectForKey:@"advtiseImg"];
        newsItem.banderHref=[contentId objectForKey:@"advtisePath"];
        newsItem.contentId=[contentId objectForKey:@"advtiseId"];
        newsItem.myNewsType=[contentId objectForKey:@"type"];
        [scrollTitle addObject:str];
        [AdvertiseArr addObject:newsItem];
        
    }
    NSDictionary *dict = @{@"type" : [[SubChannels objectAtIndex:0]objectForKey:@"name"]};
    [MobClick event:@"news_select" attributes:dict];
    
    NSURL * murl;
    if ([[[SubChannels objectAtIndex:0] objectForKey:@"path"]hasPrefix:@"http"]) {
        murl=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[SubChannels objectAtIndex:0] objectForKey:@"path"]]];
    }else{
        murl=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[RootUrl getContentUrl],[[SubChannels objectAtIndex:0] objectForKey:@"path"]]];
    }
    mhd=[[HttpDownload alloc]init];
    mhd.delegate=self;
    mhd.DFailed=@selector(downloadFailed:);
    mhd.DComplete=@selector(downloadComplete:);
    [mhd downloadFromUrl:murl];
    
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView.tag==121001) {
        pageCtr.currentPage = scrollView.contentOffset.x/320;
        imageTitleLable.text=[scrollTitle objectAtIndex:pageCtr.currentPage];
        NSLog(@"currentPage%ld",(long)pageCtr.currentPage);

    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    int ppp=0;
    if (isReDian) {
        ppp=1;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NewsSubViewController *subOfNews=[[NewsSubViewController alloc]init];
    subOfNews.isPush=1;
    NewItem *item=[articlesArr objectAtIndex:(indexPath.row-ppp)];
    subOfNews.newitem=item;
    NSDictionary *dict = @{@"type" : item.myNewsTitle};
    [MobClick event:@"news_list_select" attributes:dict];
    if ([item.myNewsID hasPrefix:@"http"]) {
        subOfNews.myRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:item.myNewsID]];
    }else{
        subOfNews.myRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[RootUrl getContentUrl],item.myNewsID]]];
    }
    
    [subOfNews setName:@"资讯"];
    [self.navigationController pushViewController:subOfNews animated:YES];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    int ppp=0;
    if (isReDian&&AdvertiseArr.count) {
        ppp=1;

        if (indexPath.row==0) {
            
            UITableViewCell* myCell=[tableView dequeueReusableCellWithIdentifier:@"mycell"];
            if (myCell==nil) {
                myCell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mycell"];
                
            }else{
                return myCell;
                
            }
  
            UIImageView* backImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 125)];
            backImage.image=[UIImage imageNamed:@"guanggaobg"];
            [myCell addSubview:backImage];
            
            myScrollView=[[MyScroll alloc]initWithFrame:CGRectMake(0, 0, 320, 125) andWithDelegate:self andWithPages:(int)AdvertiseArr.count];
            [myCell addSubview:myScrollView];
            myScrollView.mdelegate=self;
            myScrollView.tag=121001;
            
            UIImageView* imageTitleView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 98, 320, 27)];
            imageTitleView.image=[UIImage imageNamed:@"hei"];
            imageTitleLable=[[UILabel alloc]initWithFrame:CGRectMake(10, 1, 240, 24)];
            [imageTitleView addSubview:imageTitleLable];
            imageTitleLable.font=[UIFont systemFontOfSize:15];
            imageTitleLable.textColor=[UIColor whiteColor];
            imageTitleLable.backgroundColor=[UIColor clearColor];
            
            [myCell addSubview:imageTitleView];
            

            int p;
            for (p=0; p<[AdvertiseArr count]; p++) {
                
                NewItem *item=[AdvertiseArr objectAtIndex:p];
                NSString *imgageBannerUrl;
                if ([item.banderImageUrl hasPrefix:@"http"]) {
                    
                        imgageBannerUrl=[NSString stringWithFormat:@"%@",item.banderImageUrl];
                    
                }else{
                        imgageBannerUrl=[NSString stringWithFormat:@"%@%@",[RootUrl getContentUrl],item.banderImageUrl];
                }
   
                UIImageView * scrImageView=[myScrollView.scorllImages objectAtIndex:p];
                 [scrImageView setImageWithURL:[NSURL URLWithString:imgageBannerUrl] placeholderImage:[UIImage imageNamed:@"guanggaobg"]];
       
                if (p==0) {
                    imageTitleLable.text=[scrollTitle objectAtIndex:0];
           
                }
                
            }
      
            pageCtr=[[UIPageControl alloc]initWithFrame:CGRectMake(260, 1, 50, 24)];
            pageCtr.numberOfPages=AdvertiseArr.count;
            pageCtr.currentPage=0;
            pageCtr.currentPageIndicatorTintColor=[UIColor colorWithRed:0 green:172/255.f blue:238/255.f alpha:1.f];
            [imageTitleView addSubview:pageCtr];
            if (AdvertiseArr.count>1) {
                [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(playPage) userInfo:nil repeats:YES];
            }else{
            
                pageCtr.numberOfPages=0;
            }
            
            return myCell;
        }
    }
 
    NewItem * myItem=[articlesArr objectAtIndex:(indexPath.row-ppp)];
    if ([myItem.myNewsType isEqualToString:@"0"]) {
        MyCellForVedio  *myCell=[tableView dequeueReusableCellWithIdentifier:@"myCell"];
        if (myCell==nil) {
            myCell=[[MyCellForVedio alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myCell" iconWeight:78 IconHeight:60 andHeight:80];
        }else{
            myCell.title.text=@"";
            myCell.content.text=@"";
            [myCell.goldImage setHidden:NO];
            [myCell.goldLabel setHidden:NO];
            
        }
        myCell.title.text=myItem.myNewsTitle;
        myCell.content.text=myItem.myNewsDescription.length>26?[myItem.myNewsDescription substringToIndex:26]:myItem.myNewsDescription;
        if ([myItem.myNewsImage hasPrefix:@"http"]) {
            
            [myCell.bigImage setImageWithURL:[NSURL URLWithString:myItem.myNewsImage] placeholderImage:[UIImage imageNamed:@"down_2"]];
            
        }else{
            [myCell.bigImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[RootUrl getContentUrl],myItem.myNewsImage]] placeholderImage:[UIImage imageNamed:@"down_2"]];
            
        }
        NSLog(@"imageurl:%@",[NSString stringWithFormat:@"%@%@",[RootUrl getContentUrl],myItem.myNewsImage]);
        
        if ([myItem.gold intValue]>0) {
            myCell.goldLabel.text=myItem.gold;
        }else{
            [myCell.goldLabel setHidden:YES];
            [myCell.goldImage setHidden:YES];
        }
        
        return myCell;
        
    }else{
        MyCellForNewsTwo *myCell2=[tableView dequeueReusableCellWithIdentifier:@"mycellnoimage"];
        if (myCell2==nil) {
            myCell2=[[MyCellForNewsTwo alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mycellnoimage"];
            
        }else{
            myCell2.title.text=@"";
            myCell2.content.text=@"";
        }
        myCell2.title.text=myItem.myNewsTitle;
        myCell2.content.text=myItem.myNewsDescription;
        return myCell2;
    }
}
-(void)viewDidAppear:(BOOL)animated
{

    [self.navigationController.view setBackgroundColor:[UIColor clearColor]];
}
-(void)playPage{
    i++;
    [myScrollView scrollRectToVisible:CGRectMake(i*320, 0, 320, 125) animated:YES];
    pageCtr.currentPage=i;
    imageTitleLable.text=[scrollTitle objectAtIndex:i];
    if (i==(AdvertiseArr.count-1)) {
        i=-1;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (AdvertiseArr.count!=0) {
        
        if (isReDian) {
            if (125+articlesArr.count*80>=SCREENHEIGHT) {
                 _loadMoreRefreshView.frame=CGRectMake(0, 125+articlesArr.count*80, SCREENWIDTH, 180);
            }else{
                  _loadMoreRefreshView.frame=CGRectMake(0, SCREENHEIGHT, SCREENWIDTH-84-SIZEABOUTIOSVERSION, 180);
            }
            return ([articlesArr count]+1);
        }else{
            if (articlesArr.count*80>=SCREENHEIGHT) {
                _loadMoreRefreshView.frame=CGRectMake(0, articlesArr.count*80, SCREENWIDTH, 180);
            }else{
                _loadMoreRefreshView.frame=CGRectMake(0, SCREENHEIGHT-84-SIZEABOUTIOSVERSION, SCREENWIDTH, 180);
            }
            return  [articlesArr count];
        }
        
    }else{
        _loadMoreRefreshView.frame=CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 180);
        return 0;
    }

    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isReDian) {
        if (indexPath.row==0) {
            return 125.0f;
        }
    }

    return 80.0f;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;{
    if (buttonIndex==1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat: @"tel://%@",alertView.title]]];
    }
}
-(void)pressButtonTag:(int)tag
{
    
        NewItem *item=[AdvertiseArr objectAtIndex:tag];
#pragma mark  广告位点击统计
    NSDictionary *dict = @{@"type" : item.banderTitle};
    [MobClick event:@"adv_click" attributes:dict];
    
        NSRange ranOfApk=[item.banderHref rangeOfString:@"apk"];
        if (ranOfApk.location!=NSNotFound) {
            return;
        }
        NSRange ran=[item.banderHref rangeOfString:@"tel:"];
        if (ran.location!=NSNotFound) {
                NSString *str=[[item.banderHref componentsSeparatedByString:@"tel:"]lastObject];
                str=[[str componentsSeparatedByString:@"/"]objectAtIndex:0];
                UIAlertView *myAlert = [[UIAlertView alloc]initWithTitle:str message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拨打",nil];
                [myAlert show];
              return;
    
            }
    

    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    
    ZhuanPanViewController *bander=[[ZhuanPanViewController alloc]init];
    if ([item.banderHref hasPrefix:@"http"]) {
        
        bander.myRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",item.banderHref]]];
        
    }else{
        
        bander.myRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[RootUrl getContentUrl],item.banderHref]]];
      
    }
    
    AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [app AddCoinRequestWithType:item.myNewsType ContentId:item.contentId UserId:[def objectForKey:@"userID"]CoinNum:@"2"];
    app.delegateView=self;
    
    NSLog(@"request:%@",bander.myRequest.URL.description);
    
    bander.isPush=0;
    [self.navigationController.view setBackgroundColor:[UIColor whiteColor]];
    [self presentViewController:bander animated:YES completion:nil];
}
-(void)pageUpdate{
    [self selectButIndex:channelIsIn];
}

-(void)goBackToFront{
    if (isPush) {
        [self.navigationController dismissViewControllerAnimated:YES completion:^{}];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

#pragma mark - UIScrollViewDelegate
//正在滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.tag==121001) {

    }else{
        [_loadMoreRefreshView egoRefreshScrollViewDidScroll:scrollView];
    }

}
//减速停止的时候调用
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView.tag==121001) {

    }else{
        [_loadMoreRefreshView egoRefreshScrollViewDidEndDragging:scrollView];
        Offset=scrollView.contentOffset;
    }
}

//实现 EGO协议中的方法
#pragma mark - EGO协议中的方法
//判断 是否在执行刷新操作  如果返回YES 正在执行刷新  NO 部没有执行刷新 现在可以刷新

-(void)loadMoreTableFooterDidTriggerLoadMore:(LoadMoreTableFooterView *)view{
    
    if (_isRefreshing) {
        return;
    }
    
    NSLog(@"channelId：%@",[[SubChannels objectAtIndex:channelIsIn] objectForKey:@"channelId"]);
    NewItem *item=[articlesArr lastObject];
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    
    NSString *SiteId=@"http://moreinfo.16wifi.com:2082";
    
    if (needLoadMore) {
        
        [self addTask:[NSString stringWithFormat:@"%@/contentAct/v_contentHistoryList.do?channelId=%@&contentId=%@&siteId=%@&APmac=%@&mac=%@&userName=%@&showtype=down",SiteId,[[SubChannels objectAtIndex:channelIsIn] objectForKey:@"channelId"],item.contentId,[RootUrl getCity],[GetCMCCIpAdress getBSSIDStandard],[RootUrl getIDFA],[def objectForKey:@"userPhone"]] action:@selector(LoadMoreRequestFinished:)];
            timer=[NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(stopLoadMore) userInfo:nil repeats:NO];

    }
    
}
-(void)getSiteID{
    
    [self addTask:[NSString stringWithFormat:@"http://111.13.47.152:8081/siteAct/v_siteJson.do?siteId=%@",[RootUrl getCity]] action:@selector(MoreRequestFinished:)];
    
}
-(void)MoreRequestFinished:(HttpRequest *)request{
    
    [curTaskDict removeObjectForKey:request.httpUrl];
    NSError *error;
    NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:request.downloadData options:NSJSONReadingMutableContainers error:&error];
    if (dict) {
        NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
        [def setObject:[dict objectForKey:@"domain"] forKey:@"SiteId"];
        [def synchronize];
        
    }else{
        NSLog(@"%@",error);
    }
    
}
-(void)stopLoadMore{
    
    [_loadMoreRefreshView egoRefreshScrollViewDataSourceDidFinishedLoading:tabView];
    AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [app setNotice:@"网络不给力，加载失败，请重试！"];
}

-(void)LoadMoreRequestFinished:(HttpRequest *)MoreRequest{
    //    satus = 0; 标示加载成功
    [curTaskDict removeObjectForKey:MoreRequest.httpUrl];
    NSError *error;
    NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:MoreRequest.downloadData options:NSJSONReadingMutableContainers error:&error];
    if (dict) {
        NSArray *array2=[[dict objectForKey:@"info"]objectForKey:@"contents"];
        if (array2.count==0) {
            AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
            [app setNotice:@"亲，已经是最后一条了···"];
            
        _loadMoreRefreshView.frame=CGRectMake(0, 1000000, SCREENWIDTH, 180);
            needLoadMore=NO;
        }else{
            for(NSDictionary *item in array2){
                NewItem *newsItem=[[NewItem alloc]init];
                newsItem.myNewsTitle=[item objectForKey:@"contenTItitle"];
                newsItem.myNewsImage=[item objectForKey:@"titleImagePath"];
                newsItem.myNewsDescription=[item objectForKey:@"contentISubTitle"];
                newsItem.myNewsType=[NSString stringWithFormat:@"%d",((newsItem.myNewsImage.length>3)?0:1)];
                newsItem.myNewsID=[item objectForKey:@"contentIFilePath"];
                newsItem.gold=[item objectForKey:@"goldMoney"];
                newsItem.contentId=[item objectForKey:@"contentId"];
                newsItem.showGold=[item objectForKey:@"showGold"];
                [articlesArr addObject:newsItem];
            }
        
        }
        isLoading=NO;
        _isRefreshing=NO;
        
        [_loadMoreRefreshView egoRefreshScrollViewDataSourceDidFinishedLoading:tabView];
        
        [timer invalidate];
        if (array2.count!=0) {
        [tabView setContentOffset:Offset animated:NO];
              [tabView reloadData];
        }
   
    }else{
        NSLog(@"%@",error);
        [self stopLoadMore];
        
    }
    
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
