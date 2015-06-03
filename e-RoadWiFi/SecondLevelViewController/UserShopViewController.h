//
//  UserShopViewController.h
//  e路WiFi
//
//  Created by JAY on 3/17/14.
//  Copyright (c) 2014 HE ZHENJIE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyButton.h"
#import "HttpDownLoad.h"
#import "PullPsCollectionView.h"
#import "CellView.h"
#import "JAYBannersScroll.h"
#import "MobClick.h"
#import "GoodsItem.h"
#import "LoginViewController.h"
#import "GoodsDetailViewController.h"
#import "MyCoinBillViewController.h"
#import "MyOwnObjectViewController.h"
#define DEVICE_IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568)
#define SCREENHEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SIZEABOUTIOSVERSION ([[[UIDevice currentDevice] systemVersion] floatValue]<7.0?0:20)
#define IOSVERSIONSMALL ([[[UIDevice currentDevice] systemVersion] floatValue]<7.0?20:0)
@interface UserShopViewController : UIViewController<PSCollectionViewDataSource,PSCollectionViewDelegate,UIGestureRecognizerDelegate,UIScrollViewDelegate,JAYBannersScrollDelegate,loginNoticeDelegate>
{
    NSMutableArray * goodsItemArray;
    NSMutableArray *scrollImageDataArray;
    UIPageControl *pageCtr;
    int flag;
    UIView *failImageView;
    int failImageFlag;
    UIImageView *loadingAni;
    UIImageView *aniBg;
    UIImageView *bannerScrollBg;
    JAYBannersScroll *myScrollView;
    NSString *coinNumber;
    int i;
    UIView *myOwnBg;
    HttpDownload *banderHd;
    int banderHdFlag;
    HttpDownload *goodsDataHd;
    int goodsDataHdFlag;
    MyButton *loginButton;
    MyButton *moreButton;
    UILabel *loginOrCoinLable;
    UIImageView *loginOrCoin;
    UILabel * mark;
    UILabel * getMoreCoinLabel;
    UIImageView *arrowImage;
    MyButton *getMoreCoinButton;
    int showMyOwnFlag;
}
@property (nonatomic, retain)PullPsCollectionView* collectionView;
@property (nonatomic, readwrite)int login;
@end
