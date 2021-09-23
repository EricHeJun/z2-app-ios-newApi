//
//  HJChartsView.h
//  fat
//
//  Created by ydd on 2021/5/18.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import "HJBaseView.h"
#import "fat-Bridging-Header.h"

#import "HJChartXAxisDayFormatter.h"
#import "HJChartXAxisMonthFormatter.h"
#import "HJChartXAxisYearFormatter.h"
#import "HJChartLeftAxisFormatter.h"

#import "HJArrowView.h"
NS_ASSUME_NONNULL_BEGIN

@interface HJChartsView : HJBaseView

@property (strong,nonatomic)LineChartView * chartView;

@property (strong,nonatomic)UILabel * makerLab;

- (instancetype)initWithFrame:(CGRect)frame;

- (void)drawFatView:(NSArray*)fatArr muscleArr:(NSArray*)muscleArr color:(UIColor*)color type:(KKButtonType)type pointDateArr:(NSMutableArray*)pointDateArr;

- (void)showMarkerView:(NSString*)value bgColor:(UIColor*)color;

@end

NS_ASSUME_NONNULL_END
