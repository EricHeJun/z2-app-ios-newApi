//
//  HJHistoryChatVC.h
//  fat
//
//  Created by ydd on 2021/5/7.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import "HJBaseViewController.h"
#import "HJFMDBModel.h"
#import <SDWebImage/SDWebImage.h>
#import "MJRefresh.h"
#import "HJDetailChatVC.h"
#import "HJOSSUpload.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJHistoryChatVC : HJBaseViewController
@property (assign,nonatomic)KKTest_Function_Position position;
/*
 具体时间
 */
@property (copy,nonatomic)NSString * recordDate;

@end

NS_ASSUME_NONNULL_END
