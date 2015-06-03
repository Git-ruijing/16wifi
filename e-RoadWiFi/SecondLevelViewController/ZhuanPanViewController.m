//
//  ZhuanPanViewController.m
//  e-RoadWiFi
//
//  Created by Jay on 15-1-30.
//  Copyright (c) 2015年 G.MING. All rights reserved.
//

#import "ZhuanPanViewController.h"
#import "LoginViewController.h"
#import "MyButton.h"
#import "MobClick.h"
#define DEVICE_IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568)
#define SCREENHEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SIZEABOUTIOSVERSION ([[[UIDevice currentDevice] systemVersion] floatValue]<7.0?0:20)
#define IOSVERSIONSMALL ([[[UIDevice currentDevice] systemVersion] floatValue]<7.0?20:0)
@interface ZhuanPanViewController ()

@end

@implementation ZhuanPanViewController

@synthesize myRequest,isPush;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(50, 10+SIZEABOUTIOSVERSION, 220, 30)];
    }
    return self;
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    myWebView.scrollView.scrollEnabled=YES;
    myWebView.userInteractionEnabled=YES;
    
    if ([webView canGoForward]) {
        [goForward setSelected:NO];
    }else{
        [goForward setSelected:YES];
    }
    
    [self stopAnimat];
    
    _titleLabel.text = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    NSDictionary *dict2 = @{@"type" :_titleLabel.text};
    [MobClick event:@"webShow" attributes:dict2];
    
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

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self stopAnimat];
    if (failImageFlag==0) {
        [self.view addSubview:failImageView];
        failImageFlag=1;
    }
    if ([webView.request.URL.description hasPrefix:@"http://m.paixie"]) {
        return;
    }
    
}
-(void)setName:(NSString *)string{
    if (isPush) {
        [self addTitle:string];
    }else{
        [self.titleLabel setText:string];
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
    
    failImageFlag=0;
    
    failImageView=[[UIImageView alloc]initWithFrame:CGRectMake(76.5,(SCREENHEIGHT-102-90)/2,167,90)];
    failImageView.center=self.view.center;
    failImageView.image=[UIImage imageNamed:@"biaoqing.png"];
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    
    UIView* headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 44+SIZEABOUTIOSVERSION)];
    UIImageView *headerBackground=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320,44+SIZEABOUTIOSVERSION)];
    [headerView addSubview:headerBackground];
    headerBackground.image=[[UIImage imageNamed:@"gm_nav"]stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    
    _titleLabel.backgroundColor=[UIColor clearColor];
    _titleLabel.font=[UIFont systemFontOfSize:20];
    _titleLabel.textAlignment=NSTextAlignmentCenter;
    _titleLabel.textColor=[UIColor whiteColor];
    [headerView addSubview:_titleLabel];
    
    
    bottomView=[[UIView alloc]init];
    bottomView.frame=CGRectMake(0, SCREENHEIGHT-43-IOSVERSIONSMALL, 320,43);
    bottomView.backgroundColor=[UIColor clearColor];
    UIImageView *bottomBg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 43)];
    bottomBg.image=[[UIImage imageNamed:@"nav"]stretchableImageWithLeftCapWidth:5 topCapHeight:0];
    [bottomView addSubview:bottomBg];
    
    MyButton * goBack=[MyButton buttonWithType:UIButtonTypeCustom];
    goBack.frame=CGRectMake(5, 3,40, 40);
    [goBack setNormalImage:[UIImage imageNamed:@"left_back"]];
    [goBack setHighlightedImage:[UIImage imageNamed:@"left_back_d"]];
    [bottomView addSubview:goBack];
    [goBack addTarget:self action:@selector(goBackToFront)];
    goForward=[MyButton buttonWithType:UIButtonTypeCustom];
    goForward.frame=CGRectMake(50, 3,40, 40);
    [goForward setNormalImage:[UIImage imageNamed:@"right_back"]];
    [goForward setSelectedImage:[UIImage imageNamed:@"right_back_no"]];
    [goForward setHighlightedImage:[UIImage imageNamed:@"right_back_d"]];
    [goForward setSelected:YES];
    [bottomView addSubview:goForward];
    [goForward addTarget:self action:@selector(goForward)];
    MyButton * update=[MyButton buttonWithType:UIButtonTypeCustom];
    update.frame=CGRectMake(275, 3,40, 40);
    [bottomView addSubview:update];
    [update setHighlightedImage:[UIImage imageNamed:@"shuaxin_d"]];
    [update setNormalImage:[UIImage imageNamed:@"shuaxin"]];
    [update addTarget:self action:@selector(pageUpdate)];
    
    MyButton * homeButton=[MyButton buttonWithType:UIButtonTypeCustom];
    homeButton.frame=CGRectMake(230,3,40, 40);
    [bottomView addSubview:homeButton];
    [homeButton addTarget:self action:@selector(gohome)];
    [homeButton setNormalImage:[UIImage imageNamed:@"home"]];
    [homeButton setHighlightedImage:[UIImage imageNamed:@"home_d"]];
    
 
    [self loadWebView];

    [self.view addSubview:bottomView];
    if (isPush==0) {
        [self.view addSubview:headerView];
    }
    [self buildLoadingAnimat];
    [self startAnimat];
    // Do any additional setup after loading the view.
}
-(void)loadWebView{
    
    myWebView=[[UIWebView alloc]init];
    myWebView.frame= CGRectMake(0,(isPush?0:44+SIZEABOUTIOSVERSION),320, SCREENHEIGHT-(isPush?:106));
    [myWebView.scrollView setBounces:NO];
    myWebView.scrollView.scrollEnabled=NO;
    myWebView.userInteractionEnabled=NO;
    [self.view addSubview:myWebView];
    myWebView.delegate=self;
    [myWebView loadRequest:self.myRequest];
}

