//
//  HJButtonView.h
//  fat
//
//  Created by ydd on 2021/4/21.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import "HJBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJButtonView : HJBaseView

@property (strong,nonatomic)UILabel * titleLab;
@property (strong,nonatomic)UIButton * testButton;
@property (strong,nonatomic)UIImageView * topImageView;
@property (strong,nonatomic)UILabel * textLab;
@property (strong,nonatomic)UIImageView * rightImageView;

- (instancetype)initWithFrame:(CGRect)frame withButtonType:(KKButtonType)buttonType;

@end

NS_ASSUME_NONNULL_END
