//
//  HJDeviceInfoVC.h
//  fat
//
//  Created by 何军 on 2021/4/14.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import "HJBaseViewController.h"
#import "HJMaskView.h"
#import "HJUserInfoView.h"
#import "HJBLEUpgradeVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJDeviceInfoVC : HJBaseViewController

@property (strong,nonatomic)HJMaskView * maskView;
@property (strong,nonatomic)HJUserInfoView * depthView;

@end

NS_ASSUME_NONNULL_END
