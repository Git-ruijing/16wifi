//
//  FirstOpenAnimationViewController.h
//  e路WiFi
//
//  Created by JAY on 13-10-23.
//  Copyright (c) 2013年 HE ZHENJIE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface FirstOpenAnimationViewController : UIViewController<UIScrollViewDelegate,loginNoticeDelegate>

@property (strong,nonatomic)UIScrollView  * MyScrollView;
@property (strong,nonatomic)NSMutableArray *slideImages;
@property (strong,nonatomic)UIPageControl *pageControl;

@end
