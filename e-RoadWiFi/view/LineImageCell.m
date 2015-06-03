//
//  LineImageCell.m
//  e路WiFi
//
//  Created by JAY on 13-12-12.
//  Copyright (c) 2013年 HE ZHENJIE. All rights reserved.
//

#import "LineImageCell.h"

@implementation LineImageCell
@synthesize label,bigImage;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        label=[[UILabel alloc]initWithFrame:CGRectMake(111,10,23,20)];
        label.backgroundColor=[UIColor clearColor];
        label.textAlignment=NSTextAlignmentCenter;
        label.font=[UIFont systemFontOfSize:11];
        label.textColor=[UIColor whiteColor];
        bigImage=[[UIImageView alloc]initWithFrame:CGRectMake(111,0,23, 40)];
        self.backgroundColor=[UIColor clearColor];
        
        [self addSubview:bigImage];
        [self addSubview:label];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
