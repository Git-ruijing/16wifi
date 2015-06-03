//
//  PWSCalendarDayCell.m
//  PWSCalendar
//
//  Created by Sylar on 3/14/14.
//  Copyright (c) 2014 PWS. All rights reserved.
//
////////////////////////////////////////////////////////////////////////
#import "PWSCalendarDayCell.h"
#import "PWSHelper.h"
////////////////////////////////////////////////////////////////////////
const NSString* PWSCalendarDayCellId = @"PWSCalendarDayCellId";
////////////////////////////////////////////////////////////////////////
@interface PWSCalendarDayCell()
{
    UILabel* m_date;
}
@property (nonatomic, strong) NSDate* p_date;
@end
////////////////////////////////////////////////////////////////////////
@implementation PWSCalendarDayCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self SetInitialValue];
    }
    return self;
}

- (void) SetInitialValue
{
    m_date = [[UILabel alloc] init];
    [m_date setFrame:self.bounds];
    [m_date setFrame:CGRectMake(10, 0, 24, 24)];
    m_date.backgroundColor=[UIColor clearColor];
//    m_date.backgroundColor=[UIColor colorWithRed:0/255.0f green:156/255.0f blue:235/255.0f alpha:1];;
    m_date.layer.masksToBounds = YES;
    m_date.layer.cornerRadius=12;
    m_date.tag=0;
    [m_date setText:@""];
    [m_date setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:m_date];
}

- (void) setSelected:(BOOL)selected
{
//    [super setSelected:selected];
//    if (selected)
//    {
//        if ([PWSHelper CheckSameDay:self.p_date AnotherDate:[NSDate date]])
//        {
//            [m_date setTextColor:[UIColor whiteColor]];
//        }
//        else
//        {
//            [m_date setTextColor:[UIColor whiteColor]];
//        }
//        [m_date setBackgroundColor:kPWSDefaultColor];
//    }
//    else
//    {
//        if ([PWSHelper CheckSameDay:self.p_date AnotherDate:[NSDate date]])
//        {
//            [m_date setTextColor:kPWSDefaultColor];
//        }
//        else
//        {
//            [m_date setTextColor:[UIColor blackColor]];
//        }
//        [m_date setBackgroundColor:[UIColor clearColor]];
//    }
}

- (void) SetDate:(NSDate*)_date
{
    NSString* day = @"";
    self.p_date = _date;
    
    if ([PWSHelper CheckSameDay:_date AnotherDate:[NSDate date]])
    {
        //当前 日期的颜色
        [m_date setTextColor:[UIColor blueColor]];
    }
    else
    {
        if ([PWSHelper CheckPreviousDay:_date AnotherDate:[NSDate date]]) {
            
            [m_date setTextColor:[UIColor blackColor]];
        }else{
            [m_date setTextColor:[UIColor grayColor]];
            
        }
    }

    
    m_date.backgroundColor=[UIColor clearColor];
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];

    for (NSString *  Signdate in [def objectForKey:@"SignDate"]) {
        
        if ([PWSHelper CheckSignDay:Signdate AnotherDate:_date]) {
            //在这判断最后一次签到时间
            
            m_date.backgroundColor=[UIColor colorWithRed:0/255.0f green:156/255.0f blue:235/255.0f alpha:1];;
            [m_date setTextColor:[UIColor whiteColor]];
            
        }
    }
    
    if (_date)
    {
        NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit|NSMonthCalendarUnit fromDate:_date];
        day = [NSString stringWithFormat:@"%@", @(dateComponents.day)];
        
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy"];
        NSInteger s1 = [[formatter stringFromDate:_date] integerValue];
        
            if ([[def objectForKey:@"SignMonth"] integerValue]==dateComponents.month && [[def objectForKey:@"SignYear"] integerValue]==s1) {
                
                if ([day integerValue] >[[def objectForKey:@"SignDay"] integerValue]-[[def objectForKey:@"QdTimes"] integerValue] &&  [day integerValue]  <= [[def objectForKey:@"SignDay"] integerValue]) {
                    
                    m_date.backgroundColor=[UIColor colorWithRed:0/255.0f green:156/255.0f blue:235/255.0f alpha:1];;
                    [m_date setTextColor:[UIColor whiteColor]];
                    
                }
            }
        
        }
    
    [m_date setText:day];
}


@end
