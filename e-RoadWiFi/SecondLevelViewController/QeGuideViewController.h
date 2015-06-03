//
//  QeGuideViewController.h
//  e-RoadWiFi
//
//  Created by QC on 15/2/2.
//  Copyright (c) 2015年 G.MING. All rights reserved.
//

#import "BasicViewController.h"

@interface QeGuideViewController : BasicViewController
{
        UIScrollView *MyScrollView;
}
@property(nonatomic,strong)NSString *HeadTitle;
@property(nonatomic,assign)NSInteger Index;
@end
