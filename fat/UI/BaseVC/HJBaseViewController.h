//
//  HJBaseViewController.h
//  fat
//
//  Created by ydd on 2021/4/2.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJBaseView.h"
#import <fat_BLE_SDK/fat_BLE_SDK.h>
#import <fat_BLE_SDK/HJBLEManage+Func.h>
#import <MBProgressHUD.h>

enum LeftBtnType {
    LeftBtnNone = 0,
    LeftBtnGray,
    LeftBtnCancel,
    LeftBtnWhite,
};

enum RightBtnType {
    
    RightBtnMore = 3,
    
    RightBtnSearchBLE,
    
    RightBtnDeviceInfo,
    
    RightBtnAddAccount,
    
    RightBtnAddShare,
    
};

typedef void (^callback)(NSInteger index,NSString * titleString);

@interface HJBaseViewController : UIViewController

/// 不可变数据源
@property (strong,nonatomic)NSArray * dataArr;
@property (strong,nonatomic)NSDictionary * dataDic;


/// 可变数据源
@property (strong,nonatomic)NSMutableArray * mutableDataArr;
@property (strong,nonatomic)NSMutableDictionary * mutableDataDic;

@property (strong,nonatomic)MBProgressHUD * hud;

//@property (strong,nonatomic)HJUserInfoModel * userInfoModel;       //当前用户信息
//@property (strong,nonatomic)HJVendorInfoModel * vendorInfoModel;   //当前商户信息


//导航字体颜色
- (void)navTitleColor:(UIColor*)color;

//导航背景颜色
- (void)addNavBackgroundColor:(UIColor*)color;

//导航左侧按钮
- (void)addBackBtnWithImage:(enum LeftBtnType)type;
- (void)addBackBtnWithString:(NSString *)string;

- (void)addLeftBtnWithImage:(enum LeftBtnType)type;
- (void)leftBack;

//导航右侧按钮
- (void)addRightBtnOneWithImage:(enum RightBtnType)type;
- (void)addRightBtnOneWithString:(NSString *)string;

//导航右侧按钮2
- (void)addRightBtnTwoWithImage:(NSArray*)typeArr;
- (void)addRightBtnTwoWithString:(NSString *)string;



#pragma mark ============== 点击事件 ===============
- (void)rightBtnOneClick:(UIButton*)sender;
- (void)rightBtnTwoClick:(UIButton*)sender;


#pragma mark ============== toast显示 ===============
- (void)showLoadingInView:(UIView*)view
                     time:(NSTimeInterval)time
                    title:(NSString*)title;

- (void)showLoadingInWindows:(NSTimeInterval)time
                       title:(NSString*)title;


- (void)showToastInView:(UIView*)view
                   time:(NSTimeInterval)time
                  title:(NSString*)title;

- (void)showToastInWindows:(NSTimeInterval)time
                     title:(NSString*)title;

/*
 是否可以点击其他区域
 */
- (void)showToastInWindows:(NSTimeInterval)time
                     title:(NSString*)title
    userInteractionEnabled:(BOOL)userInteractionEnabled;

- (void)showProgressInWindows:(NSTimeInterval)time
                        title:(NSString*)title
                     progress:(float)progress;

- (void)hideLoading;


#pragma mark ============== sheetView ===============
- (void)showAlertSheetTitle:(NSString*)title
                    message:(NSString*)message
                    dataArr:(NSArray*)dataArr
                   callback:(callback)result;

- (void)showAlertViewTitle:(NSString*)title
                   message:(NSString*)message
                   dataArr:(NSArray*)dataArr
                  callback:(callback)result;


- (void)showOkAlertViewTitle:(NSString*)title
                     message:(NSString*)message
                     dataArr:(NSArray*)dataArr
                    callback:(callback)result;


#pragma mark ============== 倒计时按钮 ===============
- (void)startCountDownAction:(UIButton*)sender;



#pragma mark ============== 更新app ===============
- (void)getAppStoreInfo:(BOOL)showToast;



/*
 获取当前视图控制器
 */
-(UIViewController *)getCurrentVC;

@end


