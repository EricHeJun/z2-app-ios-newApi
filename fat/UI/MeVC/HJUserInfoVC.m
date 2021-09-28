//
//  HJUserInfoVC.m
//  JiaYueShouYin
//
//  Created by 何军 on 2020/7/3.
//  Copyright © 2020 Eric. All rights reserved.
//

#import "HJUserInfoVC.h"
#import <SDWebImage/SDWebImage.h>

#define KKMinHeight 50
#define KKMaxHeight 250

#define KKMinWeight 20
#define KKMaxWeight 160

@interface HJUserInfoVC ()<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,TZImagePickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>{

    UIButton * _iconImageBtn;
    
    UIButton * _nicknameBtn;
    UIButton * _sexBtn;
    UIButton * _birthdayBtn;
    UIButton * _heightBtn;
    UIButton * _weightBtn;
    
    UIButton * _userInfoSaveBtn;
    
    UIImage * _selImage;
    
}

@property (strong,nonatomic)UITableView * tableView;
@property (strong,nonatomic)UIView * headView;

@property (strong,nonatomic)NSArray * imageArr;

@property (strong,nonatomic)NSArray * sexArr;
@property (strong,nonatomic)NSArray * heightArr;
@property (strong,nonatomic)NSArray * weightArr;

@property (assign,nonatomic)int sexIndex;
@property (assign,nonatomic)int heightIndex;
@property (assign,nonatomic)int weightIndex;



@end

@implementation HJUserInfoVC


- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KKAccount_Edit_Photo object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addNavBackgroundColor:KKBgYellowColor];
    
    [self initData];
    [self initUI];
    
}
- (void)initData{
    
    /*
     默认状态
     */
    _sexIndex = 0;
    _heightIndex = 170 - KKMinHeight;
    _weightIndex = 60 - KKMinWeight;
    
    if (self.userInfoType == KKUserInfoType_add){
        /*
         添加
         */
        self.userModel = [[HJUserInfoModel alloc] init];
        self.userModel.userId =  [HJCommon shareInstance].userInfoModel.userId;
        self.userModel.sex = @"1";  //默认为男
        
        
    }else if (self.userInfoType == KKUserInfoType_self) {
        /*
         个人中心
         */
        self.userModel = [HJCommon shareInstance].userInfoModel;
        
        if (self.userModel.sex == nil) {
            self.userModel.sex = @"1";  //默认为男
        }
        
    }else{
        
        /*
         编辑其他人
         */
        self.userModel.ossHeadImageUrl = self.userModel.httpHeadImage;
    }
    
    
    
    self.imageArr = [NSArray arrayWithObjects:
                    
                    KKLanguage(@"img_me_userinfo_nick"),
                    KKLanguage(@"img_me_userinfo_sex"),
                    KKLanguage(@"img_me_userinfo_birthday"),
                    KKLanguage(@"img_me_userinfo_height"),
                    KKLanguage(@"img_me_userinfo_weight"),
                    
                    nil];
    
    
    self.dataArr = [NSArray arrayWithObjects:
                    
                    KKLanguage(@"lab_me_userInfo_name"),
                    KKLanguage(@"lab_me_userInfo_sex"),
                    KKLanguage(@"lab_me_userInfo_birthday"),
                    KKLanguage(@"lab_me_userInfo_height"),
                    KKLanguage(@"lab_me_userInfo_weight"),
                    
                    nil];
    
    self.sexArr = @[KKLanguage(@"lab_me_userInfo_sex_man"),
                  KKLanguage(@"lab_me_userInfo_sex_woman")];
    
    
    NSMutableArray * heightArr = [NSMutableArray array];
    for (int i = KKMinHeight; i<KKMaxHeight+1; i++) {
        [heightArr addObject:[NSString stringWithFormat:@"%dcm",i]];
    }
    
    self.heightArr = [NSArray arrayWithArray:heightArr];
    
    NSMutableArray * weightArr = [NSMutableArray array];
    for (int i = KKMinWeight; i<KKMaxWeight+1; i++) {
        [weightArr addObject:[NSString stringWithFormat:@"%dkg",i]];
    }
    
    self.weightArr = [NSArray arrayWithArray:weightArr];
    
}

- (void)initUI{
    
    self.view.backgroundColor = kkWhiteColor;
    [self.view addSubview:self.tableView];
    
}

