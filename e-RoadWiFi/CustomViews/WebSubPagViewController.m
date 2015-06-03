//
//  WebSubPagViewController.m
//  e路WiFi
//
//  Created by JAY on 13-10-29.
//  Copyright (c) 2013年 HE ZHENJIE. All rights reserved.
//

#import "WebSubPagViewController.h"
#import "UserShopViewController.h"
#import "LoginViewController.h"
#import "MyButton.h"
#import "MobClick.h"
#import "AppDelegate.h"
#define DEVICE_IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568)
#define SCREENHEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SIZEABOUTIOSVERSION ([[[UIDevice currentDevice] systemVersion] floatValue]<7.0?0:20)
#define IOSVERSIONSMALL ([[[UIDevice currentDevice] systemVersion] floatValue]<7.0?20:0)
@interface WebSubPagViewController ()

@end
@implementation WebSubPagViewController
@synthesize myRequest,isPush,myWebView;
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
    if ([webView canGoForward]) {
        [goForward setSelected:NO];
    }else{
        [goForward setSelected:YES];
    }
    if (failImageFlag) {
        [failImageView removeFromSuperview];
        failImageFlag=0;
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
    failImageView=[[UIView alloc]initWithFrame:CGRectMake(0,65,SCREENWIDTH,SCREENHEIGHT-108)];
    failImageView.backgroundColor=[UIColor whiteColor];
    UIImageView *imge=[[UIImageView alloc]initWithFrame:CGRectMake((SCREENWIDTH-167)/2,(SCREENHEIGHT-200)/2,167,90)];
    imge.image=[UIImage imageNamed:@"biaoqing.png"];
    [failImageView addSubview:imge];
    

    
    

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
    
    //https 认证数据初始化
    self.originRequest=[[NSURLRequest alloc]init];
    self.isAuthed =NO;
    
    myWebView=[[UIWebView alloc]init];
         myWebView.frame= CGRectMake(0,(isPush?0:44+SIZEABOUTIOSVERSION),320, SCREENHEIGHT-(isPush?:106));
    [myWebView.scrollView setBounces:NO];
    [self.view addSubview:myWebView];
    myWebView.delegate=self;
    [myWebView loadRequest:self.myRequest];
    [self buildLoadingAnimat];
    [self startAnimat];
    [self.view addSubview:bottomView];
    if (isPush==0) {
        [self.view addSubview:headerView];
    }
  	// Do any additional setup after loading the view.
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

-(void)pageUpdate{
    [myWebView reload];
}
-(void)gohome{
    [self stopAnimat];
    if (isPush==0) {
        [self dismissViewControllerAnimated:NO completion:^{}];
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)goBackToFront{
    
    NSLog(@"canGoBack%d",myWebView.canGoBack);
     NSLog(@"self.canGoBack%d",self.GoBack);
    
    if (myWebView.canGoBack&&!self.GoBack) {
       
        [myWebView goBack];
    }else{
        [self stopAnimat];
        if (isPush==0) {
            [self dismissViewControllerAnimated:NO completion:^{}];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)startAnimat{
    [aniBg setHidden:NO];
    [NSTimer scheduledTimerWithTimeInterval:50 target:self selector:@selector(stopAnimat) userInfo:nil repeats:NO];
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
     [self startAnimat];
    if (failImageFlag) {
        [failImageView removeFromSuperview];
        failImageFlag=0;
    }
}
-(void)loginSuccessWithTag:(int)tag{
    
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
   
    NSLog(@"WebRequest.Url:%@",request.URL.description);
    
    
    NSRange baiduKs=[request.URL.description rangeOfString:@"ks.baidu.com"];
    if (baiduKs.location!=NSNotFound) {
        
        NSRange bkid=[request.URL.description rangeOfString:@"bkid="];
        
        if (bkid.location!=NSNotFound) {
            NSArray *array=[request.URL.description componentsSeparatedByString:@"bkid="];
            
            NSArray * bkidArr=[array[1] componentsSeparatedByString:@"&"];
            NSString *Bookid= [bkidArr firstObject];
            NSLog(@"bkib:%@",Bookid);
            
            AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
            [app AddCoinRequestWithType:@"con" ContentId:Bookid UserId:[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"]CoinNum:@"2"];
            app.delegateView=self;
            
        }
        
    }
    
    
    NSString* scheme = [[request URL] scheme];
    if ([scheme isEqualToString:@"https"]) {
        //如果是https:的话，那么就用NSURLConnection来重发请求。从而在请求的过程当中吧要请求的URL做信任处理。
        if (!self.isAuthed) {
            _isAuthed=NO;
            _originRequest = request;
            NSURLConnection* conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            
            [conn start];
            [webView stopLoading];
            [self stopAnimat];
            return NO;
        }else{
           
            
        }
    }
    NSString * strUrl=[NSString stringWithFormat:@"%@",request.URL];
    
    NSRange ran3=[strUrl rangeOfString:@"android"];
    NSRange ran4=[strUrl rangeOfString:@"apk"];
    NSRange ran5=[strUrl rangeOfString:@"https://itunes.apple.com"];
    if (ran5.location!=NSNotFound) {
        [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    }
    if (ran3.location!=NSNotFound||ran4.location!=NSNotFound) {
        return NO;
    }
    
    NSRange ran1=[strUrl rangeOfString:@"16wifi.com"];
    if (ran1.location!=NSNotFound) {
        NSRange rr=[strUrl rangeOfString:@"?phone="];
        if (rr.location!=NSNotFound) {
            NSUserDefaults * userDef=[NSUserDefaults standardUserDefaults];
            NSString *goUrl=[NSString stringWithFormat:@"%@?phone=%@&city=%@",request.URL.description,[userDef objectForKey:@"userPhone"],[RootUrl getCity]];
            NSLog(@"活动%@",goUrl);
            [myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:goUrl]]];
            return NO;
        }else{
            return YES;
        }
        
    }
    NSRange ran0=[request.URL.description rangeOfString:@"lijiduihuan"];
    NSRange ran2=[request.URL.description rangeOfString:@"userlogin"];
  
    
    if (ran0.location!=NSNotFound) {
        UserShopViewController *userShop=[[UserShopViewController alloc]init];
        [self.navigationController pushViewController:userShop animated:YES];
        return NO;
    }
    if (ran2.location!=NSNotFound) {
        LoginViewController *loginCtr=[[LoginViewController alloc]init];
        loginCtr.delegate=self;
        [self presentViewController:loginCtr animated:YES completion:^{
            [loginCtr showNotice:@"请先登录"];
        }];
        return NO;
    }
   
    return YES;
    


}
-(void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
    if ([challenge previousFailureCount]== 0) {
        self.isAuthed = YES;

        //NSURLCredential 这个类是表示身份验证凭据不可变对象。凭证的实际类型声明的类的构造函数来确定。
        NSURLCredential* cre = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        [challenge.sender useCredential:cre forAuthenticationChallenge:challenge];
    }else
    {
        [[challenge sender] cancelAuthenticationChallenge:challenge];
    }
}
-(NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response{
    return  request;
}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.isAuthed=YES;
    [myWebView loadRequest:self.originRequest];
    //清空旧数据
    [connection  cancel];
}
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
