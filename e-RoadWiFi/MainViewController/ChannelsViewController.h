//
//  ChannelsViewController.h
//  e-RoadWiFi
//
//  Created by QC on 14-8-1.
//  Copyright (c) 2014年 G.MING. All rights reserved.
//

#import "BasicViewController.h"
#import "AppDelegate.h"
#import "MyScroll.h"
#import "MyImageView.h"
@interface ChannelsViewController : BasicViewController<UIWebViewDelegate,UIScrollViewDelegate,loginNoticeDelegate>
{
        UIScrollView *MyScrollView;
    MyImageView *tipsView;
    UILabel *tipsLabel;
    UILabel *QdTimes;
    int FinishFlag;
    NSMutableArray *SignDateArray;
    NSArray *FristList;
    NSArray *SecondList;
    NSArray *ThridList;
    NSInteger NumOfList;
}

@end
