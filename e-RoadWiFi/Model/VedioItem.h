//
//  VedioItem.h
//  16wifi2
//
//  Created by JAY on 13-5-10.
//  Copyright (c) 2013年 JAY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VedioItem : NSObject

@property(nonatomic,retain)NSString *contentId;
@property(nonatomic ,retain)NSString *vedioImage;
@property(nonatomic ,retain)NSString *vedioTitle;
@property(nonatomic ,retain)NSString *vedioDescription;
@property(nonatomic ,retain)NSString *vedioLabel;
@property(nonatomic ,retain)NSString *comeFrom;
@property(nonatomic ,retain)NSString *vedioDuration;
@property(nonatomic ,retain)NSString *vedioUrl;
@property(nonatomic,readwrite)BOOL banderIsComm;
@property(nonatomic,retain)NSString *banderTitle;
@property(nonatomic,retain)NSString *banderHref;
@property(nonatomic,retain)NSString *banderImageUrl;
@property(nonatomic,retain)NSString *gold;
@property(nonatomic,retain)NSString *contentIFilePath;
@end
