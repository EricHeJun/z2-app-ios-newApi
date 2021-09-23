//
//  HJDeviceBgView.h
//  fat
//
//  Created by ydd on 2021/4/23.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import "HJBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJDeviceBgView : HJBaseView

@property (strong,nonatomic)UIImageView * deviceImageView;
@property (strong,nonatomic)UILabel * deviceDetailLab;

@property (strong,nonatomic)UILabel * deviceConnectLab;
@property (strong,nonatomic)UIButton * deviceFaqBtn;


- (instancetype)initWithFrame:(CGRect)frame;


@end

NS_ASSUME_NONNULL_END
