//
//  HJChatVC.m
//  fat
//
//  Created by 何军 on 2021/4/14.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import "HJChatVC.h"
#import "HJChartsView.h"

@interface HJChatVC ()<ChartViewDelegate>

@property (strong,nonatomic)UIView * topView;
@property (strong,nonatomic)UIView * lineView;

@property (strong,nonatomic)HJChartsView * chartView;
@property (strong,nonatomic)UIView * timeView;
@property (strong,nonatomic)UIView * typeView;

@property (strong,nonatomic)HJRecenetView * recentlyView;


@property (strong,nonatomic)UILabel * NoDataLab;

@property (strong,nonatomic)UIButton * selPositionBtn;
@property (strong,nonatomic)UIButton * selTimeBtn;

@property (strong,nonatomic)HJPositionModel * selPositionModel;
@property (strong,nonatomic)HJChatInfoModel * chatInfoModel;

@property (strong,nonatomic)NSMutableArray * pointFatArr;
@property (strong,nonatomic)NSMutableArray * pointMuscleArr;

@property (strong,nonatomic)UIColor * bgColor;

@property (strong,nonatomic)NSMutableArray * pointDateArr;   //数据点

@end

@implementation HJChatVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addNavBackgroundColor:self.view.backgroundColor];
    
    [self initData];
    
    [self initUI];

    [self changePosition];

    [self getRecentlyData];
    
    [self getYearData];
    
    
}

- (void)initData{
    
    /*
     切换用户
     */
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(account_Change)
                                                 name:KKAccount_Change
                                               object:nil];
    
    
    /*
     切换部位
     */
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(position_Change)
                                                 name:KKPosition_Change
                                               object:nil];
    
    /*
     新测量数据后
     */
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(position_Change)
                                                 name:KKTest_NewData
                                               object:nil];
    
   
    self.selPositionModel = [[HJCommon shareInstance] currectPositionToString];
    
    self.dataArr = @[KKLanguage(@"lab_main_test_waist"),
                     KKLanguage(@"lab_main_test_belly"),
                     KKLanguage(@"lab_main_test_arm"),
                     KKLanguage(@"lab_main_test_ham"),
                     KKLanguage(@"lab_main_test_calf")];
    

    self.pointFatArr = [NSMutableArray array];
    self.pointMuscleArr = [NSMutableArray array];
    self.pointDateArr = [NSMutableArray array];

}

- (void)initUI{
    

    [self.view addSubview:self.topView];
    [self.topView addSubview:self.lineView];
    
    [self.view addSubview:self.chartView];
    [self.view addSubview:self.timeView];
    [self.view addSubview:self.typeView];
    [self.view addSubview:self.recentlyView];
    
    
    [self.view addSubview:self.NoDataLab];
    self.NoDataLab.hidden = YES;
}


- (UIView *)topView{
    
    if (!_topView) {
        
        UIView * view = [[UIView alloc] init];
        view.frame = CGRectMake(0, KKStatusBarHeight, KKSceneWidth, 44);
        _topView = view;
        
        float btnWidth = KKSceneWidth/self.dataArr.count;
        
        for (int i = 0; i<self.dataArr.count; i++) {
            
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(i*btnWidth, 0, btnWidth, view.frame.size.height);
            
            [btn setTitle:self.dataArr[i] forState:UIControlStateNormal];
            [btn setTitleColor:kkTextBlackColor forState:UIControlStateNormal];
            btn.titleLabel.font = kk_sizefont(KKFont_Normal);
            [_topView addSubview:btn];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = KKButton_Main_TestPoint;
            
            if (i == 0) {
                _selPositionBtn = btn;
            }
        }
        
    }
    
    return _topView;
}

- (UIView *)lineView{
    
    if (!_lineView) {

        UIView * view = [[UIView alloc] init];
        view.frame = CGRectMake(0, _topView.frame.size.height - 2, kk_x(100), 2);
        view.backgroundColor = KKBgYellowColor;
        _lineView = view;
        
    }
    
    return _lineView;
}

