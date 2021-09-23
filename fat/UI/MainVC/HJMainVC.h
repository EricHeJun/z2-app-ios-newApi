//
//  HJMainVC.h
//  fat
//
//  Created by ydd on 2021/4/2.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import "HJBaseViewController.h"
#import "HJDeviceInfoVC.h"
#import "HJFunctionView.h"
#import "HJBLEImageDataVC.h"
#import "HJMaskView.h"
#import "HJButtonView.h"
#import "HJDeviceBgView.h"
#import "HJFMDBModel.h"
#import "HJUserInfoVC.h"
#import "HJBLEStatusView.h"
#import <SDWebImage/SDWebImage.h>
#import "HJUserInfoVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJMainVC : HJBaseViewController{
    
    dispatch_source_t _timer;
    dispatch_source_t _connectTimer;
}

@property (strong,nonatomic)HJMaskView * maskView;  //黑色蒙板
@property (strong,nonatomic)HJFunctionView * functionView; //测量功能视图

@property (strong,nonatomic)NSMutableArray * accountArr;   
@property (strong,nonatomic)HJFunctionView * accountListView; //用户列表视图

@property (strong,nonatomic)HJDeviceBgView * deviceBgView;  //设备连接视图


@property (strong,nonatomic)NSMutableArray * deviceArr;
@property (strong,nonatomic)HJFunctionView * deviceListView; //设备列表视图

@property (strong,nonatomic)HJButtonView * testAccountView;
@property (strong,nonatomic)HJButtonView * testPointView;


@property (strong,nonatomic)HJBLEStatusView * BLEStatusView;


@property (assign,nonatomic)BOOL autoDisConnect; //主动断开蓝牙连接



- (void)showMaskViewSubview:(UIView*)view;
- (void)hideMaskViewSubview:(UIView*)view;

- (void)refreshUI;

@end

NS_ASSUME_NONNULL_END
