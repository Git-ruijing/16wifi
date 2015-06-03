//
//  SubOfVedioViewController.m
//  16wifi2
//
//  Created by JAY on 13-5-10.
//  Copyright (c) 2013年 JAY. All rights reserved.
//

#import "SubOfVedioViewController.h"
#import "MyButton.h"
#import "RootUrl.h"
#import "MobClick.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import "VedioViewController.h"
#define DEVICE_IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568)
#define SCREENHEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SIZEABOUTIOSVERSION ([[[UIDevice currentDevice] systemVersion] floatValue]<7.0?0:20)
#define IOSVERSIONSMALL ([[[UIDevice currentDevice] systemVersion] floatValue]<7.0?20:0)

@interface SubOfVedioViewController ()

@end

@implementation SubOfVedioViewController
@synthesize itemArray=_itemArray,inPages=_inPages,channel;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //Custom initialization
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
-(void)goBackToFront{
    [JayPlayer.player pause];
    [playerLayer removeFromSuperlayer];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:JayPlayer.player.currentItem];
    //释放掉对playItem的观察
    [JayPlayer.player.currentItem removeObserver:self
                                      forKeyPath:@"status"
                                         context:nil];
    
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)creatBottomView{
    bottomView=[[UIView alloc]init];
    bottomView.frame=CGRectMake(0, SCREENHEIGHT-43-IOSVERSIONSMALL, 320,43);
    bottomView.backgroundColor=[UIColor clearColor];
    UIImageView *bottomBg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 43)];
    bottomBg.image=[[UIImage imageNamed:@"bottomBackground"]stretchableImageWithLeftCapWidth:5 topCapHeight:0];
    [bottomView addSubview:bottomBg];
    
    MyButton * goBack=[MyButton buttonWithType:UIButtonTypeCustom];
    goBack.frame=CGRectMake(5, 3,40, 40);
    [goBack setNormalImage:[UIImage imageNamed:@"left_back"]];
    [goBack setHighlightedImage:[UIImage imageNamed:@"left_back_d"]];
    [bottomView addSubview:goBack];
    [goBack addTarget:self action:@selector(goBackToFront)];

    
    MyButton * sharebutton=[MyButton buttonWithType:UIButtonTypeCustom];
    sharebutton.frame=CGRectMake(265, 3,50, 40);
    [bottomView addSubview:sharebutton];
    [sharebutton setHighlightedImage:[UIImage imageNamed:@"base_share_d"]];
    [sharebutton setNormalImage:[UIImage imageNamed:@"base_share"]];
    [sharebutton addTarget:self action:@selector(goShareVedio)];
    
    MyButton * download=[MyButton buttonWithType:UIButtonTypeCustom];
    download.frame=CGRectMake(220,3,50, 40);
    [bottomView addSubview:download];
    [download addTarget:self action:@selector(downloadVideo)];
    [download setNormalImage:[UIImage imageNamed:@"base_down"]];
    [download setHighlightedImage:[UIImage imageNamed:@"base_down_d"]];
    [self.view addSubview:bottomView];
    
}
- (void) oneTap:(UITapGestureRecognizer *)sender
{
    if ([myTimer isValid]) {
        [myTimer invalidate];
    }
    if (bottomToolView.isHidden)
    {
        [bottomToolView setHidden:NO];
        myTimer=[NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(hiddenToolBar) userInfo:nil repeats:NO];
    }else{
        [bottomToolView setHidden:YES];
    }
    
}
-(void)hiddenToolBar{
    [bottomToolView setHidden:YES];
}
-(void)creatAVPlayer{
    
    JayPlayer=[[CustomPlayerView alloc]initWithFrame:CGRectMake(0,SIZEABOUTIOSVERSION,SCREENWIDTH,180)];
   
    UITapGestureRecognizer *oneTap=nil;
    oneTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(oneTap:)];
    oneTap.numberOfTapsRequired = 1;
    [JayPlayer addGestureRecognizer:oneTap];
    [self.view addSubview:JayPlayer];

    
    bottomToolView=[[UIView alloc]initWithFrame:CGRectMake(0,180+SIZEABOUTIOSVERSION-44,SCREENWIDTH,44)];
    bottomToolView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    [self.view addSubview:bottomToolView];
    
    playOrPause=[MyButton buttonWithType:UIButtonTypeCustom];
    playOrPause.frame=CGRectMake(0,0, 65, 44);
    [playOrPause setNormalImage:[UIImage imageNamed:@"jaypause"]];
    [playOrPause setHighlightedImage:[UIImage imageNamed:@"jaypause_d"]];
    [playOrPause addTarget:self action:@selector(PlayOrPause)];
    [bottomToolView addSubview:playOrPause];
    
    Moviebuffer=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-25,55+SIZEABOUTIOSVERSION, 50, 40)];
    CALayer *lay  = Moviebuffer.layer;//获取层
    [lay setMasksToBounds:YES];
    [lay setCornerRadius:10];
    Moviebuffer.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    [self.view addSubview:Moviebuffer];
    
    
    
    
    durationLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH-145,28,100,12)];
    durationLabel.textAlignment=NSTextAlignmentRight;
    durationLabel.backgroundColor=[UIColor clearColor];
    durationLabel.textColor=[UIColor colorWithRed:153/255.f green:153/255.f blue:153/255.f alpha:1.f];
    durationLabel.font=[UIFont systemFontOfSize:9];
    [bottomToolView addSubview:durationLabel];
    
    
    
    
    
    movieProgressSlider=[[UISlider alloc]initWithFrame:CGRectMake(45, 12,SCREENWIDTH-90,20)];
    movieProgressSlider.backgroundColor=[UIColor clearColor];
    [movieProgressSlider setThumbImage:[UIImage imageNamed:@"thumb"] forState:UIControlStateNormal];
    [movieProgressSlider setMinimumTrackTintColor:[UIColor colorWithRed:0/255.f green:172/255.f blue:238/255.f alpha:1.f]];
    [movieProgressSlider setMaximumTrackTintColor:[UIColor whiteColor]];
    
    
    [movieProgressSlider addTarget:self action:@selector(scrubbingDidBegin) forControlEvents:UIControlEventTouchDown];
    [movieProgressSlider addTarget:self action:@selector(scrubberIsScrolling) forControlEvents:UIControlEventValueChanged];
    [movieProgressSlider addTarget:self action:@selector(scrubbingDidEnd) forControlEvents:(UIControlEventTouchUpInside | UIControlEventTouchCancel)];
    [bottomToolView addSubview:movieProgressSlider];
    

    
  
    
    MyButton * fillBtn=[MyButton buttonWithType:UIButtonTypeCustom];
    [fillBtn setImage:[UIImage imageNamed:@"full-screen.png"] forState:UIControlStateNormal];
    [fillBtn setImage:[UIImage imageNamed:@"full-screen_d.png"] forState:UIControlStateHighlighted];
    fillBtn.frame=CGRectMake(SCREENWIDTH-41,4, 36, 36);
    [fillBtn addTarget:self action:@selector(fullScreen)];
    [bottomToolView addSubview:fillBtn];

    
    [Moviebuffer startAnimating];

    [self playVideo];
}
-(void)scrubbingDidBegin{

    [JayPlayer.player pause];
    if ([myTimer isValid]) {
        [myTimer invalidate];
    }
    if (bottomToolView.isHidden)
    {
        [bottomToolView setHidden:NO];
        
    }
    NSLog(@"滑竿开始滑动");
}
-(void)scrubberIsScrolling{
    
    double currentTime = floor(totalMovieDuration *movieProgressSlider.value);
    //转换成CMTime才能给player来控制播放进度
    CMTime dragedCMTime = CMTimeMake(currentTime, 1);
    [JayPlayer.player seekToTime:dragedCMTime completionHandler:
     ^(BOOL finish)
     {
         if (isPlaying == YES)
         {
             [JayPlayer.player play];
         }
         [Moviebuffer stopAnimating];
         Moviebuffer.hidden = YES;
     }];
    
    NSLog(@"滑竿正在滑动");
}
-(void)scrubbingDidEnd{
    Moviebuffer.hidden=NO;
    [Moviebuffer startAnimating];
    if ([myTimer isValid]) {
        [myTimer invalidate];
    }
    if (bottomToolView.isHidden)
    {
        [bottomToolView setHidden:NO];
        
    }

     myTimer=[NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(hiddenToolBar) userInfo:nil repeats:NO];

    NSLog(@"滑竿结束滑动");
}
- (void)PlayOrPause{
    if (isPlaying == YES)
    {
        [JayPlayer.player pause];
        [playOrPause setNormalImage:[UIImage imageNamed:@"jayplay"]];
        [playOrPause setHighlightedImage:[UIImage imageNamed:@"jayplay_d"]];
        if ([myTimer isValid]) {
            [myTimer invalidate];
        }
        if (bottomToolView.isHidden)
        {
            [bottomToolView setHidden:NO];
            
        }
        
        isPlaying = NO;
    }
    else
    {
        [JayPlayer.player play];
        [playOrPause setNormalImage:[UIImage imageNamed:@"jaypause"]];
        [playOrPause setHighlightedImage:[UIImage imageNamed:@"jaypause_d"]];
        if ([myTimer isValid]) {
            [myTimer invalidate];
        }
        if (bottomToolView.isHidden)
        {
            [bottomToolView setHidden:NO];
            
        }
        myTimer=[NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(hiddenToolBar) userInfo:nil repeats:NO];
        isPlaying = YES;
    }
}
-(void)moviePlayDidEnd:(NSNotification*)notification{
    //视频播放完成
    isPlaying=NO;
    [playOrPause setNormalImage:[UIImage imageNamed:@"jayplay"]];
    [playOrPause setHighlightedImage:[UIImage imageNamed:@"jayplay_d"]];
    NSLog(@"播放完成");
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItem *playerItem = (AVPlayerItem*)object;
        if (playerItem.status==AVPlayerStatusReadyToPlay) {
            //视频加载完成
            [JayPlayer.player play];
            [Moviebuffer stopAnimating];
            Moviebuffer.hidden = YES;
            if (bottomToolView.hidden) {
                [bottomToolView setHidden:NO];
            }
            if ([myTimer isValid]) {
                [myTimer invalidate];
            }
            myTimer=[NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(hiddenToolBar) userInfo:nil repeats:NO];
            if (IOS7)
            {
                //计算视频总时间
                CMTime totalTime = playerItem.duration;
                totalMovieDuration = (CGFloat)totalTime.value/totalTime.timescale;
                NSDate *d = [NSDate dateWithTimeIntervalSince1970:totalMovieDuration];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                if (totalMovieDuration/3600 >= 1) {
                    [formatter setDateFormat:@"HH:mm:ss"];
                }
                else
                {
                    [formatter setDateFormat:@"mm:ss"];
                }
                NSString *showtimeNew = [formatter stringFromDate:d];
                durationLabel.text=[NSString stringWithFormat:@"%@/%@",[formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:0.f]],showtimeNew];
            }
        }
    }

    
}
-(void)fullScreen{
    
    [JayPlayer.player pause];
    if ([myTimer isValid]) {
        [myTimer invalidate];
    }
    if ([bottomToolView isHidden]) {
        [bottomToolView setHidden:NO];
    }
    
    CMTime tt=JayPlayer.player.currentItem.currentTime;
    PlayVedioViewController *playVedioCtr=[[PlayVedioViewController alloc]init];
    playVedioCtr.delegate=self;
    playVedioCtr.vedioTitle=item.vedioTitle;
    playVedioCtr.JayPlayerItem=JayPlayer.player.currentItem;
    playVedioCtr.startTime=tt.value/tt.timescale;
    playVedioCtr.isLocal=NO;
    playVedioCtr.isPlaying=isPlaying;
    [self presentViewController:playVedioCtr animated:NO completion:^{}];
    
}
 

