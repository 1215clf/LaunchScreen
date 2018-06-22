//
//  WebViewController.m
//  CLFADLaunch
//
//  Created by clf on 2018/6/21.
//  Copyright © 2018年 com.clf. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()
@property(nonatomic,strong)UIWebView *webview;
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title =@"广告";
    _webview = [[UIWebView alloc]initWithFrame:self.view.bounds];
    
    [_webview loadRequest:[[NSURLRequest alloc]initWithURL:[[NSURL alloc]initWithString:@"https://www.jianshu.com/u/533b59db5047"]]];
    
    [self.view addSubview:_webview];
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





@implementation UIViewController(getVcNav)

-(UINavigationController *)getVc_navigationController{
    
    UINavigationController *nav = nil;
    if([self isKindOfClass:[UINavigationController class]]){
        
        nav = (UINavigationController *)self;
        
    }else if ([self isKindOfClass:[UITabBarController class]]){
        
        nav = [((UITabBarController *)self).selectedViewController getVc_navigationController];
        
    }else{
        nav = self.navigationController;
    }
    return nav;
}

@end



