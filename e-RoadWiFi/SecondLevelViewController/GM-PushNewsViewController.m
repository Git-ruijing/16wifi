//
//  GM-PushNewsViewController.m
//  e-RoadWiFi
//
//  Created by QC on 14-9-9.
//  Copyright (c) 2014年 G.MING. All rights reserved.
//

#import "GM-PushNewsViewController.h"
#import "GM-PushInfoViewController.h"
#import "MyDatabase.h"
#import "PushInfoItem.h"
#import "UMFeedback.h"
#import "UMFeedbackViewController.h"
#import "MobClick.h"
@interface GM_PushNewsViewController ()

@end

@implementation GM_PushNewsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden=YES;
    self.tabBarController.tabBar.hidden=YES;

    UIImageView *navView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 44+SIZEABOUTIOSVERSION)];
    navView.image=[UIImage imageNamed:@"gm_nav"];
    navView.userInteractionEnabled=YES;
    [self.view addSubview:navView];
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(120, SIZEABOUTIOSVERSION, 80, 44)];
    label.text=@"消息";
    label.textAlignment=NSTextAlignmentCenter;
    label.backgroundColor=[UIColor clearColor];
    label.font=[UIFont systemFontOfSize:20];
    label.textColor=[UIColor whiteColor];
    [navView addSubview:label];
    UIButton *back=[UIButton buttonWithType:UIButtonTypeCustom];
    back.frame=CGRectMake(0, SIZEABOUTIOSVERSION, 50, 44);
    back.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"newBack_d"]];
    [back addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:back];
    
    
    MyButton*  moreButton=[MyButton buttonWithType:UIButtonTypeCustom];
    moreButton.frame=CGRectMake(270,SIZEABOUTIOSVERSION, 50, 44);
    [moreButton setNormalImage:[UIImage imageNamed:@"shopemore.png"]];
    [moreButton addTarget:self action:@selector(moreButtonClick)];
    [navView addSubview:moreButton];

    
    pushInfo=[NSMutableArray array];
    noReadInfo=[NSMutableArray array];
    push =[NSMutableArray array];
    allInfo=[NSMutableArray array];
    
    CGRect frame=[[UIScreen mainScreen] bounds];
    frame.size.height-=64;
    frame.origin.y+=64;
    dataTableView=[[YFJLeftSwipeDeleteTableView alloc] initWithFrame:frame];
    dataTableView.dataSource=self;
    dataTableView.delegate=self;
    dataTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:dataTableView];

    // Do any additional setup after loading the view.
}

-(void)moreButtonClick{
    
    UIActionSheet *action=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"全部消息设为已读",@"清空所有消息",nil];
    [action showInView:self.view];
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        NSLog(@"已读所有");
        [[MyDatabase sharedDatabase]updataTable:[[PushInfoItem alloc]init ] setField:@"read" Value:@"1" where:nil value:nil];
        
    }else if (buttonIndex==1){
        NSLog(@"清空");
        [[MyDatabase sharedDatabase]deleteTable:[[PushInfoItem alloc]init]];
    }else{
        
    }
    [self showInfo];
    NSMutableArray * array=[NSMutableArray arrayWithArray:[[MyDatabase sharedDatabase] readData:1 count:0 model:[[PushInfoItem alloc]init] where:@"read" value:@"0"]];
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    [def setObject:[NSString stringWithFormat:@"%lu",(unsigned long)array.count] forKey:@"newsNO"];
    [def synchronize];
}
-(void)showInfo{

    [push removeAllObjects];
    [push addObjectsFromArray:[[MyDatabase sharedDatabase] readData:1 count:0 model:[[PushInfoItem alloc]init] grounBy:@"type" orderBy:@"read" desc:NO]];
    
    NSLog(@"push.cunt%lu",(unsigned long)push.count);
    if (push.count) {
        [allInfo removeAllObjects];
        for (int i=0; i<push.count; i++) {
            PushInfoItem *item=push[i];
            [allInfo addObject:[[MyDatabase sharedDatabase]readData:1 count:0 model:[[PushInfoItem alloc]init] where:@"type" value:[NSString stringWithFormat:@"%ld",(long)item.type] ]];
        }

        [dataTableView reloadData];
        
    }else{
        dataTableView.hidden=YES;
        UIImageView * noDataImage=[[UIImageView alloc]initWithFrame:CGRectMake(107,200,106,83)];
        [noDataImage setImage:[UIImage imageNamed:@"gm-noread"]];
        [self.view addSubview:noDataImage];
    }
    
    
}

