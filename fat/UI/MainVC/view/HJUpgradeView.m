//
//  HJUpgradeView.m
//  fat
//
//  Created by ydd on 2021/5/24.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import "HJUpgradeView.h"

@implementation HJUpgradeView

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
        titleLab.frame = CGRectMake(kk_x(20), 0,frame.size.width - kk_x(20), KKButtonHeight);
        titleLab.font = kk_sizefont(KKFont_Normal);
        titleLab.textColor = kkTextBlackColor;
        [self addSubview:titleLab];
        
        _titleLab = titleLab;
        
        
        
        titleLab = [[UILabel alloc] init];
        titleLab.frame = CGRectMake(kk_x(20), _titleLab.frame.size.height+_titleLab.frame.origin.y,frame.size.width - kk_x(20), KKButtonHeight);
        titleLab.font = kk_sizefont(KKFont_Normal);
        titleLab.textColor = kkTextBlackColor;
        [self addSubview:titleLab];
        
        _currectLab = titleLab;
        
        
        titleLab = [[UILabel alloc] init];
        titleLab.frame = CGRectMake(kk_x(20),  _currectLab.frame.size.height+_currectLab.frame.origin.y,frame.size.width - kk_x(20), KKButtonHeight);
        titleLab.font = kk_sizefont(KKFont_Normal);
        titleLab.textColor = kkTextBlackColor;
        [self addSubview:titleLab];
        
        _freshLab = titleLab;
        
        
        
        titleLab = [[UILabel alloc] init];
        titleLab.frame = CGRectMake(kk_x(20),  _freshLab.frame.size.height+_freshLab.frame.origin.y,frame.size.width - kk_x(20), KKButtonHeight);
        titleLab.font = kk_sizefont(KKFont_Normal);
        titleLab.textColor = kkTextBlackColor;
        titleLab.numberOfLines = 0;
        [self addSubview:titleLab];
        
        _logLab = titleLab;
        
        
    }
    return self;
}


@end
