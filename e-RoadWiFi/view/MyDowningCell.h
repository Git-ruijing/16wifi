//
//  MyDowningCell.h
//  e路WiFi
//
//  Created by JAY on 14-4-21.
//  Copyright (c) 2014年 HE ZHENJIE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KDGoalBar.h"
@interface MyDowningCell : UITableViewCell
@property(nonatomic ,strong)UILabel *title;
@property(nonatomic ,strong)UILabel *label;
@property(nonatomic ,strong)UIImageView *bigImage;
@property(nonatomic ,strong)UIImageView * iconImage;
@property(nonatomic ,strong)KDGoalBar * downBar;
@end