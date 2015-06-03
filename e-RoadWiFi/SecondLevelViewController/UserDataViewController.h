//
//  UserDataViewController.h
//  e路WiFi
//
//  Created by JAY on 3/6/14.
//  Copyright (c) 2014 HE ZHENJIE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyButton.h"
#import "MHTextField.h"
#import "HttpDownLoad.h"
#import "MobClick.h"
#import "Encryption.h"
#define SECRETKEY @"ilovewififorfree"
#define DEVICE_IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568)
#define SCREENHEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SIZEABOUTIOSVERSION ([[[UIDevice currentDevice] systemVersion] floatValue]<7.0?0:20)
#define IOSVERSIONSMALL ([[[UIDevice currentDevice] systemVersion] floatValue]<7.0?20:0)
#import "HeadImageCropperViewController.h"
#import "ASIFormDataRequest.h"
@interface UserDataViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate, UIActionSheetDelegate,HeadImageCropperDelegate,MHTextFieldDelegate,UIGestureRecognizerDelegate>
{
    HttpDownload *submitHd;
    int downflag;
    
    UIScrollView *myScrollView;
    UIView* headerView;
    MyButton *submButton;
    MyButton *exitButton;
    MHTextField* nicknameTextField;
    MHTextField* gendersTextField;
    MHTextField* birthdayTextField;
    MHTextField* emailTextField;
    MHTextField *introTextField;
    UILabel* LocationTextField;
    int flag;
    UIImageView *loadingAni;
    UIImageView *aniBg;
    UILabel *noticeLabel;
    UIImageView * HeadPhoto;
    ASIFormDataRequest *form;
    UIImageView *imageView;
}
@property (nonatomic, strong) UIImageView *portraitImageView;


@end
