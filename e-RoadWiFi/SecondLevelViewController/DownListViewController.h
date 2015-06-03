//
//  DownListViewController.h
//  e-RoadWiFi
//
//  Created by QC on 15/3/31.
//  Copyright (c) 2015年 G.MING. All rights reserved.
//

#import "BasicViewController.h"
#import "MyScroll.h"
#import "HttpDownLoad.h"
#import <StoreKit/StoreKit.h>
@interface DownListViewController : BasicViewController<UITableViewDataSource,SKStoreProductViewControllerDelegate,UITableViewDelegate,MyScrollPressDelegate>
{
    SKStoreProductViewController *storeProductVC;
        UITableView *tabView;
        NSMutableArray *AdvertiseArr;
        NSMutableArray *articlesArr;
        NSMutableArray *scrollTitle;
        MyScroll *myScrollView;
        UILabel *imageTitleLable;
        UIPageControl *pageCtr;
        int i;
        HttpDownload *mhd;
    int failImageFlag;
    UIView *failImageView;
    UIImageView *loadingAni;
    int flag;
    UIImageView *aniBg;

}
@property  (nonatomic,strong) NSString *HeadTitle;
@property (nonatomic,strong) NSString *IndexTag;
@property (nonatomic,strong) NSString *TypeStr;

@end
