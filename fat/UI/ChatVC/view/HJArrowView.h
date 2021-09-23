//
//  HJArrowView.h
//  fat
//
//  Created by ydd on 2021/7/8.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import "HJBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJArrowView : HJBaseView

@property (strong,nonatomic)UIColor * bgColor;

- (instancetype)initWithFrame:(CGRect)frame bgColor:(UIColor*)color;

@end

NS_ASSUME_NONNULL_END
