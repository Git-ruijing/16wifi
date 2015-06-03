//
//  PlayVedioViewController.m
//  e-RoadWiFi
//
//  Created by Jay on 14-11-19.
//  Copyright (c) 2014年 G.MING. All rights reserved.
//

#import "PlayVedioViewController.h"
#import "RootUrl.h"
#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "MobClick.h"
#define SCREENHEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREENWIDTH ([[UIScreen mainScreen] bounds].size.width)
#define IOSVERSION6BIG ([[[UIDevice currentDevice] systemVersion] floatValue]<7.0?20:0)
#define IOSVERSION6SMALL ([[[UIDevice currentDevice] systemVersion] floatValue]<7.0?(-20):0)
@interface PlayVedioViewController ()

@end
@implementation PlayVedioViewController
@synthesize JayMoviePlayerController,vedioTitle,startTime,JayPlayerItem,isPlaying;
- (BOOL)shouldAutorotate
{
    return NO;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeRight;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeRight;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.view];
    NSLog(@"began %f==%f",touchPoint.x,touchPoint.y);
    x = (touchPoint.x);
    y = (touchPoint.y);
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.view];
    NSLog(@"moved:%f==%f",touchPoint.x,touchPoint.y);
    if ((touchPoint.x - x) >= 50 && (touchPoint.y - y) <= 20 && (touchPoint.y - y) >= -20)
    {
        NSLog(@"快进");
        [moveShow setHidden:NO];
        [moveImage setImage:[UIImage imageNamed:@"Jaymovespeed"]];
        movedurationLabel.text=[NSString stringWithFormat:@"/%@",[self getTimeString:totalMovieDuration]];
        float aaa=(touchPoint.x-x)/SCREENHEIGHT;
        CMTime currentTime =JayMoviePlayerController.player.currentItem.currentTime;
        CGFloat currentPlayTime = (CGFloat)currentTime.value/currentTime.timescale;

        
        CGFloat durationPerUnit=totalMovieDuration>60?(totalMovieDuration<420?60:(totalMovieDuration*0.15)):totalMovieDuration;
    
        moveCurrentLabel.text= [NSString stringWithFormat:@"%@",[self getTimeString:(currentPlayTime+aaa*durationPerUnit)]];
        
        return;
       
    }
    if ((x - touchPoint.x) >= 50 && (touchPoint.y - y) <= 50 && (touchPoint.y - y) >= -50)
    {
        NSLog(@"快退");
        [moveShow setHidden:NO];
        [moveImage setImage:[UIImage imageNamed:@"Jaymoveback"]];
        movedurationLabel.text=[NSString stringWithFormat:@"/%@",[self getTimeString:totalMovieDuration]];
        float aaa=(x-touchPoint.x)/SCREENHEIGHT;
        CMTime currentTime =JayMoviePlayerController.player.currentItem.currentTime;
        CGFloat currentPlayTime = (CGFloat)currentTime.value/currentTime.timescale;
        
        
        CGFloat durationPerUnit=totalMovieDuration>60?(totalMovieDuration<420?60:(totalMovieDuration*0.15)):totalMovieDuration;
        
        moveCurrentLabel.text= [NSString stringWithFormat:@"%@",[self getTimeString:(currentPlayTime-aaa*durationPerUnit)]];
        return;
    }
    if (moveShow.isHidden==NO) {
        [moveShow setHidden:YES];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.view];
    NSLog(@"end %f==%f",touchPoint.x,touchPoint.y);
    if (moveShow.isHidden==NO) {
        [moveShow setHidden:YES];
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication]setStatusBarHidden:NO];
  
    [self.view setBackgroundColor:[UIColor blackColor]];
    if (!IOS7) {
        [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
        UIView * iOS6BlackBg=[[UIView alloc]initWithFrame:CGRectMake(0, -200,SCREENHEIGHT,200)];
        iOS6BlackBg.backgroundColor=[UIColor blackColor];
        [self.view addSubview:iOS6BlackBg];
     
    }
    
    JayMoviePlayerController=[[CustomPlayerView alloc]initWithFrame:CGRectMake(0,IOSVERSION6SMALL,SCREENHEIGHT,SCREENWIDTH)];
    
    
   
    
    [self.view addSubview:JayMoviePlayerController];

    moveShow=[[UIView alloc]initWithFrame:CGRectMake(SCREENHEIGHT/2-60, SCREENWIDTH/2-60, 120, 120)];
    CALayer *lay  = moveShow.layer;//获取层
    [lay setMasksToBounds:YES];
    [lay setCornerRadius:10];
    moveShow.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    
    moveImage=[[UIImageView alloc]initWithFrame:CGRectMake(30, 30, 61, 35)];
    moveImage.image=[UIImage imageNamed:@"Jaymoveback"];
    [moveShow addSubview:moveImage];
    moveCurrentLabel=[[UILabel alloc]initWithFrame:CGRectMake(5,90,53,20)];
    moveCurrentLabel.text=@"00:00:00";
    moveCurrentLabel.backgroundColor=[UIColor clearColor];
    moveCurrentLabel.textAlignment=NSTextAlignmentRight;
    moveCurrentLabel.textColor=[UIColor colorWithRed:0/255.f green:172/255.f blue:238/255.f alpha:1.f];
    moveCurrentLabel.font=[UIFont systemFontOfSize:13];
    movedurationLabel=[[UILabel alloc]initWithFrame:CGRectMake(58,90,58,20)];
    movedurationLabel.textAlignment=NSTextAlignmentLeft;
    movedurationLabel.textColor=[UIColor whiteColor];
    movedurationLabel.font=[UIFont systemFontOfSize:13];
    movedurationLabel.backgroundColor=[UIColor clearColor];
    movedurationLabel.text=@"/00:00:00";
    [moveShow addSubview:moveCurrentLabel];
    [moveShow addSubview:movedurationLabel];
    [moveShow setHidden:YES];
    [self.view addSubview:moveShow];
    
    //player是视频播放的控制器，可以用来快进播放，暂停等
    AVPlayer *player = [AVPlayer playerWithPlayerItem:JayPlayerItem];

    
    playerLayer = [AVPlayerLayer playerLayerWithPlayer:JayMoviePlayerController.player];
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [JayMoviePlayerController setPlayer:player];
    
    JayMoviePlayerController.delegate = self;
    UITapGestureRecognizer *oneTap=nil;
    oneTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(oneTap:)];
    oneTap.numberOfTapsRequired = 1;
    [JayMoviePlayerController addGestureRecognizer:oneTap];
   [self createToolBar];
    
   [JayMoviePlayerController.player play];
 

    
    
    
    //检测视频加载状态，加载完成隐藏风火轮
    [JayMoviePlayerController.player.currentItem addObserver:self forKeyPath:@"status"
                                                           options:NSKeyValueObservingOptionNew
                                                           context:nil];

    
    //添加视频播放完成的notifation
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:JayMoviePlayerController.player.currentItem];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:)name:UIApplicationDidBecomeActiveNotification object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:)name:UIApplicationWillResignActiveNotification object:nil];
    imageBg=[[UIImageView alloc]initWithFrame:CGRectMake(SCREENHEIGHT/2-45, SCREENWIDTH/2+50, 85, 26)];
    imageBg.image=[[UIImage imageNamed:@"tishi.png"]stretchableImageWithLeftCapWidth:10 topCapHeight:5];
    [imageBg setAlpha:0.85];
    UILabel *notice=[[UILabel alloc]initWithFrame:CGRectMake(5, 1,75, 20)];
    notice.backgroundColor=[UIColor clearColor];
    notice.textAlignment=NSTextAlignmentCenter;
    notice.font=[UIFont systemFontOfSize:13];
    notice.textColor=[UIColor whiteColor];
    [imageBg addSubview:notice];
    notice.text=@"已开始下载！";
    [self.view addSubview:imageBg];
    [imageBg setHidden:YES];
    // Do any additional setup after loading the view.
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    
    
    [JayMoviePlayerController.player pause];
    isPlaying=NO;
    
}
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    if (isPlaying) {
        [JayMoviePlayerController.player play];
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
        
        [JayMoviePlayerController.player pause];
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
}
-(void)moviePlayDidEnd:(NSNotification*)notification{
    //视频播放完成
    isPlaying=NO;
    [JayMoviePlayerController.player pause];
    [[UIApplication sharedApplication]setStatusBarHidden:NO];
    if ([vedioDownTimer isValid]) {
        [vedioDownTimer invalidate];
    }
    if ([myTimer isValid]) {
        [myTimer invalidate];
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.isLocal==NO) {
            [self.delegate currentTimeWith:JayMoviePlayerController.player.currentItem.duration andIsPlaying:NO];
        }
        
    }];
    NSLog(@"播放完成");
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItem *playerItem = (AVPlayerItem*)object;
        if (playerItem.status==AVPlayerStatusReadyToPlay) {
            //视频加载完成
            
            [[UIApplication sharedApplication]setStatusBarHidden:NO];
            [JayMoviePlayerController.player seekToTime:CMTimeMake(startTime+1, 1) completionHandler:
             ^(BOOL finish)
             {
                 [Moviebuffer stopAnimating];
                 Moviebuffer.hidden = YES;
                 if ([myTimer isValid]) {
                     [myTimer invalidate];
                 }
                 if (headerToolView.isHidden)
                 {
                     [self showToolBar];
                     
                 }
                 if (isPlaying == YES)
                 {
                     [JayMoviePlayerController.player play];
                     myTimer=[NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(hiddenToolBar) userInfo:nil repeats:NO];
                 }else{
                     [JayMoviePlayerController.player pause];
                     [playOrPause setNormalImage:[UIImage imageNamed:@"jayplay"]];
                     [playOrPause setHighlightedImage:[UIImage imageNamed:@"jayplay_d"]];
                 }
                 
                 
                 
             }];
       
            if (IOS7)
            {
                //计算视频总时间
                CMTime totalTime = playerItem.duration;
                totalMovieDuration = (CGFloat)totalTime.value/totalTime.timescale;
              
                durationLabel.text = [self getTimeString:totalMovieDuration];
            }
        }
    }

    
}

