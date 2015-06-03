//
//  UserShopViewController.m
//  e路WiFi
//
//  Created by JAY on 3/17/14.
//  Copyright (c) 2014 HE ZHENJIE. All rights reserved.
//

#import "UserShopViewController.h"
#import "UIImageView+WebCache.h"
#import "WebSubPagViewController.h"
#import "RootUrl.h"
#import "ChannelsViewController.h"
#define ROOTURLFORBANNER @"http://111.13.47.155/usersystem/"
#define SECRETKEY @"ilovewififorfree"
#import "GetCMCCIpAdress.h"
@interface UserShopViewController ()

@end

@implementation UserShopViewController
@synthesize collectionView;
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
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    pageCtr.currentPage = scrollView.contentOffset.x/320;
    
    
}
-(void)hiddenMyOwnView{
    showMyOwnFlag=0;
    myOwnBg.frame=CGRectMake(147,SIZEABOUTIOSVERSION+44-94,176,94);
    [myOwnBg setHidden:YES];
    
}

-(void)showMyCoin{

    HttpDownload *getMyCoinHd=[[HttpDownload alloc]init];
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"hhmmss"];
    
    NSString *qSting=[NSString stringWithFormat:@"mod=getmycreditnew&uid=%@",[userDefaults objectForKey:@"userID"]];
    NSData *secretData=[qSting dataUsingEncoding:NSUTF8StringEncoding];
    NSData *qValueData=[secretData AES256EncryptWithKey:SECRETKEY];
    NSString *qValue=[qValueData newStringInBase64FromData];
    
    NSURL *downLoadUrl;
    downLoadUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@/app_api/credit/getUserCredit.html?q=%@&ntime=%@",NewBaseUrl,qValue,[dateformatter stringFromDate:[NSDate date]]]];
    getMyCoinHd.DFailed=@selector(downloadFailed:);
    getMyCoinHd.DComplete=@selector(downloadComplete:);
    getMyCoinHd.delegate=self;
    getMyCoinHd.tag=230;
    if([RootUrl getIsNetOn]||[[GetCMCCIpAdress getSSID]isEqualToString:@"16wifi"]){
        [getMyCoinHd downloadFromUrl:downLoadUrl];
    }
}
-(void)loginSuccessWithTag:(int)tag{
        [moreButton setHidden:NO];
        [loginButton setHidden:YES];
        [mark setHidden:YES];
        
        loginOrCoin.frame=CGRectMake(40, 183+SIZEABOUTIOSVERSION-125, 60, 25);
        loginOrCoinLable.frame=CGRectMake(0, 0 ,60, 25);
        loginOrCoinLable.text=@"0 彩豆";
        [getMoreCoinLabel setHidden:NO];
        [arrowImage setHidden:NO];
        [getMoreCoinButton setHidden:NO];
        //获取个人账户信息
    [self showMyCoin];
    
}
-(void)playPage{
    i++;
    [myScrollView scrollRectToVisible:CGRectMake(i*320, 0, 320, 125) animated:YES];
    pageCtr.currentPage=i;
    if (i==[scrollImageDataArray count]) {
        i=-1;
    }
}
-(void)pressButtonTag:(int)tag
{
    
    NSDictionary *banneritem=[scrollImageDataArray objectAtIndex:tag];
    int type=[[banneritem objectForKey:@"extra"]intValue];
    switch (type) {
        case 1:
        {
            //商品促销
            break;
        }
        case 2:
        {
            NSRange ranOfApk=[[banneritem objectForKey:@"gotourl"] rangeOfString:@"apk"];
            if (ranOfApk.location!=NSNotFound) {
                return;
            }
            NSRange ran=[[banneritem objectForKey:@"gotourl"] rangeOfString:@"tel:"];
            if (ran.location!=NSNotFound) {
                NSString *str=[[[banneritem objectForKey:@"gotourl"] componentsSeparatedByString:@"tel:"]lastObject];
                str=[[str componentsSeparatedByString:@"/"]objectAtIndex:0];
                UIAlertView *myAlert = [[UIAlertView alloc]initWithTitle:str message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拨打",nil];
                [myAlert show];
                return;
                
            }
            WebSubPagViewController *bander=[[WebSubPagViewController alloc]init];
            bander.myRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:[banneritem objectForKey:@"gotourl"]]];
//            bander.titleLabel.text=@"e路商城";
            
            [self presentViewController:bander animated:YES completion:^{}];
            break;
        }
        case 3:
        {
            return;
            break;
        }
        default:
            break;
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
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
//    [self hideTabBar];
    scrollImageDataArray=[[NSMutableArray alloc]init];
    goodsItemArray=[[NSMutableArray alloc]init];
    UIView* headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 44+SIZEABOUTIOSVERSION)];
    UIImageView *headerBackground=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320,44+SIZEABOUTIOSVERSION)];
    [headerView addSubview:headerBackground];
    headerBackground.image=[[UIImage imageNamed:@"gm_nav"]stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(110, 10+SIZEABOUTIOSVERSION, 100, 30)];
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.font=[UIFont systemFontOfSize:20];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [headerView addSubview:titleLabel];
    titleLabel.text=@"兑换中心";
    MyButton * goBack=[MyButton buttonWithType:UIButtonTypeCustom];
    goBack.frame=CGRectMake(0, SIZEABOUTIOSVERSION,50, 44);
    [goBack setNormalImage:[UIImage imageNamed:@"newBack"]];
    [goBack setSelectedImage:[UIImage imageNamed:@"newBack_d"]];
    [headerView addSubview:goBack];
    [goBack addTarget:self action:@selector(gohome)];

    
    moreButton=[MyButton buttonWithType:UIButtonTypeCustom];
    moreButton.frame=CGRectMake(270,SIZEABOUTIOSVERSION, 50, 44);
    [moreButton setNormalImage:[UIImage imageNamed:@"shopemore.png"]];
    [moreButton addTarget:self action:@selector(showMyOwn)];
    [moreButton setHidden:YES];
    [headerView addSubview:moreButton];
    
    NSUserDefaults * userDefault=[NSUserDefaults standardUserDefaults];
    int isLogin=[[userDefault objectForKey:@"isLogin"]intValue];
    
    if (isLogin>1) {
        [moreButton setHidden:NO];
    }
    
    UIImageView * moneyImage=[[UIImageView alloc]initWithFrame:CGRectMake(15, 180+SIZEABOUTIOSVERSION-120,21 , 21)];
    moneyImage.image=[UIImage imageNamed:@"goldIcon.png"];
    [self.view addSubview:moneyImage];
    
    loginOrCoin=[[UIImageView alloc]initWithFrame:CGRectMake(40, 183+SIZEABOUTIOSVERSION-125, 100, 25)];
    loginOrCoinLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 25)];
    loginOrCoinLable.backgroundColor=[UIColor clearColor];
    loginOrCoinLable.textColor=[UIColor  colorWithRed:244/255.0f green:134/255.0f blue:0/255.0f alpha:1];
    loginOrCoinLable.textAlignment=NSTextAlignmentLeft;
    loginOrCoinLable.font=[UIFont systemFontOfSize:17];
    loginOrCoinLable.text=@"登录抢大礼";
    [loginOrCoin addSubview:loginOrCoinLable];
    [self.view addSubview:loginOrCoin];
    
    loginButton=[MyButton buttonWithType:UIButtonTypeCustom];
    loginButton.frame=CGRectMake(15,183+SIZEABOUTIOSVERSION-125 ,130,25);
    [loginButton addTarget:self action:@selector(goLogin)];
    [loginButton setHidden:YES];
    [self.view addSubview:loginButton];
    
    
    mark=[[UILabel alloc]initWithFrame:CGRectMake(145,60+SIZEABOUTIOSVERSION,150, 20)];
    mark.backgroundColor=[UIColor clearColor];
    mark.textAlignment=NSTextAlignmentCenter;
    mark.font=[UIFont systemFontOfSize:13];
    mark.textColor=[UIColor colorWithRed:128/255 green:128/255 blue:128/255 alpha:1.0];
 
    mark.text=@"新手立即获得800彩豆";
    [mark setHidden:YES];
    [self.view addSubview:mark];
    getMoreCoinLabel=[[UILabel alloc]initWithFrame:CGRectMake(210,60+SIZEABOUTIOSVERSION,150, 20)];
    getMoreCoinLabel.backgroundColor=[UIColor clearColor];
    getMoreCoinLabel.textAlignment=NSTextAlignmentLeft;
    getMoreCoinLabel.font=[UIFont systemFontOfSize:15];
    getMoreCoinLabel.textColor=[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0];
    
    getMoreCoinLabel.text=@"获取更多彩豆";
    [getMoreCoinLabel setHidden:YES];
     [self.view addSubview:getMoreCoinLabel];
    arrowImage=[[UIImageView alloc]initWithFrame:CGRectMake(296, 60+SIZEABOUTIOSVERSION, 20, 20)];
    arrowImage.backgroundColor=[UIColor clearColor];
    arrowImage.image=[UIImage imageNamed:@"goodarrows"];
    [arrowImage setHidden:YES];
    [self.view addSubview:arrowImage];
    
    getMoreCoinButton=[MyButton buttonWithType:UIButtonTypeCustom];
    getMoreCoinButton.frame=CGRectMake(210,55+SIZEABOUTIOSVERSION,160, 25);
    [getMoreCoinButton addTarget:self action:@selector(getMoreCoin)];
    [getMoreCoinButton setHidden:YES];
    [self.view addSubview:getMoreCoinButton];

    self.collectionView = [[PullPsCollectionView alloc] initWithFrame:CGRectMake(0, 220+SIZEABOUTIOSVERSION-125,320,SCREENHEIGHT-220-SIZEABOUTIOSVERSION+125)];
    //collectionView.bounces=NO;
    collectionView.collectionViewDelegate = self;
    collectionView.collectionViewDataSource = self;
    collectionView.backgroundColor = [UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1.0];
    collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    collectionView.numColsPortrait = 2;
    
    [self.view addSubview:collectionView];
    //内容
    
    failImageFlag=0;
    failImageView=[[UIView alloc]initWithFrame:CGRectMake(0,84+SIZEABOUTIOSVERSION,SCREENWIDTH,SCREENHEIGHT-84-SIZEABOUTIOSVERSION)];
    failImageView.backgroundColor=[UIColor whiteColor];
    UIImageView *imge=[[UIImageView alloc]initWithFrame:CGRectMake((SCREENWIDTH-167)/2,(SCREENHEIGHT-84-SIZEABOUTIOSVERSION-200)/2,167,90)];
    imge.image=[UIImage imageNamed:@"biaoqing.png"];
    [failImageView addSubview:imge];
    [self.view addSubview:failImageView];
    failImageView.hidden=YES;
    [self buildLoadingAnimat];
    

    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"hhmmss"];
    
    banderHd=[[HttpDownload alloc]init];
    NSString *qSting=@"mod=banners";
    NSData *secretData=[qSting dataUsingEncoding:NSUTF8StringEncoding];
    NSData *qValueData=[secretData AES256EncryptWithKey:SECRETKEY];
    NSString *qValue=[qValueData newStringInBase64FromData];
    NSURL *bannerUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@/usersystem/api.php?q=%@&ntime=%@",FormalBaseUrl,qValue,[dateformatter stringFromDate:[NSDate date]]]];
    banderHd.DFailed=@selector(downloadFailed:);
    banderHd.DComplete=@selector(downloadComplete:);
    banderHd.delegate=self;
    banderHd.tag=210;
    if([RootUrl getIsNetOn]||[[GetCMCCIpAdress getSSID]isEqualToString:@"16wifi"]){
//        [banderHd downloadFromUrl:bannerUrl];
           [self startAnimat];
    }
    
    banderHdFlag=1;
    goodsDataHd=[[HttpDownload alloc]init];
    flag=1;
    
    NSString *qSting1=@"mod=getlistnew";
    NSData *secretData1=[qSting1 dataUsingEncoding:NSUTF8StringEncoding];
    NSData *qValueData1=[secretData1 AES256EncryptWithKey:SECRETKEY];
    NSString *qValue1=[qValueData1 newStringInBase64FromData];
    //加入接入16wifi网络时CGI调用
    NSURL *listUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@/app_api/shop/htmlEarnCredit.html?q=%@&ntime=%@",NewBaseUrl,qValue1,[dateformatter stringFromDate:[NSDate date]]]];
    goodsDataHd.DFailed=@selector(downloadFailed:);
    goodsDataHd.DComplete=@selector(downloadComplete:);
    goodsDataHd.delegate=self;
    goodsDataHd.tag=220;
    if([RootUrl getIsNetOn]||[[GetCMCCIpAdress getSSID]isEqualToString:@"16wifi"]){
        [goodsDataHd downloadFromUrl:listUrl];
           [self startAnimat];
    }
    
    goodsDataHdFlag=1;
    
    myOwnBg=[[UIView alloc]initWithFrame:CGRectMake(147,SIZEABOUTIOSVERSION+44-94,176,94)];
    myOwnBg.backgroundColor=[UIColor clearColor];
    [self.view addSubview:myOwnBg];
    
    showMyOwnFlag=0;
    MyButton *myObject=[MyButton buttonWithType:UIButtonTypeCustom];
    myObject.frame=CGRectMake(0, 0,176,47);
    [myObject setNormalImage:[UIImage imageNamed:@"baobei.png"]];
    [myOwnBg addSubview:myObject];
    [myObject addTarget:self action:@selector(goMyObject)];
    
    MyButton *myCoinBill=[MyButton buttonWithType:UIButtonTypeCustom];
    myCoinBill.frame=CGRectMake(0, 46,176,47);
    [myCoinBill setNormalImage:[UIImage imageNamed:@"jinbi.png"]];
    [myOwnBg addSubview:myCoinBill];
    [myCoinBill addTarget:self action:@selector(goMyCoinBill)];
    [myOwnBg setHidden:YES];
    
    [self.view addSubview:headerView];
    
	// Do any additional setup after loading the view.
}

