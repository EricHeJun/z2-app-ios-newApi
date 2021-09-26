//
//  HJAccountManageVC.m
//  fat
//
//  Created by ydd on 2021/4/29.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import "HJAccountManageVC.h"

@interface HJAccountManageVC ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic)UITableView * tableView;
@property (strong,nonatomic)NSArray * imageArr;
@end

@implementation HJAccountManageVC

- (void)viewWillAppear:(BOOL)animated{
    
    [self getUserInfo];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initData];
    
    [self.view addSubview:self.tableView];
    
}
- (void)initData{
    
    self.dataArr = [NSArray arrayWithObjects:
                    KKLanguage(@"lab_me_userInfo_edit_psw"),
                    KKLanguage(@"lab_login_email"),
                    KKLanguage(@"lab_login_phone"),
                    nil];
    
    
    self.imageArr = [NSArray arrayWithObjects:
                    
                    KKLanguage(@"img_account_psw"),
                    KKLanguage(@"img_account_email"),
                    KKLanguage(@"img_account_phone"),
                    
                    nil];
    
}
- (UITableView *)tableView{

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
    btn.tag = KKButton_Account_logout;
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:KKLanguage(@"lab_me_userInfo_logout") forState:UIControlStateNormal];
   

    return view;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
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
    

    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * title = self.dataArr[indexPath.row];
    
    cell.imageView.image = [UIImage imageNamed:self.imageArr[indexPath.row]];
    cell.textLabel.text = title;
    
    if ([title isEqualToString:KKLanguage(@"lab_login_email")]) {
        
        if ([[HJCommon shareInstance].userInfoModel.isEmail boolValue] == YES) {
            cell.detailTextLabel.text = [HJCommon shareInstance].userInfoModel.email;
        }else{
            
            if ([HJCommon shareInstance].userInfoModel.email != nil &&
                [HJCommon shareInstance].userInfoModel.email.length != 0) {
                
                cell.detailTextLabel.text =[NSString stringWithFormat:@"%@(%@)",[HJCommon shareInstance].userInfoModel.email,KKLanguage(@"lab_tips_http_text21")];
                
            }else{
                
                cell.detailTextLabel.text = KKLanguage(@"lab_me_userInfo_no_bind");
            }
        
        }
    
        
    }else if ([title isEqualToString:KKLanguage(@"lab_login_phone")]) {
        
        if ([HJCommon shareInstance].userInfoModel.userName == nil) {
            cell.detailTextLabel.text = KKLanguage(@"lab_me_userInfo_no_bind");
        }else{
            cell.detailTextLabel.text = [HJCommon shareInstance].userInfoModel.userName;
        }
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    

    if ([cell.textLabel.text isEqualToString:KKLanguage(@"lab_me_userInfo_edit_psw")]) {
        
        HJEditPswVC * vc = [[HJEditPswVC alloc] init];
        vc.navigationItem.title = KKLanguage(@"lab_me_userInfo_edit_psw");
        [self.navigationController pushViewController:vc animated:YES];
    
        
    }else if ([cell.textLabel.text isEqualToString:KKLanguage(@"lab_login_email")]) {
        
        
        HJBindEmailVC * vc = [[HJBindEmailVC alloc] init];
        vc.navigationItem.title = KKLanguage(@"lab_me_userInfo_bind_email");
        [self.navigationController pushViewController:vc animated:YES];
        
     
        
    }else if ([cell.textLabel.text isEqualToString:KKLanguage(@"lab_login_phone")]) {
        
        HJBindPhoneVC * vc = [[HJBindPhoneVC alloc] init];
        vc.navigationItem.title = KKLanguage(@"lab_me_userInfo_bind_phone");
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }
    
}
#pragma mark ============== 点击事件 ===============
- (void)btnClick:(UIButton*)sender{
    
    if (sender.tag == KKButton_Account_logout) {
        
        [self showAlertSheetTitle:KKLanguage(@"lab_me_userInfo_logout_title") message:nil dataArr:@[KKLanguage(@"lab_me_userInfo_logout")] callback:^(NSInteger index, NSString *titleString) {
            
            if ([titleString isEqualToString:KKLanguage(@"lab_me_userInfo_logout")]) {
                
                [KKHttpRequest HttpRequestType:k_POST withrequestType:YES withDataString:nil withUrl:KK_URL_api_user_logout withSuccess:^(id result, NSDictionary *resultDic, HJHTTPModel *model) {
                    
                    if (model.code == KKStatus_success) {
                        [[HJCommon shareInstance] logout:NO toast:@""];
                    }else{
                        [self showToastInView:self.view time:KKToastTime title:model.msg];
                    }
                    
                } withError:^(id result, NSDictionary *resultDic, HJHTTPModel *model) {
                    
                }];
            
            }
            
        }];
        
    }
}
#pragma mark ============== 方法 ===============
- (void)getUserInfo{
    
    [self showLoadingInView:self.view time:KKTimeOut title:KKLanguage(@"lab_common_loading")];
    
    HJUserInfoModel * model = [HJUserInfoModel new];
    model.userId = [HJCommon shareInstance].userInfoModel.userId;
    
    
    NSDictionary *dic = [model toDictionary];
    
    [KKHttpRequest HttpRequestType:k_POST withrequestType:NO withDataString:dic withUrl:KK_URL_get_user withSuccess:^(id result, NSDictionary *resultDic, HJHTTPModel *model) {
        
        if (model.errorcode == KKStatus_success) {
            [self hideLoading];
            
            //解析数据,存储数据库
            NSString * jsonStr = [HJAESUtil aesDecrypt:model.data];
            DLog(@"jsonStr:%@",jsonStr);
            
            HJUserInfoModel * userModel = [[HJUserInfoModel alloc] initWithString:jsonStr error:nil];
            
            [HJCommon shareInstance].userInfoModel = userModel;
            
            [self.tableView reloadData];
            
            
        }else{
            
            [self showToastInView:self.view time:KKToastTime title:model.errormessage];
            
        }
        
    } withError:^(id result, NSDictionary *resultDic, HJHTTPModel *model) {
        
        [self showToastInView:self.view time:KKToastTime title:KKLanguage(@"tips_fail")];
        
    }];
    
    
    
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
