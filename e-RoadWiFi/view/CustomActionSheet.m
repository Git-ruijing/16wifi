//
//  CustomActionSheet.m
//  e-RoadWiFi
//
//  Created by QC on 14-12-5.
//  Copyright (c) 2014年 G.MING. All rights reserved.
//

#import "CustomActionSheet.h"
#import "MyButton.h"
@implementation CustomActionSheet


-(id)initWithViewHeight:(float)_height WithSheetTitle:(NSString *)_title
{
    
    self = [super initWithTitle:nil
                       delegate:nil
              cancelButtonTitle:@" "
         destructiveButtonTitle:nil
              otherButtonTitles:nil];
   
    if (self) {
        [self setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
        // Initialization code
        
        int theight =  _height- 50;
        
        int btnnum = theight/50;
        
        for(int i=0; i<btnnum; i++)
            
        {
            
            [self addButtonWithTitle:@" "];
            
        }
//    _height=244;
        _customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, _height-28)];
        
        _customView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _customView.backgroundColor = [UIColor whiteColor];

        
        [self addSubview:_customView];
    
        MyButton * cancelButton=[MyButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame=CGRectMake(10, 84, 300, 44);
        [cancelButton setNTitleColor:[UIColor blackColor]];
        [cancelButton setNormalBackgroundImage:[[UIImage imageNamed:@"ACbut.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10]];
        [cancelButton setHighlightedBackgroundImage:[[UIImage imageNamed:@"ACbut_d.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10]];
        [cancelButton setNTitle:@"完成"];
        cancelButton.titleLabel.font=[UIFont systemFontOfSize:20];
        [cancelButton addTarget:self action:@selector(btn:)];
        [self addSubview:cancelButton];
     
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel)];
        tapGesture.delegate = self;
        [self addGestureRecognizer:tapGesture];
        
    }
    return self;
}
-(void)tappedCancel{
    [self dismissWithClickedButtonIndex:1 animated:YES];
    [self.delegate actionSheet:self clickedButtonAtIndex:1];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if([touch.view isKindOfClass:[self class]]){
        return YES;
    }
    return NO;
}
-(void)btn:(UIButton *)buttton{
    [self dismissWithClickedButtonIndex:1 animated:YES];
    [self.delegate actionSheet:self clickedButtonAtIndex:1];
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (actionSheet.cancelButtonIndex == buttonIndex) {
        NSLog(@"取消");
    }
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
