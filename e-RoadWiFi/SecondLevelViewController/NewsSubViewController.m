//
//  NewsSubViewController.m
//  e-RoadWiFi
//
//  Created by Jay on 14-9-10.
//  Copyright (c) 2014年 G.MING. All rights reserved.
//

#import "NewsSubViewController.h"
#import "MyButton.h"
#import "RootUrl.h"
#import "UIImageView+WebCache.h"
#import "MobClick.h"
#import "CustomActionSheet.h"
#import "MyCustomActionSheet.h"
#import "Encryption.h"
#import "AppDelegate.h"
#import "GetCMCCIpAdress.h"
#define DEVICE_IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568)
#define SIZEABOUTIOSVERSION ([[[UIDevice currentDevice] systemVersion] floatValue]<7.0?0:20)
#define IOSVERSIONSMALL ([[[UIDevice currentDevice] systemVersion] floatValue]<7.0?20:0)
@interface NewsSubViewController ()

@end

@implementation NewsSubViewController
@synthesize myRequest,isPush,newitem;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(50, 10+SIZEABOUTIOSVERSION, 220, 30)];
    }
    return self;
}
-(void)downloadComplete:(HttpDownload *)hd{
    NSError *error = nil;
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:hd.mData options:NSJSONReadingAllowFragments error:&error];

    if (error!=nil) {
        NSLog(@"json解析失败32");
    }else{
        NSNumber *num=[dic objectForKey:@"ReturnCode"];
        if ([num intValue]==200) {
            
            int aaa=[newitem.gold intValue];
            if (aaa) {
                UIImageView *goldBg=[[UIImageView alloc]initWithFrame:CGRectMake(132,SCREENHEIGHT, 56, 56)];
                goldBg.tag=9090;
                
                goldBg.image=[UIImage imageNamed:@"round.png"];
                [self.view addSubview:goldBg];
                UILabel *goldLabel=[[UILabel alloc]initWithFrame:CGRectMake(5,18,43,20)];
                goldLabel.backgroundColor=[UIColor clearColor];
                goldLabel.textAlignment=NSTextAlignmentCenter;
                goldLabel.textColor=[UIColor whiteColor];
                goldLabel.font=[UIFont boldSystemFontOfSize:17];
                [goldBg addSubview:goldLabel];
                goldLabel.text=[NSString stringWithFormat:@"+ %d",aaa];
                [UIView animateWithDuration:0.9 animations:^{
                    goldBg.frame=CGRectMake(132,SCREENHEIGHT-116, 56, 56);
                } completion:^(BOOL finished){
                    [UIView animateWithDuration:1.5 animations:^{
                        goldBg.alpha=0;
                    } completion:^(BOOL finished){
                        [goldBg removeFromSuperview];
                    }];
                }];
            }
        }
    }
}
-(void)downloadFailed:(HttpDownload *)hd{}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"页面加载完成");
    if (failImageFlag) {//如果是1，标示显示失败的图片存在 要将view移除；
        
        [failImageView removeFromSuperview];
        failImageFlag=0;//0 表示不存在 1标示加载成功
        
    }
    if (goldFlag) {
        goldFlag=0;
        if([newitem.gold intValue]){
            HttpDownload *httdD=[[HttpDownload alloc]init];
            httdD.delegate=self;
            httdD.DComplete=@selector(downloadComplete:);
            httdD.DFailed=@selector(downloadFailed:);
            NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
            NSString *sign=[NSString stringWithFormat:@"con_news%@%@",newitem.contentId,[def objectForKey:@"userID"]];
            
            NSString *subUrl=[NSString stringWithFormat:@"mod=downtocredit&fid=con_news&gid=%@&uid=%@&amount=%@&sign=%@",newitem.contentId,[def objectForKey:@"userID"],newitem.gold,[RootUrl md5:sign]];
            
            NSData *secretData=[subUrl dataUsingEncoding:NSUTF8StringEncoding];
            NSData *qValueData=[secretData AES256EncryptWithKey:SECRETKEY];
            NSString *qValue=[qValueData newStringInBase64FromData];
            if([RootUrl getIsNetOn]||[[GetCMCCIpAdress getSSID]isEqualToString:@"16wifi"]){
                [httdD downloadFromUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@/app_api/credit/addCredit.html?q=%@",NewBaseUrl,qValue]]];
            
            }
        }
        
    }

    [self stopAnimat];
    
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    if (![def objectForKey:@"fountSize"]) {
        [def setObject:@"120%" forKey:@"fountSize"];
        [def synchronize];
    }
    [myWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust='%@'",[def objectForKey:@"fountSize"]]];

    NSLog(@"------height------%f",[[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue]);
    
    
   
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"页面加载失败");
    NSLog(@"failImageFlag:%d",failImageFlag);

    if (failImageFlag==0) {
        [self.view addSubview:failImageView];
        failImageFlag=1;

    }
    [self stopAnimat];
}
-(void)setName:(NSString *)string{
    [self.titleLabel setText:string];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    goldFlag=1;
    failImageFlag=0;
    failImageView=[[UIView alloc]initWithFrame:CGRectMake(0,65,SCREENWIDTH,SCREENHEIGHT-65)];
    failImageView.backgroundColor=[UIColor whiteColor];
    UIImageView *imge=[[UIImageView alloc]initWithFrame:CGRectMake((SCREENWIDTH-167)/2,(SCREENHEIGHT-155)/2,167,90)];
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
    
    
    MyButton * goBack=[MyButton buttonWithType:UIButtonTypeCustom];
        goBack.frame=CGRectMake(0, SIZEABOUTIOSVERSION,50, 44);
    [goBack setNormalImage:[UIImage imageNamed:@"newBack"]];
    [goBack setSelectedImage:[UIImage imageNamed:@"newBack_d"]];
    [goBack addTarget:self action:@selector(goBackToFront)];
    [headerView addSubview:goBack];
    MyButton * shareButton=[MyButton buttonWithType:UIButtonTypeCustom];
    shareButton.frame=CGRectMake(SCREENWIDTH-55, SIZEABOUTIOSVERSION,50, 44);
    [shareButton setNormalImage:[UIImage imageNamed:@"jayNewsShare"]];
    [shareButton setSelectedImage:[UIImage imageNamed:@"jayNewsShare_d"]];
    [shareButton addTarget:self action:@selector(goShareVedio)];
    [headerView addSubview:shareButton];

    MyButton*  moreButton=[MyButton buttonWithType:UIButtonTypeCustom];
    moreButton.frame=CGRectMake(SCREENWIDTH-95,SIZEABOUTIOSVERSION, 50, 44);
    [moreButton setNormalImage:[UIImage imageNamed:@"wenzi"]];
    [moreButton setSelectedImage:[UIImage imageNamed:@"wenzi_d"]];
    [moreButton addTarget:self action:@selector(ButtonClick)];
    [headerView addSubview:moreButton];
    
    if (_isRecommend) {
        shareButton.hidden=YES;
        moreButton.frame=CGRectMake(SCREENWIDTH-55,SIZEABOUTIOSVERSION, 50, 44);
    }
    
    [self.view addSubview:headerView];
    
    //https 认证数据初始化
    self.originRequest=[[NSURLRequest alloc]init];
    self.isAuthed =NO;
    
    myWebView=[[UIWebView alloc]init];
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0) {
        myWebView.frame=CGRectMake(0,44+SIZEABOUTIOSVERSION,320,SCREENHEIGHT-44-SIZEABOUTIOSVERSION);
    }
    [myWebView.scrollView setBounces:NO];
    myWebView.delegate=self;
    [myWebView loadRequest:self.myRequest];
    
    
    [self.view addSubview:myWebView];
    
    [self buildLoadingAnimat];
    [self startAnimat];
   
    self.view.backgroundColor=[UIColor whiteColor];
    
  	// Do any additional setup after loading the view.
}
-(void)ButtonClick{

    if ([UIDevice currentDevice].systemVersion.doubleValue<8.0) {
        
        sheet = [[CustomActionSheet alloc] initWithViewHeight:174.0f WithSheetTitle:nil];
        
        NSArray *titles=@[@"字体大小"];
       
        
        UIImageView *bgview=[[UIImageView alloc]initWithFrame:CGRectMake(100, 23, 210, 44)];
        bgview.image=[[UIImage imageNamed:@"ACbut.png"]stretchableImageWithLeftCapWidth:5 topCapHeight:10];
        
        
        [sheet.customView addSubview:bgview];
        
        
        for (int j=0; j<1; j++) {
            
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 35+40*j, 70, 20)];
            label.text=titles[j];
            label.font=[UIFont systemFontOfSize:17];
            label.textAlignment=NSTextAlignmentCenter;
            [sheet.customView addSubview:label];
     
            
        }
        
        
        UIView *lineView1=[[UIView alloc]initWithFrame:CGRectMake(70,0,0.5, 44)];
        lineView1.backgroundColor=[UIColor colorWithRed:215/255.f green:217/255.f blue:223/255.f alpha:0.7];
        [bgview addSubview:lineView1];
        
        UIView *lineView2=[[UIView alloc]initWithFrame:CGRectMake(140,0,0.5, 44)];
        lineView2.backgroundColor=[UIColor colorWithRed:215/255.f green:217/255.f blue:223/255.f alpha:0.7];
        [bgview addSubview:lineView2];
        
        
        for (int i=0; i<3; i++) {
            
            MyButton *button=[MyButton buttonWithType:UIButtonTypeCustom];
            button.frame=CGRectMake(115+70*i,30, 50, 30);
            button.tag=40012+i;
            [button addTarget:self action:@selector(btn:)];
            [button setNTitleColor:[UIColor blackColor]];
            [button setSTitleColor:[UIColor colorWithRed:0/255.0f green:172/255.0f blue:238/255.0f alpha:1]];
            
            
            [sheet.customView addSubview:button];
            
            if (i==0) {
                [button setNTitle:@"小"];
                button.titleLabel.font=[UIFont systemFontOfSize:13];
            }else if (i==1){
                [button setNTitle:@"中"];
                button.titleLabel.font=[UIFont systemFontOfSize:15];
            }else{
                
                [button setNTitle:@"大"];
                button.titleLabel.font=[UIFont systemFontOfSize:17];
            }
            
        }
        
        NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
        if ([[def objectForKey:@"fountSize"] isEqual:@"100%"]) {
            MyButton *selbutton=(MyButton *)[sheet.customView viewWithTag:40012];
            [selbutton setNTitleColor:[UIColor colorWithRed:0/255.0f green:172/255.0f blue:238/255.0f alpha:1]];
            
        }else if ([[def objectForKey:@"fountSize"]isEqual:@"120%"]){
            MyButton *selbutton=(MyButton *)[sheet.customView viewWithTag:40013];
            [selbutton setNTitleColor:[UIColor colorWithRed:0/255.0f green:172/255.0f blue:238/255.0f alpha:1]];
        }else{
            
            MyButton *selbutton=(MyButton *)[sheet.customView viewWithTag:40014];
            [selbutton setNTitleColor:[UIColor colorWithRed:0/255.0f green:172/255.0f blue:238/255.0f alpha:1]];
        }
        [sheet showInView:self.view];
        

        
    }else{
    
        MyCustomActionSheet *alert = [MyCustomActionSheet alertControllerWithTitle:@" "
                                                                           message:@" "
                                                                    preferredStyle:UIAlertControllerStyleActionSheet];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"完成"
                                                  style:UIAlertActionStyleCancel
                                                handler:^(UIAlertAction *action) {
                                                    NSLog(@"wancheng");
                                                    
                                                }]];
        
        alert.myWebView=myWebView;
        
        [self presentViewController:alert animated:YES completion:nil];
        

    }

}