-(void)ReloadWebView{
    
    [myWebView removeFromSuperview];
    myWebView=[[UIWebView alloc]init];
    myWebView.frame= CGRectMake(0,(isPush?0:44+SIZEABOUTIOSVERSION),320, SCREENHEIGHT-(isPush?:106));
    [myWebView.scrollView setBounces:NO];
    myWebView.scrollView.scrollEnabled=NO;
    myWebView.userInteractionEnabled=NO;
    [self.view addSubview:myWebView];
    myWebView.delegate=self;
    
    NSRange ran=[[[NSUserDefaults standardUserDefaults]objectForKey:@"LoadUrl"] rangeOfString:@"phone="];
    if (ran.location==NSNotFound) {
        NSRange ran=[[[NSUserDefaults standardUserDefaults]objectForKey:@"LoadUrl"] rangeOfString:@"?"];
        if (ran.location!=NSNotFound) {
            [myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@&phone=%@&city=%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"LoadUrl"],[[NSUserDefaults standardUserDefaults] objectForKey:@"userPhone"],[RootUrl getCity]]]]];
        }else{
            
            [myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?phone=%@&city=%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"LoadUrl"],[[NSUserDefaults standardUserDefaults] objectForKey:@"userPhone"],[RootUrl getCity]]]]];
        }
    }

}


