//
//  HJSettingVC.m
//  fat
//
//  Created by 何军 on 2021/4/23.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import "HJSettingVC.h"

@interface HJSettingVC ()<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource>

@property (strong,nonatomic)UITableView * tableView;
@property (assign,nonatomic)int depthIndex;

@end

@implementation HJSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initData];
    
    [self.view addSubview:self.tableView];
    
}
- (void)initData{
    
    NSArray * arrOne = @[KKLanguage(@"lab_me_userInfo_text1"),
                         KKLanguage(@"lab_me_userInfo_text2")];
    
    NSArray * arrTwo =@[KKLanguage(@"lab_me_userInfo_text3")];
    
    NSArray * arrThree = @[KKLanguage(@"lab_me_userInfo_text4"),
                           KKLanguage(@"lab_me_userInfo_text5")];
    
    self.dataArr = [NSMutableArray arrayWithObjects:arrOne,arrTwo,arrThree, nil];
    
    
    NSString * unit =[[HJCommon shareInstance] getBLEUnit];
    
    if ([unit isEqualToString:KKBLEParameter_cm]) {
        self.depthIndex = 0;
    }else if ([unit isEqualToString:KKBLEParameter_inch]) {
        self.depthIndex = 1;
    }else if ([unit isEqualToString:KKBLEParameter_mm]) {
        self.depthIndex = 2;
    }
    
}

- (UITableView*)tableView{
    
    if (!_tableView) {
        
        
        UITableView * tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, KKNavBarHeight, KKSceneWidth, KKSceneHeight-KKNavBarHeight) style:UITableViewStylePlain];
        tableview.backgroundColor = self.view.backgroundColor;
        tableview.delegate =self;
        tableview.dataSource = self;
        tableview.showsVerticalScrollIndicator = NO;
        tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableview.rowHeight = KKButtonHeight*1.5;
        
        if (@available(iOS 11.0, *)) {
            tableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        _tableView = tableview;
    }
    
    return _tableView;
}
- (HJMaskView *)maskView{
    
    SW(sw);
    if (!_maskView) {
        
        _maskView=[HJMaskView makeViewWithMask:self.view.frame];
        _maskView.resultblock = ^{
            
            sw.maskView = nil;
            [sw hideMaskViewSubview:sw.depthView];

        };
    }
    return _maskView;
}

- (HJUserInfoView *)depthView{
    
    SW(sw);
    
    if (!_depthView) {
        
        HJUserInfoView *view = [[HJUserInfoView alloc] initWithFrame:CGRectMake(0, KKSceneHeight, KKSceneWidth, kk_y(500)) withType:KKViewType_Userinfo_sex_height_weight];
        _depthView = view;
    }
    
    _depthView.titleLab.text = KKLanguage(@"lab_me_userInfo_text3");
    _depthView.pickerView.dataSource = self;
    _depthView.pickerView.delegate = self;
    
    [_depthView.pickerView selectRow:self.depthIndex inComponent:0 animated:NO];
    
    _depthView.selectBlock = ^(UIButton * _Nonnull sender) {
        
        [sw hideMaskViewSubview:sw.depthView];
        
        if (sender.tag == KKButton_Cancel) {
            
        }else if (sender.tag == KKButton_Confirm){
            
            NSString * str;
            
            if (sw.depthIndex == 0) {
                
                str = KKBLEParameter_cm;
                
            }else if (sw.depthIndex == 1){
                
                str = KKBLEParameter_inch;
                
            }else if (sw.depthIndex == 2){
                
                str = KKBLEParameter_mm;
            }
            
            [[HJCommon shareInstance] saveBLEUnit:str];
            
            NSIndexSet *indexSet1 = [[NSIndexSet alloc] initWithIndex:1];
            
            [sw.tableView reloadSections:indexSet1 withRowAnimation:UITableViewRowAnimationNone];
            
            
            /*
             发送切换单位通知
             */
            [[NSNotificationCenter defaultCenter] postNotificationName:KKAccount_Change object:nil];
        }
    };
    
    
    return _depthView;
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
#pragma mark ============== pickerviewdelegate ===============
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 2;
}
//返回指定列，行的高度，就是自定义行的高度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    
    return KKButtonHeight;
    
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view API_UNAVAILABLE(tvos){
    
    UILabel * lab =[[UILabel alloc] init];;
    lab.textAlignment = NSTextAlignmentCenter;
    lab.adjustsFontSizeToFitWidth=YES;

    if (row == 0) {
        lab.text = KKBLEParameter_cm;
    }else if(row == 1){
        lab.text = KKBLEParameter_inch;
    }else if (row == 2){
        lab.text = KKBLEParameter_mm;
    }
    
    return lab;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.depthIndex = (int)row;
}

