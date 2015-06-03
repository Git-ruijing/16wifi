//
//  GM-PushInfoViewController.h
//  e-RoadWiFi
//
//  Created by QC on 14-9-9.
//  Copyright (c) 2014年 G.MING. All rights reserved.
//

#import "BasicViewController.h"
#import "YFJLeftSwipeDeleteTableView.h"
@interface GM_PushInfoViewController : BasicViewController<UITableViewDataSource,UIActionSheetDelegate,UITableViewDelegate,UIGestureRecognizerDelegate>
{

    NSArray *InforArr;
    YFJLeftSwipeDeleteTableView* dataTableView;
    NSMutableArray *pushInfo;
    NSString *temp;
    UILabel *subtitle;
}
@property (nonatomic,assign)NSInteger index;
@property (nonatomic,assign)NSInteger type;
@property(nonatomic,strong) NSMutableArray *push;
@property(nonatomic,strong) NSString *headTitle;
@end
