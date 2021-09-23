//
//  HJUpgradeTipsView.m
//  fat
//
//  Created by ydd on 2021/5/25.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import "HJUpgradeTipsView.h"

@implementation HJUpgradeTipsView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        
        UIImage * image = [UIImage imageNamed:@"img_BLE_upgrade_fail"];
        UIImageView * imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(frame.size.width/2 - image.size.width/2, kk_y(50), image.size.width, image.size.height);
        imageView.image = image;
        [self addSubview:imageView];
        _imageView = imageView;
        
        
        
        UILabel * titleLab = [[UILabel alloc] init];
        titleLab.frame = CGRectMake(0, _imageView.frame.size.height + _imageView.frame.origin.y + kk_y(50), frame.size.width, KKButtonHeight);
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.font = kk_sizefont(KKFont_Normal);
        titleLab.textColor = kkTextBlackColor;
        [self addSubview:titleLab];
        _resultLab = titleLab;
        
        
        titleLab = [[UILabel alloc] init];
        titleLab.frame = CGRectMake(0,  _resultLab.frame.size.height + _resultLab.frame.origin.y , frame.size.width, KKButtonHeight);
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.font = kk_sizefont(KKFont_Normal);
        titleLab.textColor = kkTextBlackColor;
        titleLab.numberOfLines = 0;
        [self addSubview:titleLab];
        _detailLab = titleLab;
        
        
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(kk_x(20), _detailLab.frame.origin.y + _detailLab.frame.size.height, frame.size.width - 2*kk_x(20), KKButtonHeight);
        [btn setTitle:KKLanguage(@"lab_common_done") forState:UIControlStateNormal];
        [btn setTitleColor:kkWhiteColor forState:UIControlStateNormal];
        btn.titleLabel.font = kk_sizefont(KKFont_Normal);
        btn.backgroundColor = KKBgYellowColor;
        [self addSubview:btn];
        btn.tag = KKButton_Cancel;
        _cancelBtn = btn;
        
        
    }
    
    return self;
}

@end
