//
//  HJForgotVC.h
//  fat
//
//  Created by ydd on 2021/4/25.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import "HJBaseViewController.h"
#import "HJLoginView.h"
#import "FCCountryAraeViewController.h"
#import "HJTipsUtil.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJForgotVC : HJBaseViewController

@property (strong,nonatomic)HJLoginView * forgotPhoneView;
@property (strong,nonatomic)HJLoginView * forgotEmailView;

@end

NS_ASSUME_NONNULL_END
