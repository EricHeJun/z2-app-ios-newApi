//
//  HJBLEChatView.h
//  fat
//
//  Created by 何军 on 2021/4/16.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import "HJBaseView.h"
#import "HJChartAnalysisModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJBLEChatView : HJBaseView

@property (strong,nonatomic)UIImageView * BLEImageView;
@property (strong,nonatomic)NSMutableArray *pointArr;
@property (assign,nonatomic)int bitmapHeight;
@property (strong,nonatomic)UIImage * oldImage;

@property (strong,nonatomic)UILabel * sexLab;
@property (strong,nonatomic)UIView * resultView;
@property (strong,nonatomic)UIView * analysisView;
@property (strong,nonatomic)UILabel * analysisLab;

@property (strong,nonatomic)UILabel * bottomLab;

@property (copy,nonatomic)NSString * sex;
@property (assign,nonatomic)KKTest_Function_Position type;


@property (strong,nonatomic)UILabel * valueLab;
@property (strong,nonatomic)UIImageView * valueImageView;

@property (strong,nonatomic)HJChartAnalysisModel *  analysisModel;

@property (assign,nonatomic)BOOL isMuscle;

@property (strong,nonatomic)UIView * lineView1;
@property (strong,nonatomic)UIView * lineView2;

@property (strong,nonatomic)UIBezierPath * path;
@property (strong,nonatomic)CAShapeLayer * shapeLine;

@property (strong,nonatomic)UILabel * muscleValueLab;
@property (assign,nonatomic)int depth_mm;

/*
 蜂窝动画
 */
@property (strong,nonatomic)UIBezierPath * fatPath;
@property (strong,nonatomic)CAShapeLayer * fatShapeLayer;
@property (strong,nonatomic)UIImageView * fatImageView;

@property (nonatomic,strong) void (^ selectBlock)(NSArray * pointArr);

@property (nonatomic,strong) void (^ muscleValueBlock)(float muscleValue);

- (instancetype)initWithFrame:(CGRect)frame withChatWidth:(float)chatWidth chatHeight:(float)chatHeight depth:(NSInteger)depth bitmapHight:(NSInteger)bitmapHight withocxo:(NSInteger)ocxo sex:(NSString*)sex type:(KKTest_Function_Position)type isMuscle:(BOOL)isMuscle;


/*
 浮动value
 */
- (void)drawValue:(HJChartAnalysisModel*)model;

/*
 绘制黄线
 */
- (void)drawPointLine:(NSArray*)pointArr bitmapHeight:(int)bitmapHeight;

/*
 绘制肌肉选择线
 */
- (void)drawMusclePointLine:(NSArray*)pointArr bitmapHeight:(int)bitmapHeight reallyValue:(NSString*)reallyValue;

/*
 移动线
 */
- (void)movePoint:(BOOL)move bitmapHeight:(int)bitmapHeight;

/*
 移除肌肉选择线
 */
- (void)removeMuscleLine;

/*
 脂肪动画
 */
- (void)fatAnimation;



@end

NS_ASSUME_NONNULL_END