- (UIView *)chartView{
    
    if (!_chartView) {
        
        HJChartsView * view = [[HJChartsView alloc] initWithFrame:CGRectMake(0, KKNavBarHeight, KKSceneWidth, kk_y(600))];
        view.chartView.delegate = self;
        _chartView = view;
    
    }
    
    return _chartView;
}
- (UIView *)timeView{
  
    
    if (!_timeView) {
        
        UIView * view = [[UIView alloc] init];
        view.frame = CGRectMake(0, _chartView.frame.size.height +_chartView.frame.origin.y, KKSceneWidth/2, KKButtonHeight);
        _timeView = view;
        
        
        UIView * bgview = [[UIView alloc] init];
        bgview.frame = CGRectMake(kk_x(20),(view.frame.size.height - kk_y(60))/2, kk_x(360), kk_y(60));
        bgview.layer.backgroundColor = kkBgLightGrayColor.CGColor;
        bgview.layer.masksToBounds = YES;
        bgview.layer.cornerRadius = bgview.frame.size.height/2;
        [view addSubview:bgview];
        
        
        
        NSArray * timeArr = @[KKLanguage(@"lab_chat_history_chat_week"),
                              KKLanguage(@"lab_chat_history_chat_month"),
                              KKLanguage(@"lab_chat_history_chat_year")];
        
        float btnWidth = bgview.frame.size.width/timeArr.count;
        
        for (int i = 0; i<timeArr.count; i++) {
            
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(i*btnWidth, 0, btnWidth, bgview.frame.size.height);
            [btn setTitle:timeArr[i] forState:UIControlStateNormal];
            [btn setTitleColor:kkTextGrayColor forState:UIControlStateNormal];
            [btn setTitleColor:kkWhiteColor forState:UIControlStateSelected];
            btn.titleLabel.font = kk_sizefont(KKFont_Normal);
            btn.layer.cornerRadius = btn.frame.size.height/2;
            btn.layer.masksToBounds = YES;
            [bgview addSubview:btn];
            
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            if (i == 0) {
                
                btn.tag = KKButton_week;

            }else if(i == 1){
                
                btn.tag = KKButton_month;
                btn.selected = YES;
                _selTimeBtn = btn;
                btn.backgroundColor = KKBgYellowColor;
                
            }else{
                
                btn.tag = KKButton_year;
            }
        }
        
    }
    
    return _timeView;
}
- (UIView *)typeView{
    
    if (!_typeView) {
        
        UIView * view = [[UIView alloc] init];
        view.frame = CGRectMake(_timeView.frame.size.width+_timeView.frame.origin.x, _timeView.frame.origin.y, KKSceneWidth - (_timeView.frame.size.width+_timeView.frame.origin.x)-kk_x(20) , KKButtonHeight);
        _typeView = view;

        
        UILabel * titleLab = [[UILabel alloc] init];
        titleLab.frame = CGRectMake(view.frame.size.width - kk_x(80), 0, kk_x(80), view.frame.size.height);
        titleLab.text = KKLanguage(@"lab_main_muscle");
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.font = kk_sizefont(KKFont_small_12);
        titleLab.textColor = kkTextGrayColor;
        [view addSubview:titleLab];
        
        
        UIImage * image = [UIImage imageNamed:@"img_chart_muscle"];
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(titleLab.frame.origin.x-image.size.width, view.frame.size.height/2-image.size.height/2, image.size.width, image.size.height)];
        imageView.image = image;
        [view addSubview:imageView];
        
        
        titleLab = [[UILabel alloc] init];
        titleLab.frame = CGRectMake(imageView.frame.origin.x - kk_x(80), 0, kk_x(80), view.frame.size.height);
        titleLab.text = KKLanguage(@"lab_main_fat");
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.font = kk_sizefont(KKFont_small_12);
        titleLab.textColor = kkTextGrayColor;
        [view addSubview:titleLab];
        

        image = [UIImage imageNamed:@"img_chart_fat"];
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(titleLab.frame.origin.x-image.size.width, view.frame.size.height/2-image.size.height/2, image.size.width, image.size.height)];
        imageView.image = image;
        [view addSubview:imageView];
        
        
    }
    
    return _typeView;
}
- (HJRecenetView *)recentlyView{
    
    if (!_recentlyView) {
        
        HJRecenetView * view = [[HJRecenetView alloc] initWithFrame:CGRectMake(0, _timeView.frame.size.height +_timeView.frame.origin.y, KKSceneWidth, kk_y(200))];
        _recentlyView = view;
        
        UITapGestureRecognizer *pan = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer)];
        [_recentlyView.bgview addGestureRecognizer:pan];
    
    }
    
    return _recentlyView;
}
- (UILabel *)NoDataLab{
    
    if (!_NoDataLab) {
        
        UILabel * titleLab = [[UILabel alloc] init];
        titleLab.frame = CGRectMake(KKSceneWidth/4, kk_y(400), KKSceneWidth/2, kk_y(60));
        titleLab.text = KKLanguage(@"tips_NoTestData");
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.font = kk_sizefont(KKFont_Normal);
        titleLab.textColor = kkTextGrayColor;
        _NoDataLab = titleLab;
        
    }
    return _NoDataLab;
}
#pragma mark ============== 点击事件 ===============
- (void)btnClick:(UIButton*)sender{
    
    if (sender.tag == KKButton_week ||
        sender.tag == KKButton_month ||
        sender.tag == KKButton_year){
        
        _selTimeBtn.selected = NO;
        _selTimeBtn.backgroundColor = [UIColor clearColor];
        
        _selTimeBtn = sender;
        _selTimeBtn.selected = YES;
        _selTimeBtn.backgroundColor = KKBgYellowColor;
        
        [self getYearData];
        
    }else if(sender.tag == KKButton_Main_TestPoint){
        
        _selPositionBtn.titleLabel.font = kk_sizefont(KKFont_Normal);
        
        _selPositionBtn = sender;
        
        _selPositionBtn.titleLabel.font = kk_sizeBoldfont(KKFont_Big);
        
        self.selPositionModel = [[HJCommon shareInstance] selPositionToString:_selPositionBtn.titleLabel.text];
        
        [self getRecentlyData];
        
        [self getYearData];
        
    }
    
}

