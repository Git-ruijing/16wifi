//
//  MyVideoViewController.m
//  e路WiFi
//
//  Created by JAY on 13-11-21.
//  Copyright (c) 2013年 HE ZHENJIE. All rights reserved.
//

#import "MyVideoViewController.h"
#import "VedioViewController.h"
#import "MobClick.h"
#define SYSTEMVERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define IOSVERSIONSMALL ([[[UIDevice currentDevice] systemVersion] floatValue]<7.0?20:0)
@interface MyVideoViewController ()

@end

@implementation MyVideoViewController
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
    self.view.backgroundColor=[UIColor whiteColor];
    DoneOrDoing=0;
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    videoArr=[NSMutableArray arrayWithArray:[defaults objectForKey:@"video"]];
    UIImageView * noDataImage=[[UIImageView alloc]initWithFrame:CGRectMake(102,200,115,69)];
    [noDataImage setImage:[UIImage imageNamed:@"biaoqingforlose.png"]];
    [self.view addSubview:noDataImage];
    UILabel *bigWord=[[UILabel alloc]initWithFrame:CGRectMake(92,270,136,25)];
    bigWord.backgroundColor=[UIColor clearColor];
    bigWord.textAlignment=NSTextAlignmentCenter;
    bigWord.font=[UIFont boldSystemFontOfSize:15];
    
    bigWord.text=@"还没有任何下载！";
    [self.view addSubview:bigWord];
    MyButton *getGoodsButton=[MyButton buttonWithType:UIButtonTypeCustom];
    
    getGoodsButton.frame=CGRectMake(60,310,200, 33);
    [getGoodsButton setNormalBackgroundImage:[[UIImage imageNamed:@"quxiao.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10]];
    [getGoodsButton setNTitle:@"前往下载，走你！"];
    [getGoodsButton addTarget:self action:@selector(gotoVideoPage)];
    [self.view addSubview:getGoodsButton];

    YFJtableView=[[YFJLeftSwipeDeleteTableView alloc]initWithFrame:CGRectMake(0,93+SIZEABOUTIOSVERSION, 320,SCREENHEIGHT-90-SIZEABOUTIOSVERSION)];
    YFJtableView.delegate=self;
    YFJtableView.tag=5801;
    YFJtableView.dataSource=self;
    YFJtableView.backgroundColor=[UIColor whiteColor];
    [YFJtableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:YFJtableView];
    if (videoArr.count==0) {
        [YFJtableView setHidden:YES];
    }
    nomalTableView=[[YFJLeftSwipeDeleteTableView alloc]initWithFrame:CGRectMake(0,93+SIZEABOUTIOSVERSION, 320,SCREENHEIGHT-90-SIZEABOUTIOSVERSION)];
    nomalTableView.delegate=self;
    nomalTableView.tag=5802;
    nomalTableView.dataSource=self;
    nomalTableView.backgroundColor=[UIColor whiteColor];
    [nomalTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:nomalTableView];
    [nomalTableView setHidden:YES];
    headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 115+SIZEABOUTIOSVERSION)];
    UIImageView *headerBackground=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320,95+SIZEABOUTIOSVERSION)];
    [headerView addSubview:headerBackground];
    headerBackground.image=[[UIImage imageNamed:@"gm_nav"]stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    [self.view addSubview:headerView];


    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(110, 10+SIZEABOUTIOSVERSION, 100, 30)];
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.font=[UIFont systemFontOfSize:20];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [headerView addSubview:titleLabel];
    titleLabel.text=@"下载管理";
    
    MyButton * goBack=[MyButton buttonWithType:UIButtonTypeCustom];
    goBack.frame=CGRectMake(0, SIZEABOUTIOSVERSION,50, 44);
    [goBack setNormalImage:[UIImage imageNamed:@"newBack"]];
    [goBack setSelectedImage:[UIImage imageNamed:@"newBack_d"]];
    [headerView addSubview:goBack];
    [goBack addTarget:self action:@selector(gohome)];
    
    BusInquiryBar* busBar=[[BusInquiryBar alloc]initWithFrame:CGRectMake(10, 50+SIZEABOUTIOSVERSION, 300, 35) andTag:@"0" andStretchCap:4 andWithDelegate:self];
    [busBar setButtonName:@"已下载" andWithButtonIndex:1];
    [busBar setButtonName:@"下载中" andWithButtonIndex:2];
    [headerView addSubview:busBar];
    
	// Do any additional setup after loading the view.
}
-(void)selectType:(int)type{
    switch (type) {
        case 0:
        {
            AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
            
            DoneOrDoing=0;
            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
            videoArr=[NSMutableArray arrayWithArray:[defaults objectForKey:@"video"]];
            if (videoArr.count==0) {
                [YFJtableView setHidden:YES];
                [nomalTableView setHidden:YES];
            }else{
            
                [nomalTableView setHidden:YES];
                [YFJtableView setHidden:NO];
                [YFJtableView reloadData];
            }
            app.downManageIsIn=0;
            break;
        }
        case 1:
        {
            AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
            
            DoneOrDoing=1;
            if (app.downingVideoArray.count==0) {
                [nomalTableView setHidden:YES];
                [YFJtableView setHidden:YES];
            
            }else{
                [nomalTableView setHidden:NO];
                [YFJtableView setHidden:YES];
                [nomalTableView reloadData];
            }
            app.downManageIsIn=1;
            break;
        }
        default:
            break;
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [MobClick endLogPageView:@"myvideo"];
    AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    app.downManageIsIn=0;
    self.tabBarController.tabBar.hidden=NO;
    [self.navigationController setNavigationBarHidden:NO];

}
-(void)viewWillAppear:(BOOL)animated{

    [MobClick beginLogPageView:@"myvideo"];
            self.tabBarController.tabBar.hidden=YES;
    [self.navigationController setNavigationBarHidden:YES];
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath

{
        return UITableViewCellEditingStyleDelete;
    
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
   
        return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        switch (tableView.tag) {
            case 5801:
            {
                NSString *sandBoxPath=NSHomeDirectory();
                NSString *vieoPath=[sandBoxPath stringByAppendingPathComponent:@"Library/Caches"];
                NSDictionary *dictionary=[videoArr objectAtIndex:indexPath.row];
                NSString *filePath=[vieoPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",[dictionary objectForKey:@"title"]]];
                NSFileManager *manager=[NSFileManager defaultManager];
                [manager removeItemAtPath:filePath error:Nil];
                [videoArr removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
                [defaults setObject:videoArr forKey:@"video"];
                [defaults synchronize];
                if (videoArr.count==0) {
                    [nomalTableView setHidden:YES];
                }
               
                break;
            }
            case 5802:
            {
                AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
                JAYDownload *JayDown=(JAYDownload *)[app.downingVideoArray objectAtIndex:indexPath.row];
                [JayDown cancel];
                if (app.downingVideoArray.count==0) {
                    [YFJtableView setHidden:YES];
                }
                [nomalTableView reloadData];
                break;
            }
            default:
                break;
        }
    
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (DoneOrDoing) {
        return;
    }else{
        [self playVideo:(int)indexPath.row];
    }
}
-(void)playVideo:(int)n{
    
    [[UIApplication sharedApplication]setStatusBarHidden:YES];
    isPlay=1;
    NSString *sandBoxPath=NSHomeDirectory();
    NSString *vieoPath=[sandBoxPath stringByAppendingPathComponent:@"Library/Caches"];
    NSDictionary *dictionary=[videoArr objectAtIndex:n];
    NSString *filePath=[vieoPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",[dictionary objectForKey:@"title"]]];

    NSURL *avUrl=[[NSURL alloc]initFileURLWithPath:filePath];
    PlayVedioViewController *playVedio=[[PlayVedioViewController alloc]init];
    playVedio.startTime=0.f;
    playVedio.isLocal=YES;
    playVedio.JayPlayerItem=[[AVPlayerItem alloc]initWithURL:avUrl];
    playVedio.vedioTitle=[dictionary objectForKey:@"title"];
    NSDictionary *dict = @{@"type" : [NSString stringWithFormat:@"%@_本地",[dictionary objectForKey:@"title"]]};
    [MobClick event:@"video_play" attributes:dict];
    [self presentViewController:playVedio animated:NO completion:^{}];
    
}



-(void)setValue:(NSString *)sch andWithTag:(int)tag{
    MyDowningCell *mycell=(MyDowningCell *)[nomalTableView viewWithTag:tag];
    int percent=[sch floatValue]*100;
    [mycell.downBar setPercent:percent animated:YES];
    
}
-(void)downloadFinish{
    AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    if (app.downingVideoArray.count==0) {
        [nomalTableView setHidden:YES];
        [YFJtableView setHidden:YES];
        
    }else{
    
        [nomalTableView reloadData];
    }
   
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (DoneOrDoing) {
        MyDowningCell * myCell=[[MyDowningCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyDowningCell"];
        
        AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
        JAYDownload *JayDown=(JAYDownload *)[app.downingVideoArray objectAtIndex:indexPath.row];
        myCell.title.text=JayDown.vName;
        myCell.label.text=JayDown.vTime;
        int percent=[JayDown.schedule floatValue]*100;
        [myCell.downBar setPercent:percent animated:YES];
        myCell.tag=999+indexPath.row;
        JayDown.delegate=self;
        JayDown.tag=(int)myCell.tag;
     
        [myCell.bigImage setImage:JayDown.videoImage];
        return myCell;
    }else{
        MyVideoCell *myCell=[tableView dequeueReusableCellWithIdentifier:@"myCell"];
        if (myCell==nil) {
            myCell=[[MyVideoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myCell"];
        }else{
            myCell.bigImage.image=nil;
            myCell.title.text=@"";
            myCell.label.text=@"";
        }
        NSDictionary *dic=[videoArr objectAtIndex:indexPath.row];
    
        myCell.title.text=[dic objectForKey:@"title"];
        myCell.label.text=[dic objectForKey:@"label"];
        [myCell.bigImage setImage:[UIImage imageWithData:[dic objectForKey:@"image"]]];
        return myCell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65.f;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (DoneOrDoing) {
        AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
        return app.downingVideoArray.count;
    }else{
        return videoArr.count;
    }
}
-(void)gotoVideoPage{
    VedioViewController *vedio=[[VedioViewController alloc]init];
    [self.navigationController pushViewController:vedio animated:YES];
}
-(void)gohome{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
