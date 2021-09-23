//
//  HJBLEChatView.m
//  fat
//
//  Created by 何军 on 2021/4/16.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import "HJBLEChatView.h"

@interface HJBLEChatView ()<UIGestureRecognizerDelegate>

@end

@implementation HJBLEChatView


- (instancetype)initWithFrame:(CGRect)frame withChatWidth:(float)chatWidth chatHeight:(float)chatHeight depth:(NSInteger)depth bitmapHight:(NSInteger)bitmapHight withocxo:(NSInteger)ocxo sex:(NSString*)sex type:(KKTest_Function_Position)type isMuscle:(BOOL)isMuscle{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.isMuscle = isMuscle;
        
        self.layer.cornerRadius = KKLayerCornerRadius*2;
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(KKSceneWidth/4, 0, KKSceneWidth/2, KKButtonHeight);
        
        [btn setImage:[UIImage imageNamed:@"img_btn_top_point"] forState:UIControlStateNormal];
        [btn setTitle:KKLanguage(@"lab_function_chat_title") forState:UIControlStateNormal];
        [btn setTitleColor:kkTextGrayColor forState:UIControlStateNormal];
        btn.titleLabel.font = kk_sizefont(KKFont_small_12);
        [self addSubview:btn];
    
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(btn.imageView.frame.size.height ,-btn.imageView.frame.size.width,-10,0)];
        //文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
        [btn setImageEdgeInsets:UIEdgeInsetsMake(-btn.imageView.frame.size.height-10, 0.0,0.0, -btn.titleLabel.bounds.size.width)];
        
        
        float imageViewheight = chatHeight;
        
        UIImageView * imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(kk_x(30), btn.frame.size.height, self.frame.size.width-kk_x(30)-kk_x(60), imageViewheight);
        [self addSubview:imageView];
        _BLEImageView = imageView;
        
        
        //创建手势识别器对象
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] init];
        //设置手势识别器对象的具体属性
        pan.delegate = self;
        //添加手势识别器到对应的view上
        [_BLEImageView addGestureRecognizer:pan];
        //监听手势的触发
        [pan addTarget:self action:@selector(panGestureRecognizer:)];
        
    
        [self drawDepth:depth bitmapHight:bitmapHight withocxo:ocxo];
        
        
        if (isMuscle == NO) {
            
            UILabel * titleLab = [[UILabel alloc] init];
            titleLab.frame = CGRectMake(0, _BLEImageView.frame.size.height+_BLEImageView.frame.origin.y, self.frame.size.width, KKButtonHeight);
            titleLab.textAlignment = NSTextAlignmentCenter;
            titleLab.font = kk_sizefont(KKFont_small_12);
            titleLab.textColor = kkTextGrayColor;
            [self addSubview:titleLab];
            _sexLab =  titleLab;
            
            
            _sex = sex;
            _type = type;
            
            [self addSubview:self.resultView];
            [self addSubview:self.analysisView];
            [self addSubview:self.bottomLab];
            
            [_resultView addSubview:self.valueLab];
            [_resultView addSubview:self.valueImageView];
            
        }else{
            
            _BLEImageView.userInteractionEnabled = YES;
            
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
            [_BLEImageView addGestureRecognizer:tap];
        }
    
    }
    return self;
}


