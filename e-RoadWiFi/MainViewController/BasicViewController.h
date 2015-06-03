//
//  BasicViewController.h
//  e-RoadWiFi
//
//  Created by QC on 14-8-1.
//  Copyright (c) 2014年 G.MING. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyButton.h"
@interface BasicViewController : UIViewController{

    NSMutableDictionary *curTaskDict;
    BOOL isLoading;
    NSMutableArray * dataArray;
    
}
-(void)addTitle:(NSString *)title;

-(void)addTask:(NSString *)url action:(SEL)action;
- (long long) fileSizeAtPath:(NSString*) filePath;
- (float ) folderSizeAtPath:(NSString*) folderPath;
-(void)addNavAndTitle:(NSString *)title withFrame:(CGRect )frame;
-(void)clearCache;

@end
