//
//  HJAESUtil.h
//  fat
//
//  Created by ydd on 2021/4/23.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>


NS_ASSUME_NONNULL_BEGIN

@interface HJAESUtil : NSObject


/**
 * AES加密
 */
+ (NSString *)aesEncrypt:(NSString *)sourceStr;
 
/**
 * AES解密
 */
+ (NSString *)aesDecrypt:(NSString *)secretStr;


@end

NS_ASSUME_NONNULL_END
