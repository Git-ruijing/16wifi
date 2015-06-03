//
//  SignInViewController.h
//  e-RoadWiFi
//
//  Created by QC on 15/2/27.
//  Copyright (c) 2015年 G.MING. All rights reserved.
//

#import "BasicViewController.h"
#import "MyImageView.h"
#import "PWSCalendarView.h"
@interface SignInViewController : BasicViewController<PWSCalendarDelegate>
{

    UIScrollView *_scrollerView;
    MyImageView *SignView;
    UILabel *SignLabel;
    UILabel *tips;
    UIView* m_view_bottom;
    NSMutableArray *SignDateArray;
    PWSCalendarView* DateView;
}

@end
