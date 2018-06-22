//
//  CLFADLaunch.m
//  CLFADLaunch
//
//  Created by clf on 2018/6/21.
//  Copyright © 2018年 com.clf. All rights reserved.
//

#import "CLFADLaunch.h"
#import "WebViewController.h"

@interface CLFADLaunch()
@property (nonatomic, strong) UIWindow* window;
@property (nonatomic, strong) UIButton* goBtn;
@property (nonatomic, assign) NSInteger goCount;
@end

@implementation CLFADLaunch

+(void)load
{
    [self shareInstance];
}



+(instancetype)shareInstance{
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
    });
    return instance;
}



/**
 instancetype的作用，就是使那些非关联的方法返回所在类的类型。
 
 【instancetype和id的异同】
 相同点：都可以作为方法的返回类型。
 不同点：
 （1）instancetype可以返回方法所在类相同类型的对象，id只能返回未知类型的对象；
 （2）instancetype只能作为返回值，不能像id一样作为参数；
 
 注意点：
 1.对于init方法，id和instancetype是没有区别的。因为编译器会把id优化为instancetype。当明确返回的类型就是当前类时，使用instancetype能避免id带来的编译不出的错误情况。
 */
-(instancetype)init
{
    self = [super init];
    if(self){
        
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            ///要等DidFinished方法结束后才能初始化UIWindow，不然会检测是否有rootViewController
            [self checkHadAdvertising];
        }];
        
        
        [[NSNotificationCenter defaultCenter]addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            [self requestAdvertising];
        }];
        
        [[NSNotificationCenter defaultCenter]addObserverForName:UIApplicationWillEnterForegroundNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            ///进入前台，显示广告
            [self checkHadAdvertising];
        }];
    }
    
    return self;
}

///先检查本地是否有广告图，有则显示，无则进行请求
-(void)checkHadAdvertising{
    ///这里直接显示
    [self showAdvertising];
}

///请求新的广告
-(void)requestAdvertising{
    
}

///显示广告
-(void)showAdvertising{
    UIWindow *window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    window.rootViewController = [UIViewController new];
    window.rootViewController.view.backgroundColor = [UIColor clearColor];
    window.rootViewController.view.userInteractionEnabled = NO;
    
    ///默认隐藏
    window.hidden = NO;
    window.alpha = 1;
    ///设置window的显示级别，nomal<StatusBar<Alert
    ///防止被键盘或者alertview视图覆盖
    window.windowLevel = UIWindowLevelAlert + 1;
    
    [self settingView:window];
    
    ///显示window，防止被释放，释放需要手动
    self.window = window;
}

-(void)hidden{
    [UIView animateWithDuration:0.5 animations:^{
        self.window.alpha = 0;
    } completion:^(BOOL finished) {
        [self.window.subviews.copy enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        
        ///这里使用remove是没有用的，因为自建self.window没有父视图，所以需要置为nil
        self.window.hidden = YES ;
        self.window = nil;
    }];
}


-(void)settingView:(UIWindow *)window
{
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:window.bounds];
    
    imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"default%d.jpg",rand()%4]];
    ///默认是NO
    imgView.userInteractionEnabled = YES;
    [imgView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoAdView)]];
    [window addSubview:imgView];
    
    self.goCount = 3;
    

    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(window.bounds.size.width-120, 20, 100, 60)];
    
    [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [btn addTarget:self action:@selector(goAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [window addSubview:btn];
    self.goBtn = btn;
    [self timer];
}
-(void)goAction:(UIButton *)btn{
    [self hidden];
}

-(void)timer{
    [self.goBtn setTitle:[NSString stringWithFormat:@"跳过：%ld",self.goCount] forState:UIControlStateNormal];
    if(self.goCount<=0){
        [self hidden];
    }else{
        self.goCount--;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self timer];
        });
    }
}

-(void)gotoAdView{
    
    NSLog(@"进来了");
    ///这里不直接使用[UIApplication sharedApplication].keyWindow,因为当有AlertView 或者有键盘弹出时， 取到的KeyWindow是错误的。
    NSLog(@"%@\n%@",[UIApplication sharedApplication].keyWindow,[[UIApplication sharedApplication].delegate window]);
    UIViewController *rootVC = [[UIApplication sharedApplication].delegate window].rootViewController ;
    ///这里我们知道当前vc就是一个navigationcontroller，可以直接跳转，但是最好还是判断一下
//    [(UINavigationController *)rootVC pushViewController:[WebViewController new] animated:YES];
    
    ///获取一下当前viewcontroller的navigationcontroller
    [rootVC.getVc_navigationController pushViewController:[WebViewController new] animated:YES];
    
    [self hidden];
}





@end
