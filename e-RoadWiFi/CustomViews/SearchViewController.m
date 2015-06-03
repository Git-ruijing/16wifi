//
//  SearchViewController.m
//  e路WiFi
//
//  Created by JAY on 13-12-4.
//  Copyright (c) 2013年 HE ZHENJIE. All rights reserved.
//

#import "SearchViewController.h"
#import "MyButton.h"
#import "MyDatabase.h"
#import "HttpRequest.h"
#import "HttpManager.h"
#import "searchItem.h"
#import "MyImageView.h"
#import "HotSearchItem.h"
#import "WebSubPagViewController.h"
#import "MobClick.h"
#import "RootUrl.h"
#import "AppDelegate.h"
@interface SearchViewController ()

@end

@implementation SearchViewController

@synthesize isLineOfTurn,delegate,tag;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}
-(void)dealloc
{
    [[HttpManager sharedManager] stopAllTask:curTaskDict];
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor=[UIColor whiteColor];
    hotSearch=[[NSMutableArray alloc]init];
    searchArray=[[NSMutableArray alloc]init];
    [self addTask:HotSearch action:@selector(hotSearchFinished:)];
    
    HistoryArray=[NSMutableArray arrayWithArray:[[MyDatabase sharedDatabase]readData:1 count:0 model:[[searchItem alloc]init]grounBy:nil orderBy:nil desc:YES]];
    
    myTabView=[[UITableView alloc]initWithFrame:CGRectMake(0,44, 320,SCREENHEIGHT-49-64-44-44)];
    myTabView.bounces=YES;
    myTabView.delegate=self;
    myTabView.dataSource=self;
    myTabView.backgroundColor=[UIColor whiteColor];
    //    myTabView.backgroundColor=[UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1];
    [self.view addSubview:myTabView];
    TabFrame=CGRectMake(0,44, 320,SCREENHEIGHT-49-64-44-44);
    
    [self creatSearchBar];
    myScroller=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320,44)];
    myScroller.bounces=YES;
    
}