-(void)backButtonClick{
    if (_isPush==0) {
        [self dismissViewControllerAnimated:YES completion:^{}];

    }
        [self.navigationController popViewControllerAnimated:YES];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId=@"InfoCellID";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        
        dataTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    }
    
    NSArray *subviews = [[NSArray alloc] initWithArray:cell.contentView.subviews];
    for (UIView *subview in subviews) {
        [subview removeFromSuperview];
    }
    if (allInfo.count) {
        
        titles=@[@"焦点资讯",@"流量钱包",@"同城活动",@"e路通知",@"有礼有你",@"联系我们",];
        headImage=@[@"gm-zixun",@"gm-liuliang",@"gm-huodong",@"gm-tongzhi",@"gm-jinbi",@"gm-call"];
        NSArray *array=allInfo[indexPath.row];
            PushInfoItem *item=[array lastObject];

            NSLog(@"item:%ld",(long)item.type);
            
            UIView *cellbg=[[UIView alloc]init];
            cellbg.frame=CGRectMake(0, 0, 320, 70);
            cellbg.backgroundColor=[UIColor whiteColor];
            [cell.contentView addSubview:cellbg];
            
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(60, 17, 100, 20)];
            label.text=titles[item.type];
            label.textColor=[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
            label.font=[UIFont systemFontOfSize:15];
            [cellbg addSubview:label];
        
            UILabel*  subTitle=[[UILabel alloc]initWithFrame:CGRectMake(60, 37, 200, 20)];
            subTitle.textColor=[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1];
            subTitle.font=[UIFont systemFontOfSize:13];
            subTitle.text=item.m;
            subTitle.tag=71001+indexPath.row;
            [cellbg addSubview:subTitle];
            
            UILabel*   date=[[UILabel alloc]initWithFrame:CGRectMake(240, 20, 80, 20)];
            date.textColor=[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1];
            date.font=[UIFont systemFontOfSize:13];
            date.text=item.time;
            date.tag=72001+indexPath.row;
            [cellbg addSubview:date];
            
            UIImageView *head=[[UIImageView alloc]initWithFrame:CGRectMake(10, 17, 36, 36)];
            head.image=[UIImage imageNamed:headImage[item.type]];
            [cellbg addSubview:head];
        
        UIView *lineView1=[[UIView alloc]initWithFrame:CGRectMake(10,70,300, 0.5)];
        lineView1.backgroundColor=[UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:0.7];
        [cellbg addSubview:lineView1];
        
            PushTips=[[UIImageView alloc]initWithFrame:CGRectMake(38, 15, 20, 15)];
            PushTips.image=[UIImage imageNamed:@"bg_red"];
            [cellbg addSubview:PushTips];
            UILabel * tip=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 20, 14)];
            tip.textAlignment=NSTextAlignmentCenter;
            tip.font=[UIFont systemFontOfSize:13];
            tip.backgroundColor=[UIColor clearColor];
            tip.textColor=[UIColor whiteColor];
            tip.tag=73001+indexPath.row;
            [PushTips addSubview:tip];
        
        NSArray *noRead=[[MyDatabase sharedDatabase]readData:1 count:0 model:[[PushInfoItem alloc]init] where:@"type" value:[NSString stringWithFormat:@"%ld",(long)item.type] andWhere:@"read" andValue:@"0" orderBy:@"time" desc:YES];
        
        tip.text=[NSString stringWithFormat:@"%lu",(unsigned long)noRead.count];
        if (noRead.count==0) {
            PushTips.hidden=YES;
        }
    }else{
        NSLog(@"没有推送消息");
    }
    return cell;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

 
    
    GM_PushInfoViewController *gvc=[[GM_PushInfoViewController alloc]init];
            NSLog(@"allinfo:%lu",(unsigned long)allInfo.count);
    for (PushInfoItem *item in [allInfo objectAtIndex:indexPath.row]) {
        
        if (item.type==0) {
           gvc.index=0;
        }else{
            gvc.index=1;
            [[MyDatabase sharedDatabase]updataTable:[[PushInfoItem alloc]init ] setField:@"read" Value:@"1" where:@"type" value:[NSString stringWithFormat:@"%ld",(long)item.type]];

        }
        gvc.headTitle=titles[item.type];
        gvc.type=item.type;
    }
    
    [self presentViewController:gvc animated:YES completion:nil];

    NSMutableArray * array=[NSMutableArray arrayWithArray:[[MyDatabase sharedDatabase] readData:1 count:0 model:[[PushInfoItem alloc]init] where:@"read" value:@"0"]];
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    [def setObject:[NSString stringWithFormat:@"%lu",(unsigned long)array.count] forKey:@"newsNO"];
    [def synchronize];
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath

{
    return UITableViewCellEditingStyleDelete;
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    
    return NO;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        NSLog(@"删除某类数据");
        // 这里是删除某类
        PushInfoItem *item=[push objectAtIndex:indexPath.row];
        [[MyDatabase sharedDatabase]deleteTableName:[[PushInfoItem alloc]init] where:@"type" value:[NSString stringWithFormat:@"%ld",(long)item.type]];
         }
    
    [self showInfo];
    

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 
     NSArray *array=[[MyDatabase sharedDatabase] readData:1 count:0 model:[[PushInfoItem alloc]init] grounBy:@"type" orderBy:@"read" desc:NO];
    return array.count;
    
}

- (void)showNativeFeedbackWithAppkey:(NSString *)appkey {
    //友盟意见反馈页面
    UMFeedbackViewController *feedbackViewController = [[UMFeedbackViewController alloc] init];
    feedbackViewController.appkey = appkey;
    [self.navigationController presentViewController:feedbackViewController animated:YES completion:nil];
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [MobClick endLogPageView:@"PushNews"];


}
-(void)viewWillAppear:(BOOL)animated{

    [self showInfo];

    [MobClick beginLogPageView:@"PushNews"];
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
