
//
//  NewsSubViewController.h
//  e-RoadWiFi
//
//  Created by Jay on 14-9-10.
//  Copyright (c) 2014年 G.MING. All rights reserved.
//

#import "BasicViewController.h"
#import "NewItem.h"
#import "HttpDownLoad.h"
#import "UMSocial.h"
#import "CustomActionSheet.h"
@interface NewsSubViewController : BasicViewController<NSURLConnectionDelegate,NSURLConnectionDataDelegate,UIGestureRecognizerDelegate,UIWebViewDelegate,UMSocialUIDelegate>
{
    UIWebView *myWebView;
    UIImageView *loadingAni;
    UIImageView *aniBg;
    int flag;
    NSString *channelName;
    UIView* failImageView;
    int failImageFlag;
    NSString *fountColor;
    NSString *fountSize;
    NSString *bgColor;
    CustomActionSheet* sheet ;
    int goldFlag;
}
@property(nonatomic,retain)UILabel *titleLabel;
@property(nonatomic,retain)NSURLRequest *myRequest;
@property (nonatomic,readonly)NSMutableData *mData;
@property(nonatomic,retain)NSURLRequest *originRequest;
@property(nonatomic,readwrite)BOOL isAuthed;
@property(nonatomic,readwrite)BOOL isRecommend;
@property(nonatomic,readwrite)int isPush;
//@property(nonatomic,readwrite)int isPush;
@property(nonatomic,retain)NewItem * newitem;
-(void)setName:(NSString *)string;
@end
