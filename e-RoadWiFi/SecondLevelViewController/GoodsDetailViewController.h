//
//  GoodsDetailViewController.h
//  e路WiFi
//
//  Created by JAY on 14-3-26.
//  Copyright (c) 2014年 HE ZHENJIE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyButton.h"
#import "GoodsItem.h"
#import "HttpDownLoad.h"
#import "Encryption.h"
#define SECRETKEY @"ilovewififorfree"
#import "MyOwnObjectViewController.h"
#define DEVICE_IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568)
#define SCREENHEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SIZEABOUTIOSVERSION ([[[UIDevice currentDevice] systemVersion] floatValue]<7.0?0:20)
#define IOSVERSIONSMALL ([[[UIDevice currentDevice] systemVersion] floatValue]<7.0?20:0)
@interface GoodsDetailViewController : UIViewController<UIGestureRecognizerDelegate>{
    UIImageView * aniBg;
    UIImageView *loadingAni;
    int flag;
    UILabel *noticeLabel;
    UILabel * lingqudizhi;
    MyButton *getGoodsButton;
}
@property(nonatomic,retain)GoodsItem *goodsItem;
@property(nonatomic,readwrite)int isGet;
@property(nonatomic,strong)NSString * GoodsStatus;
@property(nonatomic,strong)NSString * Type;
@property(nonatomic,strong)MyOwnObjectViewController * MyObj;

@end
