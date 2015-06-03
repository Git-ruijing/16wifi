//
//  MyTitleBarForMyGoods.h
//  e路WiFi
//
//  Created by JAY on 14-4-2.
//  Copyright (c) 2014年 HE ZHENJIE. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MyTitleBarForMyGoodsDelegate;
@interface MyTitleBarForMyGoods : UIView
@property(nonatomic,unsafe_unretained)id<MyTitleBarForMyGoodsDelegate>delegate;
- (id)initWithFrame:(CGRect)frame  andWithDelegate:(id)mdelegate;
@end
@protocol MyTitleBarForMyGoodsDelegate <NSObject>
-(void)selectButtonIndex:(int)index;
@end