-(void)goMyCoinBill{
    [self hiddenMyOwnView];
    MyCoinBillViewController *modelViewCtr=[[MyCoinBillViewController alloc]init];
    modelViewCtr.myCoinNumber=coinNumber;
    modelViewCtr.Type=@"1";
    [self.navigationController pushViewController:modelViewCtr animated:YES];
}
-(void)goMyObject{
    [self hiddenMyOwnView];
    MyOwnObjectViewController *modelViewCtr=[[MyOwnObjectViewController alloc]init];
    [self.navigationController pushViewController:modelViewCtr animated:YES];
}

-(void)getMoreCoin{

    [UIView animateWithDuration:0 animations:^{
        [self.navigationController popToRootViewControllerAnimated:NO];
    } completion:^(BOOL finished){
        AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
        [app setTabBarSelected:1];
    }];
}

-(void)showMyOwn{
    if (showMyOwnFlag) {
        showMyOwnFlag=0;
        
        [UIView animateWithDuration:0.5 animations:^{
            myOwnBg.frame=CGRectMake(147,SIZEABOUTIOSVERSION+44-94,176,94);
        } completion:^(BOOL finished){
            [myOwnBg setHidden:YES];
        }];
    }else{
        showMyOwnFlag=1;
        [myOwnBg setHidden:NO];
        [UIView animateWithDuration:0.5 animations:^{
            myOwnBg.frame=CGRectMake(147,SIZEABOUTIOSVERSION+44,176,94);
        }];
    }
    
}

