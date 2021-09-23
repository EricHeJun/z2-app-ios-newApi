//
//  HJBLEManage.m
//  fat_BLE_SDK
//
//  Created by ydd on 2021/4/2.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import "HJBLEManage.h"
#import "HJBLEManage+Func.h"

@interface HJBLEManage()


//image Byte 每线数组
@property (strong,nonatomic)NSMutableData * imageData;

//设备列表
@property (strong,nonatomic)HJBLEHandle deviceListResult;
//图像数据开始传输
@property (strong,nonatomic)HJBLEHandle imageDataStartResult;
//图像数据
@property (strong,nonatomic)HJBLEHandle imageDataResult;

@property (strong,nonatomic)HJBLEHandle BLEStatusResult;

@property (strong,nonatomic)HJBLEHandle BLEConnectStatusResult;

@property (strong,nonatomic)HJBLEHandle BLEInfoStatuResult;

@end

@implementation HJBLEManage

+ (instancetype)sharedCentral{
    
    static HJBLEManage * blemanage = nil;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        
        blemanage = [[HJBLEManage alloc] init];
        
    });
    
    return blemanage;
    
}


- (instancetype)init{
    
    if (self = [super init]){
        
        _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        _imageData = [NSMutableData data];
        
    }
    return self;
}

#pragma mark ============== 蓝牙状态方法(系统自己调用) ===============
- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    
    NSInteger  state = KKBLEStatus_UNKnow;
    
    switch ([_centralManager state])
    {
        case CBManagerStateUnsupported:
            state = KKBLEStatus_Unsupported;
            break;
            //应用程序没有被授权使用蓝牙
        case CBManagerStateUnauthorized:
            state = KKBLEStatus_Unauthorized;
            break;
            //尚未打开蓝牙
        case CBManagerStatePoweredOff:
            
            state = KKBLEStatus_OFF;
            self.BLEConnectStatusResult(KKBLEConnectStatus_disconnect,YES, nil, nil);
            self.isConnect = NO;
            self.peripheral = nil;
            self.BLEPoweredOn = NO;
            
            break;
           
        case CBManagerStatePoweredOn:
            
            state = KKBLEStatus_ON;
            self.BLEPoweredOn = YES;
            
            break;
            
        case CBManagerStateUnknown:
            
        default:
            ;
    }
    
    self.BLEStatusResult(state, YES, nil, nil);
   
}

#pragma mark ============== 查找周围设备 ===============
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    
    NSLog(@"发现的设备:%@",peripheral.name);
    
    if (peripheral.name == nil) {
        return;
    }
    
    if ([peripheral.name hasPrefix:KDevice_Head_New] ||
        [peripheral.name hasPrefix:KDevice_Head_Old]) {
        self.deviceListResult(KKBLEActionStatus_list,YES, peripheral, nil);
    }
    
    
    
}
#pragma mark ============== 搜索设备列表 ===============
- (void)searchDeviceList:(HJBLEHandle)callback{
    
    self.deviceListResult = callback;
    
    [self.centralManager scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey:@(NO)}];
}
#pragma mark ============== 暂停搜索 ===============
- (void)cancelSeach{
    [self.centralManager stopScan];
    NSLog(@"暂停搜索");
}

#pragma mark ============== 连接设备 ===============
- (void)connectDevice:(CBPeripheral*)peripheral{
    
    if (peripheral) {
        NSLog(@"主动链接:%@",peripheral);
        
        [self.centralManager connectPeripheral:peripheral options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:CBConnectPeripheralOptionNotifyOnDisconnectionKey]];
    }

}

#pragma mark ============== 连接成功 ===============
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    
    NSLog(@"连接成功:%@",peripheral.name);

    self.peripheral = peripheral;
    [peripheral setDelegate:self];
    
    //查找服务
    [peripheral discoverServices:@[[CBUUID UUIDWithString:K_SERVER_UUID],
                                   [CBUUID UUIDWithString:BATTERY_SERVER_UUID],
                                   [CBUUID UUIDWithString:DEVICE_INFO_SERVER_UUID]]];
    
    [self cancelSeach];
    self.isConnect = YES;
   
}

#pragma mark ============== 断开设备 ===============
- (void)disconnectDevice:(CBPeripheral*_Nullable)peripheral{
    
    if (peripheral) {
        [self.centralManager cancelPeripheralConnection:peripheral];
    }
    
}
#pragma mark ============== 连接断开 ===============
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error{
    
    self.isConnect = NO;
    
    NSLog(@"连接断开");
    self.peripheral = nil;
    [peripheral setDelegate:nil]; //查找服务
    [peripheral discoverServices:nil];
    
    self.BLEConnectStatusResult(KKBLEConnectStatus_disconnect,YES, peripheral, nil);
}

