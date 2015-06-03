//
//  InviteViewController.m
//  e-RoadWiFi
//
//  Created by QC on 14-10-22.
//  Copyright (c) 2014年 G.MING. All rights reserved.
//

#import "InviteViewController.h"
#import "HttpRequest.h"
#import "HttpManager.h"
#import "HttpDownload.h"
#import "RootUrl.h"
#import "Encryption.h"
#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "UIViewController+setTabBarStatus.h"
#import "MobClick.h"
#import "AppDelegate.h"
#import "MyButton.h"
#import "UIImageView+WebCache.h"
#import "FriendsInforViewController.h"
#import "GetCMCCIpAdress.h"
#import "MyDatabase.h"
#import "cityItem.h"
#import "CustomActionSheet.h"
@interface InviteViewController ()

@end

@implementation InviteViewController

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
    self.view.backgroundColor=[UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1];
    
    
    _scrollerView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 44+SIZEABOUTIOSVERSION, 320,SCREENHEIGHT-44-55-SIZEABOUTIOSVERSION)];
    _scrollerView.backgroundColor=[UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1];
    _scrollerView.showsHorizontalScrollIndicator=NO;
    _scrollerView.showsVerticalScrollIndicator=NO;
    _scrollerView.contentSize=CGSizeMake(320, SCREENHEIGHT-44-55-SIZEABOUTIOSVERSION);
    [self.view addSubview:_scrollerView];
    
    
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    FriendsArr=[NSArray arrayWithArray:[def objectForKey:@"InviteData"]];
    if (FriendsArr.count) {
        
        [self CreatFriendsList];
    }else{
        [self CreatNoFriendsView];
        
    }
    
    UIView* headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 44+SIZEABOUTIOSVERSION)];
    UIImageView *headerBackground=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320,44+SIZEABOUTIOSVERSION)];
    [headerView addSubview:headerBackground];
    headerBackground.image=[[UIImage imageNamed:@"gm_nav"]stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(110, 10+SIZEABOUTIOSVERSION, 100, 30)];
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.font=[UIFont systemFontOfSize:20];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [headerView addSubview:titleLabel];
    titleLabel.text=@"我的好友";
    MyButton * goBack=[MyButton buttonWithType:UIButtonTypeCustom];
    goBack.frame=CGRectMake(0, SIZEABOUTIOSVERSION,50, 44);
    [goBack setNormalImage:[UIImage imageNamed:@"newBack"]];
    [goBack setSelectedImage:[UIImage imageNamed:@"newBack_d"]];
    [headerView addSubview:goBack];
    [goBack addTarget:self action:@selector(gohome)];

    
    moreButton=[MyButton buttonWithType:UIButtonTypeCustom];
    moreButton.frame=CGRectMake(270,SIZEABOUTIOSVERSION, 50, 44);
    [moreButton setNormalImage:[UIImage imageNamed:@"shopemore.png"]];
    [moreButton addTarget:self action:@selector(showMyOwn)];
    [moreButton setHidden:YES];
    [headerView addSubview:moreButton];
    
    NSUserDefaults * userDefault=[NSUserDefaults standardUserDefaults];
    int isLogin=[[userDefault objectForKey:@"isLogin"]intValue];
    
    if (isLogin>1) {
        [moreButton setHidden:NO];
    }
    
    
    myOwnBg=[[UIView alloc]initWithFrame:CGRectMake(147,SIZEABOUTIOSVERSION+44-94,176,94)];
    myOwnBg.backgroundColor=[UIColor clearColor];
    
    showMyOwnFlag=0;
    MyButton *myObject=[MyButton buttonWithType:UIButtonTypeCustom];
    myObject.frame=CGRectMake(0, 0,176,47);
    [myObject setNormalImage:[UIImage imageNamed:@"tongxun.png"]];
    [myOwnBg addSubview:myObject];
    [myObject addTarget:self action:@selector(goMyContact)];
    
    MyButton *myCoinBill=[MyButton buttonWithType:UIButtonTypeCustom];
    myCoinBill.frame=CGRectMake(0, 46,176,47);
    [myCoinBill setNormalImage:[UIImage imageNamed:@"haoyou.png"]];
    [myOwnBg addSubview:myCoinBill];
    [myCoinBill addTarget:self action:@selector(AnotherFri)];
    [myOwnBg setHidden:YES];

    [self.view addSubview:myOwnBg];
    
    [self.view addSubview:headerView];
    
    
    MyButton *InviteButton=[MyButton buttonWithType:UIButtonTypeCustom];
    InviteButton.frame=CGRectMake(10,SCREENHEIGHT-55,300, 45);
    InviteButton.titleLabel.font=[UIFont systemFontOfSize:17];
    [InviteButton addTarget:self action:@selector(InviteFriends)];
    
    [InviteButton setNormalBackgroundImage:[[UIImage imageNamed:@"loginbut"] stretchableImageWithLeftCapWidth:10 topCapHeight:10]];
    [InviteButton setNTitle:@"邀请好友"];
    [InviteButton setNTitleColor:[UIColor whiteColor]];
    InviteButton.userInteractionEnabled=YES;
    [self.view addSubview:InviteButton];
    
    // Do any additional setup after loading the view.
}

