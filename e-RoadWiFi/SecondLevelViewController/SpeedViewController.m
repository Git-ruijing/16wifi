//
//  SpeedViewController.m
//  e-RoadWiFi
//
//  Created by QC on 15/3/25.
//  Copyright (c) 2015年 G.MING. All rights reserved.
//

#import "SpeedViewController.h"
#import "wendu_yuan2.h"
#import "MyButton.h"
#import "JAYDownload.h"
#import "RootUrl.h"
#import "GetCMCCIpAdress.h"
#import "UMSocial.h"
#import "AppDelegate.h"
#import "NetPlayViewController.h"
@interface SpeedViewController ()

@end

@implementation SpeedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor=[UIColor whiteColor];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    count=0;
    curTaskDict=[[NSMutableDictionary alloc]init];
    MyScrollView=[[UIScrollView alloc]init];
    MyScrollView.frame=CGRectMake(0, 64, 320, SCREENHEIGHT-64);
    MyScrollView.backgroundColor=[UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1];
    MyScrollView.showsHorizontalScrollIndicator=NO;
    MyScrollView.showsVerticalScrollIndicator=NO;
    [self creatNav];
    [self.view addSubview:MyScrollView];
    
    
    Bgimage=[[UIImageView alloc]initWithFrame:CGRectMake(11, 100-20-64, 298, 276)];
    Bgimage.image=[UIImage imageNamed:@"ve00.png"];
    [MyScrollView addSubview:Bgimage];
    
    _wendu = [[wendu_yuan2 alloc]initWithFrame:CGRectMake(26, 115-20-64, 268, 246)];
    _wendu.backgroundColor = [UIColor clearColor];
    [MyScrollView addSubview:_wendu];
    
    
    TipsLabel=[[UILabel alloc]init];
    TipsLabel.frame=CGRectMake(10, 370-64-20-6,300, 20);
    TipsLabel.textAlignment=NSTextAlignmentCenter;
    
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];

    if ([GetCMCCIpAdress getSSID].length) {
        TipsLabel.text=[NSString stringWithFormat:@"当前连接%@网络",[GetCMCCIpAdress getSSID]];
    }else{
        if ([[def objectForKey:@"NetStatusTag"]integerValue ]==1) {
              TipsLabel.text=@"当前连接蜂窝数据";
        }else{
            TipsLabel.text=@"当前连接未知网络";
        }
    }
    
    TipsLabel.textColor=[UIColor colorWithRed:51/255.0f green:51/255.0f  blue:51/255.0f  alpha:1];
    TipsLabel.font=[UIFont systemFontOfSize:15 ];
    TipsLabel.backgroundColor=[UIColor clearColor];
    
    [MyScrollView addSubview:TipsLabel];
    
    TestSpeed=[UIButton buttonWithType:UIButtonTypeCustom];
    [TestSpeed setTitle:@"开始测速" forState:UIControlStateNormal];
    [TestSpeed setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    TestSpeed.titleLabel.font=[UIFont systemFontOfSize:15];
    [TestSpeed setBackgroundImage:[[UIImage imageNamed:@"gm_but"]stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
    [TestSpeed addTarget:self action:@selector(testSpeed) forControlEvents:UIControlEventTouchUpInside];
    TestSpeed.titleLabel.textColor=[UIColor redColor];
    [TestSpeed setFrame:CGRectMake(60, 400-64-20-6, 200, 45)];
    
    if (SCREENHEIGHT>480) {
        
        TipsLabel.frame=CGRectMake(10, 370-74,300, 20);
        [TestSpeed setFrame:CGRectMake(60, 400-64, 200, 45)];
    }
    [MyScrollView addSubview:TestSpeed];
  
    
//    NSArray * titles=@[@"断开",@"分享"];
//    NSArray *iamges=@[@"guan_grey",@"gm-share"];
//    
//    for (int i=0; i<2; i++) {
//        
//        UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(160*i, SCREENHEIGHT-54, 160, 54)];
//        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//        button.tag=15032500+i;
//        [self.view addSubview:button];
//        
//        UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(40, 16, 21, 21)];
//        image.image=[UIImage imageNamed:iamges[i]];
//        [button addSubview:image];
//        
//        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(75, 16, 50, 21)];
//        label.text=titles[i];
//        label.backgroundColor=[UIColor clearColor];
//        label.textAlignment=NSTextAlignmentCenter;
//        label.font=[UIFont systemFontOfSize:15];
//        [button addSubview:label];
//        
//    }
//    
//    UIView *lineView1=[[UIView alloc]initWithFrame:CGRectMake(0,SCREENHEIGHT-54,320, 0.5)];
//    lineView1.backgroundColor=[UIColor colorWithRed:215/255.f green:217/255.f blue:223/255.f alpha:0.7];
//    [self.view addSubview:lineView1];
//    
//    
//    UIView *lineView2=[[UIView alloc]initWithFrame:CGRectMake(160,SCREENHEIGHT-54,0.5, 54)];
//    lineView2.backgroundColor=[UIColor colorWithRed:215/255.f green:217/255.f blue:223/255.f alpha:0.7];
//    [self.view addSubview:lineView2];
    
    
}
-(void)creatNav{
    UIView * headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    UIImageView *headerBackground=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320,64)];
    [headerView addSubview:headerBackground];
    headerBackground.image=[[UIImage imageNamed:@"gm_nav"]stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    [self.view addSubview:headerView];
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(110, 10+SIZEABOUTIOSVERSION, 100, 30)];
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.font=[UIFont systemFontOfSize:20];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [headerView addSubview:titleLabel];
    titleLabel.text=@"网络测速";
    
    MyButton* goBack=[MyButton buttonWithType:UIButtonTypeCustom];
    goBack.frame=CGRectMake(0, SIZEABOUTIOSVERSION,50, 44);
    [goBack setNormalImage:[UIImage imageNamed:@"newBack"]];
    [goBack setSelectedImage:[UIImage imageNamed:@"newBack_d"]];
    [goBack addTarget:self action:@selector(goBackToSuperPage)];
    [headerView addSubview:goBack];
    
    
    MyButton * shareButton=[MyButton buttonWithType:UIButtonTypeCustom];
    shareButton.frame=CGRectMake(SCREENWIDTH-55, SIZEABOUTIOSVERSION,50, 44);
    [shareButton setNormalImage:[UIImage imageNamed:@"jayNewsShare"]];
    [shareButton setSelectedImage:[UIImage imageNamed:@"jayNewsShare_d"]];
    [shareButton addTarget:self action:@selector(shareApp)];
    [headerView addSubview:shareButton];

    
}
-(void)shareApp{

    if ([RootUrl getIsNetOn]) {
        NSString * murl=[NSString stringWithFormat:@"%@/thirdinfo/share/index.html",[RootUrl getRootUrl]];
        NSString *title=@"16WiFi的网速不错，我一直在用，走到哪里，都能免费上网，省了我不少流量，你也来用吧！";
        [UMSocialData defaultData].extConfig.wechatTimelineData.shareText=title;
        [UMSocialData defaultData].extConfig.wechatSessionData.shareText=title;
        [UMSocialData defaultData].extConfig.qzoneData.shareText=title;
        [UMSocialData defaultData].extConfig.qqData.shareText=title;
        [UMSocialData defaultData].extConfig.sinaData.shareText=[NSString stringWithFormat:@"%@\n%@",title,murl];
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
        
        [UMSocialData defaultData].extConfig.wechatSessionData.url = murl;
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = murl;
        [UMSocialData defaultData].extConfig.qzoneData.url = murl;
        [UMSocialData defaultData].extConfig.qqData.url = murl;
        [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeDefault url:murl];
        
        
        UIGraphicsBeginImageContext(self.view.bounds.size);
        [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:UMENG_APPKEY
                                          shareText:[NSString stringWithFormat:@"%@\n%@",title,murl]
                                         shareImage:viewImage
                                    shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQzone,UMShareToQQ,UMShareToSina,nil]
                                           delegate:self];
        
        AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
        app.ShareContentId=@"Speed";
        
    }else{
        UIAlertView *alterView=[[UIAlertView alloc]initWithTitle:nil message:@"网络不通，请稍后分享" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [alterView show];
    }

}
-(void)btnClick:(UIButton *)button{

    NSLog(@"%ld",(long)button.tag);
    switch (button.tag-15032500) {
        case 0:
        {
            NetPlayViewController *nvc=[[NetPlayViewController alloc]init];
            [nvc goLogOut];
        }
            break;
        case 1:
        {
            if ([RootUrl getIsNetOn]) {
                NSString * murl=[NSString stringWithFormat:@"%@/thirdinfo/share/index.html",[RootUrl getRootUrl]];
                NSString *title=@"16WiFi的网速不错，还免费！";
                [UMSocialData defaultData].extConfig.wechatTimelineData.shareText=title;
                [UMSocialData defaultData].extConfig.wechatSessionData.shareText=title;
                [UMSocialData defaultData].extConfig.qzoneData.shareText=title;
                [UMSocialData defaultData].extConfig.qqData.shareText=title;
                [UMSocialData defaultData].extConfig.sinaData.shareText=[NSString stringWithFormat:@"%@\n%@",title,murl];
                [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
                
                [UMSocialData defaultData].extConfig.wechatSessionData.url = murl;
                [UMSocialData defaultData].extConfig.wechatTimelineData.url = murl;
                [UMSocialData defaultData].extConfig.qzoneData.url = murl;
                [UMSocialData defaultData].extConfig.qqData.url = murl;
                [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeDefault url:murl];
                
                
                UIGraphicsBeginImageContext(self.view.bounds.size);
                [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
                UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                [UMSocialSnsService presentSnsIconSheetView:self
                                                     appKey:UMENG_APPKEY
                                                  shareText:[NSString stringWithFormat:@"%@\n%@",title,murl]
                                                 shareImage:viewImage
                                            shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQzone,UMShareToQQ,UMShareToSina,nil]
                                                   delegate:self];
                
                AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
                app.ShareContentId=@"Speed";
                
            }else{
                UIAlertView *alterView=[[UIAlertView alloc]initWithTitle:nil message:@"网络不通，请稍后分享" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
                [alterView show];
            }
            
        }
            break;
        default:
            break;
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
            [app AddCoinRequestWithType:type ContentId:@"Speed" UserId:[def objectForKey:@"userID"]CoinNum:@"2"];
            app.delegateView=self;

        }
        
    }
}


-(void)testSpeed{
    if ([RootUrl getIsNetOn]) {

        NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
        [def setObject:@"0" forKey:@"CurrentSpeed"];
        
        [self addTask:[NSString stringWithFormat:@"%@/r/cms/www/recommend/16wifi.apk",[RootUrl getRootUrl]] action:nil];
        
        timer=[NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(ReadCurrentSpeed) userInfo:nil repeats:YES];
        TestSpeed.userInteractionEnabled=NO;
        [TestSpeed setBackgroundImage:[[UIImage imageNamed:@"but_wenxin"]stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
        [TestSpeed setTitle:@"正在努力测速" forState:UIControlStateNormal];
        [TestSpeed setTitleColor:[UIColor colorWithRed:0 green:172/255.f blue:238/255.f alpha:1.0] forState:UIControlStateNormal];
//        TipsLabel.hidden=YES;
        

        
    }else{
    
        if ([[GetCMCCIpAdress getSSID]isEqualToString:@"16wifi"]) {
            
            UIAlertView *alterView=[[UIAlertView alloc]initWithTitle:nil message:@"16wifi未认证，无法测速" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
            [alterView show];
            
        }else{
            UIAlertView *alterView=[[UIAlertView alloc]initWithTitle:nil message:@"网络不通，请检查网络设置后重试" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
            [alterView show];
            
        }
    }
}

-(void)addTask:(NSString *)url action:(SEL)action{
    isLoading=YES;
    id object=[curTaskDict objectForKey:url];
    if (!object) {
        [curTaskDict setObject:url forKey:url];
        [[HttpManager sharedManager]addTask:url delegate:self action:action];
    }

}

-(void)ReadCurrentSpeed{

    float  value=[[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentSpeed"]floatValue];
    NSLog(@"READSPPE%f",value);
    
    if (++count<=15) {
        
        if (value>0&&value<=128) {
            _wendu.z =value/512;
            _wendu.dw.text=@"KB/S";
            if (value>=64) {
            Bgimage.image=[UIImage imageNamed:@"ve01.png"];
            }
        }else if (value>128&&value<=512){
            _wendu.z =0.25+((value-128)/1536);
            _wendu.dw.text=@"KB/S";
            if (value>=128+191) {
                Bgimage.image=[UIImage imageNamed:@"ve02.png"];
            }else{
               Bgimage.image=[UIImage imageNamed:@"ve01.png"];
            }
        }else if (value>512&&value<=1024){
            _wendu.z =0.5+((value-512)/2048);
            _wendu.dw.text=@"KB/S";
            if (value>=512+256) {
                Bgimage.image=[UIImage imageNamed:@"ve03.png"];
            }else{
                Bgimage.image=[UIImage imageNamed:@"ve02.png"];
            }
       
        }else{
            _wendu.z =0.75+((value-1024)/(7*1024))*0.25;
            _wendu.dw.text=@"M/S";
            if (value>=4*1024) {
                Bgimage.image=[UIImage imageNamed:@"ve04.png"];
            }else{
                Bgimage.image=[UIImage imageNamed:@"ve03.png"];
            }
      NSLog(@"Maxcount：%d Mac_wendu.z%f  Maxvalue:%f",count,_wendu.z,value);
        }
        NSLog(@"count：%d _wendu.z%f  value:%f",count,_wendu.z,value);

    }else{
        [[HttpManager sharedManager]removeTask:[NSString stringWithFormat:@"%@/r/cms/www/recommend/16wifi.apk",[RootUrl getRootUrl]]];
        [curTaskDict removeObjectForKey:[NSString stringWithFormat:@"%@/r/cms/www/recommend/16wifi.apk",[RootUrl getRootUrl]]];
        
        [timer invalidate];
        timer = nil;
        TipsLabel.hidden=NO;
        if (value<=128) {
            TipsLabel.text=@"当前网速一般，可浏览网页、聊天";
        }else if (value>128&&value<=512){
          TipsLabel.text=@"当前网速不错，来首音乐吧";
            
        }else if (value>512&&value<=1024){
            
        TipsLabel.text=@"当前网速很好，看会视频吧";
        }else{
            
        TipsLabel.text=@"当前网速好棒，做啥都行哦";
        }
        count=0;
        TestSpeed.userInteractionEnabled=YES;
        [TestSpeed setTitle:@"重新测速" forState:UIControlStateNormal];
        [TestSpeed setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [TestSpeed setBackgroundImage:[[UIImage imageNamed:@"gm_but"]stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];

    }

}

-(void)goBackToSuperPage{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{

        [self hideTabBar];
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
