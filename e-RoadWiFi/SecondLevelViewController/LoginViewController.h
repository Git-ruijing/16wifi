//
//  LoginViewController.h
//  e路WiFi
//
//  Created by JAY on 14-1-15.
//  Copyright (c) 2014年 HE ZHENJIE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyButton.h"
#import "MHTextField.h"
#import "HttpDownLoad.h"
#import "Encryption.h"
#import "WXApi.h"
@protocol loginNoticeDelegate;
@interface LoginViewController : UIViewController<UIGestureRecognizerDelegate,UITextFieldDelegate>
{
    MyButton *registerButton;
    UIView *bottomView;
    MyButton *fogetPassword;
    MHTextField *numberTextfield;
    MHTextField *passwordTextfield;
    UILabel *noticeLabel;
    HttpDownload *loginHd;
    int loginDownloadFlag;
    int flag;
    UIImageView *loadingAni;
    UIImageView *aniBg;
    UIScrollView *BgScrollView;
    
}
-(void)showNotice:(NSString*)str;
-(void)showSuccessNotice:(NSString*)str;
-(void)buildLoadingAnimat;
-(void)startAnimat;
-(void)stopAnimat;

@property(nonatomic ,readwrite)int Ltag;
@property(nonatomic ,readwrite)int Ltype;
@property (nonatomic,unsafe_unretained) id<loginNoticeDelegate> delegate;
@end
@protocol loginNoticeDelegate
@optional
-(void)loginSuccessWithTag:(int)tag;

@end