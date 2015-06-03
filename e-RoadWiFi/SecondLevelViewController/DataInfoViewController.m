//
//  DataInfoViewController.m
//  e-RoadWiFi
//
//  Created by QC on 14-9-17.
//  Copyright (c) 2014年 G.MING. All rights reserved.
//

#import "DataInfoViewController.h"
#import "UserShopViewController.h"
#import "AppDelegate.h"
#import "UserGuiderViewController.h"
#import "NewsChannelViewController.h"
#import "MobClick.h"
@interface DataInfoViewController ()

@end

@implementation DataInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (BOOL)shouldAutorotate
{
    return NO;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    [self addNavAndTitle:@"流量说明" withFrame:CGRectMake(0, 0, 320, 44+SIZEABOUTIOSVERSION)];
    _scrollerView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, 320,SCREENHEIGHT-64)];
    _scrollerView.showsHorizontalScrollIndicator=NO;
    _scrollerView.showsVerticalScrollIndicator=NO;
    _scrollerView.userInteractionEnabled=YES;
    _scrollerView.contentSize=CGSizeMake(320, SCREENHEIGHT+79);
    [self.view addSubview:_scrollerView];
    [self addInfo];
}
-(void)addInfo{
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 300,44)];
    label.text=@"1. 初始流量";
    label.textColor=[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
    label.font=[UIFont fontWithName:@"HelveticaNeue-Bold" size:17];
    [_scrollerView addSubview:label];

    UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(10, 34, 300,68)];
    label2.text=@"     成功注册为16WiFi会员后，我们将免费赠送你一定额度的初始流量，没有使用时间限制哦。当然，只送一次，用完后可在商城自行兑换。";
    label2.font=[UIFont systemFontOfSize:14];
    label2.numberOfLines=0;
    [_scrollerView addSubview:label2];
    
    UILabel *label3=[[UILabel alloc]initWithFrame:CGRectMake(10, 110, 300, 30)];
    label3.text=@"2. 流量使用";
        label3.font=[UIFont fontWithName:@"HelveticaNeue-Bold" size:17];
    label3.textColor=[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
    [_scrollerView addSubview:label3];
    
    UILabel *label4=[[UILabel alloc]initWithFrame:CGRectMake(10, 144, 300,25)];
    label4.text=@"     启动16WiFi并通过“一键上网”成功认证后，";
    label4.font=[UIFont systemFontOfSize:14];
    label4.numberOfLines=0;
    [_scrollerView addSubview:label4];
    
    UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(10, 152, 300,158)];
    lab.text=@"(                      ) 即可免费聊微信、刷微博，听在线音乐、看在线视频······上网过程中产生的所有流量将从会员账号的剩余流量中扣除，这跟你的流量包月木有半毛钱关系，大可放心！\n\n      你说什么？流量用完了怎么办？\n\n      Good question！往下看。";
    lab.font=[UIFont systemFontOfSize:14];
    lab.numberOfLines=0;
    lab.userInteractionEnabled=YES;
    [_scrollerView addSubview:lab];
    
    UILabel *touchlabel=[[UILabel alloc]initWithFrame:CGRectMake(17, 157, 100, 30)];
    touchlabel.text=@"查看如何使用";
    touchlabel.textColor=[UIColor blueColor];
        touchlabel.font=[UIFont systemFontOfSize:14];
    [_scrollerView addSubview:touchlabel];
    
    UIButton *but=[UIButton buttonWithType:UIButtonTypeCustom];
    but.frame=CGRectMake(17, 157, 100, 30);
    but.tag=50211;
    [but addTarget:self action:@selector(btn:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollerView addSubview:but];
    
    UILabel *label5=[[UILabel alloc]initWithFrame:CGRectMake(10, 325, 300, 30)];
    label5.text=@"3. 流量兑换";
    label5.font=[UIFont fontWithName:@"HelveticaNeue-Bold" size:17];
    label5.textColor=[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
    [_scrollerView addSubview:label5];
    
    UILabel *label6=[[UILabel alloc]initWithFrame:CGRectMake(10, 365, 300,168)];
    label6.text=@"     很抱歉地说，当剩余流量≤0，你将无法通过16WiFi上网啦！求我们也没用。\n\n    好消息是：流量可以拿彩豆兑换！             \n\n      更好的消息是，在你浏览频道内容的同时（如资讯、视频等）会获得好多彩豆，下载我们为你推荐的应用、游戏、小说等等也会惊喜不断，根本停不下来！除此之外，做做（       ）也不错哦！";
    label6.font=[UIFont systemFontOfSize:14];
    label6.numberOfLines=0;
    [_scrollerView addSubview:label6];
    
    UILabel *touchlabel1=[[UILabel alloc]initWithFrame:CGRectMake(245, 408, 100, 30)];
    touchlabel1.text=@"立即兑换";
    touchlabel1.textColor=[UIColor blueColor];
    touchlabel1.font=[UIFont systemFontOfSize:14];
    [_scrollerView addSubview:touchlabel1];
    
    UIButton *but1=[UIButton buttonWithType:UIButtonTypeCustom];
    but1.frame=CGRectMake(245, 408, 100, 30);
    but1.tag=50212;
    [but1 addTarget:self action:@selector(btn:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollerView addSubview:but1];
    
    
    UILabel *touchlabel2=[[UILabel alloc]initWithFrame:CGRectMake(248, 492, 100, 30)];
    touchlabel2.text=@"任务";
    touchlabel2.textColor=[UIColor blueColor];
    touchlabel2.font=[UIFont systemFontOfSize:14];
    [_scrollerView addSubview:touchlabel2];
    
    UIButton *but2=[UIButton buttonWithType:UIButtonTypeCustom];
    but2.frame=CGRectMake(248, 492, 100, 30);
    but2.tag=50213;
    [but2 addTarget:self action:@selector(btn:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollerView addSubview:but2];
    
    
    
//    
//    UILabel *touchlabel3=[[UILabel alloc]initWithFrame:CGRectMake(110, 508, 100, 30)];
//    touchlabel3.text=@"去看看";
//    touchlabel3.textColor=[UIColor blueColor];
//    touchlabel3.font=[UIFont systemFontOfSize:14];
//    [_scrollerView addSubview:touchlabel3];
//    
//    UIButton *but3=[UIButton buttonWithType:UIButtonTypeCustom];
//    but3.frame=CGRectMake(110, 508, 100, 30);
//    but3.tag=50214;
//    [but3 addTarget:self action:@selector(btn:) forControlEvents:UIControlEventTouchUpInside];
//    [_scrollerView addSubview:but3];
    
}
-(void)btn:(UIButton *)object{
    if (object.tag==50211) {
        UserGuiderViewController *guide=[[UserGuiderViewController alloc]init];
        [self.navigationController pushViewController:guide animated:YES];
    }else if (object.tag==50212){
        UserShopViewController *svc=[[UserShopViewController alloc]init];
        [self.navigationController pushViewController:svc animated:YES];
    }else if (object.tag==50213){
        [UIView animateWithDuration:0 animations:^{
            [self.navigationController popToRootViewControllerAnimated:NO];
        } completion:^(BOOL finished){
            AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
            [app setTabBarSelected:1];
        }];
        
    }else{
        NewsChannelViewController *cvc=[[NewsChannelViewController alloc]init];
        [self.navigationController pushViewController:cvc animated:YES];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden=YES;
    self.tabBarController.tabBar.hidden=YES;

    [MobClick beginLogPageView:@"DataInfo"];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.hidden=NO;
    self.tabBarController.tabBar.hidden=NO;
     [MobClick endLogPageView:@"DataInfo"];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
