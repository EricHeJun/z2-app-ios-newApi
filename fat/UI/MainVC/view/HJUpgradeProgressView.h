//
//  HJUpgradeProgressView.h
//  fat
//
//  Created by ydd on 2021/6/9.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import "HJBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJUpgradeProgressView : HJBaseView

@property (strong,nonatomic)UISlider * slider;
@property (strong,nonatomic)UILabel * titleLab;
@property (strong,nonatomic)UILabel * bottomLab;

- (instancetype)initWithFrame:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END
