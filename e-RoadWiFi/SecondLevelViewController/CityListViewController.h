//
//  CityListViewController.h
//  e-RoadWiFi
//
//  Created by QC on 14-10-16.
//  Copyright (c) 2014年 G.MING. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HttpDownLoad.h"
#import "Encryption.h"
@interface CityListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    HttpDownload *update;
    UILabel *noticeLabel;
}
@property (nonatomic, strong) NSMutableDictionary *cities;
@property (nonatomic, strong) NSMutableArray *keys;
@property (nonatomic, strong) NSMutableArray *arrayCitys;
@property (nonatomic, strong) NSMutableArray *arrayHotCity;
@property(nonatomic,strong)UITableView *tableView;

@end
