//
//  MyOwnObjectViewController.h
//  e路WiFi
//
//  Created by JAY on 14-3-26.
//  Copyright (c) 2014年 HE ZHENJIE. All rights reserved.
//

#import "BasicViewController.h"
#import "MyButton.h"
#import "MyGoodsCell.h"
#import "MyTitleBarForMyGoods.h"
#import "HttpDownLoad.h"
#import "Encryption.h"
#define SECRETKEY @"ilovewififorfree"
#define DEVICE_IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568)
#define SCREENHEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SIZEABOUTIOSVERSION ([[[UIDevice currentDevice] systemVersion] floatValue]<7.0?0:20)
#define IOSVERSIONSMALL ([[[UIDevice currentDevice] systemVersion] floatValue]<7.0?20:0)
@interface MyOwnObjectViewController : BasicViewController<UITableViewDataSource,UITableViewDelegate,MyTitleBarForMyGoodsDelegate,UIGestureRecognizerDelegate>{
    UIImageView * aniBg;
    UIImageView *loadingAni;
    int flag;
    UITableView *myTableView;
    NSMutableArray *myGoodsDataArray;
    UIView * noDataBg;
    HttpDownload *mhd;
    int downloadflag;
}

@property(nonatomic,readwrite)BOOL IsRefresh;
@end

