//
//  SubOfVedioViewController.h
//  16wifi2
//
//  Created by JAY on 13-5-10.
//  Copyright (c) 2013年 JAY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VedioItem.h"
#import "MyButton.h"
#import "JAYDownload.h"
#import "MyCellForVedio.h"
#import "HttpDownLoad.h"
#import "RequestForLoginNet.h"
#import "PlayVedioViewController.h"
#import "CustomPlayerView.h"
#import "UMSocial.h"
@interface SubOfVedioViewController : UIViewController<UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate,RequestForLoginNetDelegate,PlayVedioDelegate,UMSocialUIDelegate>{
    UIImageView *loadingAni;
    UIImageView *aniBg;
    VedioItem *item;
    UIScrollView *scrollView;

    UILabel *videoDuration;
    UILabel*videoLabel;
    UILabel *videoTitle;
    UILabel *contentLabel;
    UITableView *myTabView;
    MyButton *playButton;
    MyButton *downloadButton;
    NSMutableArray *recommendArray;
    UILabel *c1;
    UILabel *c2;
    int flag;
    NSURL *url;
    UIView *bottomView;
    UIView *infoView;
    UIView *recommendView;
    MyButton * goForward;
    AVPlayerLayer *playerLayer;
       
    BOOL isRotate;
    
    BOOL isPlaying;
    CustomPlayerView *JayPlayer;
    
    UIView *bottomToolView;
    
    NSTimer * myTimer;
    MyButton * playOrPause;
    UIActivityIndicatorView *Moviebuffer;
    UISlider *movieProgressSlider;
    CGFloat  totalMovieDuration;
    CGFloat  currentDuration;
    UILabel *durationLabel;
    
    RequestForLoginNet *jDownVideoRequest;
    BOOL JDownViewRequest;
    RequestForLoginNet *jPlayRequest;
    BOOL jPlayRequestFlag;
    

    BOOL goldRequestFlag;
    HttpDownload *goldHttp;
}

@property(nonatomic,strong)NSArray *itemArray;
@property(nonatomic,readwrite)int channel;
@property int inPages;
@property(nonatomic,strong)NSURL *vedioUrl;
@end
