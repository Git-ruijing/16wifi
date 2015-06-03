//
//  CityListViewController.m
//  e-RoadWiFi
//
//  Created by QC on 14-10-16.
//  Copyright (c) 2014年 G.MING. All rights reserved.
//

#import "CityListViewController.h"
#import "MyButton.h"
#import "MyDatabase.h"
#import "cityItem.h"
#import "RootUrl.h"
#import "MobClick.h"
#define ROOTURL @"http://m.16wifi.com/"

@interface CityListViewController ()

@end

@implementation CityListViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.arrayHotCity = [NSMutableArray arrayWithObjects:@"北京",@"天津",@"上海",@"南京",@"佛山", nil];
        self.keys = [NSMutableArray array];
        self.arrayCitys = [NSMutableArray array];
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
    UIImageView *navView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 44+SIZEABOUTIOSVERSION)];
    navView.image=[UIImage imageNamed:@"gm_nav"];
    navView.userInteractionEnabled=YES;
    [self.view addSubview:navView];
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(70, SIZEABOUTIOSVERSION, 180, 44)];
    label.text=@"所在地";
    label.backgroundColor=[UIColor clearColor];
    label.textAlignment =NSTextAlignmentCenter;
    label.font=[UIFont systemFontOfSize:20];
    label.textColor=[UIColor whiteColor];
    [navView addSubview:label];
    MyButton *back=[MyButton buttonWithType:UIButtonTypeCustom];
    back.frame=CGRectMake(0, SIZEABOUTIOSVERSION, 50, 44);
    [back setNormalImage:[UIImage imageNamed:@"newBack"]];
    [back addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:back];
    [self getCityData];
    self.view.backgroundColor=[UIColor whiteColor];
	// Do any additional setup after loading the view.
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44+SIZEABOUTIOSVERSION, 320, SCREENHEIGHT-44-SIZEABOUTIOSVERSION) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0) {
        self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    }
    [self.view addSubview:_tableView];
    noticeLabel=[[UILabel alloc]initWithFrame:CGRectMake(60, SCREENHEIGHT-130, 200, 26)];
    noticeLabel.layer.cornerRadius=5.f;
    noticeLabel.layer.masksToBounds=YES;
    noticeLabel.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    noticeLabel.textAlignment=NSTextAlignmentCenter;
    noticeLabel.font=[UIFont systemFontOfSize:13];
    noticeLabel.textColor=[UIColor whiteColor];
    [noticeLabel setHidden:YES];
    [self.view addSubview:noticeLabel];
    
}

-(void)backButtonClick{
    [self dismissViewControllerAnimated:YES completion:^{}];
    
}

#pragma mark - 获取城市数据
-(void)getCityData
{
    NSString *path=[[NSBundle mainBundle] pathForResource:@"citydict" ofType:@"plist"];
    self.cities = [NSMutableDictionary dictionaryWithContentsOfFile:path];
  [self.keys addObjectsFromArray:[[self.cities allKeys] sortedArrayUsingSelector:@selector(compare:)]];
    //添加热门城市
    NSString *strHot = @"热门";
    [self.keys insertObject:strHot atIndex:0];
    [self.cities setObject:_arrayHotCity forKey:strHot];

}

#pragma mark - tableView
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    bgView.backgroundColor = [UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 30)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
    titleLabel.font = [UIFont systemFontOfSize:13];
    
    NSString *key = [_keys objectAtIndex:section];
    if ([key rangeOfString:@"热门"].location != NSNotFound) {
        titleLabel.text = @"热门城市";
    }
    else
        titleLabel.text = key;
    
    [bgView addSubview:titleLabel];
    
    return bgView;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _keys;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [_keys count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSString *key = [_keys objectAtIndex:section];
    NSArray *citySection = [_cities objectForKey:key];
    return [citySection count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    NSString *key = [_keys objectAtIndex:indexPath.section];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        [cell.textLabel setTextColor:[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1]];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    cell.textLabel.text = [[_cities objectForKey:key] objectAtIndex:indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 40.0f;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSString *key = [_keys objectAtIndex:indexPath.section];
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    
    NSLog(@"%@",[[_cities objectForKey:key] objectAtIndex:indexPath.row]);
    NSLog(@"SelectCityName%@",[def objectForKey:@"SelectCityName"]);
    if ([[[_cities objectForKey:key] objectAtIndex:indexPath.row] isEqualToString:[def objectForKey:@"SelectCityName"]]) {
        
        [def setObject:@"0" forKey:@"isUpdateCity"];
        
    }else{
        [def setObject:[[_cities objectForKey:key] objectAtIndex:indexPath.row] forKey:@"SelectCityName"];
        [def setObject:@"1" forKey:@"isUpdateCity"];
    }
    
        [def synchronize];
    [self dismissViewControllerAnimated:YES completion:^{}];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [MobClick endLogPageView:@"CityList"];

}
-(void)downloadComplete:(HttpDownload *)hd{
    
    if (hd.tag==909090) {
        NSString *str=[[NSString alloc]initWithData:hd.mData encoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&error];
        if (error!=nil) {
            NSLog(@"json解析失败25");
        }else{
            NSNumber *num=[dic objectForKey:@"ReturnCode"];
            
            switch ([num intValue]) {
                    
                case 102:
                {
                    NSLog(@"更新成功");
                    
                    [update cancel];
                    [self dismissViewControllerAnimated:YES completion:^{}];
                    
                    break;
                }
                case 103:
                {
                    break;
                }
                default:
                    break;
            }
        }
    }
}
-(void)dealloc{
    [update cancel];
    
}
-(void)viewWillAppear:(BOOL)animated{

  
    [MobClick beginLogPageView:@"CityList"];
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