-(void)hotSearchFinished:(HttpRequest *)request{
    
    [curTaskDict removeObjectForKey:request.httpUrl];
    NSError *error;
    NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:request.downloadData options:NSJSONReadingMutableContainers error:&error];
    if (dict) {
        
        NSDictionary *info=dict[@"info"];
        NSArray *array=info[@"contents"];
        
        for (NSDictionary *dic in array) {
            
            HotSearchItem *item=[[HotSearchItem alloc]init];
            [item setValuesForKeysWithDictionary:dic];
            [hotSearch addObject:item];
            
        }
        
        isLoading=NO;
    }else{
        
        NSLog(@"%@",error);
        
    }
    [myTabView reloadData];
    
}
-(void)creatSearchBar{
    
    UIImageView *headerBackground=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320,44+SIZEABOUTIOSVERSION)];
    headerBackground.image=[[UIImage imageNamed:@"gm_nav"]stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    headerBackground.userInteractionEnabled=YES;
    [self.view addSubview:headerBackground];
    
    mySearchBar=[[UISearchBar alloc]initWithFrame:CGRectMake(10, 7+SIZEABOUTIOSVERSION,250, 30)];
    mySearchBar.backgroundImage=[[UIImage imageNamed:@"search"]stretchableImageWithLeftCapWidth:12 topCapHeight:12];
    mySearchBar.tag=40001;
    mySearchBar.placeholder=@"输入搜索关键字                  ";
    mySearchBar.delegate=self;
    [mySearchBar becomeFirstResponder];
    [headerBackground addSubview:mySearchBar];
    
    MyButton *cancelButton=[MyButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame=CGRectMake(265, 7+SIZEABOUTIOSVERSION, 50, 29);
    [cancelButton setNTitle:@"取消"];
    [cancelButton setTitleColor:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:0.3] forState:UIControlStateHighlighted];
    [cancelButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [cancelButton addTarget:self action:@selector(backSuperView)];
    [headerBackground addSubview:cancelButton];
    
}

-(void)creatClearButton{
    
    clearButton=[MyButton buttonWithType:UIButtonTypeCustom];
    myTabView.frame=TabFrame;
    clearButton.frame=CGRectMake(10, 55+SIZEABOUTIOSVERSION+myTabView.frame.size.height+10, 300, 40);
    clearButton.tag=4001;
    [clearButton addTarget:self action:@selector(clearHistory:) forControlEvents:UIControlEventTouchUpInside];
    [clearButton setNTitle:@"清除当前记录"];
    [clearButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [clearButton setTitleColor:[UIColor colorWithRed:0/255.0f green:172/255.0f blue:238/255.0f alpha:1] forState:UIControlStateNormal];
    clearButton.titleLabel.font=[UIFont systemFontOfSize:16];
    [clearButton setNormalBackgroundImage:[[UIImage imageNamed:@"button"]stretchableImageWithLeftCapWidth:10 topCapHeight:10]];
    [clearButton setHighlightedBackgroundImage:[[UIImage imageNamed:@"button_d"]stretchableImageWithLeftCapWidth:10 topCapHeight:10]];
    [self.view addSubview:clearButton];
    
}
-(void)clearHistory:(UIButton *)Button{
    
    NSLog(@"清除数据库");
    UIAlertView *alterView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"是否清空访问记录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认" ,nil];
    [alterView show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.cancelButtonIndex == buttonIndex) {
        NSLog(@"取消");
    }else{
        NSLog(@"确定");
        [[MyDatabase sharedDatabase]deleteTable:[[searchItem alloc]init]];
        HistoryArray=nil;
        clearButton.hidden=YES;
        [myTabView reloadData];
        creat=NO;
    }
    
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HistoryArray=[NSMutableArray arrayWithArray:[[MyDatabase sharedDatabase]readData:1 count:0 model:[[searchItem alloc]init]grounBy:nil orderBy:@"no" desc:NO]];
    
    UITableViewCell *myCell=[tableView dequeueReusableCellWithIdentifier:@"myCell"];
    
    if (myCell==nil) {
        myCell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myCell"];
        myCell.selectionStyle=UITableViewCellSeparatorStyleNone;
    }
    NSArray *subviews = [[NSArray alloc] initWithArray:myCell.contentView.subviews];
    for (UIView *subview in subviews) {
        [subview removeFromSuperview];
    }
    if (HistoryArray.count) {
        
        UIImageView *history=[[UIImageView alloc]initWithFrame:CGRectMake(10,11.5 , 21, 21)];
        history.image=[UIImage imageNamed:@"gm_history"];
        [myCell.contentView addSubview:history];
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(40, 0, 300, 44)];
        label.textAlignment=NSTextAlignmentLeft;
        searchItem *item=[HistoryArray objectAtIndex:indexPath.row];
        myScroller.hidden=YES;
        label.text=item.keyWord;
        label.font=[UIFont systemFontOfSize:14];
        [myCell.contentView addSubview:label];
        
        UIView *lineView1=[[UIView alloc]initWithFrame:CGRectMake(10,44,310, 0.5)];
        lineView1.backgroundColor=[UIColor colorWithRed:215/255.f green:217/255.f blue:223/255.f alpha:0.7];
        [myCell.contentView addSubview:lineView1];
        
    }else{
        
        MyImageView *setBag=[[MyImageView alloc]initWithFrame:CGRectMake(0, 0, 300,44)andWithRadius:0];
        setBag.backgroundColor=[UIColor whiteColor];
        
        [myCell.contentView addSubview:setBag];
        
        for (int i=0; i<2; i++) {
            HotSearchItem *item=[hotSearch objectAtIndex:indexPath.row*2+i];
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            button.frame=CGRectZero;
            button.tag=3500+indexPath.row*2+i;
            [setBag addSubview:button];
            
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectZero];
            //                label.backgroundColor=[UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1];
            [label setNumberOfLines:1];
            label.textAlignment=NSTextAlignmentCenter;
            label.font=[UIFont systemFontOfSize:14];
            NSString *hotWord=item.linkName;
            label.text=hotWord;
            UIFont *font = [UIFont fontWithName:@"Arial" size:16];
            CGSize size=CGSizeMake(300, 300);
#pragma mark 修改label宽度
//            CGSize labelSize=[ hotWord sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
            
            CGSize labelSize=[hotWord boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
            
            [label setFrame:CGRectMake(0, 0, labelSize.width, 30)];
            //                [button setFrame:CGRectMake((10+(temp.width+arc4random()%10+10) *(i%2)), (10+44*(i/2)), labelSize.width, labelSize.height)];
     
            [button setFrame:CGRectMake((10+(temp.width+10) *(i%2)), (10+44*(i/2)), labelSize.width, labelSize.height+10)];
            button.backgroundColor=[UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1];
            temp=labelSize;
            [button addSubview:label];
            [button addTarget:self action:@selector(btn:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return myCell;
}
-(void)btn:(UIButton *)button{
    NSLog(@"%ld",(long)button.tag);
        HotSearchItem *item=[hotSearch objectAtIndex:button.tag-3500];
        NSString *url=[NSString stringWithFormat:@"http://www.baidu.com/s?wd=%@",item.linkName];
        NSString *newUrlStr = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        searchItem *searchitem=[[searchItem alloc]init];
        [searchitem setValue:item.linkName forKey:@"keyWord"];
        [searchitem setValue:@"1" forKey:@"count"];
        [searchArray removeAllObjects];
        [searchArray addObject:searchitem];
        [[MyDatabase sharedDatabase]insertArray:searchArray];
        
        WebSubPagViewController *wvc=[[WebSubPagViewController alloc]init];
        wvc.myRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:newUrlStr]];
        //    wvc.titleLabel.text=@"百度";
        [self presentViewController:wvc animated:YES completion:nil];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (HistoryArray.count) {
        return HistoryArray.count;
    }else{
        return hotSearch.count/2;
        clearButton.hidden=YES;
    }
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 320,44);
    btn.backgroundColor=[UIColor whiteColor];
    btn.tag = section+3400;
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 12, 150, 20)];
    label.font=[UIFont systemFontOfSize:17];
    label.textColor=[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1];
    if (HistoryArray.count!=0) {
        label.text=nil;
        label.text=@"历史记录";
        
        myTabView.frame=TabFrame;
        myTabView.separatorStyle=UITableViewCellSeparatorStyleNone;
        
        
    }else{
        label.text=nil;
        clearButton.hidden=YES;
        label.text=@"热门搜索";
        CGRect frame=TabFrame;
        frame.size.height+=150;
        myTabView.frame=frame;
        myTabView.separatorStyle=UITableViewCellSeparatorStyleNone;
    }
    label.textAlignment=NSTextAlignmentLeft;
    [btn addSubview:label];
    
    UIView *lineView1=[[UIView alloc]initWithFrame:CGRectMake(0,44,320, 0.5)];
    lineView1.backgroundColor=[UIColor colorWithRed:215/255.f green:217/255.f blue:223/255.f alpha:0.7];
    [btn addSubview:lineView1];
    
    
    return btn;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    searchItem *item=[HistoryArray objectAtIndex:indexPath.row];
    NSString *url=[NSString stringWithFormat:@"http://www.baidu.com/s?wd=%@",item.keyWord];
    NSString *newUrlStr = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    if (self.tag==410) {
        
        WebSubPagViewController *wvc=[[WebSubPagViewController alloc]init];
        wvc.myRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:newUrlStr]];
        //    wvc.titleLabel.text=@"百度";
        [self presentViewController:wvc animated:YES completion:nil];

    }else{
    
        if ([item.keyWord hasPrefix:@"http://"]) {
        
            [RootUrl setRootUrl:item.keyWord];
        }else{
        
            [RootUrl setRootUrl:[NSString stringWithFormat:@"http://%@",item.keyWord]];
        
        }
        NSLog(@"HISTORYsetUrl:%@",[RootUrl getRootUrl]);
        AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
        [app checkChannelsData];
        
        UIAlertView *alterView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"已切换到测试站点" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [alterView show];
        
        [self backSuperView];
}
    [mySearchBar resignFirstResponder];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 44;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.f;
}

