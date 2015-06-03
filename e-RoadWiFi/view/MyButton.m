//
//  MyButton.m
//  16wifi
//
//  Created by sucen on 13-4-15.
//  Copyright (c) 2013年 sucen. All rights reserved.
//

#import "MyButton.h"

@implementation MyButton

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}
-(void)setNTitleColor:(UIColor *)color {
    [self setTitleColor:color forState:UIControlStateNormal];
}
-(void)setSTitleColor:(UIColor *)color {
    [self setTitleColor:color forState:UIControlStateSelected];
}
-(void)setNTitle:(NSString *)title{
    [self setTitle:title forState:UIControlStateNormal];
}
-(void)setSTitle:(NSString *)title{
     [self setTitle:title forState:UIControlStateSelected];
}
-(void)addTarget:(id)target action:(SEL)action{
    [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}
-(void)setNormalImage:(UIImage *)image {
    [self setImage:image forState:UIControlStateNormal];
}
-(void)setHighlightedImage:(UIImage *)image {
    [self setImage:image forState:UIControlStateHighlighted];
}
-(void)setSelectedImage:(UIImage *)image {
    [self setImage:image forState:UIControlStateSelected];
}
-(void)setSelectedBackgroundImage:(UIImage *)image {
    [self setBackgroundImage:image forState:UIControlStateSelected];
    
}
-(void)setHighlightedBackgroundImage:(UIImage *)image {
    [self setBackgroundImage:image forState:UIControlStateHighlighted];
    
}
-(void)setNormalBackgroundImage:(UIImage *)image {
    [self setBackgroundImage:image forState:UIControlStateNormal];
    
}
@end
