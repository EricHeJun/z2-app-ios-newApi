//
//  HJChartAnalysisModel.m
//  fat
//
//  Created by 何军 on 2021/5/28.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import "HJChartAnalysisModel.h"

@implementation HJChartAnalysisModel

+ (HJChartAnalysisModel*)chartAnalysisSex:(NSString*)sex position:(KKTest_Function_Position)position value:(float)recordValue{
    
    /*
     value 是 cm
     
     转成
     
     当前的 单位
     
     */
    NSString * valueResult = [[HJCommon shareInstance] getCurrectUnitValue:recordValue];
    NSString * unit = [[HJCommon shareInstance] getBLEUnit];
    NSString * resultValue = [NSString stringWithFormat:@"%@ %@",valueResult,unit];
    

    NSString * valueString = [NSString stringWithFormat:@"%.1f",recordValue];

    /*
     换成 mm 来判断
     */
    float value = [valueString floatValue]*10;
    
    UIColor * resultAnalysisColor;
    NSString * resultStr;
    NSString * str;
    UIImage * image;
    HJChartAnalysisModel * model = [HJChartAnalysisModel new];
    model.resultValue = resultValue;
    model.recordValue = valueString;
    
    if([sex intValue] == 0){
        /*
         女性
         */
        
        switch (position) {
                
            case KKTest_Function_Position_Calf:
            case KKTest_Function_Position_Ham:
                
                if (value < 5) {
                    str = KKLanguage(@"lab_function_result_1_analysis");
                }else if (value == 5){
                    str = KKLanguage(@"lab_function_result_2_analysis");
                }else if (value == 6){
                    str = KKLanguage(@"lab_function_result_3_analysis");
                }else if (value<= 8){
                    str = KKLanguage(@"lab_function_result_4_analysis");
                }else if (value<= 10){
                    str = KKLanguage(@"lab_function_result_5_analysis");
                }else{
                    str = KKLanguage(@"lab_function_result_6_analysis");
                }
                
                break;
                
            case KKTest_Function_Position_Arm:
                
                if (value < 6) {
                    str = KKLanguage(@"lab_function_result_1_analysis");
                }else if (value <= 7){
                    str = KKLanguage(@"lab_function_result_2_analysis");
                }else if (value <= 9){
                    str = KKLanguage(@"lab_function_result_3_analysis");
                }else if (value <= 12){
                    str = KKLanguage(@"lab_function_result_4_analysis");
                }else if (value <= 15){
                    str = KKLanguage(@"lab_function_result_5_analysis");
                }else{
                    str = KKLanguage(@"lab_function_result_6_analysis");
                }
                
                break;
                
            case KKTest_Function_Position_Waist:
                
                if (value < 6) {
                    str = KKLanguage(@"lab_function_result_1_analysis");
                }else if (value <= 7){
                    str = KKLanguage(@"lab_function_result_2_analysis");
                }else if (value <= 10){
                    str = KKLanguage(@"lab_function_result_3_analysis");
                }else if (value <= 13){
                    str = KKLanguage(@"lab_function_result_4_analysis");
                }else if (value <= 17){
                    str = KKLanguage(@"lab_function_result_5_analysis");
                }else{
                    str = KKLanguage(@"lab_function_result_6_analysis");
                }
                
                break;
                
            case KKTest_Function_Position_Belly:
                
                if (value < 6) {
                    str = KKLanguage(@"lab_function_result_1_analysis");
                }else if (value <= 8){
                    str = KKLanguage(@"lab_function_result_2_analysis");
                }else if (value <= 12){
                    str = KKLanguage(@"lab_function_result_3_analysis");
                }else if (value <= 15){
                    str = KKLanguage(@"lab_function_result_4_analysis");
                }else if (value <= 19){
                    str = KKLanguage(@"lab_function_result_5_analysis");
                }else{
                    str = KKLanguage(@"lab_function_result_6_analysis");
                }
                
                break;
                
            default:
                break;
        }
        
    
        
    }else{
        /*
         男性
         */
        
        switch (position) {
                
            case KKTest_Function_Position_Calf:
            case KKTest_Function_Position_Ham:
                
                if (value < 4) {
                    str = KKLanguage(@"lab_function_result_1_analysis");
                }else if (value <= 5){
                    str = KKLanguage(@"lab_function_result_2_analysis");
                }else if (value <= 7){
                    str = KKLanguage(@"lab_function_result_3_analysis");
                }else if (value <= 9){
                    str = KKLanguage(@"lab_function_result_4_analysis");
                }else if (value <= 11){
                    str = KKLanguage(@"lab_function_result_5_analysis");
                }else{
                    str = KKLanguage(@"lab_function_result_6_analysis");
                }
                
                break;
                
            case KKTest_Function_Position_Arm:
                
                if (value < 4) {
                    str = KKLanguage(@"lab_function_result_1_analysis");
                }else if (value == 4){
                    str = KKLanguage(@"lab_function_result_2_analysis");
                }else if (value == 5){
                    str = KKLanguage(@"lab_function_result_3_analysis");
                }else if (value == 6){
                    str = KKLanguage(@"lab_function_result_4_analysis");
                }else if (value == 7){
                    str = KKLanguage(@"lab_function_result_5_analysis");
                }else{
                    str = KKLanguage(@"lab_function_result_6_analysis");
                }
                
                break;
                
            case KKTest_Function_Position_Waist:
                
                if (value < 5) {
                    str = KKLanguage(@"lab_function_result_1_analysis");
                }else if (value <= 7){
                    str = KKLanguage(@"lab_function_result_2_analysis");
                }else if (value <= 10){
                    str = KKLanguage(@"lab_function_result_3_analysis");
                }else if (value <= 13){
                    str = KKLanguage(@"lab_function_result_4_analysis");
                }else if (value <= 17){
                    str = KKLanguage(@"lab_function_result_5_analysis");
                }else{
                    str = KKLanguage(@"lab_function_result_6_analysis");
                }
                
                break;
                
            case KKTest_Function_Position_Belly:
                
                if (value < 5) {
                    str = KKLanguage(@"lab_function_result_1_analysis");
                }else if (value <= 7){
                    str = KKLanguage(@"lab_function_result_2_analysis");
                }else if (value <= 11){
                    str = KKLanguage(@"lab_function_result_3_analysis");
                }else if (value <= 14){
                    str = KKLanguage(@"lab_function_result_4_analysis");
                }else if (value <= 18){
                    str = KKLanguage(@"lab_function_result_5_analysis");
                }else{
                    str = KKLanguage(@"lab_function_result_6_analysis");
                }
                
                break;
                
            default:
                break;
        }
    }
    
    
    
    if ([str isEqualToString:KKLanguage(@"lab_function_result_1_analysis")]) {
        image = [UIImage imageNamed:@"img_charts_result_1"];
        resultStr = KKLanguage(@"lab_function_result_1");
        resultAnalysisColor = KKChartColor1;
    }else if ([str isEqualToString:KKLanguage(@"lab_function_result_2_analysis")]) {
        image = [UIImage imageNamed:@"img_charts_result_2"];
        resultStr = KKLanguage(@"lab_function_result_2");
        resultAnalysisColor = KKChartColor2;
    }else if ([str isEqualToString:KKLanguage(@"lab_function_result_3_analysis")]) {
        image = [UIImage imageNamed:@"img_charts_result_3"];
        resultStr = KKLanguage(@"lab_function_result_3");
        resultAnalysisColor = KKChartColor3;
    }else if ([str isEqualToString:KKLanguage(@"lab_function_result_4_analysis")]) {
        image = [UIImage imageNamed:@"img_charts_result_4"];
        resultStr = KKLanguage(@"lab_function_result_4");
        resultAnalysisColor = KKChartColor4;
    }else if ([str isEqualToString:KKLanguage(@"lab_function_result_5_analysis")]) {
        image = [UIImage imageNamed:@"img_charts_result_5"];
        resultStr = KKLanguage(@"lab_function_result_5");
        resultAnalysisColor = KKChartColor5;
    }else{
        image = [UIImage imageNamed:@"img_charts_result_6"];
        resultStr = KKLanguage(@"lab_function_result_6");
        resultAnalysisColor = KKChartColor6;
    }
    
    model.resultImage = image;
    model.resultString = str;
    model.resultAnalysisString = resultStr;
    model.resultColor = resultAnalysisColor;
    return model;
}

