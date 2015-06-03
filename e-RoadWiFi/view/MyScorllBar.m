//
//  MyScorllBar.m
//  16wifi2
//
//  Created by JAY on 13-4-25.
//  Copyright (c) 2013年 JAY. All rights reserved.
//

#import "MyScorllBar.h"
#import "MyButton.h"
#define SIZEOFTITLECOLOR 76.0f
@implementation MyScorllBar

@synthesize delegate;
-(void)changeNavCtr:(MyButton*)button{
    NSUserDefaults * userDefaults=[NSUserDefaults standardUserDefaults];
    NSArray *subChannels=[userDefaults objectForKey:@"newsChannels"];
    
    for (int i=0; i<subChannels.count; i++) {
        MyButton*but1=(MyButton*)[self viewWithTag:700+i];
        if (i==(button.tag-700)) {
          
            [but1 setSelected:YES];
        }else{
            [but1 setSelected:NO];
        }
        
    }
    
    [self.delegate selectButIndex:(int)button.tag-700];
    [UIView animateWithDuration:0.25 animations:^{
        scrollView.frame=CGRectMake((button.tag-700)*64,37, 64, 3);
    }];
       
}

- (id)initWithFrame:(CGRect)frame  andWithDelegate:(id)mdelegate
{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        NSUserDefaults * userDefaults=[NSUserDefaults standardUserDefaults];
        NSArray *subChannels=[userDefaults objectForKey:@"newsChannels"];
        
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc]
                                                        initWithTarget:self
                                                        action:@selector(handlePan:)];
        [self addGestureRecognizer:panGestureRecognizer];
        
        self.delegate=mdelegate;
        backgroundView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 64*(subChannels.count<5?5:subChannels.count), frame.size.height)];
        [self addSubview:backgroundView];
        backgroundView.backgroundColor= [UIColor clearColor];
        UIImageView *imageViewBg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 64*(subChannels.count<5?5:subChannels.count), frame.size.height)];
        
        imageViewBg.image=[[UIImage imageNamed:@"tab_bg"]stretchableImageWithLeftCapWidth:10 topCapHeight:10];
        [backgroundView addSubview:imageViewBg];
        
        scrollView=[[UIImageView alloc]initWithFrame:CGRectMake(5,37, 54,3)];
        scrollView.image=[[UIImage imageNamed:@"line_bottom"]stretchableImageWithLeftCapWidth:1 topCapHeight:1];
        
        [backgroundView addSubview:scrollView];
 
        
        for (int i=0; i<subChannels.count; i++) {
            MyButton *but1=[MyButton buttonWithType:UIButtonTypeCustom];
            but1.frame=CGRectMake(10+64*i,5, 49.5, 30);
            but1.tag=700+i;
            [but1 setNTitle:[[subChannels objectAtIndex:i]objectForKey:@"name"]];
            but1.titleLabel.font=[UIFont systemFontOfSize:18];
            [but1 setNTitleColor:[UIColor colorWithRed:SIZEOFTITLECOLOR/255.f green:SIZEOFTITLECOLOR/255.f blue:SIZEOFTITLECOLOR/255.f alpha:1.0]];
            [but1 setSTitle:[[subChannels objectAtIndex:i]objectForKey:@"name"]];
            [but1 setSTitleColor:[UIColor colorWithRed:0/255.f green:172/255.f blue:238/255.f alpha:1.0]];
            [but1 addTarget:self action:@selector(changeNavCtr:)];
            if (i==0) {
                but1.selected=YES;
            }
            [backgroundView addSubview:but1];
        }
        
    }
    
    return self;
}
- (void) handlePan:(UIPanGestureRecognizer*) recognizer
{
    NSUserDefaults * userDefaults=[NSUserDefaults standardUserDefaults];
    NSArray *subChannels=[userDefaults objectForKey:@"newsChannels"];
    CGPoint translation = [recognizer translationInView:self];
 

    if (translation.x<-30) {
     
        if (backgroundView.frame.origin.x>(self.frame.size.width-subChannels.count*64)) {
            [UIView animateWithDuration:0.25 animations:^{
                backgroundView.frame=CGRectMake(backgroundView.frame.origin.x-64,backgroundView.frame.origin.y,backgroundView.frame.size.width,backgroundView.frame.size.height);
            }];
        }

    }else if(translation.x>30){
    
        if (backgroundView.frame.origin.x<0) {
            [UIView animateWithDuration:0.25 animations:^{
                backgroundView.frame=CGRectMake(backgroundView.frame.origin.x+64,backgroundView.frame.origin.y,backgroundView.frame.size.width,backgroundView.frame.size.height);
            }];
        }
        
      
    }
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
