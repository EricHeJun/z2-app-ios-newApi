//
//  HJUserInfoView.h
//  fat
//
//  Created by ydd on 2021/4/26.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import "HJBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJUserInfoView : HJBaseView

/*
 头部
 */
@property (strong,nonatomic)UIButton * cancelBtn;
@property (strong,nonatomic)UIButton * confirmBtn;
@property (strong,nonatomic)UILabel * titleLab;

@property (strong,nonatomic)UIPickerView * pickerView;

@property (strong,nonatomic)UIDatePicker * datePicker;


@property (nonatomic,strong) void (^ selectBlock)(UIButton * sender);

- (instancetype)initWithFrame:(CGRect)frame withType:(KKViewType)type;

@end

NS_ASSUME_NONNULL_END
