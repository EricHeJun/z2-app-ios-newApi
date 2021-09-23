//
//  HJShareUtil.h
//  fat
//
//  Created by ydd on 2021/5/18.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import "HJBaseObject.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDKUI.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareSheetConfiguration.h>

NS_ASSUME_NONNULL_BEGIN

@interface HJShareUtil : HJBaseObject

+ (void)shareInit;

+ (void)shareImage:(UIImage*)image;


+ (void)shareUI;

@end

NS_ASSUME_NONNULL_END