- (UIView *)resultView{
    
    float y_offest = _sexLab.frame.size.height+_sexLab.frame.origin.y;
    
    if (!_resultView) {
        
        UIView * view = [[UIView alloc] init];
        view.frame = CGRectMake(_BLEImageView.frame.origin.x, y_offest, _BLEImageView.frame.size.width, 2*KKButtonHeight);
        _resultView  = view;
        
        HJChartAnalysisModel * model = [HJChartAnalysisModel chartAnalysisResultSex:_sex position:_type value:0];
        _analysisModel = model;
        
        float totalSpaceX = model.max - model.min;
        
        float width = 0.0;
        float offset_x = 0.0;
        
        for (int i = 0; i<6; i++) {
            
            UIView * lineView = [[UIView alloc] init];
            [view addSubview:lineView];
            
            UILabel * lab = [[UILabel alloc] init];
            lab.textAlignment = NSTextAlignmentCenter;
            lab.font = kk_sizefont(KKFont_small_middle);
            lab.adjustsFontSizeToFitWidth = YES;
            [view addSubview:lab];
            
            
            if (i==0) {
                
                lineView.backgroundColor = model.Analysiscolor1;
                lab.text = model.AnalysisText1;
                lab.textColor = model.Analysiscolor1;
                
                
                offset_x = offset_x+width;
                width = _BLEImageView.frame.size.width*(model.AnalysisValue1-model.min)/totalSpaceX-1;
                
                model.origin_x_1 = offset_x;
                model.width_1 = width;
               
                
            }else if (i==1){
                
                lineView.backgroundColor = model.Analysiscolor2;
                lab.text = model.AnalysisText2;
                lab.textColor = model.Analysiscolor2;
                
                offset_x = offset_x+width+1;
                width = _BLEImageView.frame.size.width*(model.AnalysisValue2-model.AnalysisValue1)/totalSpaceX-1;
                
                model.origin_x_2 = offset_x;
                model.width_2 = width;
                
            }else if (i==2){
                
                lineView.backgroundColor = model.Analysiscolor3;
                lab.text = model.AnalysisText3;
                lab.textColor = model.Analysiscolor3;
                
                offset_x = offset_x+width+1;
                width = _BLEImageView.frame.size.width*(model.AnalysisValue3-model.AnalysisValue2)/totalSpaceX-1;
                
                model.origin_x_3 = offset_x;
                model.width_3 = width;
                
            }else if (i==3){
                lineView.backgroundColor = model.Analysiscolor4;
                lab.text = model.AnalysisText4;
                lab.textColor = model.Analysiscolor4;
                
                offset_x = offset_x+width+1;
                width = _BLEImageView.frame.size.width*(model.AnalysisValue4-model.AnalysisValue3)/totalSpaceX-1;
                
                model.origin_x_4 = offset_x;
                model.width_4 = width;
                
            }else if (i==4){
                lineView.backgroundColor = model.Analysiscolor5;
                lab.text = model.AnalysisText5;
                lab.textColor = model.Analysiscolor5;
                
                offset_x = offset_x+width+1;
                width = _BLEImageView.frame.size.width*(model.AnalysisValue5-model.AnalysisValue4)/totalSpaceX-1;
                
                model.origin_x_5 = offset_x;
                model.width_5 = width;
                
            }else if (i==5){
                
                lineView.backgroundColor = model.Analysiscolor6;
                lab.text = model.AnalysisText6;
                lab.textColor = model.Analysiscolor6;
                
                offset_x = offset_x+width+1;
                width = _BLEImageView.frame.size.width*(model.AnalysisValue6-model.AnalysisValue5)/totalSpaceX;
                
                model.origin_x_6 = offset_x;
                model.width_6 = width;
                
            }
            
            lineView.frame = CGRectMake(offset_x,KKButtonHeight, width, kk_y(30));
            lab.frame = CGRectMake(lineView.frame.origin.x, lineView.frame.size.height+lineView.frame.origin.y, lineView.frame.size.width, lineView.frame.size.height);
            
        }
        
    }
    
    return _resultView;
}
- (UILabel *)valueLab{
    
    if (!_valueLab) {
        
        UILabel * lab = [[UILabel alloc] init];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = kk_sizefont(KKFont_small_middle);
        
        _valueLab = lab;
    }
    return _valueLab;
}

- (UIImageView *)valueImageView{
    
    if (!_valueImageView) {
        
        UIImageView * imageView = [[UIImageView alloc] init];
        _valueImageView = imageView;
        
    }
    return _valueImageView;
}

- (UIView *)analysisView{
    
    if (!_analysisView) {
        
        UIView * view = [[UIView alloc] init];
        view.frame  = CGRectMake(_resultView.frame.origin.x, _resultView.frame.size.height+_resultView.frame.origin.y, _resultView.frame.size.width, KKButtonHeight+kk_y(40));
        _analysisView = view;
        
        UILabel * lab = [[UILabel alloc] init];
        lab.frame = CGRectMake(0, 0, view.frame.size.width, KKButtonHeight);
        lab.backgroundColor = kkWhiteColor;
        lab.font = kk_sizefont(KKFont_small_11);
        lab.textColor = kkTextGrayColor;
        lab.numberOfLines = 0;
        [view addSubview:lab];
        _analysisLab = lab;
        
        
        lab = [[UILabel alloc] init];
        lab.frame = CGRectMake(_analysisLab.frame.origin.x, _analysisLab.frame.size.height+_analysisLab.frame.origin.y, _analysisLab.frame.size.width, kk_y(40));
        lab.text = KKLanguage(@"lab_function_analysis");
        lab.textAlignment = NSTextAlignmentRight;
        lab.font = kk_sizefont(KKFont_small_11);
        lab.textColor = kkTextGrayColor;
        [view addSubview:lab];
        
    }
    return _analysisView;
}

