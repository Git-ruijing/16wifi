//
//  DataItem.h
//  e-RoadWiFi
//
//  Created by QC on 14-8-25.
//  Copyright (c) 2014年 G.MING. All rights reserved.
//

#import "MyObject.h"

@interface DataItem : MyObject

@property (nonatomic,strong)NSString * Data;
@property (nonatomic,assign)NSNumber * alldata;
@property (nonatomic,strong)NSArray * list;
@property (nonatomic,assign)NSNumber * today;


@end
