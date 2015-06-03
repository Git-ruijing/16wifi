//
//  ActivityViewController.h
//  e-RoadWiFi
//
//  Created by QC on 14-8-1.
//  Copyright (c) 2014年 G.MING. All rights reserved.
//

#import "BasicViewController.h"
#import "LoginViewController.h"
@interface ActivityViewController : BasicViewController<UIWebViewDelegate,loginNoticeDelegate>
{
    int flag;
    UIImageView *loadingAni;
    UIImageView *aniBg;
    UIView* failImageView;
    int failImageFlag;
    UIWebView *myWebView;
    
    BOOL NeedLoadView;
    
}
@end
