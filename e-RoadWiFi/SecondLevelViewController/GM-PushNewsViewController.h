//
//  GM-PushNewsViewController.h
//  e-RoadWiFi
//
//  Created by QC on 14-9-9.
//  Copyright (c) 2014年 G.MING. All rights reserved.
//

#import "BasicViewController.h"
#import "YFJLeftSwipeDeleteTableView.h"
@interface GM_PushNewsViewController : BasicViewController<UIActionSheetDelegate, UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
{

    UIImageView *PushTips;
    UIView *bgview;
    NSMutableArray *pushInfo;
    NSMutableArray *noReadInfo;
    NSMutableArray *news;
    NSMutableArray *statistic;
    NSMutableArray *activity;
    NSMutableArray *notification;
    NSMutableArray *gift;
    
    YFJLeftSwipeDeleteTableView* dataTableView;
     NSMutableArray *push;
    NSMutableArray *allInfo;
    NSArray *titles;
    NSArray *headImage;
    
}
@property(nonatomic,readwrite)int isPush;
@end
