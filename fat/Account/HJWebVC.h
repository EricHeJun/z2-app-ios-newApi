//
//  HJWebVC.h
//  fat
//
//  Created by ydd on 2021/4/29.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import "HJBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJWebVC : HJBaseViewController

@property (assign,nonatomic)KKWebType webType;
@property (copy,nonatomic)NSString * urlString;

@end

NS_ASSUME_NONNULL_END
