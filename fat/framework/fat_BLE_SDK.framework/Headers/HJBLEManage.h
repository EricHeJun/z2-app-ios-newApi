//
//  HJBLEManage.h
//  fat_BLE_SDK
//
//  Created by ydd on 2021/4/2.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreBluetooth/CBL2CAPChannel.h>
#import "HJBLETools.h"
#import "HJBLECommon.h"

//蓝牙状态
typedef NS_ENUM(NSInteger,KKBLEStatus){
    
    KKBLEStatus_OFF,
    KKBLEStatus_ON,  
    KKBLEStatus_Unsupported,
    KKBLEStatus_Unauthorized,
    KKBLEStatus_UNKnow

};

//蓝牙连接状态
typedef NS_ENUM(NSInteger,KKBLEConnectStatus){
    
    KKBLEConnectStatus_disconnect,
    KKBLEConnectStatus_connect,
};

//蓝牙指令操作
typedef NS_ENUM(NSInteger,KKBLEActionStatus){
    
    KKBLEActionStatus_list = 0,
    
    KKBLEActionStatus_version_ctrl,
    KKBLEActionStatus_init_ctrl,
    KKBLEActionStatus_m_value,
    KKBLEActionStatus_dlpf_para,
    KKBLEActionStatus_dr_para,
    KKBLEActionStatus_line_cycle,
    
    KKBLEActionStatus_image_upload,
    KKBLEActionStatus_image_upload_start,
    
    KKBLEActionStatus_UPG_CTRL,
    KKBLEActionStatus_UPG_CTRL_END,
    KKBLEActionStatus_UPG_PAGE_RD,
    
    KKBLEActionStatus_Battery_level,
    KKBLEActionStatus_Model_Number,
    KKBLEActionStatus_Software_Revision,
    
};


/**
 @remark 统一API返回Handle
 
 @param isSucceeded API Result是否成功, Http fail以及server fail都是false，只有成功结果返回为true
 @param response 如果成功则为返回数据，失败为nil 
 
 注:当KKBLEActionStatus == KKBLEActionStatus_image_upload时,返回NSArray类型[每线位置,图像状态标识,数据]
 
 @param error 如果失败则为失败错误码，成功为nil
 */
typedef void (^_Nonnull HJBLEHandle)(NSInteger KKBLEActionStatus,BOOL isSucceeded, id _Nullable response, NSError *_Nullable error);

/*
 升级进度
 process:0 - 1
 isSucceeded  状态
 */
typedef void (^_Nonnull HJBLEUpgradeProgress)(float progress,BOOL isSucceeded,id _Nullable response, NSError *_Nullable error);


@interface HJBLEManage : NSObject<CBPeripheralManagerDelegate,CBPeripheralDelegate>

//蓝牙中心管理者
@property (strong, nonatomic)CBCentralManager *_Nullable centralManager;
//蓝牙外设
@property (nonatomic, strong)CBPeripheral *_Nullable peripheral;
//写入特征值
@property (strong,nonatomic)CBCharacteristic * _Nullable characteristic;

//API_AVAILABLE(ios(11.0))
@property (strong,nonatomic)CBL2CAPChannel * L2CapChannel;

//蓝牙指令的回调
@property (nonatomic,strong)HJBLEHandle orderResult;

/*
 蓝牙连接状态
 */
@property (assign,nonatomic)BOOL isConnect;

/*
 蓝牙是否打开
 */
@property (assign,nonatomic)BOOL BLEPoweredOn;

/*
 每线数据的高度
 */
@property (assign,nonatomic)NSInteger BLE_ImageData_Height;


//蓝牙初始化
+ (instancetype _Nullable )sharedCentral;

//取消搜索
- (void)cancelSeach;

//设备列表
- (void)searchDeviceList:(HJBLEHandle)callback;

//连接设备
- (void)connectDevice:(CBPeripheral*_Nullable)peripheral;

//断开设备
- (void)disconnectDevice:(CBPeripheral*_Nullable)peripheral;

/*
 蓝牙图像数据开始传输回调
 */
- (void)BLEImageDataStartTransmission:(HJBLEHandle)callback;

/*
 蓝牙图像数据通知
 */
- (void)BLEImageData:(HJBLEHandle)callback;

/*
 蓝牙中心管理者状态通知
 */
- (void)BLEStatus:(HJBLEHandle)callback;

/*
 蓝牙连接状态通知
 */
- (void)BLEConnectStatus:(HJBLEHandle)callback;

/*
 蓝牙电量 / 固件版本
 */
- (void)BLEInfoStatus:(HJBLEHandle)callback;

@end


