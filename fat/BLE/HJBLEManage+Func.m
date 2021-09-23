//
//  HJBLEManage+Func.m
//  fat_BLE_SDK
//
//  Created by 何军 on 2021/4/7.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import "HJBLEManage+Func.h"

@implementation HJBLEManage (Func)

#pragma mark ============== 蓝牙命令操作结合 ===============

- (void)getDevice_VERSION_CTRL:(HJBLEHandle)callback{
    
    NSString * length = @"0000";
    
    NSString * lengthData = @"";

    NSString * cmdString = [NSString stringWithFormat:@"%@%@%@%@%@",K_CMD_HEAD,K_CMD_GET_VERSION_CTRL,length,lengthData,K_CMD_END];    
    NSData * data= [HJBLETools convertHexStrToData:cmdString];
    
    [self writeValue:data];
    
    self.orderResult=callback;
}


- (void)setDevice_INIT_CTRL:(NSInteger)level withCallback:(HJBLEHandle)callback{
    
    NSString * length = @"0004";
    
    NSString * lengthData = [HJBLETools convertToHexStr:level];

    NSString * cmdString = [NSString stringWithFormat:@"%@%@%@%@%@",K_CMD_HEAD,K_CMD_INIT_CTRL,length,lengthData,K_CMD_END];    

    NSData * data= [HJBLETools convertHexStrToData:cmdString];
    
    [self writeValue:data];
    
    self.orderResult=callback;
    
}


- (void)setDevice_M_VALUE:(NSInteger)level withCallback:(HJBLEHandle)callback{
    
    NSString * length = @"0004";
    
    NSString * lengthData = [HJBLETools convertToHexStr:level];

    NSString * cmdString = [NSString stringWithFormat:@"%@%@%@%@%@",K_CMD_HEAD,K_CMD_M_VALUE,length,lengthData,K_CMD_END];    

    NSData * data= [HJBLETools convertHexStrToData:cmdString];
    
    [self writeValue:data];
    
    self.orderResult=callback;
}

- (void)setDevice_DLPF_PARA:(NSInteger)level withCallback:(HJBLEHandle)callback{
    
    
    NSString * length = @"0004";
    
    NSString * lengthData = [HJBLETools convertToHexStr:level];

    NSString * cmdString = [NSString stringWithFormat:@"%@%@%@%@%@",K_CMD_HEAD,k_CMD_DLPF_PARA,length,lengthData,K_CMD_END];    

    NSData * data= [HJBLETools convertHexStrToData:cmdString];
    
    [self writeValue:data];
    
    self.orderResult=callback;
    
}


- (void)setDevice_DR_PARA:(NSInteger)level withCallback:(HJBLEHandle)callback{
    
    NSString * length = @"0004";
    
    NSInteger value = [HJBLETools convert_DR_PARA:level];
    
    NSString * lengthData = [HJBLETools convertToHexStr:value];

    NSString * cmdString = [NSString stringWithFormat:@"%@%@%@%@%@",K_CMD_HEAD,K_CMD_DR_PARA,length,lengthData,K_CMD_END];    

    NSData * data= [HJBLETools convertHexStrToData:cmdString];
    
    [self writeValue:data];
    
    self.orderResult=callback;
    
}


- (void)setDevice_LINE_CYCLE:(NSInteger)level withCallback:(HJBLEHandle)callback{
    
    NSString * length = @"0004";
    
    NSInteger value = [HJBLETools convert_LINE_CYCLE:level];
    
    NSString * lengthData = [HJBLETools convertToHexStr:value];

    NSString * cmdString = [NSString stringWithFormat:@"%@%@%@%@%@",K_CMD_HEAD,K_CMD_LINE_CYCLE,length,lengthData,K_CMD_END];    

    NSData * data= [HJBLETools convertHexStrToData:cmdString];
    
    [self writeValue:data];
    
    self.orderResult=callback;
}

/*
 动态设置每线数据高度
 */
- (void)setSAMPLE_LEN:(NSInteger)level head:(NSInteger)head withCallback:(HJBLEHandle)callback{
    
    self.BLE_ImageData_Height = level+head;
    
    NSString * length = @"0004";
    
    NSString * lengthData = [HJBLETools convertToHexStr:level];

    NSString * cmdString = [NSString stringWithFormat:@"%@%@%@%@%@",K_CMD_HEAD,K_CMD_SAMPLE_LEN,length,lengthData,K_CMD_END];    

    NSData * data= [HJBLETools convertHexStrToData:cmdString];
    
    [self writeValue:data];
    
    self.orderResult=callback;
    
}

/*
 设置延时参数
 */
