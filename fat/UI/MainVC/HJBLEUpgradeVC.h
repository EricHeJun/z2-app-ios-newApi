//
//  HJBLEUpgradeVC.h
//  fat
//
//  Created by ydd on 2021/5/21.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import "HJBaseViewController.h"
#import "fat-Bridging-Header.h"

NS_ASSUME_NONNULL_BEGIN


@interface HJBLEUpgradeVC : HJBaseViewController<LoggerDelegate,DFUServiceDelegate,DFUProgressDelegate>

@property (assign,nonatomic)BOOL isBLEUpdate;     //是否是BLE升级 还是 超声升级
@property (strong,nonatomic)HJFirmwareInfoModel * firmwareInfoModel;


@property (strong,nonatomic)DFUServiceController * dfuController;
@property (strong,nonatomic)DFUFirmware * selectedFirmware;

/*
 升级完成
 */
@property (nonatomic,copy) void (^updateResult) (BOOL isSucceeded);


@end

NS_ASSUME_NONNULL_END
