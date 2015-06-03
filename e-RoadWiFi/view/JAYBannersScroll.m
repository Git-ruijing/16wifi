//
//  JAYBannersScroll.m
//  e路WiFi
//
//  Created by JAY on 14-4-16.
//  Copyright (c) 2014年 HE ZHENJIE. All rights reserved.
//

#import "JAYBannersScroll.h"

@implementation JAYBannersScroll

@synthesize scorllImageArray,mdelegate;
- (id)initWithFrame:(CGRect)frame andWithDelegate:(id)delegate andWithPage:(int)pages;
{
    self = [super initWithFrame:frame];
    if (self) {
        scorllImageArray=[[NSMutableArray alloc]initWithCapacity:0];
        self.bounces=NO;
        self.showsHorizontalScrollIndicator=NO;
        self.contentSize=CGSizeMake(320*pages, 125);
        self.pagingEnabled=YES;
        self.backgroundColor=[UIColor clearColor];
        self.delegate=delegate;
        for (int a=0;a<pages;a++) {
           UIImageView * scorllImage=[[UIImageView alloc]initWithFrame:CGRectMake(a*320, 0, 320, 125)];
            scorllImage.backgroundColor=[UIColor clearColor];
            [self addSubview:scorllImage];
            UIButton *but=[UIButton buttonWithType:UIButtonTypeCustom];
            but.frame=CGRectMake(a*320, 0, 320, 125);
            [but addTarget:self action:@selector(pressMe:) forControlEvents:UIControlEventTouchUpInside];
            but.tag=300+a;
            [self addSubview:but];
            [scorllImageArray addObject:scorllImage];
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