-(void)btn:(MyButton *)button{

    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];

    for (int i=0; i<3; i++) {
        MyButton *btn=(MyButton *)[sheet.customView viewWithTag:40012+i];
        if (btn.tag==button.tag) {
            
        [btn setNTitleColor:[UIColor colorWithRed:0/255.0f green:172/255.0f blue:238/255.0f alpha:1]];
        }else{
         [btn setNTitleColor:[UIColor blackColor]];
            
        }
       
    }
    
    if (button.tag==40012) {
    [myWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '100%'"];
    [def setObject:@"100%" forKey:@"fountSize"];
        
    }else if (button.tag==40013){
    [myWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '120%'"];
    [def setObject:@"120%" forKey:@"fountSize"];
    }else{
    [myWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '130%'"];
    [def setObject:@"130%" forKey:@"fountSize"];
    }
    [def synchronize];
    
}

-(BOOL)isDirectShareInIconActionSheet{
    return YES;
}
-(void)goForward{
    [myWebView goForward];
}
-(void)viewWillAppear:(BOOL)animated{
    
    [MobClick beginLogPageView:@"newsSub"];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    if (failImageFlag) {//如果是1，标示显示失败的图片存在 要将view移除；
        
        [failImageView removeFromSuperview];
        
        
        failImageFlag=0;//0 表示不存在 1标示加载成功
    
    }
    
    [self.tabBarController.tabBar setHidden:YES];

    self.navigationController.navigationBar.hidden=YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [MobClick endLogPageView:@"newsSub"];
    self.tabBarController.tabBar.hidden=NO;
    self.navigationController.navigationBar.hidden=NO;
}
-(void)goShareVedio{
    [self stopAnimat];
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    [def setObject:@"1" forKey:@"ShareWxType"];
    [def synchronize];
    
    if ([RootUrl getIsNetOn]) {
        NSString *murl;
        if ([newitem.myNewsImage hasPrefix:@"http"]) {
            murl=[NSString stringWithString:newitem.myNewsID];
        }else{
            murl=[NSString stringWithFormat:@"http://general.16wifi.com/%@",newitem.myNewsID];
        }
        

        [UMSocialData defaultData].extConfig.wechatTimelineData.shareText=newitem.myNewsTitle;
        [UMSocialData defaultData].extConfig.wechatSessionData.shareText=newitem.myNewsTitle;
        [UMSocialData defaultData].extConfig.qzoneData.shareText=newitem.myNewsTitle;
        [UMSocialData defaultData].extConfig.qqData.shareText=newitem.myNewsTitle;
        [UMSocialData defaultData].extConfig.sinaData.shareText=[NSString stringWithFormat:@"%@\n%@",newitem.myNewsTitle,murl];
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
        
        [UMSocialData defaultData].extConfig.wechatSessionData.url = murl;
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = murl;
        [UMSocialData defaultData].extConfig.qzoneData.url = murl;
        [UMSocialData defaultData].extConfig.qqData.url = murl;
        [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeDefault url:murl];
        
        UIImage* image;
        if ([newitem.myNewsImage hasPrefix:@"http"]) {
            image=[[SDWebImageManager sharedManager] imageWithURL:[NSURL URLWithString:newitem.myNewsImage]];
        }else{
            image=[[SDWebImageManager sharedManager] imageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[RootUrl getContentUrl],newitem.myNewsImage]]];
        }
        
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:UMENG_APPKEY
                                          shareText:[NSString stringWithFormat:@"%@\n%@",newitem.myNewsTitle,murl]
                                         shareImage:image
                                    shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQzone,UMShareToQQ,UMShareToSina,nil]
                                           delegate:self];

            AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
            app.ShareContentId=[NSString stringWithFormat:@"%@",newitem.myNewsID];
        
    }else{
            UIAlertView *alterView=[[UIAlertView alloc]initWithTitle:nil message:@"当前网络不给力,请确认网络连接后重试" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
            [alterView show];
    }
}
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    NSLog(@"share success%@",response);
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
        
        NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
        
        if ( [[def objectForKey:@"ShareWxType"]isEqualToString:@"0"]) {
            
        }else{
            AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
            NSString *type=@"con_share";
            if ([[[response.data allKeys] objectAtIndex:0]isEqualToString:@"qq"]) {
                type=@"con_share_qq";
                
            }else if ([[[response.data allKeys] objectAtIndex:0]isEqualToString:@"qzone"]){
                type=@"con_share_zone";
            }else if ([[[response.data allKeys] objectAtIndex:0]isEqualToString:@"sina"]){
                type=@"con_share_wb";
                
            }
            [app AddCoinRequestWithType:type ContentId:newitem.myNewsID UserId:[def objectForKey:@"userID"]CoinNum:@"2"];
            app.delegateView=self;

        }
        
    }
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
    aniBg.center=CGPointMake(self.view.center.x, self.view.center.y+40);
    [self.view addSubview:aniBg];
}
-(void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"开始加载");
       if (failImageFlag) {
        [failImageView removeFromSuperview];
        failImageFlag=0;
       }
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{

    NSString* scheme = [[request URL] scheme];
    NSString * strUrl=request.URL.description;


    //判断是不是https
    if ([scheme isEqualToString:@"https"]) {
        //如果是https:的话，那么就用NSURLConnection来重发请求。从而在请求的过程当中吧要请求的URL做信任处理。
        if (!self.isAuthed) {
            _isAuthed=NO;
            _originRequest = request;
            NSURLConnection* conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            
            [conn start];
            [webView stopLoading];
            return NO;
        }else{
            return YES;
            
        }
    }
    
    NSRange ran3=[strUrl rangeOfString:@"android"];
    NSRange ran4=[strUrl rangeOfString:@"apk"];
    NSRange ran5=[strUrl rangeOfString:@"https://itunes.apple.com"];
    if (ran5.location!=NSNotFound) {
        [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    }
    if ( ran3.location==NSNotFound && ran4.location==NSNotFound) {
        [self startAnimat];
        return YES;
    }else{
        
        return  NO;
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

