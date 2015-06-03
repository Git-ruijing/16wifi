//
//  MyGoodsCell.m
//  e路WiFi
//
//  Created by JAY on 14-4-2.
//  Copyright (c) 2014年 HE ZHENJIE. All rights reserved.
//

#import "MyGoodsCell.h"

@implementation MyGoodsCell
@synthesize title,label1,label2,bigImage;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        self.backgroundColor=[UIColor clearColor];
        UIImageView *bg=[[UIImageView alloc]initWithFrame:CGRectMake(10, 7, 300, 70)];
        bg.image=[[UIImage imageNamed:@"bg_kuang"]stretchableImageWithLeftCapWidth:4 topCapHeight:4];
        [self addSubview:bg];
        title=[[UILabel alloc]initWithFrame:CGRectMake(132, 12, 178,20)];
        title.font=[UIFont boldSystemFontOfSize:15];
        title.textColor=[UIColor colorWithRed:51/255.f green:51/255.f blue:51/255.f alpha:1.0];
        [self addSubview:title];
       
        UILabel * t1=[[UILabel alloc]initWithFrame:CGRectMake(132, 32, 60,20)];
        t1.font=[UIFont boldSystemFontOfSize:13];
        t1.text=@"序列号：";
        
        t1.textColor=[UIColor colorWithRed:51/255.f green:51/255.f blue:51/255.f alpha:1.0];
        [self addSubview:t1];
        
        UILabel * t2=[[UILabel alloc]initWithFrame:CGRectMake(132, 52, 80,20)];
        t2.font=[UIFont boldSystemFontOfSize:13];
        t2.text=@"有效期至：";
        t2.textColor=[UIColor colorWithRed:51/255.f green:51/255.f blue:51/255.f alpha:1.0];
        [self addSubview:t2];
        
        label1=[[UILabel alloc]initWithFrame:CGRectMake(180,32 , 130, 20)];
        label1.textColor=[UIColor colorWithRed:0/255.f green:172/255.f blue:238/255.f alpha:1.0];
        label1.font=[UIFont systemFontOfSize:13];
        [self addSubview:label1];
        label2=[[UILabel alloc]initWithFrame:CGRectMake(190,52 , 120, 20)];
        label2.textColor=[UIColor colorWithRed:51/255.f green:51/255.f blue:51/255.f alpha:1.0];
        label2.font=[UIFont systemFontOfSize:13];
        
        [self addSubview:label2];
        
        bigImage =[[UIImageView alloc]initWithFrame:CGRectMake(10, 14, 112, 55)];
        bigImage.image=[UIImage imageNamed:@"down_1"];
                
        [self addSubview:bigImage];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
