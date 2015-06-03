//
//  BusInquiryBar.m
//  e路WiFi
//
//  Created by JAY on 13-12-4.
//  Copyright (c) 2013年 HE ZHENJIE. All rights reserved.
//

#import "BusInquiryBar.h"
#import "MyButton.h"
@implementation BusInquiryBar
@synthesize delegate, redPoint;
- (id)initWithFrame:(CGRect)frame  andTag:(NSString *)tag andStretchCap:(NSInteger)cap andWithDelegate:(id)mdelegate
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate=mdelegate;
        UIImageView *backView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        backView.image=[[UIImage imageNamed:[NSString stringWithFormat:@"bg_kuang%@",tag]]stretchableImageWithLeftCapWidth:cap topCapHeight:cap];
        [self addSubview:backView];
   
//        backView.alpha=0.85;
        self.backgroundColor=[UIColor clearColor];
        
        but1=[MyButton buttonWithType:UIButtonTypeCustom];
        but1.frame=CGRectMake(0,0,frame.size.width/2,frame.size.height);
        but1.tag=800;
        
        [but1 setNTitleColor:[UIColor colorWithRed:0 green:172/255.f blue:238/255.f alpha:1.0]];
        [but1 setSTitleColor:[UIColor whiteColor]];
        [but1 addTarget:self action:@selector(changeNavCtr:)];
        [but1 setSelectedBackgroundImage:[[UIImage imageNamed:[NSString stringWithFormat:@"tableft%@",tag]]stretchableImageWithLeftCapWidth:cap topCapHeight:0]];
        but1.selected=YES;
        [self addSubview:but1];
        
        but2=[MyButton buttonWithType:UIButtonTypeCustom];
        but2.frame=CGRectMake(frame.size.width/2,0, frame.size.width/2, frame.size.height);
        but2.tag=801;
        [but2 setNTitleColor:[UIColor colorWithRed:0 green:172/255.f blue:238/255.f alpha:1.0]];
        [but2 setSTitleColor:[UIColor whiteColor]];
        [but2 addTarget:self action:@selector(changeNavCtr:)];
        [but2 setSelectedBackgroundImage:[[UIImage imageNamed:[NSString stringWithFormat:@"tabright%@",tag]]stretchableImageWithLeftCapWidth:4 topCapHeight:0]];
        [self addSubview:but2];
        
        if ([tag isEqualToString:@"1"]) {
            [but2.titleLabel setFont:[UIFont systemFontOfSize:16]];
            [but1.titleLabel setFont:[UIFont systemFontOfSize:16]];
            redPoint=[[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-15,3, 6 ,6 )];
            redPoint.image=[UIImage imageNamed:@"redPoind"];
            [self addSubview:redPoint];
            
        }else{
            [but2.titleLabel setFont:[UIFont systemFontOfSize:15]];
            [but1.titleLabel setFont:[UIFont systemFontOfSize:15]];
        }
        
    }
    
    return self;
}
-(void)setButtonName:(NSString *)buttonName andWithButtonIndex:(int)index{
    switch (index) {
        case 1:
        {
            [but1 setNTitle:buttonName];
            [but1 setSTitle:buttonName];
            break;
        }
           
        case 2:
        {
            [but2 setSTitle:buttonName];
            [but2 setNTitle:buttonName];
            break;
        }
        default:
            break;
    }
}
-(void)changeNavCtr:(MyButton*)button{
    
    MyButton*but11=(MyButton*)[self viewWithTag:800];
    MyButton*but22=(MyButton*)[self viewWithTag:801];

    
    switch (button.tag) {
        case 800:
        {
            [self.delegate selectType:0];
            [but11 setSelected:YES];
            [but22 setSelected:NO];
 
            break;
            
        }
        case 801:
        {
            
            [self.delegate selectType:1];
            [but11 setSelected:NO];
            [but22 setSelected:YES];
            redPoint.hidden=YES;
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
