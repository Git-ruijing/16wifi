//
//  MyScorllBar.h
//  16wifi2
//
//  Created by JAY on 13-4-25.
//  Copyright (c) 2013年 JAY. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MyScorllBarDelegate;
@interface MyScorllBar : UIView
{
    UIImageView *scrollView;
    UIView *backgroundView;
}
@property (nonatomic,unsafe_unretained)id<MyScorllBarDelegate>delegate;
- (id)initWithFrame:(CGRect)frame  andWithDelegate:(id)mdelegate;
@end
@protocol MyScorllBarDelegate <NSObject>
-(void)selectButIndex:(int)index;
@end