-(void)creatInfo{

    infoView=[[UIView alloc]initWithFrame:CGRectMake(0,180+SIZEABOUTIOSVERSION, 320, 80)];
    infoView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:infoView];
    
    videoTitle=[[UILabel alloc]initWithFrame:CGRectMake(10,3, 300, 20)];
    videoTitle.numberOfLines=2;
    videoTitle.backgroundColor=[UIColor clearColor];
    videoTitle.textColor=[UIColor colorWithRed:51/255.f green:51/255.f blue:51/255.f alpha:1.0];
    videoTitle.font=[UIFont boldSystemFontOfSize:15];
    [infoView  addSubview:videoTitle];
    
    videoLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 25, 170,15)];
    videoLabel.textColor=[UIColor colorWithRed:76/255.f green:76/255.f blue:76/255.f alpha:1.0];
    videoLabel.font=[UIFont systemFontOfSize:12];
    
    videoLabel.backgroundColor=[UIColor clearColor];
    [infoView addSubview:videoLabel];

    
    videoDuration=[[UILabel alloc]initWithFrame:CGRectMake(10,42,170, 15)];
    videoDuration.font=[UIFont systemFontOfSize:12];
    videoDuration.backgroundColor=[UIColor clearColor];
    videoDuration.textColor=[UIColor colorWithRed:76/255.f green:76/255.f blue:76/255.f alpha:1.0];
    [infoView addSubview:videoDuration];
    
    

   
    
    contentLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 59,300,15)];
    contentLabel.backgroundColor=[UIColor clearColor];
    contentLabel.font=[UIFont systemFontOfSize:12];
    contentLabel.numberOfLines=1;
    contentLabel.textAlignment=NSTextAlignmentLeft;
    contentLabel.textColor=[UIColor colorWithRed:76/255.f green:76/255.f blue:76/255.f alpha:1.0];
    [infoView addSubview:contentLabel];
    

}
-(void)creatRecommentVedio{
    
    recommendView  =[[UIView alloc]initWithFrame:CGRectMake(0, 259+SIZEABOUTIOSVERSION, 320, SCREENHEIGHT-277-42)];
    recommendView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:recommendView];

    c2=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 19)];
    c2.backgroundColor=[UIColor clearColor];
    c2.font=[UIFont boldSystemFontOfSize:14];
    c2.text=@"相关推荐";
    c2.textColor=[UIColor colorWithRed:0/255.f green:172/255.f blue:238/255.f alpha:1.0];
    [recommendView addSubview:c2];
    myTabView=[[UITableView alloc]initWithFrame:CGRectMake(0,22,320,SCREENHEIGHT-300-42) style:UITableViewStylePlain];
    myTabView.dataSource=self;
    myTabView.delegate=self;
    myTabView.bounces=NO;
    myTabView.separatorStyle=UITableViewCellSeparatorStyleNone;
    myTabView.backgroundColor=[UIColor colorWithRed:242/255.f green:242/255.f blue:242/255.f alpha:1.0];
    [recommendView addSubview:myTabView];
    if ([[RootUrl getNetStatus]isEqualToString:@"4G/3G/2G"]) {
        UIAlertView *alert= [[UIAlertView alloc] initWithTitle:@"蜂窝网络" message:@"您使用的网络为蜂窝（4G/3G/2G）网络，播放视频将消耗较多流量！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil] ;
        [alert show];
    }
    
    [self laodContent];
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    JDownViewRequest=NO;
    jPlayRequestFlag=NO;
    isRotate=NO;
    goldRequestFlag=NO;
    flag=0;
    item=[self.itemArray objectAtIndex:self.inPages];
    self.view.backgroundColor=[UIColor blackColor];
    recommendArray=[[NSMutableArray alloc]initWithArray:self.itemArray];
    [recommendArray removeObjectAtIndex:self.inPages];
  
    
 
    [self creatAVPlayer];

    [self creatInfo];
    
    [self creatRecommentVedio];
    [self creatBottomView];
    
	// Do any additional setup after loading the view.
}
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    if (isPlaying) {
        [JayPlayer.player play];
        [playOrPause setNormalImage:[UIImage imageNamed:@"jaypause"]];
        [playOrPause setHighlightedImage:[UIImage imageNamed:@"jaypause_d"]];
        if ([myTimer isValid]) {
            [myTimer invalidate];
        }
        if (bottomToolView.isHidden)
        {
            [bottomToolView setHidden:NO];
            
        }
        myTimer=[NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(hiddenToolBar) userInfo:nil repeats:NO];
    }else{
    
        [JayPlayer.player pause];
        [playOrPause setNormalImage:[UIImage imageNamed:@"jayplay"]];
        [playOrPause setHighlightedImage:[UIImage imageNamed:@"jayplay_d"]];
        if ([myTimer isValid]) {
            [myTimer invalidate];
        }
        if (bottomToolView.isHidden)
        {
            [bottomToolView setHidden:NO];
            
        }
    }
      // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
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

    VedioItem *itemArt=[recommendArray objectAtIndex:indexPath.row];
    myCell.title.text=itemArt.vedioTitle;
    myCell.content.text=itemArt.vedioDescription.length>28?[itemArt.vedioDescription substringToIndex:28]:itemArt.vedioDescription;
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
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return recommendArray.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    item=[recommendArray objectAtIndex:indexPath.row];
    [recommendArray removeAllObjects];
    [recommendArray addObjectsFromArray:self.itemArray];
    [recommendArray removeObject:item];

    [self laodContent];
    
    [self playVideo];
    
 
    
}
-(void)downloadVideo{
    NSDictionary *dict = @{@"type" : @"press",@"name":item.vedioTitle};
    [MobClick event:@"video_down" attributes:dict];
    
    if (JDownViewRequest) {
        AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
        app.downManageIsIn=0;
        [app setNotice:@"数据准备中，请稍后再试！"];
    }else{
        jDownVideoRequest=[[RequestForLoginNet alloc]init];
        jDownVideoRequest.delegate=self;
        jDownVideoRequest.tag=9922;
        JDownViewRequest=YES;
        if ([item.vedioUrl hasPrefix:@"http"]) {
            [jDownVideoRequest requestFromUrl:[NSURL URLWithString:item.vedioUrl] andWithTimeoutInterval:2];
        }else{
        
            [jDownVideoRequest requestFromUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[RootUrl getContentUrl],item.vedioUrl]] andWithTimeoutInterval:2];
        }
  
    
    }
  


}
-(void)goShareVedio{
    if ([RootUrl getIsNetOn]) {

  
//    NSString *murl=[NSString stringWithFormat:@"%@%@",[RootUrl getRootUrl],item.contentIFilePath];
      NSString *murl=[NSString stringWithFormat:@"http://general.16wifi.com/%@",item.contentIFilePath];
    
        [UMSocialData defaultData].extConfig.wechatTimelineData.shareText=item.vedioTitle;
        [UMSocialData defaultData].extConfig.wechatSessionData.shareText=item.vedioTitle;
        [UMSocialData defaultData].extConfig.qzoneData.shareText=item.vedioTitle;
        [UMSocialData defaultData].extConfig.qqData.shareText=item.vedioTitle;
        [UMSocialData defaultData].extConfig.sinaData.shareText=item.vedioTitle;
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeVideo;
        [UMSocialData defaultData].extConfig.wechatSessionData.url = murl;
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = murl;
        [UMSocialData defaultData].extConfig.qzoneData.url = murl;
        [UMSocialData defaultData].extConfig.qqData.url = murl;
        [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeVideo url:murl];
        UIImage* image;
        if ([item.vedioImage hasPrefix:@"http"]) {
            image=[[SDWebImageManager sharedManager] imageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",item.vedioImage]]];
        }else{
            image=[[SDWebImageManager sharedManager] imageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[RootUrl getContentUrl],item.vedioImage]]];
            
        }

    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UMENG_APPKEY
                                      shareText:item.vedioTitle
                                     shareImage:image
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQzone,UMShareToQQ,UMShareToSina,nil]
                                       delegate:self];
        
        AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
        app.ShareContentId=[NSString stringWithFormat:@"%@",item.contentId];
        
    }else{
        UIAlertView *alterView=[[UIAlertView alloc]initWithTitle:nil message:@"当前网络不给力,请确认网络连接后重试" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [alterView show];
    }
    
    
}
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
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
            [app AddCoinRequestWithType:type ContentId:item.contentId UserId:[def objectForKey:@"userID"]CoinNum:@"2"];
            app.delegateView=self;
        }
    }
}
-(BOOL)isDirectShareInIconActionSheet{
    return YES;
}

