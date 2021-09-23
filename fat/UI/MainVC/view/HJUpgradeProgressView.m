//
//  HJUpgradeProgressView.m
//  fat
//
//  Created by ydd on 2021/6/9.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import "HJUpgradeProgressView.h"

@implementation HJUpgradeProgressView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        UILabel * titleLab = [[UILabel alloc] init];
        titleLab.frame = CGRectMake(0, KKButtonHeight, frame.size.width, KKButtonHeight);
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.font = kk_sizefont(KKFont_Normal);
        titleLab.textColor = kkTextBlackColor;
        [self addSubview:titleLab];
        _titleLab = titleLab;
        
        
        UISlider * slider = [[UISlider alloc]initWithFrame:CGRectMake(kk_x(40), titleLab.frame.size.height+titleLab.frame.origin.y+KKButtonHeight, frame.size.width - 2*kk_x(40), 20)];
        //01.minimumValue  : 当值可以改变时，滑块可以滑动到最小位置的值，默认为0.0
        slider.minimumValue = 0;
        //02.maximumValue : 当值可以改变时，滑块可以滑动到最大位置的值，默认为1.0
        slider.maximumValue = 100;
        
        //07.minimumTrackTintColor : 小于滑块当前值滑块条的颜色，默认为蓝色
        slider.minimumTrackTintColor = KKBgYellowColor;
        
        //08.maximumTrackTintColor: 大于滑块当前值滑块条的颜色，默认为白色
        slider.maximumTrackTintColor = kkBgGrayColor;
        
        //09.thumbTintColor : 当前滑块的颜色，默认为白色
        slider.thumbTintColor = KKBgYellowColor;
        
        slider.enabled = NO;
        slider.continuous = YES;   //值联系变化
        
        [self addSubview:slider];
        
        _slider  = slider;
        
        
        
        titleLab = [[UILabel alloc] init];
        titleLab.frame = CGRectMake(0, slider.frame.size.height+slider.frame.origin.y+KKButtonHeight, frame.size.width, KKButtonHeight);
        titleLab.text = KKLanguage(@"lab_BLE_deviceInfo_upgrade_text7");
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.font = kk_sizefont(KKFont_Normal);
        titleLab.textColor = kkTextBlackColor;
        [self addSubview:titleLab];
        _bottomLab = titleLab;
    
        
    }
    
    return self;
}

@end
