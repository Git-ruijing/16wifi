//
//  MyCellForVedio.m
//  16wifi2
//
//  Created by JAY on 13-5-2.
//  Copyright (c) 2013年 JAY. All rights reserved.
//

#import "MyCellForVedio.h"

@implementation MyCellForVedio
@synthesize title,content,bigImage,goldImage,goldLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier iconWeight:(int)weight IconHeight:(int)height andHeight:(int)SizeHeight
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor=[UIColor clearColor];
//        UIImageView *bg=[[UIImageView alloc]initWithFrame:CGRectMake(10, 7, 300, 70)];
//        bg.image=[[UIImage imageNamed:@"bg_kuang"]stretchableImageWithLeftCapWidth:4 topCapHeight:4];
//        [self addSubview:bg];
        title=[[UILabel alloc]initWithFrame:CGRectMake(weight+20, 10, 210,20 )];
        title.font=[UIFont boldSystemFontOfSize:15];
        title.textColor=[UIColor colorWithRed:51/255.f green:51/255.f blue:51/255.f alpha:1.0];
        [self.contentView addSubview:title];
     
        content=[[UILabel alloc]initWithFrame:CGRectMake(weight+20,30 , 210, 40)];
        content.textColor=[UIColor colorWithRed:128/255.f green:128/255.f blue:128/255.f alpha:1.0];
        content.font=[UIFont systemFontOfSize:13];
        content.textAlignment=NSTextAlignmentLeft;
        content.numberOfLines=2;
        [self.contentView addSubview:content];
      
        bigImage=[[UIImageView alloc]initWithFrame:CGRectMake(10, (SizeHeight-height)/2, weight, height)];
        bigImage.image=[UIImage imageNamed:@"down_2.png"];
        [self.contentView addSubview:bigImage];
        
        goldImage=[[UIImageView alloc]init];
        goldImage. frame=CGRectMake(270,SizeHeight-((SizeHeight-height)+2),16,16);
        goldImage.image=[UIImage imageNamed:@"goldIcon.png"];
        [self.contentView addSubview:goldImage];
        
        goldLabel=[[UILabel alloc]init];
        goldLabel.frame=CGRectMake(302-8,SizeHeight-((SizeHeight-height)-2), 25, 10);
        goldLabel.textColor=[UIColor colorWithRed:249/255.f green:160/255.f blue:24/255.f alpha:1.0];
        goldLabel.font=[UIFont systemFontOfSize:13];
        [self.contentView addSubview:goldLabel];
        
        if ([reuseIdentifier isEqualToString:@"AppCell"]) {
            _DownLoad=[[UIButton alloc]initWithFrame:CGRectMake(240, (SizeHeight-35)/2, 70, 35)];
            [_DownLoad setTitle:@"安装" forState:UIControlStateNormal];
            _DownLoad.titleLabel.font=[UIFont systemFontOfSize:13];
            _DownLoad.titleLabel.textColor=[UIColor whiteColor];
            [_DownLoad setBackgroundImage:[[UIImage imageNamed:@"gm_but"]stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
            _DownLoad.userInteractionEnabled=NO;
            [self.contentView addSubview:_DownLoad];
            
            goldImage. frame=CGRectMake(270-90,SizeHeight-((SizeHeight-height)+11),21,21);
            
            CALayer *lay = bigImage.layer;//获取ImageView的层 [lay
            [lay setMasksToBounds:YES];
            [lay setCornerRadius:10.0f];
            
            goldLabel.frame=CGRectMake(302-90-8,SizeHeight-((SizeHeight-height)+4), 25, 10);
        }

        UIView *lineView5=[[UIView alloc]initWithFrame:CGRectMake(10,80,310, 0.5)];
        lineView5.backgroundColor=[UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:0.7];
        [self.contentView addSubview:lineView5];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
