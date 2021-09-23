//
//  HJChartsView.m
//  fat
//
//  Created by ydd on 2021/5/18.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import "HJChartsView.h"

@interface HJChartsView (){
    
    float _makerX_Min;
    float _makerX_Max;
    
    float _makerY_Min;
    float _makerY_Max;
    
}

@end

@implementation HJChartsView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self addSubview:self.chartView];
        
    }
    
    return self;
}

- (LineChartView *)chartView{
    
    if (!_chartView) {
        
        _chartView = [[LineChartView alloc] init];
        
        _chartView.frame  = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        
        // 是否开启描述label
        _chartView.chartDescription.enabled = NO;
        
        //是否显示图例
        _chartView.legend.enabled = NO;
        
        _chartView.dragEnabled = YES; //拖动气泡
     
        //取消Y轴缩放
        _chartView.scaleYEnabled = NO;

        // 取消双击缩放
        _chartView.doubleTapToZoomEnabled =NO;
        
        //
        _chartView.drawBordersEnabled = NO;
      

        //是否支持marker功能 这里可以自定义一个点击弹窗的marker
        _chartView.drawMarkers = YES;
        
    
        /*
         左侧轴
         */
        ChartYAxis *leftAxis = _chartView.leftAxis;
        
        //是否使能left坐标轴
        leftAxis.enabled = YES;
        //坐标值在外部还是内部
        leftAxis.labelPosition = YAxisLabelPositionOutsideChart;

        leftAxis.drawAxisLineEnabled = NO;
        leftAxis.drawGridLinesEnabled = NO;
    
        leftAxis.labelCount = 7;
        leftAxis.axisMinimum = 0;
    
    
        /*
         右侧轴
         */
        _chartView.rightAxis.enabled = NO;
        
        
        /*
         X轴
         */
         
        ChartXAxis *xAxis = _chartView.xAxis;
        
        xAxis.drawAxisLineEnabled = YES;//是否画x轴线
        xAxis.drawGridLinesEnabled = YES;//是否画网格
        xAxis.gridLineDashLengths = @[@5.f, @5.f];
        
        xAxis.granularity = 1;
        
        xAxis.labelCount = 5;
       // xAxis.axisMinimum = 0;
       // xAxis.spaceMin = 10;

        /*
         取消重复的数字
         */
        xAxis.granularityEnabled = YES;
        
        xAxis.labelPosition = XAxisLabelPositionBottom;
        xAxis.avoidFirstLastClippingEnabled = YES;
        
    }
    
    return _chartView;
}


- (void)drawFatView:(NSArray*)fatArr muscleArr:(NSArray*)muscleArr color:(UIColor*)color type:(KKButtonType)type pointDateArr:(NSMutableArray*)pointDateArr{
    
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    
    if (fatArr.count) {
        
        //创建一个集合并为这个集合赋值 label的值可为空
        LineChartDataSet *set = [[LineChartDataSet alloc] initWithEntries:fatArr label:nil];
        //折线颜色
        [set setColor:color];
        
        set.lineWidth = 3;
        //这里模式可以用来设置线条的类型：比如折线，平滑曲线等
        set.mode = LineChartModeHorizontalBezier;
        //使能小圆圈 默认使能 通过圆圈和Hole可以画出空心圆的效果，这个在k线指标DKBY图中会用到的
        set.drawCirclesEnabled = YES;
        //圆圈半径
        set.circleRadius = 4;
        //圆圈颜色
        set.circleColors = @[color];
        //使能圆圈孔
        set.drawCircleHoleEnabled = YES;
        //圆孔孔中心半径 这个半径要比圆圈半径小才可以看到空心圆效果
        set.circleHoleRadius = 2;
        
        
        set.drawHorizontalHighlightIndicatorEnabled = NO;
        set.drawVerticalHighlightIndicatorEnabled = YES;
        
        set.fillAlpha = 0.2;
        set.drawFilledEnabled = YES;
        set.fillColor =  color;
        
        set.highlightColor = color;
        
        set.highlightEnabled = YES;
        /*
         是否显示数字
         */
        set.drawValuesEnabled = NO;
        
        [dataSets addObject:set];

    }
    
    
    if (muscleArr.count) {
        
        //创建一个集合并为这个集合赋值 label的值可为空
        LineChartDataSet *set = [[LineChartDataSet alloc] initWithEntries:muscleArr label:nil];
        //折线颜色
        [set setColor:color];
        
        set.lineWidth = 3;
        //这里模式可以用来设置线条的类型：比如折线，平滑曲线等
        set.mode = LineChartModeHorizontalBezier;
        //使能小圆圈 默认使能 通过圆圈和Hole可以画出空心圆的效果，这个在k线指标DKBY图中会用到的
        set.drawCirclesEnabled = YES;
        //圆圈半径
        set.circleRadius = 4;
        //圆圈颜色
        set.circleColors = @[color];

        set.drawHorizontalHighlightIndicatorEnabled = NO;
        set.drawVerticalHighlightIndicatorEnabled = YES;
        
        
        set.lineDashLengths = @[@5.f, @2.5f];
        //set.highlightLineDashLengths = @[@5.f, @2.5f];
        
        set.highlightColor = color;
        
        set.highlightEnabled = YES;
        
        set.drawValuesEnabled = NO;
        
        [dataSets addObject:set];
    }
    
    /*
     移除残留数据
     */
    [self.chartView.leftAxis removeAllLimitLines];
    [self.chartView.xAxis removeAllLimitLines];
    
    /*
     y轴的 数值类型
     */
    self.chartView.leftAxis.valueFormatter = [HJChartLeftAxisFormatter new];
    
    /*
     x轴的 日期类型
     */
    if (type == KKButton_week) {
        self.chartView.xAxis.valueFormatter = [[HJChartXAxisDayFormatter alloc] initWithDate:pointDateArr];
    }else if (type == KKButton_month){
        self.chartView.xAxis.valueFormatter = [[HJChartXAxisMonthFormatter alloc] initWithDate:pointDateArr];
    }else if (type == KKButton_year){
        self.chartView.xAxis.valueFormatter = [[HJChartXAxisYearFormatter alloc] initWithDate:pointDateArr];
    }
    
    LineChartData *chartData = [[LineChartData alloc]  initWithDataSets:dataSets];
    
    //将数据添加到图中 注意这里可以是多条线  [chartData addDataSet:set]
    self.chartView.data = chartData;
    self.chartView.marker = nil;

}

- (void)showMarkerView:(NSString*)value bgColor:(UIColor*)color{
    
    ChartMarkerView * makerView = [[ChartMarkerView alloc]initWithFrame:CGRectMake(0, 0, 60, 25)];
    makerView.backgroundColor = color;
    makerView.layer.cornerRadius = 5;
    makerView.chartView = _chartView;
    makerView.offset = CGPointMake(-30, -35);

    
    HJArrowView * arrowView = [[HJArrowView alloc] initWithFrame:CGRectMake(0, makerView.frame.size.height-1, makerView.frame.size.width, 5) bgColor:color];
    arrowView.backgroundColor = [UIColor clearColor];
    [makerView addSubview:arrowView];

    
    UILabel * titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, makerView.frame.size.width, makerView.frame.size.height)];
    titleLab.text = value;
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = kk_sizefont(KKFont_small_12);
    titleLab.textColor = kkWhiteColor;
    titleLab.adjustsFontSizeToFitWidth = YES;
    titleLab.numberOfLines = 0;
    [makerView addSubview:titleLab];
    
    
    _chartView.marker = makerView;
    
}




@end
