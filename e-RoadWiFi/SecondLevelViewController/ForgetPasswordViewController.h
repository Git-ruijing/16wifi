//
//  ForgetPasswordViewController.h
//  e路WiFi
//
//  Created by JAY on 2/25/14.
//  Copyright (c) 2014 HE ZHENJIE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyButton.h"
#import "MHTextField.h"
#import "Encryption.h"
#import "HttpDownLoad.h"
#import "LoginViewController.h"
@interface ForgetPasswordViewController : UIViewController<UITextFieldDelegate,loginNoticeDelegate>
{
    int myTimerFlag;
    HttpDownload *getSecurityCodeHD;
    UIView *bottomView;
    MHTextField *numberTextfield;
    UIView *ChangeView;
    UIView * registerView;
    UILabel * timeMachine;
    MyButton * regetButton;
    NSTimer *myTimer;
    
    int seconds;
    int httpDownloadFlag;
    UILabel * myPhoneNumberLabel;
    
    MHTextField *  securityCodeField;
    MHTextField * passwordTextfield;
    int registerFlag;
    HttpDownload *registerHD;

    int flag;
    UIImageView *loadingAni;
    UIImageView *aniBg;
    MyButton * getSecurityCodeButton;
}
@property(nonatomic,strong)LoginViewController* login;
@property(nonatomic,strong)NSString* UserPhone;
@property(nonatomic,assign)int  TypeTag;
@end
