//
//  FirstOpenAnimationViewController.m
//  e路WiFi
//
//  Created by JAY on 13-10-23.
//  Copyright (c) 2013年 HE ZHENJIE. All rights reserved.
//

#import "FirstOpenAnimationViewController.h"
#import "MyButton.h"
#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "MobClick.h"
#import "ZhuanPanViewController.h"
#define DEVICE_IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568)
#define DEVICE_IS_IPHONE6p ([[UIScreen mainScreen] bounds].size.height == 736)
#define SCREENHEIGHT ([[UIScreen mainScreen] bounds].size.height)

#define SIZE ABOUTIOSVERSION ([[[UIDevice currentDevice] systemVersion] floatValue]<7.0?0:20)
#define IOSVERSIONSMALL ([[[UIDevice currentDevice] systemVersion] floatValue]<7.0?20:0)
#define SCALE [[UIScreen mainScreen] scale]
@interface FirstOpenAnimationViewController ()

@end

@implementation FirstOpenAnimationViewController

@synthesize MyScrollView, slideImages;
@synthesize pageControl;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        self.view.backgroundColor=[UIColor clearColor];
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
    [[UIApplication sharedApplication]setStatusBarHidden:YES];

    [MobClick beginLogPageView:@"FirstOp"];
}
-(void)viewWillDisappear:(BOOL)animated{
    [[UIApplication sharedApplication]setStatusBarHidden:NO];
    [MobClick endLogPageView:@"FirstOp"];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithRed:240/255.0f green:103/255.0f blue:104/255.0f alpha:1];
   
    if (DEVICE_IS_IPHONE5) {
        slideImages=[NSMutableArray arrayWithObjects:@"zhinan0",@"zhinan1",@"zhinan2",@"zhinan3", nil];
    }else{
        slideImages=[NSMutableArray arrayWithObjects:@"zhinan9600",@"zhinan9601",@"zhinan9602", @"zhinan9603",nil];
    }
    
    self.MyScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, SCREENHEIGHT)];
    [MyScrollView setPagingEnabled:YES];
    MyScrollView.backgroundColor=[UIColor clearColor];
    MyScrollView.delegate=self;
    [MyScrollView setShowsVerticalScrollIndicator:NO];
    [MyScrollView setContentSize:CGSizeMake(320*([slideImages count]), SCREENHEIGHT)];
    [self.view addSubview:MyScrollView];
    
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0,SCREENHEIGHT-95,320,20)];
    [pageControl setCurrentPageIndicatorTintColor:[UIColor whiteColor]];
    [pageControl setPageIndicatorTintColor:[UIColor colorWithRed:237/255.0f green:237/255.0f blue:237/255.0f alpha:0.4]];
    pageControl.numberOfPages = [self.slideImages count];
    pageControl.currentPage = 0;
    [pageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:pageControl];
    
    for (int i = 0;i<[slideImages count];i++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[slideImages objectAtIndex:i]]];
        imageView.frame = CGRectMake((320 * i), 0, 320, SCREENHEIGHT);
        [MyScrollView addSubview:imageView];
    }

    UIView *bgview=[[UIView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT-75, 320, 75)];
    bgview.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:bgview];

    
    MyButton *login=[MyButton buttonWithType:UIButtonTypeCustom];
    [login setTitle:@"登录" forState:UIControlStateNormal];
    [login setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    login.titleLabel.font=[UIFont systemFontOfSize:15];
    [login setNormalBackgroundImage:[[UIImage imageNamed:@"button_grey"]stretchableImageWithLeftCapWidth:5 topCapHeight:5]];
    [login setFrame:CGRectMake(25, SCREENHEIGHT-55, 116, 35)];
    [login addTarget:self action:@selector(loginBtn)];
    [self.view addSubview:login];
    
    
    MyButton *Register=[MyButton buttonWithType:UIButtonTypeCustom];
    [Register setTitle:@"注册" forState:UIControlStateNormal];
    [Register setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    Register.titleLabel.font=[UIFont systemFontOfSize:15];
    [Register setNormalBackgroundImage:[[UIImage imageNamed:@"gm_but"]stretchableImageWithLeftCapWidth:5 topCapHeight:5]];
    [Register setFrame:CGRectMake(181, SCREENHEIGHT-55, 116, 35)];
    [Register addTarget:self action:@selector(registerBtn)];
    [self.view addSubview:Register];
    
    MyButton *Close=[MyButton buttonWithType:UIButtonTypeCustom];
    [Close setNormalBackgroundImage:[[UIImage imageNamed:@"zhinan-close"]stretchableImageWithLeftCapWidth:5 topCapHeight:5]];
    [Close setFrame:CGRectMake(SCREENWIDTH-40, 0, 40, 40)];
    [Close addTarget:self action:@selector(goMainPage)];
    [self.view addSubview:Close];
    
	// Do any additional setup after loading the view.
}
-(void)loginBtn{
    LoginViewController *lvc=[[LoginViewController alloc]init];

    lvc.delegate=self;
    [self presentViewController:lvc animated:YES completion:nil];
    
    
}
-(void)loginSuccessWithTag:(int)tag{
    [self goMainPage];
}
-(void)registerBtn{
    RegisterViewController *rvc=[[RegisterViewController alloc]init];
    rvc.RegisterType=0;
    [self presentViewController:rvc animated:YES completion:nil];
    
}
-(void)goMainPage{

        AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication]delegate];
        [app creatTabBarController];
        [app resetNetChack];
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGPoint offset=scrollView.contentOffset;
    CGRect bounds=scrollView.frame;
    [pageControl setCurrentPage:offset.x/bounds.size.width];
   
}
-(void)pageTurn:(UIPageControl *)page {
    CGSize viewsize=MyScrollView.frame.size;
    CGRect rect=CGRectMake(page.currentPage*viewsize.width, 0, viewsize.width, viewsize.height);
    [MyScrollView scrollRectToVisible:rect animated:YES];
}
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{

    if ((320*(slideImages.count-1)+20)<scrollView.contentOffset.x) {
        [self goMainPage];
    }
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    if (scrollView.contentOffset.x<=0) {
        self.view.backgroundColor=[UIColor colorWithRed:86/255.0f green:180/255.0f blue:243/255.0f alpha:1];
    }else if (scrollView.contentOffset.x>=(slideImages.count-1)*320){
        self.view.backgroundColor=[UIColor colorWithRed:255/255.0f green:162/255.0f blue:23/255.0f alpha:1];
        
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
