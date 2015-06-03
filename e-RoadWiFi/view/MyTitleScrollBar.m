//
//  MyTitleScrollBar.m
//  16wifi2
//
//  Created by JAY on 13-5-2.
//  Copyright (c) 2013年 JAY. All rights reserved.
//

#import "MyTitleScrollBar.h"

#import "MyButton.h"
@implementation MyTitleScrollBar
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
        but1.frame=CGRectMake(0,0,75,35);
        but1.tag=700;
        [but1 setNTitle:@"搞笑"];
        [but1 setNTitleColor:[UIColor colorWithRed:0 green:172/255.f blue:238/255.f alpha:1.0]];
        [but1 setSTitle:@"搞笑"];
        [but1.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [but1 setSTitleColor:[UIColor whiteColor]];
        [but1 addTarget:self action:@selector(changeNavCtr:)];
        [but1 setSelectedBackgroundImage:[[UIImage imageNamed:@"tableft0"]stretchableImageWithLeftCapWidth:4 topCapHeight:0]];
        but1.selected=YES;
        [self addSubview:but1];
        MyButton *but2=[MyButton buttonWithType:UIButtonTypeCustom];
        but2.frame=CGRectMake(75,0, 75, 35);
        but2.tag=701;
        [but2 setNTitle:@"娱乐"];
        [but2 setNTitleColor:[UIColor colorWithRed:0 green:172/255.f blue:238/255.f alpha:1.0]];
        [but2 setSTitle:@"娱乐"];
        [but2.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [but2 setSTitleColor:[UIColor whiteColor]];
        [but2 addTarget:self action:@selector(changeNavCtr:)];
        [but2 setSelectedBackgroundImage:[[UIImage imageNamed:@"tabmid"]stretchableImageWithLeftCapWidth:2 topCapHeight:0]];
        [self addSubview:but2];
        MyButton *but3=[MyButton buttonWithType:UIButtonTypeCustom];
        but3.frame=CGRectMake(150,0, 75, 35);
        but3.tag=702;
        [but3 setNTitle:@"微电影"];
        [but3 setNTitleColor:[UIColor colorWithRed:0 green:172/255.f blue:238/255.f alpha:1.0]];
        [but3 setSTitle:@"微电影"];
        [but3.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [but3 setSTitleColor:[UIColor whiteColor]];
        [but3 addTarget:self action:@selector(changeNavCtr:)];
        [but3 setSelectedBackgroundImage:[[UIImage imageNamed:@"tabmid"]stretchableImageWithLeftCapWidth:2 topCapHeight:0]];
        [self addSubview:but3];
        MyButton *but4=[MyButton buttonWithType:UIButtonTypeCustom];
        but4.frame=CGRectMake(225,0, 75, 35);
        but4.tag=703;
        [but4 setNTitle:@"综合"];
        [but4.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [but4 setNTitleColor:[UIColor colorWithRed:0 green:172/255.f blue:238/255.f alpha:1.0]];
        [but4 setSTitle:@"综合"];
        [but4 setSTitleColor:[UIColor whiteColor]];
        [but4 addTarget:self action:@selector(changeNavCtr:)];
        [but4 setSelectedBackgroundImage:[[UIImage imageNamed:@"tabright0"]stretchableImageWithLeftCapWidth:4 topCapHeight:0]];

        [self addSubview:but4];

    }
    
    return self;
}
-(void)changeNavCtr:(MyButton*)button{
    
    MyButton*but1=(MyButton*)[self viewWithTag:700];
    MyButton*but2=(MyButton*)[self viewWithTag:701];
    MyButton*but3=(MyButton*)[self viewWithTag:702];
    MyButton*but4=(MyButton*)[self viewWithTag:703];
    
    switch (button.tag) {
        case 700:
        {
            [self.delegate selectButtonIndex:0];
            [but1 setSelected:YES];
            [but2 setSelected:NO];
            [but3 setSelected:NO];
            [but4 setSelected:NO];
            break;
        }
        case 701:
        {
            [self.delegate selectButtonIndex:1];
            [but1 setSelected:NO];
            [but2 setSelected:YES];
            [but3 setSelected:NO];
            [but4 setSelected:NO];
            break;
            
        }
        case 702:
        {
            [self.delegate selectButtonIndex:2];
            [but1 setSelected:NO];
            [but2 setSelected:NO];
            [but3 setSelected:YES];
            [but4 setSelected:NO];
            break;
        }
        case 703:
        {
            [self.delegate selectButtonIndex:3 ];
            [but1 setSelected:NO];
            [but2 setSelected:NO];
            [but3 setSelected:NO];
            [but4 setSelected:YES];
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