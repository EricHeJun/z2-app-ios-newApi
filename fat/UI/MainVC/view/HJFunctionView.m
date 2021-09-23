//
//  HJFunctionView.m
//  fat
//
//  Created by ydd on 2021/4/15.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import "HJFunctionView.h"

@implementation HJFunctionView



- (instancetype)initWithFrame:(CGRect)frame withViewType:(KKViewType)type{
    
    self = [super initWithFrame:frame];
    
  
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        if (type == KKViewType_testPoint_select) {
            
            [self functionTestPoint:frame];
            
        }else if(type == KKViewType_DeviceList){
            
            [self deviceListView:frame];
            
        }else if (type == KKViewType_AccountList){
            
            [self accountListView:frame];
        }
    }
    
    return self;
}
#pragma mark ============== 选择功能视图 ===============

- (void)functionTestPoint:(CGRect)frame{
    
    UILabel * titleLab = [[UILabel alloc] init];
    titleLab.frame = CGRectMake(0, _sexView.frame.size.height, frame.size.width, kk_y(80));
    titleLab.text = KKLanguage(@"lab_main_test_function");
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = kk_sizefont(KKFont_Normal);
    titleLab.textColor = kkTextGrayColor;
    [self addSubview:titleLab];
    _testFunctionLab = titleLab;
    
    float btnWidth = kk_x(160);
    float btnHeight = kk_y(200);
    
    
    //fat 按钮
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(frame.size.width/3-btnWidth/2, titleLab.frame.origin.y + titleLab.frame.size.height + kk_y(20), btnWidth, btnHeight);
    
    [btn setImage:[UIImage imageNamed:@"img_btn_fat_nor"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"img_btn_fat_sel"] forState:UIControlStateSelected];
    
    [btn setTitle:KKLanguage(@"lab_main_test_fat") forState:UIControlStateNormal];
    [btn setTitleColor:kkTextGrayColor forState:UIControlStateNormal];
    [btn setTitleColor:KKBgYellowColor forState:UIControlStateSelected];
    btn.titleLabel.font = kk_sizefont(KKFont_Normal);
    [self addSubview:btn];
    btn.tag = KKButton_Main_TestPoint_fat;
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(btn.imageView.frame.size.height ,-btn.imageView.frame.size.width,-10,0)];
    //文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
    [btn setImageEdgeInsets:UIEdgeInsetsMake(-btn.imageView.frame.size.height+30, 0.0,0.0, -btn.titleLabel.bounds.size.width)];
    
    _fatBtn = btn;
    
    
    // 肌肉 按钮
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(frame.size.width/3*2-btnWidth/2, titleLab.frame.origin.y + titleLab.frame.size.height + kk_y(20), btnWidth, btnHeight);
    
    [btn setImage:[UIImage imageNamed:@"img_btn_muscle_nor"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"img_btn_muscle_sel"] forState:UIControlStateSelected];
    
    [btn setTitle:KKLanguage(@"lab_main_test_muscle") forState:UIControlStateNormal];
    [btn setTitleColor:kkTextGrayColor forState:UIControlStateNormal];
    [btn setTitleColor:KKBgYellowColor forState:UIControlStateSelected];
    btn.titleLabel.font = _fatBtn.titleLabel.font;
    [self addSubview:btn];
    btn.tag = KKButton_Main_TestPoint_muscle;
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(btn.imageView.frame.size.height ,-btn.imageView.frame.size.width,-10,0)];
    //文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
    [btn setImageEdgeInsets:UIEdgeInsetsMake(-btn.imageView.frame.size.height+30, 0.0,0.0, -btn.titleLabel.bounds.size.width)];
    
    _muslceBtn = btn;
    
    
    //请选择测量部位
    titleLab = [[UILabel alloc] init];
    titleLab.frame = CGRectMake(0, btn.frame.size.height+btn.frame.origin.y+kk_y(20), frame.size.width, kk_y(80));
    titleLab.text = KKLanguage(@"lab_main_test_select_point");
    titleLab.textAlignment = _testFunctionLab.textAlignment;
    titleLab.font = _testFunctionLab.font;
    titleLab.textColor = _testFunctionLab.textColor;
    [self addSubview:titleLab];
    _testPointLab= titleLab;
    
    [self addSubview:self.fatView];
    [self addSubview:self.muslceView];
    
    self.muslceView.hidden = YES;
}

