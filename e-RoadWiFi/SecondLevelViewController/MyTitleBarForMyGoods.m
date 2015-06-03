//
//  MyTitleBarForMyGoods.m
//  e路WiFi
//
//  Created by JAY on 14-4-2.
//  Copyright (c) 2014年 HE ZHENJIE. All rights reserved.
//

#import "MyTitleBarForMyGoods.h"
#import "MyButton.h"
@implementation MyTitleBarForMyGoods
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame  andWithDelegate:(id)mdelegate
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate=mdelegate;
        UIImageView *backView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 300, 35)];
        backView.image=[[UIImage imageNamed:@"bg_kuang0.png"]stretchableImageWithLeftCapWidth:4 topCapHeight:4];
        [self addSubview:backView];
        backView.alpha=0.85;
        self.backgroundColor=[UIColor clearColor];
        MyButton *but1=[MyButton buttonWithType:UIButtonTypeCustom];
        but1.frame=CGRectMake(0,0,100,35);
        but1.tag=700;
        [but1 setNTitle:@"未使用"];
        [but1 setNTitleColor:[UIColor colorWithRed:0 green:172/255.f blue:238/255.f alpha:1.0]];
        [but1 setSTitle:@"未使用"];
        [but1.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [but1 setSTitleColor:[UIColor whiteColor]];
        [but1 addTarget:self action:@selector(changeNavCtr:)];
        [but1 setSelectedBackgroundImage:[[UIImage imageNamed:@"tableft0"]stretchableImageWithLeftCapWidth:4 topCapHeight:0]];
        but1.selected=YES;
        [self addSubview:but1];
        MyButton *but2=[MyButton buttonWithType:UIButtonTypeCustom];
        but2.frame=CGRectMake(100,0, 100, 35);
        but2.tag=701;
        [but2 setNTitle:@"已使用"];
        [but2 setNTitleColor:[UIColor colorWithRed:0 green:172/255.f blue:238/255.f alpha:1.0]];
        [but2 setSTitle:@"已使用"];
        [but2.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [but2 setSTitleColor:[UIColor whiteColor]];
        [but2 addTarget:self action:@selector(changeNavCtr:)];
        [but2 setSelectedBackgroundImage:[[UIImage imageNamed:@"tabmid"]stretchableImageWithLeftCapWidth:2 topCapHeight:0]];
        [self addSubview:but2];
        MyButton *but3=[MyButton buttonWithType:UIButtonTypeCustom];
        but3.frame=CGRectMake(200,0, 100, 35);
        but3.tag=702;
        [but3 setNTitle:@"已过期"];
        [but3.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [but3 setNTitleColor:[UIColor colorWithRed:0 green:172/255.f blue:238/255.f alpha:1.0]];
        [but3 setSTitle:@"已过期"];
        [but3 setSTitleColor:[UIColor whiteColor]];
        [but3 addTarget:self action:@selector(changeNavCtr:)];
        [but3 setSelectedBackgroundImage:[[UIImage imageNamed:@"tabright0"]stretchableImageWithLeftCapWidth:4 topCapHeight:0]];
        
        [self addSubview:but3];
        
    }
    
    return self;
}
-(void)changeNavCtr:(MyButton*)button{
    
    MyButton*but1=(MyButton*)[self viewWithTag:700];
    MyButton*but2=(MyButton*)[self viewWithTag:701];
    MyButton*but3=(MyButton*)[self viewWithTag:702];
 
    
    switch (button.tag) {
        case 700:
        {
            [self.delegate selectButtonIndex:0];
            [but1 setSelected:YES];
            [but2 setSelected:NO];
            [but3 setSelected:NO];
    
            break;
        }
        case 701:
        {
            [self.delegate selectButtonIndex:1];
            [but1 setSelected:NO];
            [but2 setSelected:YES];
            [but3 setSelected:NO];
        
            break;
            
        }
        case 702:
        {
            [self.delegate selectButtonIndex:2];
            [but1 setSelected:NO];
            [but2 setSelected:NO];
            [but3 setSelected:YES];
          
            break;
        }
   
        default:
            break;
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
