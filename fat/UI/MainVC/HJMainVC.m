//
//  HJMainVC.m
//  fat
//
//  Created by ydd on 2021/4/2.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import "HJMainVC.h"

#import "HJMainVC+BLE.h"

#import "HJMainVC+AccountList.h"

#import "HJMainVC+UploadData.h"



@interface HJMainVC ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation HJMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self initData];
    [self initUI];
  
    [self refreshUI];

}

- (void)initData{
    
    /*
     初始化蓝牙
     */
    [self initDataBLE];

    /*
     当前登陆者信息
     */
    [HJCommon shareInstance].userInfoModel = [HJFMDBModel queryCurrectUserInfoWithUser];

    /*
     获取当前用户最新信息 - 如果没有设置信息, 跳转到信息界面
     */
    if ([HJCommon shareInstance].userInfoModel.userName.length == 0) {
        
        HJUserInfoVC * vc = [[HJUserInfoVC alloc] init];
        vc.navigationItem.title = KKLanguage(@"lab_me_complete_info");
        vc.hidesBottomBarWhenPushed = YES;   //关键代码 （隐藏tabBar）
        vc.userInfoType = KKUserInfoType_self;
        [self.navigationController pushViewController:vc animated:YES];
        
        vc.selectBlock = ^(HJUserInfoModel *userModel) {
            
            self.testAccountView.textLab.text = userModel.userName;
            [self.testAccountView.topImageView sd_setImageWithURL:[NSURL URLWithString:[HJCommon shareInstance].userInfoModel.avatar] placeholderImage:[UIImage imageNamed:@"img_me_userinfo_photo_s"]];
            
        };
    }
    
    
    /*
     初始化用户
     */
    
    [self initDataAccount:nil];
    
    
    /*
     app数据上传 分线程执行
     */
    
    dispatch_queue_t queue =  dispatch_get_global_queue(0, 0);
    
    /*
     app更新 分线程执行
     */
    
    dispatch_async(queue, ^{
        [self getAppStoreInfo:NO];
    });

}