- (UILabel *)bottomLab{
    
    if (!_bottomLab) {
        
        _bottomLab = [[UILabel alloc] init];
        _bottomLab.frame = CGRectMake(0, self.frame.size.height - kk_y(40) - KKButtomSpace, self.frame.size.width, kk_y(40));
        _bottomLab.text = KKLanguage(@"lab_function_test_again");
        _bottomLab.backgroundColor = KKBgYellowColor;
        _bottomLab.textAlignment = NSTextAlignmentCenter;
        _bottomLab.font = kk_sizefont(KKFont_small_11);
        _bottomLab.textColor = kkWhiteColor;
    }
    return _bottomLab;
}

- (void)drawValue:(HJChartAnalysisModel *)model{
    
    if (model == nil) {
        
        self.valueLab.hidden = self.valueImageView.hidden = YES;
        
        return;
        
    }else{
        
        self.valueLab.hidden = self.valueImageView.hidden = NO;
    }
    
    self.valueLab.text = model.resultValue;
    self.valueImageView.image = model.resultImage;
    
    float image_x = 0;
    
    BOOL isBetween = NO;
    
    float minSpace = 0.11;
    
    if ([model.recordValue floatValue]<=_analysisModel.AnalysisValue1) {
        
        float space =[model.recordValue floatValue] - _analysisModel.min;
        
        if (space<0) {
            space = 0;
        }
    
        float totalSpace = _analysisModel.AnalysisValue1 -_analysisModel.min;
        
        image_x = space * _analysisModel.width_1/totalSpace  + _analysisModel.origin_x_1;
        
        model.resultColor = _analysisModel.Analysiscolor1;
        
        
    }else if ([model.recordValue floatValue]<=_analysisModel.AnalysisValue2) {
        
        
        float space =[model.recordValue floatValue] - _analysisModel.AnalysisValue1;
        
        float totalSpace = _analysisModel.AnalysisValue2 -_analysisModel.AnalysisValue1;
        
        image_x = space * _analysisModel.width_2/totalSpace + _analysisModel.origin_x_2;
        
        model.resultColor = _analysisModel.Analysiscolor2;
        
        
        if (totalSpace<minSpace) {
            image_x = space * _analysisModel.width_2/totalSpace/2 + _analysisModel.origin_x_2;
            isBetween = YES;
        }
        
    }else if ([model.recordValue floatValue]<=_analysisModel.AnalysisValue3) {
        
        float space =[model.recordValue floatValue] - _analysisModel.AnalysisValue2;
        
        float totalSpace = _analysisModel.AnalysisValue3 -_analysisModel.AnalysisValue2;
        
        image_x = space * _analysisModel.width_3/totalSpace + _analysisModel.origin_x_3;
        
        model.resultColor = _analysisModel.Analysiscolor3;
        
        
        if (totalSpace<minSpace) {
            image_x = space * _analysisModel.width_3/totalSpace/2 + _analysisModel.origin_x_3;
            isBetween = YES;
        }
        
    }else if ([model.recordValue floatValue]<=_analysisModel.AnalysisValue4) {
        
        float space =[model.recordValue floatValue] - _analysisModel.AnalysisValue3;
        
        float totalSpace = _analysisModel.AnalysisValue4 -_analysisModel.AnalysisValue3;
        
        image_x = space * _analysisModel.width_4/totalSpace + _analysisModel.origin_x_4;
        
        model.resultColor = _analysisModel.Analysiscolor4;
        
        if (totalSpace<minSpace) {
            image_x = space * _analysisModel.width_4/totalSpace/2 + _analysisModel.origin_x_4;
            isBetween = YES;
        }
        
    }else if ([model.recordValue floatValue]<=_analysisModel.AnalysisValue5) {
        
        
        float space =[model.recordValue floatValue] - _analysisModel.AnalysisValue4;
        
        float totalSpace = _analysisModel.AnalysisValue5 -_analysisModel.AnalysisValue4;
        
        image_x = space * _analysisModel.width_5/totalSpace + _analysisModel.origin_x_5;
        
        model.resultColor = _analysisModel.Analysiscolor5;
        
        if (totalSpace<minSpace) {
            image_x = space * _analysisModel.width_5/totalSpace/2 + _analysisModel.origin_x_5;
            isBetween = YES;
        }
        
        
    }else{
        
        float space =[model.recordValue floatValue] - _analysisModel.AnalysisValue5;
        
        float totalSpace = _analysisModel.AnalysisValue6 -_analysisModel.AnalysisValue5;
        
        if (space>totalSpace) {
            space = totalSpace;
        }
        
        image_x = space * _analysisModel.width_6/totalSpace + _analysisModel.origin_x_6;
        model.resultColor = _analysisModel.Analysiscolor6;
    
    }
    
    float valueImageView_x = image_x - model.resultImage.size.width/2;
    
    if (isBetween == NO) {
        valueImageView_x = valueImageView_x - kk_x(10);
    }
    
    if (valueImageView_x<_analysisModel.origin_x_1) {
        valueImageView_x = _analysisModel.origin_x_1;
    }

    self.valueImageView.frame = CGRectMake(valueImageView_x, KKButtonHeight-model.resultImage.size.height, model.resultImage.size.width, model.resultImage.size.height);
    
    
    self.valueLab.frame = CGRectMake(self.valueImageView.center.x - kk_x(120)/2, self.valueImageView.frame.origin.y - kk_y(30), kk_x(120), kk_y(30));
    self.valueLab.textColor = model.resultColor;
    
}



