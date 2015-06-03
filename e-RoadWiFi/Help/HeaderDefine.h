//
//  HeaderDefine.h
//  e-RoadWiFi
//
//  Created by QC on 14-8-1.
//  Copyright (c) 2014年 G.MING. All rights reserved.
//

#ifndef e_RoadWiFi_HeaderDefine_h
#define e_RoadWiFi_HeaderDefine_h
#define LEFT_BAR_BUTTON 1
#define RIGHT_BAR_BUTTON 2
#define ROOTURL @"http://m.16wifi.com/"
#define HUAWEIIP @"http://192.100.100.100/"
#define SECRETKEY @"ilovewififorfree"
#define TestBaseUrl @"http://111.13.47.145:8090/"
#define FormalBaseUrl @"http://www.16wifi.com/"
//#define NewBaseUrl @"http://user.16wifi.com/"
#define NewBaseUrl @"http://111.13.47.153:7000/"
#define DEVICE_IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568)
#define SCREENHEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREENWIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SIZEFORLOGNAV ([[[UIDevice currentDevice] systemVersion] floatValue]<7.0?(-20):0)
#define SIZEABOUTIOSVERSION ([[[UIDevice currentDevice] systemVersion] floatValue]<7.0?0:20)
#define IOSVERSIONSMALL ([[[UIDevice currentDevice] systemVersion] floatValue]<7.0?20:0)
#define SYSTEMVERSION [[[UIDevice currentDevice] systemVersion] floatValue]
//#define UMENG_APPKEY @"53ad3c0056240b6a0d039210"
#define UMENG_APPKEY @"544da7affd98c5b22206a91a"
#define WXAPP_ID @"wxec18d96456cf5b87"
#define WXAPP_SECRET @"e32014b9477266bdda1cd13acba94f66"
#define RootConnectUrl  @"http://m.16wifi.com"
#define WebCategary  @"http://m.16wifi.com/json/websiteicon/iconnavigation.json"
#define LifeAssistant @"http://m.16wifi.com/json/goodsadvertise/lifeassistant.json"
#define QiCaiLife  @"http://m.16wifi.com/json/websitecategory/qicailife.json"
#define ColumnList @"http://m.16wifi.com/json/innerColumnList.json"
#define HotSearch @"http://m.16wifi.com/json/websiteicon/hotKeyword.json"
#endif
