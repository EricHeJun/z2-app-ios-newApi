//
//  HJBaseViewController.m
//  fat
//
//  Created by ydd on 2021/4/2.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import "HJBaseViewController.h"
#import "AFNetworkReachabilityManager.h"

@interface HJBaseViewController ()


@property (strong,nonatomic)UIView * navBgView;
@end

@implementation HJBaseViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = kkWhiteColor;
    
    // 1、设置导航栏半透明
    [self.navigationController.navigationBar setTranslucent:YES];
      // 2、设置导航栏背景图片
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
      // 3、设置导航栏阴影图片
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    //导航字体颜色
    [self navTitleColor:kkWhiteColor];
    
    //返回按钮
    [self addBackBtnWithImage:LeftBtnNone];
    
    [self addNavBackgroundColor:KKBgYellowColor];

    
}
//导航背景色
- (void)addNavBackgroundColor:(UIColor*)color{
    
    if (!_navBgView) {
        UIView * navBgView = [[UIView alloc] init];
        _navBgView = navBgView;
    }
    
    _navBgView.frame = CGRectMake(0, 0, KKSceneWidth, KKNavBarHeight);
    _navBgView.backgroundColor = color;
    [self.view addSubview:_navBgView];

}

//导航字体颜色
- (void)navTitleColor:(UIColor*)color{
    //字体颜色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : color, NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:17]}];
}

#pragma mark ============== UI ===============
- (void)addBackBtnWithImage:(enum LeftBtnType)type{
    
    //隐藏默认的返回箭头
    self.navigationController.navigationBar.backIndicatorImage = [UIImage new];
    self.navigationController.navigationBar.backIndicatorTransitionMaskImage = [UIImage new];
    
    UIImage * image;
    
    if (type == LeftBtnGray){
        
        image = [UIImage imageNamed:@"img_common_back_gray"];
        
    }else{
        
        image =[UIImage imageNamed:@"img_common_back_white"];
    }

    //只显示图片
    UIBarButtonItem * backItem  = [[UIBarButtonItem alloc] initWithImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:nil action:nil];
   self.navigationItem.backBarButtonItem =  backItem;
    
}

- (void)addLeftBtnWithImage:(enum LeftBtnType)type{
    
    //隐藏默认的返回箭头
    self.navigationController.navigationBar.backIndicatorImage = [UIImage new];
    self.navigationController.navigationBar.backIndicatorTransitionMaskImage = [UIImage new];
    
    UIImage * image;
    
    if (type == LeftBtnGray){
        
        image = [UIImage imageNamed:@"img_common_back_gray"];
        
    }else if(type == LeftBtnNone){
        
        image =[UIImage imageNamed:@"common_back_black"];
        
    }else if (type == LeftBtnCancel){
        
        image =[UIImage imageNamed:@"common_bg_cancel"];
        
    }else if(type == LeftBtnWhite){
        
        image =[UIImage imageNamed:@"img_common_back_white"];
    }
    
    //只显示图片
    UIBarButtonItem * backItem  = [[UIBarButtonItem alloc] initWithImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(leftBack)];
    
    self.navigationItem.leftBarButtonItem =  backItem;

}
/// 返回
- (void)leftBack{
    DLog(@"leftBack");
}

- (void)addBackBtnWithString:(NSString *)string{
    
    //只显示文字
     UIBarButtonItem * backItem  = [[UIBarButtonItem alloc] initWithTitle:string style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    //更改返回按钮文字颜色
    self.navigationController.navigationBar.tintColor = [UIColor redColor];
    
    //隐藏默认的返回箭头
    self.navigationController.navigationBar.backIndicatorImage = [UIImage new];
    self.navigationController.navigationBar.backIndicatorTransitionMaskImage = [UIImage new];
    
}

- (void)addRightBtnOneWithImage:(enum RightBtnType)type{
    
    UIImage * image ;
    if (type == RightBtnAddAccount) {
        image = [UIImage imageNamed:@"img_me_add_account"];
    }else if(type == RightBtnAddShare){
        image = [UIImage imageNamed:@"img_common_share"];
    }else if (type == RightBtnMore){
        image = [UIImage imageNamed:@"img_common_more"];
    }
    
    UIBarButtonItem * right1 = [[UIBarButtonItem alloc] initWithImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnOneClick:)];
    right1.tag = KKButton_Main_AddAcount;
    
    self.navigationItem.rightBarButtonItems = @[right1];
}

