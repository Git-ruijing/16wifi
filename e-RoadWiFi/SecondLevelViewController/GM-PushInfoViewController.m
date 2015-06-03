//
//  GM-PushInfoViewController.m
//  e-RoadWiFi
//
//  Created by QC on 14-9-9.
//  Copyright (c) 2014年 G.MING. All rights reserved.
//

#import "GM-PushInfoViewController.h"
#import "RootUrl.h"
#import "PushInfoItem.h"
#import "MyDatabase.h"
#import "MobClick.h"
#import "YFJLeftSwipeDeleteTableView.h"
#import "WebSubPagViewController.h"
#import "PushInfoItem.h"
@interface GM_PushInfoViewController ()
@end
@implementation GM_PushInfoViewController
@synthesize index;

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
    temp=[[NSString alloc]init];
    temp=@"2014-01-01";
    
    pushInfo=[NSMutableArray array];
    if (index) {
        [self addNavAndTitle:_headTitle withFrame:CGRectMake(0, 0, 320, 64)];
    }else{
        UIImageView *navView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 44+SIZEABOUTIOSVERSION)];
        navView.image=[UIImage imageNamed:@"gm_nav"];
        navView.userInteractionEnabled=YES;
        [self.view addSubview:navView];
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(120, SIZEABOUTIOSVERSION, 80, 44)];
        label.text=@"焦点资讯";
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
    }
    
    CGRect frame=[[UIScreen mainScreen] bounds];
    frame.size.height-=64;
    frame.origin.y+=64;
    dataTableView=[[YFJLeftSwipeDeleteTableView alloc] initWithFrame:frame style:UITableViewStylePlain ];
    dataTableView.dataSource=self;
    dataTableView.delegate=self;

    dataTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:dataTableView];
}
-(void)moreButtonClick{

    UIActionSheet *action=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"全部消息设为已读",@"清空所有消息",nil];
    [action showInView:self.view];
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        NSLog(@"已读所有");
    [[MyDatabase sharedDatabase]updataTable:[[PushInfoItem alloc]init ] setField:@"read" Value:@"1" where:@"type" value:@"0"];
        
    }else if (buttonIndex==1){
        NSLog(@"清空");
        [[MyDatabase sharedDatabase]deleteTableName:[[PushInfoItem alloc]init] where:@"type" value:@"0"];
    }else{
    
    }
    [self showInfo];
    
    NSMutableArray * array=[NSMutableArray arrayWithArray:[[MyDatabase sharedDatabase] readData:1 count:0 model:[[PushInfoItem alloc]init] where:@"read" value:@"0"]];
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    [def setObject:[NSString stringWithFormat:@"%lu",(unsigned long)array.count] forKey:@"newsNO"];
    [def synchronize];
    
}

