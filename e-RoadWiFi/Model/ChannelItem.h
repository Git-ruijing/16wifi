//
//  ChannelItem.h
//  e路WiFi
//
//  Created by JAY on 13-11-5.
//  Copyright (c) 2013年 HE ZHENJIE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChannelItem : NSObject
@property(nonatomic,strong)NSString *channelName;
@property(nonatomic,strong)NSString *channelImageUrl;
@property(nonatomic,strong)NSString *imgaeName;
@property(nonatomic,strong)NSString *channelContentUrl;
@property(nonatomic,strong)NSString *selectedImage;
@property(nonatomic,strong)NSString *isJsonOrHtml;
@property(nonatomic,strong)NSArray *children;
@end