- (void)addRightBtnOneWithString:(NSString *)string{
    
    //只显示文字
    UIBarButtonItem * backItem  = [[UIBarButtonItem alloc] initWithTitle:string style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnOneClick:)];
    
    self.navigationItem.rightBarButtonItem = backItem;
    
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kk_sizefont(KKFont_Normal),NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    //更改返回按钮文字颜色
    self.navigationController.navigationBar.tintColor = kkWhiteColor;
    
}

- (void)addRightBtnTwoWithImage:(NSArray*)typeArr{
    
    float NavBarHeight = self.navigationController.navigationBar.frame.size.height;
    
    UIImage * image1 = [UIImage imageNamed:@"img_btn_searchBLE"];
    
    
    UIView * rightView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, NavBarHeight-10, NavBarHeight)];
    
    UIButton *rightBtn1 = [[UIButton alloc] initWithFrame:CGRectMake(rightView1.frame.size.width-image1.size.width, rightView1.frame.size.height/2-image1.size.height/2, image1.size.width, image1.size.height)];
    [rightBtn1 addTarget:self action:@selector(rightBtnTwoClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn1 setImage:image1 forState:UIControlStateNormal];
    rightBtn1.tag = KKButton_SearchBLE;
    [rightView1 addSubview:rightBtn1];
    
    UIBarButtonItem * right1 = [[UIBarButtonItem alloc] initWithCustomView:rightView1];
    
    
    UIImage * image2 = [UIImage imageNamed:@"img_btn_next"];
    UIView * rightView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, rightView1.frame.size.width, NavBarHeight)];
    
    UIButton *rightBtn2 = [[UIButton alloc] initWithFrame:CGRectMake(rightView2.frame.size.width-image2.size.width, rightView2.frame.size.height/2-image2.size.height/2, image2.size.width, image2.size.height)];
    [rightBtn2 addTarget:self action:@selector(rightBtnTwoClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn2 setImage:image2 forState:UIControlStateNormal];
    [rightView2 addSubview:rightBtn2];
    rightBtn2.tag = KKButton_Device_Info;
    UIBarButtonItem * right2 = [[UIBarButtonItem alloc] initWithCustomView:rightView2];
    

    self.navigationItem.rightBarButtonItems = @[right2,right1];
    
    
    
    /*
    
    UIBarButtonItem * right1 = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"img_btn_searchBLE"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnTwoClick:)];

    right1.tag = KKButton_SearchBLE;
    
    UIBarButtonItem * right2 = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"img_btn_next"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnTwoClick:)];
    right2.tag = KKButton_Device_Info;
    

    self.navigationItem.rightBarButtonItems = @[right2,right1];
     */
    
}

- (void)addRightBtnTwoWithString:(NSString *)string{
    //只显示文字
    UIBarButtonItem * backItem  = [[UIBarButtonItem alloc] initWithTitle:string style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnTwoClick:)];
    self.navigationItem.rightBarButtonItem = backItem;
    
    //更改返回按钮文字颜色
    self.navigationController.navigationBar.tintColor = kkWhiteColor;
}


#pragma mark ============== 点击事件 ===============
- (void)rightBtnOneClick:(UIButton*)sender{
    NSLog(@"rightBtnOneClick");
}