#pragma mark ============== 手势 ===============
- (void)panGestureRecognizer{
    
    HJHistoryChatVC * vc = [[HJHistoryChatVC alloc] init];
    vc.position = self.selPositionModel.positionValue;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ============== 刷新最近一条记录 ===============
- (void)refreshUI{
    
    _lineView.center  = CGPointMake(_selPositionBtn.center.x,_lineView.center.y);//限制屏幕范围：
    
    if (_chatInfoModel) {
        
        _recentlyView.hidden = _timeView.hidden = _typeView.hidden = NO;
        
        _recentlyView.timeLab.text = self.chatInfoModel.recordDate;
        _recentlyView.positionLab.text = [[HJCommon shareInstance] currectPositionToString:[self.chatInfoModel.bodyPosition integerValue]];
        _recentlyView.functionLab.text = [[HJCommon shareInstance] currectFunctionToString:[self.chatInfoModel.recordType integerValue]];
        
        
        NSString * unit=[[HJCommon shareInstance] getBLEUnit];

        NSString * value =[self.chatInfoModel.recordValue substringToIndex:self.chatInfoModel.recordValue.length - KKBLEParameter_mm.length];
        
        value = [[HJCommon shareInstance] getCurrectUnitValue:[value floatValue]/10];

        _recentlyView.recordValueLab.text = [NSString stringWithFormat:@"%@ %@",value,unit];
        
        [_recentlyView.imageView sd_setImageWithURL:[NSURL URLWithString:self.chatInfoModel.httpRecordImage] placeholderImage:nil];
        
        
    }else{
        
        _recentlyView.hidden = _timeView.hidden = _typeView.hidden = YES;
    
    }
}
#pragma mark ============== 改变当前选择的部位 ===============
- (void)changePosition{
    
    for (id obj in self.topView.subviews) {
        
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton * btn = (UIButton*)obj;
            
            if ([self.selPositionModel.name isEqualToString:btn.titleLabel.text]) {
                _selPositionBtn.titleLabel.font = kk_sizefont(KKFont_Normal);
                _selPositionBtn = btn;
                _selPositionBtn.titleLabel.font = kk_sizeBoldfont(KKFont_Big);
                break;
            }
            
        }
    }
    
    _lineView.center  = CGPointMake(_selPositionBtn.center.x,_lineView.center.y);//限制屏幕范围：
    
}
#pragma mark ============== 刷新绘图界面 ===============
- (void)refreshChartsUI{
    
    if (self.mutableDataArr.count) {
        self.chartView.hidden = NO;
        self.NoDataLab.hidden = YES;
    }else{
        self.chartView.hidden = YES;
        self.NoDataLab.hidden = NO;
    }
}

