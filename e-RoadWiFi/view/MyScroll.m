//
//  MyScroll.m
//  16wifi2
//
//  Created by JAY on 13-4-28.
//  Copyright (c) 2013年 JAY. All rights reserved.
//

#import "MyScroll.h"

@implementation MyScroll
@synthesize mdelegate,scorllImages;
- (id)initWithFrame:(CGRect)frame andWithDelegate:(id)delegate andWithPages:(int)page
{
    self = [super initWithFrame:frame];
    if (self) {
        self.bounces=NO;
        self.showsHorizontalScrollIndicator=NO;
        self.contentSize=CGSizeMake(320*page, 125);
        self.pagingEnabled=YES;
        self.backgroundColor=[UIColor clearColor];
        self.delegate=delegate;
        scorllImages=[[NSMutableArray alloc]initWithCapacity:0];
        for (int i=0; i<page; i++) {
            UIImageView *scorllImage1=[[UIImageView alloc]initWithFrame:CGRectMake(320*i, 0, 320, 125)];
            scorllImage1.backgroundColor=[UIColor clearColor];
            
            [self addSubview:scorllImage1];
            
            UIButton *but1=[UIButton buttonWithType:UIButtonTypeCustom];
            but1.frame=CGRectMake(320*i, 0, 320, 125);
            [but1 addTarget:self action:@selector(pressMe:) forControlEvents:UIControlEventTouchUpInside];
            but1.tag=300+i;
            [self addSubview:but1];
            [scorllImages addObject:scorllImage1];
        }

        
 

    }
    return self;
}
-(void)pressMe:(UIButton *)button{
    [self.mdelegate pressButtonTag:(int)(button.tag-300)];
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