- (void)rightBtnTwoClick:(UIButton*)sender{
    NSLog(@"rightBtnTwoClick");
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


#pragma mark ============== toast显示 ===============
- (void)showLoadingInView:(UIView*)view
                     time:(NSTimeInterval)time
                    title:(NSString*)title{
    dispatch_async(dispatch_get_main_queue(), ^{
        

        /*
         设置菊花颜色
         */
        [UIActivityIndicatorView appearanceWhenContainedIn:[MBProgressHUD class], nil].color = [UIColor whiteColor];
        
        
        [self.hud removeFromSuperview];
        
        
        [view addSubview:self.hud];
        self.hud.frame = view.bounds;
        self.hud.mode = MBProgressHUDModeIndeterminate;
        self.hud.offset=CGPointMake(self.hud.offset.x, 0);
        self.hud.label.text = [title isKindOfClass:[NSString class]]?title:@"";
        self.hud.label.numberOfLines = 0;
        
       
        
        self.hud.label.textColor = [UIColor whiteColor];
        self.hud.bezelView.backgroundColor = kkTextBlackColor;
        self.hud.bezelView.alpha = 0.65;
        
        [self.hud showAnimated:YES];
        
        [self.hud hideAnimated:YES afterDelay:time];
        [view endEditing:YES];
        
    });
}

- (void)showLoadingInWindows:(NSTimeInterval)time
                       title:(NSString*)title{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [UIActivityIndicatorView appearanceWhenContainedIn:[MBProgressHUD class], nil].color = [UIColor whiteColor];
        
        
        [self.hud removeFromSuperview];
        UIWindow * win = (UIWindow *)[UIApplication sharedApplication].delegate.window;
        [win addSubview:self.hud];
        self.hud.frame = win.bounds;
         self.hud.mode = MBProgressHUDModeIndeterminate;
        self.hud.offset=CGPointMake(self.hud.offset.x, 0);
        self.hud.label.text = [title isKindOfClass:[NSString class]]?title:@"";
        self.hud.label.numberOfLines = 0;
        
        
       
        
        self.hud.label.textColor = [UIColor whiteColor];
        self.hud.bezelView.backgroundColor = kkTextBlackColor;
        self.hud.bezelView.alpha = 0.65;
        
        [self.hud showAnimated:YES];
        
        [self.hud hideAnimated:YES afterDelay:time];
      
    });
}
- (void)showProgressInWindows:(NSTimeInterval)time
                        title:(NSString*)title
                     progress:(float)progress{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.hud removeFromSuperview];
        UIWindow * win = (UIWindow *)[UIApplication sharedApplication].delegate.window;
        [win addSubview:self.hud];
        self.hud.frame = win.bounds;
         self.hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
        self.hud.offset=CGPointMake(self.hud.offset.x, 0);
        self.hud.label.text = [title isKindOfClass:[NSString class]]?title:@"";
        self.hud.label.numberOfLines = 0;
        self.hud.progress = progress;
        
        self.hud.label.textColor = [UIColor whiteColor];
        self.hud.bezelView.backgroundColor = kkTextBlackColor;
        self.hud.bezelView.alpha = 0.65;
        
        [self.hud showAnimated:YES];
        [self.hud hideAnimated:YES afterDelay:time];
      
      
    });
}
- (void)showToastInView:(UIView*)view
                   time:(NSTimeInterval)time
                  title:(NSString*)title{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.hud removeFromSuperview];
        [view addSubview:self.hud];
        self.hud.frame = view.bounds;
        self.hud.mode = MBProgressHUDModeText;
        self.hud.offset=CGPointMake(self.hud.offset.x, view.frame.size.height/2 - 150);
        self.hud.label.text =  [title isKindOfClass:[NSString class]]?title:@"";
        self.hud.label.numberOfLines = 0;
        self.hud.label.textColor = [UIColor whiteColor];
//        self.hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        
        //设置等待框背景色为黑色
        self.hud.bezelView.backgroundColor = kkTextBlackColor;
        self.hud.bezelView.alpha = 0.65;
     
        [self.hud showAnimated:YES];
        
        [self.hud hideAnimated:YES afterDelay:time];
        [view endEditing:YES];
       
    });
}