/*
 根据参数动态绘图
 */
- (void)drawDepth:(NSInteger)depth bitmapHight:(NSInteger)bitmapHight withocxo:(NSInteger)ocxo{
    
    //绘制标尺
    int  interval = 10;
    
    /*
     毫米单位
     */
    int  depthMM  = [[HJCommon shareInstance] getBLEDepth_cm_new:depth bitmapHight:bitmapHight withOcxo:ocxo];
    self.depth_mm = depthMM;
    
    int totalLineCount = depthMM;

    float  spaceHeight =  self.BLEImageView.frame.size.height/totalLineCount;
    
    if (totalLineCount == 0) {
        return;
    }
  
    
    for (int i = 0; i<=totalLineCount; i++) {
        
        if (i%2 == 0) {
            
            UIView * lineView = [[UIView alloc] init];
            lineView.frame = CGRectMake(self.BLEImageView.frame.size.width+self.BLEImageView.frame.origin.x, self.BLEImageView.frame.origin.y + i*spaceHeight, kk_x(10), 1);
            
            lineView.backgroundColor = kkTextGrayColor;
            
            [self addSubview:lineView];
            
            if (i%interval==0) {
                
                float unitValue = [[[HJCommon shareInstance] getCurrectUnitValue:i*1.0] floatValue];
                
                
                lineView.frame = CGRectMake(self.BLEImageView.frame.size.width+self.BLEImageView.frame.origin.x, self.BLEImageView.frame.origin.y + i*spaceHeight, kk_x(20), 1);
                
                UILabel * lab = [[UILabel alloc] init];
                lab.frame = CGRectMake(lineView.frame.size.width+lineView.frame.origin.x, lineView.frame.origin.y - kk_y(10), kk_x(40), kk_y(20));
                lab.text = [NSString stringWithFormat:@"%.1f",unitValue/interval*1.0];
                lab.font = kk_sizefont(KKFont_small_middle_9);
                lab.textColor = kkTextGrayColor;
                lab.textAlignment = NSTextAlignmentCenter;
                
                [self addSubview:lab];
                
            }
        }
    }
}

/*
 绘制线
 */
