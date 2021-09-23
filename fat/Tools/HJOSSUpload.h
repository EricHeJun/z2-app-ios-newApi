//
//  HJOSSUpload.h
//  fat
//
//  Created by ydd on 2021/5/6.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AliyunOSSiOS/OSSService.h>

NS_ASSUME_NONNULL_BEGIN

/// 上传到阿里云的 EndPoint
static NSString * _Nonnull const OSS_ENDPOINT = @"http://oss-cn-hongkong.aliyuncs.com";
/// 上传到阿里云的 BucketName
static NSString * _Nonnull const BucketName = @"marvoto-hk";

@interface HJOSSUpload : NSObject

typedef void (^ImageCallback)(BOOL result,NSArray <NSString *> * nameArray);

+(HJOSSUpload *)aliyunInit;

/// 上传图片
/// @param imgArray 放入需要上传的图片
/// @param success 上传成功,返回自己拼接的图片名字
- (void)uploadImage:(NSArray <UIImage *>*)imgArray success:(ImageCallback)success;

@end



NS_ASSUME_NONNULL_END