-(void)backButtonClick{
//    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)showInfo{
    [pushInfo removeAllObjects];
    
[pushInfo addObjectsFromArray:[[MyDatabase sharedDatabase]readData:1 count:0 model:[[PushInfoItem alloc]init] where:@"type" value:[NSString stringWithFormat:@"%ld",(long)_type] andWhere:nil andValue:nil orderBy:@"time" desc:NO]];
    
    if (pushInfo.count) {
        [dataTableView reloadData];
    }else{
        dataTableView.hidden=YES;
        UIImageView * noDataImage=[[UIImageView alloc]initWithFrame:CGRectMake(107,200,106,83)];
        [noDataImage setImage:[UIImage imageNamed:@"gm-noread"]];
        [self.view addSubview:noDataImage];
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
#pragma mark 这里数据应该排序 第一类按照read 其他按时间 ？？
    
    if (index==0) {
        static NSString *cellId=@"newsCellID";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            dataTableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
        }
        NSArray *subviews = [[NSArray alloc] initWithArray:cell.contentView.subviews];
        for (UIView *subview in subviews) {
            [subview removeFromSuperview];
        }
        
        if (pushInfo.count) {
        
            PushInfoItem *item=[pushInfo objectAtIndex:indexPath.row];
            UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 200, 20)];
            title.text=item.t;
            title.font=[UIFont systemFontOfSize:15];
            [cell.contentView addSubview:title];
            
            UILabel *des=[[UILabel alloc]initWithFrame:CGRectMake(10, 25, 300, 40)];
            des.text=item.m;
            NSLog(@"des:%@",des.text);
            
            des.font=[UIFont systemFontOfSize:13];
            des.numberOfLines=2;
            [cell.contentView addSubview:des];
            
            UIImageView *status=[[UIImageView alloc]initWithFrame:CGRectMake(220,7, 16, 16)];
            [cell.contentView addSubview:status];
            
            UILabel *time=[[UILabel alloc]initWithFrame:CGRectMake(240, 5, 100, 20)];
            time.text=item.time;
            time.font=[UIFont systemFontOfSize:13];
            [cell.contentView addSubview:time];
            
            if (item.read) {
                NSLog(@"已读");
                title.textColor=[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:0.6];
                des.textColor=[UIColor colorWithRed:128/255.0f green:128/255.0f blue:128/255.0f alpha:0.6];
                status.image=[UIImage imageNamed:@"gm-read"];
                time.textColor=[UIColor colorWithRed:128/255.0f green:128/255.0f blue:128/255.0f alpha:0.6];
            }else{
                NSLog(@"未读");
                title.textColor=[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
                des.textColor=[UIColor colorWithRed:128/255.0f green:128/255.0f blue:128/255.0f alpha:1];
                status.image=[UIImage imageNamed:@"gm-unread"];
                time.textColor=[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
            }
        }else{
            NSLog(@"没有推送消息");
        }
        
        return cell;

    }else{
    
        static NSString *cellId=@"cellID";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            
            dataTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        }
        
        
        NSArray *subviews = [[NSArray alloc] initWithArray:cell.contentView.subviews];
        for (UIView *subview in subviews) {
            [subview removeFromSuperview];
        }
        
        [pushInfo removeAllObjects];
        
        [pushInfo addObjectsFromArray:[[MyDatabase sharedDatabase]readData:1 count:0 model:[[PushInfoItem alloc]init] where:@"type" value:[NSString stringWithFormat:@"%ld",(long)_type] andWhere:nil andValue:nil orderBy:@"_j_msgid" desc:YES]];
        
        if (pushInfo.count) {
       
            PushInfoItem *item=[pushInfo objectAtIndex:indexPath.row];
            
            UILabel *time=[[UILabel alloc]initWithFrame:CGRectMake(0, 5, 320, 20)];
            time.backgroundColor=[UIColor clearColor];
            time.text=item.time;
            time.font=[UIFont systemFontOfSize:13];
            time.textColor=[UIColor colorWithRed:178/255.0f green:178/255.0f blue:178/255.0f alpha:1];
            time.textAlignment=NSTextAlignmentCenter;
            [cell.contentView addSubview:time];
            
            UIImageView *bgview=[[UIImageView alloc]init];
            bgview.image=[[UIImage imageNamed:@"denglu_bg"]stretchableImageWithLeftCapWidth:10 topCapHeight:10];
            [cell.contentView addSubview:bgview];
            
            UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 280, 20)];
            title.backgroundColor=[UIColor clearColor];
            title.font=[UIFont systemFontOfSize:15];
            title.textAlignment=NSTextAlignmentLeft;
            title.text=item.t;
            [bgview addSubview:title];
          
            subtitle=[[UILabel alloc]initWithFrame:CGRectMake(10, 25, 280, 40)];
            subtitle.backgroundColor=[UIColor clearColor];
            subtitle.font=[UIFont systemFontOfSize:13];
            subtitle.textColor=[UIColor colorWithRed:178/255.0f green:178/255.0f blue:178/255.0f alpha:1];
            subtitle.textAlignment=NSTextAlignmentLeft;
            subtitle.numberOfLines=0;
            subtitle.text=item.m;
            [bgview addSubview:subtitle];
            
        
            UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(10, 74, 80, 20)];
            [button addTarget:self action:@selector(btn:) forControlEvents:UIControlEventTouchUpInside];
            button.tag=74000+indexPath.row;
            
            [bgview addSubview:button];
            
            UILabel *detail=[[UILabel alloc]initWithFrame:CGRectMake(10, 64, 80, 20)];
            detail.backgroundColor=[UIColor clearColor];
            detail.font=[UIFont systemFontOfSize:13];
            detail.text=@"查看详情";
            detail.textColor=[UIColor colorWithRed:0 green:172/255.0f blue:238/255.0f alpha:1];
            [bgview addSubview:detail];
            detail.hidden=YES;

            CGSize maxSize=CGSizeMake(250,200);
            CGSize realSize=[subtitle.text boundingRectWithSize:maxSize  options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:subtitle.font} context:nil].size;
            subtitle.frame=CGRectMake(10, 25, 280, realSize.height);
            
            if (![item.h isEqualToString:@""]) {
                detail.hidden=NO;
                bgview.frame=CGRectMake(10, 30, 300, 94-40+realSize.height);
                detail.frame=CGRectMake(10, bgview.frame.size.height-30, 80, 20);
                
            }else{

                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                
                bgview.frame=CGRectMake(10, 30, 300, 67-40+realSize.height);
            }
            
        }else{
            NSLog(@"没有推送消息");
        }

        
        
        
        
        return cell;
        
    }
    
}
-(void)btn:(UIButton *)button{

    PushInfoItem *item=[pushInfo objectAtIndex:button.tag-74000];
    WebSubPagViewController *wvc=[[WebSubPagViewController alloc]init];
    if ([item.h hasPrefix:@"http"]) {
        wvc.myRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:item.h]];
    }else{
        wvc.myRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",[RootUrl getContentUrl],item.h]]];
    }
    wvc.isPush=0;
    wvc.GoBack=YES;
    [self presentViewController:wvc animated:YES completion:nil];
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PushInfoItem *item=[pushInfo objectAtIndex:indexPath.row];

    if (![item.h isEqualToString:@""]) {
        WebSubPagViewController *wvc=[[WebSubPagViewController alloc]init];
        if ([item.h hasPrefix:@"http"]) {
            wvc.myRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:item.h]];
        }else{
            wvc.myRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",[RootUrl getContentUrl],item.h]]];
        }
        wvc.isPush=0;
        wvc.GoBack=YES;
        [self presentViewController:wvc animated:YES completion:nil];
        [[MyDatabase sharedDatabase]updataTable:[[PushInfoItem alloc]init ] setField:@"read" Value:@"1" where:@"_j_msgid" value:item._j_msgid];
    }else{
    
    }
    
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
    if (index==0) {
        return YES;
    }else{
        return NO;
    }
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        NSLog(@"删除某条数据");
        PushInfoItem *item=[pushInfo objectAtIndex:indexPath.row];
        [[MyDatabase sharedDatabase]deleteTableName:[[PushInfoItem alloc]init] where:@"_j_msgid" value:item._j_msgid];
        [self showInfo];
    }

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (index==0) {
        return 67;
    }else{
    
        PushInfoItem *item=[pushInfo objectAtIndex:indexPath.row];
        if (![item.h isEqualToString:@""]) {
            return 134-40+subtitle.frame.size.height;
        }else{
        
            return 107-40+subtitle.frame.size.height;
        }
    }
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
            return pushInfo.count;

}
-(void)viewWillAppear:(BOOL)animated{
    [self showInfo];

    [MobClick beginLogPageView:@"gmPush"];
}
-(void)viewWillDisappear:(BOOL)animated{
    [MobClick endLogPageView:@"gmPush"];
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
