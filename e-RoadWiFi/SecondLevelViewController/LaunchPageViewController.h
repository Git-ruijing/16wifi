//
//  LaunchPageViewController.h
//  e路WiFi
//
//  Created by JAY on 14-4-18.
//  Copyright (c) 2014年 HE ZHENJIE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface LaunchPageViewController : UIViewController
{
    UILabel * timerLabel;
    int  duration;
    NSTimer *myTimer;
}
@end
