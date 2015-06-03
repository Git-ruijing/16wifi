//
//  NewItem.m
//  16wifi2
//
//  Created by JAY on 13-5-3.
//  Copyright (c) 2013年 JAY. All rights reserved.
//

#import "NewItem.h"

@implementation NewItem
@synthesize myNewsID=_myNewsID,myNewsImage=_myNewsImage,myNewsTitle=_myNewsTitle,myNewsType=_myNewsType,myNewsDescription=_myNewsDescription,banderHref=_banderHref,banderImageUrl=_banderImageUrl,banderTitle=_banderTitle,gold=_gold,contentId=_contentId;
- (void)dealloc
{
    self.banderTitle=nil;
    self.banderImageUrl=nil;
    self.banderHref=nil;
    self.myNewsID=nil;
    self.myNewsImage=nil;
    self.myNewsTitle=nil;
    self.myNewsDescription=nil;
    self.gold=nil;
    self.contentId=nil;
}
@end