- (void)drawPointLine:(NSArray*)pointArr bitmapHeight:(int)bitmapHeight{
    
    NSMutableArray * pointNewArr = [NSMutableArray arrayWithArray:pointArr];
    
    /*
     去除 0,0 这种数据点
     */
    [pointNewArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGPoint point = [obj CGPointValue];
        
        if (point.x == 0 && point.y == 0) {
            [pointNewArr removeObject:obj];
        }
    }];
    
    self.pointArr = pointNewArr;
    
    
    UIGraphicsBeginImageContextWithOptions(self.BLEImageView.frame.size,NO,
                                           [UIScreen mainScreen].scale);
    
    [self.oldImage drawInRect:CGRectMake(0, 0, self.BLEImageView.frame.size.width, self.BLEImageView.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);  //边缘样式
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 3.0);  //线宽
    CGContextSetAllowsAntialiasing(UIGraphicsGetCurrentContext(), YES);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 249/255., 242/255., 47/255., 1.0);  //颜色
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    
    
    float x_space = self.BLEImageView.frame.size.width/pointArr.count;
    
   
    float last_x = 0.0;
    float last_y = 0.0;
    
    for (int i =0; i<pointNewArr.count; i++) {
    
        CGPoint point = [pointNewArr[i] CGPointValue];
        
        float value_y = point.y*self.BLEImageView.frame.size.height/bitmapHeight;
        
        if (value_y<0) {
            value_y = 0;
        }
        
        CGPoint pointNew = CGPointMake(i*x_space, value_y);
        
        /*
         最后一项时
         */
        if (i == pointNewArr.count - 1) {
            last_x = self.BLEImageView.frame.size.width;
            last_y = pointNew.y;
        }
        
        if (i == 0) {
            
            CGContextMoveToPoint(UIGraphicsGetCurrentContext(), pointNew.x, pointNew.y);  //起点坐标
            
        }else{
            
            if (point.x == 0) {
                continue;
            }
            
            CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), pointNew.x, pointNew.y);  //其他点坐标
        }
    }
    
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), last_x, last_y);   //终点坐标
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.BLEImageView.image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    [self setFillet];
}

/*
 绘制脂肪的动图
 */
- (void)setFillet{
    
    
    float x_space = self.BLEImageView.frame.size.width/self.pointArr.count;
    
    /*
     去除所有点
     */
    [self.fatPath removeAllPoints];
    
    [self.fatPath moveToPoint:CGPointMake(0, 0)];
    
    for (int i =0; i<self.pointArr.count; i++) {
    
        CGPoint point = [self.pointArr[i] CGPointValue];
        
        float value_y = point.y*self.BLEImageView.frame.size.height/self.bitmapHeight;
        
        if (value_y<0) {
            value_y = 0;
        }
        
        CGPoint pointNew = CGPointMake(i*x_space, value_y);
        
        [self.fatPath addLineToPoint:pointNew];
    
        if(i == self.pointArr.count-1){
            
            [self.fatPath addLineToPoint:CGPointMake(self.BLEImageView.frame.size.width, pointNew.y)];
            
            [self.fatPath addLineToPoint:CGPointMake(self.BLEImageView.frame.size.width, 0)];
        }

    }
    
    [self.fatPath stroke];

    self.fatShapeLayer.path = _fatPath.CGPath;
    
    self.fatImageView.layer.mask = _fatShapeLayer;
  
}


/*
 绘制肌肉选择线
 */
- (void)drawMusclePointLine:(NSArray*)pointArr bitmapHeight:(int)bitmapHeight reallyValue:(NSString*)reallyValue{
    
    self.BLEImageView.userInteractionEnabled = NO;
    
    CGPoint point = [[pointArr firstObject] CGPointValue];
    
    [self.BLEImageView addSubview:self.lineView1];
    [self.BLEImageView addSubview:self.lineView2];
    
    
    float y1 = point.x*self.BLEImageView.frame.size.height/bitmapHeight;
    float y2 = point.y*self.BLEImageView.frame.size.height/bitmapHeight;
    
    
    self.lineView1.frame = CGRectMake(0, y1, self.lineView1.frame.size.width, self.lineView1.frame.size.height);
    self.lineView2.frame = CGRectMake(0, y2, self.lineView2.frame.size.width, self.lineView2.frame.size.height);
    
    
    [self drawxuxian];
    
    /*
     重新赋值
     */
    
    NSString *  valueString = [[HJCommon shareInstance] getCurrectUnitValue:[reallyValue floatValue]/10];
    
    NSString * unit=[[HJCommon shareInstance] getBLEUnit];
    
    _muscleValueLab.text = [NSString stringWithFormat:@"%@ %@",valueString,unit];
    
}


