//
//  MyOwnObjectViewController.m
//  e路WiFi
//
//  Created by JAY on 14-3-26.
//  Copyright (c) 2014年 HE ZHENJIE. All rights reserved.
//

#import "MyOwnObjectViewController.h"
#import "MobClick.h"
#import "RootUrl.h"
#import "GoodsDetailViewController.h"
#import "UIImageView+WebCache.h"
#define ROOTURLFORBANNER @"http://111.13.47.155/usersystem/"
#import "GetCMCCIpAdress.h"
#import "HttpManager.h"
#import "HttpRequest.h"
@interface MyOwnObjectViewController ()

@end

@implementation MyOwnObjectViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    if (self) {
        
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
-(void)viewWillDisappear:(BOOL)animated{
    [MobClick endLogPageView:@"myOwnObject"];
    self.tabBarController.tabBar.hidden=NO;
    [self.navigationController setNavigationBarHidden:NO];
    
}
-(void)viewWillAppear:(BOOL)animated{
    NSDictionary *dict = @{@"type" : @"myOwnObject"};
    [MobClick event:@"click" attributes:dict];
    [MobClick beginLogPageView:@"myOwnObject"];
    [self hideTabBar];
    self.tabBarController.tabBar.hidden=YES;
    [self.navigationController setNavigationBarHidden:YES];

    NSLog(@"ListType:%d ---%d",[[[NSUserDefaults standardUserDefaults] objectForKey:@"ListType"] intValue],_IsRefresh);
    
    if (_IsRefresh) {
        [self loadMyListViewWithTag:[[[NSUserDefaults standardUserDefaults] objectForKey:@"ListType"] intValue]];
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
    downloadflag=1;
    myGoodsDataArray=[[NSMutableArray alloc]initWithCapacity:0];
    UIView * headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 95+SIZEABOUTIOSVERSION)];
    UIImageView *headerBackground=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320,95+SIZEABOUTIOSVERSION)];
    [headerView addSubview:headerBackground];
    headerBackground.image=[[UIImage imageNamed:@"gm_nav"]stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    [self.view addSubview:headerView];
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(110, 10+SIZEABOUTIOSVERSION, 100, 30)];
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.font=[UIFont systemFontOfSize:20];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [headerView addSubview:titleLabel];
    titleLabel.text=@"我的卡包";
    
    MyButton * goBack=[MyButton buttonWithType:UIButtonTypeCustom];
    goBack.frame=CGRectMake(0, SIZEABOUTIOSVERSION,50, 44);
    [goBack setNormalImage:[UIImage imageNamed:@"newBack"]];
    [goBack setSelectedImage:[UIImage imageNamed:@"newBack_d"]];
    [headerView addSubview:goBack];
    [goBack addTarget:self action:@selector(goBackToSuperPage)];
    
     MyTitleBarForMyGoods *titleSrollBar=[[MyTitleBarForMyGoods alloc]initWithFrame:CGRectMake(10, 45+SIZEABOUTIOSVERSION,300, 35) andWithDelegate:self];
    [headerView addSubview:titleSrollBar];
    
    noDataBg=[[UIView alloc]initWithFrame:CGRectMake(102, 200, 115, 69+25+20)];
    noDataBg.hidden=YES;
    
    UIImageView * noDataImage=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,115,69)];
    [noDataImage setImage:[UIImage imageNamed:@"biaoqingforlose.png"]];
    [noDataBg addSubview:noDataImage];
    
    UILabel *bigWord=[[UILabel alloc]initWithFrame:CGRectMake(0,69,116,25)];
    bigWord.backgroundColor=[UIColor clearColor];
    bigWord.textAlignment=NSTextAlignmentCenter;
    bigWord.font=[UIFont boldSystemFontOfSize:17];
    bigWord.text=@"您还没有宝贝";
    [noDataBg addSubview:bigWord];
    
    UILabel *smallWord=[[UILabel alloc]initWithFrame:CGRectMake(0,69+25,120,20)];
    smallWord.backgroundColor=[UIColor clearColor];
    smallWord.textColor=[UIColor grayColor];
    smallWord.font=[UIFont systemFontOfSize:12];
    smallWord.textAlignment=NSTextAlignmentCenter;
    smallWord.text=@"火速前往商城领取吧";
    [noDataBg addSubview:smallWord];
    
    
    myTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,95+SIZEABOUTIOSVERSION,SCREENHEIGHT-95,0)];
    myTableView.delegate=self;
    myTableView.dataSource=self;
    myTableView.bounces=NO;
    //myTableView.backgroundColor=[UIColor colorWithRed:242/255.f green:242/255.f blue:242/255.f alpha:1.0];
    myTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:myTableView];

    [self.view addSubview:noDataBg];
    
    [self buildLoadingAnimat];
    
    [self initListView];

    // Do any additional setup after loading the view.
}
-(void)initListView{

    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"hhmmss"];
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSString stringWithFormat:@"0"] forKey:@"ListType"];
    [userDefaults synchronize];
    
    NSString *qString=[NSString stringWithFormat:@"mod=mystuffnew&uid=%@&flag=0&ntime=%@",[userDefaults objectForKey:@"userID"],[dateformatter stringFromDate:[NSDate date]]];
    NSData *secretData=[qString dataUsingEncoding:NSUTF8StringEncoding];
    NSData *qValueData=[secretData AES256EncryptWithKey:SECRETKEY];
    NSString *qValue=[qValueData newStringInBase64FromData];
    if([RootUrl getIsNetOn]||[[GetCMCCIpAdress getSSID]isEqualToString:@"16wifi"]){
        
        NSURL * murl=[NSURL URLWithString:[NSString stringWithFormat:@"%@/app_api/shop/mystuffnew.html?q=%@",NewBaseUrl,qValue]];
        mhd=[[HttpDownload alloc]init];
        mhd.delegate=self;
        mhd.DFailed=@selector(downloadFailed:);
        mhd.DComplete=@selector(downloadComplete:);
        [mhd downloadFromUrl:murl];
        
        [self startAnimat];
        
    }else{
        noDataBg.hidden=NO;
    }

}
-(void)loadMyListViewWithTag:(int)index{
    if (!index) {
        index=0;
    }
    NSLog(@"index:%d",index);
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"hhmmss"];
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSString stringWithFormat:@"%d",index] forKey:@"ListType"];
    [userDefaults synchronize];
    
    NSString *qString=[NSString stringWithFormat:@"mod=mystuffnew&uid=%@&flag=%d&ntime=%@",[userDefaults objectForKey:@"userID"],index,[dateformatter stringFromDate:[NSDate date]]];
    NSData *secretData=[qString dataUsingEncoding:NSUTF8StringEncoding];
    NSData *qValueData=[secretData AES256EncryptWithKey:SECRETKEY];
    NSString *qValue=[qValueData newStringInBase64FromData];
    if([RootUrl getIsNetOn]||[[GetCMCCIpAdress getSSID]isEqualToString:@"16wifi"]){
        
        NSURL * murl=[NSURL URLWithString:[NSString stringWithFormat:@"%@/app_api/shop/mystuffnew.html?q=%@",NewBaseUrl,qValue]];
        downloadflag=1;
        //    tabView.frame=CGRectZero;
        [mhd downloadFromUrl:murl];
        [self startAnimat];
    }
    
}
-(void)downloadFailed:(HttpDownload *)hd{

    
}

