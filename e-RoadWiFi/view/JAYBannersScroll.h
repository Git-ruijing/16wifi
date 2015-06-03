//
//  JAYBannersScroll.h
//  e路WiFi
//
//  Created by JAY on 14-4-16.
//  Copyright (c) 2014年 HE ZHENJIE. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol JAYBannersScrollDelegate;
@interface JAYBannersScroll : UIScrollView{
    NSMutableArray* scorllImageArray;
    id<JAYBannersScrollDelegate>mdelegate;
}
@property(nonatomic,retain)id<JAYBannersScrollDelegate>mdelegate;
@property(nonatomic,retain)NSMutableArray* scorllImageArray;

- (id)initWithFrame:(CGRect)frame andWithDelegate:(id)delegate andWithPage:(int)pages;
@end
@protocol JAYBannersScrollDelegate <NSObject>

-(void)pressButtonTag:(int)tag;
@end
