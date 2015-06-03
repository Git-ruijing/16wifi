//
//  RecommendViewController.h
//  e-RoadWiFi
//
//  Created by QC on 14-8-1.
//  Copyright (c) 2014年 G.MING. All rights reserved.
//

#import "BasicViewController.h"
#import "RootUrl.h"
#import "AppDelegate.h"
#import "MyImageView.h"
#import "UMUFPHandleView.h"
#import "BusInquiryBar.h"
@interface RecommendViewController : BasicViewController<UITableViewDataSource,UITableViewDelegate,BusInquiryBarDelegate,UIGestureRecognizerDelegate,UISearchBarDelegate,UIAlertViewDelegate>
{

    UITableView *dataTableView;
    UISearchBar *MySearchBar;
    NSMutableArray*_CurrentArray;
    UIView *TabHeadView;
    NSArray *headArray;
    NSMutableArray *QCArray;
    NSMutableArray *AdDataArray;
    BOOL isOpen;
    BOOL isRefresh;
    NSMutableArray *testArray;
    UIView *view;
    NSMutableArray *historyArray;
    UIView *recent;
    NSInteger rowCount;

    UMUFPHandleView *handleView;
    NSMutableArray *AppArray;
    NSMutableArray *IosApp;
    UIView *bgHandle;
    MyImageView *shop;
    MyImageView*tipsImage;
    UILabel *tipsLabel;
    NSArray *LocalApp;
    BOOL isFinished;
    BOOL canOpen;
    BOOL NeedRefresh;
    BOOL RefHisList;
    BOOL AppLoadFailed;
    BOOL RefreshAppIcon;
    UIView *FristView;
    UIView *SecondView;
    BOOL IsFristView;
    UIScrollView *myScrollView;
    BusInquiryBar* busBar;
    UIPageControl *pageControl;
    UIScrollView *bgScrollView;
    BOOL isPassed;
}
@end
