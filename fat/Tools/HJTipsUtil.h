//
//  HJTipsUtil.h
//  fat
//
//  Created by ydd on 2021/6/17.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import "HJBaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJTipsUtil : HJBaseObject

/*
 网络请求结果提示
 */
+ (NSString*)resultTips:(HJHTTPModel*)model type:(NSInteger)type;

@end

NS_ASSUME_NONNULL_END