#pragma mark ============== 刷新界面 ===============
- (void)refreshUI{
    
 
    [_nicknameBtn setTitle:self.userModel.userName.length?self.userModel.userName:KKLanguage(@"lab_me_userInfo_no_setting") forState:UIControlStateNormal];
    
    NSString * imageStr = [self.userModel.sex isEqualToString:@"1"]?@"img_me_userinfo_man":@"img_me_userinfo_woman";
    [_sexBtn setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
    

    [_birthdayBtn setTitle:self.userModel.birthday.length?self.userModel.birthday:KKLanguage(@"lab_me_userInfo_no_setting") forState:UIControlStateNormal];
    
    [_heightBtn setTitle:self.userModel.height.length?self.userModel.height:KKLanguage(@"lab_me_userInfo_no_setting") forState:UIControlStateNormal];
    
    [_weightBtn setTitle:self.userModel.weight.length?self.userModel.weight:KKLanguage(@"lab_me_userInfo_no_setting") forState:UIControlStateNormal];
    
    [_iconImageBtn sd_setImageWithURL:[NSURL URLWithString:self.userModel.ossHeadImageUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"img_me_userinfo_photo_l"]];
    
    _iconImageBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;

    
    if ([self.userModel.sex isEqualToString:@"1"]) {
        _sexIndex = 0;
    }else{
        _sexIndex = 1;
    }

    if ([self.userModel.height hasSuffix:@"cm"]) {
        
        NSString * height = [self.userModel.height substringToIndex:self.userModel.height.length-2];
        NSLog(@"height:%@",height);
        _heightIndex = [height intValue] - KKMinHeight;
    }
    
    if ([self.userModel.weight hasSuffix:@"kg"]) {
        
        NSString * weight = [self.userModel.weight substringToIndex:self.userModel.weight.length-2];
        NSLog(@"weight:%@",weight);
        _weightIndex = [weight intValue] - KKMinWeight;
    }
    

}

- (HJMaskView *)maskView{
    
    SW(sw);
    if (!_maskView) {
        
        _maskView=[HJMaskView makeViewWithMask:self.view.frame];
        _maskView.resultblock = ^{
            
            sw.maskView = nil;
            
            [sw hideMaskViewSubview:sw.sexView];
            [sw hideMaskViewSubview:sw.birthdayView];
            [sw hideMaskViewSubview:sw.weightView];
            [sw hideMaskViewSubview:sw.heightView];
     
        };
        
    }
    return _maskView;
}

- (HJUserInfoView *)sexView{
    
    SW(sw);
    
    if (!_sexView) {
        
        HJUserInfoView *view = [[HJUserInfoView alloc] initWithFrame:CGRectMake(0, KKSceneHeight, KKSceneWidth, kk_y(500)) withType:KKViewType_Userinfo_sex_height_weight];
        _sexView = view;
    }
    
    _sexView.titleLab.text = KKLanguage(@"lab_me_userInfo_sex");
    _sexView.pickerView.dataSource = self;
    _sexView.pickerView.delegate = self;
    
    [_sexView.pickerView selectRow:_sexIndex inComponent:0 animated:NO];
    
    _sexView.selectBlock = ^(UIButton * _Nonnull sender) {
        
        [sw hideMaskViewSubview:sw.sexView];
        
        if (sender.tag == KKButton_Cancel) {
            
        }else if (sender.tag == KKButton_Confirm){
            
            if (sw.sexIndex == 0) {
                [self->_sexBtn setImage:[UIImage imageNamed:@"img_me_userinfo_man"] forState:UIControlStateNormal];
            }else if(sw.sexIndex == 1){
                [self->_sexBtn setImage:[UIImage imageNamed:@"img_me_userinfo_woman"] forState:UIControlStateNormal];
            }
            
            if (sw.userInfoType == KKUserInfoType_add) {
                return;
            }
            
            [sw jointData:nil url:nil];
        }
    };
    
    return _sexView;
}
- (HJUserInfoView *)heightView{
    
    SW(sw);
    
    if (!_heightView) {
        
        HJUserInfoView *view = [[HJUserInfoView alloc] initWithFrame:CGRectMake(0, KKSceneHeight, KKSceneWidth, kk_y(500)) withType:KKViewType_Userinfo_sex_height_weight];
        _heightView = view;
    }
    
    _heightView.titleLab.text = KKLanguage(@"lab_me_userInfo_height");
    _heightView.pickerView.dataSource = self;
    _heightView.pickerView.delegate = self;
    
    [_heightView.pickerView selectRow:_heightIndex inComponent:0 animated:NO];
    
    _heightView.selectBlock = ^(UIButton * _Nonnull sender) {
        
        [sw hideMaskViewSubview:sw.heightView];
        
        if (sender.tag == KKButton_Cancel) {
            
            
        }else if (sender.tag == KKButton_Confirm){
            
            if (sw.heightIndex>=0) {
                [self->_heightBtn setTitle:sw.heightArr[sw.heightIndex] forState:UIControlStateNormal];
            }
            
            if (sw.userInfoType == KKUserInfoType_add) {
                return;
            }
            
            [sw jointData:nil url:nil];
        }
    };
    
    return _heightView;
}

- (HJUserInfoView *)weightView{
    
    SW(sw);
    
    if (!_weightView) {
        
        HJUserInfoView *view = [[HJUserInfoView alloc] initWithFrame:CGRectMake(0, KKSceneHeight, KKSceneWidth, kk_y(500)) withType:KKViewType_Userinfo_sex_height_weight];
        _weightView = view;
    }
    
    _weightView.titleLab.text = KKLanguage(@"lab_me_userInfo_weight");
    _weightView.pickerView.dataSource = self;
    _weightView.pickerView.delegate = self;
    
    [_weightView.pickerView selectRow:_weightIndex inComponent:0 animated:NO];
    
    _weightView.selectBlock = ^(UIButton * _Nonnull sender) {
        
        [sw hideMaskViewSubview:sw.weightView];
        
        if (sender.tag == KKButton_Cancel) {
            
        }else if (sender.tag == KKButton_Confirm){
            
            if (sw.weightIndex>=0) {
                [self->_weightBtn setTitle:sw.weightArr[sw.weightIndex] forState:UIControlStateNormal];
            }
            
            if (sw.userInfoType == KKUserInfoType_add) {
                return;
            }
            
            [sw jointData:nil url:nil];
        }
    };
    
    return _weightView;
}


- (HJUserInfoView *)birthdayView{
    
    SW(sw);
    
    if (!_birthdayView) {
        
        HJUserInfoView *view = [[HJUserInfoView alloc] initWithFrame:CGRectMake(0, KKSceneHeight, KKSceneWidth, kk_y(500)) withType:KKViewType_Userinfo_birthday];
        _birthdayView = view;
    }
    
    _birthdayView.titleLab.text = KKLanguage(@"lab_me_userInfo_birthday");
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy/MM/dd";
    
    if (self.userModel.birthday.length) {
        _birthdayView.datePicker.date = [formatter dateFromString:self.userModel.birthday];
    }
    
    [_birthdayView.datePicker addTarget:self action:@selector(timeChanged:) forControlEvents:UIControlEventValueChanged];
    
    _birthdayView.selectBlock = ^(UIButton * _Nonnull sender) {
        
        [sw hideMaskViewSubview:sw.birthdayView];
        
        if (sender.tag == KKButton_Cancel) {
            
            
        }else if (sender.tag == KKButton_Confirm){
            
            if (sw.userInfoType == KKUserInfoType_add) {
                return;
            }
            
            [sw jointData:nil url:nil];
        }
    };
    
    return _birthdayView;
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
        tableview.tableHeaderView = self.headView;
        
        _tableView = tableview;
    }
    
    return _tableView;
}
- (UIView*)headView{
    
    if (!_headView) {
        
        UIView * view = [[UIView alloc] init];
        view.frame = CGRectMake(0, 0, KKSceneWidth, kk_y(310));
        _headView = view;
        
        UIImage * image =[UIImage imageNamed:@"img_me_userinfo_photo_l"];
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(KKSceneWidth/2-image.size.width/2, kk_y(60), image.size.width, image.size.height);
        [btn setImage:image forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = KKButton_Me_userInfo_savePhoto;
        btn.layer.cornerRadius = btn.frame.size.height/2;
        btn.layer.masksToBounds = YES;
        [view addSubview:btn];
        _iconImageBtn = btn;
    
    }
    
    return _headView;
}
#pragma mark ============== pickerviewdelegate ===============
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (pickerView == _sexView.pickerView ||
        pickerView == _heightView.pickerView ||
        pickerView == _weightView.pickerView ) {
        return 1;
    }
    return 0;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (pickerView == _sexView.pickerView) {
        return self.sexArr.count;
    }else if (pickerView == _heightView.pickerView){
        return self.heightArr.count;
    }else if (pickerView == _weightView.pickerView){
        return self.weightArr.count;
    }
    
    return 0;
}
//返回指定列，行的高度，就是自定义行的高度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    
    return KKButtonHeight;
    
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view API_UNAVAILABLE(tvos){
    
    UILabel * lab =[[UILabel alloc] init];;
    lab.textAlignment = NSTextAlignmentCenter;
    lab.adjustsFontSizeToFitWidth=YES;
    
    if (pickerView == _sexView.pickerView) {
        lab.text = self.sexArr[row];
    }else if (pickerView == _heightView.pickerView){
        lab.text = self.heightArr[row];
    }else if (pickerView == _weightView.pickerView){
        lab.text = self.weightArr[row];
    }
    
    return lab;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component API_UNAVAILABLE(tvos){
    
    if (pickerView == _sexView.pickerView) {
        _sexIndex = (int)row;
    }else if (pickerView == _heightView.pickerView){
        _heightIndex = (int)row;
    }else if (pickerView == _weightView.pickerView){
        _weightIndex= (int)row;
    }
    
}

#pragma mark ============== tableviewdelegate ===============
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return KKButtonHeight * 2;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView * view = [[UIView alloc] init];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(kk_x(40), KKButtonHeight, KKSceneWidth - 2*kk_x(40), KKButtonHeight);
    btn.backgroundColor = KKBgYellowColor;
    [btn setTitleColor:kkWhiteColor forState:UIControlStateNormal];
    btn.titleLabel.font = kk_sizefont(KKFont_Normal);
    [view addSubview:btn];
    btn.tag = KKButton_Me_userInfo_save;
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    _userInfoSaveBtn = btn;
    
   
    if (self.userInfoType == KKUserInfoType_add){
        /*
         添加
         */
        [_userInfoSaveBtn setTitle:KKLanguage(@"lab_me_userInfo_save") forState:UIControlStateNormal];
        
        
    }else if (self.userInfoType == KKUserInfoType_self) {
        /*
         个人中心
         */
        [_userInfoSaveBtn setTitle:KKLanguage(@"lab_me_userInfo_save") forState:UIControlStateNormal];
        _userInfoSaveBtn.hidden = YES;
        
    }else{
        
        /*
         编辑其他人
         */
        [_userInfoSaveBtn setTitle:KKLanguage(@"lab_me_userInfo_delete") forState:UIControlStateNormal];
        
    }
    
    return view;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    // 定义cell标识  每个cell对应一个自己的标识
    NSString *CellIdentifier = [NSString stringWithFormat:@"cell%ld%ld",(long)indexPath.section,(long)indexPath.row];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        //底线
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = kkBgGrayColor;
        lineView.frame = CGRectMake(kk_x(20), KKButtonHeight*1.5 - kk_y(1), KKSceneWidth - 2 * kk_x(20), kk_y(1));
        lineView.tag = 10;
        [cell.contentView addSubview:lineView];
        
        
        if (indexPath.section == 0) {
            
            UIImage * image = [UIImage imageNamed:@"img_common_next"];
            
            UIImageView * nextImageView = [[UIImageView alloc] init];
            nextImageView.image =image;
            
            nextImageView.frame = CGRectMake(KKSceneWidth - image.size.width - kk_x(40), KKButtonHeight*1.5/2-image.size.height/2, image.size.width, image.size.height);
            [cell.contentView addSubview:nextImageView];
            
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(nextImageView.frame.origin.x-kk_x(180), 0, kk_x(150), KKButtonHeight*1.5);
            [btn setTitleColor:kkTextBlackColor forState:UIControlStateNormal];
            btn.titleLabel.font = kk_sizefont(KKFont_small_large);
            btn.tag = 100;
            btn.userInteractionEnabled = NO;
            [cell.contentView addSubview:btn];
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            
        }
    }
    
    NSString * title = self.dataArr[indexPath.row];
    
    UIButton * btn = (UIButton*)[cell.contentView viewWithTag:100];
    
    if ([title isEqualToString:KKLanguage(@"lab_me_userInfo_name")]) {
        
        _nicknameBtn = btn;
    
    }else if ([title isEqualToString:KKLanguage(@"lab_me_userInfo_sex")]) {
        
        _sexBtn = btn;
        
    }else if([title isEqualToString:KKLanguage(@"lab_me_userInfo_birthday")]){
        
        _birthdayBtn = btn;
        
    }else if([title isEqualToString:KKLanguage(@"lab_me_userInfo_height")]){
        
        _heightBtn = btn;
        
        
    }else if([title isEqualToString:KKLanguage(@"lab_me_userInfo_weight")]){
        
        _weightBtn = btn;
        
    }
    
    cell.imageView.image = [UIImage imageNamed:self.imageArr[indexPath.row]];
    cell.textLabel.text = title;
    
    return cell;
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
        [self refreshUI];
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell.textLabel.text isEqualToString:KKLanguage(@"lab_me_userInfo_name")]) {
        
        HJNickNameVC * vc = [[HJNickNameVC alloc] init];
        vc.navigationItem.title = KKLanguage(@"lab_me_userInfo_name_edit");
        
        NSString * name = _nicknameBtn.titleLabel.text;
        
        if ([name isEqualToString:KKLanguage(@"lab_me_userInfo_no_setting")]) {
            name = @"";
        }
        
        vc.nickName =name;
        [self.navigationController pushViewController:vc animated:YES];
        
        vc.selectBlock = ^(NSString * _Nonnull nickName) {
            
            [self->_nicknameBtn setTitle:nickName forState:UIControlStateNormal];
            
            if (self.userInfoType == KKUserInfoType_add) {
                return;
            }
            
            [self jointData:nil url:nil];
            
        };
        
    }else if ([cell.textLabel.text isEqualToString:KKLanguage(@"lab_me_userInfo_sex")]) {
        
        [self showMaskViewSubview:self.sexView];
        
    }else if ([cell.textLabel.text isEqualToString:KKLanguage(@"lab_me_userInfo_birthday")]) {
        
        [self showMaskViewSubview:self.birthdayView];
        
    }else if ([cell.textLabel.text isEqualToString:KKLanguage(@"lab_me_userInfo_height")]) {
        
        [self showMaskViewSubview:self.heightView];
        
    }else if ([cell.textLabel.text isEqualToString:KKLanguage(@"lab_me_userInfo_weight")]) {
        
        [self showMaskViewSubview:self.weightView];
        
    }
    
}
#pragma mark ============== 点击事件 ===============
- (void)btnClick:(UIButton*)sender{
    
    SW(sw);
    
    if(sender.tag == KKButton_Me_userInfo_save){
        
        if (_nicknameBtn.titleLabel.text.length == 0){
        
            [self showToastInView:self.view time:KKToastTime title:KKLanguage(@"lab_me_userInfo_name_enter")];
            
            return;
        }
        
        if ([_nicknameBtn.titleLabel.text isEqualToString:KKLanguage(@"lab_me_userInfo_no_setting")]&&self.userInfoType==KKUserInfoType_add) {
            
            [self showToastInView:self.view time:KKToastTime title:KKLanguage(@"lab_me_userInfo_name_enter")];
            
            return;
        }
        
        if ([_nicknameBtn.titleLabel.text isEqualToString:KKLanguage(@"lab_me_userInfo_no_setting")]&&self.userInfoType==KKUserInfoType_self) {
            
            [self showToastInView:self.view time:KKToastTime title:KKLanguage(@"lab_me_userInfo_name_enter")];
            
            return;
        }
    
        
        [self showLoadingInView:self.view time:KKTimeOut title:KKLanguage(@"lab_common_loading")];
        

        if (self.userInfoType == KKUserInfoType_add) {
            
            [self uploadImage:^(BOOL result, NSArray<NSString *> * _Nonnull nameArray) {
                
                if (result) {
                    
                    [sw jointData:[nameArray firstObject] url:nil];
   
                }
            }];
            
        }else if (self.userInfoType == KKUserInfoType_other){
            
            [sw hideLoading];
            
            [sw jointData:nil url:KK_URL_api_fat_member_del];
           
        }
        
    }else if(sender.tag == KKButton_Me_userInfo_savePhoto){
        
        SW(sw);
        [self showAlertSheetTitle:@"" message:@"" dataArr:@[KKLanguage(@"lab_me_setUser_Profile_select_2"),KKLanguage(@"lab_me_setUser_Profile_select_1")] callback:^(NSInteger index, NSString * _Nonnull titleString) {
            
            if (index == 0) {
                
                [sw requestCameraAuthorization];
                
            }else if (index == 1){
                
                [sw getPicture];
                
            }
            
        }];
    }
}
#pragma mark ============== 拼接数据 ===============
- (void)jointData:(NSString*)headImageUrl url:(NSString*)url{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        HJUserInfoModel * model = [[HJUserInfoModel alloc] init];
    
        model.userName = _nicknameBtn.titleLabel.text;
        model.sex = _sexIndex==0?@"1":@"0";
        model.birthday = _birthdayBtn.titleLabel.text;
        model.height = _heightBtn.titleLabel.text;
        model.weight = _weightBtn.titleLabel.text;
        
        model.avatar = headImageUrl.length?headImageUrl:self.userModel.avatar;
        
        if (self.userInfoType == KKUserInfoType_other) {
            model.id = self.userModel.id;
        }
        
        NSDictionary * dic = [model toDictionary];
        
        
        if ([url isEqualToString:KK_URL_api_fat_member_del]) {
            
            [self showAlertSheetTitle:KKLanguage(@"lab_me_userInfo_delete_tips") message:nil dataArr:@[KKLanguage(@"lab_chat_delete")] callback:^(NSInteger index, NSString *titleString) {
                
                if ([titleString isEqualToString:KKLanguage(@"lab_chat_delete")]) {
                    
                    [self showLoadingInView:self.view time:KKTimeOut title:KKLanguage(@"lab_common_loading")];
                    
                    [self editAccount:dic withUrl:url];
                }
                
            }];
            
        }else{
            
            if (self.userInfoType == KKUserInfoType_self) {
                
                [self editAccount:dic withUrl:KK_URL_api_fat_member_modify];
                
            }else{
                
                [self editAccount:dic withUrl:KK_URL_api_fat_member_submit];
                
            }
            
        }
    });
    
    
    
}

