//
//  HJBLECommon.h
//  fat_BLE_SDK
//
//  Created by 何军 on 2021/7/19.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#ifndef HJBLECommon_h
#define HJBLECommon_h

/*
 单次传递最大值
 */
#define K_MTU 175

//超声升级每笔长度
#define K_UPG_LENGTH 256


#define K_SERVER_UUID  @"5ba60001-925d-4776-9224-92f8998cd749"
#define K_WRITE_UUID   @"5ba60002-925d-4776-9224-92f8998cd749"
#define K_READ_UUID    @"5ba60003-925d-4776-9224-92f8998cd749"
#define K_IMAGE_UUID   @"5ba60004-925d-4776-9224-92f8998cd749"


/*
 电量
 */
#define BATTERY_SERVER_UUID   @"0000180f-0000-1000-8000-00805f9b34fb"
#define BATTERY_R_UUID        @"00002A19-0000-1000-8000-00805f9b34fb"

/*
 蓝牙版本信息
 */
#define DEVICE_INFO_SERVER_UUID  @"0000180A-0000-1000-8000-00805f9b34fb"

#define DEVICE_MODE_R_UUID      @"00002A24-0000-1000-8000-00805f9b34fb"
#define DEVICE_VERSION_R_UUID   @"00002A28-0000-1000-8000-00805f9b34fb"


#define KDevice_Head_New   @"MT"
#define KDevice_Head_Old   @"Z2"

// 蓝牙操作命令码
#define K_CMD_HEAD @"23E4"
#define K_CMD_END  @"FEFE"
#define K_CMD_END_upgrade  @"FEFEFE"


//设置下位机CMD
#define K_CMD_INIT_CTRL    @"10C8"
#define K_CMD_M_VALUE      @"10C0"
#define k_CMD_DLPF_PARA    @"10C1"
#define K_CMD_DR_PARA      @"10C3"
#define K_CMD_LINE_CYCLE   @"10C5"

#define K_CMD_UPG_PAGE_RD   @"10B5"
#define K_CMD_UPG_CTRL      @"10B6"
#define K_CMD_UPG_CTRL_END  @"10B7"
#define K_CMD_SAMPLE_LEN    @"10CE"
#define K_CMD_RXATE_DELAY   @"10CD"


//读取下位机回复CMD
#define K_CMD_GET_VERSION_CTRL @"01B0"
#define K_CMD_GET_INIT_CTRL    @"01C8"
#define K_CMD_GET_M_VALUE      @"01C0"
#define k_CMD_GET_DLPF_PARA    @"01C1"
#define K_CMD_GET_DR_PARA      @"01C3"
#define K_CMD_GET_LINE_CYCLE   @"01C5"
#define K_CMD_GET_SAMPLE_LEN   @"01CE"

#define K_CMD_IMAGE_UPLOAD     @"10A5"


#endif /* HJBLECommon_h */
