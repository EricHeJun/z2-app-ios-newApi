//
//  HJMuscleGuideView.m
//  fat
//
//  Created by ydd on 2021/8/7.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import "HJMuscleGuideView.h"

@implementation HJMuscleGuideView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.indexTag = 0;
        
        self.backgroundColor =[KKBgYellowColor colorWithAlphaComponent:0.9];
        
        [self addSubview:self.titleLab];
        [self addSubview:self.firstLab];
        
        [self addSubview:self.imageView];
        [self addSubview:self.twoLab];
        
        [self addSubview:self.cancelBtn];
        
        [self addSubview:self.backBtn];
        
        [self addSubview:self.lastBtn];
        
        
    }
    
    return self;
}

#pragma mark ============== UI ===============
- (UILabel *)titleLab{
    
    if (!_titleLab) {
        
        UILabel * titleLab = [[UILabel alloc] init];
        titleLab.frame = CGRectMake(self.frame.size.width/4, KKStatusBarHeight, self.frame.size.width/2, 44);
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.font = kk_sizefont(KKFont_Normal);
        titleLab.textColor = kkWhiteColor;
        _titleLab = titleLab;
    }
    return _titleLab;
}

- (UILabel *)firstLab{
    
    if (!_firstLab) {
        UILabel * titleLab = [[UILabel alloc] init];
        titleLab.frame = CGRectMake(kk_x(40), KKNavBarHeight, self.frame.size.width - 2*kk_x(40), kk_y(80));
        titleLab.textAlignment = NSTextAlignmentLeft;
        titleLab.font = kk_sizefont(KKFont_small_large);
        titleLab.textColor = kkWhiteColor;
        titleLab.numberOfLines = 0;
        _firstLab = titleLab;
    }
    
    return _firstLab;
}

- (UIImageView *)imageView{
    
    float width = self.frame.size.width*0.8;
    float height = width/2;
    
    if (!_imageView) {
        
        UIImageView * imageview = [[UIImageView alloc] init];
        imageview.frame = CGRectMake((self.frame.size.width-width)/2, _firstLab.frame.size.height+_firstLab.frame.origin.y, width, height);
        
        _imageView = imageview;
    }
    
    return _imageView;
}


- (UILabel *)twoLab{
    
    if (!_twoLab) {
        UILabel * titleLab = [[UILabel alloc] init];
        titleLab.frame = CGRectMake(kk_x(40), _imageView.frame.size.height+_imageView.frame.origin.y, self.frame.size.width - 2*kk_x(40), kk_y(80));
        titleLab.textAlignment = NSTextAlignmentLeft;
        titleLab.font = kk_sizefont(KKFont_small_large);
        titleLab.textColor = kkWhiteColor;
        titleLab.numberOfLines = 0;
        _twoLab = titleLab;
    }
    
    return _twoLab;
}


- (UIButton *)cancelBtn{
    
    if (!_cancelBtn) {
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(self.frame.size.width - 60, _titleLab.frame.origin.y, 44, 44);
        
        UIImage *image = [UIImage imageNamed:@"common_bg_cancel"];
        
        [btn setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        btn.tintColor = kkWhiteColor;
        btn.tag = KKButton_Cancel;
        
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        _cancelBtn = btn;
        
        
    }

    return _cancelBtn;
}

- (UIButton *)backBtn{
    
    if (!_backBtn) {
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];

        btn.tag = KKButton_back;
        
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = kkWhiteColor.CGColor;
        
        [btn setTitleColor:kkWhiteColor forState:UIControlStateNormal];
        btn.titleLabel.font = kk_sizefont(KKFont_Normal);
        
        [btn setTitle:KKLanguage(@"lab_guide_back") forState:UIControlStateNormal];

        _backBtn = btn;
        
    }

    return _backBtn;
}

- (UIButton *)lastBtn{
    
    float width = kk_x(320);
    float height = kk_y(60);
    
    if (!_lastBtn) {
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(self.frame.size.width/2 - width/2, self.frame.size.height - height - kk_y(20), width, height);
        
        btn.tag = KKButton_last;
    
        
        btn.backgroundColor = kkWhiteColor;
        
        [btn setTitleColor:KKBgYellowColor forState:UIControlStateNormal];
        btn.titleLabel.font = kk_sizefont(KKFont_Normal);
        
        [btn setTitle:KKLanguage(@"lab_guide_last") forState:UIControlStateNormal];
        
        _lastBtn = btn;
        
    }

    return _lastBtn;
}

- (void)btnClick:(UIButton*)sender{
    
    switch (sender.tag) {
            
        case KKButton_Cancel:
            
            [self remove];
            
            break;
            
            
        default:
            break;
    }
}

- (void)remove{
    
    [self removeFromSuperview];
    self.indexTag = 0;
    
}

@end
