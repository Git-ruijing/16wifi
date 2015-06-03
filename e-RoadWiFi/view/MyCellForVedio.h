//
//  MyCellForVedio.h
//  16wifi2
//
//  Created by JAY on 13-5-2.
//  Copyright (c) 2013年 JAY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCellForVedio : UITableViewCell
@property(nonatomic ,strong)UILabel *title;
@property(nonatomic ,strong)UILabel *content;
@property(nonatomic ,strong)UIImageView *bigImage;
@property(nonatomic ,strong)UIImageView *goldImage;
@property(nonatomic ,strong)UILabel *goldLabel;
@property(nonatomic ,strong)UIButton *DownLoad;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier iconWeight:(int)weight IconHeight:(int)height andHeight:(int)SizeHeight;

@end
