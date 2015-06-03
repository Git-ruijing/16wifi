//
//  VedioViewController.h
//  16wifipro
//
//  Created by JAY on 14-7-9.
//  Copyright (c) 2014年 HE ZHENJIE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HttpDownLoad.h"
#import "MyTitleScrollBar.h"
#define DEVICE_IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568)
@interface VedioViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,MyTitleScorllBarDelegate>{
    UIImageView * aniBg;
    UIImageView *loadingAni;
    NSMutableArray *ContentArr;
    int pflag;
    int isFirst;
    HttpDownload * mhd;
    int failImageFlag;
    UIView *failImageView;
}

@property(nonatomic,strong)UITableView *jTabView;

@end
