//
//  HJSettingVC.h
//  fat
//
//  Created by 何军 on 2021/4/23.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import "HJBaseViewController.h"
#import "HJUserInfoVC.h"
#import "HJAccountManageVC.h"
#import "HJMaskView.h"
#import "HJUserInfoView.h"
#import "HJAboutVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJSettingVC : HJBaseViewController

@property (strong,nonatomic)HJMaskView * maskView;
@property (strong,nonatomic)HJUserInfoView * depthView;

@end

NS_ASSUME_NONNULL_END
