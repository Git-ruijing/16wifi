//
//  MyInforItem.h
//  e-RoadWiFi
//
//  Created by QC on 14-9-5.
//  Copyright (c) 2014年 G.MING. All rights reserved.
//

#import "MyObject.h"

@interface MyInforItem : MyObject

@property (nonatomic,strong)NSString * Data;
@property (nonatomic,assign)NSNumber * ReturnCode;
@property (nonatomic,assign)NSNumber * lv;
@property (nonatomic,assign)NSNumber * num;
@property (nonatomic,assign)NSNumber * status;
@property (nonatomic,strong)NSString * tip;

@end