#pragma mark ============== tableviewDelegate ===============
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray * arr = self.dataArr[section];
    return arr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGFLOAT_MIN;
    }
    return KKButtonHeight/2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc] init];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = kkBgGrayColor;
    lineView.frame = CGRectMake(kk_x(20), KKButtonHeight/2 - kk_y(1), KKSceneWidth - 2 * kk_x(20), kk_y(1));
  
    [view addSubview:lineView];
    return view;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    // 定义cell标识  每个cell对应一个自己的标识
    NSString *CellIdentifier = [NSString stringWithFormat:@"cell%ld%ld",(long)indexPath.section,(long)indexPath.row];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        //底线
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = kkBgGrayColor;
        lineView.frame = CGRectMake(kk_x(20), KKButtonHeight*1.5 - kk_y(1), KKSceneWidth - 2 * kk_x(20), kk_y(1));
        lineView.tag = 10;
        [cell.contentView addSubview:lineView];
        
    }
    
    NSArray * arr = self.dataArr[indexPath.section];
    
    cell.imageView.image = [UIImage imageNamed:arr[indexPath.row]];
    cell.textLabel.text = arr[indexPath.row];
    cell.textLabel.font = kk_sizefont(KKFont_Normal);
    
    if ([cell.textLabel.text isEqualToString:KKLanguage(@"lab_me_userInfo_text3")]) {
        
        cell.detailTextLabel.text = [[HJCommon shareInstance] getBLEUnit];
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell.textLabel.text isEqualToString:KKLanguage(@"lab_me_userInfo_text1")]) {
        
        
        HJUserInfoVC * vc = [[HJUserInfoVC alloc] init];
        vc.userInfoType= KKUserInfoType_self;
        vc.navigationItem.title = KKLanguage(@"lab_me_userInfo_title");
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([cell.textLabel.text isEqualToString:KKLanguage(@"lab_me_userInfo_text2")]) {
        
        
        HJAccountManageVC * vc = [[HJAccountManageVC alloc] init];
        vc.navigationItem.title = KKLanguage(@"lab_me_userInfo_text2");
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([cell.textLabel.text isEqualToString:KKLanguage(@"lab_me_userInfo_text3")]) {
        
        [self showMaskViewSubview:self.depthView];
        
    }else if ([cell.textLabel.text isEqualToString:KKLanguage(@"lab_me_userInfo_text4")]) {
        
        /*
         app更新 分线程执行
         */
        [self showLoadingInView:self.view time:KKTimeOut title:KKLanguage(@"lab_common_loading")];
        dispatch_queue_t queue =  dispatch_get_global_queue(0, 0);
        dispatch_async(queue, ^{

            [self getAppStoreInfo:YES];
    
        });
        
    }else if ([cell.textLabel.text isEqualToString:KKLanguage(@"lab_me_userInfo_text5")]) {
        
        HJAboutVC * vc = [[HJAboutVC alloc] init];
        vc.navigationItem.title = KKLanguage(@"lab_me_userInfo_text5");
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}


@end
