//
//  DownListViewController.m
//  e-RoadWiFi
//
//  Created by QC on 15/3/31.
//  Copyright (c) 2015年 G.MING. All rights reserved.
//

#import "DownListViewController.h"
#import "NewItem.h"
#import "RootUrl.h"
#import "UIImageView+WebCache.h"
#import "MyCellForVedio.h"
#import "MyCellForNewsTwo.h"
#import "MobClick.h"
#import "WebSubPagViewController.h"
#import "AppDelegate.h"
@interface DownListViewController ()

@end

@implementation DownListViewController

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


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1];
    
    failImageFlag=0;
    failImageView=[[UIView alloc]initWithFrame:CGRectMake(0,44+SIZEABOUTIOSVERSION+125,SCREENWIDTH,SCREENHEIGHT-44-SIZEABOUTIOSVERSION-125)];
    failImageView.backgroundColor=[UIColor whiteColor];
    UIImageView *imge=[[UIImageView alloc]initWithFrame:CGRectMake((SCREENWIDTH-167)/2,(SCREENHEIGHT-84-SIZEABOUTIOSVERSION-200)/2,167,90)];
    imge.image=[UIImage imageNamed:@"biaoqing.png"];
    [failImageView addSubview:imge];

    
    [self addNavAndTitle:_HeadTitle withFrame:CGRectMake(0, 0, 320, 44+SIZEABOUTIOSVERSION)];
    
    AdvertiseArr=[[NSMutableArray alloc]initWithCapacity:0];
    articlesArr=[[NSMutableArray alloc]initWithCapacity:0];
    scrollTitle=[[NSMutableArray alloc]initWithObjects:@"加载中...", nil];
    
    [self getAdvDataWithTag:_IndexTag];
    
    tabView=[[UITableView alloc]init];
    tabView.bounces=NO;
    
    tabView.delegate=self;
    tabView.dataSource=self;
    tabView.separatorStyle=UITableViewCellSeparatorStyleNone;
    tabView.frame=CGRectMake(0,44+SIZEABOUTIOSVERSION, 320, SCREENHEIGHT-44-SIZEABOUTIOSVERSION);
    tabView.backgroundColor=[UIColor colorWithRed:249/255.f green:249/255.f blue:249/255.f alpha:1.0];
    [self.view addSubview:tabView];
    
      [self buildLoadingAnimat];
    // Do any additional setup after loading the view.
}
-(void)getAdvDataWithTag:(NSString *)index{

    NSArray *type=@[@"AppAdv",@"GameAdv"];
    NSArray *adress=@[@"/json/wifiapp.json",@"/json/wifigame.json"];
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    NSDictionary *jAdvertiseDic=[userDefaults objectForKey:@"advertise"];
    int tag=[index intValue];
    NSArray *contentsArr=[jAdvertiseDic objectForKey:type[tag]];
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

    NSDictionary *dict = @{@"type" : _TypeStr};
    [MobClick event:[NSString stringWithFormat:@"%@_select",_TypeStr] attributes:dict];
    
    NSURL * murl=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[RootUrl getContentUrl],[adress objectAtIndex:tag]]];
    mhd=[[HttpDownload alloc]init];
    mhd.delegate=self;
    mhd.DFailed=@selector(downloadFailed:);
    mhd.DComplete=@selector(downloadComplete:);
    mhd.tag=150402;
    [mhd downloadFromUrl:murl];
    
}

