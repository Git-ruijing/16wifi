//
//  BasicViewController.m
//  e-RoadWiFi
//
//  Created by QC on 14-8-1.
//  Copyright (c) 2014年 G.MING. All rights reserved.
//

#import "BasicViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "UIViewController+setTabBarStatus.h"
#import "HttpManager.h"
#import "HttpRequest.h"
#import "UIImageView+WebCache.h"
@interface BasicViewController ()

@end

@implementation BasicViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        curTaskDict=[[NSMutableDictionary alloc]init];
        dataArray=[[NSMutableArray alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setHidesBottomBarWhenPushed:YES];
    [self.tabBarController setHidesBottomBarWhenPushed:YES];
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"gm_nav"] forBarMetrics:UIBarMetricsDefault];
//       [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"gm_nav"] forBarMetrics:UIBarMetricsDefault];
    self.view.backgroundColor=[UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1];
    // Do any additional setup after loading the view.
}
-(void)addTitle:(NSString *)title{
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 30)];
    label.backgroundColor=[UIColor clearColor];
    label.textAlignment=NSTextAlignmentCenter;
    label.font=[UIFont systemFontOfSize:20];
    label.textColor=[UIColor whiteColor];
    label.text=title;
    self.navigationItem.titleView=label;
}
-(void)addTask:(NSString *)url action:(SEL)action{
    isLoading=YES;
    id object=[curTaskDict objectForKey:url];
    if (!object) {
        [curTaskDict setObject:url forKey:url];
        [[HttpManager sharedManager]addTask:url delegate:self action:action];
    }


}

- (BOOL)isUrl
{
    NSString *      regex = @"http(s)?:\\/\\/([\\w-]+\\.)+[\\w-]+(\\/[\\w- .\\/?%&=]*)?";
    NSPredicate *   pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:self];
}

-(void)clearCache{

    NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    
    
    
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
    
    NSLog(@"files :%lu",(unsigned long)[files count]);
    
    for (NSString *p in files) {
        
        NSError *error;
        
        NSString *path = [cachPath stringByAppendingPathComponent:p];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            
            [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
            
        }
        
    }
    
    
}
- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
- (float ) folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath])
        return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}
-(void)addNavAndTitle:(NSString *)title withFrame:(CGRect )frame{
    UIImageView *navView=[[UIImageView alloc]initWithFrame:frame];
    navView.image=[UIImage imageNamed:@"gm_nav"];
    navView.userInteractionEnabled=YES;
    [self.view addSubview:navView];
    UILabel *label=[[UILabel alloc]init];
    label.frame=CGRectMake(120, SIZEABOUTIOSVERSION, 80, 44);
    label.text=title;
    label.backgroundColor=[UIColor clearColor];
    label.font=[UIFont systemFontOfSize:20];
    label.textColor=[UIColor whiteColor];
    [navView addSubview:label];
        UIButton *back=[UIButton buttonWithType:UIButtonTypeCustom];
        back.frame=CGRectMake(0, SIZEABOUTIOSVERSION, 50, 44);
    back.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"newBack_d"]];
    [back addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:back];

}

-(void)backButtonClick{
   [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
