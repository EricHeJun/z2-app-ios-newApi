//
//  HJUserInfoView.m
//  fat
//
//  Created by ydd on 2021/4/26.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import "HJUserInfoView.h"

@implementation HJUserInfoView
- (instancetype)initWithFrame:(CGRect)frame withType:(KKViewType)type{
    
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        if (type == KKViewType_Userinfo_sex_height_weight) {
            
            [self sexView:frame];
            
        }else if(type == KKViewType_Userinfo_birthday){
            
            [self birthdayView:frame];
        }
    }
    
    return self;
}
- (void)sexView:(CGRect)frame{
    
    self.backgroundColor = kkBgGrayColor;
    
    UIView * view = [[UIView alloc]init];
    view.frame = CGRectMake(0, 0, self.frame.size.width, KKButtonHeight);
    view.backgroundColor = kkBgLightGrayColor;
    [self addSubview:view];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, kk_x(150), KKButtonHeight);
    [btn setTitle:KKLanguage(@"lab_common_cancel") forState:UIControlStateNormal];
    [btn setTitleColor:KKBgBlueColor forState:UIControlStateNormal];
    btn.titleLabel.font = kk_sizefont(KKFont_Normal);
    btn.tag = KKButton_Cancel;
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    _cancelBtn = btn;
    
    
    UILabel * titleLab = [[UILabel alloc] init];
    titleLab.frame = CGRectMake(frame.size.width/4, 0, frame.size.width/2, btn.frame.size.height);
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = kk_sizefont(KKFont_Normal);
    titleLab.textColor = kkTextBlackColor;
    [view addSubview:titleLab];
    _titleLab = titleLab;
    
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(frame.size.width - kk_x(150), 0, kk_x(150), KKButtonHeight);
    [btn setTitle:KKLanguage(@"lab_common_confirm") forState:UIControlStateNormal];
    [btn setTitleColor:KKBgBlueColor forState:UIControlStateNormal];
    btn.titleLabel.font = kk_sizefont(KKFont_Normal);
    btn.tag = KKButton_Confirm;
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    _confirmBtn = btn;
    
    
    UIPickerView * pickerView = [[UIPickerView alloc] init];
    pickerView.frame = CGRectMake(0, view.frame.size.height, frame.size.width, frame.size.height - view.frame.size.height);
    pickerView.backgroundColor = [UIColor clearColor];
    [self addSubview:pickerView];
    _pickerView = pickerView;
    
    
}

- (void)birthdayView:(CGRect)frame{
    
    self.backgroundColor = kkBgGrayColor;
    
    UIView * view = [[UIView alloc]init];
    view.frame = CGRectMake(0, 0, self.frame.size.width, KKButtonHeight);
    view.backgroundColor = kkBgLightGrayColor;
    [self addSubview:view];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, kk_x(150), KKButtonHeight);
    [btn setTitle:KKLanguage(@"lab_common_cancel") forState:UIControlStateNormal];
    [btn setTitleColor:KKBgBlueColor forState:UIControlStateNormal];
    btn.titleLabel.font = kk_sizefont(KKFont_Normal);
    btn.tag = KKButton_Cancel;
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    _cancelBtn = btn;
    
    
    UILabel * titleLab = [[UILabel alloc] init];
    titleLab.frame = CGRectMake(frame.size.width/4, 0, frame.size.width/2, btn.frame.size.height);
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = kk_sizefont(KKFont_Normal);
    titleLab.textColor = kkTextBlackColor;
    [view addSubview:titleLab];
    _titleLab = titleLab;
    
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(frame.size.width - kk_x(150), 0, kk_x(150), KKButtonHeight);
    [btn setTitle:KKLanguage(@"lab_common_confirm") forState:UIControlStateNormal];
    [btn setTitleColor:KKBgBlueColor forState:UIControlStateNormal];
    btn.titleLabel.font = kk_sizefont(KKFont_Normal);
    btn.tag = KKButton_Confirm;
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    _confirmBtn = btn;
    
    
    UIDatePicker * datePicker = [[UIDatePicker alloc] init];
    
    datePicker.backgroundColor = [UIColor clearColor];
    //设置地区: zh-中国
    datePicker.locale = [NSLocale currentLocale];

    datePicker.datePickerMode = UIDatePickerModeDate;
    if (@available(iOS 13.4, *)) {
        datePicker.preferredDatePickerStyle = UIDatePickerStyleWheels;
    }
    /*
     UIDatePicker 位置 需要在 设置完其他参数后 再进行设置
     */
    datePicker.frame = CGRectMake(0, view.frame.size.height, frame.size.width, frame.size.height - view.frame.size.height);

    datePicker.date = [NSDate date];
    datePicker.maximumDate = [NSDate date];
    
    _datePicker = datePicker;
    [self addSubview:datePicker];
    
}

- (void)btnClick:(UIButton*)sender{
    
    if (self.selectBlock) {
        self.selectBlock(sender);
    }
}

@end
