//
//  BusInquiryBar.h
//  e路WiFi
//
//  Created by JAY on 13-12-4.
//  Copyright (c) 2013年 HE ZHENJIE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyButton.h"
@protocol BusInquiryBarDelegate;
@interface BusInquiryBar : UIView
{
    MyButton *but1;
    MyButton *but2;
}
@property(nonatomic,unsafe_unretained)id<BusInquiryBarDelegate>delegate;
@property(nonatomic,strong)UIImageView * redPoint;
- (id)initWithFrame:(CGRect)frame andTag:(NSString *)tag andStretchCap:(NSInteger)cap andWithDelegate:(id)mdelegate;
-(void)setButtonName:(NSString *)buttonName andWithButtonIndex:(int)index;
-(void)changeNavCtr:(MyButton*)button;

@end
@protocol BusInquiryBarDelegate <NSObject>
-(void)selectType:(int)type;
@end
