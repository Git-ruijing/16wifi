//
//  RelateWxViewController.h
//  e-RoadWiFi
//
//  Created by QC on 15-1-22.
//  Copyright (c) 2015年 G.MING. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Encryption.h"
#import "WXApi.h"
#import "MyButton.h"
@interface RelateWxViewController : UIViewController<UIAlertViewDelegate>
{

    UIView *  mainInforView;
    int flag;
    UIImageView *loadingAni;
    UIImageView *aniBg;
    MyButton * goBack;
}
@property(nonatomic ,readwrite)int BandType;
@property(nonatomic,strong)UISwitch *MySwitch;
-(void)startAnimat;
-(void)stopAnimat;
@end
