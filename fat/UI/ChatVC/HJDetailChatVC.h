//
//  HJDetailChatVC.h
//  fat
//
//  Created by ydd on 2021/5/13.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import "HJBaseViewController.h"
#import "HJShareUtil.h"
#import "HJChartAnalysisModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HJDetailChatVC : HJBaseViewController
@property (strong,nonatomic)HJChatInfoModel * chatInfoModel;
@property (assign,nonatomic)NSInteger selIndex;                  //记录选择的index

@end

NS_ASSUME_NONNULL_END