#pragma mark ============== 上传头像 ===============
- (void)uploadImage:(ImageCallback)success {
    
    [[HJOSSUpload aliyunInit] uploadImage:@[_iconImageBtn.imageView.image] success:^(BOOL result, NSArray<NSString *> * _Nonnull nameArray) {
        success(result,nameArray);
        if (result == NO) {
            
            [self showToastInWindows:KKToastTime title:KKLanguage(@"tips_fail")];
        }
    }];
}

#pragma mark ============== 上传数据 ===============
- (void)editAccount:(NSDictionary*)dic withUrl:(NSString*)url{
    
    [KKHttpRequest HttpRequestType:k_POST withrequestType:NO withDataString:dic withUrl:url withSuccess:^(id result, NSDictionary *resultDic, HJHTTPModel *model) {
        
        if (model.code == KKStatus_success ) {
            
            HJUserInfoModel * userModel = [[HJUserInfoModel alloc] initWithDictionary:model.data error:nil];
            
            if (self.userInfoType == KKUserInfoType_self){
                
                /*
                 插入本地数据库
                 */
                
                if (self.userInfoType == KKUserInfoType_self) {
                    [HJFMDBModel userInfoInsert:userModel];
                    [HJCommon shareInstance].userInfoModel = userModel;
                }
                
                if(self.selectBlock){
                    self.selectBlock(userModel);
                }
                
                [self showToastInWindows:KKToastTime title:model.msg];
                
            }else if (self.userInfoType == KKUserInfoType_add){
                
                if(self.selectBlock){
                    self.selectBlock(userModel);
                }
                
                [self showToastInWindows:KKToastTime title:model.msg];
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }else if (self.userInfoType == KKUserInfoType_other){
                
                if ([url isEqualToString:KK_URL_api_fat_member_del]) {
                    
                    [self showToastInWindows:KKToastTime title:model.msg];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }else if ([url isEqualToString:KK_URL_api_fat_member_submit]){
                    
                    [self showToastInWindows:KKToastTime title:model.msg];
                }
                
            }
            
            NSLog(@"%@ %@",[HJCommon shareInstance].selectModel.userId,[HJCommon shareInstance].selectModel.id);
            
            if ([[HJCommon shareInstance].selectModel.userId isEqualToString:userModel.userId] ) {
                
                if ([[HJCommon shareInstance].selectModel.id intValue] == [userModel.id intValue]) {
                    
                    [HJCommon shareInstance].selectModel.sex = userModel.sex;
                }
            }
            
            
            
        }else{
            
            [self showToastInView:self.view time:KKToastTime title:model.msg];
        }
        
    } withError:^(id result, NSDictionary *resultDic, HJHTTPModel *model) {
        
        [self showToastInView:self.view time:KKToastTime title:KKLanguage(@"tips_fail")];
    }];
    
}

