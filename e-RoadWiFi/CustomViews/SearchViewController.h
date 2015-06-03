//
//  SearchViewController.h
//  e路WiFi
//
//  Created by JAY on 13-12-4.
//  Copyright (c) 2013年 HE ZHENJIE. All rights reserved.
//

#import "BasicViewController.h"
#import "RootUrl.h"
@protocol SearchViewDelegate;
@interface SearchViewController : BasicViewController<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>{
    NSMutableArray *searchArray;

    NSMutableArray *hotSearch;
    UITableView * myTabView;
    UIScrollView *myScroller;
    UISearchBar *mySearchBar;
    MyButton *clearButton;
    NSMutableArray *HistoryArray;
    CGSize temp;
    CGRect TabFrame;
    BOOL creat;
}
@property (nonatomic,strong) id<SearchViewDelegate> delegate;
@property(nonatomic ,readwrite)int isLineOfTurn;
@property(nonatomic ,readwrite)int tag;
@end
@protocol SearchViewDelegate
@optional
-(void)searchWord:(NSString *)word andWithSelf:(SearchViewController*)searchViewCtr;
-(void)searchTransferLineWithSelf:(SearchViewController*)searchViewCtr;
@end