//
//  HJNickNameVC.h
//  fat
//
//  Created by ydd on 2021/4/26.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import "HJBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJNickNameVC : HJBaseViewController

@property (copy,nonatomic)NSString * nickName;
@property (strong,nonatomic)UITextField * nickTf;


@property (nonatomic,strong) void (^ selectBlock)(NSString * nickName);

@end

NS_ASSUME_NONNULL_END
