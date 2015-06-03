//
//  wendu_yuan2.m
//  2014621
//
//  Created by 孔凡群 on 14-6-30.
//  Copyright (c) 2014年 孔凡群. All rights reserved.
//

#import "wendu_yuan2.h"
#import "yuan2_sc.h"
#import "yuan2_zj.h"

@implementation wendu_yuan2
//托空间初始化
-(void)awakeFromNib{
    [self setchushihua];
}

//代码创建初始化
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    [self setchushihua];
    return  self;
}

-(void)setchushihua{
    angle=0;
    _kd = 8;//圆弧的宽度
    _sc = [[yuan2_sc alloc]init];
    _sc.backgroundColor = [UIColor clearColor];
    _zj = [[yuan2_zj alloc]init];
    _zj.backgroundColor = [UIColor clearColor];
    [self insertSubview:_zj atIndex:1];
    [self insertSubview:_sc atIndex:2];
    
    
    image=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 268,246)];
    image.image=[UIImage imageNamed:@"ve_03.png"];
    image.transform=CGAffineTransformMakeRotation(((135-(_z*270))*-M_PI)/180);
    [self addSubview:image];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(84, 80, 100, 20)];
    label.text=@"平均速度";
    label.backgroundColor=[UIColor clearColor];
    label.textAlignment=NSTextAlignmentCenter;
    label.textColor=[UIColor whiteColor];
    [self addSubview:label];
    
    speed=[[UILabel alloc]initWithFrame:CGRectMake(84,100 , 100, 45)];
    speed.font=[UIFont systemFontOfSize:40];
    speed.textAlignment=NSTextAlignmentCenter;
    speed.textColor=[UIColor whiteColor];
    speed.text=@"0";
    [self addSubview:speed];
    
    
    _dw=[[UILabel alloc]initWithFrame:CGRectMake(104, 145, 60, 20)];
    _dw.text=@"KB/S";
    _dw.font=[UIFont systemFontOfSize:15];
    _dw.textAlignment=NSTextAlignmentCenter;
    _dw.textColor=[UIColor whiteColor];
    [self addSubview:_dw];
    
}


//重绘方法
-(void)drawRect:(CGRect)rect{
    
    [self draw_scdcdt:rect];
    [self draw_jishu:rect];
    
}

//添加计数器
-(void)draw_jishu:(CGRect)rect{
 
    speed.font=[UIFont systemFontOfSize:40];
    if (_z<=0.25) {
        speed.text=[NSString stringWithFormat:@"%.1f",_z*512];
    }else if (_z>0.25&&_z <=0.5){
    
        speed.text=[NSString stringWithFormat:@"%.1f",(_z*1536)-256];
    }else if (_z>0.5&&_z <=0.75){
    
        speed.text=[NSString stringWithFormat:@"%.1f",(_z*2048)-512];
        if ((_z*2048)-512>=1000) {
            speed.font=[UIFont systemFontOfSize:33];
        }
    }else{
         speed.text=[NSString stringWithFormat:@"%.2f",((((_z*4)-3)*7*1024)+1024)/1024];
        
    }
    
    
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.5];
//    [UIView setAnimationBeginsFromCurrentState:YES];
//    image.transform=CGAffineTransformMakeRotation(((135-(_z*270))*-M_PI)/180);
//        [UIView commitAnimations];
    
    
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveLinear
     
                     animations:^{ // 执行的动画code
                         image.layer.transform = CATransform3DMakeRotation(((135-(_z*270))*-M_PI)/180,0,0,1);
                     }
                     completion:nil];
    NSLog(@"yuan2:_z:%f  image.transform%f",_z,(((135-(_z*270))*-M_PI)/180));
}

//添加上层,中间层，底层
-(void)draw_scdcdt:(CGRect)rect{
    _sc.frame = rect;
    _zj.frame = rect;
    //宽度，值，宽度
    _sc.sc_kd = _kd+5;
    _zj.z = _z;
    _zj.zj_kd = _kd;
    
}



-(void)setKd:(float)kd{
    _kd = kd>20?20:kd;
    [self setNeedsDisplay];
}
-(void)setZ:(float)z{
    _z = z;
    [self setNeedsDisplay];
}
@end