-(void)goForward{
    [myWebView goForward];
}
-(void)viewWillAppear:(BOOL)animated{
    if ([RootUrl getUMLogClickFlag]) {
        NSDictionary *dict2 = @{@"type" : @"inweb"};
        [MobClick event:@"loginNet_isRun" attributes:dict2];
        [RootUrl setUMLogClickFlag:0];
    }

    [MobClick beginLogPageView:@"webPage"];
    [self hideTabBar];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    if (failImageFlag) {
        [failImageView removeFromSuperview];
        failImageFlag=0;
    }
    if (myWebView.isHidden) {
        [myWebView setHidden:NO];
    }
    
    //    [self.tabBarController.tabBar setHidden:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [MobClick endLogPageView:@"webPage"];
    self.tabBarController.tabBar.hidden=NO;
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSLog(@"request.Url:%@",request.URL.description);
    
     NSRange MyRan=[request.URL.description rangeOfString:@"16wifi.com"];
    if (MyRan.location!=NSNotFound) {
        
        NSRange login=[request.URL.description rangeOfString:@"userlogin"];
        
        if (login.location!=NSNotFound) {
            
            LoginViewController *loginCtr=[[LoginViewController alloc]init];
            loginCtr.delegate=self;
            loginCtr.Ltag=15050701;
            [self presentViewController:loginCtr animated:YES completion:^{
                [loginCtr showNotice:@"请先登录"];
            }];
            return NO;
        }
        

        
        NSRange ran=[request.URL.description rangeOfString:@"phone="];
        if (ran.location==NSNotFound) {
            
            NSRange ran=[request.URL.description rangeOfString:@"?"];
            if (ran.location!=NSNotFound) {
                [myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@&phone=%@&city=%@",request.URL.description,[[NSUserDefaults standardUserDefaults] objectForKey:@"userPhone"],[RootUrl getCity]]]]];
            }else{
                
                [myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?phone=%@&city=%@",request.URL.description,[[NSUserDefaults standardUserDefaults] objectForKey:@"userPhone"],[RootUrl getCity]]]]];
            }
            
            [[NSUserDefaults standardUserDefaults]setObject:request.URL.description forKey:@"LoadUrl"];
            
            return NO;
        }
        
//        NSRange cgiRan=[request.URL.description rangeOfString:@"cgi-bin"];
//        if (cgiRan.location!=NSNotFound) {
//            return NO;
//        }
        
    }
    
      return YES;
}
-(void)loginSuccessWithTag:(int)tag{

    switch (tag) {
        case 15050701:
        {
            
//            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"CallBackUrl"]) {
//                
//                NSRange ran=[[[NSUserDefaults standardUserDefaults] objectForKey:@"CallBackUrl"] rangeOfString:@"?"];
//                if (ran.location!=NSNotFound) {
//                    self.myRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@&phone=%@&city=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"CallBackUrl"],[[NSUserDefaults standardUserDefaults] objectForKey:@"userPhone"],[RootUrl getCity]]]];
//                }else{
//                    
//                    self.myRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?phone=%@&city=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"CallBackUrl"],[[NSUserDefaults standardUserDefaults] objectForKey:@"userPhone"],[RootUrl getCity]]]];
//                }
//
//
//            }
            
              [self ReloadWebView];
        }
            break;
            
        default:
            break;
    }
}
-(void)pageUpdate{
    [myWebView reload];
}

-(void)gohome{
    if (isPush==0) {
        [self dismissViewControllerAnimated:NO completion:^{}];
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)goBackToFront{
    if (myWebView.canGoBack) {
        [myWebView goBack];
    }else{
        if (isPush==0) {
            [self dismissViewControllerAnimated:NO completion:^{}];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)startAnimat{
    [aniBg setHidden:NO];
    [NSTimer scheduledTimerWithTimeInterval:500 target:self selector:@selector(stopAnimat) userInfo:nil repeats:NO];
    loadingAni.animationRepeatCount = 100000;
    flag=1;
    [loadingAni startAnimating];
}
-(void)stopAnimat{
    [aniBg setHidden:YES];
    flag=0;
    [loadingAni stopAnimating];
    
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
    [NSTimer scheduledTimerWithTimeInterval:500 target:self selector:@selector(stopAnimat) userInfo:nil repeats:NO];
    [loadingAni startAnimating];
    loadingAni.center=aniBg.center;
    [aniBg addSubview:loadingAni];
    aniBg.center=CGPointMake(self.view.center.x, self.view.center.y-40);
    [self.view addSubview:aniBg];
}
-(void)webViewDidStartLoad:(UIWebView *)webView{
    if (failImageFlag) {
        [failImageView removeFromSuperview];
        failImageFlag=0;
    }
    [self startAnimat];
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

