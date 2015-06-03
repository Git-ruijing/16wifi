//
//  SettingViewController.h
//  e-RoadWiFi
//
//  Created by QC on 14-8-18.
//  Copyright (c) 2014年 G.MING. All rights reserved.
//

#import "BasicViewController.h"
#import "HttpDownLoad.h"
@interface SettingViewController : BasicViewController<UIAlertViewDelegate>
{
    NSString *path;
    UIScrollView *_scrollerView;
}
@end