#pragma mark ==============   蓝牙图像数据开始传输回调 ===============
- (void)BLEImageDataStartTransmission:(HJBLEHandle)callback{
    
    self.imageDataStartResult = callback;
}
#pragma mark ==============  蓝牙图像数据 ===============
- (void)BLEImageData:(HJBLEHandle)callback{
        
    self.imageDataResult = callback;
}
#pragma mark ============== 蓝牙中心管理者状态通知 ===============
- (void)BLEStatus:(HJBLEHandle)callback{
    
    self.BLEStatusResult = callback;
}

#pragma mark ============== 蓝牙连接状态通知 ===============

- (void)BLEConnectStatus:(HJBLEHandle)callback{
    
    self.BLEConnectStatusResult = callback;
}

#pragma mark ==============  蓝牙电量 / 固件版本 ===============
- (void)BLEInfoStatus:(HJBLEHandle)callback{
    self.BLEInfoStatuResult = callback;
}

#pragma mark:=========================外围设备的代理方法===============
#pragma mark:=========================外围设备的代理方法===============
#pragma mark:=========================外围设备的代理方法===============
//返回的蓝牙服务
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error  {
    
    if (error==nil){
        
       // NSLog(@"服务:%@",peripheral.services);
        
        for (CBService * service in peripheral.services)   {
            
            //发现特定服务
            if ([service.UUID isEqual:[CBUUID UUIDWithString:K_SERVER_UUID]]){
    
                //在一个服务中寻找特征值
                [peripheral discoverCharacteristics:nil forService:service];
                
                
            }else if([service.UUID isEqual:[CBUUID UUIDWithString:BATTERY_SERVER_UUID]]){
                
                //在一个服务中寻找特征值
                [peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:BATTERY_R_UUID]] forService:service];
                
                
            }else if([service.UUID isEqual:[CBUUID UUIDWithString:DEVICE_INFO_SERVER_UUID]]){
                
                //在一个服务中寻找特征值
                [peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:DEVICE_MODE_R_UUID],
                                                      [CBUUID UUIDWithString:DEVICE_VERSION_R_UUID]] forService:service];
            }
        }
        
    }
}

//返回的蓝牙特征值
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error  {
    
    if (error==nil)  {
        
       // NSLog(@"特征:%@",service.characteristics);
        
        for(CBCharacteristic * characteristic in service.characteristics){
            
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:K_READ_UUID]]) {
                
                [self.peripheral setNotifyValue:YES forCharacteristic:characteristic];
                
                self.BLEConnectStatusResult(KKBLEConnectStatus_connect,YES, peripheral, nil);
                
            }else if([characteristic.UUID isEqual:[CBUUID UUIDWithString:K_WRITE_UUID]]){
                
                self.characteristic = characteristic;
                
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:BATTERY_R_UUID]]) {
                
                /*
                 电量注册为通知模式,变化时直接通知
                 */
                [self.peripheral setNotifyValue:YES forCharacteristic:characteristic];
                /*
                 连接时 主动读取一次电量值
                 */
                [self.peripheral readValueForCharacteristic:characteristic];
                
            }else if([characteristic.UUID isEqual:[CBUUID UUIDWithString:DEVICE_MODE_R_UUID]]){
                
                [self.peripheral readValueForCharacteristic:characteristic];
            
            }else if([characteristic.UUID isEqual:[CBUUID UUIDWithString:DEVICE_VERSION_R_UUID]]){
                
                [self.peripheral readValueForCharacteristic:characteristic];
               
            }
        }
    }
}
- (void)peripheral:(CBPeripheral *)peripheral didOpenL2CAPChannel:(nullable CBL2CAPChannel *)channel error:(nullable NSError *)error API_AVAILABLE(ios(11.0)){
    
    if(error){
        NSLog(@"%@", error);
    }
    
    NSLog(@"channel:%hu",channel.PSM);
}


#pragma mark:======================处理蓝牙发过来的数据============