#pragma mark ============== 拖动手势 ===============
-(void)panGestureRecognizer:(UIPanGestureRecognizer *)recognizer{
    
    /*
     获取手势坐标
     */
    CGPoint location = [recognizer locationInView:_BLEImageView];
    
    /*
     限制范围
     */
    if (location.x<0 || location.x>_BLEImageView.frame.size.width || location.y<0 || location.y>_BLEImageView.frame.size.height) {
        return;
    }
    
    if (self.isMuscle) {
        
        if (_lineView1 == nil) {
            return;
        }
        
        if(fabs(location.y-self.lineView1.frame.origin.y)>fabs(location.y-self.lineView2.frame.origin.y)) {
            
            self.lineView2.frame = CGRectMake(0, location.y, self.lineView2.frame.size.width, self.lineView2.frame.size.height);
            
        }else{
            
            self.lineView1.frame = CGRectMake(0, location.y, self.lineView1.frame.size.width, self.lineView1.frame.size.height);
            
        }


        [self.path removeAllPoints];
   
        [self.path moveToPoint:CGPointMake(_lineView1.center.x, _lineView1.center.y)];
        [self.path addLineToPoint:CGPointMake(_lineView2.center.x, _lineView2.center.y)];
        
        self.shapeLine.path = self.path.CGPath;
        
        [self refreshMuscleValue];
        
        return;
    }
    
    /*
     限制移动的 幅度 大小
     */
    
    if (recognizer.state == UIGestureRecognizerStateChanged ) {
        
        float x_space = pxWidth/self.pointArr.count;
        
        float realy_x = pxWidth*location.x/_BLEImageView.frame.size.width;
        float realy_y = location.y*_bitmapHeight/self.BLEImageView.frame.size.height;
        
        int index = realy_x/x_space;
        float index_space =index - index*x_space;
        
        if (index_space>x_space/2) {
            index = index + 1;
        }
        
        if (index>self.pointArr.count-1) {
            index = (int)self.pointArr.count -1;
        }
        
        CGPoint point  = CGPointMake(realy_x, realy_y);
        
        [self.pointArr replaceObjectAtIndex:index withObject:[NSValue valueWithCGPoint:point]];
    
        //对数组进行从小到大排序
        NSArray * resultArr = [self.pointArr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
           
            CGPoint point1 = [obj1 CGPointValue];
            CGPoint point2 = [obj2 CGPointValue];
        
            return [@(point1.x) compare:@(point2.x)];
        }];

        [self drawPointLine:resultArr bitmapHeight:self.bitmapHeight];
        
        if (self.selectBlock) {
            self.selectBlock(resultArr);
        }
    }
}


#pragma mark ============== 点击手势 ===============
- (void)tap:(UITapGestureRecognizer *)recognizer{
    
    /*
     获取手势坐标
     */
    CGPoint location = [recognizer locationInView:_BLEImageView];
    
    if (_lineView1) {
        return;
    }
    
    [self drawMuscleLine:location.y];
    
}

- (void)drawMuscleLine:(float)y{
    
    [self.BLEImageView addSubview:self.lineView1];
    [self.BLEImageView addSubview:self.lineView2];
    
    self.lineView1.frame = CGRectMake(0, 50, self.lineView1.frame.size.width, self.lineView1.frame.size.height);
    self.lineView2.frame = CGRectMake(0, 100, self.lineView2.frame.size.width, self.lineView2.frame.size.height);
    
    [self drawxuxian];
    
}


- (UIView *)lineView1{
    
    if (!_lineView1) {
        UIView * view = [[UIView alloc] init];
        view.frame = CGRectMake(0, 0, self.BLEImageView.frame.size.width, 2);
        view.backgroundColor = KKLineColor;
        _lineView1 = view;
    
    }
    return _lineView1;
}

- (UIView *)lineView2{
    if (!_lineView2) {
        UIView * view = [[UIView alloc] init];
        view.frame = CGRectMake(0, 0, self.BLEImageView.frame.size.width, 2);
        view.backgroundColor = KKLineColor;
        _lineView2 = view;
        
    }
    return _lineView2;
}
- (UIBezierPath *)path{
    if (!_path) {
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        _path = path;
    }
    return _path;
}

- (CAShapeLayer *)shapeLine{
    
    if (!_shapeLine) {
        
        _shapeLine = [CAShapeLayer layer];
        _shapeLine.frame = CGRectMake(0, 0, 10, 0.5);
        _shapeLine.lineJoin = kCALineJoinRound;
        _shapeLine.lineDashPattern = @[@(3),@(3)];
        _shapeLine.fillColor = [UIColor clearColor].CGColor;
        _shapeLine.strokeColor = KKLineColor.CGColor;
    }
    
    return _shapeLine;
}

- (UILabel *)muscleValueLab{
    
    if (!_muscleValueLab) {
        
        UILabel * titleLab = [[UILabel alloc] init];
        titleLab.frame = CGRectMake(0, 0, kk_x(100), kk_y(60));
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.font = kk_sizefont(KKFont_small_11);
        titleLab.textColor = KKLineColor;
        _muscleValueLab = titleLab;
    }
    

    return _muscleValueLab;
}