-(void)downloadComplete:(HttpDownload*)hd{
    [self stopAnimat];
    [myGoodsDataArray removeAllObjects];
    downloadflag=0;
    NSError *error = nil;
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:hd.mData options:NSJSONReadingAllowFragments error:&error];
    if (error!=nil) {
        NSLog(@"json解析失败15");
        noDataBg.hidden=NO;
    }else{
        noDataBg.hidden=NO;
        if (![[NSString stringWithFormat:@"%@",[dic objectForKey:@"Contents"]]isEqualToString:@""]) {
            
            [myGoodsDataArray addObjectsFromArray:[dic objectForKey:@"Contents"]];
            if (myGoodsDataArray.count) {
                myTableView.frame=CGRectMake(0,95+SIZEABOUTIOSVERSION,320,SCREENHEIGHT-115);
                noDataBg.hidden=YES;
            }
        }
        NSLog(@"刷新%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"ListType"]);
        
        [myTableView reloadData];
    }
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (myGoodsDataArray.count) {
        NSDictionary *dic=[myGoodsDataArray objectAtIndex:indexPath.row];
        GoodsItem *item=[[GoodsItem alloc]init];
        item.goodsIntroduce=[dic objectForKey:@"content"];
        item.goodsImagesArray=[dic objectForKey:@"attachment"];
        item.goodsID=[dic objectForKey:@"tid"];
        item.goodsName=[dic objectForKey:@"name"];
        item.goodsTotalNumber=[dic objectForKey:@"number"];
        item.everyDayNumber=[dic objectForKey:@"number_everyday"];
        item.everyOneNumber=[dic objectForKey:@"number_everyone"];
        item.oldPrice=[dic objectForKey:@"ext_price"];
        item.realPrice=[dic objectForKey:@"real_price"];
        item.startTime=[dic objectForKey:@"starttimefrom"];
        item.endTime=[dic objectForKey:@"starttimeto"];
        item.getEndTime=[dic objectForKey:@"starttimeto_f"];
        item.getStartTime=[dic objectForKey:@"starttimefrom_f"];
        item.goodsStatus=[dic objectForKey:@"goodstatus"];
        item.goodsAbout=[dic objectForKey:@"spec"];
        item.hotOrSale=[dic objectForKey:@"extra"];
        item.sid=[dic objectForKey:@"sid"];
        item.usecontent=[dic objectForKey:@"usecontent"];
        
        GoodsDetailViewController *modelViewCtr=[[GoodsDetailViewController alloc]init];
        modelViewCtr.goodsItem=item;
        modelViewCtr.isGet=1;
        modelViewCtr.MyObj=self;
        NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
        modelViewCtr.Type=[NSString stringWithFormat:@"%@",[def objectForKey:@"ListType"]];
        [self.navigationController pushViewController:modelViewCtr animated:YES];

    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyGoodsCell * myCell=[tableView dequeueReusableCellWithIdentifier:@"myCell"];
    if (myCell==nil) {
        myCell=[[MyGoodsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myCell"];
    }else{
        myCell.bigImage.image=nil;
        myCell.title.text=@"";
        myCell.label2.text=@"";
        myCell.label1.text=@"";
    }
    if (myGoodsDataArray.count) {
        NSDictionary *dic=[myGoodsDataArray objectAtIndex:indexPath.row];
        myCell.title.text=[dic objectForKey:@"name"];
        NSNumber *num=[dic objectForKey:@"SerialID"];
        myCell.label1.text=[NSString stringWithFormat:@"%@",num];
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString* startdate=[dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[dic objectForKey:@"starttimeto_f"] doubleValue]]];
        myCell.label2.text=startdate;
        NSString *stringUrl=[[dic objectForKey:@"attachment"]objectAtIndex:0];
        NSURL *bigImageUrl;
        if ([stringUrl hasPrefix:@"http"]) {
            bigImageUrl=[NSURL URLWithString:stringUrl];
        }else{
            bigImageUrl=[NSURL URLWithString:[NSString stringWithFormat:@"http://m.16wifi.com/recommend/shoplist/%@",stringUrl]];
        }

        [myCell.bigImage setImageWithURL:bigImageUrl placeholderImage:[UIImage imageNamed:@"down_1"]];
    }
        return myCell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.f;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (![[NSString stringWithFormat:@"%@",myGoodsDataArray]isEqualToString:@"<null>"]) {
        
       return myGoodsDataArray.count;

    }
    return 0;
}
-(void)selectButtonIndex:(int)index{
 
    if (downloadflag) {
        [mhd cancel];
    }
    [self loadMyListViewWithTag:index];
}

-(void)goBackToSuperPage{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
