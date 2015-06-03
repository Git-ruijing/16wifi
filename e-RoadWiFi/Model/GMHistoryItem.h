//
//  GMHistoryItem.h
//  e-RoadWiFi
//
//  Created by QC on 14-9-4.
//  Copyright (c) 2014年 G.MING. All rights reserved.
//

#import "MyObject.h"

@interface GMHistoryItem : MyObject
@property(nonatomic,strong)NSString * keyPath;
@property(nonatomic,strong)NSString * icon;
@property(nonatomic,strong)NSString * name;
@property(nonatomic,assign)NSInteger  count;
@end