#pragma mark ============== 选择测量部位视图 ===============
- (void)testFatView{
    
    NSArray * titleArr = @[KKLanguage(@"lab_main_test_belly"),
                           KKLanguage(@"lab_main_test_waist"),
                           KKLanguage(@"lab_main_test_arm"),
                           KKLanguage(@"lab_main_test_ham"),
                           KKLanguage(@"lab_main_test_calf")];
    
    NSArray * imageArr = @[KKLanguage(@"img_btn_belly_nor"),
                           KKLanguage(@"img_btn_waist_nor"),
                           KKLanguage(@"img_btn_arm_nor"),
                           KKLanguage(@"img_btn_ham_nor"),
                           KKLanguage(@"img_btn_calf_nor")];
    
    NSArray * imageSelArr = @[KKLanguage(@"img_btn_belly_sel"),
                           KKLanguage(@"img_btn_waist_sel"),
                           KKLanguage(@"img_btn_arm_sel"),
                           KKLanguage(@"img_btn_ham_sel"),
                           KKLanguage(@"img_btn_calf_sel")];
    
    float btnWidth = kk_x(160);
    float btnHeight = kk_y(200);
    
    float width_space_1 = (self.frame.size.width - btnWidth*3)/4;
    
    float width_space_2 = (self.frame.size.width - btnWidth*2)/3;
    
    
    int x,y;
    
    KKTest_Function_Position value =[[HJCommon shareInstance] getTestFunctionPosition];
    
    for (int i = 0; i<titleArr.count; i++) {
        
        x = i%3;
        y = i/3;
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        if (y>0) {
            
            btn.frame = CGRectMake(width_space_2+x*(width_space_2 + btnWidth), y*btnHeight+kk_y(20), btnWidth, btnHeight);
            
        }else{
            
            btn.frame = CGRectMake(width_space_1+x*(width_space_1 + btnWidth), y*btnHeight+kk_y(20), btnWidth, btnHeight);
            
        }
        
        [btn setImage:[UIImage imageNamed:imageArr[i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:imageSelArr[i]] forState:UIControlStateSelected];
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:kkTextGrayColor forState:UIControlStateNormal];
        [btn setTitleColor:KKBgYellowColor forState:UIControlStateSelected];
        btn.titleLabel.font = kk_sizefont(KKFont_Normal);
        [self.fatView addSubview:btn];
       
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(btn.imageView.frame.size.height ,-btn.imageView.frame.size.width,-10,0)];
        //文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
        [btn setImageEdgeInsets:UIEdgeInsetsMake(-btn.imageView.frame.size.height+30, 0.0,0.0, -btn.titleLabel.bounds.size.width)];
        
        [btn addTarget:self action:@selector(fatBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        if (i == 0) {
            
            /*
             默认选中
             */
            btn.tag = KKTest_Function_Position_Belly;
            _fatviewBtnSel = btn;
            
            
        }else if (i == 1){
            
            
            btn.tag = KKTest_Function_Position_Waist;
            if (value == KKTest_Function_Position_Waist) {
                _fatviewBtnSel = btn;
            }
            
            
        }else if (i == 2){
            
            btn.tag = KKTest_Function_Position_Arm;
            
            if (value == KKTest_Function_Position_Arm) {
                _fatviewBtnSel = btn;
            }
            
        }else if (i == 3){
            
            btn.tag = KKTest_Function_Position_Ham;
            
            if (value == KKTest_Function_Position_Ham) {
                _fatviewBtnSel = btn;
            }
            
        }else if (i == 4){
            
            btn.tag = KKTest_Function_Position_Calf;
    
            if (value == KKTest_Function_Position_Calf) {
                _fatviewBtnSel = btn;
            }
        }
    }
    
    _fatviewBtnSel.selected = YES;
    
}

- (void)testMuslceView{
    
    NSArray * titleArr = @[KKLanguage(@"lab_main_test_belly"),
                           KKLanguage(@"lab_main_test_arm_front"),
                           KKLanguage(@"lab_main_test_ham"),
                           KKLanguage(@"lab_main_test_calf")];
    

    NSArray * imageArr = @[KKLanguage(@"img_btn_belly_nor"),
                           KKLanguage(@"img_btn_arm_nor"),
                           KKLanguage(@"img_btn_ham_nor"),
                           KKLanguage(@"img_btn_calf_nor")];
    
    NSArray * imageSelArr = @[KKLanguage(@"img_btn_belly_sel"),
                           KKLanguage(@"img_btn_arm_sel"),
                           KKLanguage(@"img_btn_ham_sel"),
                           KKLanguage(@"img_btn_calf_sel")];
    
    float btnWidth = kk_x(160);
    float btnHeight = kk_y(200);
    
    float width_space_2 = (self.frame.size.width - btnWidth*2)/3;
    
    int x,y;
    
    KKTest_Function_Position value =[[HJCommon shareInstance] getTestFunctionPosition];
    
    for (int i = 0; i<titleArr.count; i++) {
        
        x = i%2;
        y = i/2;
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        btn.frame = CGRectMake(width_space_2+x*(width_space_2 + btnWidth), y*btnHeight+kk_y(20), btnWidth, btnHeight);
        
        [btn setImage:[UIImage imageNamed:imageArr[i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:imageSelArr[i]] forState:UIControlStateSelected];
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:kkTextGrayColor forState:UIControlStateNormal];
        [btn setTitleColor:KKBgYellowColor forState:UIControlStateSelected];
        btn.titleLabel.font = kk_sizefont(KKFont_Normal);
        [self.muslceView addSubview:btn];
      
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(btn.imageView.frame.size.height ,-btn.imageView.frame.size.width,-10,0)];
        //文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
        [btn setImageEdgeInsets:UIEdgeInsetsMake(-btn.imageView.frame.size.height+30, 0.0,0.0, -btn.titleLabel.bounds.size.width)];
        
        [btn addTarget:self action:@selector(muscleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        

        
        if (i == 0) {
            /*
             默认选中
             */
            btn.tag = KKTest_Function_Position_Belly;
            _muslceViewBtnSel = btn;
            
        }else if (i == 1){
            
            btn.tag = KKTest_Function_Position_Arm;
            
            if (value == KKTest_Function_Position_Arm) {
                _muslceViewBtnSel = btn;
            }
            
        }else if (i == 2){
            
            btn.tag = KKTest_Function_Position_Ham;
            
            if (value == KKTest_Function_Position_Ham) {
                _muslceViewBtnSel = btn;
            }
            
        }else if (i == 3){
            
            btn.tag = KKTest_Function_Position_Calf;
            
            if (value == KKTest_Function_Position_Calf) {
                _muslceViewBtnSel = btn;
            }
        }
       
    }
    _muslceViewBtnSel.selected = YES;
    
}

static UIImage * manimage;
static UIImage * womanimage;

- (UIView *)sexView{
    
    if (!_sexView) {
        
        _sexView  = [[UIView alloc] init];
        _sexView.frame = CGRectMake(0, 0, self.frame.size.width, 0);
    }
    
    if (!_sexLab) {
        _sexLab =  [[UILabel alloc] init];
    }
   
    _sexLab.frame = CGRectMake(0, 0, _sexView.frame.size.width, kk_y(80));
    _sexLab.text = KKLanguage(@"lab_main_test_sex");
    _sexLab.font = _testFunctionLab.font;
    _sexLab.textColor = _testFunctionLab.textColor;
    _sexLab.textAlignment = _testFunctionLab.textAlignment;
    
    [_sexView addSubview:_sexLab];
    
    
    float imageWidth = kk_y(120);
    float imageHeight = kk_y(120);
    
    if (!_womanBtn ) {
        _womanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    _womanBtn.frame = CGRectMake(_fatBtn.center.x - imageWidth/2 , _sexLab.frame.size.height, imageWidth, imageHeight);
    
    [_womanBtn setImage:[UIImage imageNamed:@"img_me_userinfo_woman_nor"] forState:UIControlStateNormal];
    [_womanBtn setImage:[UIImage imageNamed:@"img_me_userinfo_woman"] forState:UIControlStateSelected];
    [_sexView addSubview:_womanBtn];
    _womanBtn.tag = KKTest_Sex_Woman;
    [_womanBtn addTarget:self action:@selector(sexBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    if (!_manBtn ) {
        _manBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    _manBtn.frame = CGRectMake(_muslceBtn.center.x - imageWidth/2, _womanBtn.frame.origin.y, imageWidth, imageHeight);
    
    [_manBtn setImage:[UIImage imageNamed:@"img_me_userinfo_man_nor"] forState:UIControlStateNormal];
    [_manBtn setImage:[UIImage imageNamed:@"img_me_userinfo_man"] forState:UIControlStateSelected];
    [_sexView addSubview:_manBtn];
    _manBtn.tag = KKTest_Sex_Man;
    [_manBtn addTarget:self action:@selector(sexBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    KKTest_Sex sexValue  = [[HJCommon shareInstance] getTestSex];
    
    if (sexValue == KKTest_Sex_Woman) {
        
        _womanBtn.selected = YES;
        _sexBtnSel = _womanBtn;
        
    }else{
        
        _manBtn.selected = YES;
        _sexBtnSel = _manBtn;
        
    }
    
    return _sexView;
}

- (UIView *)fatView{
    
    if (!_fatView) {
        
        _fatView = [[UIView alloc] initWithFrame:CGRectMake(0, _testPointLab.frame.size.height+_testPointLab.frame.origin.y, self.frame.size.width, self.frame.size.height - (_testPointLab.frame.size.height+_testPointLab.frame.origin.y))];
        
        [self testFatView];
        
    }
    return _fatView;
}

- (UIView *)muslceView{
    
    if (!_muslceView) {
        
        _muslceView = [[UIView alloc] initWithFrame:CGRectMake(0, _testPointLab.frame.size.height+_testPointLab.frame.origin.y, self.frame.size.width, self.frame.size.height - (_testPointLab.frame.size.height+_testPointLab.frame.origin.y))];
        
        [self testMuslceView];
        
    }
    return _muslceView;
}


- (void)deviceListView:(CGRect)frame{

    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(kk_x(20), frame.size.height - KKButtonHeight - KKButtomSpace - kk_y(40), frame.size.width-2*kk_x(20), KKButtonHeight);
    [btn setTitle:KKLanguage(@"lab_common_cancel") forState:UIControlStateNormal];
    [btn setTitleColor:kkWhiteColor forState:UIControlStateNormal];
    [self addSubview:btn];
    btn.backgroundColor = KKBgYellowColor;
    btn.tag = KKButton_Cancel;
    _cancelBtn = btn;
    
    
    if (!_deviceTableView) {
        
        UITableView * tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width,btn.frame.origin.y-KKButtonHeight) style:UITableViewStylePlain];
        tableview.showsVerticalScrollIndicator = NO;
        tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableview.bounces = YES;
        
        if (@available(iOS 11.0, *)) {
            tableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        
        UIView * view = [[UIView alloc] init];
        view.frame = CGRectMake(0, 0, KKSceneWidth, KKButtonHeight);
        view.backgroundColor = [UIColor clearColor];
        
        UILabel * titleLab = [[UILabel alloc] init];
        titleLab.frame = CGRectMake(kk_x(40), 0, frame.size.width-2*kk_x(40), view.frame.size.height);
        titleLab.textAlignment = NSTextAlignmentLeft;
        titleLab.font = kk_sizefont(KKFont_Big);
        titleLab.textColor = kkTextBlackColor;
        [view addSubview:titleLab];
        _searchTitleLab = titleLab;
        tableview.tableHeaderView = view;
        
        
        _deviceTableView = tableview;
    }
    
    [self addSubview:_deviceTableView];
}
#pragma mark ============== 用户列表 ===============
- (void)accountListView:(CGRect)frame{
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, frame.size.height - KKButtonHeight - KKButtomSpace, frame.size.width, KKButtonHeight);
    [btn setImage:[UIImage imageNamed:@"img_btn_add_account"] forState:UIControlStateNormal];
    [btn setTitle:KKLanguage(@"lab_main_add_account") forState:UIControlStateNormal];
    [btn setTitleColor:kkTextGrayColor forState:UIControlStateNormal];
    [self addSubview:btn];
    btn.tag = KKButton_Main_AddAcount;
    _addAccountBtn = btn;
    
    
    if (!_accountTableView) {
        
        UITableView * tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height-btn.frame.size.height - KKButtomSpace) style:UITableViewStylePlain];
        tableview.showsVerticalScrollIndicator = NO;
        tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableview.bounces = YES;
        
        if (@available(iOS 11.0, *)) {
            tableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        UIView * view = [[UIView alloc] init];
        view.frame = CGRectMake(0, 0, KKSceneWidth, KKButtonHeight);
      
        
        UILabel * titleLab = [[UILabel alloc] init];
        titleLab.frame = CGRectMake(kk_x(40), 0, frame.size.width-2*kk_x(40), view.frame.size.height);
        titleLab.text = KKLanguage(@"lab_main_switch_account");
        titleLab.textAlignment = NSTextAlignmentLeft;
        titleLab.font = kk_sizefont(KKFont_Big);
        titleLab.textColor = kkTextBlackColor;
        [view addSubview:titleLab];
        
        /*
         假的按钮
         */
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(view.frame.size.width - 44 - kk_x(20), view.frame.size.height/2-44/2, 44, 44);

        UIImage *image = [UIImage imageNamed:@"common_bg_cancel"];
        [btn setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        btn.tintColor = kkTextGrayColor;
        [view addSubview:btn];
        btn.userInteractionEnabled = NO;
        tableview.tableHeaderView = view;
        
        _accountTableView = tableview;
    }
    
    [self addSubview:_accountTableView];
}

#pragma mark ============== 点击事件 ===============
- (void)fatBtnClick:(UIButton*)sender{
    
    if (self.selectFatBlock) {
        self.selectFatBlock(sender);
    }
    
}

- (void)muscleBtnClick:(UIButton*)sender{
    
    if (self.selectMuscleBlock) {
        self.selectMuscleBlock(sender);
    }
    
}

- (void)sexBtnClick:(UIButton*)sender{
    
    if (self.selectSexBlock) {
        self.selectSexBlock(sender);
    }
    
}



/*
 是否展示 sex 视图
 */
- (void)showSexView:(BOOL)isShow{
    
    if (isShow) {
        
        [self addSubview:self.sexView];
        self.sexView.frame = CGRectMake(0, 0, self.frame.size.width, kk_y(200));
        
        self.frame = CGRectMake(self.frame.origin.x, KKSceneHeight - kk_y(1100), self.frame.size.width, kk_y(1100));
        
    }else{
        
        [self addSubview:self.sexView];
        self.sexView.frame = CGRectMake(0, 0, self.frame.size.width, 0);
        
        self.frame = CGRectMake(self.frame.origin.x, KKSceneHeight - kk_y(900), self.frame.size.width, kk_y(900));
    }
    
    self.testFunctionLab.frame = CGRectMake(self.testFunctionLab.frame.origin.x, self.sexView.frame.size.height, self.testFunctionLab.frame.size.width, self.testFunctionLab.frame.size.height);
    
    self.fatBtn.frame = CGRectMake(self.fatBtn.frame.origin.x, _testFunctionLab.frame.origin.y + _testFunctionLab.frame.size.height + kk_y(20), self.fatBtn.frame.size.width, self.fatBtn.frame.size.height);
    
    self.muslceBtn.frame = CGRectMake(self.muslceBtn.frame.origin.x, _testFunctionLab.frame.origin.y + _testFunctionLab.frame.size.height + kk_y(20), self.muslceBtn.frame.size.width, self.muslceBtn.frame.size.height);
    
    
    self.testPointLab.frame = CGRectMake(self.testPointLab.frame.origin.x, _muslceBtn.frame.size.height+_muslceBtn.frame.origin.y+kk_y(20), self.testPointLab.frame.size.width, self.testPointLab.frame.size.height);
    
    
    _fatView.frame = CGRectMake(0, _testPointLab.frame.size.height+_testPointLab.frame.origin.y, _fatView.frame.size.width, _fatView.frame.size.height);
    
    _muslceView.frame = CGRectMake(0, _testPointLab.frame.size.height+_testPointLab.frame.origin.y, _muslceView.frame.size.width, _muslceView.frame.size.height);

    
    self.sexView.hidden = !isShow;
}

@end
