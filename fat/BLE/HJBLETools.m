//
//  HJBLETools.m
//  fat_BLE_SDK
//
//  Created by 何军 on 2021/4/7.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import "HJBLETools.h"

@implementation HJBLETools


// 16进制转NSData
+ (NSData *)convertHexStrToData:(NSString *)str{
    if (!str || [str length] == 0) {
        return nil;
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:20];
    NSRange range;
    if ([str length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    return hexData;
}

// NSData转16进制
+ (NSString *)convertDataToHexStr:(NSData *)data{
   if (!data || [data length] == 0) {
       return @"";
   }
   NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
   
   [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
       unsigned char *dataBytes = (unsigned char*)bytes;
       for (NSInteger i = 0; i < byteRange.length; i++) {
           NSString *hexStr = [NSString stringWithFormat:@"%X", (dataBytes[i]) & 0xFF];
           if ([hexStr length] == 2) {
               [string appendString:hexStr];
           } else {
               [string appendFormat:@"0%@", hexStr];
           }
       }
   }];
   return string;
}

// 10进制转换为16进制
+ (NSString *)convertToHexStr:(NSInteger)level{
    
    NSString * cmd =  [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%02lx",(long)level]];
    
    return [self addZero:cmd withLength:8];
}

//字符串补零操作
+ (NSString *)addZero:(NSString *)str withLength:(int)length{
    NSString *string = nil;
    if (str.length==length) {
        return str;
    }
    if (str.length<length) {
        NSUInteger inter = length-str.length;
        for (int i=0;i< inter; i++) {
            string = [NSString stringWithFormat:@"0%@",str];
            str = string;
        }
    }
    return string;
}


+ (NSInteger)convert_DR_PARA:(NSInteger)level{
    return [[self convertToHexStr:(23029/level)|((64-7650/level)<<16)] intValue];
}

+ (NSInteger)convert_LINE_CYCLE:(NSInteger)level{
    
    NSInteger value  = BLEocxo * level * 1000;
    
    return value;
}



@end
