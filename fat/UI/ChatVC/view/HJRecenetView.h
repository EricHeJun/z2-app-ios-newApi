//
//  HJRecenetView.h
//  fat
//
//  Created by ydd on 2021/5/17.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import "HJBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJRecenetView : HJBaseView

@property (strong,nonatomic)UILabel * titleLab;
@property (strong,nonatomic)UIView * bgview;


@property (strong,nonatomic)UILabel * timeLab;
@property (strong,nonatomic)UILabel * positionLab;
@property (strong,nonatomic)UILabel * functionLab;
@property (strong,nonatomic)UILabel * recordValueLab;

@property (strong,nonatomic)UIImageView * imageView;
@property (strong,nonatomic)UIImageView * nextImageView;

- (instancetype)initWithFrame:(CGRect)frame;
@end

NS_ASSUME_NONNULL_END
