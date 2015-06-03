//
//  BandPhoneViewController.h
//  e-RoadWiFi
//
//  Created by QC on 15/2/9.
//  Copyright (c) 2015年 G.MING. All rights reserved.
//

#import "BasicViewController.h"
#import "MyButton.h"
#import "MHTextField.h"
#import "Encryption.h"
#import "HttpDownLoad.h"
#import "LoginViewController.h"
@interface BandPhoneViewController : BasicViewController<UIAlertViewDelegate>
{
    
    MHTextField * SeCodeField;
    MHTextField *PhoneTextfield;
    UIView *getInforView;
    UILabel * timeMachine;
    MyButton * regetButton;
    HttpDownload *getSeCodeHD;
    int httpDownloadFlag;
    int flag;
    UIImageView *loadingAni;
    UIImageView *aniBg;
    int myTimerFlag;
    NSTimer *myTimer;
    int seconds;
    HttpDownload *VerifyHD;
    MyButton * getSecurityCodeButton;
}
@property (strong, nonatomic) LoginViewController *WXLogin;

@end
