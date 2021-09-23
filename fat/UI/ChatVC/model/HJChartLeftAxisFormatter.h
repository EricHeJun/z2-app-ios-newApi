//
//  HJChartLeftAxisFormatter.h
//  fat
//
//  Created by ydd on 2021/5/19.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "fat-Bridging-Header.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJChartLeftAxisFormatter : NSObject<IChartAxisValueFormatter>

//小数位
@property(nonatomic, assign)int digital;


-(NSString *)stringForValue:(double)value axis:(ChartAxisBase *)axis;

@end

NS_ASSUME_NONNULL_END
