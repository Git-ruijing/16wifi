//
//  MyButton.h
//  16wifi
//
//  Created by sucen on 13-4-15.
//  Copyright (c) 2013年 sucen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyButton : UIButton
-(void)setNormalImage:(UIImage *)image;
-(void)setHighlightedImage:(UIImage *)image; 
-(void)setSelectedImage:(UIImage *)image; 
-(void)setSelectedBackgroundImage:(UIImage *)image;
-(void)setHighlightedBackgroundImage:(UIImage *)image;
-(void)setNormalBackgroundImage:(UIImage *)image;
-(void)setNTitleColor:(UIColor *)color;
-(void)setSTitleColor:(UIColor *)color;
-(void)setNTitle:(NSString *)title;
-(void)setSTitle:(NSString *)title;
-(void)addTarget:(id)target action:(SEL)action;
@end
