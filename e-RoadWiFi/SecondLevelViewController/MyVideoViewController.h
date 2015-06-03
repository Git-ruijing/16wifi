//
//  MyVideoViewController.h
//  e路WiFi
//
//  Created by JAY on 13-11-21.
//  Copyright (c) 2013年 HE ZHENJIE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyButton.h"
#import "MyDowningCell.h"
#import "MyVideoCell.h"
#import "YFJLeftSwipeDeleteTableView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "BusInquiryBar.h"
#import "JAYDownload.h"
#import "AppDelegate.h"
#import "PlayVedioViewController.h"
#define DEVICE_IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568)
#define SCREENHEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SIZEABOUTIOSVERSION ([[[UIDevice currentDevice] systemVersion] floatValue]<7.0?0:20)
#define IOSVERSIONSMALL ([[[UIDevice currentDevice] systemVersion] floatValue]<7.0?20:0)



@interface MyVideoViewController : UIViewController<JAYDownloadDelegate,BusInquiryBarDelegate,UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate>
{
    YFJLeftSwipeDeleteTableView *YFJtableView;
    YFJLeftSwipeDeleteTableView*  nomalTableView;
    UIImageView *loadingAni;
    UIImageView *aniBg;
    UIView* headerView;
    NSMutableArray *videoArr;
    int isPlay;
    MPMoviePlayerController *movie_Player;
    int DoneOrDoing;
}
@property(nonatomic,retain)NSString * channel;

@end
