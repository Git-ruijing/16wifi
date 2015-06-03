//
//  ActivityViewController.m
//  e-RoadWiFi
//
//  Created by QC on 14-8-1.
//  Copyright (c) 2014年 G.MING. All rights reserved.
//

#import "ActivityViewController.h"
#import "WebSubPagViewController.h"
#import "LoginViewController.h"
#import "UserShopViewController.h"
#import "RootUrl.h"
#import "MobClick.h"
#import "GetCMCCIpAdress.h"
#import "ZhuanPanViewController.h"
#define DEVICE_IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568)
#define SCREENHEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SIZEABOUTIOSVERSION ([[[UIDevice currentDevice] systemVersion] floatValue]<7.0?0:20)
#define IOSVERSIONSMALL ([[[UIDevice currentDevice] systemVersion] floatValue]<7.0?20:0)
@interface ActivityViewController ()
@end
@implementation ActivityViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
-(void)buildLoadingAnimat{
    aniBg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 77, 77)];
    aniBg.image=[UIImage imageNamed:@"jiazaibg"];
    NSArray *imageArray=[NSArray arrayWithObjects:[UIImage imageNamed:@"tu1"],[UIImage imageNamed:@"tu2"],[UIImage imageNamed:@"tu3"],[UIImage imageNamed:@"tu4"], nil];
    loadingAni=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 77, 77)];
    loadingAni.image=[UIImage imageNamed:@"tu1"];
    loadingAni.animationImages=imageArray;
    
    loadingAni.animationDuration=[loadingAni.animationImages count] * 1/5.0;
    loadingAni.animationRepeatCount=100000;
    flag=0;
    [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(stopAnimat) userInfo:nil repeats:NO];
    [loadingAni startAnimating];
    loadingAni.center=aniBg.center;
    [aniBg addSubview:loadingAni];
    aniBg.center=CGPointMake(self.view.center.x,self.view.center.y-40);
    [self.view addSubview:aniBg];
}
-(void)startAnimat{
    [aniBg setHidden:NO];
    loadingAni.animationRepeatCount = 100000;
    flag=1;
    [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(stopAnimat) userInfo:nil repeats:NO];
    [loadingAni startAnimating];
}
-(void)stopAnimat{
    [aniBg setHidden:YES];
    flag=0;
    [loadingAni stopAnimating];
}
-(void)viewWillDisappear:(BOOL)animated{
    [MobClick endLogPageView:@"activity"];
}
-(void)viewWillAppear:(BOOL)animated{
    if ([RootUrl getUMLogClickFlag]) {
        NSDictionary *dict2 = @{@"type" : @"inactivity"};
        [MobClick event:@"loginNet_isRun" attributes:dict2];
        [RootUrl setUMLogClickFlag:0];
    }
    NSDictionary *dict = @{@"type" : @"活动"};
    [MobClick event:@"page_select" attributes:dict];
    [MobClick beginLogPageView:@"activity"];
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
   
    if ((![RootUrl getIsNetOn]) &&(![[GetCMCCIpAdress getSSID]isEqualToString:@"16wifi"])) {
        if (failImageFlag==0) {
            [self.view addSubview:failImageView];
            failImageFlag=1;
            [self stopAnimat];
        }
        NeedLoadView=YES;
    }else{
        if (NeedLoadView) {
            if (failImageFlag) {
                [failImageView removeFromSuperview];
                failImageFlag=0;
            }
            if (myWebView.isHidden) {
                [myWebView setHidden:NO];
            }
            NSURL *url=[NSURL URLWithString:@"http://clienthtml.16wifi.com/faxian/index.html"];
            NSURLRequest *request=[NSURLRequest requestWithURL:url];
            NSLog(@"%@",url);
            [myWebView loadRequest:request];
        }
        
    }
    
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationController.navigationBar.hidden=YES;
    NeedLoadView=YES;
    failImageFlag=0;
    
    
    failImageView=[[UIView alloc]initWithFrame:CGRectMake(0,65,SCREENWIDTH,SCREENHEIGHT-110)];
    failImageView.backgroundColor=[UIColor whiteColor];
    UIImageView *imge=[[UIImageView alloc]initWithFrame:CGRectMake((SCREENWIDTH-167)/2,(SCREENHEIGHT-200)/2,167,90)];
    imge.image=[UIImage imageNamed:@"biaoqing.png"];
    [failImageView addSubview:imge];
    
    myWebView=[[UIWebView alloc]init];
   
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7) {
        myWebView.frame=CGRectMake(0,44, 320,SCREENHEIGHT-44);
    }else{
        myWebView.frame=CGRectMake(0,44, 320,SCREENHEIGHT-112);
    }
    myWebView.delegate=self;
    myWebView.scrollView.bounces=NO;
    myWebView.scrollView.scrollEnabled=NO;
    myWebView.userInteractionEnabled=NO;
    myWebView.backgroundColor=[UIColor whiteColor];
    NSURL *url=[NSURL URLWithString:@"http://clienthtml.16wifi.com/faxian/index.html"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0f];
    [myWebView loadRequest:request];
    [self.view addSubview:myWebView];
    
    [self creatNav];
    [self buildLoadingAnimat];
}

-(void)creatNav{
    UIImageView *navView=[[UIImageView alloc]init];
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7) {
        navView.frame=CGRectMake(0, 0, 320, 64);
    }else{
        navView.frame=CGRectMake(0, -20, 320, 64);
    }
    navView.image=[UIImage imageNamed:@"gm_nav"];
    navView.userInteractionEnabled=YES;
    [self.view addSubview:navView];
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(120, 20, 80, 44)];
    titleLabel.text=@"发现";
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.font=[UIFont systemFontOfSize:20];
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.backgroundColor=[UIColor clearColor];
    [navView addSubview:titleLabel];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    if (failImageFlag==0) {
        [self.view addSubview: failImageView];
        failImageFlag=1;
    }
    [self stopAnimat];
    [myWebView setHidden:YES];
    NeedLoadView=YES;
    
}
-(void)loginSuccessWithTag:(int)tag{

}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
 
    [self startAnimat];
    
    NSString * strUrl=[NSString stringWithFormat:@"%@",request.URL];
    NSLog(@"NNN:%@",strUrl);
   
    if([strUrl hasPrefix:@"http://clienthtml.16wifi.com/faxian/index.html"]) {
         NSLog(@"NNN3");
        return YES;
    }else if(![RootUrl getIsNetOn]){
         NSLog(@"NNN4");
       
        return NO;
    }else{
        ZhuanPanViewController *wvc=[[ZhuanPanViewController alloc]init];
        wvc.myRequest=request;
        wvc.isPush=0;
        [self presentViewController:wvc animated:NO completion:nil];
        return NO;
    
    }
    
    
    
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    if (failImageFlag) {
        [failImageView removeFromSuperview];
        failImageFlag=0;
    }
   [self stopAnimat];
    NeedLoadView=NO;
    myWebView.scrollView.scrollEnabled=YES;
    myWebView.userInteractionEnabled=YES;
}
-(void)webViewDidStartLoad:(UIWebView *)webView{
    [self startAnimat];
 
    [myWebView setHidden:NO];
    if (failImageFlag) {
        [failImageView removeFromSuperview];
        failImageFlag=0;
    }

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
