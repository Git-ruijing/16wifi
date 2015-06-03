//
//  MyVideoCell.m
//  e路WiFi
//
//  Created by JAY on 13-11-21.
//  Copyright (c) 2013年 HE ZHENJIE. All rights reserved.
//

#import "MyVideoCell.h"

@implementation MyVideoCell
@synthesize title,label,bigImage,iconImage;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
   
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0,64, 320, 1)];
        lineView.backgroundColor=[UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:0.8];
        [self addSubview:lineView];
        self.backgroundColor=[UIColor whiteColor];
        
        title=[[UILabel alloc]initWithFrame:CGRectMake(70, 10, 180,20 )];
        title.font=[UIFont boldSystemFontOfSize:15];
        title.textAlignment=NSTextAlignmentLeft;
        title.textColor=[UIColor colorWithRed:51/255.f green:51/255.f blue:51/255.f alpha:1.0];
        [self addSubview:title];
        iconImage=[[UIImageView alloc]initWithFrame:CGRectMake(70,40,13, 13)];
        iconImage.image=[UIImage imageNamed:@"videoDownIcon"];
        [self addSubview:iconImage];
        label=[[UILabel alloc]initWithFrame:CGRectMake(90,40 , 100, 15)];
        label.textColor=[UIColor colorWithRed:128/255.f green:128/255.f blue:128/255.f alpha:1.0];
        label.font=[UIFont systemFontOfSize:13];
        
        [self addSubview:label];
        
        bigImage =[[UIImageView alloc]initWithFrame:CGRectMake(10, 7, 50, 50)];
        bigImage.image=[UIImage imageNamed:@"down_1"];
        
        [self addSubview:bigImage];
 

        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
