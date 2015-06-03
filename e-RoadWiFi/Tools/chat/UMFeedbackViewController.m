//
//  UMFeedbackViewController.m
//  UMeng Analysis
//
//  Created by liu yu on 7/12/12.
//  Copyright (c) 2012 Realcent. All rights reserved.
//

#import "UMFeedbackViewController.h"
#import "UMFeedbackTableViewCellLeft.h"
#import "UMFeedbackTableViewCellRight.h"
#import "RootUrl.h"
#define DEVICE_IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568)
#define SCREENHEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SIZEABOUTIOSVERSION ([[[UIDevice currentDevice] systemVersion] floatValue]<7.0?0:20)
#define IOSVERSIONSMALL ([[[UIDevice currentDevice] systemVersion] floatValue]<7.0?20:0)
#define TOP_MARGIN 20.0f
#define kNavigationBar_ToolBarBackGroundColor  [UIColor colorWithRed:0.149020 green:0.149020 blue:0.149020 alpha:1.0]
#define kContactViewBackgroundColor  [UIColor colorWithRed:0.078 green:0.584 blue:0.97 alpha:1.0]

static UITapGestureRecognizer *tapRecognizer;

@implementation UINavigationBar (CustomImage)
- (void)drawRect:(CGRect)rect {
    UIImage *image = [UIImage imageNamed:@"nav_btn_bg"];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}
@end

@interface UMFeedbackViewController ()
@property(nonatomic, copy) NSString *mContactInfo;
@end

@implementation UMFeedbackViewController

@synthesize mTextField = _mTextField, mTableView = _mTableView, mToolBar = _mToolBar, mFeedbackData = _mFeedbackData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated{
    
    [_refreshHeaderView egoRefreshScrollViewShowLoadingManual:self.mTableView];
    [_refreshHeaderView egoRefreshScrollViewDataSourceStartManualLoading:self.mTableView];
    
    
}

- (void)customizeNavigationBar:(UINavigationBar *)bar {
    bar.clipsToBounds = YES;
    if ([bar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        UIImage *image = [self imageWithColor:kNavigationBar_ToolBarBackGroundColor];
        
        [bar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)setupTableView {
    UIImageView *toolBarBg=[[UIImageView alloc]initWithFrame:CGRectMake(0, -3, 320, 47)];
    toolBarBg.image=[[UIImage imageNamed:@"bottomBackground"]stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    [self.mToolBar setBackgroundColor:[UIColor clearColor]];
    [self.mToolBar addSubview:toolBarBg];
    // _tableViewTopMargin=48+SIZEABOUTIOSVERSION;
    
    
    
    _tableViewTopMargin = 0;
    
    
    
    self.mTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
}

- (void)setupEGORefreshTableHeaderView {
    if (_refreshHeaderView == nil) {
        
        UMEGORefreshTableHeaderView *view = [[UMEGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f,-self.mTableView.frame.size.height-SIZEABOUTIOSVERSION+20, self.mTableView.frame.size.width, self.mTableView.bounds.size.height)];
        view.delegate = (id <UMEGORefreshTableHeaderDelegate>) self;
        [self.mTableView addSubview:view];
        _refreshHeaderView = view;
    }
    [_refreshHeaderView refreshLastUpdatedDate];
}

- (void)setupToolbar {
    backBut=[UIButton buttonWithType:UIButtonTypeCustom];
    backBut.frame=CGRectMake(6, 3, 40, 40);
    [backBut setImage:[UIImage imageNamed:@"Hback"] forState:UIControlStateNormal];
    [backBut addTarget:self action:@selector(backToPrevious) forControlEvents:UIControlEventTouchUpInside];
    [self.mToolBar addSubview:backBut];
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    button.frame = CGRectMake(256, 7, 57.0f, 30.0f);
    button.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [button setTitle:NSLocalizedString(@"提交",@"Send") forState:UIControlStateNormal];
    [button setBackgroundImage:[[UIImage imageNamed:@"butBgS"] stretchableImageWithLeftCapWidth:5 topCapHeight:5]forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(sendFeedback:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.mToolBar addSubview:button];
    [button setHidden:YES];
    [self setupTextField];
}

- (void)setupTextField {
    _mTextField = [[UITextField alloc] initWithFrame:CGRectMake(55, 7, _mToolBar.frame.size.width - 74.0f, 30.0f)];
    _mTextField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _mTextField.backgroundColor = [UIColor clearColor];
    _mTextField.background=[[UIImage imageNamed:@"shuru"]stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    _mTextField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _mTextField.textAlignment = NSTextAlignmentLeft;
    _mTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _mTextField.borderStyle = UITextBorderStyleNone;
    _mTextField.font = [UIFont systemFontOfSize:14.0f];
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 30)];
    _mTextField.leftView = paddingView;
    _mTextField.leftViewMode = UITextFieldViewModeAlways;
    _mTextField.delegate = (id <UITextFieldDelegate>) self;
    
    [self.mToolBar addSubview:_mTextField];
}




- (void)viewDidLoad {
    [super viewDidLoad];
    self.mTableView.frame=CGRectMake(0,44+SIZEABOUTIOSVERSION, 320, SCREENHEIGHT-SIZEABOUTIOSVERSION-44-44);
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 44+SIZEABOUTIOSVERSION)];
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
    titleLabel.text=@"意见反馈";
    
    [self setBackButton];
    [self setBackgroundColor];
    [self setupTableView];
    [self setupEGORefreshTableHeaderView];
    [self setupToolbar];
    [self customizeNavigationBar:self.navigationController.navigationBar];
    [self setFeedbackClient];
    [self updateTableView:nil];
    [self handleKeyboard];
    
    
    
    
    _shouldScrollToBottom = YES;
    
}

- (void)handleKeyboard {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapAnywhere:)];
}

