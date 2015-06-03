//
//  NewsChannelViewController.h
//  e路WiFi
//
//  Created by JAY on 13-12-26.
//  Copyright (c) 2013年 HE ZHENJIE. All rights reserved.
//
#import "BasicViewController.h"
#import "MyScorllBar.h"
#import "MyScroll.h"
#import "HttpDownLoad.h"
#import "MobClick.h"
#import "LoadMoreTableFooterView.h"

@interface NewsChannelViewController : BasicViewController<UIGestureRecognizerDelegate,MyScorllBarDelegate,MyScrollPressDelegate,UITableViewDataSource,UITableViewDelegate,LoadMoreTableFooterDelegate>
{
    HttpDownload *mhd;
    UITableView *tabView;
    UILabel *imageTitleLable;
    UIPageControl *pageCtr;
    
    NSMutableArray *AdvertiseArr;
    NSMutableArray *articlesArr;
    NSMutableArray *scrollTitle;
    NSMutableArray *SubChannels;
    MyScroll *myScrollView;
    
    int channelIsIn;
    int downloadflag;
    int isReDian;
    int i;
    int failImageFlag;
    UIView *failImageView;
    UIImageView *loadingAni;
    int flag;
    UIImageView *aniBg;
    
    LoadMoreTableFooterView *_loadMoreRefreshView;
    BOOL _isRefreshing;
    NSTimer *timer;
    CGPoint  Offset;
    BOOL needLoadMore;
}
@property(nonatomic ,readwrite)int isPush;
@end
