//
//  MyCoinBillViewController.m
//  e路WiFi
//
//  Created by JAY on 14-3-26.
//  Copyright (c) 2014年 HE ZHENJIE. All rights reserved.
//

#import "MyCoinBillViewController.h"
#import "MobClick.h"
#import "RootUrl.h"
#import "HttpManager.h"
#import "HttpRequest.h"
#import "AppDelegate.h"
#define SECRETKEY @"ilovewififorfree"
#import "GetCMCCIpAdress.h"
#import "WebSubPagViewController.h"
@interface MyCoinBillViewController ()

@end

@implementation MyCoinBillViewController
@synthesize myCoinNumber;
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
-(void)viewWillAppear:(BOOL)animated{

    [MobClick beginLogPageView:@"myCoinBill"];
    [self hideTabBar];
    self.tabBarController.tabBar.hidden=YES;
    [self.navigationController setNavigationBarHidden:YES];
}
-(void)buildLoadingAnimat{
    aniBg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 77, 77)];
    aniBg.image=[UIImage imageNamed:@"jiazaibg"];
    NSArray *imageArray=[NSArray arrayWithObjects:[UIImage imageNamed:@"tu1"],[UIImage imageNamed:@"tu2"],[UIImage imageNamed:@"tu3"],[UIImage imageNamed:@"tu4"], nil];
    loadingAni=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 77,77)];
    loadingAni.image=[UIImage imageNamed:@"tu1"];
    loadingAni.animationImages =imageArray;
    loadingAni.animationDuration = [loadingAni.animationImages count] * 1/5.0;
    loadingAni.animationRepeatCount = 100000;
    flag=0;
    loadingAni.center=aniBg.center;
    [aniBg addSubview:loadingAni];
    aniBg.center=CGPointMake(self.view.center.x, self.view.center.y+40);
    [self.view addSubview:aniBg];
    [aniBg setHidden:YES];
}

