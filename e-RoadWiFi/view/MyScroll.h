//
//  MyScroll.h
//  16wifi2
//
//  Created by JAY on 13-4-28.
//  Copyright (c) 2013年 JAY. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MyScrollPressDelegate;
@interface MyScroll : UIScrollView{
    NSMutableArray* scorllImages;
   
    id<MyScrollPressDelegate>mdelegate;
}
@property(nonatomic,strong)id<MyScrollPressDelegate>mdelegate;
@property(nonatomic,strong)NSMutableArray* scorllImages;

- (id)initWithFrame:(CGRect)frame andWithDelegate:(id)delegate andWithPages:(int)page;
@end
@protocol MyScrollPressDelegate <NSObject>

-(void)pressButtonTag:(int)tag;

@end