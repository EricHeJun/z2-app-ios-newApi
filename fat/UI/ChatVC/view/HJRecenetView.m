//
//  HJRecenetView.m
//  fat
//
//  Created by ydd on 2021/5/17.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import "HJRecenetView.h"

@implementation HJRecenetView

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
        titleLab.frame = CGRectMake(kk_x(20), 0, kk_x(200), kk_y(60));
        titleLab.text = KKLanguage(@"lab_chat_recently_chat");
        titleLab.textAlignment = NSTextAlignmentLeft;
        titleLab.font = kk_sizefont(KKFont_Normal);
        titleLab.textColor = kkTextGrayColor;
        [self addSubview:titleLab];
        _titleLab = titleLab;
        
        UIView * bgview = [[UIView alloc] init];
        bgview.frame = CGRectMake(kk_x(20),titleLab.frame.size.height, self.frame.size.width-2*kk_x(20), self.frame.size.height - titleLab.frame.size.height-2);
        bgview.layer.borderColor = KKBgYellowColor.CGColor;
        bgview.layer.masksToBounds = YES;
        bgview.layer.borderWidth = 1;
        bgview.layer.cornerRadius = KKLayerCornerRadius;
        [self addSubview:bgview];
        _bgview  = bgview;
        
        
        UILabel * timeLab = [[UILabel alloc] init];
        timeLab.frame = CGRectMake(2, 0, bgview.frame.size.width/3, bgview.frame.size.height);
        timeLab.textAlignment = NSTextAlignmentCenter;
        timeLab.font = kk_sizefont(KKFont_small_12);
        timeLab.textColor = kkTextBlackColor;
        timeLab.text = KKLanguage(@"lab_chat_history_chat_text1");
        [bgview addSubview:timeLab];
        timeLab.numberOfLines = 1;
        timeLab.adjustsFontSizeToFitWidth = YES;
        _timeLab  =  timeLab;
        
        float width = (bgview.frame.size.width - timeLab.frame.size.width)/5;
        
        UILabel * positionLab = [[UILabel alloc] init];
        positionLab.frame = CGRectMake(timeLab.frame.size.width+timeLab.frame.origin.x, timeLab.frame.origin.y, width, timeLab.frame.size.height);
        positionLab.textAlignment = NSTextAlignmentCenter;
        positionLab.font = kk_sizefont(KKFont_small_12);
        positionLab.textColor = kkTextBlackColor;
        positionLab.text = KKLanguage(@"lab_main_test_point");
        [bgview addSubview:positionLab];
        _positionLab = positionLab;
        
        UILabel * functionLab = [[UILabel alloc] init];
        functionLab.frame =CGRectMake(positionLab.frame.size.width+positionLab.frame.origin.x, positionLab.frame.origin.y, positionLab.frame.size.width, positionLab.frame.size.height);
        functionLab.textAlignment = NSTextAlignmentCenter;
        functionLab.font = kk_sizefont(KKFont_small_12);
        functionLab.textColor = kkTextBlackColor;
        functionLab.text = KKLanguage(@"lab_chat_history_chat_text2");
        [bgview addSubview:functionLab];
        _functionLab = functionLab;
        
        UILabel * recordValueLab = [[UILabel alloc] init];
        recordValueLab.frame = CGRectMake(functionLab.frame.size.width+functionLab.frame.origin.x, positionLab.frame.origin.y, positionLab.frame.size.width+positionLab.frame.size.width*1/3, positionLab.frame.size.height);
        recordValueLab.textAlignment = NSTextAlignmentCenter;
        recordValueLab.font = kk_sizefont(KKFont_small_12);
        recordValueLab.textColor = kkTextBlackColor;
        recordValueLab.text = KKLanguage(@"lab_chat_history_chat_text3");
        [bgview addSubview:recordValueLab];
        _recordValueLab = recordValueLab;
        
        UIImageView * imageView= [[UIImageView alloc] init];
        imageView.frame =CGRectMake(recordValueLab.frame.size.width+recordValueLab.frame.origin.x, kk_y(40), positionLab.frame.size.width*2/3, positionLab.frame.size.height-kk_y(40)*2);
        [bgview addSubview:imageView];
        _imageView  = imageView;
        
        
        UIImage * image = [UIImage imageNamed:@"img_bg_next"];
        UIImageView * nextImageView= [[UIImageView alloc] init];
        nextImageView.frame =CGRectMake(imageView.frame.size.width+imageView.frame.origin.x+kk_x(50), bgview.frame.size.height/2 - image.size.height/2, image.size.width, image.size.height);
        [bgview addSubview:nextImageView];
        nextImageView.image = image;
        _nextImageView  = nextImageView;
        
    }
    return self;
}

@end
