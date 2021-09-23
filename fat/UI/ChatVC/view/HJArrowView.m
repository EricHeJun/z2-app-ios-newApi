//
//  HJArrowView.m
//  fat
//
//  Created by ydd on 2021/7/8.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import "HJArrowView.h"

@implementation HJArrowView


- (instancetype)initWithFrame:(CGRect)frame bgColor:(UIColor*)color{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.bgColor = color;
    }
    return self;
    
}


- (void)drawRect:(CGRect)rect{
    
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextMoveToPoint(context, rect.size.width/2-5, 0);

    CGContextAddLineToPoint(context, rect.size.width/2+5, 0);

    CGContextAddLineToPoint(context, rect.size.width/2, rect.size.height-1);

    CGContextClosePath(context);

    [self.bgColor setStroke];
    [self.bgColor setFill];

    CGContextDrawPath(context, kCGPathFillStroke);
    
}

@end
