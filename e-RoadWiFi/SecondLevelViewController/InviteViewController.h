//
//  InviteViewController.h
//  e-RoadWiFi
//
//  Created by QC on 14-10-22.
//  Copyright (c) 2014年 G.MING. All rights reserved.
//

#import "BasicViewController.h"
#import "UMSocial.h"
#import "MyButton.h"
@interface InviteViewController : BasicViewController<UMSocialUIDelegate,UITableViewDataSource,UITableViewDelegate>
{

    UIScrollView *_scrollerView;
     NSMutableArray *_dataArray;
    UILabel *code;
    UILabel *tips;
    UITableView *dataTableView;
    NSArray *FriendsArr;
    MyButton *moreButton;
    UIView *myOwnBg;
    int showMyOwnFlag;
}
@property(nonatomic,strong)NSString *InvitationCode;
@property(nonatomic,strong)NSString *InviteNum;
@property(nonatomic,assign)NSInteger count;
@end
