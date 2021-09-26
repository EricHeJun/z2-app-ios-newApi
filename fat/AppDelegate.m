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
        
        if (model.code == KKStatus_success) {
            
            //解析数据,存储数据库

            HJUserInfoModel * userModel = [[HJUserInfoModel alloc] initWithDictionary:model.data error:nil];
            
            DLog(@"用户信息:%@",userModel);
            
            /*
             插入本地数据库
             */
            [HJFMDBModel userInfoInsert:userModel];
            
            /*
             保存当前登陆者信息
             */
            [HJCommon shareInstance].userInfoModel = userModel;
            
            
            [[HJCommon shareInstance] saveUserInfo:userModel];
            
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
