//
//  FriendsInforViewController.h
//  e-RoadWiFi
//
//  Created by MacMini on 15/4/27.
//  Copyright (c) 2015年 G.MING. All rights reserved.
//

#import "BasicViewController.h"

@interface FriendsInforViewController : BasicViewController
{

        UIScrollView *_scrollerView;
    
}

@property(nonatomic,strong)NSMutableDictionary *DataDic;
@property(nonatomic,assign)BOOL Refresh;

@end