#pragma mark ============== UI ===============
- (void)initUI{
    
    [self addNavBackgroundColor:self.view.backgroundColor];
    
    
    UIImage * titleImage =[UIImage imageNamed:@"img_bg_main_title"];
    
    if(KKIsIphoneXLater){
        titleImage = [UIImage imageNamed:@"img_bg_main_title_all"];
    }
    UIImageView * titleImageView = [[UIImageView alloc] init];
    titleImageView.image = titleImage;
    titleImageView.frame = CGRectMake(0, 0, KKSceneWidth, titleImage.size.height);
    [self.view addSubview:titleImageView];
    
    
    /*
     蓝牙信息
     */
    [self.view addSubview:self.BLEStatusView];
    
    //右侧按钮
    [self addRightBtnTwoWithImage:@[@(RightBtnSearchBLE),@(RightBtnDeviceInfo)]];
    
    
    float btnWidth = kk_x(270);
    float btnSpace = kk_x(60);
    //测量者

    _testAccountView = [[HJButtonView alloc] initWithFrame:CGRectMake(KKSceneWidth/2-btnWidth-btnSpace/2, kk_y(250), btnWidth, kk_y(200)) withButtonType:KKButton_Main_TestAccount];
    [self.view addSubview:_testAccountView];
    
    _testAccountView.titleLab.text =KKLanguage(@"lab_main_test_account");
    _testAccountView.textLab.textColor = kkTextGrayColor;
    _testAccountView.topImageView.layer.cornerRadius =_testAccountView.topImageView.frame.size.height/2;
    _testAccountView.topImageView.layer.masksToBounds = YES;
    
    
    [_testAccountView.testButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _testPointView = [[HJButtonView alloc] initWithFrame:CGRectMake(KKSceneWidth/2+btnSpace/2, kk_y(250), btnWidth, kk_y(200)) withButtonType:KKButton_Main_TestPoint];
    [self.view addSubview:_testPointView];
    
    _testPointView.titleLab.text =KKLanguage(@"lab_main_test_point");
    [_testPointView.testButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    float tabBarHeight = self.tabBarController.tabBar.frame.size.height;
    
    _deviceBgView = [[HJDeviceBgView alloc] initWithFrame:CGRectMake(0, _testPointView.frame.size.height+_testPointView.frame.origin.y, KKSceneWidth, KKSceneHeight-(_testPointView.frame.size.height+_testPointView.frame.origin.y)-tabBarHeight)];
    [self.view addSubview:_deviceBgView];
    
}

#pragma mark ============== 刷新界面 ===============
- (void)refreshUI{

    /*
     测量位置
     */
    HJPositionModel * positionModel = [[HJCommon shareInstance] currectPositionToString];
    
    /*
     测量功能 脂肪/肌肉
     */
    HJTestFunctionModel * functionModel = [[HJCommon shareInstance] currectFunctionToString];
    
    /*
     测量视图
     */
    if (functionModel.functionValue == KKTest_Function_Fat) {
        
        self.functionView.fatView.hidden = NO;
        self.functionView.muslceView.hidden = YES;
        
        self.functionView.fatBtn.selected = YES;
        self.functionView.muslceBtn.selected = NO;
        
    }else{
        
        self.functionView.fatView.hidden = YES;
        self.functionView.muslceView.hidden = NO;
        
        self.functionView.fatBtn.selected = NO;
        self.functionView.muslceBtn.selected = YES;
    }
    
    _testPointView.textLab.text = [NSString stringWithFormat:@"%@ | %@",positionModel.name,functionModel.name];
    _testPointView.topImageView.image = [UIImage imageNamed:positionModel.selImageName];
    
 
    
    
    [_testAccountView.topImageView sd_setImageWithURL:[NSURL URLWithString:[HJCommon shareInstance].selectModel.avatar] placeholderImage:[UIImage imageNamed:@"img_me_userinfo_photo_s"]];
    _testAccountView.topImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    if ([[HJCommon shareInstance].selectModel.id isEqualToString:KKAccount_TestId]) {
        _testAccountView.topImageView.image = [UIImage imageNamed:@"img_bg_guest"];
    }

    /*
     用户视图
     */
    NSString * nickName = [HJCommon shareInstance].selectModel.userName;

    self.testAccountView.textLab.text = nickName;
    
    /*
     刷新gif
     */
    [self refreshGIF];

}
- (HJBLEStatusView *)BLEStatusView{
    
    if(!_BLEStatusView){
        _BLEStatusView = [[HJBLEStatusView alloc] initWithFrame:CGRectMake(0, KKStatusBarHeight, KKSceneWidth/2, 44)];
    }
    return _BLEStatusView;
}

- (HJMaskView *)maskView{
    
    SW(sw);
    if (!_maskView) {
        
        _maskView=[HJMaskView makeViewWithMask:self.view.frame];
        _maskView.resultblock = ^{
            
            sw.maskView = nil;
            
            if (sw.deviceListView.hidden == NO) {
                [sw hideMaskViewSubview:sw.deviceListView];
                [sw cancelSearchDevice];
            }
            
            if (sw.functionView.hidden == NO) {
                [sw hideMaskViewSubview:sw.functionView];
                
            }
            
            if (sw.accountListView.hidden == NO) {
                [sw hideMaskViewSubview:sw.accountListView];
               
            }
            
        };
        
    }
    return _maskView;
}

- (HJFunctionView *)functionView{
    
    SW(sw);
    
    float height;

    if ([[HJCommon shareInstance].selectModel.id isEqualToString:KKAccount_TestId]) {
        height = kk_y(1100);
    }else{
        height = kk_y(900);
    }


    if (!_functionView) {
        
        _functionView = [[HJFunctionView alloc] initWithFrame:CGRectMake(0, KKSceneHeight, KKSceneWidth, height) withViewType:KKViewType_testPoint_select];
    }
   

    
    [_functionView.fatBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_functionView.muslceBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    _functionView.selectSexBlock = ^(UIButton * _Nonnull sender) {
        
        sw.functionView.sexBtnSel.selected = NO;
        sw.functionView.sexBtnSel = sender;
        sw.functionView.sexBtnSel.selected = YES;
        
        [[HJCommon shareInstance] saveTestSex:sender.tag];
        
        [HJCommon shareInstance].selectModel.sex = [NSString stringWithFormat:@"%ld",(long)sender.tag];
        
    };
    
    _functionView.selectFatBlock = ^(UIButton * _Nonnull sender) {
        
        sw.functionView.fatviewBtnSel.selected = NO;
        sw.functionView.fatviewBtnSel = sender;
        sw.functionView.fatviewBtnSel.selected = YES;
        
        [[HJCommon shareInstance] saveTestFunctionPosition:sender.tag];
        
        [sw hideMaskViewSubview:sw.functionView];
        
        [sw refreshUI];
        
        /*
         发送部位通知
         */
        [[NSNotificationCenter defaultCenter] postNotificationName:KKPosition_Change object:nil];
        
    };
    
    _functionView.selectMuscleBlock = ^(UIButton * _Nonnull sender) {
        
        sw.functionView.muslceViewBtnSel.selected = NO;
        sw.functionView.muslceViewBtnSel = sender;
        sw.functionView.muslceViewBtnSel.selected = YES;
        
        [[HJCommon shareInstance] saveTestFunctionPosition:sender.tag];
        
        [sw hideMaskViewSubview:sw.functionView];
        
        [sw refreshUI];
    
        /*
         发送部位通知
         */
        [[NSNotificationCenter defaultCenter] postNotificationName:KKPosition_Change object:nil];
     
    };
    
    return _functionView;
}

- (HJFunctionView *)deviceListView{
    
   
    if (!_deviceListView) {
        
        _deviceListView = [[HJFunctionView alloc] initWithFrame:CGRectMake(0, KKSceneHeight, KKSceneWidth, [self deviceViewHeight]) withViewType:KKViewType_DeviceList];
        
    }
    
    _deviceListView.deviceTableView.delegate = self;
    _deviceListView.deviceTableView.dataSource = self;
    
    [_deviceListView.cancelBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return _deviceListView;
}

- (HJFunctionView *)accountListView{
    
    if (!_accountListView) {
        
        _accountListView = [[HJFunctionView alloc] initWithFrame:CGRectMake(0, KKSceneHeight, KKSceneWidth, [self accountViewHeight]) withViewType:KKViewType_AccountList];
        
    }
    
    _accountListView.accountTableView.delegate = self;
    _accountListView.accountTableView.dataSource = self;
    
    [_accountListView.addAccountBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return _accountListView;
}
#pragma mark ============== 隐藏视图 ===============
- (void)hideMaskViewSubview:(UIView*)view{
    
    self.maskView.hidden = view.hidden = YES;
    view.frame =CGRectMake(view.frame.origin.x, KKSceneHeight, view.frame.size.width, view.frame.size.height);
    
}

- (void)showMaskViewSubview:(UIView*)view{

    [self.maskView addSubview:view];
    self.maskView.hidden = view.hidden = NO;
    
    [UIView animateWithDuration:0.2 animations:^{
        view.frame = CGRectMake(view.frame.origin.x, KKSceneHeight - view.frame.size.height, view.frame.size.width, view.frame.size.height);
    }];
    
}
#pragma mark ============== 获取成员列表 ===============
- (void)getAccountList{
    
    [self showLoadingInView:self.view time:KKTimeOut title:KKLanguage(@"lab_common_loading")];
    
    [KKHttpRequest HttpRequestType:k_POST withrequestType:NO withDataString:nil withUrl:KK_URL_api_fat_member_list withSuccess:^(id result, NSDictionary *resultDic, HJHTTPModel *model) {
        
        if (model.code == KKStatus_success) {
            
            [self showToastInView:self.view time:KKToastTime title:model.msg];
        
            NSMutableArray * modelArr = [HJUserInfoModel arrayOfModelsFromDictionaries:model.data error:nil];
            
            NSMutableArray * accountArr = [NSMutableArray array];
            
            for (HJUserInfoModel * obj in modelArr) {
                obj.firstCharactor =[[HJCommon shareInstance] firstCharactor:obj.userName];
                [accountArr addObject:obj];
            }
            
            modelArr = [accountArr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                
                HJUserInfoModel * mod1 = obj1;
                HJUserInfoModel * mod2 = obj2;
                return [mod1.firstCharactor compare:mod2.firstCharactor options:NSCaseInsensitiveSearch];
            }];
            
            [self initDataAccount:modelArr];
            
        }else{
            
            [self showToastInView:self.view time:KKToastTime title:model.msg];
            [self initDataAccount:nil];
        }
        
        
        [self showMaskViewSubview:self.accountListView];
        
        [self accountListViewChange];
    
        
    } withError:^(id result, NSDictionary *resultDic, HJHTTPModel *model) {
    
        [self initDataAccount:nil];
        
        [self showToastInView:self.view time:KKToastTime title:KKLanguage(@"tips_fail")];
        
        [self showMaskViewSubview:self.accountListView];
        
        [self accountListViewChange];
        
    }];
    
}

#pragma mark ============== 点击事件 ===============
- (void)rightBtnTwoClick:(UIButton*)sender{
    
    if (sender.tag == KKButton_Device_Info) {
        
        HJDeviceInfoVC * vc = [[HJDeviceInfoVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;   //关键代码 （隐藏tabBar）
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if(sender.tag == KKButton_SearchBLE){
        
        [self searchDevice];
        
        [self showMaskViewSubview:self.deviceListView];
        
        [self deviceViewChange];
        
    }
    
}

- (void)btnClick:(UIButton*)sender{
    

    if (sender.tag == KKButton_Main_TestAccount) {
        
        [self getAccountList];
    
        
    }else if (sender.tag == KKButton_Main_TestPoint){
        
        [self showMaskViewSubview:self.functionView];
        
        BOOL isShow;
        
        if ([[HJCommon shareInstance].selectModel.id isEqualToString:KKAccount_TestId]) {
       
            isShow = YES;
            
        }else{
          
            isShow = NO;
        }
        
        [_functionView showSexView:isShow];
        
        
        [self refreshUI];
        
        
    }else if (sender.tag == KKButton_Main_TestPoint_fat){
        
        [[HJCommon shareInstance] saveTestFunction:KKTest_Function_Fat];
        [[HJCommon shareInstance] saveTestFunctionPosition:self.functionView.fatviewBtnSel.tag];
    
        [self refreshUI];
        
    }else if (sender.tag == KKButton_Main_TestPoint_muscle){
        
        [[HJCommon shareInstance] saveTestFunction:KKTest_Function_Muscle];
        [[HJCommon shareInstance] saveTestFunctionPosition:self.functionView.muslceViewBtnSel.tag];
        
        [self refreshUI];
        
    }else if (sender.tag == KKButton_Cancel){
        
        [self cancelSearchDevice];
        
        [self hideMaskViewSubview:self.deviceListView];
        
        
    }else if (sender.tag == KKButton_Main_AddAcount){
        
        [self hideMaskViewSubview:self.accountListView];
        
        HJUserInfoVC * vc = [[HJUserInfoVC alloc] init];
        vc.navigationItem.title = KKLanguage(@"lab_main_add_account_title");
        vc.hidesBottomBarWhenPushed = YES;
        vc.userInfoType = KKUserInfoType_add;
        [self.navigationController pushViewController:vc animated:YES];
        
        vc.selectBlock = ^(HJUserInfoModel *userModel) {
            
            [HJCommon shareInstance].selectModel = userModel;
            
            self.testAccountView.textLab.text = userModel.userName;
            [self.testAccountView.topImageView sd_setImageWithURL:[NSURL URLWithString:userModel.avatar] placeholderImage:[UIImage imageNamed:@"img_me_userinfo_photo_s"]];
            
        };
    }
}

#pragma mark ============== UItableview 代理 ===============
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (tableView == self.deviceListView.deviceTableView) {
        
        return 1;
        
    }else{
        
        return 2;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == self.deviceListView.deviceTableView) {
        
        return  self.deviceArr.count;
        
    }else{
        
        NSArray * arr = self.accountArr[section];
        
        return  arr.count;
        
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return KKButtonHeight*1.5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (tableView == self.accountListView.accountTableView) {
        if (section == 0) {
            return CGFLOAT_MIN;
        }
        return kk_y(20);
    }
    
    return CGFLOAT_MIN;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (tableView == self.accountListView.accountTableView) {
        float height = section==0?CGFLOAT_MIN:kk_y(20);
        
        UIView * view = [[UIView alloc] init];
        view.frame = CGRectMake(0, 0, KKSceneWidth, height);
        view.backgroundColor = kkBgGrayColor;
        
        return view;
    }
    
    return nil;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 定义cell标识  每个cell对应一个自己的标识
    NSString *CellIdentifier = [NSString stringWithFormat:@"cell%ld%ld",(long)indexPath.section,(long)indexPath.row];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        //底线
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = kkBgGrayColor;
        lineView.frame = CGRectMake(kk_x(20), KKButtonHeight*1.5 - kk_y(1), KKSceneWidth - 2 * kk_x(20), kk_y(1));
        [cell.contentView addSubview:lineView];
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, KKSceneWidth, KKButtonHeight*1.5);
        btn.tag = indexPath.row;
        btn.accessibilityValue = [NSString stringWithFormat:@"%ld",(long)indexPath.section];
        [cell.contentView addSubview:btn];

        if (tableView == self.deviceListView.deviceTableView) {

            [btn addTarget:self action:@selector(BLEbtnClick:) forControlEvents:UIControlEventTouchUpInside];

        }else{

            [btn addTarget:self action:@selector(AccountbtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            UIImageView * imageView = [[UIImageView alloc] init];
            imageView.frame = CGRectMake(kk_x(40), kk_y(20), KKButtonHeight*1.5 - 2*kk_y(20), KKButtonHeight*1.5 - 2*kk_y(20));
            imageView.tag = 10000;
            imageView.layer.cornerRadius =imageView.frame.size.height/2;
            imageView.layer.masksToBounds = YES;
            [cell.contentView addSubview:imageView];
            
            UILabel * textLabel = [[UILabel alloc] init];
            textLabel.frame = CGRectMake(imageView.frame.size.width+imageView.frame.origin.x+kk_x(40), 0, KKSceneWidth/2, KKButtonHeight*1.5);
            textLabel.font = kk_sizefont(KKFont_Normal);
            textLabel.textColor = kkTextBlackColor;
            textLabel.tag = 10001;
            [cell.contentView addSubview:textLabel];
        
        }
    }

    cell.textLabel.font = kk_sizefont(KKFont_Normal);
    
    return cell;
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.deviceListView.deviceTableView) {
        
        [self deviceTableViewCell:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
        
    }else{
        
        [self accountTableViewCell:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    }
    
}



@end