+ (HJChartAnalysisModel*)chartAnalysisResultSex:(NSString*)sex position:(KKTest_Function_Position)position value:(float)value{
    
    HJChartAnalysisModel * model = [HJChartAnalysisModel new];
    
    if([sex intValue] == 0){
        /*
         女性
         */
        
        switch (position) {
                
            case KKTest_Function_Position_Calf:
            case KKTest_Function_Position_Ham:
                
                model.min = 0.2;
                
                model.AnalysisValue1 = 0.4;
                model.AnalysisValue2 = 0.5;
                model.AnalysisValue3 = 0.6;
                model.AnalysisValue4 = 0.8;
                model.AnalysisValue5 = 1.0;
                model.AnalysisValue6 = 0.2 + model.AnalysisValue5;
                model.max = model.AnalysisValue6;
                
                break;
                
            case KKTest_Function_Position_Arm:
                
                
                model.min = 0.2;
               
                model.AnalysisValue1 = 0.5;
                model.AnalysisValue2 = 0.7;
                model.AnalysisValue3 = 0.9;
                model.AnalysisValue4 = 1.2;
                model.AnalysisValue5 = 1.5;
                model.AnalysisValue6 = 0.3 + model.AnalysisValue5;
                model.max = model.AnalysisValue6;
                
                break;
                
            case KKTest_Function_Position_Waist:
                
                
                model.min = 0.2;
               
                model.AnalysisValue1 = 0.5;
                model.AnalysisValue2 = 0.7;
                model.AnalysisValue3 = 1.0;
                model.AnalysisValue4 = 1.3;
                model.AnalysisValue5 = 1.7;
                model.AnalysisValue6 = 0.3 + model.AnalysisValue5;
                model.max = model.AnalysisValue6;
                
                
                break;
                
            case KKTest_Function_Position_Belly:
                
                model.min = 0.2;
               
                model.AnalysisValue1 = 0.5;
                model.AnalysisValue2 = 0.8;
                model.AnalysisValue3 = 1.2;
                model.AnalysisValue4 = 1.5;
                model.AnalysisValue5 = 1.9;
                model.AnalysisValue6 = 0.3 + model.AnalysisValue5;
                model.max = model.AnalysisValue6;
                
                break;
                
            default:
                break;
        }
        
    }else{
        /*
         男性
         */
        
        switch (position) {
                
            case KKTest_Function_Position_Calf:
            case KKTest_Function_Position_Ham:
                
                model.min = 0.0;
               
                model.AnalysisValue1 = 0.3;
                model.AnalysisValue2 = 0.5;
                model.AnalysisValue3 = 0.7;
                model.AnalysisValue4 = 0.9;
                model.AnalysisValue5 = 1.1;
                model.AnalysisValue6 = 0.3 + model.AnalysisValue5;
                model.max = model.AnalysisValue6;
                
                break;
                
            case KKTest_Function_Position_Arm:
                
                model.min = 0.0;
               
                model.AnalysisValue1 = 0.3;
                model.AnalysisValue2 = 0.4;
                model.AnalysisValue3 = 0.5;
                model.AnalysisValue4 = 0.6;
                model.AnalysisValue5 = 0.7;
                model.AnalysisValue6 = 0.3 + model.AnalysisValue5;
                model.max = model.AnalysisValue6;
                
                break;
                
            case KKTest_Function_Position_Waist:
                
                model.min = 0.1;
               
                model.AnalysisValue1 = 0.4;
                model.AnalysisValue2 = 0.7;
                model.AnalysisValue3 = 1.0;
                model.AnalysisValue4 = 1.3;
                model.AnalysisValue5 = 1.7;
                model.AnalysisValue6 = 0.3 + model.AnalysisValue5;
                model.max = model.AnalysisValue6;
                
                break;
                
            case KKTest_Function_Position_Belly:
                
                model.min = 0.1;
               
                model.AnalysisValue1 = 0.4;
                model.AnalysisValue2 = 0.7;
                model.AnalysisValue3 = 1.1;
                model.AnalysisValue4 = 1.4;
                model.AnalysisValue5 = 1.8;
                model.AnalysisValue6 = 0.3 + model.AnalysisValue5;
                model.max = model.AnalysisValue6;
                
                break;
                
            default:
                break;
        }
    }
    
    
    model.AnalysisText1 = KKLanguage(@"lab_function_result_1");
    model.AnalysisText2 = KKLanguage(@"lab_function_result_2");
    model.AnalysisText3 = KKLanguage(@"lab_function_result_3");
    model.AnalysisText4 = KKLanguage(@"lab_function_result_4");
    model.AnalysisText5 = KKLanguage(@"lab_function_result_5");
    model.AnalysisText6 = KKLanguage(@"lab_function_result_6");
    
    
    model.Analysiscolor1 = KKChartColor1;
    model.Analysiscolor2 = KKChartColor2;
    model.Analysiscolor3 = KKChartColor3;
    model.Analysiscolor4 = KKChartColor4;
    model.Analysiscolor5 = KKChartColor5;
    model.Analysiscolor6 = KKChartColor6;
    

    return model;
}



@end
