//
//  HJMaskView.m
//  JiaYueShouYin
//
//  Created by 何军 on 2020/7/24.
//  Copyright © 2020 Eric. All rights reserved.
//

#import "HJMaskView.h"
#import "AppDelegate.h"
@implementation HJMaskView

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
        
        self.frame = frame;
       // self.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.1];
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *pan = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeView)];
        [self addGestureRecognizer:pan];


    
    }
    
    return self;
}
//蒙层添加到Window上
+ (instancetype)makeViewWithMask:(CGRect)frame{
    

    
    HJMaskView *mview = [[self alloc] initWithFrame:frame];
   
    mview.backgroundColor =[[UIColor blackColor] colorWithAlphaComponent:0.5];
   // mview.alpha = 0;
    
//    [UIView animateWithDuration:0.2 animations:^{
//        
//         mview.alpha = 0.5;
//    }];
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [delegate.window addSubview:mview];
   

    return mview;
}

- (void)removeView{
    
    [self removeFromSuperview];
    
    if (self.resultblock) {
        self.resultblock();
    }
}

@end