#pragma mark ============== 处理绘图数据 ===============
- (void)initChartData{
    
    [self refreshChartsUI];
    [self.pointDateArr removeAllObjects];
    
    if (self.mutableDataArr.count == 0) {
        return;
    }
    
    /*
     去除重复日期
     */
    for (HJChatInfoModel * model in self.mutableDataArr) {
        
        if ([self.pointDateArr containsObject:model.recordDate] == NO) {
            [self.pointDateArr addObject:model.recordDate];
        }
    }
    
    
    float value = 0;
    
    NSString * valueCm;
    
    for (int i = 0; i<self.mutableDataArr.count; i++) {
        
        HJChatInfoModel * model = self.mutableDataArr[i];

        /*
         这是mm值, 需要转换成 当前选中的 单位值
         */
        value = [model.recordValue floatValue];
        valueCm =  [[HJCommon shareInstance] getCurrectUnitValue:value/10.];
        
        if ([model.recordType intValue] == KKTest_Function_Fat) {
            
            NSUInteger j = [self.pointDateArr indexOfObject:model.recordDate];
        
            //创建ChartDataEntry对象并将每个点对应的值与x轴 y轴进行绑定
            ChartDataEntry *entry = [[ChartDataEntry alloc] initWithX:j y:[valueCm doubleValue]];
            
            entry.data = model.recordDate;
            [self.pointFatArr addObject:entry];
            
        }else{
            
            NSUInteger j = [self.pointDateArr indexOfObject:model.recordDate];
        
            //创建ChartDataEntry对象并将每个点对应的值与x轴 y轴进行绑定
            ChartDataEntry *entry = [[ChartDataEntry alloc] initWithX:j y:[valueCm doubleValue]];
            
            entry.data = model.recordDate;
            [self.pointMuscleArr addObject:entry];
            
        }
        
    }
    
   [self drawChartsView];

}

- (void)drawChartsView{
    
    /*
     绘制视图
     */
    UIColor *color;
    
    switch (_selPositionModel.positionValue) {
        case KKTest_Function_Position_Waist://腰部
            
            color = KKWaistColor;

            break;
        case KKTest_Function_Position_Face://脸
            
            color = KKFaceColor;
   
            break;
        case KKTest_Function_Position_Belly://腹部
            
            color = KKBellyColor;

            break;
        case KKTest_Function_Position_Arm://手臂
            
            color = KKArmColor;

            break;
        case KKTest_Function_Position_Ham://大腿
            
            color = KKHamColor;
            
            break;

        case KKTest_Function_Position_Calf://小腿
            
            color = KKCalfColor;
  
            break;
            
    }
    
    self.bgColor = color;
    /*
     绘图
     */
    [self.chartView drawFatView:self.pointFatArr muscleArr:self.pointMuscleArr color:color type:self.selTimeBtn.tag pointDateArr:(NSMutableArray*)self.pointDateArr];
    
    
    [self.chartView.chartView zoomWithScaleX:0 scaleY:1 x:self.chartView.chartView.frame.size.width y:0];
    
    if (self.selTimeBtn.tag == KKButton_week ||
        self.selTimeBtn.tag == KKButton_month) {
        
        if (self.pointFatArr.count>15 || self.pointMuscleArr.count>15) {
            
            [self.chartView.chartView zoomWithScaleX:100/12 scaleY:1 x:self.chartView.chartView.frame.size.width y:0];
        }
    }
    


}


#pragma mark ============== 最近记录 ===============

- (void)getRecentlyData{
    
    [self showLoadingInView:self.view time:KKTimeOut title:KKLanguage(@"lab_common_loading")];
    
    HJFatRecordHttpModel * model = [[HJFatRecordHttpModel alloc] init];
    
    model.userId = [HJCommon shareInstance].userInfoModel.userId;
    
    
    model.bodyPosition = [NSString stringWithFormat:@"%ld",(long)self.selPositionModel.positionValue];
    
    NSString * familiId = [HJCommon shareInstance].selectModel.id;
    
    if ([familiId isEqualToString:KKAccount_TestId]) {
        familiId =  [HJCommon shareInstance].userInfoModel.id;
    }
    
    model.familyId = familiId;

    NSDictionary * dic =[model toDictionary];
    
    [KKHttpRequest HttpRequestType:k_POST withrequestType:NO withDataString:dic withUrl:KK_URL_query_fat_record_by_recently withSuccess:^(id result, NSDictionary *resultDic, HJHTTPModel *model) {
        
        [self hideLoading];
        
        if (model.errorcode == KKStatus_success) {
            //解析数据,存储数据库
            NSString * jsonStr = [HJAESUtil aesDecrypt:model.data];
            //DLog(@"jsonStr:%@",jsonStr);
            
            self.chatInfoModel = [[HJChatInfoModel alloc] initWithString:jsonStr error:nil];
            [self refreshUI];
            
        }else{
            
            [self showToastInView:self.view time:KKToastTime title:model.msg];
        }
        
        
    } withError:^(id result, NSDictionary *resultDic, HJHTTPModel *model) {
        
        [self showToastInView:self.view time:KKToastTime title:KKLanguage(@"tips_fail")];
        
        self.chatInfoModel = nil;
        [self refreshUI];
        
    }];
}
/*
 获取最近一年的数据 平均值
 */