-(void)startAnimat{
    [aniBg setHidden:NO];
    loadingAni.animationRepeatCount = 100000;
    flag=1;
    [NSTimer scheduledTimerWithTimeInterval:50 target:self selector:@selector(stopAnimat) userInfo:nil repeats:NO];
    [loadingAni startAnimating];
}
-(void)stopAnimat{
    [aniBg setHidden:YES];
    flag=0;
    [loadingAni stopAnimating];
}
- (void)hideTabBar {
    if (self.tabBarController.tabBar.hidden == YES) {
        return;
    }
    UIView *contentView;
    if ( [[self.tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] ){
        contentView = [self.tabBarController.view.subviews objectAtIndex:1];
    }
    else{
        contentView = [self.tabBarController.view.subviews objectAtIndex:0];
        contentView.frame = CGRectMake(contentView.bounds.origin.x,  contentView.bounds.origin.y,  contentView.bounds.size.width, contentView.bounds.size.height + self.tabBarController.tabBar.frame.size.height);
        self.tabBarController.tabBar.hidden = YES;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    UIView * headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 44+SIZEABOUTIOSVERSION)];
    UIImageView *headerBackground=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320,44+SIZEABOUTIOSVERSION)];
    [headerView addSubview:headerBackground];
    headerBackground.image=[[UIImage imageNamed:@"gm_nav"]stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    [self.view addSubview:headerView];
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(110, 10+SIZEABOUTIOSVERSION, 100, 30)];
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.font=[UIFont systemFontOfSize:20];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [headerView addSubview:titleLabel];
    
    if ([_Type isEqualToString:@"1"]) {
         titleLabel.text=@"彩豆详情";
    }else{
         titleLabel.text=@"威望详情";
    }
   
    MyButton * goBack=[MyButton buttonWithType:UIButtonTypeCustom];
    goBack.frame=CGRectMake(0, SIZEABOUTIOSVERSION,50, 44);
    [goBack setNormalImage:[UIImage imageNamed:@"newBack"]];
    [goBack setSelectedImage:[UIImage imageNamed:@"newBack_d"]];
    [headerView addSubview:goBack];
    [goBack addTarget:self action:@selector(goBackToSuperPage)];
    
    MyButton*  clearButton=[MyButton buttonWithType:UIButtonTypeCustom];
    clearButton.frame=CGRectMake(270,SIZEABOUTIOSVERSION, 50, 44);
    [clearButton setNormalImage:[UIImage imageNamed:@"billdelete"]];
    [clearButton addTarget:self action:@selector(clearCoinBill)];
    [headerView addSubview:clearButton];

    if ([_Type isEqualToString:@"1"]) {
        clearButton.hidden=NO;
    }else{
    
        clearButton.hidden=YES;
        
    }
    UIImageView * moneyImage=[[UIImageView alloc]initWithFrame:CGRectMake(15, 55+SIZEABOUTIOSVERSION,21 , 21)];
    if ([_Type isEqualToString:@"1"]) {
        moneyImage.image=[UIImage imageNamed:@"goldIcon.png"];
    }else{
       moneyImage.image=[UIImage imageNamed:@"weiwang.png"];
        
    }
 
    [self.view addSubview:moneyImage];
    
    loginOrCoin=[[UIImageView alloc]initWithFrame:CGRectMake(45, 53+SIZEABOUTIOSVERSION, 100, 25)];
    
    loginOrCoin.image=[[UIImage imageNamed:@"but_red"]stretchableImageWithLeftCapWidth:10 topCapHeight:0];
    loginOrCoinLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 25)];
    loginOrCoinLable.backgroundColor=[UIColor clearColor];
    loginOrCoinLable.textColor=[UIColor whiteColor];

    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    
    if ([_Type isEqualToString:@"1"]) {
        
        if ([userDefaults objectForKey:@"coinNumber"]) {
            
            CGSize maxSize=CGSizeMake(250, 25);
            CGSize realSize=[[userDefaults objectForKey:@"coinNumber"] boundingRectWithSize:maxSize  options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:loginOrCoinLable.font} context:nil].size;
            loginOrCoin.frame=CGRectMake(45, 53+SIZEABOUTIOSVERSION, realSize.width+50, 25);
            loginOrCoinLable.frame=CGRectMake(0, 0 ,realSize.width+45, 25);
            loginOrCoinLable.text=nil;
            loginOrCoinLable.text= [NSString stringWithFormat:@"  %@彩豆",[userDefaults objectForKey:@"coinNumber"]];
        }else{
            loginOrCoinLable.text=@"0 彩豆";
        }
    }else{
        
        if ([userDefaults objectForKey:@"UserData"]) {
            
            CGSize maxSize=CGSizeMake(250, 25);
            CGSize realSize=[[userDefaults objectForKey:@"UserData"] boundingRectWithSize:maxSize  options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:loginOrCoinLable.font} context:nil].size;
            loginOrCoin.frame=CGRectMake(45, 53+SIZEABOUTIOSVERSION, realSize.width+50, 25);
            loginOrCoinLable.frame=CGRectMake(0, 0 ,realSize.width+45, 25);
            loginOrCoinLable.text=nil;
            loginOrCoinLable.text= [NSString stringWithFormat:@"  %@威望",[userDefaults objectForKey:@"UserData"]];
        }else{
            loginOrCoinLable.text=@"0 威望";
        }
    }
    
    loginOrCoinLable.textAlignment=NSTextAlignmentCenter;
    [loginOrCoin addSubview:loginOrCoinLable];
    [self.view addSubview:loginOrCoin];
    
    
    
    UILabel * getMoreCoinLabel=[[UILabel alloc]initWithFrame:CGRectMake(210,53+SIZEABOUTIOSVERSION,150, 20)];
    getMoreCoinLabel.backgroundColor=[UIColor clearColor];
    getMoreCoinLabel.textAlignment=NSTextAlignmentLeft;
    getMoreCoinLabel.font=[UIFont systemFontOfSize:15];
    getMoreCoinLabel.textColor=[UIColor colorWithRed:0/255.f green:172/255.f blue:238/255.f alpha:1.0];
    
    if ([_Type isEqualToString:@"1"]) {
        getMoreCoinLabel.text=@"获取更多彩豆";
    }else{
        getMoreCoinLabel.text=@"获取更多威望";
    }
    [self.view addSubview:getMoreCoinLabel];
    UIImageView*  arrowImage=[[UIImageView alloc]initWithFrame:CGRectMake(296, 53+SIZEABOUTIOSVERSION, 20, 20)];
    arrowImage.backgroundColor=[UIColor clearColor];
    arrowImage.image=[UIImage imageNamed:@"arrowsblue"];
    
    [self.view addSubview:arrowImage];
    MyButton * getMoreCoinButton=[MyButton buttonWithType:UIButtonTypeCustom];
    getMoreCoinButton.frame=CGRectMake(210,50+SIZEABOUTIOSVERSION,100, 30);
    [getMoreCoinButton addTarget:self action:@selector(getMoreCoin)];
    [self.view addSubview:getMoreCoinButton];
    
    FailBgView=[[UIView alloc]initWithFrame:CGRectMake(102,200,115,69+25+20)];
    FailBgView.hidden=YES;
    
    UIImageView * noDataImage=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,115,69)];
    [noDataImage setImage:[UIImage imageNamed:@"biaoqingforlose.png"]];
    [FailBgView addSubview:noDataImage];
    UILabel *bigWord=[[UILabel alloc]initWithFrame:CGRectMake(0,69,116,25)];
    bigWord.backgroundColor=[UIColor clearColor];
    bigWord.textAlignment=NSTextAlignmentCenter;
    bigWord.font=[UIFont boldSystemFontOfSize:17];
   
    [FailBgView addSubview:bigWord];
    UILabel *smallWord=[[UILabel alloc]initWithFrame:CGRectMake(-27,69+25,170,20)];
    smallWord.backgroundColor=[UIColor clearColor];
    smallWord.textColor=[UIColor grayColor];
    smallWord.font=[UIFont systemFontOfSize:13];
    smallWord.textAlignment=NSTextAlignmentCenter;
  
    [FailBgView addSubview:smallWord];
    
     if([_Type isEqualToString:@"1"]){
         
          bigWord.text=@"没有交易详情";
           smallWord.text=@"下手太慢了，赶紧去赚吧";
     }else {
     
         bigWord.text=@"您还没有威望";
         smallWord.text=@"每日凌晨批量更新所有威望";
     }
    billDataArray=[[NSMutableArray alloc]init];
    
    myTableView=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    myTableView.delegate=self;
    myTableView.dataSource=self;
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0) {
        [myTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    [self.view addSubview:myTableView];
    
    [self.view addSubview:FailBgView];
    
    noticeLabel=[[UILabel alloc]initWithFrame:CGRectMake(60, SCREENHEIGHT-130, 200, 26)];
    noticeLabel.layer.cornerRadius=5.f;
    noticeLabel.layer.masksToBounds=YES;
    noticeLabel.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    noticeLabel.textAlignment=NSTextAlignmentCenter;
    noticeLabel.font=[UIFont systemFontOfSize:13];
    noticeLabel.textColor=[UIColor whiteColor];
    [noticeLabel setHidden:YES];
    [self.view addSubview:noticeLabel];
    
    [self buildLoadingAnimat];
    NSUserDefaults *uerDefaults=[NSUserDefaults standardUserDefaults];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"hhmmss"];
    if ([_Type isEqualToString:@"1"]) {
        
        NSString *qString=[NSString stringWithFormat:@"mod=credit&uid=%@&ntime=%@",[uerDefaults objectForKey:@"userID"],[dateformatter stringFromDate:[NSDate date]]];
        NSData *secretData=[qString dataUsingEncoding:NSUTF8StringEncoding];
        NSData *qValueData=[secretData AES256EncryptWithKey:SECRETKEY];
        NSString *qValue=[qValueData newStringInBase64FromData];
        if([RootUrl getIsNetOn]||[[GetCMCCIpAdress getSSID]isEqualToString:@"16wifi"]){
            
            [self addTask: [NSString stringWithFormat:@"%@/app_api/credit/getUserCreditList.html?q=%@",NewBaseUrl,qValue]action:@selector(coinListRequest:)];
            [self startAnimat];
        }
    }else{
        NSString *qString=[NSString stringWithFormat:@"mod=getwwlist&uid=%@&ntime=%@",[uerDefaults objectForKey:@"userID"],[dateformatter stringFromDate:[NSDate date]]];
        NSData *secretData=[qString dataUsingEncoding:NSUTF8StringEncoding];
        NSData *qValueData=[secretData AES256EncryptWithKey:SECRETKEY];
        NSString *qValue=[qValueData newStringInBase64FromData];
        if([RootUrl getIsNetOn]||[[GetCMCCIpAdress getSSID]isEqualToString:@"16wifi"]){
            
            [self addTask: [NSString stringWithFormat:@"%@/app_api/credit/getWeiWangList.html?q=%@",NewBaseUrl,qValue]action:@selector(coinListRequest:)];
            [self startAnimat];
        }
        
    }
    

    
    // Do any additional setup after loading the view.
}
-(void)clearCoinBill{
    if ([_Type isEqualToString:@"1"]) {
        
        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"提示" message:@"清空所有彩豆信息记录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertview show];
    }
}


