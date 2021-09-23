//
//  HJBLEStatusView.m
//  fat
//
//  Created by ydd on 2021/5/21.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import "HJBLEStatusView.h"

@implementation HJBLEStatusView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        UIImage * image = [UIImage imageNamed:@"img_bg_dianchi1"];
        
        UIImageView * imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(kk_x(20), frame.size.height/2- image.size.height/2, image.size.width, image.size.height);
        [self addSubview:imageView];
        _battertImageView = imageView;
        
        
        UILabel * titleLab = [[UILabel alloc] init];
        titleLab.frame = CGRectMake(imageView.frame.origin.x+imageView.frame.size.width+kk_x(20), 0, frame.size.width-(imageView.frame.origin.x+imageView.frame.size.width+kk_x(20)), frame.size.height);
        titleLab.textAlignment = NSTextAlignmentLeft;
        titleLab.font = kk_sizefont(KKFont_small_12);
        titleLab.textColor = kkTextBlackColor;
        [self addSubview:titleLab];
        _connectLab = titleLab;
        
        [self addSubview:self.connectImageView];
        [self addSubview:self.BLEImageView];
        [self addSubview:self.battertImageView];
        
        [self addSubview:self.connectLab];
        
    }
    
    return self;
}

- (UIImageView *)connectImageView{
    if (!_connectImageView) {
        
        _connectImageView = [[UIImageView alloc] init];

    }
    return _connectImageView;
}

- (UIImageView *)BLEImageView{
    if (!_BLEImageView) {
        
        _BLEImageView = [[UIImageView alloc] init];
        
    }
    return _BLEImageView;
}

- (UIImageView *)battertImageView{
    if (!_battertImageView) {
        
        _battertImageView = [[UIImageView alloc] init];
        
    }
    return _battertImageView;
}

- (UILabel *)connectLab{
    if (!_connectLab) {
        
        UILabel * titleLab = [[UILabel alloc] init];
        titleLab.textAlignment = NSTextAlignmentLeft;
        titleLab.font = kk_sizefont(KKFont_small_12);
        titleLab.textColor = kkTextBlackColor;
        _connectLab = titleLab;
    }
    return _connectLab;
}


- (void)BLErefresh:(NSInteger)battery isConnect:(BOOL)isConnect BLEStatus:(BOOL)BLEStatus searching:(BOOL)searching{
    
    if (BLEStatus) {
        
        if (isConnect) {
            
            _battertImageView.hidden = _connectImageView.hidden = _BLEImageView.hidden = NO;
            
            
            UIImage * image = [UIImage imageNamed:@"img_status_connect"];
            _connectImageView.image = image;
            _connectImageView.frame = CGRectMake(kk_x(20), self.frame.size.height/2-image.size.height/2, image.size.width, image.size.height);
            
            image = [UIImage imageNamed:@"img_BLE_status_connect"];
            _BLEImageView.image = image;
            _BLEImageView.frame = CGRectMake(_connectImageView.frame.size.width+_connectImageView.frame.origin.x+kk_x(10), self.frame.size.height/2-image.size.height/2, image.size.width, image.size.height);
            
            NSInteger value = battery ;
            
            _connectLab.text = KKLanguage(@"lab_BLE_connected");
            
            if(value<=33){
                
                image = [UIImage imageNamed:@"img_bg_dianchi1"];
                _connectLab.text = KKLanguage(@"lab_BLE_low_battery");
                
            }else if(value<35){
                image = [UIImage imageNamed:@"img_bg_dianchi2"];
            }else if(value<37){
                image = [UIImage imageNamed:@"img_bg_dianchi3"];
            }else if(value<39){
                image = [UIImage imageNamed:@"img_bg_dianchi4"];
            }else{
                image = [UIImage imageNamed:@"img_bg_dianchi5"];
            }
            
            _battertImageView.image = image;
            _battertImageView.frame = CGRectMake(_BLEImageView.frame.size.width+_BLEImageView.frame.origin.x+kk_x(10), self.frame.size.height/2-image.size.height/2, image.size.width, image.size.height);
            
            
            
            _connectLab.frame = CGRectMake(_battertImageView.frame.size.width+_battertImageView.frame.origin.x+kk_x(10), 0, self.frame.size.width - (_battertImageView.frame.size.width+_battertImageView.frame.origin.x+kk_x(10)), self.frame.size.height);
            
        }else{
            
            _battertImageView.hidden = _connectImageView.hidden = _BLEImageView.hidden = YES;

            _connectLab.frame = CGRectMake(kk_x(40), 0, self.frame.size.width - kk_x(40), self.frame.size.height);
            
            if (searching) {
                
                _connectLab.text = KKLanguage(@"lab_BLE_searching");
                
            }else{
                
                _connectLab.text = @"";
            }
        }
    
    }else{
        
        _connectLab.frame = CGRectMake(kk_x(40), 0, self.frame.size.width - kk_x(40), self.frame.size.height);
        _connectLab.text = KKLanguage(@"lab_BLE_off");
        _battertImageView.hidden = _connectImageView.hidden = _BLEImageView.hidden = YES;

    }
}


@end