- (void)setRXATE_DELAY:(NSInteger)depth length:(NSInteger)length withCallback:(HJBLEHandle)callback{
    
    NSString * len = @"0004";
    
    NSInteger delayValue = 0xa5 + depth*length*2 + 24;
    
    
    NSString * cmd =   [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%02lx",(long)delayValue>>8&0xff]];
    
    NSString * cmd1 = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%02lx",(long)delayValue&0xff]];
   
    
    NSString * lengthData = [NSString stringWithFormat:@"00a5%@%@",cmd,cmd1];

    NSString * cmdString = [NSString stringWithFormat:@"%@%@%@%@%@",K_CMD_HEAD,K_CMD_RXATE_DELAY,len,lengthData,K_CMD_END];
    
//    Byte delayByte[4] ={0x00,0xa5,delayValue>>8&0xff,delayValue&0xff};
//
//    NSData *temphead = [[NSData alloc]initWithBytes:delayByte length:4];
  
    NSData * data= [HJBLETools convertHexStrToData:cmdString];
    
    NSLog(@"设置延时参数:%ld %@ %@",(long)delayValue,lengthData,data);
    
    [self writeValue:data];
    
    self.orderResult=callback;
}


/*
 获取每线数据高度
 */
- (void)getSAMPLE_LEN:(HJBLEHandle)callback{
    

    NSString * length = @"0004";
    
    NSString * lengthData = @"";

    NSString * cmdString = [NSString stringWithFormat:@"%@%@%@%@%@",K_CMD_HEAD,K_CMD_GET_SAMPLE_LEN,length,lengthData,K_CMD_END];    

    NSData * data= [HJBLETools convertHexStrToData:cmdString];
    
    [self writeValue:data];
    
    self.orderResult=callback;
    
}

/*
 超声开始升级指令
 */
- (void)setDevice_UPG_CTRL:(HJBLEHandle)callback{
    
    NSString * length = @"0004";
    
    NSString * lengthData = [HJBLETools convertToHexStr:1];
    
    NSString * cmdString = [NSString stringWithFormat:@"%@%@%@%@%@",K_CMD_HEAD,K_CMD_UPG_CTRL,length,lengthData,K_CMD_END];

    NSData * data= [HJBLETools convertHexStrToData:cmdString];
    
    [self writeValue:data];
    
    self.orderResult=callback;
}
/*
 超声开始升级完成
 */
- (void)setDevice_UPG_CTRL_End:(HJBLEHandle)callback{
    
    NSString * length = @"0004";
    
    NSString * lengthData = [HJBLETools convertToHexStr:1];
    
    NSString * cmdString = [NSString stringWithFormat:@"%@%@%@%@%@",K_CMD_HEAD,K_CMD_UPG_CTRL_END,length,lengthData,K_CMD_END];

    NSData * data= [HJBLETools convertHexStrToData:cmdString];
    
    [self writeValue:data];
    
    self.orderResult=callback;
    
    NSLog(@"超声开始升级完成:%@",data);
    
}
/*
 超声升级数据包
 */
- (void)setDevice_UPG_PAGE_RD:(NSData*)data withCallback:(HJBLEHandle)callback{

    
    [self writeValue:data];
    
    self.orderResult=callback;
}

- (void)flashDataJoint:(NSData*)data flag:(int)flag address:(int)address withCallback:(HJBLEHandle)callback{
    
    __weak __typeof(&*self)weakSelf = self;
    /*
     数据拼接
     */
    
    /*
     flashFlag  1字节 表示数据 开始 中间 结束
     flashAdr   3字节 表示数据 flash 的地址 ,每多 K_UPG_LENGTH 字节, 增加 0x100
     */
    NSString * flashFlag =  [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%02lx",(long)flag]];
    NSString * flashAdr = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%06lx",(long)address]];
    
    
    NSData * firstData;
    NSData * lastData;
    
    int dataLength = K_MTU - 13 ; // 有效数据长度
    
   
    /*
     分两次发送
     */
    
    firstData  = [data subdataWithRange:NSMakeRange(0, dataLength)];
    lastData = [data subdataWithRange:NSMakeRange(dataLength,data.length-dataLength)];
    
    /*
     length 4字节 表示有效数据 长度
     */
    NSString * firstlength = [NSString stringWithFormat:@"%04lx",(long)firstData.length+4];
    NSString * lastlength = [NSString stringWithFormat:@"%04lx",(long)lastData.length+4];
    
    
    NSData * resultData= [HJBLETools convertHexStrToData:[NSString stringWithFormat:@"%@%@%@%@%@",K_CMD_HEAD,K_CMD_UPG_PAGE_RD,firstlength,flashFlag,flashAdr]];
    
    NSMutableData * firstJointData = [NSMutableData dataWithData:resultData];
    [firstJointData appendData:firstData];
    resultData =  [HJBLETools convertHexStrToData:K_CMD_END_upgrade];
    [firstJointData appendData:resultData];
    
    
    NSData * lastresultData= [HJBLETools convertHexStrToData:[NSString stringWithFormat:@"%@%@%@%@%@",K_CMD_HEAD,K_CMD_UPG_PAGE_RD,lastlength,flashFlag,flashAdr]];
    
    NSMutableData * lastJointData = [NSMutableData dataWithData:lastresultData];
    [lastJointData appendData:lastData];
    lastresultData =  [HJBLETools convertHexStrToData:K_CMD_END_upgrade];
    [lastJointData appendData:resultData];
    
    [self setDevice_UPG_PAGE_RD:firstJointData withCallback:^(NSInteger KKBLEActionStatus, BOOL isSucceeded, id  _Nullable response, NSError * _Nullable error) {
        
        if (isSucceeded) {
            
            [weakSelf setDevice_UPG_PAGE_RD:lastJointData withCallback:^(NSInteger KKBLEActionStatus, BOOL isSucceeded, id  _Nullable response, NSError * _Nullable error) {
                
                callback(KKBLEActionStatus,isSucceeded,response,error);
                
            }];
            
        }
        
    }];
    
}




/*
 超声固件升级
 */
- (void)BLEUltrasoundUpdgrade:(NSString*_Nullable)path
                     progress:(HJBLEUpgradeProgress)progress
                     callback:(HJBLEHandle)callback{
    
    __weak __typeof(&*self)weakSelf = self;
    
    [self setDevice_UPG_CTRL:^(NSInteger KKBLEActionStatus, BOOL isSucceeded, id  _Nullable response, NSError * _Nullable error) {
        
        if (isSucceeded == NO) {
            callback(KKBLEActionStatus_UPG_CTRL,NO,nil,nil);
            return;
        }
       
        /*
         获取bin文件地址
         */
        NSData * resourcedata=[NSData dataWithContentsOfURL:[NSURL URLWithString:path]];
        
        /*
         向上取整j
         */
        NSInteger sendCount = ceilf(1.0*resourcedata.length/K_UPG_LENGTH);
        
        __block int  flag = 0;
        __block int  address = 0;
        __block  NSData * smallData;
        
        /*
         app数据上传 分线程执行
         */
        
        dispatch_queue_t queue =  dispatch_get_global_queue(0, 0);
        dispatch_async(queue, ^{
            
            dispatch_semaphore_t sema = dispatch_semaphore_create(0);
            
            for (int i = 0; i<sendCount; i++) {
                
                address = i*K_UPG_LENGTH;
                
                if (i == 0) {
                    flag = 16;
                }else if(sendCount-1 == i){
                    flag = 1;
                }else{
                    flag = 0;
                }
                
                if (i == sendCount - 1) {
                    
                    smallData = [resourcedata subdataWithRange:NSMakeRange(i*K_UPG_LENGTH, resourcedata.length - i*K_UPG_LENGTH)];
                    
                    Byte value[K_UPG_LENGTH]= {};
                    
                    Byte * vaildByte=(Byte*)[smallData bytes];
                    
                    for (int i = 0; i<K_UPG_LENGTH; i++) {
                        
                        if (i<smallData.length) {
                            
                            value[i] = vaildByte[i];
                            
                        }else{
                            
                            value[i] = 0xff;
                            
                        }
                    }
                    
                    smallData = [[NSData alloc] initWithBytes:value length:sizeof(value)];
                    
                }else{
                    
                    smallData = [resourcedata subdataWithRange:NSMakeRange(i*K_UPG_LENGTH, K_UPG_LENGTH)];
                    
                }
            
                
                [weakSelf flashDataJoint:smallData flag:flag address:address withCallback:^(NSInteger KKBLEActionStatus, BOOL isSucceeded, id  _Nullable response, NSError * _Nullable error) {
                    
                    /*
                     回调进度
                     */
                    
                    if (i == sendCount - 1) {
                        
                        /*
                         发送结束指令
                         */
                        [weakSelf setDevice_UPG_CTRL_End:^(NSInteger KKBLEActionStatus, BOOL isSucceeded, id  _Nullable response, NSError * _Nullable error) {
                            
                            if (isSucceeded) {
                                callback(KKBLEActionStatus_UPG_CTRL_END,YES,nil,nil);
                            }
                            
                        }];
                        
                    }else{
                        
                        progress(1.0*i/sendCount,YES,nil,nil);
                    }
                    
                    dispatch_semaphore_signal(sema);
                }];
                
                dispatch_semaphore_wait(sema,DISPATCH_TIME_FOREVER);
                
            }
        });
    }];
}

#pragma mark ============== 写数据 ===============
- (void)writeValue:(NSData *)value{
    
    //NSLog(@"蓝牙指令:%@",value);
    
    [self.peripheral writeValue:value forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
    
}


@end
