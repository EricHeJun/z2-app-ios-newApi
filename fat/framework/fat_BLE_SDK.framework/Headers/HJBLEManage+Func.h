//
//  HJBLEManage+Func.h
//  fat_BLE_SDK
//
//  Created by 何军 on 2021/4/7.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import <fat_BLE_SDK/fat_BLE_SDK.h>
#import "HJBLEManage.h"

@interface HJBLEManage (Func)


#pragma mark ============== 蓝牙命令操作结合 ===============
/*
 获取设备版本
 */
- (void)getDevice_VERSION_CTRL:(HJBLEHandle)callback;


/*
 系统初始化控制参数
 level 1 打开  0 锁定状态
 */
- (void)setDevice_INIT_CTRL:(NSInteger)level withCallback:(HJBLEHandle)callback;


/*
 降采样率参数
 level 档位高低 2 低 3 高
 */
- (void)setDevice_M_VALUE:(NSInteger)level withCallback:(HJBLEHandle)callback;

/*
 降采样参数 - 增益设置
 level 20 - 40  范围
 */
- (void)setDevice_DLPF_PARA:(NSInteger)level withCallback:(HJBLEHandle)callback;

/*
 动态范围参数
 level 60
 */
- (void)setDevice_DR_PARA:(NSInteger)level withCallback:(HJBLEHandle)callback;

/*
 每线扫描周期参数
 level 3ms  10ms 
 */
- (void)setDevice_LINE_CYCLE:(NSInteger)level withCallback:(HJBLEHandle)callback;

/*
 动态设置每线数据高度
 */
- (void)setBLE_ImageData_Height:(NSInteger)height;

/*
 超声开始升级指令
 */
- (void)setDevice_UPG_CTRL:(HJBLEHandle)callback;

/*
 超声开始升级完成
 */
- (void)setDevice_UPG_CTRL_End:(HJBLEHandle)callback;


/*
 超声发送包数据指令
 */
- (void)setDevice_UPG_PAGE_RD:(HJBLEHandle)callback;

/*
 超声固件升级
 */
- (void)BLEUltrasoundUpdgrade:(NSString*_Nullable)path
                     progress:(HJBLEUpgradeProgress)progress
                     callback:(HJBLEHandle)callback;

@end


