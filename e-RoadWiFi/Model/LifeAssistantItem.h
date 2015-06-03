//
//  LifeAssistantItem.h
//  e-RoadWiFi
//
//  Created by QC on 14-8-13.
//  Copyright (c) 2014年 G.MING. All rights reserved.
//

#import "MyObject.h"

@interface LifeAssistantItem : MyObject
@property (nonatomic,strong)NSString * advtiseId;
@property (nonatomic,strong)NSString * advtiseTitle;
@property (nonatomic,strong)NSString * advtisePath;
@property (nonatomic,strong)NSString * advtiseSource;
@property (nonatomic,strong)NSString * advtisePrice;
@property (nonatomic,strong)NSString * advtiseImg;
@property (nonatomic,assign)NSInteger  adWeight;

@end