- (void)timeChanged:(UIDatePicker *)datePicker{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy/MM/dd";
    
    NSString * string   = [formatter stringFromDate:datePicker.date];
    
    [_birthdayBtn setTitle:string forState:UIControlStateNormal];
    
    NSLog(@"%@",string);
    
}

- (void)getPicture{
    
    SW(sw);
    TZImagePickerController *imagePC=[[TZImagePickerController alloc]initWithMaxImagesCount:1 delegate:self];//设置多选最多支持的最大数量，设置代理
    imagePC.allowTakePicture = NO;
    imagePC.allowTakeVideo = NO;
    imagePC.allowPickingVideo = NO;
    imagePC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePC animated:YES completion:nil];//跳转
    
    [imagePC setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
        UIImage * image = [photos firstObject];
        
        self->_selImage = image;
        
        [sw refreshPictureView:NO];
        
    }];
}

- (void)refreshPictureView:(BOOL)isShowDelete{
    
    [_iconImageBtn setImage:_selImage forState:UIControlStateNormal];
    _iconImageBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    SW(sw);
   
    if (self.userInfoType == KKUserInfoType_add){
        return;
    }
    
    
    [self uploadImage:^(BOOL result, NSArray<NSString *> * _Nonnull nameArray) {
        
        if (result) {
            
           [sw jointData:[nameArray firstObject] url:nil];
            
        }
    }];
    
}