- (void)setFeedbackClient {
    _mFeedbackData = [[NSArray alloc] init];
    feedbackClient = [UMFeedback sharedInstance];
    if ([self.appkey isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"NO Umeng kUmengAppkey"
                                                        message:@"Please define UMENG_APPKEY macro!"
                                                       delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    [feedbackClient setAppkey:self.appkey delegate:(id <UMFeedbackDataDelegate>) self];
    
    //    从缓存取topicAndReplies
    self.mFeedbackData = feedbackClient.topicAndReplies;
}

- (void)setBackgroundColor {
    self.mTableView.backgroundColor = [UIColor whiteColor];
    if ([self.mToolBar respondsToSelector:@selector(setBackgroundImage:forToolbarPosition:barMetrics:)]) {
        UIImage *image = [self imageWithColor:kNavigationBar_ToolBarBackGroundColor];
        [self.mToolBar setBackgroundImage:image forToolbarPosition:UIToolbarPositionBottom barMetrics:UIBarMetricsDefault];
    } else {
        self.mToolBar.barStyle = UIBarStyleBlack;
    }
    
}

- (void)setBackButton {
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [backBtn addTarget:self action:@selector(backToPrevious) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    backBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [backBtn setTitle:NSLocalizedString(@"Close", @"关闭") forState:UIControlStateNormal];
    
    [backBtn setBackgroundImage:[UIImage imageNamed:@"nav_btn_bg"] forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"nav_btn_bg_lighted"] forState:UIControlStateHighlighted];
    backBtn.frame = CGRectMake(0, 0, 51.0f, self.navigationController.navigationBar.frame.size.height * 0.7);
    backBtn.autoresizingMask = UIViewAutoresizingFlexibleHeight;
}

- (void)didTapAnywhere:(UITapGestureRecognizer *)recognizer {
    [self.mTextField resignFirstResponder];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark keyboard notification

- (void)keyboardWillShow:(NSNotification *)notification {
    [_mTextField setFrame:CGRectMake(6, 7, _mToolBar.frame.size.width - 74.0f, 30.0f)];
    [backBut setHidden:YES];
    [button setHidden:NO];
    float animationDuration = [[[notification userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGFloat keyboardHeight = [[[notification userInfo] objectForKey:UIKeyboardBoundsUserInfoKey] CGRectValue].size.height;
    
    [UIView animateWithDuration:animationDuration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         CGRect toolbarFrame = self.mToolBar.frame;
                         toolbarFrame.origin.y = self.view.bounds.size.height - keyboardHeight - toolbarFrame.size.height;
                         self.mToolBar.frame = toolbarFrame;
                         
                         CGRect tableViewFrame = self.mTableView.frame;
                         tableViewFrame.size.height = self.view.bounds.size.height - self.navigationController.navigationBar.frame.size.height - keyboardHeight;
                         self.mTableView.frame = tableViewFrame;
                     }
                     completion:^(BOOL finished) {
                         if (_shouldScrollToBottom) {
                             [self scrollToBottom];
                         }
                     }
     ];
    
    [self.view addGestureRecognizer:tapRecognizer];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [_mTextField setFrame:CGRectMake(55, 7, _mToolBar.frame.size.width - 74.0f, 30.0f)];
    [backBut setHidden:NO];
    [button setHidden:YES];
    float animationDuration = [[[notification userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView beginAnimations:@"bottomBarDown" context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    CGRect toolbarFrame = self.mToolBar.frame;
    toolbarFrame.origin.y = self.view.bounds.size.height - toolbarFrame.size.height;
    self.mToolBar.frame = toolbarFrame;
    
    CGRect tableViewFrame = self.mTableView.frame;
    tableViewFrame.size.height = self.view.bounds.size.height - self.navigationController.navigationBar.frame.size.height;
    self.mTableView.frame = tableViewFrame;
    
    [UIView commitAnimations];
    
    [self.view removeGestureRecognizer:tapRecognizer];
}

- (void)backToPrevious {
    
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (IBAction)sendFeedback:(id)sender {
    if ([self.mTextField.text length]) {
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [dictionary setObject:self.mTextField.text forKey:@"content"];
        NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
        
        NSDictionary* UserInfoDic=[NSDictionary dictionaryWithObjectsAndKeys:[def objectForKey:@"userPhone"],@"phone",[def objectForKey:@"SelectCityName"],@"city", nil];
        
        if ([self.mContactInfo length]) {
            [dictionary setObject:[NSDictionary dictionaryWithObjectsAndKeys:self.mContactInfo, @"plain", nil] forKey:@"contact"];
        }
        
        NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithObjectsAndKeys:UserInfoDic,@"contact",nil];
        if ([RootUrl getIsNetOn]) {
            [feedbackClient post:dictionary];
            [feedbackClient updateUserInfo:dic];
            [self.mTextField resignFirstResponder];
            _shouldScrollToBottom = YES;
        }else{
        
            UIAlertView *alterView=[[UIAlertView alloc]initWithTitle:nil message:@"当前网络不给力，请稍后重试" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
            [alterView show];
        }
 
    }
}

#pragma mark tableview delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_mFeedbackData count]+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *content;
    if (indexPath.row==0) {
        content=@"亲，在这里或到QQ群337841709，留下您的宝贵意见或建议，都可以获得0~200不等的彩豆奖励。";
    }else{
        content = [[feedbackClient.topicAndReplies objectAtIndex:(NSUInteger) indexPath.row-1] objectForKey:@"content"];
    }
    
    CGSize labelSize = [content sizeWithFont:[UIFont systemFontOfSize:14.0f]
                           constrainedToSize:CGSizeMake(226.0f, MAXFLOAT)
                               lineBreakMode:NSLineBreakByWordWrapping];
    return labelSize.height + 40 + TOP_MARGIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *L_CellIdentifier = @"L_UMFBTableViewCell";
    static NSString *R_CellIdentifier = @"R_UMFBTableViewCell";
    
    if (indexPath.row!=0) {
        NSDictionary *data = [self.mFeedbackData objectAtIndex:(NSUInteger) indexPath.row-1];
        
        
        NSString * timeStampString =[NSString stringWithFormat:@"%@",[data objectForKey:@"created_at"]];
        NSTimeInterval _interval=[[timeStampString substringToIndex:10] doubleValue];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
        NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
        [objDateformat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
        if ([[data objectForKey:@"type"] isEqualToString:@"dev_reply"]) {
            UMFeedbackTableViewCellLeft *cell = (UMFeedbackTableViewCellLeft *) [tableView dequeueReusableCellWithIdentifier:L_CellIdentifier];
            if (cell == nil) {
                cell = [[UMFeedbackTableViewCellLeft alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:L_CellIdentifier];
            }
            
            cell.textLabel.text = [data objectForKey:@"content"];
            cell.timestampLabel.text = [NSString stringWithFormat:@"%@",[objDateformat stringFromDate: date]];
            
            return cell;
        }
        else {
            
            UMFeedbackTableViewCellRight *cell = (UMFeedbackTableViewCellRight *) [tableView dequeueReusableCellWithIdentifier:R_CellIdentifier];
            if (cell == nil) {
                cell = [[UMFeedbackTableViewCellRight alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:R_CellIdentifier];
            }
            
            cell.textLabel.text = [data objectForKey:@"content"];
            cell.timestampLabel.text = [NSString stringWithFormat:@"%@",[objDateformat stringFromDate: date]];
            return cell;
            
        }
    }else{
        UMFeedbackTableViewCellLeft *cell = (UMFeedbackTableViewCellLeft *) [tableView dequeueReusableCellWithIdentifier:L_CellIdentifier];
        if (cell == nil) {
            cell = [[UMFeedbackTableViewCellLeft alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:L_CellIdentifier];
        }
        
        cell.textLabel.text =@"亲，在这里或到QQ群337841709，留下您的宝贵意见或建议，都可以获得0~200不等的彩豆奖励。";
        NSString *str=[RootUrl getFeedBackDate];
        if (!str) {
            NSDateFormatter *formater = [[[ NSDateFormatter alloc] init]autorelease];
            [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *curDate = [NSDate date];//获取当前日期
            [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//这里去掉 具体时间 保留日期
            NSString * str = [formater stringFromDate:curDate];
            [RootUrl setFeedBackDate:str];
            
        }
        cell.timestampLabel.text = str;
        
        return cell;
        
        return  cell;
    }
    
}

#pragma mark ContactViewController delegate method

#pragma mark Umeng Feedback delegate

- (void)updateTableView:(NSError *)error {
    if ([self.mFeedbackData count]) {
        [self.mTableView reloadData];
    }
}

- (void)updateTextField:(NSError *)error {
    if (!error) {
        self.mTextField.text = @"";
        [feedbackClient get];
    }
}

- (void)getFinishedWithError:(NSError *)error {
    if (!error) {
        [self updateTableView:error];
    }
    
    if (1) {
        [self.mTableView setFrame:CGRectMake(0, 44+SIZEABOUTIOSVERSION, 320, SCREENHEIGHT-SIZEABOUTIOSVERSION-44-44)];
        [self scrollToBottom];
    }
    
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.0];
}

- (void)postFinishedWithError:(NSError *)error {
    //    UIAlertView *alertView;
    //    if (!error)
    //    {
    //        alertView = [[UIAlertView alloc] initWithTitle:@"感谢您的反馈!" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //    }
    //    else
    //    {
    //        alertView = [[UIAlertView alloc] initWithTitle:@"发送失败!" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //    }
    //
    //    [alertView show];
    
    [self updateTextField:error];
}

- (void)doneLoadingTableViewData {
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.mTableView];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollToBottom {
    if ([self.mTableView numberOfRowsInSection:0] > 1) {
        int lastRowNumber = (int)[self.mTableView numberOfRowsInSection:0] - 1;
        NSIndexPath *ip = [NSIndexPath indexPathForRow:lastRowNumber inSection:0];
        [self.mTableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)reloadTableViewDataSource {
    _reloading = YES;
    [feedbackClient get];
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(UMEGORefreshTableHeaderView *)view {
    _shouldScrollToBottom = NO;
    [self reloadTableViewDataSource];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(UMEGORefreshTableHeaderView *)view {
    return _reloading; // should return if data source model is reloading
}

- (NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(UMEGORefreshTableHeaderView *)view {
    return [NSDate date]; // should return date data source was last changed
}

#pragma mark UITextField Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

- (void)dealloc {
    
    feedbackClient.delegate = nil;
    [super dealloc];
}

@end
