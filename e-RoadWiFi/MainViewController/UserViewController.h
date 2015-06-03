//
//  UserViewController.h
//  e-RoadWiFi
//
//  Created by QC on 14-8-15.
//  Copyright (c) 2014年 G.MING. All rights reserved.
//

#import "BasicViewController.h"
#import "LoginViewController.h"
@interface UserViewController : BasicViewController<loginNoticeDelegate>
{
    UIView *backView;
    UIScrollView *MyScrollView;
    UILabel *status;
    NSString *coinNumber;
    UIButton *BackButton;
    UIImageView *im;
    UIImageView *PushNews;
    UIImageView * HeadPhoto;
      UIImageView * redPoint;
    NSInteger NumOfShowList;
    
}
@end