- (void) oneTap:(UITapGestureRecognizer *)sender
{
    if ([myTimer isValid]) {
        [myTimer invalidate];
    }
    if (headerToolView.isHidden)
    {
        [self showToolBar];
        myTimer=[NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(hiddenToolBar) userInfo:nil repeats:NO];
    }else{
        [self hiddenToolBar];
    }

}
-(void)hiddenToolBar{

    [[UIApplication sharedApplication]setStatusBarHidden:YES];
    headerToolView.hidden=YES;
    bottomToolView.hidden=YES;
}
-(void)showToolBar{
    [[UIApplication sharedApplication]setStatusBarHidden:NO];
   
    headerToolView.hidden=NO;
    bottomToolView.hidden=NO;
}
-(void)createToolBar{

    headerToolView=[[UIView alloc]initWithFrame:CGRectMake(0,IOSVERSION6SMALL,SCREENHEIGHT, 56)];
    headerToolView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    [self.view addSubview:headerToolView];
   
    MyButton *backButton=[MyButton buttonWithType:UIButtonTypeCustom];
    
   
    backButton.frame=CGRectMake(0,20,52, 32);
    
    
    [backButton setNormalImage:[UIImage imageNamed:@"jayback"]];
    [backButton setHighlightedImage:[UIImage imageNamed:@"jayback_d"]];
    [headerToolView addSubview:backButton];
    [backButton addTarget:self action:@selector(goBackToFront)];
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(60, 20,SCREENHEIGHT-160, 30)];
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.font=[UIFont systemFontOfSize:17];
    titleLabel.textAlignment=NSTextAlignmentLeft;
    titleLabel.textColor=[UIColor whiteColor];
    [headerToolView addSubview:titleLabel];
    titleLabel.text=vedioTitle;
    
    if (self.isLocal==NO) {
        MyButton *downloadButton=[MyButton buttonWithType:UIButtonTypeCustom];
        
        downloadButton.frame=CGRectMake(SCREENHEIGHT-57,20,52, 32);
        
        
        [downloadButton setNormalImage:[UIImage imageNamed:@"jaydownload"]];
        [downloadButton setHighlightedImage:[UIImage imageNamed:@"jaydownload_d"]];
        [headerToolView addSubview:downloadButton];
        [downloadButton addTarget:self action:@selector(goDownLoadVedio)];
    }




    bottomToolView=[[UIView alloc]initWithFrame:CGRectMake(0,SCREENWIDTH-50-IOSVERSION6BIG,SCREENHEIGHT,50)];
    bottomToolView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    [self.view addSubview:bottomToolView];
    
    playOrPause=[MyButton buttonWithType:UIButtonTypeCustom];
    playOrPause.frame=CGRectMake(0,0, 65, 52);
    if (isPlaying) {
        [playOrPause setNormalImage:[UIImage imageNamed:@"jaypause"]];
        [playOrPause setHighlightedImage:[UIImage imageNamed:@"jaypause_d"]];
    }else{
        [playOrPause setNormalImage:[UIImage imageNamed:@"jayplay"]];
        [playOrPause setHighlightedImage:[UIImage imageNamed:@"jayplay_d"]];
    }
    
    [playOrPause addTarget:self action:@selector(PlayOrPause)];
    [bottomToolView addSubview:playOrPause];

    Moviebuffer=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(SCREENHEIGHT/2-25,SCREENWIDTH/2-20, 50, 40)];
    CALayer *lay  = Moviebuffer.layer;//获取层
    [lay setMasksToBounds:YES];
    [lay setCornerRadius:10];
    Moviebuffer.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    [self.view addSubview:Moviebuffer];
    [Moviebuffer startAnimating];

 

    durationLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREENHEIGHT-60,15,45,20)];
    durationLabel.textAlignment=NSTextAlignmentRight;
    durationLabel.backgroundColor=[UIColor clearColor];
    durationLabel.textColor=[UIColor colorWithRed:153/255.f green:153/255.f blue:153/255.f alpha:1.f];
    durationLabel.font=[UIFont systemFontOfSize:10];
    [bottomToolView addSubview:durationLabel];
    currentTimeLabel=[[UILabel alloc]initWithFrame:CGRectMake(45,15,45,20)];
    currentTimeLabel.textAlignment=NSTextAlignmentRight;
    currentTimeLabel.backgroundColor=[UIColor clearColor];
    currentTimeLabel.textColor=[UIColor colorWithRed:153/255.f green:153/255.f blue:153/255.f alpha:1.f];
    
    currentTimeLabel.font=[UIFont systemFontOfSize:10];
    [bottomToolView addSubview:currentTimeLabel];
    if (!IOS7)
    {
        //计算视频总时间
     
        
        CMTime totalTime = JayPlayerItem.duration;
        //因为slider的值是小数，要转成float，当前时间和总时间相除才能得到小数,因为5/10=0
        totalMovieDuration = (CGFloat)totalTime.value/totalTime.timescale;
        
    
        //在totalTimeLabel上显示总时间
        durationLabel.text= [self getTimeString:totalMovieDuration];
        currentTimeLabel.text=[self getTimeString:0];
    }

    
    

    
    movieProgressSlider=[[UISlider alloc]initWithFrame:CGRectMake(95, 15,SCREENHEIGHT-155 ,20)];
    movieProgressSlider.backgroundColor=[UIColor clearColor];
    [movieProgressSlider setThumbImage:[UIImage imageNamed:@"thumb"] forState:UIControlStateNormal];
    [movieProgressSlider setMinimumTrackTintColor:[UIColor colorWithRed:0/255.f green:172/255.f blue:238/255.f alpha:1.f]];
    [movieProgressSlider setMaximumTrackTintColor:[UIColor whiteColor]];
    

    [movieProgressSlider addTarget:self action:@selector(scrubbingDidBegin) forControlEvents:UIControlEventTouchDown];
    [movieProgressSlider addTarget:self action:@selector(scrubberIsScrolling) forControlEvents:UIControlEventValueChanged];
    [movieProgressSlider addTarget:self action:@selector(scrubbingDidEnd) forControlEvents:(UIControlEventTouchUpInside | UIControlEventTouchCancel)];
    [bottomToolView addSubview:movieProgressSlider];
    
    
    [JayMoviePlayerController.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:NULL usingBlock:^(CMTime time){
        //获取当前时间
        CMTime currentTime =JayMoviePlayerController.player.currentItem.currentTime;
        //转成秒数
        CGFloat currentPlayTime = (CGFloat)currentTime.value/currentTime.timescale;
        movieProgressSlider.value = currentPlayTime/totalMovieDuration;

        currentTimeLabel.text =[self getTimeString:(int)currentPlayTime];
    }];
    [[UIApplication sharedApplication]setStatusBarHidden:NO];

}
-(NSString *)getTimeString:(int)time{
   
    return time > 3600 ? [NSString stringWithFormat:@"%0.2d:%0.2d:%0.2d",time/3600,time/60,time%60]:[NSString stringWithFormat:@"%0.2d:%0.2d",time/60,time%60];

}
- (void) TouchspeedWithChange:(float)change{
    NSLog(@"快进：%f",change);
    if (![moveShow isHidden]) {
        [moveShow setHidden:YES];
    }
    float aaa=change/SCREENHEIGHT;
    CMTime currentTime =JayMoviePlayerController.player.currentItem.currentTime;
    CGFloat currentPlayTime = (CGFloat)currentTime.value/currentTime.timescale;
    

    float durationPerUnit=totalMovieDuration>60?(totalMovieDuration<420?60:(totalMovieDuration*0.15)):totalMovieDuration;
    movieProgressSlider.value=(currentPlayTime+aaa*durationPerUnit)/totalMovieDuration;
    
    
    CMTime dragedCMTime = CMTimeMake(currentPlayTime+aaa*durationPerUnit, 1);
    [Moviebuffer startAnimating];
    Moviebuffer.hidden = NO;
    if ([myTimer isValid]) {
        [myTimer invalidate];
    }
    if (headerToolView.isHidden)
    {
        [self showToolBar];
        
    }
    
    [JayMoviePlayerController.player seekToTime:dragedCMTime completionHandler:
     ^(BOOL finish)
     {
         if (isPlaying == YES)
         {
             [JayMoviePlayerController.player play];
         }
        myTimer=[NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(hiddenToolBar) userInfo:nil repeats:NO];
         [Moviebuffer stopAnimating];
         Moviebuffer.hidden = YES;
       
     }];


}
- (void) TouchretreatWithChange:(float)change{
    NSLog(@"快退：%f",change);
    if (![moveShow isHidden]) {
        [moveShow setHidden:YES];
    }
    float aaa=change/SCREENHEIGHT;
    CMTime currentTime =JayMoviePlayerController.player.currentItem.currentTime;
    CGFloat currentPlayTime = (CGFloat)currentTime.value/currentTime.timescale;
    
    
    float durationPerUnit=totalMovieDuration>60?(totalMovieDuration<420?60:(totalMovieDuration*0.15)):totalMovieDuration;
    movieProgressSlider.value=(currentPlayTime-aaa*durationPerUnit)/totalMovieDuration;
    
    
    CMTime dragedCMTime = CMTimeMake(currentPlayTime-aaa*durationPerUnit, 1);
    [Moviebuffer startAnimating];
    Moviebuffer.hidden = NO;
    if ([myTimer isValid]) {
        [myTimer invalidate];
    }
    if (headerToolView.isHidden)
    {
        [self showToolBar];
        
    }
    
    [JayMoviePlayerController.player seekToTime:dragedCMTime completionHandler:
     ^(BOOL finish)
     {
         if (isPlaying == YES)
         {
             [JayMoviePlayerController.player play];
         }
         myTimer=[NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(hiddenToolBar) userInfo:nil repeats:NO];
         [Moviebuffer stopAnimating];
         Moviebuffer.hidden = YES;
         
     }];
}
-(void)scrubbingDidBegin{
    if ([myTimer isValid]) {
        [myTimer invalidate];
    }
    if (headerToolView.isHidden)
    {
        [self showToolBar];
     
    }
    [JayMoviePlayerController.player pause];
    NSLog(@"滑竿开始滑动");
}
-(void)scrubberIsScrolling{
    
    double currentTime = floor(totalMovieDuration *movieProgressSlider.value);
    //转换成CMTime才能给player来控制播放进度
    CMTime dragedCMTime = CMTimeMake(currentTime, 1);
    [JayMoviePlayerController.player seekToTime:dragedCMTime completionHandler:
     ^(BOOL finish)
     {
         if (isPlaying == YES)
         {
             [JayMoviePlayerController.player play];
         }
         [Moviebuffer stopAnimating];
         Moviebuffer.hidden = YES;
     }];

   NSLog(@"滑竿正在滑动");
}
-(void)viewWillAppear:(BOOL)animated{

 
    [MobClick beginLogPageView:@"PlayVedio"];
}
-(void)viewDidDisappear:(BOOL)animated{
    [MobClick endLogPageView:@"PlayVedio"];

}
-(void)scrubbingDidEnd{
    Moviebuffer.hidden=NO;
    [Moviebuffer startAnimating];
 
    if ([myTimer isValid]) {
        [myTimer invalidate];
    }
    myTimer=[NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(hiddenToolBar) userInfo:nil repeats:NO];
    NSLog(@"滑竿结束滑动");
}
- (void)PlayOrPause{
    if (isPlaying == YES)
    {
        [JayMoviePlayerController.player pause];
        [playOrPause setNormalImage:[UIImage imageNamed:@"jayplay"]];
        [playOrPause setHighlightedImage:[UIImage imageNamed:@"jayplay_d"]];
        if ([myTimer isValid]) {
            [myTimer invalidate];
        }
        [self showToolBar];
        isPlaying = NO;
    }
    else
    {
        [JayMoviePlayerController.player play];
        [playOrPause setNormalImage:[UIImage imageNamed:@"jaypause"]];
        [playOrPause setHighlightedImage:[UIImage imageNamed:@"jaypause_d"]];
        if ([myTimer isValid]) {
            [myTimer invalidate];
        }
        [self showToolBar];
        myTimer=[NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(hiddenToolBar) userInfo:nil repeats:NO];

        isPlaying = YES;
    }
}

-(void)goDownLoadVedio{
    

    [imageBg setHidden:NO];
    vedioDownTimer=[NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(hiddenDownNotice) userInfo:nil repeats:NO];

    [self.delegate downloadVideo];
}
-(void)hiddenDownNotice{
    [imageBg setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)goBackToFront{
    [JayMoviePlayerController.player pause];
    [[UIApplication sharedApplication]setStatusBarHidden:NO];
    if ([vedioDownTimer isValid]) {
        [vedioDownTimer invalidate];
    }
    if ([myTimer isValid]) {
        [myTimer invalidate];
    }

    [playerLayer removeFromSuperlayer];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:JayMoviePlayerController.player.currentItem];
    //释放掉对playItem的观察
    [JayMoviePlayerController.player.currentItem removeObserver:self
                                      forKeyPath:@"status"
                                         context:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.isLocal==NO) {
            [self.delegate currentTimeWith:JayMoviePlayerController.player.currentItem.currentTime andIsPlaying:isPlaying];
        }
        
    }];
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