- (void)getYearData{
    
    [self showLoadingInView:self.view time:KKTimeOut title:KKLanguage(@"lab_common_loading")];
    
    HJFatRecordHttpModel * model = [[HJFatRecordHttpModel alloc] init];
    
    model.userId = [HJCommon shareInstance].userInfoModel.userId;
    
    model.bodyPosition = [NSString stringWithFormat:@"%ld",(long)self.selPositionModel.positionValue];
    
    NSString * familiId = [HJCommon shareInstance].selectModel.id;
    
    if ([familiId isEqualToString:KKAccount_TestId]) {
        familiId =  [HJCommon shareInstance].userInfoModel.id;
    }
    
    model.familyId = familiId;
    
    model.recordDate = [[HJCommon shareInstance] getLastYear];
    
    NSDictionary * dic =[model toDictionary];
    
    NSString * url = KK_URL_query_fat_record_by_date;
    
    if (self.selTimeBtn.tag == KKButton_year) {
        url = KK_URL_query_fat_record_by_month_avg;
    }
    
    [KKHttpRequest HttpRequestType:k_POST withrequestType:NO withDataString:dic withUrl:url withSuccess:^(id result, NSDictionary *resultDic, HJHTTPModel *model) {
        
        [self hideLoading];
        
        if (model.errorcode == KKStatus_success) {
            
            [self.pointFatArr removeAllObjects];
            [self.pointMuscleArr removeAllObjects];
            
            //解析数据,存储数据库
            NSString * jsonStr = [HJAESUtil aesDecrypt:model.data];
            //DLog(@"曲线数据:%@",jsonStr);
            
            NSMutableArray * arr = [HJChatInfoModel arrayOfModelsFromString:jsonStr error:nil];
            
            self.mutableDataArr =   [[[arr reverseObjectEnumerator] allObjects] mutableCopy];
            
            [self initChartData];
            
        }else{
            [self showToastInView:self.view time:KKToastTime title:model.msg];
        }
        
    } withError:^(id result, NSDictionary *resultDic, HJHTTPModel *model) {
        
        [self showToastInView:self.view time:KKToastTime title:KKLanguage(@"tips_fail")];
        
        self.mutableDataArr = nil;
        
        [self initChartData];
        
    }];
}
#pragma mark ============== 通知 ===============
- (void)account_Change{
    
    /*
     选中的位置
     */
    DLog(@"切换对象");
    [self getYearData];
    [self getRecentlyData];
    
}

- (void)position_Change{
    
    /*
     选中的位置
     */
    self.selPositionModel = [[HJCommon shareInstance] currectPositionToString];
    [self changePosition];
    
    DLog(@"切换选中的位置");
    [self getYearData];
    [self getRecentlyData];
    
}


#pragma mark - ChartViewDelegate

- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry highlight:(ChartHighlight * __nonnull)highlight{
    
    NSLog(@"chartValueSelected");
    
    NSString * unit=[[HJCommon shareInstance] getBLEUnit];
    NSString * value = [NSString stringWithFormat:@"%@ %@\n%@",[[HJCommon shareInstance] getCurrectUnitValue:entry.y],unit,entry.data];
    
    [self.chartView showMarkerView:value bgColor:self.bgColor];
    
//    HJHistoryChatVC * vc = [[HJHistoryChatVC alloc] init];
//    vc.position = self.selPositionModel.positionValue;
//    vc.recordDate = entry.data;
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
    
}



@end