-(void)goMyContact{

    
}

-(void)AnotherFri{

    
}

-(void)CreatNoFriendsView{

    UIImageView *head=[[UIImageView alloc]initWithFrame:CGRectMake((SCREENWIDTH-169)/2, 31, 169, 52)];
    head.image=[UIImage imageNamed:@"award"];
    [_scrollerView addSubview:head];
    
    
    UIImageView *bgView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 115, SCREENWIDTH-20, 200)];
    bgView.image=[[UIImage imageNamed:@"bg_blue"]stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    [_scrollerView addSubview:bgView];
    
    
    UILabel *Label=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 20)];
    Label.text=@"我的邀请码:";
    Label.textColor=[UIColor colorWithRed:0/255.f green:172/255.f blue:238/255.f alpha:1.0];
    Label.textAlignment=NSTextAlignmentLeft;
    [bgView addSubview:Label];
    
    
    UILabel *FristLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 10+30, 100, 20)];
    FristLabel.text=@"参与方式";
    FristLabel.textColor=[UIColor colorWithRed:0/255.f green:172/255.f blue:238/255.f alpha:1.0];
    FristLabel.textAlignment=NSTextAlignmentLeft;
    [bgView addSubview:FristLabel];
    
    NSArray *title=@[@"1、邀请好友下载并安装16WiFi客户端",@"2、好友输入邀请码注册,便成功完成任务"];
    for (int i=0; i<2; i++) {
        
        UILabel *info=[[UILabel alloc]initWithFrame:CGRectMake(10, 40+10+20+25*i, 290, 20)];
        info.text=title[i];
        info.textAlignment=NSTextAlignmentLeft;
        info.font=[UIFont systemFontOfSize:15];
        [bgView addSubview:info];
    }
    
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    UILabel *pin=[[UILabel alloc]initWithFrame:CGRectMake(10+100, 10, 100, 20)];
    pin.text=[def objectForKey:@"InvitePin"];
    pin.textAlignment=NSTextAlignmentLeft;
    pin.textColor=[UIColor redColor];
    pin.font=[UIFont systemFontOfSize:15];
    [bgView addSubview:pin];
  

    UILabel *guize=[[UILabel alloc]initWithFrame:CGRectMake(10, 10+10+20+25*2+40, 100, 20)];
    guize.text=@"规则";
    guize.textAlignment=NSTextAlignmentLeft;
    guize.textColor=[UIColor colorWithRed:0/255.f green:172/255.f blue:238/255.f alpha:1.0];
    [bgView addSubview:guize];
    
    
    UILabel *des=[[UILabel alloc]initWithFrame:CGRectMake(10, 10+10+20+25*2+20+20+20, 290, 40)];
    des.text=@"邀请好友加入，奖励彩豆和威望";
    des.textAlignment=NSTextAlignmentLeft;
    des.numberOfLines=2;
    des.font=[UIFont systemFontOfSize:15];
    [bgView addSubview:des];
    
}

