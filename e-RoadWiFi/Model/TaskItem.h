//
//  TaskItem.h
//  e路WiFi
//
//  Created by JAY on 14-4-3.
//  Copyright (c) 2014年 HE ZHENJIE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaskItem : NSObject
@property(nonatomic,strong)NSString *taskDescription;
@property(nonatomic,strong)NSString *taskBonus;
@property(nonatomic,strong)NSString *taskName;
@property(nonatomic,strong)NSString *taskID;
@property(nonatomic,strong)NSString *taskOrder;
@property(nonatomic,strong)NSNumber *taskStatus;
@end
