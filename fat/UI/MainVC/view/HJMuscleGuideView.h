//
//  HJMuscleGuideView.h
//  fat
//
//  Created by ydd on 2021/8/7.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import "HJBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJMuscleGuideView : HJBaseView

@property (strong,nonatomic)UILabel * titleLab;
@property (strong,nonatomic)UILabel * firstLab;
@property (strong,nonatomic)UIImageView * imageView;
@property (strong,nonatomic)UILabel * twoLab;

@property (strong,nonatomic)UIButton * cancelBtn;
@property (strong,nonatomic)UIButton * backBtn;
@property (strong,nonatomic)UIButton * lastBtn;

@property (assign,nonatomic)NSInteger indexTag;

- (instancetype)initWithFrame:(CGRect)frame;

- (void)remove;

@end

NS_ASSUME_NONNULL_END