-(void)showMyOwn{
    if (showMyOwnFlag) {
        showMyOwnFlag=0;
        
        [UIView animateWithDuration:0.5 animations:^{
            myOwnBg.frame=CGRectMake(147,SIZEABOUTIOSVERSION+44-94,176,94);
        } completion:^(BOOL finished){
            [myOwnBg setHidden:YES];
        }];
    }else{
        showMyOwnFlag=1;
        [myOwnBg setHidden:NO];
        [UIView animateWithDuration:0.5 animations:^{
            myOwnBg.frame=CGRectMake(147,SIZEABOUTIOSVERSION+44,176,94);
        }];
    }
    
}

-(void)hiddenMyOwnView{
    showMyOwnFlag=0;
    myOwnBg.frame=CGRectMake(147,SIZEABOUTIOSVERSION+44-94,176,94);
    [myOwnBg setHidden:YES];
    
}

-(void)CreatFriendsList{

    dataTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 44+SIZEABOUTIOSVERSION, 320,SCREENHEIGHT-44-55-SIZEABOUTIOSVERSION) style:UITableViewStylePlain];
    dataTableView.dataSource=self;
    dataTableView.delegate=self;
    dataTableView.backgroundColor=[UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1];
//    dataTableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    dataTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:dataTableView];
    
}

-(void)InviteFriends{

    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    [def setObject:@"0" forKey:@"ShareWxType"];
    [def synchronize];
    
    if ([RootUrl getIsNetOn]) {
       
        NSString *text=[NSString stringWithFormat:@"赞！公交车上有免费WiFi了，邀请码:%@  http://t.cn/RzpkJBD",_InvitationCode];
        
        UIImage* image=[UIImage imageNamed:@"shareIcon"];
        
        [[UMSocialControllerService defaultControllerService]setShareText:text shareImage:image socialUIDelegate:self];
        
        [UMSocialData defaultData].extConfig.wechatTimelineData.shareText=[NSString stringWithFormat:@"赞！公交车上有免费WiFi了，邀请码:%@ ",_InvitationCode];
        [UMSocialData defaultData].extConfig.wechatSessionData.shareText=[NSString stringWithFormat:@"赞！公交车上有免费WiFi了，邀请码:%@ ",_InvitationCode];
        [UMSocialData defaultData].extConfig.sinaData.shareText=[NSString stringWithFormat:@"赞！公交车上有免费WiFi了，邀请码:%@ ",_InvitationCode];
        [UMSocialData defaultData].extConfig.qqData.shareText=[NSString stringWithFormat:@"赞！公交车上有免费WiFi了，邀请码:%@ ",_InvitationCode];
        [UMSocialData defaultData].extConfig.smsData.shareText=text;
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;

        
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:UMENG_APPKEY
                                          shareText:text
                                         shareImage:image
                                    shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQzone,UMShareToQQ,UMShareToSina,UMShareToSms, nil]
                                           delegate:self];
        
    }else{
        UIAlertView *alterView=[[UIAlertView alloc]initWithTitle:@"16WiFi提示" message:@"当前网络不通,请在您认证上网后邀请小伙伴" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alterView show];
    }
    
    
}

