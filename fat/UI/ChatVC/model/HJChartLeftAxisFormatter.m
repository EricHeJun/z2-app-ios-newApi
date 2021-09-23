//
//  HJChartLeftAxisFormatter.m
//  fat
//
//  Created by ydd on 2021/5/19.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import "HJChartLeftAxisFormatter.h"

@implementation HJChartLeftAxisFormatter


-(NSString *)stringForValue:(double)value axis:(ChartAxisBase *)axis{
    
      
    if ([[[HJCommon shareInstance] getBLEUnit] isEqualToString:KKBLEParameter_mm]) {
        
        return [NSString stringWithFormat:@"%.1f",value];
        
    }else{
        
        return [NSString stringWithFormat:@"%.2f",value];
    }
    
    
}


@end