-(void)currentTimeWith:(CMTime)currentTime andIsPlaying:(BOOL)playTag{
    [JayPlayer.player.currentItem addObserver:self forKeyPath:@"status"
                                      options:NSKeyValueObservingOptionNew
                                      context:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:JayPlayer.player.currentItem];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:)name:UIApplicationDidBecomeActiveNotification object:nil];

    CMTime cTime=CMTimeMake((currentTime.value/currentTime.timescale+1), 1);
    if (!playTag)
    {
       
        [playOrPause setNormalImage:[UIImage imageNamed:@"jayplay"]];
        [playOrPause setHighlightedImage:[UIImage imageNamed:@"jayplay_d"]];
     
        
    }
    else
    {
        [playOrPause setNormalImage:[UIImage imageNamed:@"jaypause"]];
        [playOrPause setHighlightedImage:[UIImage imageNamed:@"jaypause_d"]];
      
   
  
    }
    [JayPlayer.player seekToTime:cTime completionHandler:
     ^(BOOL finish)
     {
         if (playTag == YES)
         {
             [JayPlayer.player play];
             myTimer=[NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(hiddenToolBar) userInfo:nil repeats:NO];
         }else{
             [JayPlayer.player pause];
             [bottomToolView setHidden:NO];
         }
         [Moviebuffer stopAnimating];
         Moviebuffer.hidden = YES;
     }];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    if (goldRequestFlag) {
        [goldHttp cancel];
    }
    if (JDownViewRequest) {
        [jDownVideoRequest cancel];
    }
    if (jPlayRequestFlag) {
        [jPlayRequest cancel];
    }
    [MobClick endLogPageView:@"videoSubPage"];
}
-(void)viewWillAppear:(BOOL)animated{
   
    [MobClick beginLogPageView:@"videoSubPage"];
    self.tabBarController.tabBar.hidden=YES;
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)playVideo{
 
    NSDictionary *dict = @{@"type" :[NSString stringWithFormat:@"%@_在线",item.vedioTitle]};
    [MobClick event:@"video_play" attributes:dict];

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
    
    NSLog(@"subofVedio:%@",murl);
    
    if (![murl hasSuffix:@".mp4"]) {
        UIAlertView *myAlert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"您访问的视频文件已删除或损坏，请选择其他视频资源！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [myAlert show];
        return;
    }
    if (!jPlayRequestFlag) {
        jPlayRequest=[[RequestForLoginNet alloc]init];
        jPlayRequest.delegate=self;
        jPlayRequest.tag=9911;
        jPlayRequestFlag=YES;
        [jPlayRequest requestFromUrl:[NSURL URLWithString:murl] andWithTimeoutInterval:2];
        NSLog(@"验证开始");
    }else{
        NSLog(@"有其他验证进行中");
    }

}
-(void)startPlayVedio{


     NSLog(@"5playaaaaa");
    
    //player是视频播放的控制器，可以用来快进播放，暂停等
    flag=1;
    [JayPlayer.player play];
    [Moviebuffer setHidden:NO];
    [Moviebuffer startAnimating];
    isPlaying=YES;
    [JayPlayer.player.currentItem addObserver:self forKeyPath:@"status"
                                      options:NSKeyValueObservingOptionNew
                                      context:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:JayPlayer.player.currentItem];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:)name:UIApplicationDidBecomeActiveNotification object:nil];
    if (!IOS7)
    {
        //计算视频总时间
        CMTime totalTime = JayPlayer.player.currentItem.duration;
        //因为slider的值是小数，要转成float，当前时间和总时间相除才能得到小数,因为5/10=0
        totalMovieDuration = (CGFloat)totalTime.value/totalTime.timescale;
        
        NSDate *d = [NSDate dateWithTimeIntervalSince1970:totalMovieDuration];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        if (totalMovieDuration/3600 >= 1) {
            [formatter setDateFormat:@"HH:mm:ss"];
        }
        else
        {
            [formatter setDateFormat:@"mm:ss"];
        }
        NSString *showtimeNew = [formatter stringFromDate:d];
        NSLog(@"totalMovieDuration:%@",showtimeNew);
        //在totalTimeLabel上显示总时间
         durationLabel.text=[NSString stringWithFormat:@"%@/%@",[formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:0.f]],showtimeNew];
        
    }
    
    [JayPlayer.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:NULL usingBlock:^(CMTime time){
        //获取当前时间
        CMTime currentTime =JayPlayer.player.currentItem.currentTime;
        //转成秒数
        CGFloat currentPlayTime = (CGFloat)currentTime.value/currentTime.timescale;
        movieProgressSlider.value = currentPlayTime/totalMovieDuration;
        NSDate *d = [NSDate dateWithTimeIntervalSince1970:currentPlayTime];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        if (currentPlayTime/3600 >= 1) {
            [formatter setDateFormat:@"HH:mm:ss"];
        }
        else
        {
            [formatter setDateFormat:@"mm:ss"];
        }
        NSString *showtime = [formatter stringFromDate:d];
        durationLabel.text=[NSString stringWithFormat:@"%@/%@",showtime,[formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:totalMovieDuration]]];
    }];


}
-(void)forLoginRequestFaild:(RequestForLoginNet *)hd{
    if (hd.tag==9922) {
        JDownViewRequest=NO;
    }
    if (hd.tag==9911) {
        jPlayRequestFlag=NO;
    }
    NSLog(@"req complete");
}
-(void)forLoginReceiveResponse:(NSURLResponse *)response andWith:(RequestForLoginNet *)hd{
    if (hd.tag==9911) {
        
         NSLog(@"1aaaaa");
        
        if ([response.MIMEType isEqualToString:@"video/mp4"]) {
            jPlayRequestFlag=NO;
            [hd cancel];
            if (flag) {
                NSLog(@"2aaaaa");
                [playerLayer removeFromSuperlayer];
                [[NSNotificationCenter defaultCenter]removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:JayPlayer.player.currentItem];
                //释放掉对playItem的观察
                [JayPlayer.player.currentItem removeObserver:self
                                                  forKeyPath:@"status"
                                                     context:nil];
               
                [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];

            }
            AVPlayer *player = [AVPlayer playerWithPlayerItem:[AVPlayerItem playerItemWithURL:response.URL]];
            [JayPlayer setPlayer:player];
            playerLayer = [AVPlayerLayer playerLayerWithPlayer:JayPlayer.player];
            playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    
            [JayPlayer setPlayer:player];
            NSLog(@"3aaaaa");
            [self startPlayVedio];
            
            
        }else{
            UIAlertView *myAlert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"您访问的视频文件已删除或损坏，请选择其他视频资源！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [myAlert show];
            [hd cancel];
        }
        

    }
    if (hd.tag==9922) {
        if ([response.MIMEType isEqualToString:@"video/mp4"]) {
            JDownViewRequest=NO;
            [hd cancel];
            JAYDownload *downVideo=[[JAYDownload alloc]init];
            if ([item.vedioImage hasPrefix:@"http"]) {
                downVideo.videoImage=[[SDWebImageManager sharedManager] imageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",item.vedioImage]]];
            }else{
            
                downVideo.videoImage=[[SDWebImageManager sharedManager] imageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[RootUrl getContentUrl],item.vedioImage]]];
            }
    
            downVideo.vTime=item.vedioDuration;
            downVideo.vName=item.vedioTitle;
            downVideo.vLabel=item.vedioLabel;
            downVideo.vImage=item.vedioImage;
            [downVideo downloadFromUrl:response.URL];
            
            AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
            app.downManageIsIn=0;
            [app setNotice:[NSString stringWithFormat:@"已开始下载:%@",item.vedioTitle]];
        }else{
            UIAlertView *myAlert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"您访问的视频文件已删除或损坏，请选择其他视频资源！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [myAlert show];
            [hd cancel];
        }

       
    }
    
}
-(void)forLoginRequestComplete:(RequestForLoginNet *)hd{
    if (hd.tag==9922) {
       JDownViewRequest=NO;
    }
    if (hd.tag==9911) {
        jPlayRequestFlag=NO;
    }
    NSLog(@"req complete");
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
    [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(stopAnimat) userInfo:nil repeats:NO];
    [loadingAni startAnimating];
    loadingAni.center=aniBg.center;
    [aniBg addSubview:loadingAni];
    aniBg.center=CGPointMake(self.view.center.x, self.view.center.y+40);
    [self.view addSubview:aniBg];
    
}
-(void)startAnimat{
    [aniBg setHidden:NO];
    [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(stopAnimat) userInfo:nil repeats:NO];
    loadingAni.animationRepeatCount = 100000;

    [loadingAni startAnimating];
}
-(void)stopAnimat{
    [aniBg setHidden:YES];
   
    [loadingAni stopAnimating];
}
-(void)laodContent{

    videoTitle.text=item.vedioTitle;
    videoLabel.text=[NSString stringWithFormat:@"标签 : %@", item.vedioLabel];
    videoDuration.text=[NSString stringWithFormat:@"时长 : %@", item.vedioDuration];
    contentLabel.text=[NSString stringWithFormat:@"简介 : %@",item.vedioDescription];
    [myTabView reloadData];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"hhmmss"];
    
        goldRequestFlag=YES;
        if([item.gold intValue]){
            goldHttp=[[HttpDownload alloc]init];
            goldHttp.delegate=self;
            goldHttp.DFailed=@selector(downloadFailed:);
            goldHttp.DComplete=@selector(downloadComplete:);
            NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
            NSString *sign=[NSString stringWithFormat:@"con_video%@%@",item.contentId,[def objectForKey:@"userID"]];
            
            NSString *subUrl=[NSString stringWithFormat:@"mod=downtocredit&fid=con_video&gid=%@&uid=%@&amount=%@&sign=%@&ntime=%@",item.contentId,[def objectForKey:@"userID"],item.gold,[RootUrl md5:sign],[dateformatter stringFromDate:[NSDate date]]];
            
            NSData *secretData=[subUrl dataUsingEncoding:NSUTF8StringEncoding];
            NSData *qValueData=[secretData AES256EncryptWithKey:SECRETKEY];
            
            NSString *qValue=[qValueData newStringInBase64FromData];

            [goldHttp downloadFromUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@/app_api/credit/addCredit.html?q=%@",NewBaseUrl,qValue]]];
        }
    
}
-(void)downloadFailed:(HttpDownload *)hd{
    goldRequestFlag=NO;
}
-(void)downloadComplete:(HttpDownload *)hd{
        goldRequestFlag=NO;
        NSError *error = nil;
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:hd.mData options:NSJSONReadingAllowFragments error:&error];
        if (error!=nil) {
            NSLog(@"json解析失败32");
        }else{
            NSNumber *num=[dic objectForKey:@"ReturnCode"];
            NSLog(@"%@",dic);
            if ([num intValue]==200) {
                
                int aaa=[[dic objectForKey:@"amount"]intValue];
                if (aaa) {
                    UIImageView *goldBg=[[UIImageView alloc]initWithFrame:CGRectMake(132,SCREENHEIGHT, 56, 56)];
                    goldBg.tag=9090;
                    
                    goldBg.image=[UIImage imageNamed:@"round.png"];
                    [self.view addSubview:goldBg];
                    UILabel *goldLabel=[[UILabel alloc]initWithFrame:CGRectMake(5,18,43,20)];
                    goldLabel.backgroundColor=[UIColor clearColor];
                    goldLabel.textAlignment=NSTextAlignmentCenter;
                    goldLabel.textColor=[UIColor whiteColor];
                    if ([[dic objectForKey:@"amount"] integerValue]>=100) {
                        goldLabel.font=[UIFont boldSystemFontOfSize:14];
                    }else{
                        goldLabel.font=[UIFont boldSystemFontOfSize:17];
                    }
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
