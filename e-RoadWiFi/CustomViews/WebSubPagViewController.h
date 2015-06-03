//
//  WebSubPagViewController.h
//  e路WiFi
//
//  Created by JAY on 13-10-29.
//  Copyright (c) 2013年 HE ZHENJIE. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "BasicViewController.h"
#import "RootUrl.h"
#import "LoginViewController.h"
@interface WebSubPagViewController : BasicViewController<NSURLConnectionDelegate,NSURLConnectionDataDelegate,UIGestureRecognizerDelegate,UIWebViewDelegate,loginNoticeDelegate>
{

    UIImageView *loadingAni;
    UIImageView *aniBg;
    int flag;
    NSString *channelName;
    UIView *bottomView;
    MyButton * goForward;
    UIView* failImageView;
    int failImageFlag;
}
@property(nonatomic,retain)UILabel *titleLabel;
@property(nonatomic,retain)NSURLRequest *myRequest;
@property (nonatomic,readonly)NSMutableData *mData;
@property(nonatomic,retain)NSURLRequest *originRequest;
@property(nonatomic,readwrite)BOOL isAuthed;
@property(nonatomic,readwrite)BOOL GoBack;
@property(nonatomic,readwrite)int isPush;
@property (nonatomic,strong)UIWebView *myWebView;
-(void)setName:(NSString *)string;
@end