- (UIBezierPath *)fatPath{
    
    if (!_fatPath) {
        UIBezierPath *path = [UIBezierPath bezierPath];
        _fatPath = path;
    }
    return _fatPath;
}

- (CAShapeLayer *)fatShapeLayer{
    
    if (!_fatShapeLayer) {
        
        CAShapeLayer *shapelayer = [CAShapeLayer layer];
        _fatShapeLayer = shapelayer;
    }
    
    return _fatShapeLayer;
}

- (UIImageView *)fatImageView{
    
    if (!_fatImageView) {
        
        UIImageView *imageView = [[UIImageView alloc]init];
        UIImage * image = [UIImage imageNamed:@"img_bg_fat_test"];
    
        imageView.backgroundColor = [UIColor colorWithPatternImage:image];
        
        imageView.frame =CGRectMake(0, 0, self.BLEImageView.frame.size.width, self.BLEImageView.frame.size.height);
        
        _fatImageView = imageView;
        
    }
    
    
    return _fatImageView;
}


- (void)drawxuxian{
    
    [self.path moveToPoint:CGPointMake(_lineView1.center.x, _lineView1.center.y)];
    [self.path addLineToPoint:CGPointMake(_lineView2.center.x, _lineView2.center.y)];
    
    self.shapeLine.path = self.path.CGPath;
    [self.BLEImageView.layer addSublayer:_shapeLine];
    
    [self.BLEImageView addSubview:self.muscleValueLab];
    
    [self refreshMuscleValue];
}


- (void)refreshMuscleValue{
    
    float y = 0;
    if (_lineView1.frame.origin.y<_lineView2.frame.origin.y) {
        
        y = _lineView1.frame.origin.y + (_lineView2.frame.origin.y - _lineView1.frame.origin.y)/2;
        
    }else{
        
        y = _lineView2.frame.origin.y + (_lineView1.frame.origin.y - _lineView2.frame.origin.y)/2;
        
    }
    
    _muscleValueLab.center = CGPointMake(_lineView1.center.x + kk_x(60), y);
    
    /*
     像素差值
     */
   float value =fabs(_lineView1.frame.origin.y - _lineView2.frame.origin.y);
    
    /*
     获取真实毫米单位
     */
    float reallyValue = value * self.depth_mm/self.BLEImageView.frame.size.height;
    
    NSString *  valueString = [[HJCommon shareInstance] getCurrectUnitValue:reallyValue/10];
    
    NSString * unit=[[HJCommon shareInstance] getBLEUnit];
    
    _muscleValueLab.text = [NSString stringWithFormat:@"%@ %@",valueString,unit];
    
    
    if (self.muscleValueBlock) {
        self.muscleValueBlock(reallyValue/10);
    }
    
}



/*
 移动线
 */
- (void)movePoint:(BOOL)move bitmapHeight:(int)bitmapHeight{
    
    self.BLEImageView.userInteractionEnabled = move;
    self.bitmapHeight = bitmapHeight;

}

/*
 移除肌肉选择线
 */
- (void)removeMuscleLine{
    
    [self.path removeAllPoints];
    self.shapeLine.path = self.path.CGPath;
    
    [self.lineView1 removeFromSuperview];
    [self.lineView2 removeFromSuperview];
    [self.muscleValueLab removeFromSuperview];
    
    self.lineView1 = self.lineView2 = self.muscleValueLab = nil;
    
}

/*
 脂肪动画
 */
- (void)fatAnimation{
    

    [self.BLEImageView addSubview:self.fatImageView];
    self.fatImageView.alpha = 0;
    
    [UIView animateWithDuration:1 animations:^{
        
        self.fatImageView.alpha = 1;

    } completion:^(BOOL finished) {

        [UIView animateWithDuration:1 animations:^{

            self.fatImageView.alpha = 0;

        } completion:^(BOOL finished) {

            [UIView animateWithDuration:1 animations:^{

                self.fatImageView.alpha = 1;

            } completion:^(BOOL finished) {

                [UIView animateWithDuration:1 animations:^{

                    self.fatImageView.alpha = 0;

                } completion:^(BOOL finished) {

                    [self.fatImageView removeFromSuperview];

                }];

            }];


        }];

    }];
    

}

@end
