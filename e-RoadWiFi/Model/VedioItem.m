//
//  VedioItem.m
//  16wifi2
//
//  Created by JAY on 13-5-10.
//  Copyright (c) 2013年 JAY. All rights reserved.
//

#import "VedioItem.h"

@implementation VedioItem
@synthesize vedioDescription=_vedioDescription,vedioDuration=_vedioDuration,vedioImage=_vedioImage,vedioLabel=_vedioLabel,vedioTitle=_vedioTitle,vedioUrl=_vedioUrl,comeFrom=_comeFrom,banderHref=_banderHref,banderImageUrl=_banderImageUrl,banderIsComm=_banderIsComm,banderTitle=_banderTitle,gold=_gold,contentId=_contentId;
- (void)dealloc
{
    self.banderTitle=nil;
    self.banderImageUrl=nil;
    self.banderHref=nil;
    self.comeFrom=nil;
    self.vedioUrl=nil;
    self.vedioTitle=nil;
    self.vedioLabel=nil;
    self.vedioDescription=nil;
    self.vedioImage=nil;
    self.vedioDuration=nil;
    self.contentId=nil;
    self.gold=nil;
}
@end
