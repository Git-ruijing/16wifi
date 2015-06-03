//
//  CustomActionSheet.h
//  e-RoadWiFi
//
//  Created by QC on 14-12-5.
//  Copyright (c) 2014年 G.MING. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomActionSheet : UIActionSheet<UIGestureRecognizerDelegate>

@property (nonatomic, retain) UIView *customView;
@property (nonatomic, retain) NSString *customTitle;


-(id)initWithViewHeight:(float)_height WithSheetTitle:(NSString *)_title;

@end
