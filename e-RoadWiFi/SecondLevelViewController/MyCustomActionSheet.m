//
//  MyCustomActionSheet.m
//  e-RoadWiFi
//
//  Created by QC on 14-12-22.
//  Copyright (c) 2014年 G.MING. All rights reserved.
//

#import "MyCustomActionSheet.h"
#import "MyButton.h"
@interface MyCustomActionSheet ()

@end

@implementation MyCustomActionSheet

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatCustomSheet];

    
    // Do any additional setup after loading the view.
}

-(void)creatCustomSheet{

    NSArray *titles=@[@"字体大小"];
   
    
    
    UIImageView *bgview=[[UIImageView alloc]initWithFrame:CGRectMake(90, 10, 210, 44)];
    bgview.image=[[UIImage imageNamed:@"ACbut.png"]stretchableImageWithLeftCapWidth:5 topCapHeight:10];
    
    
    [self.view addSubview:bgview];
    
    
    for (int j=0; j<1; j++) {
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 25, 70, 20)];
        label.text=titles[j];
        label.font=[UIFont systemFontOfSize:15];
        label.textAlignment=NSTextAlignmentCenter;
        [self.view addSubview:label];

        
    }
    
    
    UIView *lineView1=[[UIView alloc]initWithFrame:CGRectMake(70,0,0.5, 44)];
    lineView1.backgroundColor=[UIColor colorWithRed:215/255.f green:217/255.f blue:223/255.f alpha:0.7];
    [bgview addSubview:lineView1];
    
    UIView *lineView2=[[UIView alloc]initWithFrame:CGRectMake(140,0,0.5, 44)];
    lineView2.backgroundColor=[UIColor colorWithRed:215/255.f green:217/255.f blue:223/255.f alpha:0.7];
    [bgview addSubview:lineView2];
    
    
    for (int i=0; i<3; i++) {
        
        MyButton *button=[MyButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(100+70*i,18, 50, 30);
        button.tag=40012+i;
        [button addTarget:self action:@selector(btn:)];
        [button setNTitleColor:[UIColor blackColor]];
        [button setSTitleColor:[UIColor colorWithRed:0/255.0f green:172/255.0f blue:238/255.0f alpha:1]];
        
        
        
        [self.view addSubview:button];
        
        if (i==0) {
            [button setNTitle:@"小"];
            button.titleLabel.font=[UIFont systemFontOfSize:13];
        }else if (i==1){
            [button setNTitle:@"中"];
            button.titleLabel.font=[UIFont systemFontOfSize:15];
        }else{
            
            [button setNTitle:@"大"];
            button.titleLabel.font=[UIFont systemFontOfSize:17];
        }
        
    }
    
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    if ([[def objectForKey:@"fountSize"] isEqual:@"100%"]) {
        MyButton *selbutton=(MyButton *)[self.view viewWithTag:40012];
        [selbutton setNTitleColor:[UIColor colorWithRed:0/255.0f green:172/255.0f blue:238/255.0f alpha:1]];
        
    }else if ([[def objectForKey:@"fountSize"]isEqual:@"110%"]){
        MyButton *selbutton=(MyButton *)[self.view viewWithTag:40013];
        [selbutton setNTitleColor:[UIColor colorWithRed:0/255.0f green:172/255.0f blue:238/255.0f alpha:1]];
    }else{
        
        MyButton *selbutton=(MyButton *)[self.view viewWithTag:40014];
        [selbutton setNTitleColor:[UIColor colorWithRed:0/255.0f green:172/255.0f blue:238/255.0f alpha:1]];
    }

}

-(void)btn:(MyButton *)button{
    
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    
    for (int i=0; i<3; i++) {
        MyButton *btn=(MyButton *)[self.view viewWithTag:40012+i];
        if (btn.tag==button.tag) {
            
            [btn setNTitleColor:[UIColor colorWithRed:0/255.0f green:172/255.0f blue:238/255.0f alpha:1]];
        }else{
            [btn setNTitleColor:[UIColor blackColor]];
            
        }
        
    }
    

    if (button.tag==40012) {
        [_myWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '100%'"];
        [def setObject:@"100%" forKey:@"fountSize"];
        
    }else if (button.tag==40013){
        [_myWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '110%'"];
        [def setObject:@"110%" forKey:@"fountSize"];
    }else{
        [_myWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '120%'"];
        [def setObject:@"120%" forKey:@"fountSize"];
    }
    [def synchronize];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
