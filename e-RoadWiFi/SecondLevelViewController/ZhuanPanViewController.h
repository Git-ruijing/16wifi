//
//  ZhuanPanViewController.h
//  e-RoadWiFi
//
//  Created by Jay on 15-1-30.
//  Copyright (c) 2015年 G.MING. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicViewController.h"
#import "RootUrl.h"
#import "LoginViewController.h"
@interface ZhuanPanViewController : BasicViewController<NSURLConnectionDelegate,NSURLConnectionDataDelegate,UIGestureRecognizerDelegate,UIWebViewDelegate,loginNoticeDelegate>
{
    UIWebView *myWebView;
    UIImageView *loadingAni;
    UIImageView *aniBg;
    int flag;
    NSString *channelName;
    UIView *bottomView;
    MyButton * goForward;
    UIImageView* failImageView;
    int failImageFlag;
}
@property(nonatomic,retain)UILabel *titleLabel;
@property(nonatomic,retain)NSURLRequest *myRequest;
@property (nonatomic,readonly)NSMutableData *mData;
@property(nonatomic,readwrite)BOOL GoBack;

@property(nonatomic,readwrite)int isPush;
-(void)setName:(NSString *)string;
@end