-(void)WwListRequest:(HttpRequest *)request{


    
    
}

-(void)coinListRequest:(HttpRequest *)request{
    [self stopAnimat];
    [curTaskDict removeObjectForKey:request.httpUrl];
    NSData *myData=[[[NSString alloc]initWithData:request.downloadData encoding:NSUTF8StringEncoding]dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSArray *ListdataArray=[[NSJSONSerialization JSONObjectWithData:myData options:NSJSONReadingAllowFragments error:&error]objectForKey:@"Contents"];
        if (error!=nil) {
            NSLog(@"json解析失败13");
            FailBgView.hidden=NO;
        }else{
            FailBgView.hidden=YES;
            if ([[NSString stringWithFormat:@"%@",ListdataArray]isEqualToString:@"<null>"]) {
                myTableView.frame=CGRectZero;
                FailBgView.hidden=NO;
                return;
            }
            for (NSDictionary * dic in ListdataArray) {
                CoinBillItem *item=[[CoinBillItem alloc]init];
                item.dealTime=[dic objectForKey:@"time"];
                item.dealArray=[dic objectForKey:@"content"];
                [billDataArray addObject:item];
            }
            myTableView.frame=CGRectMake(0,83+SIZEABOUTIOSVERSION,320, SCREENHEIGHT-83-20);
            [myTableView reloadData];
        }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        [billDataArray removeAllObjects];
        myTableView.frame=CGRectZero;
        [myTableView reloadData];
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"hhmmss"];
        NSLog(@"---------2 delete");
        NSUserDefaults *uerDefaults=[NSUserDefaults standardUserDefaults];
        NSString *qString=[NSString stringWithFormat:@"mod=delcredit&uid=%@&token=%@&ntime=%@",[uerDefaults objectForKey:@"userID"],[uerDefaults objectForKey:@"token"],[dateformatter stringFromDate:[NSDate date]]];
        NSData *secretData=[qString dataUsingEncoding:NSUTF8StringEncoding];
        NSData *qValueData=[secretData AES256EncryptWithKey:SECRETKEY];
        NSString *qValue=[qValueData newStringInBase64FromData];
        
        if([RootUrl getIsNetOn]||[[GetCMCCIpAdress getSSID]isEqualToString:@"16wifi"]){
            [self addTask:[NSString stringWithFormat:@"%@/app_api/credit/deleteCredit.html?q=%@",NewBaseUrl,qValue] action:@selector(clearList:)];
        
        }
    }
    
}
-(void)clearList:(HttpRequest *)clearList{

    [curTaskDict removeObjectForKey:clearList.httpUrl];
    
    NSError *error = nil;
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:clearList.downloadData options:NSJSONReadingAllowFragments error:&error];
    if (error!=nil) {
        NSLog(@"json解析失败14");
    }else{
        int a=[[dic objectForKey:@"ReturnCode"] intValue];
        NSLog(@"ContentsList%@",[dic objectForKey:@"Contents"]);
        if (a==101) {
            [self showNotice:[dic objectForKey:@"message"]];
        }
    }
    
}
-(void)showNotice:(NSString*)str{
    
    [noticeLabel setHidden:NO];
    CGSize maxSize=CGSizeMake(250,20);
//    CGSize realSize=[str sizeWithFont:noticeLabel.font constrainedToSize:maxSize lineBreakMode:NSLineBreakByCharWrapping];
    CGSize realSize=[str boundingRectWithSize:maxSize  options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:noticeLabel.font} context:nil].size;
    noticeLabel.frame=CGRectMake((310-realSize.width)/2, SCREENHEIGHT-130,realSize.width+10, 26);
    noticeLabel.text=str;
    [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(setHidNotice) userInfo:nil repeats:NO];
    
}
-(void)setHidNotice{
    [noticeLabel setHidden:YES];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myBillCell"];
    UILabel *title;
    UILabel *number;
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myBillCell"];
        UILabel *lable=[[UILabel alloc]initWithFrame:CGRectMake(265,10,30,15)];
     
        if ([_Type isEqualToString:@"1"]) {
            lable.text=@"彩豆";
        }else{
           lable.text=@"威望";
            
        }
        lable.font=[UIFont systemFontOfSize:15];
        lable.backgroundColor=[UIColor clearColor];
        [cell addSubview:lable];
        title=[[UILabel alloc]initWithFrame:CGRectMake(10,10,170,15)];
        title.font=[UIFont systemFontOfSize:15];
        title.backgroundColor=[UIColor clearColor];
        title.textAlignment=NSTextAlignmentLeft;
        title.tag=310;
        [cell addSubview:title];
        number=[[UILabel alloc]initWithFrame:CGRectMake(180,10,80,15)];
        number.font=[UIFont systemFontOfSize:15];
        number.textAlignment=NSTextAlignmentRight;
        number.backgroundColor=[UIColor clearColor];
        number.textColor=[UIColor redColor];
        number.tag=320;
        [cell addSubview:number];
        
    }else{
        number=(UILabel* )[cell viewWithTag:320];
        number.text=@"";
        title=(UILabel* )[cell viewWithTag:310];
        title.text=@"";
    }
    CoinBillItem *item=[billDataArray objectAtIndex:indexPath.section];
    NSDictionary *dic=[item.dealArray objectAtIndex:indexPath.row];
    
    title.text=[dic objectForKey:@"name"];
    if ([[dic objectForKey:@"ext_price"] intValue]>0) {
        number.text=[NSString stringWithFormat:@"+%@",[dic objectForKey:@"ext_price"]];
    }else{
        
        number.text=[dic objectForKey:@"ext_price"];
    }    
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [billDataArray count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35.f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1f;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    CoinBillItem *item=[billDataArray objectAtIndex:section];
    return [item.dealArray count];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 20)];
    titleLabel.textColor=[UIColor grayColor];
    titleLabel.font=[UIFont systemFontOfSize:13];
    titleLabel.backgroundColor=[UIColor colorWithRed:220/255.f green:220/255.f blue:220/255.f alpha:1.0];
    CoinBillItem *item=[billDataArray objectAtIndex:section];
    if ([item.dealTime isEqualToString:@"today"]) {
        titleLabel.text=@"    今天";
    }else{
        titleLabel.text=[NSString stringWithFormat:@"    %@",item.dealTime];
    }
    
    return titleLabel;
}
-(void)viewWillDisappear:(BOOL)animated{
    [MobClick endLogPageView:@"myCoinBill"];
//    self.tabBarController.tabBar.hidden=NO;
//    [self.navigationController setNavigationBarHidden:NO];
     [[HttpManager sharedManager]stopAllTask:curTaskDict];
    
}
-(void)getMoreCoin{
    if([_Type isEqualToString:@"1"]){
    
        [UIView animateWithDuration:1 animations:^{
            [self.navigationController popToRootViewControllerAnimated:NO];
        } completion:^(BOOL finished){
            
        }];
        
    }else{
        BackClick=YES;
        
        WebSubPagViewController *web=[[WebSubPagViewController alloc]init];
        NSString *filePath = [[NSBundle mainBundle]pathForResource:@"account" ofType:@"html"];
        NSURL *url = [NSURL fileURLWithPath:filePath];
        web.myRequest=[NSURLRequest requestWithURL:url];
        //    web.titleLabel.text=@"用户协议";
        [self presentViewController:web animated:YES completion:nil];

        
//        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"提示" message:@"待开发" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
//        [alertview show];
        
    }

}
-(void)viewDidDisappear:(BOOL)animated{

    if (BackClick) {
        
    }else{
        AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
        [app setTabBarSelected:1];
    }

}
-(void)goBackToSuperPage{
    BackClick=YES;
    if (_IsPresent) {
        [self dismissViewControllerAnimated:YES completion:nil];
 
    }else{
          [self.navigationController popViewControllerAnimated:YES];
    }

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
