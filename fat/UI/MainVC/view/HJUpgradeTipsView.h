//
//  HJUpgradeTipsView.h
//  fat
//
//  Created by ydd on 2021/5/25.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import "HJBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJUpgradeTipsView : HJBaseView

@property (strong,nonatomic)UIImageView * imageView;
@property (strong,nonatomic)UILabel * resultLab;
@property (strong,nonatomic)UILabel * detailLab;
@property (strong,nonatomic)UIButton * cancelBtn;

- (instancetype)initWithFrame:(CGRect)frame;
@end

NS_ASSUME_NONNULL_END
