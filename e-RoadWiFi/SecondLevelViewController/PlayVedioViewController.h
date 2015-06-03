//
//  PlayVedioViewController.h
//  e-RoadWiFi
//
//  Created by Jay on 14-11-19.
//  Copyright (c) 2014年 G.MING. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomPlayerView.h"
#import "MyButton.h"
#import "VedioItem.h"

#define NLSystemVersionGreaterOrEqualThan(version) ([[[UIDevice currentDevice] systemVersion] floatValue] >= version)
#define IOS7 NLSystemVersionGreaterOrEqualThan(7.0)

@protocol PlayVedioDelegate;
@interface PlayVedioViewController : UIViewController
{
    AVPlayerLayer *playerLayer;
    int a;
    UIView *headerToolView;
    UIView *bottomToolView;
    
    MyButton * playOrPause;
    NSTimer * myTimer;
    UIActivityIndicatorView *Moviebuffer;
    UISlider *movieProgressSlider;

    
    CGFloat  totalMovieDuration;
    CGFloat  currentDuration;
    UILabel *durationLabel;
    UILabel *currentTimeLabel;
    
    UIImageView *imageBg;
    NSTimer * vedioDownTimer;
    UIView * moveShow;
    UIImageView *moveImage;
    UILabel *movedurationLabel;
    UILabel *moveCurrentLabel;
    float x;
    float y;
    float volume;
}
@property(nonatomic,strong)NSString *vedioTitle;
@property(nonatomic,readwrite)float startTime;
@property(nonatomic,readwrite)BOOL isLocal;
@property(nonatomic,readwrite)BOOL isPlaying;
@property(nonatomic,copy)AVPlayerItem *JayPlayerItem;
@property (nonatomic,unsafe_unretained) id<PlayVedioDelegate> delegate;
@property (retain, nonatomic) CustomPlayerView *JayMoviePlayerController;
@end

@protocol PlayVedioDelegate
@optional
-(void)downloadVideo;
-(void)currentTimeWith:(CMTime)currentTime andIsPlaying:(BOOL)playTag;
@end