-(void)downloadComplete:(HttpDownload*)hd{
    
    if (hd.tag==150402) {
        
        [self stopAnimat];
        [articlesArr removeAllObjects];
        NSError *error = nil;
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:hd.mData options:NSJSONReadingAllowFragments error:&error];
        if (error!=nil) {
            NSLog(@"json解析失败019");
        }else{
            
            NSArray *array2=[[[dict objectForKey:@"info"]objectAtIndex:0]objectForKey:@"contents"];
            for(NSDictionary *item in array2){
                NSString *str=[item objectForKey:@"clientType"];
                NSRange rannnn=[str rangeOfString:@"ios"];
                if (rannnn.location!=NSNotFound) {
                    
                    NewItem *newsItem=[[NewItem alloc]init];
                    newsItem.myNewsTitle=[item objectForKey:@"contenTItitle"];
                    newsItem.myNewsImage=[item objectForKey:@"titleImagePath"];
                    newsItem.myNewsDescription=[item objectForKey:@"mediaFileSize"];
                    newsItem.myNewsID=[item objectForKey:@"contentIFilePath"];
                    newsItem.gold=[item objectForKey:@"goldMoney"];
                    newsItem.AppStoreId=[item objectForKey:@"iosAppStoreId"];
                    newsItem.contentId=[item objectForKey:@"contentId"];
                    newsItem.myNewsType=[item objectForKey:@"applicationCategory"];//分类
                    newsItem.UrlScheme=[item objectForKey:@"iosUrlScheme"];
                    newsItem.iosLinkPath=[item objectForKey:@"iosLinkPath"];
                    [articlesArr addObject:newsItem];

                }
                
            }
            //    tabView.contentOffset=CGPointMake(0, -SIZEABOUTIOSVERSION);
            
            tabView.frame=CGRectMake(0,44+SIZEABOUTIOSVERSION, 320, SCREENHEIGHT-106+40);
            tabView.bounces=YES;
            [tabView reloadData];
        }


    }
}

-(void)downloadFailed:(HttpDownload *)hd{
    NSLog(@"aa");
    [self stopAnimat];
    if (failImageFlag==0) {
        failImageFlag=1;
        [self.view addSubview:failImageView];
    }
    
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
    [NSTimer scheduledTimerWithTimeInterval:100 target:self selector:@selector(stopAnimat) userInfo:nil repeats:NO];
    [loadingAni startAnimating];
    loadingAni.center=aniBg.center;
    [aniBg addSubview:loadingAni];
    aniBg.center=CGPointMake(self.view.center.x, self.view.center.y+40);
    [self.view addSubview:aniBg];
    
}