- (void)requestCameraAuthorization{
    
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:( AVMediaTypeVideo)];
    SW(sw);
    if(status == AVAuthorizationStatusNotDetermined){
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(granted) {
                    [sw takePhoto];
                }
            });
        }];
    }else if (status == AVAuthorizationStatusRestricted ||
              status == AVAuthorizationStatusDenied){
        
            NSString *app_Name = [[HJCommon shareInstance]getAppName];
            NSString *title = NSLocalizedString(@"lab_requires_access_camera", @"");
            NSString *msg = [NSString stringWithFormat:NSLocalizedString(@"lab_open_camera_authorization_method", @""),app_Name];
        
        [sw showAlertViewTitle:title message:msg dataArr:@[KKLanguage(@"lab_common_ok")] callback:^(NSInteger index, NSString * _Nonnull titleString) {
            
        }];
    
    }else if (status == AVAuthorizationStatusAuthorized){
        [self takePhoto];
    }
}

- (void)takePhoto{
    SW(sw);
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        //确保主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            if (granted) {
                
                UIImagePickerController *controller = [[UIImagePickerController alloc] init];
                controller.view.backgroundColor = [UIColor redColor];
                controller.modalPresentationStyle = UIModalPresentationFullScreen;
                controller.sourceType = UIImagePickerControllerSourceTypeCamera;
                
                controller.cameraDevice = UIImagePickerControllerCameraDeviceRear;
                
                NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
                [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
                controller.mediaTypes = mediaTypes;
                controller.delegate = sw;
                [sw presentViewController:controller
                                 animated:YES
                               completion:^(void){
                    DLog(@"Picker View Controller is presented");
                }];
            }
            
        });
        
    }];
}
#pragma mark ============== imagePickerController 方法 ===============
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    SW(sw);
    [picker dismissViewControllerAnimated:YES completion:^() {
        
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        self->_selImage = portraitImg;
        [sw refreshPictureView:NO];
        
    }];
}


@end
