//
//  MyImageView.h
//  e-RoadWiFi
//
//  Created by QC on 14-8-13.
//  Copyright (c) 2014年 G.MING. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyImageView : UIImageView
@property (nonatomic)NSInteger index;
- (id)initWithFrame:(CGRect)frame andWithRadius:(float)radius;
-(void)addTarget:(id)target action:(SEL)action;

@end
