//
//  HJBindEmailVC.m
//  fat
//
//  Created by ydd on 2021/5/11.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import "HJBindEmailVC.h"

@interface HJBindEmailVC ()

@property (strong,nonatomic)UITextField * emailTf;

@property (strong,nonatomic)UILabel * emailLab;

@property (strong,nonatomic)UIView * bindView;   //绑定
@property (strong,nonatomic)UIView * UNbindView; //已绑定

@property (strong,nonatomic)UIView * verifyView; //待验证

@end

@implementation HJBindEmailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    [self initUI];
    
    [self refreshUI];
}
- (void)initUI{
    
    self.view.backgroundColor = kkBgGrayColor;
    
    
    if ([[HJCommon shareInstance].userInfoModel.isEmail boolValue] == YES) {
        
        [self.view addSubview:self.UNbindView];
        
    }else{
        
    
        if ([HJCommon shareInstance].userInfoModel.email != nil &&
            [HJCommon shareInstance].userInfoModel.email.length != 0) {
            
            [self addRightBtnOneWithString:KKLanguage(@"lab_me_userInfo_text7")];
            
            [self.view addSubview:self.verifyView];
            
        }else{
            
            [self addRightBtnOneWithString:KKLanguage(@"lab_me_userInfo_save")];
            
            [self.view addSubview:self.bindView];
        }
    
    }

}
- (UIView *)bindView{
    
    if (!_bindView) {
        
        _bindView = [[UIView alloc] init];
        _bindView.frame = CGRectMake(0, KKNavBarHeight, KKSceneWidth, kk_y(500));
        
        
        UIView * bgView = [[UIView alloc] init];
        bgView.frame  = CGRectMake(0, 0, kk_x(20), KKButtonHeight);
        
        UITextField * tf = [[UITextField alloc] init];
        tf.frame = CGRectMake(0, kk_y(20), KKSceneWidth, KKButtonHeight);
        tf.backgroundColor = kkWhiteColor;
        tf.leftView = bgView;
        tf.keyboardType = UIKeyboardTypeASCIICapable;
        tf.leftViewMode = UITextFieldViewModeAlways;
        tf.placeholder = KKLanguage(@"lab_login_enter_email");
        tf.font = kk_sizefont(KKFont_Normal);
        [_bindView addSubview:tf];
        _emailTf = tf;
        
        UILabel * titleLab = [[UILabel alloc] init];
        titleLab.frame = CGRectMake(0, tf.frame.size.height+tf.frame.origin.y, KKSceneWidth, KKButtonHeight);
        titleLab.text = KKLanguage(@"lab_me_userInfo_bind_email_text1");
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.font = kk_sizefont(KKFont_small_12);
        titleLab.textColor = kkTextGrayColor;
        [_bindView addSubview:titleLab];
        
    }
    
    return _bindView;
}

- (UIView *)UNbindView{
    
    if (!_UNbindView) {
        
        _UNbindView = [[UIView alloc] init];
        _UNbindView.frame = CGRectMake(0, KKNavBarHeight, KKSceneWidth, kk_y(500));
        
        UILabel * titleLab = [[UILabel alloc] init];
        titleLab.text = KKLanguage(@"lab_me_userInfo_bind_email_text4");
        titleLab.frame = CGRectMake(0, 0, KKSceneWidth, KKButtonHeight);
        titleLab.font = kk_sizefont(KKFont_small_large);
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.textColor = kkTextGrayColor;
        [_UNbindView addSubview:titleLab];
        
        
        UILabel * emailLab = [[UILabel alloc] init];
        emailLab.frame = CGRectMake(0, titleLab.frame.size.height, KKSceneWidth, KKButtonHeight);
        emailLab.font = kk_sizefont(KKFont_Big_20);
        emailLab.textAlignment = NSTextAlignmentCenter;
        [_UNbindView addSubview:emailLab];
        _emailLab = emailLab;
        
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(kk_x(40), emailLab.frame.origin.y + emailLab.frame.size.height + kk_y(20), KKSceneWidth- 2*kk_x(40), KKButtonHeight);
        [btn setTitle:KKLanguage(@"lab_me_userInfo_bind_email_text5") forState:UIControlStateNormal];
        [btn setTitleColor:kkWhiteColor forState:UIControlStateNormal];
        btn.titleLabel.font = kk_sizefont(KKFont_Normal);
        btn.layer.backgroundColor = KKBgYellowColor.CGColor;
        btn.tag = KKButton_Account_logout;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_UNbindView addSubview:btn];
   
        
    }
    
    return _UNbindView;
    
}

