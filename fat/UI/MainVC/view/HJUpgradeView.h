//
//  HJUpgradeView.h
//  fat
//
//  Created by ydd on 2021/5/24.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import "HJBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJUpgradeView : HJBaseView


@property (strong,nonatomic)UILabel * titleLab;
@property (strong,nonatomic)UILabel * currectLab;
@property (strong,nonatomic)UILabel * freshLab;
@property (strong,nonatomic)UILabel * logLab;

- (instancetype)initWithFrame:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END