-(void)gohome{
    
    [self.navigationController popViewControllerAnimated:NO];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        cell.backgroundColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView*  HeadPhoto=[[UIImageView alloc]initWithFrame:CGRectMake(10, 11, 54, 54)];
    if ([[[FriendsArr objectAtIndex:indexPath.row]objectForKey:@"headphoto"]hasPrefix:@"http"]) {
        
       [HeadPhoto setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[FriendsArr objectAtIndex:indexPath.row]objectForKey:@"headphoto"]]] placeholderImage:[UIImage imageNamed:@"gm_photo"]];
    }else{
           [HeadPhoto setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FormalBaseUrl,[[FriendsArr objectAtIndex:indexPath.row]objectForKey:@"headphoto"]]] placeholderImage:[UIImage imageNamed:@"gm_photo"]];
    }
    
        HeadPhoto.tag=15042300;
        [cell.contentView addSubview:HeadPhoto];
        
        
        UIImageView *bgimage=[[UIImageView alloc]initWithFrame:CGRectMake(10, 11, 54, 54)];
        bgimage.image=[UIImage imageNamed:@"HeadPhoto"];
        [cell.contentView addSubview:bgimage];
        
        UILabel *name=[[UILabel alloc]initWithFrame:CGRectMake(10+54+15, 10, 100, 25)];
        name.backgroundColor=[UIColor clearColor];
        name.font=[UIFont systemFontOfSize:15];
        name.tag=15042301;
    if ([[[FriendsArr objectAtIndex:indexPath.row]objectForKey:@"nick"]isEqualToString:@""]) {
            name.text=@"昵称";
    }else{
            name.text=[[FriendsArr objectAtIndex:indexPath.row]objectForKey:@"nick"];
    }

        CGSize maxSize=CGSizeMake(110,25);
    
        CGSize realSize=[name.text boundingRectWithSize:maxSize  options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:name.font} context:nil].size;
        name.frame=CGRectMake(10+54+15, 10, realSize.width, 25);
        name.textAlignment=NSTextAlignmentLeft;
        [cell.contentView addSubview:name];
        
        
        UILabel *introduce=[[UILabel alloc]initWithFrame:CGRectMake(10+54+15, 10+30, 220, 25)];
        introduce.backgroundColor=[UIColor clearColor];
        introduce.textAlignment=NSTextAlignmentLeft;
        introduce.tag=15042302;
        if ([[[FriendsArr objectAtIndex:indexPath.row]objectForKey:@"detail"]isEqualToString:@""]) {
            introduce.text=@"还没介绍自己";
        }else{
            introduce.text=[[FriendsArr objectAtIndex:indexPath.row]objectForKey:@"detail"];
        }
    
        introduce.textColor=[UIColor colorWithRed:80/255.0f green:80/255.0f blue:80/255.0f alpha:1];
        introduce.font=[UIFont systemFontOfSize:13];
        [cell.contentView addSubview:introduce];
    
    
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(10,74.5,310, 0.5)];
        lineView.backgroundColor=[UIColor colorWithRed:215/255.f green:217/255.f blue:223/255.f alpha:0.7];
        [cell.contentView addSubview:lineView];
    
        UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(300, 32, 7, 11)];
        image.image=[UIImage imageNamed:@"arrow"];
        [cell.contentView addSubview:image];
        
        
        UIImageView *level=[[UIImageView alloc]initWithFrame:CGRectMake(85+name.frame.size.width, 12, 55, 18)];
        level.image=[[UIImage imageNamed:@"huiyuan"]stretchableImageWithLeftCapWidth:10 topCapHeight:10];
        [cell.contentView addSubview:level];
        
        
        UILabel *lv=[[UILabel alloc]initWithFrame:CGRectMake(1, 0, 45, 18)];
        lv.backgroundColor=[UIColor clearColor];
        lv.textColor=[UIColor whiteColor];
        lv.textAlignment=NSTextAlignmentCenter;
        lv.tag=15042303;
        lv.text=[NSString stringWithFormat:@"%@",[[FriendsArr objectAtIndex:indexPath.row]objectForKey:@"lv"]];
        lv.font=[UIFont systemFontOfSize:12];
        [level addSubview:lv];


    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSLog(@"%@",[[FriendsArr objectAtIndex:indexPath.row]objectForKey:@"phone"]);
    //这里请求用户的信息
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"hhmmss"];
    NSString *QString=[NSString stringWithFormat:@"mod=getwwuserinfo&phone=%@&ntime=%@",[NSString stringWithFormat:@"%@",[[FriendsArr objectAtIndex:indexPath.row]objectForKey:@"phone"]],[dateformatter stringFromDate:[NSDate date]]];
    NSData *secretData=[QString dataUsingEncoding:NSUTF8StringEncoding];
    NSData *qValueData=[secretData AES256EncryptWithKey:SECRETKEY];
    NSString *qValue=[qValueData newStringInBase64FromData];
    if([RootUrl getIsNetOn]||[[GetCMCCIpAdress getSSID]isEqualToString:@"16wifi"]){
        [self addTask:[NSString stringWithFormat:@"%@/app_api/userInfo/getUserInfo.html?q=%@",NewBaseUrl,qValue] action:@selector(userInfoRequest:)];
    }
    
    FriendsInforViewController *fvc=[[FriendsInforViewController alloc]init];
    fvc.DataDic=[NSMutableDictionary dictionaryWithDictionary:[FriendsArr objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:fvc animated:YES];
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


-(void)userInfoRequest:(HttpRequest *)infoRequest{
    
    [curTaskDict removeObjectForKey:infoRequest.httpUrl];
    
    NSString *str=[[NSString alloc]initWithData:infoRequest.downloadData encoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary * sssdic=[NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding]options:NSJSONReadingAllowFragments error:&error];
    if (error!=nil) {
        NSLog(@"json解析失败144");
    }else{
        
        NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
        int returnCode=[[sssdic objectForKey:@"ReturnCode"]intValue];
        switch (returnCode) {
            case 102:
            {
                NSLog(@"q修改资料");
#pragma mark 设置城市 性别
                NSMutableArray *array=[[NSMutableArray alloc]init];
                NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];

                if ([[sssdic objectForKey:@"city"]isEqualToString:@"1"]||[[sssdic objectForKey:@"city"]isEqualToString:@"0"]) {
                    array=[NSMutableArray arrayWithArray: [[MyDatabase sharedDatabase]readData:1 count:0 model:[[cityItem alloc]init] where:@"city_id" value:@"0"]];
                }else{
                    array=[NSMutableArray arrayWithArray: [[MyDatabase sharedDatabase]readData:1 count:0 model:[[cityItem alloc]init] where:@"city_id" value:[sssdic objectForKey:@"city"]]];
                }
                if (array.count) {
                    cityItem *item=array[0];
                    [dic setObject:item.city_name forKey:@"FsCity"];
                    
                }

                if ([[sssdic objectForKey:@"sex"] integerValue]==1) {

                       [dic setObject:@"男"forKey:@"FsSex"];
                }else{
                      [dic setObject:@"女" forKey:@"FsSex"];
               
                }
              
                [dic setObject:[NSString stringWithFormat:@"%@",[sssdic objectForKey:@"ww"] ]forKey:@"weiwang"];
                [dic setObject:@"1" forKey:@"new"];
                
                [userDefaults setObject:dic forKey:@"friendsInfo"];
                [userDefaults synchronize];
                
                    break;
            }
            default:
                break;
        }
    }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return FriendsArr.count;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 75.0f;
}

-(void)viewWillDisappear:(BOOL)animated{
    [MobClick endLogPageView:@"InVite"];
}
-(void)viewWillAppear:(BOOL)animated{
    
    [self hideTabBar];
    
   
    [MobClick beginLogPageView:@"InVite"];

    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    
    _InviteNum=[def objectForKey:@"InviteNum"];
    _InvitationCode=[def objectForKey:@"InvitePin"];
    
    code.text=_InvitationCode;
    tips.text=[NSString stringWithFormat:@"您已成功邀请%d位好友",[_InviteNum intValue]];
    
    
}
-(void)dealloc{
    [[HttpManager sharedManager]stopAllTask:curTaskDict];
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
