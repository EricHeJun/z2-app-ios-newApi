//
//  HJChartAnalysisModel.h
//  fat
//
//  Created by 何军 on 2021/5/28.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import "HJBaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJChartAnalysisModel : HJBaseObject

@property (assign,nonatomic)float min;
@property (assign,nonatomic)float max;

@property (copy,nonatomic)NSString * recordValue;  //原始值 用来计算坐标
@property (copy,nonatomic)NSString * resultValue;  //转换单位后的值 用来显示
@property (copy,nonatomic)NSString * resultString;
@property (copy,nonatomic)NSString * resultAnalysisString;
@property (strong,nonatomic)UIImage * resultImage;
@property (strong,nonatomic)UIColor * resultColor;

@property (assign,nonatomic)float AnalysisValue1;
@property (assign,nonatomic)float AnalysisValue2;
@property (assign,nonatomic)float AnalysisValue3;
@property (assign,nonatomic)float AnalysisValue4;
@property (assign,nonatomic)float AnalysisValue5;
@property (assign,nonatomic)float AnalysisValue6;

@property (strong,nonatomic)UIColor * Analysiscolor1;
@property (strong,nonatomic)UIColor * Analysiscolor2;
@property (strong,nonatomic)UIColor * Analysiscolor3;
@property (strong,nonatomic)UIColor * Analysiscolor4;
@property (strong,nonatomic)UIColor * Analysiscolor5;
@property (strong,nonatomic)UIColor * Analysiscolor6;

@property (copy,nonatomic)NSString* AnalysisText1;
@property (copy,nonatomic)NSString* AnalysisText2;
@property (copy,nonatomic)NSString* AnalysisText3;
@property (copy,nonatomic)NSString* AnalysisText4;
@property (copy,nonatomic)NSString* AnalysisText5;
@property (copy,nonatomic)NSString* AnalysisText6;



@property (assign,nonatomic)float origin_x_1;
@property (assign,nonatomic)float origin_x_2;
@property (assign,nonatomic)float origin_x_3;
@property (assign,nonatomic)float origin_x_4;
@property (assign,nonatomic)float origin_x_5;
@property (assign,nonatomic)float origin_x_6;

@property (assign,nonatomic)float width_1;
@property (assign,nonatomic)float width_2;
@property (assign,nonatomic)float width_3;
@property (assign,nonatomic)float width_4;
@property (assign,nonatomic)float width_5;
@property (assign,nonatomic)float width_6;



+ (HJChartAnalysisModel*)chartAnalysisSex:(NSString*)sex position:(KKTest_Function_Position)position value:(float)value;


+ (HJChartAnalysisModel*)chartAnalysisResultSex:(NSString*)sex position:(KKTest_Function_Position)position value:(float)value;

@end

NS_ASSUME_NONNULL_END
