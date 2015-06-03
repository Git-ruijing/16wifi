//
//  QeGuideViewController.m
//  e-RoadWiFi
//
//  Created by QC on 15/2/2.
//  Copyright (c) 2015年 G.MING. All rights reserved.
//

#import "QeGuideViewController.h"
#import "MobClick.h"
@interface QeGuideViewController ()

@end

@implementation QeGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    MyScrollView=[[UIScrollView alloc]init];
    MyScrollView.backgroundColor=[UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1];
    MyScrollView.showsHorizontalScrollIndicator=NO;
    MyScrollView.showsVerticalScrollIndicator=NO;
     [self creatNav];
    [self.view addSubview:MyScrollView];
    
   
    [self creatContentWithTag:_Index];
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
    titleLabel.text=_HeadTitle;
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
-(void)backButtonClick{
    
    [self.navigationController popViewControllerAnimated:YES];
    //    [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)creatContentWithTag:(NSInteger)tag{
    switch (tag) {
        case 0:
        {
        
            UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 44)];
            bgView.backgroundColor=[UIColor whiteColor];
            [MyScrollView addSubview:bgView];
            
            UIView *lineView1=[[UIView alloc]initWithFrame:CGRectMake(0,0,320, 0.5)];
            lineView1.backgroundColor=[UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:0.7];
            [bgView addSubview:lineView1];
    
            UIView *lineView3=[[UIView alloc]initWithFrame:CGRectMake(0,44,320, 0.5)];
            lineView3.backgroundColor=[UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:0.7];
            [bgView addSubview:lineView3];
            
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 12, 300, 20)];
            label.text=@"1、16WiFi是什么?";
            label.font=[UIFont systemFontOfSize:15];
            label.textColor=[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
            [bgView addSubview:label];
            
            UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(20, 0+44, 280, 150)];
            label2.text=@"   16WiFi是一款致力于为在路上的人群（目前为乘坐公交、地铁的人群）提供免费WiFi服务的工具.用户在公交车上打开手机无线网络,连接16wifi,通过下载客户端,进行注册登录后免费使用互联网.";
            label2.numberOfLines=0;
            label2.font=[UIFont systemFontOfSize:15];
            label2.textColor=[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
            [MyScrollView addSubview:label2];
            
        }
            break;
        case 1:
        {
            
            NSArray *titles=@[@"1、16WiFi登陆密码忘了怎么办?",@"2、密码在哪里修改?",@"3、会员等级有什么用?",@"4、微信登录问题"];
            for (int i=0; i<titles.count; i++) {
                
                UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 88*i, SCREENWIDTH, 44)];
                bgView.backgroundColor=[UIColor whiteColor];
                [MyScrollView addSubview:bgView];
                
                if (i==3) {
                    bgView.frame=CGRectMake(0, 88*i-1+20, SCREENWIDTH, 44);
                }
                
                UIView *lineView1=[[UIView alloc]initWithFrame:CGRectMake(0,0,320, 0.5)];
                lineView1.backgroundColor=[UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:0.7];
                [bgView addSubview:lineView1];
                
                UIView *lineView3=[[UIView alloc]initWithFrame:CGRectMake(0,44,320, 0.5)];
                lineView3.backgroundColor=[UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:0.7];
                [bgView addSubview:lineView3];
                
                UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 12, 300, 20)];
                label.text=titles[i];
                label.font=[UIFont systemFontOfSize:15];
                label.textColor=[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
                [bgView addSubview:label];
                
            }
           
            NSArray *contents=@[@"   可通过密码找回功能找回密码.",@"   导航-我-修改密码-进入修改.",@"   会员等级越高,享受的优惠越多,如在商城兑换奖品时,折扣力度更大.",@" 1）如果已用手机号注册了16WiFi账号,在个人资料里可绑定微信账号;\n 2）如果之前没有注册过16WiFi,用微信登录,则需要绑定手机号;\n 3）微信登录前需要连接外网,目前微信登录支持全国公交16wifi环境（除北京、南京外）,即连接16wifi,即可用微信登录。"];
            for (int i=0; i<titles.count; i++) {
                
                UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(20, 44+88*i, 280, 44)];
                label2.text=contents[i];
                label2.numberOfLines=0;
                label2.font=[UIFont systemFontOfSize:15];
                label2.textColor=[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
                if (i==2) {
                    label2.frame=CGRectMake(20, 44+88*i, 280, 66);
                }
                if (i==3) {
                    label2.frame=CGRectMake(20, 44+88*2+66+44, 280, 88+54);

                }
                      [MyScrollView addSubview:label2];
            }
               MyScrollView.contentSize=CGSizeMake(320, 44*3+88*3+66+10);
        }
            break;
        case 2:
        {
            
            NSArray *titles=@[@"1、16WiFi上网是免费的吗?",@"2、联通及电信用户是否可以使用16WiFi?",@"3、信号不稳定、总是断线是什么原因?",@"4、 状态说明"];
            for (int i=0; i<titles.count; i++) {
                
                UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 132*i, SCREENWIDTH, 44)];
                bgView.backgroundColor=[UIColor whiteColor];
                [MyScrollView addSubview:bgView];
                
                UIView *lineView1=[[UIView alloc]initWithFrame:CGRectMake(0,0,320, 0.5)];
                lineView1.backgroundColor=[UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:0.7];
                [bgView addSubview:lineView1];
                
                UIView *lineView3=[[UIView alloc]initWithFrame:CGRectMake(0,44,320, 0.5)];
                lineView3.backgroundColor=[UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:0.7];
                [bgView addSubview:lineView3];
                
                UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 12, 300, 20)];
                label.text=titles[i];
                label.font=[UIFont systemFontOfSize:15];
                label.textColor=[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
                [bgView addSubview:label];
                
            }
            
            NSArray *contents=@[@"   免费。\n   您下载安装16WiFi客户端,在安装了WiFi设备的公交车（地铁）上网是不收取任何费用的.",@"   联通及电信的手机用户,乘坐公交或者地铁（安装有16wifi设备）时都可以通过16WiFi客户端,点击“一键上网”后,免费浏览互联网.",@"   公交车在行驶过程中,会因车辆颠簸或周边建筑物的影响,对信号造成一定程度的干扰,这是在所难免的客观情况,但我们会极力采取措施保证信号的相对稳定.",@"   已连接，还不能上外网\n\n   已连接，能正常上外网\n\n    未连接，无wifi等\n"];
            for (int i=0; i<titles.count; i++) {
                
                UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(20, 44+132*i, 280, 88)];
                label2.text=contents[i];
                label2.numberOfLines=0;
                if (i==titles.count-1) {
                    label2.frame=CGRectMake(40, 44+132*i, 280, 88+22);
                }
                label2.font=[UIFont systemFontOfSize:15];
                label2.textColor=[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
                [MyScrollView addSubview:label2];

            }
            
            NSArray *images=@[@"warn",@"right",@"erro"];
            for (int j=0; j<3; j++) {
                UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(20, 10+44+132*3+35*j , 20, 20)];
                image.image=[UIImage imageNamed:images[j]];
                [MyScrollView addSubview:image];
    
            }
            
            NSArray *titles2=@[@"5、16WiFi上网攻略",@"6、16WiFi为什么总是认证失败?",@"7、问题反馈"];
            for (int i=0; i<titles2.count; i++) {
                
                UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 132*4+(176+44)*i+22, SCREENWIDTH, 44)];
                bgView.backgroundColor=[UIColor whiteColor];
                [MyScrollView addSubview:bgView];
                
                UIView *lineView1=[[UIView alloc]initWithFrame:CGRectMake(0,0,320, 0.5)];
                lineView1.backgroundColor=[UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:0.7];
                [bgView addSubview:lineView1];
                
                UIView *lineView3=[[UIView alloc]initWithFrame:CGRectMake(0,44,320, 0.5)];
                lineView3.backgroundColor=[UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:0.7];
                [bgView addSubview:lineView3];
                
                UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 12, 300, 20)];
                label.text=titles2[i];
                label.font=[UIFont systemFontOfSize:15];
                label.textColor=[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
                [bgView addSubview:label];
                
            }
            
            NSArray *contents2=@[@"   1）下载安装16WiFi客户端;\n   2）打开客户端，完成用户注册;\n   3）公交车上打开wifi，搜索‘16wifi’;\n   4）如果是苹果手机，搜索到16wifi后，点击右侧的感叹号，要选择关闭‘自动登录’，开启‘自动加入’，连接成功后，打开客户端点击‘一键上网’按钮，开启外网模式。",@"   为满足更多用户的需求，我们会不定期地对设备进行升级维护，在设备调试的过程 中会出现连接不稳定的情况，从而导致认证失败等异常问题。遇到此情况，建议多尝试几次，或换乘其他线路时再体验16wifi的免费网络。 您也可以随时拨打我们的400电话，咨询客户人员。\n   TEL：4001611616.",@"遇到问题，也可以上传日志反馈给我们。"];
            for (int i=0; i<titles2.count; i++) {
                
                UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(20, 44+132*4+(176+44)*i+22, 280, 88+44+44)];
                if (i==2) {
                    label2.frame=CGRectMake(20, 44+132*4+(176+44)*i+22, 280, 44);
                }
                label2.text=contents2[i];
                label2.numberOfLines=0;
                label2.font=[UIFont systemFontOfSize:15];
                label2.textColor=[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
                [MyScrollView addSubview:label2];
                
            }
            
            MyScrollView.contentSize=CGSizeMake(320, 44*6+88*5+176*2+22);
            
        }
            break;
        case 3:
        {
            NSArray *titles=@[@"1、什么是彩豆?",@"2、彩豆有什么用途?",@"3、通过以下途径，可以获得彩豆"];
            for (int i=0; i<titles.count; i++) {
                
                UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 88*i, SCREENWIDTH, 44)];
                bgView.backgroundColor=[UIColor whiteColor];
                [MyScrollView addSubview:bgView];
                
                UIView *lineView1=[[UIView alloc]initWithFrame:CGRectMake(0,0,320, 0.5)];
                lineView1.backgroundColor=[UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:0.7];
                [bgView addSubview:lineView1];
                
                UIView *lineView3=[[UIView alloc]initWithFrame:CGRectMake(0,44,320, 0.5)];
                lineView3.backgroundColor=[UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:0.7];
                [bgView addSubview:lineView3];
                
                UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 12, 310, 20)];
                label.text=titles[i];
                label.font=[UIFont systemFontOfSize:15];
                label.textColor=[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
                [bgView addSubview:label];
                
            }
            
            UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(20, 44, 280, 44)];
            label2.text=@"   彩豆是16WiFi内的虚拟货币.";
            label2.numberOfLines=0;
            label2.font=[UIFont systemFontOfSize:15];
            label2.textColor=[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
            [MyScrollView addSubview:label2];
            
            
            UILabel *label4=[[UILabel alloc]initWithFrame:CGRectMake(20, 44+44+44, 280, 44)];
            label4.text=@"   一键上网时需要扣除彩豆，同时，还可以去商城兑换商品";
            label4.numberOfLines=0;
            label4.font=[UIFont systemFontOfSize:15];
            label4.textColor=[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
            [MyScrollView addSubview:label4];
            
            UILabel *label3=[[UILabel alloc]initWithFrame:CGRectMake(20, 44+44+44+44+44, 280, 88*3+44)];
            label3.text=@"   1）新用户首次注册;\n   2）每日签到,连续签到;\n   3）看资讯、看视频;同时,看完分享也可获得;\n   4）装应用、玩游戏、看小说;\n   5）邀请朋友加入;\n   6）参与幸运大转盘抽奖;\n   7）每日开启桌面应用;\n   8）反馈问题及提出建议;\n   9）及时升级系统版本;\n 10）阅读最新系统消息;\n 11）参与最新活动;\n 12）除此之外，还有更多丰富多彩的活动，都可以在赚豆频道查看到.";
            label3.numberOfLines=0;
            label3.font=[UIFont systemFontOfSize:15];
            label3.textColor=[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
            [MyScrollView addSubview:label3];
            
            
            MyScrollView.contentSize=CGSizeMake(320, 44*4+88*4);

        }
            break;
        case 4:
        {
            
            NSArray *titles=@[@"1、什么是CMCC、ChinaUnicom、ChinaNet?"];
            for (int i=0; i<titles.count; i++) {
                
                UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 132*i, SCREENWIDTH, 44)];
                bgView.backgroundColor=[UIColor whiteColor];
                [MyScrollView addSubview:bgView];
                
                UIView *lineView1=[[UIView alloc]initWithFrame:CGRectMake(0,0,320, 0.5)];
                lineView1.backgroundColor=[UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:0.7];
                [bgView addSubview:lineView1];
                
                UIView *lineView3=[[UIView alloc]initWithFrame:CGRectMake(0,44,320, 0.5)];
                lineView3.backgroundColor=[UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:0.7];
                [bgView addSubview:lineView3];
                
                UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 12, 310, 20)];
                label.text=titles[i];
                label.font=[UIFont systemFontOfSize:15];
                label.textColor=[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
                [bgView addSubview:label];
                
            }
            
            NSArray *contents=@[@"   CMCC、ChinaUnicom、ChinaNet分别是中国移动、中国联通、中国电信所提供的付费WiFi，用户可通过16WiFi接入并免费使用【该版本暂不支持，下个版本将全面支持】。 114Free也是电信所有，目前仅限广东用户使用，114Free每天限时2小时，是运营商规定。"];
            for (int i=0; i<titles.count; i++) {
                
                UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(20, 44+132*i, 280, 88+44)];
                label2.text=contents[i];
                label2.numberOfLines=0;
                label2.font=[UIFont systemFontOfSize:15];
                label2.textColor=[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
                [MyScrollView addSubview:label2];
                
            }
            
        }
            break;
        case 5:
        {
           
            UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 44)];
            bgView.backgroundColor=[UIColor whiteColor];
            [MyScrollView addSubview:bgView];
            
            UIView *lineView1=[[UIView alloc]initWithFrame:CGRectMake(0,0,320, 0.5)];
            lineView1.backgroundColor=[UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:0.7];
            [bgView addSubview:lineView1];
            
            UIView *lineView3=[[UIView alloc]initWithFrame:CGRectMake(0,44,320, 0.5)];
            lineView3.backgroundColor=[UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:0.7];
            [bgView addSubview:lineView3];
            
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 12, 310, 20)];
            label.text=@"1、兑换中心是做什么的?";
            label.font=[UIFont systemFontOfSize:15];
            label.textColor=[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
            [bgView addSubview:label];

            
            UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(20, 44, 280, 88)];
            label2.text=@"   会员可以在商城兑换流量、QQ币、充值卡、各种礼品等，会员等级越高，享受的优惠越大.";
            label2.numberOfLines=0;
            label2.font=[UIFont systemFontOfSize:15];
            label2.textColor=[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
            [MyScrollView addSubview:label2];
            
        }
            break;
        case 6:
        {
            UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 44+22)];
            bgView.backgroundColor=[UIColor whiteColor];
            [MyScrollView addSubview:bgView];
            
            UIView *lineView1=[[UIView alloc]initWithFrame:CGRectMake(0,0,320, 0.5)];
            lineView1.backgroundColor=[UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:0.7];
            [bgView addSubview:lineView1];
            
            UIView *lineView3=[[UIView alloc]initWithFrame:CGRectMake(0,44+22,320, 0.5)];
            lineView3.backgroundColor=[UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:0.7];
            [bgView addSubview:lineView3];
            
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 12, 310, 20+20)];
            label.text=@"1、为什么16WiFi要认证手机号码？\n   通过16WiFi上网安全吗?";
            label.numberOfLines=0;
            label.font=[UIFont systemFontOfSize:15];
            label.textColor=[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
            [bgView addSubview:label];
            
            
            UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(20, 44+22, 280, 88+88+22)];
            label2.text=@"   从用户安全角度考虑，需要认证用户手机号码。16WiFi在安保方面做了全面的设计，保证用户个人信息及系统安全、管理安全。并且公安部第82号令也规定了上网行为要实名制。不需要验证或密码的公共WiFi风险较高，背后有可能是钓鱼陷阱，一旦连上钓鱼Wi-Fi或者登陆钓鱼网站，手机用户的操作记录就会被复制，被相关软件破解，一旦“钓鱼”成功，可能账号被盗，危及财产安全.";
            label2.numberOfLines=0;
            label2.font=[UIFont systemFontOfSize:15];
            label2.textColor=[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
            [MyScrollView addSubview:label2];
            
        }
            break;
    }
    
}
-(void)viewWillAppear:(BOOL)animated{

    [MobClick beginLogPageView:@"QeGuide"];
    
    self.tabBarController.tabBar.hidden=YES;
    self.navigationController.navigationBar.hidden=YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden=NO;
    self.navigationController.navigationBar.hidden=NO;
    [MobClick endLogPageView:@"QeGuide"];
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