-(void)startAnimat{
    [aniBg setHidden:NO];
    [NSTimer scheduledTimerWithTimeInterval:100 target:self selector:@selector(stopAnimat) userInfo:nil repeats:NO];
    loadingAni.animationRepeatCount = 10000000;
    flag=1;
    [loadingAni startAnimating];
}
-(void)stopAnimat{
    [aniBg setHidden:YES];
    flag=0;
    [loadingAni stopAnimating];
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
    NewItem *item;

    if (AdvertiseArr.count) {
            item=[articlesArr objectAtIndex:(indexPath.row-1)];
    }else{
        item=[articlesArr objectAtIndex:(indexPath.row)];
        
    }

    if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:item.UrlScheme]]) {

        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:item.UrlScheme]];
        
    }else{
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:item.iosLinkPath]];
        
        if([item.gold intValue]){

            NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
            AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
            if ([_IndexTag intValue]) {
                
            [app AddCoinRequestWithType:@"con_game" ContentId:item.contentId UserId:[def objectForKey:@"userID"]CoinNum:@"2"];
            }else{
            
            [app AddCoinRequestWithType:@"con_app" ContentId:item.contentId UserId:[def objectForKey:@"userID"]CoinNum:@"2"];
            }
    
            app.delegateView=self;
        }
    }
    
    NSDictionary *dict = @{@"type" : item.myNewsTitle};
    [MobClick event:@"news_list_select" attributes:dict];

     [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark  应用游戏页面cell点击调用方法 栗子：
-(void)openAppWithIdentifier:(NSString *)appId {
    NSLog(@"appid:%@",appId);
    storeProductVC = [[SKStoreProductViewController alloc] init];
    
    storeProductVC.delegate = self;
    
    NSDictionary *dict = [NSDictionary dictionaryWithObject:appId forKey:SKStoreProductParameterITunesItemIdentifier];

    [self presentViewController:storeProductVC animated:YES completion:^{
        [aniBg setHidden:NO];
        [self startAnimat];
        [storeProductVC.view addSubview:aniBg];
    }];
    [storeProductVC loadProductWithParameters:dict completionBlock:^(BOOL result, NSError *error) {
        NSLog(@"321");
        if (result) {
            NSLog(@"322");
            [self stopAnimat];
            [aniBg setHidden:YES];
        }else{
            NSLog(@"323");
            [self stopAnimat];
            AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
            [app setNotice:@"Sorry!官方APPStore访问失败！"];
            [storeProductVC dismissViewControllerAnimated:YES completion:nil];
        }
        
        
    }];

  
    
    
}
-(void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    [viewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    int ppp=0;
    if (AdvertiseArr.count) {
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
            myScrollView.tag=150331;
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
                        imgageBannerUrl=item.banderImageUrl;
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

        MyCellForVedio  *myCell=[tableView dequeueReusableCellWithIdentifier:@"AppCell"];
        if (myCell==nil) {
            myCell=[[MyCellForVedio alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AppCell" iconWeight:57 IconHeight:57 andHeight:80];
            myCell.DownLoad.hidden=NO;
        }else{
            myCell.title.text=@"";
            myCell.content.text=@"";
            [myCell.goldImage setHidden:NO];
            [myCell.goldLabel setHidden:NO];
        }
        myCell.title.text=[NSString stringWithFormat:@"%@",myItem.myNewsTitle];
        myCell.content.text=[NSString stringWithFormat:@"  \n%@   %@",myItem.myNewsType,myItem.myNewsDescription];

    if ([myItem.myNewsImage hasPrefix:@"http"]) {
            
            [myCell.bigImage setImageWithURL:[NSURL URLWithString:myItem.myNewsImage] placeholderImage:[UIImage imageNamed:@"down_2"]];
        }else{
            [myCell.bigImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[RootUrl getContentUrl],myItem.myNewsImage]] placeholderImage:[UIImage imageNamed:@"down_2"]];
            
        }
    
    if ([myItem.gold intValue]>0) {
        myCell.goldLabel.text=myItem.gold;
    }else{
        [myCell.goldLabel setHidden:YES];
        [myCell.goldImage setHidden:YES];
    }
    NSLog(@"%@,%@",myItem.UrlScheme,myItem.myNewsTitle);
    if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:myItem.UrlScheme]]) {
        [myCell.DownLoad setTitle:@"打开" forState:UIControlStateNormal];
    
    }else{
        [myCell.DownLoad setTitle:@"安装" forState:UIControlStateNormal];
    }
    
        return myCell;
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
    
        return ([articlesArr count]+1);
    }else{
        return articlesArr.count;
    }
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (AdvertiseArr.count!=0) {
        
        if (indexPath.row==0) {
            return 125.0f;
        }
        return 80.0f;
    }else{
        return 80.0f;
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
    
    NSRange MyRan=[item.banderHref rangeOfString:@"16wifi.com"];
    if (MyRan.location!=NSNotFound) {
        
        if ([item.banderHref hasPrefix:@"http"]) {
            
            bander.myRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",item.banderHref]]];
                
        }else{
                
            bander.myRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[RootUrl getContentUrl],item.banderHref]]];
                
        }
        
        bander.isPush=0;
        [self.navigationController.view setBackgroundColor:[UIColor whiteColor]];
        [self presentViewController:bander animated:YES completion:nil];

    }else{
        NSLog(@"banderHref:%@",item.banderHref);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:item.banderHref]];
    }
    
    
    AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [app AddCoinRequestWithType:item.myNewsType ContentId:item.contentId UserId:[def objectForKey:@"userID"]CoinNum:@"2"];
    app.delegateView=self;
    
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
    [MobClick endLogPageView:_TypeStr];
    [loadingAni stopAnimating];
    
    [mhd cancel];
    self.tabBarController.tabBar.hidden=NO;
    //    [self.navigationController setNavigationBarHidden:NO];
}
-(void)viewWillAppear:(BOOL)animated{
    
    [MobClick beginLogPageView:_TypeStr];
    
    if (failImageFlag) {
        failImageFlag=0;
        [failImageView removeFromSuperview];
    }
    [self hideTabBar];
    self.tabBarController.tabBar.hidden=YES;
    [self.navigationController setNavigationBarHidden:YES];
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