- (UIView *)verifyView{
    
    if (!_verifyView) {
        
        UIView * view = [[UIView alloc] init];
        view.frame = CGRectMake(0, KKNavBarHeight, KKSceneWidth, kk_y(500));
        
        _verifyView = view;
        
        UILabel * titleLab = [[UILabel alloc] init];
        titleLab.text = KKLanguage(@"lab_me_userInfo_bind_email_text4");
        titleLab.frame = CGRectMake(0, 0, KKSceneWidth, KKButtonHeight);
        titleLab.font = kk_sizefont(KKFont_small_large);
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.textColor = kkTextGrayColor;
        [view addSubview:titleLab];
        
        
        UILabel * emailLab = [[UILabel alloc] init];
        emailLab.frame = CGRectMake(0, titleLab.frame.size.height, KKSceneWidth, KKButtonHeight);
        emailLab.font = kk_sizefont(KKFont_Big_20);
        emailLab.textAlignment = NSTextAlignmentCenter;
        [view addSubview:emailLab];
        _emailLab = emailLab;
        
        
        UILabel * verLab = [[UILabel alloc] init];
        verLab.frame = CGRectMake(0, emailLab.frame.size.height+emailLab.frame.origin.y, KKSceneWidth, KKButtonHeight/2);
        verLab.font = kk_sizefont(KKFont_small_large);
        verLab.text = KKLanguage(@"lab_me_userInfo_text8");
        verLab.textAlignment = NSTextAlignmentCenter;
        verLab.textColor = kkTextGrayColor;
        [view addSubview:verLab];

        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(kk_x(40), verLab.frame.origin.y + verLab.frame.size.height + kk_y(20), KKSceneWidth- 2*kk_x(40), KKButtonHeight);
        [btn setTitle:KKLanguage(@"lab_me_userInfo_text9") forState:UIControlStateNormal];
        [btn setTitleColor:kkWhiteColor forState:UIControlStateNormal];
        btn.titleLabel.font = kk_sizefont(KKFont_Normal);
        btn.layer.backgroundColor = KKBgYellowColor.CGColor;
        btn.tag = KKButton_Account_Register_email;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        
        
        UIButton * lastbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        lastbtn.frame = CGRectMake(kk_x(40), btn.frame.origin.y + btn.frame.size.height, KKSceneWidth- 2*kk_x(40), KKButtonHeight);
        [lastbtn setTitle:KKLanguage(@"lab_me_userInfo_text10") forState:UIControlStateNormal];
        [lastbtn setTitleColor:KKBgYellowColor forState:UIControlStateNormal];
        lastbtn.titleLabel.font = kk_sizefont(KKFont_Normal);
        lastbtn.backgroundColor =[UIColor clearColor];
        [view addSubview:lastbtn];
        lastbtn.tag = KKButton_upgrade;
        [lastbtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
   
    }
    
    return _verifyView;
    
}

- (void)refreshUI{
    
    _emailLab.text = [HJCommon shareInstance].userInfoModel.email;
    
}

- (void)rightBtnOneClick:(UIButton *)sender{
    
    
    if ([HJCommon shareInstance].userInfoModel.email != nil &&
        [HJCommon shareInstance].userInfoModel.email.length != 0) {
        
        [self showAlertViewTitle:KKLanguage(@"lab_tip_bind") message:nil dataArr:@[KKLanguage(@"lab_common_confirm")] callback:^(NSInteger index, NSString *titleString) {
            
            if ([titleString isEqualToString:KKLanguage(@"lab_common_confirm")]) {
                
                [self unbind];
                
            }
            
        }];
        
    }else{
        
        [self bind];
    }
    
   
}

- (void)btnClick:(UIButton*)sender{
    
    if (sender.tag == KKButton_Account_logout) {
        
        [self showAlertSheetTitle:KKLanguage(@"lab_me_userInfo_bind_email_text5_title") message:nil dataArr:@[KKLanguage(@"lab_me_userInfo_bind_email_text5")] callback:^(NSInteger index, NSString *titleString) {
            
            if ([titleString isEqualToString:KKLanguage(@"lab_me_userInfo_bind_email_text5")]) {
                
                [self unbind];
                
            }
        }];
        
    }else if (sender.tag == KKButton_Account_Register_email){
        
        
        [self bind];
        
    }else if (sender.tag == KKButton_upgrade){
        
        [self getUserInfo];
        
    }
    
}

- (void)bind{
    
    
    NSString * email = [[HJCommon shareInstance] whitespaceCharacterSet:self.emailTf.text];
    
    if ([HJCommon shareInstance].userInfoModel.email != nil &&
        [HJCommon shareInstance].userInfoModel.email.length != 0) {
        email = self.emailLab.text;
    }
    
    
    if (!email.length) {
        
        [self showToastInView:self.view time:KKToastTime title:KKLanguage(@"lab_login_enter_email")];
        return;
        
    }
    
    if ([[HJCommon shareInstance] isvalidateEmail:email] == NO) {
        [self showToastInView:self.view time:KKToastTime title:KKLanguage(@"lab_tips_http_text10")];
        return;
    }

    [self showLoadingInView:self.view time:KKTimeOut title:KKLanguage(@"lab_common_loading")];
    
    HJBindEmailModel * model = [HJBindEmailModel new];
    model.userId = [HJCommon shareInstance].userInfoModel.userId;
    model.mode = email;
    model.type = @"0";
    
    NSDictionary *dic = [model toDictionary];
    [KKHttpRequest HttpRequestType:k_POST withrequestType:NO withDataString:dic withUrl:KK_URL_bound_user withSuccess:^(id result, NSDictionary *resultDic, HJHTTPModel *model) {
        
        if (model.errorcode == KKStatus_success) {
            
            [self showToastInWindows:KKToastTime title:KKLanguage(@"lab_tip_bind_text_1")];
            [self.navigationController popViewControllerAnimated:YES];
            
            
        }else{
            
            [self showToastInView:self.view time:KKToastTime title:model.errormessage];
            
        }
        
    } withError:^(id result, NSDictionary *resultDic, HJHTTPModel *model) {
        
        [self showToastInView:self.view time:KKToastTime title:KKLanguage(@"tips_fail")];
        
    }];
    
}

- (void)unbind{
    
    [self showLoadingInView:self.view time:KKTimeOut title:KKLanguage(@"lab_common_loading")];
    
    HJBindEmailModel * model = [HJBindEmailModel new];
    model.userId = [HJCommon shareInstance].userInfoModel.userId;
    model.type = @"0";
    
    NSDictionary *dic = [model toDictionary];
    [KKHttpRequest HttpRequestType:k_POST withrequestType:NO withDataString:dic withUrl:KK_URL_unbound_user withSuccess:^(id result, NSDictionary *resultDic, HJHTTPModel *model) {
        
        NSString * message = [HJTipsUtil resultTips:model type:0];
        
        if (model.errorcode == KKStatus_success) {
            
            [self showToastInWindows:KKToastTime title:message];
            [self.navigationController popViewControllerAnimated:YES];
            
            
        }else{
            
            [self showToastInView:self.view time:KKToastTime*2 title:message];
            
        }
        
    } withError:^(id result, NSDictionary *resultDic, HJHTTPModel *model) {
        
        [self showToastInView:self.view time:KKToastTime title:KKLanguage(@"tips_fail")];
        
    }];
    
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
            
            [self refreshUI];
            
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
