//
//  PushInfoItem.h
//  e-RoadWiFi
//
//  Created by QC on 14-9-17.
//  Copyright (c) 2014年 G.MING. All rights reserved.
//

#import "MyObject.h"

@interface PushInfoItem : MyObject
@property (nonatomic,strong)NSString * _j_msgid;
@property (nonatomic,strong)NSString * m;
@property (nonatomic,strong)NSString * h;
@property (nonatomic,strong)NSString * t;
@property(nonatomic,assign)NSInteger read;
@property (nonatomic,strong)NSString *time;
@property (nonatomic,assign)NSInteger type;
@end
