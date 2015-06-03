//
//  AboutUsViewController.h
//  e路WiFi
//
//  Created by JAY on 13-/Users/yy/Desktop/内测版代码改体验版说明.docx11-18.
//  Copyright (c) 2013年 HE ZHENJIE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyButton.h"
#define DEVICE_IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568)
#define SCREENHEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SIZEABOUTIOSVERSION ([[[UIDevice currentDevice] systemVersion] floatValue]<7.0?0:20)
#define IOSVERSIONSMALL ([[[UIDevice currentDevice] systemVersion] floatValue]<7.0?20:0)

@interface AboutUsViewController : UIViewController<UIGestureRecognizerDelegate>
{

    UIScrollView *myScrollView;
    UIView* headerView;
}
@end