- (void)showToastInWindows:(NSTimeInterval)time
                     title:(NSString*)title{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.hud removeFromSuperview];
        UIWindow * win = (UIWindow *)[UIApplication sharedApplication].delegate.window;
        [win addSubview:self.hud];
        self.hud.frame = win.bounds;
        self.hud.mode = MBProgressHUDModeText;
        self.hud.offset=CGPointMake(self.hud.offset.x, win.frame.size.height/2 - 150);
        self.hud.label.text = [title isKindOfClass:[NSString class]]?title:@"";
        self.hud.label.numberOfLines = 0;
        
        self.hud.label.textColor = [UIColor whiteColor];
        self.hud.bezelView.backgroundColor = kkTextBlackColor;
        self.hud.bezelView.alpha = 0.65;
        
        [self.hud showAnimated:YES];
    
        [self.hud hideAnimated:YES afterDelay:time];
        
    });
}

- (void)showToastInWindows:(NSTimeInterval)time
                     title:(NSString*)title
    userInteractionEnabled:(BOOL)userInteractionEnabled{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.hud removeFromSuperview];
        UIWindow * win = (UIWindow *)[UIApplication sharedApplication].delegate.window;
        [win addSubview:self.hud];
        self.hud.frame = win.bounds;
        self.hud.mode = MBProgressHUDModeText;
        self.hud.offset=CGPointMake(self.hud.offset.x, win.frame.size.height/2 - 150);
        self.hud.label.text = [title isKindOfClass:[NSString class]]?title:@"";
        self.hud.label.numberOfLines = 0;
        
        self.hud.label.textColor = [UIColor whiteColor];
        self.hud.bezelView.backgroundColor = kkTextBlackColor;
        self.hud.bezelView.alpha = 0.65;
        
        [self.hud showAnimated:YES];
        
        [self.hud hideAnimated:YES afterDelay:time];
        
        self.hud.userInteractionEnabled = userInteractionEnabled;
        
    });
}


- (void)hideLoading{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.hud hideAnimated:NO];
    });
    
}

- (MBProgressHUD*)hud{
    
    if (!_hud) {
        _hud = [[MBProgressHUD alloc] init];
        _hud.removeFromSuperViewOnHide = YES; //当隐藏时，移除视图
    }
    return _hud;
}

#pragma mark ============== 倒计时按钮 ===============
- (void)startCountDownAction:(UIButton*)sender{
    //开始倒计时
    __block NSInteger time = 59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置按钮的样式
                [sender setTitle:KKLanguage(@"lab_login_vcode_countDown") forState:UIControlStateNormal];
                sender.userInteractionEnabled = YES;
            });
        }else{
            
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置按钮显示读秒效果
                [sender setTitle:[NSString stringWithFormat:@"%@%d",KKLanguage(@"lab_login_vcode_countDown"),seconds] forState:UIControlStateNormal];
                sender.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}
#pragma mark ============== sheetView ===============
- (void)showAlertSheetTitle:(NSString*)title
                    message:(NSString*)message
                    dataArr:(NSArray*)dataArr
                   callback:(callback)result{
    

    title = title.length == 0?nil:title;
    message = message.length == 0?nil:message;
    
    UIAlertControllerStyle style = UIAlertControllerStyleActionSheet;
    
    if (kISiPad) {
        style = UIAlertControllerStyleAlert;
    }
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:style];
    
    
    for (int i=0; i<dataArr.count; i++) {
        NSString * objString = dataArr[i];
        UIAlertAction *resetAction = [UIAlertAction actionWithTitle:objString style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"Reset Action");
            result(i,objString);
            
        }];
        [alert addAction:resetAction];
        [resetAction setValue:kkBgRedColor forKey:@"_titleTextColor"];
        
    }
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:KKLanguage(@"lab_common_cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Cancel Action");
    }];
    
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:^{
        
    }];
    

}


#pragma mark ============== alertView ===============
- (void)showAlertViewTitle:(NSString*)title
                   message:(NSString*)message
                   dataArr:(NSArray*)dataArr
                  callback:(callback)result{
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    for (int i=0; i<dataArr.count; i++) {
        NSString * objString = dataArr[i];
        UIAlertAction *resetAction = [UIAlertAction actionWithTitle:objString style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"Reset Action");
            result(i,objString);
        }];
        
        [alert addAction:resetAction];
    }
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:KKLanguage(@"lab_common_cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Cancel Action");
        result(0,KKLanguage(@"lab_common_cancel"));
    }];
         // A
    [alert addAction:cancelAction];       // B
    
    [self presentViewController:alert animated:YES completion:^{
        
    }];
}

