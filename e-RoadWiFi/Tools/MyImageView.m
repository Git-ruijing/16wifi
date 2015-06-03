//
//  MyImageView.m
//  e-RoadWiFi
//
//  Created by QC on 14-8-13.
//  Copyright (c) 2014年 G.MING. All rights reserved.
//

#import "MyImageView.h"

@interface MyImageView(){
    id _target;
    SEL _action;
}

@property (nonatomic ,retain)id target;
@property(nonatomic )SEL action;

@end


@implementation MyImageView
@synthesize index=_index;

- (id)initWithFrame:(CGRect)frame andWithRadius:(float)radius
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.userInteractionEnabled=YES;
        
        CALayer *lay = self.layer;//获取ImageView的层 [lay
        [lay setMasksToBounds:YES];
        [lay setCornerRadius:radius];
        
    }
    return self;
}
//通过UITouch给UIImageView增加点击事件
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if ([self.target respondsToSelector:self.action]) {
        [self.target performSelector:self.action withObject:self];
    }
    
}
-(void)addTarget:(id)target action:(SEL)action{

    self.target=target;
    self.action=action;
}

-(UIImage *)makeRoundedImage:(UIImage *) image
                      radius: (float) radius;
{
    CALayer *imageLayer = [CALayer layer];
    imageLayer.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    imageLayer.contents = (id) image.CGImage;
    
    imageLayer.masksToBounds = YES;
    imageLayer.cornerRadius = radius;
    
    UIGraphicsBeginImageContext(image.size);
    [imageLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *roundedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return roundedImage;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
