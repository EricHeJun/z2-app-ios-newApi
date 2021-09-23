//
//  HJDetailChatVC.m
//  fat
//
//  Created by ydd on 2021/5/13.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import "HJDetailChatVC.h"
#import "HJBLEChatView.h"
#import <SDWebImage/SDWebImage.h>


@interface HJDetailChatVC (){
    
    int _imageViewwidth;    //可视图片大小
    int _imageViewheight;
    
    float _maxHeight;   //最大厚度
    float _minHeight;   //最小厚度
}

@property (strong,nonatomic)UIView * topView;
@property (strong,nonatomic)UILabel * recordLab;
@property (strong,nonatomic)UILabel * maxLab;
@property (strong,nonatomic)UILabel * minLab;

@property (strong,nonatomic)HJBLEChatView * chatView;
@property (strong,nonatomic)NSMutableArray * pointArr;

@end

@implementation HJDetailChatVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    [self initData];
    [self initUI];
    [self refreshUI];
    
}
- (void)initData{
    
    _imageViewwidth = KKSceneWidth*0.8;
    _imageViewheight = _imageViewwidth*3/4;
    

    if (self.chatInfoModel.bitmapHight == nil) {
        self.chatInfoModel.bitmapHight = @"496";
    }
    
    if (self.chatInfoModel.ocxo == nil) {
        self.chatInfoModel.ocxo = @"32";
    }
    
    NSArray * arrayAvg = [self.chatInfoModel.arrayAvg componentsSeparatedByString:@","];
    self.pointArr = [NSMutableArray array];
    
    NSInteger depth = [self.chatInfoModel.depth intValue];
    NSInteger bitmapHight = [self.chatInfoModel.bitmapHight intValue];
    NSInteger ocxo = [self.chatInfoModel.ocxo intValue];
     
    NSInteger depth_mm = [[HJCommon shareInstance] getBLEDepth_cm_new:depth bitmapHight:bitmapHight withOcxo:ocxo];
    float depth_cm = depth_mm/10.0;
    
    /*
     确保数组是 偶数 项
     */
    NSInteger count = arrayAvg.count;
    if (count%2 == 1) {
        count = count-1;
    }
    
    CGPoint point;
    
    float maxHeight = 0.0;
    float minHeight = [self.chatInfoModel.bitmapHight floatValue];
    
    for (int i = 0; i<count; i++) {
        
        if (i%2 == 1) {
            if (maxHeight<[arrayAvg[i] floatValue]) {
                maxHeight = [arrayAvg[i] floatValue];
            }
            
            if (minHeight>[arrayAvg[i] floatValue]) {
                minHeight = [arrayAvg[i] floatValue];
            }
            
            point.y = [arrayAvg[i] intValue];
            [self.pointArr addObject:[NSValue valueWithCGPoint:point]];
            
        }else{
            
            point.x = [arrayAvg[i] intValue];
        }
    }
    
    _maxHeight = depth_cm*maxHeight/[self.chatInfoModel.bitmapHight floatValue];
    _minHeight = depth_cm*minHeight/[self.chatInfoModel.bitmapHight floatValue];
    
}

- (void)initUI{
    
    [self addRightBtnOneWithImage:RightBtnAddShare];
    
    [self.view addSubview:self.topView];
    [self.view addSubview:self.chatView];
    
    /*
     添加手势
     */
    
    UISwipeGestureRecognizer * leftswipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeClick:)];
    leftswipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:leftswipe];
    
    UISwipeGestureRecognizer * rightswipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeClick:)];
    rightswipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:rightswipe];
    
    
}
- (UIView *)topView{
    
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.frame = CGRectMake(0, KKNavBarHeight, KKSceneWidth, KKButtonHeight*3);
        
        
        UILabel * titleLab = [[UILabel alloc] init];
        titleLab.frame = CGRectMake(0, KKButtonHeight, KKSceneWidth, KKButtonHeight);
        titleLab.textAlignment = NSTextAlignmentCenter;
        [_topView addSubview:titleLab];
        _recordLab = titleLab;
        
        
        titleLab = [[UILabel alloc] init];
        titleLab.frame = CGRectMake(0, _recordLab.frame.size.height+_recordLab.frame.origin.y, KKSceneWidth/2, _recordLab.frame.size.height);
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.textColor = kkTextGrayColor;
        titleLab.font = kk_sizefont(KKFont_Normal);
        [_topView addSubview:titleLab];
        _maxLab = titleLab;
        
        
        titleLab = [[UILabel alloc] init];
        titleLab.frame = CGRectMake(KKSceneWidth/2, _recordLab.frame.size.height+_recordLab.frame.origin.y, KKSceneWidth/2, _recordLab.frame.size.height);
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.textColor = kkTextGrayColor;
        titleLab.font = kk_sizefont(KKFont_Normal);
        [_topView addSubview:titleLab];
        _minLab = titleLab;
        
        
    }
    
    return _topView;
}

- (HJBLEChatView *)chatView{
    
    BOOL isMuscle = NO;
    if ([self.chatInfoModel.recordType intValue] == KKTest_Function_Muscle) {
        isMuscle = YES;
    }
    
    if (!_chatView) {
        
        _chatView = [[HJBLEChatView alloc] initWithFrame:CGRectMake(0, _topView.frame.size.height+_topView.frame.origin.y, KKSceneWidth, KKSceneHeight - (_topView.frame.size.height+_topView.frame.origin.y)) withChatWidth:_imageViewwidth chatHeight:_imageViewheight depth:[self.chatInfoModel.depth intValue] bitmapHight:[self.chatInfoModel.bitmapHight integerValue] withocxo:[self.chatInfoModel.ocxo integerValue] sex:[HJCommon shareInstance].selectModel.sex type:[self.chatInfoModel.bodyPosition intValue] isMuscle:isMuscle];
        _chatView.backgroundColor = kkBgGrayColor;
    
    }
    
    
    return _chatView;
}

