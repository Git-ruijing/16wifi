//
//  MyCoinBillViewController.h
//  e路WiFi
//
//  Created by JAY on 14-3-26.
//  Copyright (c) 2014年 HE ZHENJIE. All rights reserved.
//

#import "BasicViewController.h"
#import "CoinBillItem.h"
#import "MyButton.h"
#import "Encryption.h"
#define DEVICE_IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568)
#define SCREENHEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SIZEABOUTIOSVERSION ([[[UIDevice currentDevice] systemVersion] floatValue]<7.0?0:20)
#define IOSVERSIONSMALL ([[[UIDevice currentDevice] systemVersion] floatValue]<7.0?20:0)
@interface MyCoinBillViewController : BasicViewController<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>{
    NSMutableArray *billDataArray;
    UITableView *myTableView;
    UILabel *noticeLabel;
    UIImageView * aniBg;
    UIImageView *loadingAni;
    int flag;
    UILabel *loginOrCoinLable;
    UIImageView * loginOrCoin;
    BOOL BackClick;
    UIView *FailBgView;
}

@property(nonatomic,retain)NSString * myCoinNumber;
@property (nonatomic,strong)NSString *Type;
@property(nonatomic,readwrite)BOOL IsPresent;
@end