-(void)backSuperView{
    //  [self dismissViewControllerAnimated:YES completion:^{}];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    if (isLoading) {
        return;
    }
    NSDictionary *dict2 = @{@"type" : searchBar.text};
    [MobClick event:@"webSearch" attributes:dict2];
    NSString *url=[NSString stringWithFormat:@"http://www.baidu.com/s?wd=%@",searchBar.text];
#pragma mark 数据库插入数据
    searchItem *item=[[searchItem alloc]init];
    
    [item setValue:searchBar.text forKey:@"keyWord"];
    [item setValue:@"1" forKey:@"count"];
    [searchArray removeAllObjects];
    [searchArray addObject:item];
    for (searchItem *item in HistoryArray ) {
        if ([searchBar.text isEqualToString:item.keyWord]) {
            NSLog(@"曾经搜索过");
            break;
        }
    }
    [[MyDatabase sharedDatabase]insertArray:searchArray];
    NSString *newUrlStr = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if (self.tag==410) {
        WebSubPagViewController *wvc=[[WebSubPagViewController alloc]init];
        wvc.myRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:newUrlStr]];
        [self presentViewController:wvc animated:YES completion:nil];
        searchBar.text=nil;
    }else{
        
        if ([searchBar.text hasPrefix:@"http://"]) {
        
            [RootUrl setRootUrl:searchBar.text];
        }else{
     
            [RootUrl setRootUrl:[NSString stringWithFormat:@"http://%@",searchBar.text]];
            
        }
        AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
        [app checkChannelsData];
        
        UIAlertView *alterView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"已切换到测试站点" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [alterView show];
        
        [self backSuperView];
    }

    NSLog(@"setUrl:%@",[RootUrl getRootUrl]);
}

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UISearchBar *seach=(UISearchBar *)[self.view viewWithTag:40001];
    [seach resignFirstResponder];
    
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UISearchBar *seach=(UISearchBar *)[self.view viewWithTag:40001];
    [seach resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [searchBar resignFirstResponder];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    UISearchBar *seach=(UISearchBar *)[self.view viewWithTag:40001];
    [seach resignFirstResponder];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    UISearchBar *seach=(UISearchBar *)[self.view viewWithTag:40001];
    [seach resignFirstResponder];
}
-(void)viewWillAppear:(BOOL)animated{

    [MobClick beginLogPageView:@"searchPage"];
    if ([RootUrl getUMLogClickFlag]) {
        NSDictionary *dict2 = @{@"type" : @"insearsh"};
        [MobClick event:@"loginNet_isRun" attributes:dict2];
        [RootUrl setUMLogClickFlag:0];
    }
    self.tabBarController.tabBar.hidden=YES;
    HistoryArray=[NSMutableArray arrayWithArray:[[MyDatabase sharedDatabase]readData:1 count:0 model:[[searchItem alloc]init]grounBy:nil orderBy:nil desc:YES]];
    
    if (HistoryArray.count) {
        if (!creat) {
            [self creatClearButton];
            creat=YES;
        }
        
    }
    [myTabView reloadData];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [MobClick endLogPageView:@"searchPage"];
    self.tabBarController.tabBar.hidden=NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