- (void)refreshUI{

    self.navigationItem.title = self.chatInfoModel.recordDate;
    /*
     单位
     */
    NSString * unit = [[HJCommon shareInstance] getBLEUnit];
    

    
    
    /*
     平均厚度
     */
    NSString * positionString = [[HJCommon shareInstance] currectPositionToString:[self.chatInfoModel.bodyPosition intValue]];
    NSString * functionString = [[HJCommon shareInstance] currectFunctionToString:[self.chatInfoModel.recordType intValue]];
    
    NSString * midString = [NSString stringWithFormat:@"%@%@",functionString,KKLanguage(@"lab_function_chat_assessment_value")];
    
    NSString * value =[self.chatInfoModel.recordValue substringToIndex:self.chatInfoModel.recordValue.length - KKBLEParameter_mm.length];
    NSString * valueResult = [[HJCommon shareInstance] getCurrectUnitValue:[value floatValue]/10];
    
    NSString * valueString = [NSString stringWithFormat:@"%@ %@",valueResult,unit];
    
    NSString * string = [NSString stringWithFormat:@"%@ %@%@",positionString,midString,valueString];
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:string];
    
    //attrStr添加字体和设置字体的范围
    [attrStr addAttribute:NSFontAttributeName
                    value:kk_sizefont(KKFont_Big)
                    range:NSMakeRange(0, string.length)];
    
    [attrStr setAttributes:@{NSForegroundColorAttributeName :KKBgYellowColor} range:NSMakeRange(0, positionString.length)];
    [attrStr setAttributes:@{NSForegroundColorAttributeName :KKBgYellowColor} range:NSMakeRange(string.length-valueString.length, valueString.length)];
    
    self.recordLab.attributedText = attrStr;
    
    
    /*
     图像
     */
    [self.chatView.BLEImageView sd_setImageWithURL:[NSURL URLWithString:self.chatInfoModel.httpRecordImage] placeholderImage:[[HJCommon shareInstance] getDocumentImage:self.chatInfoModel.recordImage]];
    self.chatView.oldImage = self.chatView.BLEImageView.image;
    
    
    if ([self.chatInfoModel.recordType intValue]==KKTest_Function_Muscle) {
        self.maxLab.text = self.minLab.text = @"";
        /*
         绘制线
         */
        [self.chatView drawMusclePointLine:self.pointArr bitmapHeight:[self.chatInfoModel.bitmapHight intValue] reallyValue:self.chatInfoModel.recordValue];
        
        
    }else{
        
        
        self.maxLab.text = [NSString stringWithFormat:@"%@ %@ %@",KKLanguage(@"lab_function_test_max"),[[HJCommon shareInstance] getCurrectUnitValue:_maxHeight],unit];
        
        self.minLab.text = [NSString stringWithFormat:@"%@ %@ %@",KKLanguage(@"lab_function_test_min"),[[HJCommon shareInstance] getCurrectUnitValue:_minHeight],unit];
        
        
        /*
         绘制线
         */
        [self.chatView drawPointLine:self.pointArr bitmapHeight:[self.chatInfoModel.bitmapHight intValue]];
        
        
        
        NSString * sexSting;
        if ([[HJCommon shareInstance].selectModel.sex intValue] == 0) {
            sexSting = KKLanguage(@"lab_me_userInfo_sex_woman");
        }else{
            sexSting = KKLanguage(@"lab_me_userInfo_sex_man");
        }
        
        self.chatView.sexLab.text = [NSString stringWithFormat:@"%@(%@)",KKLanguage(@"lab_function_chat_assessment"),sexSting];
        
        
        HJChartAnalysisModel * obj = [HJChartAnalysisModel chartAnalysisSex:[HJCommon shareInstance].selectModel.sex position:[self.chatInfoModel.bodyPosition intValue] value:[value floatValue]/10];
        
        self.chatView.analysisLab.text = obj.resultString;
        
        
        [self.chatView drawValue:obj];
        
        self.chatView.analysisView.hidden = self.chatView.bottomLab.hidden = YES;
    }
    
}


- (void)rightBtnOneClick:(UIButton *)sender{
    
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size,NO,
                                           [UIScreen mainScreen].scale);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];//renderInContext呈现接受者及其子范围到指定的上下文
    UIImage *image  = UIGraphicsGetImageFromCurrentImageContext();//返回一个基于当前图形上
    
    [HJShareUtil shareImage:image];
    
}

- (void)swipeClick:(UISwipeGestureRecognizer*)sender{
    
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        
        self.selIndex = self.selIndex+1;
        
    }else if (sender.direction == UISwipeGestureRecognizerDirectionRight){
        
        self.selIndex = self.selIndex-1;
    }
    
    
    if (self.selIndex<0) {
        self.selIndex = 0;
        [self showToastInView:self.view time:KKToastTime title:KKLanguage(@"tips_NoData")];
    }else if (self.selIndex>self.mutableDataArr.count-1){
        self.selIndex = self.mutableDataArr.count-1;
        [self showToastInView:self.view time:KKToastTime title:KKLanguage(@"tips_NoData")];
    }
    
    self.chatInfoModel = self.mutableDataArr[self.selIndex];

    for (UIView * view in self.chatView.subviews) {
        [view removeFromSuperview];
    }
    [self.chatView removeFromSuperview];
    self.chatView = nil;
    
    [self.view addSubview:self.chatView];
    
    [self initData];
    [self refreshUI];
    
}

@end
