//
//  HJChartXAxisDayFormatter.m
//  fat
//
//  Created by 何军 on 2021/7/20.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import "HJChartXAxisDayFormatter.h"

@implementation HJChartXAxisDayFormatter

- (instancetype)initWithDate:(NSArray*)dateArr{
    self = [super init];
    if (self) {
        _dateArr = dateArr;
    }
    return self;
}


- (NSString *)stringForValue:(double)value axis:(ChartAxisBase *)axis{
    
    NSInteger index = value;
    if (index<0) {
        index = 0;
    }else if (index>_dateArr.count-1){
        index = _dateArr.count-1;
    }
    
    if(_dateArr.count == 0){
        return @"";
    }
    
    NSString * dateString = [_dateArr objectAtIndex:index];
    
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc]init];
    
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    NSDate*date =[dateFormat dateFromString:dateString];
    
    NSArray*weekdays = [NSArray arrayWithObjects: [NSNull null],
                        KKLanguage(@"lab_date_week_1"),
                        KKLanguage(@"lab_date_week_2"),
                        KKLanguage(@"lab_date_week_3"),
                        KKLanguage(@"lab_date_week_4"),
                        KKLanguage(@"lab_date_week_5"),
                        KKLanguage(@"lab_date_week_6"),
                        KKLanguage(@"lab_date_week_7"),nil];
    
    NSCalendar*calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone*timeZone = [[NSTimeZone alloc]initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit =NSCalendarUnitWeekday;
    
    NSDateComponents*theComponents = [calendar components:calendarUnit fromDate:date];
    
    return [weekdays objectAtIndex:theComponents.weekday];
    
    
    return [_dateArr objectAtIndex:index];
}

@end
