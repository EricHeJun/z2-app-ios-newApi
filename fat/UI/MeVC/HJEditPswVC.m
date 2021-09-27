//
//  HJEditPswVC.m
//  fat
//
//  Created by ydd on 2021/5/6.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import "HJEditPswVC.h"

@interface HJEditPswVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    NSUInteger _oldTfNum;
    NSUInteger _freshTfNum;
    NSUInteger _confirmTfNum;
}

@property (strong,nonatomic)UITableView * tableView;

@property (strong,nonatomic)UITextField * oldTf;
@property (strong,nonatomic)UITextField * freshTf;
@property (strong,nonatomic)UITextField * confirmTf;

@end

@implementation HJEditPswVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initData];
    
    [self addRightBtnOneWithString:KKLanguage(@"lab_common_done")];
    
    [self.view addSubview:self.tableView];
}

- (void)initData{
    
    self.dataArr = [NSArray arrayWithObjects:
                    KKLanguage(@"lab_login_old_password"),
                    KKLanguage(@"lab_login_new_password"),
                    KKLanguage(@"lab_login_confirm_password"),
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

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 定义cell标识  每个cell对应一个自己的标识
    NSString *CellIdentifier = [NSString stringWithFormat:@"cell%ld%ld",(long)indexPath.section,(long)indexPath.row];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        //底线
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = kkBgGrayColor;
        lineView.frame = CGRectMake(kk_x(20), KKButtonHeight*1.5 - kk_y(1), KKSceneWidth - 2 * kk_x(20), kk_y(1));
        lineView.tag = 10;
        [cell.contentView addSubview:lineView];
        
        UITextField * tf = [[UITextField alloc] init];
        tf.frame = CGRectMake(kk_x(250), 0, KKSceneWidth/2, KKButtonHeight*1.5);
        tf.font= kk_sizefont(KKFont_Normal);
        tf.keyboardType = UIKeyboardTypeDefault;
        tf.secureTextEntry = YES;
        tf.delegate = self;
        [cell.contentView addSubview:tf];
        
        if (indexPath.row == 0) {
            _oldTf = tf;
        }else if(indexPath.row == 1){
            _freshTf = tf;
        }else if (indexPath.row == 2){
            _confirmTf = tf;
        }
    }
    
    
    NSString * title = self.dataArr[indexPath.row];
    cell.textLabel.text = title;
    cell.textLabel.font= kk_sizefont(KKFont_Normal);
    
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
        _oldTf.placeholder = KKLanguage(@"lab_login_enter_old_password");
        _freshTf.placeholder = KKLanguage(@"lab_login_enter_new_password");
        _confirmTf.placeholder = KKLanguage(@"lab_login_enter_new_password_retry");
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    

    if ([cell.textLabel.text isEqualToString:KKLanguage(@"lab_me_userInfo_edit_psw")]) {
        
        
    }else if ([cell.textLabel.text isEqualToString:KKLanguage(@"lab_login_email")]) {
        
        
    }else if ([cell.textLabel.text isEqualToString:KKLanguage(@"lab_login_phone")]) {
        
      
    }
    
}
- (void)rightBtnOneClick:(UIButton *)sender{
    
    if (_oldTfNum<6 || _oldTfNum>12 || _freshTfNum<6 || _freshTfNum>12 || _confirmTfNum<6 || _confirmTfNum>12) {
        [self showToastInView:self.view time:KKToastTime title:KKLanguage(@"lab_tips_http_text9")];
        return;
    }
    
    
    NSString * oldPsw = [[HJCommon shareInstance] whitespaceCharacterSet:_oldTf.text];
    NSString * freshPsw = [[HJCommon shareInstance] whitespaceCharacterSet:_freshTf.text];
    NSString * confirmPsw = [[HJCommon shareInstance] whitespaceCharacterSet:_confirmTf.text];
    
    if (![freshPsw isEqualToString:confirmPsw]) {
        [self showToastInView:self.view time:KKToastTime title:KKLanguage(@"tips_login_psw_2")];
        return;
    }
    
    if([oldPsw isEqualToString:freshPsw]){
        [self showToastInView:self.view time:KKToastTime title:KKLanguage(@"tips_login_psw_3")];
        return;
    }
    
    
    HJEditPswModel * model = [HJEditPswModel new];
    model.oldPwd = oldPsw;
    model.newPwd = freshPsw;
    
    NSDictionary * dic = [model toDictionary];
    
    [self showLoadingInView:self.view time:KKTimeOut title:KKLanguage(@"lab_common_loading")];
    
    [KKHttpRequest HttpRequestType:k_POST withrequestType:NO withDataString:dic withUrl:KK_URL_api_user_reset_pwd withSuccess:^(id result, NSDictionary *resultDic, HJHTTPModel *model) {
        
        if (model.code == KKStatus_success) {
            
            [KKHttpRequest HttpRequestType:k_POST withrequestType:YES withDataString:nil withUrl:KK_URL_api_user_logout withSuccess:^(id result, NSDictionary *resultDic, HJHTTPModel *model) {
                
                if (model.code == KKStatus_success) {
                    [[HJCommon shareInstance] logout:YES toast:KKLanguage(@"tips_login_again")];
                }else{
                    [self showToastInView:self.view time:KKToastTime title:model.msg];
                }
                
            } withError:^(id result, NSDictionary *resultDic, HJHTTPModel *model) {
                
            }];
            
        }else{
            
            [self showToastInView:self.view time:KKToastTime title:model.msg];
        }
        
    } withError:^(id result, NSDictionary *resultDic, HJHTTPModel *model) {
        
        [self showToastInView:self.view time:KKToastTime title:KKLanguage(@"tips_fail")];
        
    }];

}

#pragma mark ============== textField 代理 ===============
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.oldTf) {
        _oldTfNum = textField.text.length - range.length + string.length;
    }else if (textField == self.freshTf){
        _freshTfNum = textField.text.length - range.length + string.length;
    }else if (textField == self.confirmTf){
        _confirmTfNum = textField.text.length - range.length + string.length;
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    /*
     placehode 文字显示
     */
    
    if (textField == self.freshTf) {
        
        self.freshTf.placeholder = KKLanguage(@"lab_login_placehold_password");
        self.confirmTf.placeholder = KKLanguage(@"lab_login_enter_new_password_retry");
    
    }else if(textField == self.confirmTf){
        
        self.freshTf.placeholder = KKLanguage(@"lab_login_enter_new_password");
        self.confirmTf.placeholder = KKLanguage(@"lab_login_placehold_password");
        
    }else{
        
        self.freshTf.placeholder = KKLanguage(@"lab_login_enter_new_password");
        self.confirmTf.placeholder = KKLanguage(@"lab_login_enter_new_password_retry");
    }

    
}


- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    self.freshTf.placeholder = KKLanguage(@"lab_login_enter_new_password");
    self.confirmTf.placeholder = KKLanguage(@"lab_login_enter_new_password_retry");
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
