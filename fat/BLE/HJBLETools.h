//
//  HJBLETools.h
//  fat_BLE_SDK
//
//  Created by 何军 on 2021/4/7.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import <Foundation/Foundation.h>


#define BLEocxo   40

@interface HJBLETools : NSObject

//16进制转NSData
+ (NSData *)convertHexStrToData:(NSString *)str;

// NSData转16进制
+ (NSString *)convertDataToHexStr:(NSData *)data;

// 10进制转换为16进制
+ (NSString *)convertToHexStr:(NSInteger)level;

// 动态参数范围 公式
+ (NSInteger)convert_DR_PARA:(NSInteger)level;

// 每线扫描周期
+ (NSInteger)convert_LINE_CYCLE:(NSInteger)level;

//字符串补零操作
+ (NSString *)addZero:(NSString *)str withLength:(int)length;

@end


