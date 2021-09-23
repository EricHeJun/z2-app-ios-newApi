//
//  HJButtonView.m
//  fat
//
//  Created by ydd on 2021/4/21.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import "HJButtonView.h"

@implementation HJButtonView

- (instancetype)initWithFrame:(CGRect)frame withButtonType:(KKButtonType)buttonType{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        
        UILabel * testAccountLab = [[UILabel alloc] init];
        testAccountLab.frame = CGRectMake(0, 0, frame.size.width, kk_y(60));
        testAccountLab.textAlignment = NSTextAlignmentCenter;
        testAccountLab.font = kk_sizefont(KKFont_Normal);
        testAccountLab.textColor = kkTextGrayColor;
        [self addSubview:testAccountLab];
        _titleLab = testAccountLab;
        
        
        UIButton * testAccountbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        testAccountbtn.frame = CGRectMake(testAccountLab.frame.origin.x, testAccountLab.frame.size.height+testAccountLab.frame.origin.y, testAccountLab.frame.size.width, frame.size.height - testAccountLab.frame.size.height);
        
        testAccountbtn.tag = buttonType;
        testAccountbtn.backgroundColor = kkBgGrayColor;
        testAccountbtn.layer.cornerRadius = KKLayerCornerRadius;
        testAccountbtn.layer.borderWidth = KKLineWidth;
        testAccountbtn.layer.borderColor = kkButtonLineGrayColor.CGColor;
        [self addSubview:testAccountbtn];
        _testButton = testAccountbtn;
        

        UIImage * image = [UIImage imageNamed:@"img_me_userinfo_photo_s"];
        
        UIImageView * imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(_testButton.frame.size.width/2 - kk_x(60)/2, kk_y(20), kk_x(60),kk_x(60));
        imageView.image = image;
        [testAccountbtn addSubview:imageView];
        _topImageView = imageView;
        
        
        UILabel * titleLab = [[UILabel alloc] init];
        titleLab.frame = CGRectMake(0, _topImageView.frame.size.height+_topImageView.frame.origin.y, frame.size.width, _testButton.frame.size.height - (_topImageView.frame.size.height+_topImageView.frame.origin.y));
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.font = kk_sizefont(KKFont_Normal);
        titleLab.textColor = KKBgYellowColor;
        [testAccountbtn addSubview:titleLab];
        _textLab = titleLab;
        
        
        image = [UIImage imageNamed:@"img_main_right_bottom"];
        imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(_testButton.frame.size.width - image.size.width - kk_x(40), _testButton.frame.size.height/2-image.size.height/2, image.size.width, image.size.height);
        imageView.image = image;
        [testAccountbtn addSubview:imageView];
        _rightImageView = imageView;
        
        
    }
    
    return self;
}

@end