#pragma mark ============== alertView - ok ===============
- (void)showOkAlertViewTitle:(NSString*)title
                   message:(NSString*)message
                   dataArr:(NSArray*)dataArr
                  callback:(callback)result{
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:KKLanguage(@"lab_common_ok") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        result(0,KKLanguage(@"lab_common_ok"));
    }];
         // A
    [alert addAction:cancelAction];       // B
    
    [self presentViewController:alert animated:YES completion:^{
        
    }];
}

#pragma mark ============== 更新app ===============
- (void)getAppStoreInfo:(BOOL)showToast{
   
    NSURL *appUrl = [NSURL URLWithString:@"http://itunes.apple.com/cn/lookup?id=1561308478"];
    
    NSString *appInfoString = [NSString stringWithContentsOfURL:appUrl encoding:NSUTF8StringEncoding error:nil];
    
    NSError * error = nil;
    
    NSData * appInfoData = [appInfoString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *appInfoDic;
    
    if (appInfoData) {
        
        appInfoDic =[NSJSONSerialization JSONObjectWithData:appInfoData options:NSJSONReadingMutableLeaves error:&error];
    }
    
    if(!error && appInfoDic){
        
        NSDictionary *appResultsDict = [appInfoDic[@"results"] lastObject];
        NSString *appStoreVersion = appResultsDict[@"version"];
        NSString * appUrl=appResultsDict[@"trackViewUrl"];
        
        NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        
        if ([currentVersion compare:appStoreVersion options:NSNumericSearch] == NSOrderedAscending ){
            
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:KKLanguage(@"tips_newVersion") message:KKLanguage(@"tips_newVersion_message") preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *resetAction = [UIAlertAction actionWithTitle:KKLanguage(@"lab_common_confirm") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appUrl] options:@{} completionHandler:^(BOOL success) {
                    
                }];
                
            }];
            
            [alert addAction:resetAction];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:KKLanguage(@"lab_common_cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"Cancel Action");
            }];
            
            [alert addAction:cancelAction];       // B
            
            [self presentViewController:alert animated:YES completion:^{
                
            }];
            
        }else{
            
            if (showToast) {
                [self showToastInWindows:KKToastTime title:KKLanguage(@"lab_me_userInfo_text6")];
            }
        
        }
    }
}

//获取当前视图控制器
- (UIViewController *)getCurrentVC{
    
    //获得当前活动窗口的根视图
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *currentShowingVC = [self findCurrentShowingViewControllerFrom:vc];
    return currentShowingVC;

}

//注意考虑几种特殊情况：①A present B, B present C，参数vc为A时候的情况
/* 完整的描述请参见文件头部 */
- (UIViewController *)findCurrentShowingViewControllerFrom:(UIViewController *)vc{
    //方法1：递归方法 Recursive method
    UIViewController *currentShowingVC;
    if ([vc presentedViewController]) { //注要优先判断vc是否有弹出其他视图，如有则当前显示的视图肯定是在那上面
        // 当前视图是被presented出来的
        UIViewController *nextRootVC = [vc presentedViewController];
        currentShowingVC = [self findCurrentShowingViewControllerFrom:nextRootVC];
        
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        UIViewController *nextRootVC = [(UITabBarController *)vc selectedViewController];
        currentShowingVC = [self findCurrentShowingViewControllerFrom:nextRootVC];
        
    } else if ([vc isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        UIViewController *nextRootVC = [(UINavigationController *)vc visibleViewController];
        currentShowingVC = [self findCurrentShowingViewControllerFrom:nextRootVC];
        
    } else {
        // 根视图为非导航类
        currentShowingVC = vc;
    }
    
    return currentShowingVC;

}



@end
