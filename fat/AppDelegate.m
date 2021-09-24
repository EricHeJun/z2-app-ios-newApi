//
//  AppDelegate.m
//  fat
//
//  Created by ydd on 2021/4/2.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import "AppDelegate.h"
#import "HJBaseNavigationController.h"
#import "HJBaseTabBarController.h"
#import "HJLoginVC.h"
#import "HJMeVC.h"
#import "HJChatVC.h"
//#import <IQKeyboardManager/IQKeyboardManager.h>
#import "HJFMDBModel.h"
#import "HJMainVC.h"
#import "HJOSSUpload.h"
#import "HJShareUtil.h"



@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [self initData];
    
    if ([[HJCommon shareInstance] isLogin]) {
        
        [self getUserInfo];
        [self loginMain];
        
    }else{
        
        HJLoginVC * vc = [[HJLoginVC alloc] init];
        HJBaseNavigationController * nav = [[HJBaseNavigationController alloc] initWithRootViewController:vc];
        self.window.rootViewController = nav;
    }
    
    return YES;
}
#pragma mark ============== 登陆主界面 ===============
- (void)loginMain{
    
    HJMainVC * mainVc = [[HJMainVC alloc] init];
    HJBaseNavigationController * mainNav = [[HJBaseNavigationController alloc] initWithRootViewController:mainVc];
    mainNav.tabBarItem.title = KKLanguage(@"lab_tabBar_main");
    [mainNav.tabBarItem setImage:[UIImage imageNamed:@"img_tabBar_test_nor"]];
    UIImage * image = [[UIImage imageNamed:@"img_tabBar_test_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [mainNav.tabBarItem setSelectedImage:image];
    [mainNav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:KKBgYellowColor} forState:UIControlStateSelected];
    
    
    HJChatVC * chatVc = [[HJChatVC alloc] init];
    HJBaseNavigationController * chatNav = [[HJBaseNavigationController alloc] initWithRootViewController:chatVc];
    chatNav.tabBarItem.title = KKLanguage(@"lab_tabBar_chat");
    [chatNav.tabBarItem setImage:[UIImage imageNamed:@"img_tabBar_chat_nor"]];
    image = [[UIImage imageNamed:@"img_tabBar_chat_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [chatNav.tabBarItem setSelectedImage:image];
    [chatNav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:KKBgYellowColor} forState:UIControlStateSelected];
    
    
    HJMeVC * meVc = [[HJMeVC alloc] init];
    HJBaseNavigationController * meNav = [[HJBaseNavigationController alloc] initWithRootViewController:meVc];
    meNav.tabBarItem.title = KKLanguage(@"lab_tabBar_me");
    [meNav.tabBarItem setImage:[UIImage imageNamed:@"img_tabBar_me_nor"]];
    
    
    image = [[UIImage imageNamed:@"img_tabBar_me_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [meNav.tabBarItem setSelectedImage:image];
    [meNav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:KKBgYellowColor} forState:UIControlStateSelected];


    HJBaseTabBarController * tabBarVc = [[HJBaseTabBarController alloc] init];
    tabBarVc.viewControllers = @[mainNav,chatNav,meNav];
    self.window.rootViewController = tabBarVc;
    
    /*
     解决导航push后,返回时 字体颜色又变成蓝色
     */
    if (@available(iOS 13.0, *)) {
        tabBarVc.tabBar.tintColor =KKBgYellowColor;
    }

}
#pragma mark ============== 获取用户信息 ===============
- (void)getUserInfo{

    [KKHttpRequest HttpRequestType:k_POST withrequestType:NO withDataString:nil withUrl:KK_URL_api_user_info withSuccess:^(id result, NSDictionary *resultDic, HJHTTPModel *model) {
        
        if (model.errorcode == KKStatus_success) {

            
            //解析数据,存储数据库
            NSString * jsonStr = [HJAESUtil aesDecrypt:model.data];
            DLog(@"用户信息:%@",jsonStr);
            
            HJUserInfoModel * userModel = [[HJUserInfoModel alloc] initWithString:jsonStr error:nil];
            
            /*
             插入本地数据库
             */
            [HJFMDBModel userInfoInsert:userModel];
            
            /*
             保存当前登陆者信息
             */
            [HJCommon shareInstance].userInfoModel = userModel;
            
        }else if (model.errorcode == -2 ||
                  model.errorcode == -3 ||
                  model.errorcode == -8){
            
            [[HJCommon shareInstance] logout:NO toast:model.errormessage];
            
        }
        
    } withError:^(id result, NSDictionary *resultDic, HJHTTPModel *model) {
        
        
    }];
}
#pragma mark ============== 初始化 ===============
- (void)initData{
    
    
    //初始化数据库
    [HJFMDBModel creatFMDBTable];
    
    /*
     初始化默认信息
     */
    
    [self keyBoaradInit]; // 第三方键盘注册
    //退出账号，进入登录界面
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(quitAccount:)
                                                 name:KKAccount_Quit
                                               object:nil];
    
    /*
     初始化 client
     */
    [HJOSSUpload aliyunInit];
    
    /*
     初始化 sharesdk
     */
    [HJShareUtil shareInit];
    
    
    
    
}
- (void)keyBoaradInit{
    
//    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager]; // 获取类库的单例变量
//
//    keyboardManager.enable = YES; // 控制整个功能是否启用
//
//    keyboardManager.shouldResignOnTouchOutside = YES; // 控制点击背景是否收起键盘
//
//    keyboardManager.shouldToolbarUsesTextFieldTintColor = YES; // 控制键盘上的工具条文字颜色是否用户自定义
//
//    keyboardManager.toolbarManageBehaviour = IQAutoToolbarBySubviews; // 有多个输入框时，可以通过点击Toolbar 上的“前一个”“后一个”按钮来实现移动到不同的输入框
//
//    keyboardManager.enableAutoToolbar = YES; // 控制是否显示键盘上的工具条
//
//    keyboardManager.shouldShowTextFieldPlaceholder = YES; // 是否显示占位文字
//
//    keyboardManager.placeholderFont = [UIFont boldSystemFontOfSize:17]; // 设置占位文字的字体
//
//    keyboardManager.keyboardDistanceFromTextField = 10.0f; // 输入框距离键盘的距离
}
#pragma mark ============== 退出账号 ===============
- (void)quitAccount:(NSNotification*)obj{

    
    NSDictionary * dic = [obj object];

    HJLoginVC * vc = [[HJLoginVC alloc] init];
    if ([dic[@"isShow"] intValue] == YES) {
        [vc showToastInWindows:KKToastTime title:dic[@"toast"]];
    }
    
    HJBaseNavigationController * nav = [[HJBaseNavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    
}


@end
