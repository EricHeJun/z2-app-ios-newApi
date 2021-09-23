//
//  HJDeviceBgView.m
//  fat
//
//  Created by ydd on 2021/4/23.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import "HJDeviceBgView.h"

@implementation HJDeviceBgView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        UIImage * image = [UIImage imageNamed:@"img_bg_device"];
        
        UIImageView * deviceImageView = [[UIImageView alloc] init];
        deviceImageView.frame = CGRectMake(0, KKButtonHeight, frame.size.width, kk_y(450));
        deviceImageView.image = image;
        deviceImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:deviceImageView];
        _deviceImageView = deviceImageView;
        
        
        UILabel * titleLab = [[UILabel alloc] init];
        titleLab.frame = CGRectMake(0, _deviceImageView.frame.size.height+_deviceImageView.frame.origin.y, frame.size.width, KKButtonHeight);
        titleLab.text = KKLanguage(@"lab_main_deviceDetail_text1");
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.font = kk_sizefont(KKFont_small_12);
        titleLab.textColor = kkTextGrayColor;
        titleLab.numberOfLines = 0;
        [self addSubview:titleLab];
        
        _deviceDetailLab = titleLab;
        
        
        titleLab = [[UILabel alloc] init];
        titleLab.frame = CGRectMake(frame.size.width/4, _deviceDetailLab.frame.size.height+_deviceDetailLab.frame.origin.y, frame.size.width/2, KKButtonHeight);
        titleLab.text = KKLanguage(@"lab_main_deviceDetail_text3");
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.font = kk_sizefont(KKFont_Big_20);
        titleLab.textColor = kkTextBlackColor;
        titleLab.numberOfLines = 0;
        [self addSubview:titleLab];
        
        _deviceConnectLab = titleLab;
        
        
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        btn.frame = CGRectMake(_deviceConnectLab.frame.origin.x+_deviceConnectLab.frame.size.width, _deviceConnectLab.frame.origin.y, KKButtonHeight, KKButtonHeight);
        
        [btn setImage:[UIImage imageNamed:@"img_btn_tips"] forState:UIControlStateNormal];

        btn.titleLabel.font = kk_sizefont(KKFont_small_12);
        [self addSubview:btn];
        btn.tag = KKButton_Account_Login;

        _deviceFaqBtn = btn;
        

        
        
    }
    return self;
}

@end
