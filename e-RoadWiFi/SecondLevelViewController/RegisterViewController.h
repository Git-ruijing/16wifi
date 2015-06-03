//
//  RegisterViewController.h
//  e路WiFi
//
//  Created by JAY on 2/18/14.
//  Copyright (c) 2014 HE ZHENJIE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyButton.h"
#import "MHTextField.h"
#import "Encryption.h"
#import "HttpDownLoad.h"
#import "LoginViewController.h"
@interface RegisterViewController : UIViewController<UIAlertViewDelegate>
{
    int myTimerFlag;
    MHTextField *  securityCodeField;
    MHTextField * passwordTextfield;
    MHTextField *InvitationCodefiled;
    MyButton * getSecurityCodeButton;
    UIButton *choseCity;
    UILabel *title;
    HttpDownload *getSecurityCodeHD;
    int registerFlag;
    HttpDownload *registerHD;
      HttpDownload *YzRegisterHD;
    UIView *bottomView;
    MHTextField *numberTextfield;
    UIView *getInforView;
    UIView *CityAndInviteView;
    UILabel * timeMachine;
    MyButton * regetButton;
    NSTimer *myTimer;
    int seconds;
    int httpDownloadFlag;
    UILabel * myPhoneNumberLabel;
    int flag;
    UIImageView *loadingAni;
    UIImageView *aniBg;
    UILabel *noticeLabel;
    UILabel *city;
}
@property(nonatomic,retain)LoginViewController* login;
@property(nonatomic,assign)int  RegisterType;
@end