-(void)goLogin{
    LoginViewController *loginCtr=[[LoginViewController alloc]init];
    loginCtr.delegate=self;
    [self presentViewController:loginCtr animated:YES completion:^{}];
}
-(void)collectionView:(PSCollectionView *)collectionView didSelectView:(PSCollectionViewCell *)view atIndex:(NSInteger)index{
    GoodsItem * gooditemforcell = [goodsItemArray objectAtIndex:index];
    GoodsDetailViewController *modelViewCtr=[[GoodsDetailViewController alloc]init];
    [modelViewCtr setGoodsItem:gooditemforcell];
    modelViewCtr.isGet=0;
    modelViewCtr.GoodsStatus=[NSString stringWithFormat:@"%@",gooditemforcell.goodsStatus];
    
    [self.navigationController pushViewController:modelViewCtr animated:YES];
//    [self.navigationController presentViewController:modelViewCtr animated:YES completion:nil];
}

-(PSCollectionViewCell *)collectionView:(PSCollectionView *)collectionView viewAtIndex:(NSInteger)index{
    CellView *cell = (CellView*)[self.collectionView dequeueReusableView];
    UIImageView *BigImage;
    UIImageView *SmallRoundImage;
    UILabel *PriceLabel;
    UILabel *zeOrRe;
    UILabel *duihuan;
    
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CellView" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        [cell.picView setHidden:YES];
        [cell.imageTitle setHidden:YES];
        BigImage=[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 135, 66)];
        BigImage.tag=10086;
        BigImage.backgroundColor=[UIColor clearColor];
        [cell addSubview:BigImage];
        SmallRoundImage=[[UIImageView alloc]initWithFrame:CGRectMake(5,5,25,25)];
        SmallRoundImage.tag=10087;
        SmallRoundImage.image=[UIImage imageNamed:@"mark.png"];
        [cell addSubview:SmallRoundImage];
        zeOrRe=[[UILabel alloc]initWithFrame:CGRectMake(5,5,25,25)];
        zeOrRe.tag=10088;
  
        zeOrRe.textAlignment=NSTextAlignmentCenter;
        zeOrRe.textColor=[UIColor whiteColor];
        zeOrRe.backgroundColor=[UIColor clearColor];
        [cell addSubview:zeOrRe];
        
        PriceLabel=[[UILabel alloc]initWithFrame:CGRectMake(5,88,67,20)];
        PriceLabel.tag=10091;
        PriceLabel.font=[UIFont systemFontOfSize:15];

        PriceLabel.textColor=[UIColor colorWithRed:153/255.0f green:153/255.0f  blue:153/255.0f  alpha:1];
        PriceLabel.textAlignment=NSTextAlignmentLeft;
        PriceLabel.backgroundColor=[UIColor clearColor];
        [cell addSubview:PriceLabel];
        
        
        UIView *lineView1=[[UIView alloc]initWithFrame:CGRectMake(5,80,135, 0.5)];
        lineView1.backgroundColor=[UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:0.7];
        [cell addSubview:lineView1];
        
        duihuan=[[UILabel alloc]initWithFrame:CGRectMake(90, 88, 50, 20)];
        duihuan.text=@"兑换";
        duihuan.font=[UIFont systemFontOfSize:15];
        duihuan.textColor=[UIColor whiteColor];
        duihuan.textAlignment=NSTextAlignmentCenter;
        duihuan.backgroundColor=[UIColor colorWithRed:241/255.0f green:66/255.0f  blue:66/255.0f  alpha:1];
        [cell addSubview:duihuan];
    
    
    GoodsItem * gooditemforcell = [goodsItemArray objectAtIndex:index];
    //图片地址修改
    NSString *str;
    if ([[gooditemforcell.goodsImagesArray objectAtIndex:0] hasPrefix:@"http"]) {
    
        str=[NSString stringWithFormat:@"%@",[gooditemforcell.goodsImagesArray objectAtIndex:0]];
    }else{
        str=[NSString stringWithFormat:@"http://m.16wifi.com/recommend/shoplist/%@",[gooditemforcell.goodsImagesArray objectAtIndex:0]];
        
    }
    NSURL *bigImageUrl=[NSURL URLWithString:str];
   [BigImage setImageWithURL:bigImageUrl placeholderImage:[UIImage imageNamed:@"down_1"]];
    PriceLabel.text=[NSString stringWithFormat:@"%@彩豆",gooditemforcell.oldPrice];


    int zere=[gooditemforcell.hotOrSale intValue];
    int status=[gooditemforcell.goodsStatus intValue];
    if (status==1) {
        duihuan.text=@"抢光了";
        duihuan.backgroundColor=[UIColor grayColor];
    }else if (status==2){
        duihuan.text=@"已结束";
        duihuan.backgroundColor=[UIColor grayColor];
    }
    switch (zere) {
        case 0:
        {
            [zeOrRe setHidden:YES];
            [SmallRoundImage setHidden:YES];

            break;
        }
            
        case 1:
        {
            zeOrRe.text=@"热";
            [zeOrRe setHidden:NO];
            [SmallRoundImage setHidden:NO];
            
           
            break;
        }
        case 2:
        {
            zeOrRe.text=@"折";
            [zeOrRe setHidden:NO];
            [SmallRoundImage setHidden:NO];
         
           
            break;
        }
        default:
        {
            [zeOrRe setHidden:YES];
            [SmallRoundImage setHidden:YES];
            
            break;
        }
            break;
    }
    
    return cell;
}
-(NSInteger)numberOfViewsInCollectionView:(PSCollectionView *)collectionView{
    return [goodsItemArray count];
}
-(CGFloat)heightForViewAtIndex:(NSInteger)index{
    return 116;
}
-(void)gohome{
    self.tabBarController.tabBar.hidden=NO;
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController popViewControllerAnimated:NO];

    
}
-(void)downloadComplete:(HttpDownload *)hd{
   
 
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    
    if (hd.tag==230) {
        NSError *error = nil;
     
           [self stopAnimat];
        coinNumber=[[NSJSONSerialization JSONObjectWithData:hd.mData options:NSJSONReadingAllowFragments error:&error]objectForKey:@"num"];
        NSLog(@"coinNumber:%@",coinNumber);
        if (error!=nil) {
            NSLog(@"json解析失败25");
        }else{
        
            if (coinNumber) {
                
                [defaults setObject:coinNumber forKey:@"coinNumber"];
                [defaults synchronize];
                
                loginOrCoinLable.text=[NSString stringWithFormat:@"%@彩豆",coinNumber];
                
            }else{
                loginOrCoinLable.text=[NSString  stringWithFormat:@"%@彩豆",[defaults objectForKey:@"coinNumber"]];
            }
            CGSize maxSize=CGSizeMake(250, 25);
            //        CGSize realSize=[loginOrCoinLable.text sizeWithFont:loginOrCoinLable.font constrainedToSize:maxSize lineBreakMode:NSLineBreakByCharWrapping];
            CGSize realSize=[loginOrCoinLable.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:loginOrCoinLable.font} context:nil].size;
            loginOrCoin.frame=CGRectMake(40, 183+SIZEABOUTIOSVERSION-125, realSize.width+15, 25);
            loginOrCoinLable.frame=CGRectMake(0, 0 ,realSize.width+15, 25);

        }
    }
    if (hd.tag==210) {
        banderHdFlag=0;
        NSError *error = nil;
        if(error!=nil){
         NSLog(@"json解析失败210");
        }else{
            scrollImageDataArray=[[NSJSONSerialization JSONObjectWithData:hd.mData options:NSJSONReadingAllowFragments error:&error]objectForKey:@"Contents"];
            int p;
//            myScrollView=[[JAYBannersScroll alloc]initWithFrame:CGRectMake(0,0, 320, 125) andWithDelegate:self andWithPage:(int)scrollImageDataArray.count];
//            [bannerScrollBg addSubview:myScrollView];
            myScrollView.mdelegate=self;
            if ([scrollImageDataArray count]>1) {
                pageCtr=[[UIPageControl alloc]initWithFrame:CGRectMake(260, 99+45+SIZEABOUTIOSVERSION, 50, 24)];
                pageCtr.numberOfPages=[scrollImageDataArray count];
                pageCtr.currentPage=0;
                [pageCtr setPageIndicatorTintColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
                pageCtr.currentPageIndicatorTintColor=[UIColor colorWithRed:0 green:172/255.f blue:238/255.f alpha:1.f];
                [self.view addSubview:pageCtr];
                [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(playPage) userInfo:nil repeats:YES];
            }
            for (p=0; p<[scrollImageDataArray count]; p++) {
                NSString *murl;
                murl=[[scrollImageDataArray objectAtIndex:p]objectForKey:@"attachment"];
                UIImageView *sImageView=(UIImageView *)[myScrollView.scorllImageArray objectAtIndex:p];
                if ([murl hasPrefix:@"http"]) {
                        [sImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",murl]] placeholderImage:[UIImage imageNamed:@"guanggaobg"]];
                }else{
                
                        [sImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ROOTURLFORBANNER,murl]] placeholderImage:[UIImage imageNamed:@"guanggaobg"]];
                }
            
            }
        }
}
    if (hd.tag==220) {
        goodsDataHdFlag=0;
        NSError *error = nil;
     
        NSArray *myGoodsItemArray=[[NSJSONSerialization JSONObjectWithData:hd.mData options:NSJSONReadingAllowFragments error:&error]objectForKey:@"Contents"];
        if (error!=nil) {
            NSLog(@"json解析失败25");
        }
     
        for (NSDictionary *dic in myGoodsItemArray) {
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
            [goodsItemArray addObject:item];
        }
        [self.collectionView reloadData];
        failImageView.hidden=YES;
            [self stopAnimat];
    }
}
-(void)downloadFailed:(HttpDownload *)hd{
    [self stopAnimat];
    if (hd.tag==210) {
        banderHdFlag=0;
    }
    if (hd.tag==220) {
        goodsDataHdFlag=0;
        if (failImageFlag==0) {
            failImageFlag=1;
            failImageView.hidden=NO;
        }
        
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    
    [MobClick endLogPageView:@"userShop"];
    if (banderHdFlag) {
        [banderHd cancel];
    }
    if (goodsDataHdFlag) {
        [goodsDataHd cancel];
    }
}
-(void)viewWillAppear:(BOOL)animated{


    if (failImageFlag) {
        failImageFlag=0;
        failImageView.hidden=YES;
    }
    
    [MobClick event:@"shop_click" ];
    [MobClick beginLogPageView:@"userShop"];
    self.tabBarController.tabBar.hidden=YES;
    [self.navigationController setNavigationBarHidden:YES];
    [self hideTabBar];
    
    NSUserDefaults * userDefault=[NSUserDefaults standardUserDefaults];
    int isLogin=[[userDefault objectForKey:@"isLogin"]intValue];
    
    if (isLogin<2) {
        [loginButton setHidden:NO];
        [mark setHidden:NO];
        
    }else{
        [loginButton setHidden:YES];
        [mark setHidden:YES];
        
        loginOrCoin.frame=CGRectMake(40, 183+SIZEABOUTIOSVERSION-125, 60, 25);
        loginOrCoinLable.frame=CGRectMake(0, 0 ,60, 25);
        if ([userDefault objectForKey:@"coinNumber"]) {
            loginOrCoinLable.text=[NSString stringWithFormat:@"%@彩豆",[userDefault objectForKey:@"coinNumber"]];
            
        }else{
            loginOrCoinLable.text=@"0 彩豆";
        }
        CGSize maxSize=CGSizeMake(250, 25);
//        CGSize realSize=[loginOrCoinLable.text sizeWithFont:loginOrCoinLable.font constrainedToSize:maxSize lineBreakMode:NSLineBreakByCharWrapping];
        CGSize realSize=[loginOrCoinLable.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:loginOrCoinLable.font} context:nil].size;
        loginOrCoin.frame=CGRectMake(40, 183+SIZEABOUTIOSVERSION-125, realSize.width+15, 25);
        loginOrCoinLable.frame=CGRectMake(0, 0 ,realSize.width+15, 25);
        
        [getMoreCoinLabel setHidden:NO];
        [arrowImage setHidden:NO];
        [getMoreCoinButton setHidden:NO];
        //获取个人账户信息
        [self showMyCoin];
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
    flag++;
    [NSTimer scheduledTimerWithTimeInterval:50 target:self selector:@selector(stopAnimat) userInfo:nil repeats:NO];
    [loadingAni startAnimating];
}
-(void)stopAnimat{
    [aniBg setHidden:YES];
    flag--;
    [loadingAni stopAnimating];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
