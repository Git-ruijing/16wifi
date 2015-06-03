//
//  QCLifeItem.h
//  e-RoadWiFi
//
//  Created by QC on 14-8-13.
//  Copyright (c) 2014年 G.MING. All rights reserved.
//

#import "MyObject.h"

@interface QCLifeItem : MyObject
@property (nonatomic,strong)NSArray * contents;
@property (nonatomic,assign)NSNumber * priority;
@property (nonatomic,strong)NSString * id;
@property (nonatomic,strong)NSString * categoryName;
@property (nonatomic,strong)NSString * categoryChineseName;
@property (nonatomic,strong)NSString * linkId;
@property (nonatomic,strong)NSString * linkName;
@property (nonatomic,strong)NSString * linkPath;

@end
