//
//  HJChartXAxisYearFormatter.m
//  fat
//
//  Created by 何军 on 2021/7/20.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import "HJChartXAxisYearFormatter.h"

@implementation HJChartXAxisYearFormatter

- (instancetype)initWithDate:(NSArray*)dateArr{
    self = [super init];
    if (self) {
        _dateArr = dateArr;
    }
    return self;
}


-(NSString *)stringForValue:(double)value axis:(ChartAxisBase *)axis{
    
    NSInteger index = value;
    if (index<0) {
        index = 0;
    }else if (index>_dateArr.count-1){
        index = _dateArr.count-1;
    }
    
    if(_dateArr.count == 0){
        return @"";
    }
    
    return [_dateArr objectAtIndex:index];
}

@end
