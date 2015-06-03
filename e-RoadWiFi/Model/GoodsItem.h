//
//  GoodsItem.h
//  e路WiFi
//
//  Created by JAY on 3/19/14.
//  Copyright (c) 2014 HE ZHENJIE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsItem : NSObject
@property(nonatomic,strong)NSString *goodsName;
@property(nonatomic,strong)NSString *goodsID;
@property(nonatomic,strong)NSString *goodsTotalNumber;
@property(nonatomic,strong)NSString *everyDayNumber;
@property(nonatomic,strong)NSString *oldPrice;
@property(nonatomic,strong)NSString *realPrice;
@property(nonatomic,strong)NSString *startTime;
@property(nonatomic,strong)NSString *endTime;
@property(nonatomic,strong)NSArray  *goodsImagesArray;
@property(nonatomic,strong)NSString *getStartTime;
@property(nonatomic,strong)NSString *getEndTime;
@property(nonatomic,strong)NSString *goodsStatus;
@property(nonatomic,strong)NSString *goodsIntroduce;
@property(nonatomic,strong)NSString *goodsAbout;
@property(nonatomic,strong)NSString *everyOneNumber;
@property(nonatomic,strong)NSString *hotOrSale;
@property(nonatomic,strong)NSString *sid;
@property(nonatomic,strong)NSString *usecontent;
@end
