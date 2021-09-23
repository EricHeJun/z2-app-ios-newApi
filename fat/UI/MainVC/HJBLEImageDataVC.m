//
//  HJBLEImageDataVC.m
//  fat
//
//  Created by 何军 on 2021/4/15.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import "HJBLEImageDataVC.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDKUI.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareSheetConfiguration.h>
#import "HJBLEImageDataVC+Func.h"

@interface HJBLEImageDataVC ()

@end

@implementation HJBLEImageDataVC


- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self stopTimer];
    /*
     不熄屏
     */
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    /*
     不熄屏
     */
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addNavBackgroundColor:self.view.backgroundColor];
    
    [self initData];
    
    [self initUI];
    
    if ([HJCommon shareInstance].isTest) {
        
        [self getBLEDataTwo];
        self.changeBtn.selected = YES;
        
    }else{
         
        [self getBLEData];
        self.changeBtn.selected = NO;
    }
    
    [self refreshUI];
    

    /*
     添加肌肉覆盖视图
     */
    [self addMuscleView];
    
    /*
     添加引导页
     */
    [self addGuideView:NO];
    
    [self.view bringSubviewToFront:self.guideView];
}

- (void)initData{
    
    self.arrGetCount = 0;
    
    _imageViewwidth = KKSceneWidth*0.8;
    _imageViewheight = _imageViewwidth*3/4;
   

    self.BLEDataArr = [NSMutableArray array];
    
    self.pxArr = [NSMutableArray array];
    
    self.pxBlackArr = [NSMutableArray array];
    
    for (int i = 0; i<pxWidth; i++) {
        
        Byte byte[pxHeight] = {0x00};
        
        [self.pxArr addObject:[NSData dataWithBytes:byte length:sizeof(byte)]];
        
        [self.pxBlackArr addObject:[NSData dataWithBytes:byte length:sizeof(byte)]];
    }
}
#pragma mark ============== 定时器 ===============
/*
 开启
 */
- (void)startTimer{
    
    SW(sw);
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    if (_timer == nil) {
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_resume(_timer);
    }
        
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),KKRefreshTime*NSEC_PER_MSEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (sw.BLEDataArr.count == 0) {
                [sw.pxArr addObject:[sw.pxArr lastObject]];
                sw.endCount = sw.endCount + 1;
            }else{
                [sw.pxArr addObject:[sw.BLEDataArr firstObject]];
                sw.endCount = 0;
            }
            
            /*
             成功出图后,不执行
             */
            if (sw.isImageSuccess) {
                return;
            }
            
            /*
             定时器结束后不执行
             */
            if (sw.isAcceptNewData == NO) {
                return;
            }
            
            
            UIImage * image  = [sw imageFromBRGABytesImage];
            sw.chatView.BLEImageView.image = image;
            
            if (sw.BLEDataArr.count>0) {
                [sw.BLEDataArr removeObjectAtIndex:0];
            }
            
            if (sw.pxArr.count>0) {
                [sw.pxArr removeObjectAtIndex:0];
            }
            
            NSLog(@"sw.endCount:%ld",(long)sw.endCount);
            
            if (sw.endCount>=KKEndCount) {
                [sw stopTimer];
            }
            
        });
        
    });
}
/*
 关闭
 */
- (void)stopTimer{
    
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
    
    DLog(@"stopTimer");
    self.isAcceptNewData = NO;
    [self refreshUI];
    
    /*
     重置绘图数据
     */
    [self.pxArr removeAllObjects];
    [self.pxArr addObjectsFromArray:self.pxBlackArr];
    
}





