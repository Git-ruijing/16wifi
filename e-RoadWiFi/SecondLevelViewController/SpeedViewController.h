//
//  SpeedViewController.h
//  e-RoadWiFi
//
//  Created by QC on 15/3/25.
//  Copyright (c) 2015年 G.MING. All rights reserved.
//

#import "BasicViewController.h"
#import "wendu_yuan2.h"
#import "HttpRequest.h"
#import "HttpManager.h"
#import "UMSocial.h"
@interface SpeedViewController : BasicViewController<UMSocialUIDelegate>
{
    UIScrollView *MyScrollView;
    UIButton *TestSpeed;
    UILabel*TipsLabel;
    NSTimer *timer;
    int count;
    HttpRequest *downtest;
    UIImageView *Bgimage;
}
@property(nonatomic)wendu_yuan2 * wendu;
@end