- (void)peripheral:(CBPeripheral*)peripheral didUpdateValueForCharacteristic:(CBCharacteristic*)characteristic
             error:(NSError *)error{
    
   //NSLog(@"处理蓝牙发过来的数据:%@",characteristic);

    if (error==nil){
        
        NSString * dataString = [HJBLETools convertDataToHexStr:characteristic.value];
        
        /*
         电量 版本 信息
         */
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:BATTERY_R_UUID]]) {
            
            Byte * vaildByte=(Byte*)[characteristic.value bytes];
            int batteryValue = vaildByte[0] & 0xff;
            
            self.BLEInfoStatuResult(KKBLEActionStatus_Battery_level, YES, [NSString stringWithFormat:@"%d",batteryValue], nil);
            
            return;
            
        }else if([characteristic.UUID isEqual:[CBUUID UUIDWithString:DEVICE_MODE_R_UUID]]){
            
            NSString * mode =   [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
            
            self.BLEInfoStatuResult(KKBLEActionStatus_Model_Number, YES, mode, nil);
            
            return;
            
        }else if([characteristic.UUID isEqual:[CBUUID UUIDWithString:DEVICE_VERSION_R_UUID]]){
            
            /*
             蓝牙版本号
             */
            
            NSString * mode =   [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
            
            self.BLEInfoStatuResult(KKBLEActionStatus_Software_Revision, YES, mode, nil);
            
            return;
        }
        
        
        if ([dataString hasPrefix:K_CMD_HEAD]) {
            
            
            NSString * CMDString = [dataString substringWithRange:NSMakeRange(4, 4)];
            
            if ([CMDString isEqualToString:K_CMD_GET_VERSION_CTRL]) {
            
                self.orderResult(KKBLEActionStatus_version_ctrl, YES, characteristic.value, nil);
                
            }else if([CMDString isEqualToString:K_CMD_SAMPLE_LEN]){
                
                self.orderResult(KKBLEActionStatus_Sample_len, YES, dataString, nil);
                
            }else if ([CMDString isEqualToString:K_CMD_RXATE_DELAY]){
                
                self.orderResult(KKBLEActionStatus_RXATE_DELAY, YES, dataString, nil);
                
            }else if ([CMDString isEqualToString:K_CMD_INIT_CTRL]){
                
                self.orderResult(KKBLEActionStatus_init_ctrl, YES, dataString, nil);
                
            }else if ([CMDString isEqualToString:K_CMD_M_VALUE]){
                
                self.orderResult(KKBLEActionStatus_m_value, YES, dataString, nil);
                
            }else if ([CMDString isEqualToString:k_CMD_DLPF_PARA]){
                
                self.orderResult(KKBLEActionStatus_dlpf_para, YES, dataString, nil);
                
            }else if ([CMDString isEqualToString:K_CMD_DR_PARA]){
                
                self.orderResult(KKBLEActionStatus_dr_para, YES, dataString, nil);
                
            }else if ([CMDString isEqualToString:K_CMD_LINE_CYCLE]){
                
                self.orderResult(KKBLEActionStatus_line_cycle, YES, dataString, nil);
                
            }else if ([CMDString isEqualToString:K_CMD_IMAGE_UPLOAD]){
                
                //如果是第一笔数据 需要去掉无用数据
                Byte * vaildByte=(Byte*)[characteristic.value bytes];
                NSInteger dataTag = [[NSString stringWithFormat:@"%hhu",vaildByte[10]] intValue];
                
                if (dataTag == 16) {

                    self.imageData = [NSMutableData data];
                    self.imageDataStartResult(KKBLEActionStatus_image_upload_start, YES, nil, nil);
                    
                    NSLog(@"每线数据高度%d",self.BLE_ImageData_Height);
                }
                
                [self BLEUploadImageData:characteristic];
                
            }else if([CMDString isEqualToString:K_CMD_UPG_CTRL]){
                
                self.orderResult(KKBLEActionStatus_UPG_CTRL, YES, dataString, nil);
                
            }else if([CMDString isEqualToString:K_CMD_UPG_CTRL_END]){
                
                self.orderResult(KKBLEActionStatus_UPG_CTRL_END, YES, dataString, nil);
                
            }else  if([CMDString isEqualToString:K_CMD_UPG_PAGE_RD]){
                
                self.orderResult(KKBLEActionStatus_UPG_PAGE_RD, YES, dataString, nil);
                
            }
            
        }else{
            
            [self BLEUploadImageData:characteristic];
        
        }
    }
}
#pragma mark ============== 上传图像数据 ===============
- (void)BLEUploadImageData:(CBCharacteristic*)characteristic{
    
    if (self.imageDataResult==nil) {
        return;
    }
    
    /*
     设置默认值,如果不存在的情况下
     */
    if (self.BLE_ImageData_Height==0) {
        self.BLE_ImageData_Height = 488;
    }
   
    
    [self.imageData appendBytes:[characteristic.value bytes] length:characteristic.value.length];

    //如果收到的数据 等于 一线数据长度,直接抛出
    
    if (self.imageData.length >= self.BLE_ImageData_Height) {
        
        NSData * uplaodData = [self.imageData subdataWithRange:NSMakeRange(0, self.BLE_ImageData_Height)];
        
        Byte * vaildByte=(Byte*)[uplaodData bytes];
        
        if (vaildByte == nil) {
            return;
        }
        
        NSInteger position = [[NSString stringWithFormat:@"%hhu",vaildByte[9]] intValue];
        NSInteger dataTag = [[NSString stringWithFormat:@"%hhu",vaildByte[10]] intValue];
        
        self.imageDataResult(KKBLEActionStatus_image_upload, YES, @[@(position),@(dataTag),uplaodData], nil);
        
        [self.imageData replaceBytesInRange:NSMakeRange(0, self.BLE_ImageData_Height) withBytes:NULL length:0];
        

    }
}

- (void)peripheralManagerDidUpdateState:(nonnull CBPeripheralManager *)peripheral {
    NSLog(@"peripheralManagerDidUpdateState:%@",peripheral);
}

#pragma mark ============== 数据写入回调 ===============
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    
   // NSLog(@"didWriteValueForCharacteristic:error:%@",error);
}


@end
