//
//  HJBLEStatusView.h
//  fat
//
//  Created by ydd on 2021/5/21.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import "HJBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJBLEStatusView : HJBaseView

@property (strong,nonatomic)UIImageView * connectImageView;
@property (strong,nonatomic)UIImageView * BLEImageView;
@property (strong,nonatomic)UIImageView * battertImageView;
@property (strong,nonatomic)UILabel * connectLab;

- (instancetype)initWithFrame:(CGRect)frame;

- (void)BLErefresh:(NSInteger)battery isConnect:(BOOL)isConnect BLEStatus:(BOOL)BLEStatus searching:(BOOL)searching;


@end

NS_ASSUME_NONNULL_END
