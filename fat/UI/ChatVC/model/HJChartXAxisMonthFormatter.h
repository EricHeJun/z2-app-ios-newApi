//
//  HJChartXAxisMonthFormatter.h
//  fat
//
//  Created by 何军 on 2021/7/20.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "fat-Bridging-Header.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJChartXAxisMonthFormatter : NSObject<IChartAxisValueFormatter>

@property (strong,nonatomic)NSArray * dateArr;

- (instancetype)initWithDate:(NSArray*)dateArr;

- (NSString *)stringForValue:(double)value axis:(ChartAxisBase *)axis;

@end

NS_ASSUME_NONNULL_END
