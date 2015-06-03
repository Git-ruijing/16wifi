//
//  HeadImageCropperViewController.h
//  e-RoadWiFi
//
//  Created by QC on 15/4/1.
//  Copyright (c) 2015年 G.MING. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HeadImageCropperViewController;

@protocol HeadImageCropperDelegate <NSObject>

- (void)imageCropper:(HeadImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage;
- (void)imageCropperDidCancel:(HeadImageCropperViewController *)cropperViewController;

@end

@interface HeadImageCropperViewController : UIViewController

@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, assign) id<HeadImageCropperDelegate> delegate;
@property (nonatomic, assign) CGRect cropFrame;


@property (nonatomic, retain) UIImage *originalImage;
@property (nonatomic, retain) UIImage *editedImage;

@property (nonatomic, retain) UIImageView *showImgView;
@property (nonatomic, retain) UIView *overlayView;
@property (nonatomic, retain) UIView *ratioView;

@property (nonatomic, assign) CGRect oldFrame;
@property (nonatomic, assign) CGRect largeFrame;
@property (nonatomic, assign) CGFloat limitRatio;

@property (nonatomic, assign) CGRect latestFrame;


- (id)initWithImage:(UIImage *)originalImage cropFrame:(CGRect)cropFrame limitScaleRatio:(NSInteger)limitRatio;


@end
