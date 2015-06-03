//
//  MyTitleScrollBar.h
//  16wifi2
//
//  Created by JAY on 13-5-2.
//  Copyright (c) 2013年 JAY. All rights reserved.
//


#import <UIKit/UIKit.h>
@protocol MyTitleScorllBarDelegate;
@interface MyTitleScrollBar : UIView

@property(nonatomic,unsafe_unretained)id<MyTitleScorllBarDelegate>delegate;
- (id)initWithFrame:(CGRect)frame  andWithDelegate:(id)mdelegate;
@end
@protocol MyTitleScorllBarDelegate <NSObject>
-(void)selectButtonIndex:(int)index;
@end