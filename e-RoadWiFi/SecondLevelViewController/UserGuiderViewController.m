//
//  UserGuiderViewController.m
//  e-RoadWiFi
//
//  Created by QC on 15/1/30.
//  Copyright (c) 2015年 G.MING. All rights reserved.
//

#import "UserGuiderViewController.h"
#import "MobClick.h"
#import "QeGuideViewController.h"
@interface UserGuiderViewController ()

@end

@implementation UserGuiderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    MyScrollView=[[UIScrollView alloc]init];
    MyScrollView.backgroundColor=[UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1];
    MyScrollView.showsHorizontalScrollIndicator=NO;
    MyScrollView.showsVerticalScrollIndicator=NO;
    [self creatNav];
    [self.view addSubview:MyScrollView];

    
    [self creatCellView];
}
-(void)creatNav{
    UIImageView *navView=[[UIImageView alloc]init];
    
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7) {
        navView.frame=CGRectMake(0, 0, 320, 64);
        MyScrollView.frame=CGRectMake(0, 64, 320, SCREENHEIGHT-64);
        MyScrollView.contentSize=CGSizeMake(320, SCREENHEIGHT-63);
        
    }else{
        navView.frame=CGRectMake(0, -20, 320, 64);
        MyScrollView.frame=CGRectMake(0, 44, 320, SCREENHEIGHT-44);
        MyScrollView.contentSize=CGSizeMake(320, SCREENHEIGHT-43);
    }
    navView.image=[UIImage imageNamed:@"gm_nav"];
    navView.userInteractionEnabled=YES;
    [self.view addSubview:navView];
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(120, 20, 80, 44)];
    titleLabel.text=@"用户指南";
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.font=[UIFont systemFontOfSize:20];
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.backgroundColor=[UIColor clearColor];
    [navView addSubview:titleLabel];
    UIButton *back=[UIButton buttonWithType:UIButtonTypeCustom];
    back.frame=CGRectMake(0, SIZEABOUTIOSVERSION, 50, 44);
    back.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"newBack_d"]];
    [back addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:back];
    
}

-(void)creatCellView{

    FristBgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-44-SIZEABOUTIOSVERSION)];
    FristBgView.backgroundColor=[UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1];
    [MyScrollView addSubview:FristBgView];
    
    HeadTitles=@[@"基本介绍",@"账号问题",@"上网问题",@"彩豆问题",@"运营商WiFi",@"商城问题",@"安全问题"];

    for (int i=0; i<HeadTitles.count; i++) {
        
        UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 10+(44+10)*i, SCREENWIDTH, 44)];
        bgView.backgroundColor=[UIColor whiteColor];
        [FristBgView addSubview:bgView];
        
        UIView *lineView1=[[UIView alloc]initWithFrame:CGRectMake(0,0,320, 0.5)];
        lineView1.backgroundColor=[UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:0.7];
        [bgView addSubview:lineView1];
        
        UIView *lineView2=[[UIView alloc]initWithFrame:CGRectMake(0,44,320, 0.5)];
        lineView2.backgroundColor=[UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:0.7];
        [bgView addSubview:lineView2];
        
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(0, 0, 320, 44);
        button.tag=12100+i;
        [button addTarget:self action:@selector(HelpBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:button];
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 12, 100, 20)];
        label.text=HeadTitles[i];
        label.font=[UIFont systemFontOfSize:15];
        label.textColor=[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
        [button addSubview:label];
        
        UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(300, 17, 7, 11)];
        image.image=[UIImage imageNamed:@"arrow"];
        [button addSubview:image];
    
    }

}
-(void)backButtonClick:(UIButton*)but{
  
    [self.navigationController popViewControllerAnimated:YES];
    //    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)HelpBtnClick:(UIButton *)button{
    NSDictionary *dict = @{@"type" : HeadTitles[button.tag-12100]};
    [MobClick event:@"guide" attributes:dict];
    
    QeGuideViewController *QVC=[[QeGuideViewController alloc]init];
    QVC.HeadTitle=HeadTitles[button.tag-12100];
    QVC.Index=button.tag-12100;
    [self.navigationController pushViewController:QVC animated:YES];
    
}
-(void)viewWillAppear:(BOOL)animated{
 
    [MobClick beginLogPageView:@"UserGuide"];
    
    self.tabBarController.tabBar.hidden=YES;
    self.navigationController.navigationBar.hidden=YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden=NO;
    self.navigationController.navigationBar.hidden=NO;
    [MobClick endLogPageView:@"UserGuide"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