#pragma mark ============== UI ===============
- (void)initUI{

    // 添加返回按键
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(kk_x(20),KKStatusBarHeight, kk_x(88), kk_x(88));
    [btn setImage:[UIImage imageNamed:@"common_bg_cancel"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = KKButton_Cancel;
    [self.view addSubview:btn];
    
    
    UIImage * image = [UIImage imageNamed:@"img_common_help"];
    
    float width_x = KKSceneWidth-image.size.width-kk_x(30);
    
    if ([[HJCommon shareInstance] getTestFunction] == KKTest_Function_Muscle) {
        //帮助按钮
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(width_x,KKStatusBarHeight+(44/2-image.size.height/2), image.size.width, image.size.height);
        [btn setImage:image forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = KKButton_Help;
        btn.adjustsImageWhenHighlighted = NO;
        [self.view addSubview:btn];
        
        width_x = btn.frame.origin.x-(image.size.width+kk_x(30));
    }
    
    image = [UIImage imageNamed:@"img_common_share_yellow"];
    
    //分享按钮
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(width_x,KKStatusBarHeight+(44/2-image.size.height/2), image.size.width, image.size.height);
    [btn setImage:image forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = KKButton_Share;
    btn.adjustsImageWhenHighlighted = NO;
    [self.view addSubview:btn];
    

    
    width_x = btn.frame.origin.x-(image.size.width+kk_x(30));
    
    //测量位置
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(width_x,KKStatusBarHeight+(44/2-image.size.height/2), image.size.width, image.size.height);
    btn.adjustsImageWhenHighlighted = NO;
    [self.view addSubview:btn];
    
    /*
     测试功能
     */
    [self.view addSubview:self.changeBtn];
    
    
    HJPositionModel * model = [[HJCommon shareInstance] currectPositionToString];
    [btn setImage:[UIImage imageNamed:model.circleImageNor_s] forState:UIControlStateNormal];


    UILabel * titleLab = [[UILabel alloc] init];
    titleLab.frame = CGRectMake(0, KKNavBarHeight+KKButtonHeight/2, KKSceneWidth, KKButtonHeight);
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = kk_sizefont(KKFont_Normal);
    titleLab.textColor = kkTextBlackColor;
    [self.view addSubview:titleLab];
    _testTopLab = titleLab;
    
    
    
    image = [UIImage imageNamed:@"img_bg_test_center"];
    UIImageView * bgCenter = [[UIImageView alloc] init];
    bgCenter.frame = CGRectMake(KKSceneWidth/2-image.size.width/2, _testTopLab.frame.size.height+_testTopLab.frame.origin.y, image.size.width, image.size.height);
    bgCenter.image = image;
    [self.view addSubview:bgCenter];
    
    
    UILabel * lab = [[UILabel alloc] init];
    lab.frame = CGRectMake(KKSceneWidth/4, bgCenter.center.y - (KKButtonHeight+kk_y(20))/2, KKSceneWidth/2, KKButtonHeight+kk_y(20));
    lab.textAlignment = NSTextAlignmentCenter;
    lab.numberOfLines = 0;
    [self.view addSubview:lab];
    _testValueLab = lab;
    
    
    
    titleLab = [[UILabel alloc] init];
    titleLab.frame = CGRectMake(_testValueLab.frame.origin.x, _testValueLab.frame.size.height+_testValueLab.frame.origin.y, _testValueLab.frame.size.width, kk_y(40));
    titleLab.text = KKLanguage(@"lab_function_test_avg");
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = kk_sizefont(KKFont_small_11);
    titleLab.textColor = kkTextGrayColor;
    [self.view addSubview:titleLab];
    _testAvgLab = titleLab;
    
    
    titleLab = [[UILabel alloc] init];
    titleLab.frame = CGRectMake(_testAvgLab.frame.origin.x + _testAvgLab.frame.size.width/2 - kk_x(100)/2, _testAvgLab.frame.size.height+_testAvgLab.frame.origin.y+kk_y(10), kk_x(100), kk_y(30));
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = _testAvgLab.font;
    titleLab.textColor = kkWhiteColor;
    titleLab.layer.cornerRadius = titleLab.frame.size.height/2;
    titleLab.layer.masksToBounds = YES;
    [self.view addSubview:titleLab];
    _testResultLab = titleLab;
    
    
    titleLab = [[UILabel alloc] init];
    titleLab.frame = CGRectMake(0, bgCenter.frame.size.height+bgCenter.frame.origin.y, KKSceneWidth/2, KKButtonHeight);
    titleLab.text = KKLanguage(@"lab_function_test_max");
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = kk_sizefont(KKFont_Normal);
    titleLab.textColor = kkTextGrayColor;
    [self.view addSubview:titleLab];
    _testMaxLab = titleLab;
    
    
    titleLab = [[UILabel alloc] init];
    titleLab.frame = CGRectMake(KKSceneWidth/2, _testMaxLab.frame.origin.y, _testMaxLab.frame.size.width, _testMaxLab.frame.size.height);
    titleLab.text = KKLanguage(@"lab_function_test_min");
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = kk_sizefont(KKFont_Normal);
    titleLab.textColor = kkTextGrayColor;
    [self.view addSubview:titleLab];
    _testMinLab = titleLab;
    
    
    [self.view addSubview:self.chatView];
    
}

- (HJBLEChatView *)chatView{
    
    if (!_chatView) {
        
        HJPositionModel * model = [[HJCommon shareInstance] currectPositionToString];
        
        BOOL isMuscle = NO;
        
        if ([[HJCommon shareInstance] getTestFunction] == KKTest_Function_Muscle) {
            isMuscle = YES;
        }
        
        
        _chatView = [[HJBLEChatView alloc] initWithFrame:CGRectMake(0, KKSceneHeight - (KKButtonHeight*2+_imageViewheight), KKSceneWidth, (KKButtonHeight*2+_imageViewheight)*2) withChatWidth:_imageViewwidth chatHeight:_imageViewheight depth:[[HJCommon shareInstance] getBLEDepth] bitmapHight:pxHeight withocxo:OCXO sex:[HJCommon shareInstance].selectModel.sex type:model.positionValue isMuscle:isMuscle];
        _chatView.backgroundColor = kkBgGrayColor;
        
        
        if (isMuscle == NO) {
            
            UIPanGestureRecognizer * movepan=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
            [_chatView addGestureRecognizer:movepan];
            
        }
    }
    
    SW(sw)
    
    _chatView.muscleValueBlock = ^(float muscleValue) {
        
        self->_avgHeight = muscleValue;
        
        sw.isImageSuccess = YES;
        
        [sw refreshUI];
        
    };
    
    return _chatView;
}

- (UIButton *)changeBtn{
    
    if (!_changeBtn) {
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(KKSceneWidth/2 - kk_x(300)/2, KKNavBarHeight, kk_x(300), KKButtonHeight/2);
        [btn setTitle:KKLanguage(@"当前为非补点方案") forState:UIControlStateSelected];
        [btn setTitle:KKLanguage(@"当前为补点方案") forState:UIControlStateNormal];
        [btn setTitleColor:kkTextBlackColor forState:UIControlStateNormal];
        btn.titleLabel.font = kk_sizefont(KKFont_small_large);
        btn.backgroundColor = KKBgYellowColor;
        [btn addTarget:self action:@selector(changeBtn:) forControlEvents:UIControlEventTouchUpInside];
        _changeBtn = btn;

    }
    
    return _changeBtn;
}
- (HJMuscleGuideView *)guideView{
    
    if (!_guideView) {
        HJMuscleGuideView * view = [[HJMuscleGuideView alloc] initWithFrame:CGRectMake(0, 0, KKSceneWidth, kk_y(800))];
        _guideView = view;
    }
    
    [_guideView.backBtn addTarget:self action:@selector(guideBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_guideView.lastBtn addTarget:self action:@selector(guideBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return _guideView;
}

- (HJBaseView *)muscleView{
    
    if (!_muscleView) {
        HJBaseView * view = [[HJBaseView alloc] initWithFrame:CGRectMake(0, KKNavBarHeight, KKSceneWidth, KKSceneHeight - (KKButtonHeight*2+_imageViewheight)-KKNavBarHeight)];
        view.backgroundColor = kkWhiteColor;
        
        _muscleView = view;
        

        UILabel * titleLab = [[UILabel alloc] init];
        titleLab.frame = CGRectMake(0, 0, view.frame.size.width, 44);
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.font = kk_sizefont(KKFont_Normal);
        titleLab.textColor = kkTextBlackColor;
        [view addSubview:titleLab];
        _muscleTitleLab = titleLab;
        
        
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, titleLab.frame.size.height+30, view.frame.size.width, view.frame.size.height - titleLab.frame.size.height-30*2)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview:imageView];
        _muscleImageView = imageView;
        
        
    }
    return _muscleView;
    
}

- (HJBaseView *)saveView{
    
    float width = 60;
    float height = 44;
    
    if (!_saveView) {
        
        HJBaseView * view = [[HJBaseView alloc] initWithFrame:CGRectMake(0, 0, KKSceneWidth,KKNavBarHeight)];
        view.backgroundColor = KKBgYellowColor;
        
        _saveView = view;
        
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(kk_x(20), KKStatusBarHeight, width, height);
        [btn setTitle:KKLanguage(@"lab_common_cancel") forState:UIControlStateNormal];
        [btn setTitleColor:kkWhiteColor forState:UIControlStateNormal];
        btn.titleLabel.font = kk_sizefont(KKFont_Normal);
        [view addSubview:btn];
        btn.tag = KKButton_Cancel;
        [btn addTarget:self action:@selector(saveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
       
        
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(KKSceneWidth - width - kk_x(20), KKStatusBarHeight, width, height);
        [btn setTitle:KKLanguage(@"lab_me_userInfo_save") forState:UIControlStateNormal];
        [btn setTitleColor:kkWhiteColor forState:UIControlStateNormal];
        btn.titleLabel.font = kk_sizefont(KKFont_Normal);
        [view addSubview:btn];
        btn.tag = KKButton_Confirm;
        [btn addTarget:self action:@selector(saveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return _saveView;
}

#pragma mark ============== 刷新视图 ===============
- (void)refreshUI{
    
    /*
    肌肉测量单独刷新
     */
    if ([[HJCommon shareInstance] getTestFunction] == KKTest_Function_Muscle) {
        
        [self refreshUI_muscle];
        
        return;
    }
    
    self.testAvgLab.hidden =  self.testTopLab.hidden = self.testMinLab.hidden = self.testMaxLab.hidden = self.testResultLab.hidden = !self.isImageSuccess;
    

    HJPositionModel * model = [[HJCommon shareInstance] currectPositionToString];
    HJTestFunctionModel * functionmodel = [[HJCommon shareInstance] currectFunctionToString];
    
    NSString * string = [NSString stringWithFormat:@"%@ %@%@",model.name,functionmodel.name,KKLanguage(@"lab_function_chat_assessment_value")];
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:string];
    
    //attrStr添加字体和设置字体的范围
    [attrStr addAttribute:NSFontAttributeName
                    value:kk_sizefont(KKFont_Normal)
                    range:NSMakeRange(0, string.length)];
    
    [attrStr setAttributes:@{NSForegroundColorAttributeName :KKBgYellowColor} range:NSMakeRange(0, model.name.length)];
    self.testTopLab.attributedText = attrStr;
    
    
    /*
     单位
     */
    NSString * unit = [[HJCommon shareInstance] getBLEUnit];
    
    /*
     测量结果
     */
    if (self.isImageSuccess == NO) {
        
        self.testValueLab.font = kk_sizefont(KKFont_Normal);
        self.testValueLab.textColor = kkTextGrayColor;
        
        
        if (self.isAcceptNewData == YES) {
            
            self.testValueLab.text = KKLanguage(@"lab_function_testing");
            
        }else{
            
            self.testValueLab.text = KKLanguage(@"lab_function_testing_no");
        }
        
 
        self.chatView.BLEImageView.userInteractionEnabled = NO;
        
        self.chatView.analysisLab.text = @"";
        [self.chatView drawValue:nil];
        
        [self.chatView.fatImageView removeFromSuperview];
        

    }else{
        
        self.chatView.BLEImageView.userInteractionEnabled = YES;
        

        NSString * heightStr =[[HJCommon shareInstance] getCurrectUnitValue:_avgHeight];
        NSString * resultStr = [NSString stringWithFormat:@"%@ %@",heightStr,unit];
        
        attrStr = [[NSMutableAttributedString alloc] initWithString:resultStr];
        
        [attrStr setAttributes:@{NSForegroundColorAttributeName :KKBgYellowColor} range:NSMakeRange(0, resultStr.length)];
        
        //attrStr添加字体和设置字体的范围
        [attrStr addAttribute:NSFontAttributeName
                        value:kk_sizeBoldfont(KKFont_Big_num)
                        range:NSMakeRange(0, heightStr.length)];
       
        self.testValueLab.attributedText =attrStr;
    
        
        self.testMaxLab.text = [NSString stringWithFormat:@"%@ %@ %@",KKLanguage(@"lab_function_test_max"),[[HJCommon shareInstance] getCurrectUnitValue:_maxHeight],unit];
        
        self.testMinLab.text = [NSString stringWithFormat:@"%@ %@ %@",KKLanguage(@"lab_function_test_min"),[[HJCommon shareInstance] getCurrectUnitValue:_minHeight],unit];
    
        
        HJChartAnalysisModel * obj = [HJChartAnalysisModel chartAnalysisSex:[HJCommon shareInstance].selectModel.sex position:model.positionValue value:_avgHeight];

        self.chatView.analysisLab.text = obj.resultString;
        
        [self.chatView drawValue:obj];
        
        self.testResultLab.text = obj.resultAnalysisString;
        self.testResultLab.backgroundColor = obj.resultColor;
    }
    
    
    NSString * sexSting;
    if ([[HJCommon shareInstance].selectModel.sex intValue] == 0) {
        sexSting = KKLanguage(@"lab_me_userInfo_sex_woman");
    }else{
        sexSting = KKLanguage(@"lab_me_userInfo_sex_man");
    }
    
    self.chatView.sexLab.text = [NSString stringWithFormat:@"%@(%@)",KKLanguage(@"lab_function_chat_assessment"),sexSting];
    
}

#pragma mark ============== 刷新肌肉视图 ===============
- (void)refreshUI_muscle{
    
    
    self.testAvgLab.hidden = self.testMinLab.hidden = self.testMaxLab.hidden = self.testResultLab.hidden = YES;
    
    

    HJPositionModel * model = [[HJCommon shareInstance] currectPositionToString];
    HJTestFunctionModel * functionmodel = [[HJCommon shareInstance] currectFunctionToString];
    
    NSString * string = [NSString stringWithFormat:@"%@ %@%@",model.name,functionmodel.name,KKLanguage(@"lab_function_chat_assessment_value")];
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:string];
    
    //attrStr添加字体和设置字体的范围
    [attrStr addAttribute:NSFontAttributeName
                    value:kk_sizefont(KKFont_Normal)
                    range:NSMakeRange(0, string.length)];
    
    [attrStr setAttributes:@{NSForegroundColorAttributeName :KKBgYellowColor} range:NSMakeRange(0, model.name.length)];
    self.testTopLab.attributedText = attrStr;
    
    
    /*
     单位
     */
    NSString * unit = [[HJCommon shareInstance] getBLEUnit];
    
    /*
     测量结果
     */
    if (self.isImageSuccess == NO) {
        
        self.saveView.hidden = YES;
        self.muscleView.hidden = NO;
        
        self.chatView.BLEImageView.userInteractionEnabled = YES;
        
        [self.chatView removeMuscleLine];
        
        self.resultPointArr = nil;

    }else{
        
        /*
         如果是访客则不上传数据
         */
        if ([[HJCommon shareInstance].selectModel.id isEqualToString:KKAccount_TestId]) {
            self.saveView.hidden = YES;
        }else{
            [self.view addSubview:self.saveView];
            self.saveView.hidden = NO;
            [self.view bringSubviewToFront:self.guideView];
        }
        
        
        
        self.muscleView.hidden = YES;
        
        self.chatView.BLEImageView.userInteractionEnabled = YES;

        NSString * heightStr =[[HJCommon shareInstance] getCurrectUnitValue:_avgHeight];
        NSString * resultStr = [NSString stringWithFormat:@"%@ %@",heightStr,unit];
        
        attrStr = [[NSMutableAttributedString alloc] initWithString:resultStr];
        
        [attrStr setAttributes:@{NSForegroundColorAttributeName :KKBgYellowColor} range:NSMakeRange(0, resultStr.length)];
        
        //attrStr添加字体和设置字体的范围
        [attrStr addAttribute:NSFontAttributeName
                        value:kk_sizeBoldfont(KKFont_Big_num)
                        range:NSMakeRange(0, heightStr.length)];
       
        self.testValueLab.attributedText =attrStr;
        

        CGPoint point = CGPointMake(self.chatView.lineView1.frame.origin.y*pxHeight/self.chatView.BLEImageView.frame.size.height, self.chatView.lineView2.frame.origin.y*pxHeight/self.chatView.BLEImageView.frame.size.height);
        
        self.resultPointArr = [NSMutableArray arrayWithObject:[NSValue valueWithCGPoint:point]];
        
        self.uploadImage = self.chatView.BLEImageView.image;
    
    }
    
    
}


#pragma mark ============== 点击事件 ===============
- (void)btnClick:(UIButton*)sender{
    
    if (sender.tag == KKButton_Cancel) {
        
        self.isImageSuccess = NO;
        
        [self dismissViewControllerAnimated:NO completion:^{
            
            [self saveChatInfoData:self.resultPointArr];
                
        }];
        
    }else if (sender.tag == KKButton_Share){
        
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size,NO,
                                               [UIScreen mainScreen].scale);
        [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];//renderInContext呈现接受者及其子范围到指定的上下文
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();//返回一个基于当前图形上
        
        [HJShareUtil shareImage:image];
        
    }else if (sender.tag == KKButton_Help){
        
        [self addGuideView:YES];
        
    }

}
- (void)changeBtn:(UIButton*)sender{
    
    sender.selected  = !sender.selected;

    [HJCommon shareInstance].isTest = sender.selected;
    
    [self dismissViewControllerAnimated:NO completion:^{
            
    }];
    
}

-(void)panGestureRecognizer:(UIPanGestureRecognizer *)recognizer{
    
    CGPoint translation = [recognizer translationInView:_chatView];
    CGPoint newCenter = CGPointMake(recognizer.view.center.x,recognizer.view.center.y+translation.y);//限制屏幕范围：
    
    newCenter.y = MAX(KKSceneHeight - (KKButtonHeight*2+_imageViewheight), newCenter.y);  //距离顶部最小距离
    newCenter.y = MIN(KKSceneHeight,  newCenter.y); //距离顶部最大距离
    
    recognizer.view.center = newCenter;
    [recognizer setTranslation:CGPointZero inView:self.view];
    
}

- (void)guideBtnClick:(UIButton*)sender{
    
    switch (sender.tag) {
            
        case KKButton_back:
            self.guideView.indexTag--;
            
            break;
            
        case KKButton_last:
            
            self.guideView.indexTag++;
            
            break;
            
            
        default:
            break;
    }
    
    if (self.guideView.indexTag<0) {
        self.guideView.indexTag = 0 ;
    }
    
    [self refreshGuide:self.guideView.indexTag];
    
}

- (void)saveBtnClick:(UIButton*)sender{
    
    switch (sender.tag) {
            
        case KKButton_Confirm:
            /*
             数据上传
             */
            [self showLoadingInView:self.view time:KKTimeOut title:KKLanguage(@"lab_guide_text_33")];
            [self saveChatInfoData:self.resultPointArr];
            
            self.saveView.hidden = YES;
            
            break;
            
        case KKButton_Cancel:
            
            self.isImageSuccess = NO;
            [self.chatView removeMuscleLine];
            
            [self refreshUI];
            
            break;
            
        default:
            break;
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
