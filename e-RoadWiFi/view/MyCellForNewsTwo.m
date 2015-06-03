//
//  MyCellForNewsTwo.m
//  16wifi2
//
//  Created by JAY on 13-5-6.
//  Copyright (c) 2013年 JAY. All rights reserved.
//

#import "MyCellForNewsTwo.h"

@implementation MyCellForNewsTwo

@synthesize title,content;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor=[UIColor clearColor];
        UIImageView *bg=[[UIImageView alloc]initWithFrame:CGRectMake(10, 7, 300, 70)];
        bg.image=[[UIImage imageNamed:@"bg_kuang"]stretchableImageWithLeftCapWidth:4 topCapHeight:4];
        [self addSubview:bg];
        title=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 280,20 )];
        title.font=[UIFont boldSystemFontOfSize:15];
        title.textColor=[UIColor colorWithRed:51/255.f green:51/255.f blue:51/255.f alpha:1.0];
        [bg addSubview:title];
        
        content=[[UILabel alloc]initWithFrame:CGRectMake(10,26 , 280, 40)];
        content.textColor=[UIColor colorWithRed:128/255.f green:128/255.f blue:128/255.f alpha:1.0];
        content.font=[UIFont systemFontOfSize:13];
        content.numberOfLines=2;
        [bg addSubview:content];
        

        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end