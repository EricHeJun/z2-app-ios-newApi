//
//  HJBindPhoneVC.m
//  fat
//
//  Created by ydd on 2021/5/11.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import "HJBindPhoneVC.h"

@interface HJBindPhoneVC ()<UITextFieldDelegate>{
    NSUInteger _phoneTfNum;
    NSUInteger _phoneVcodeTfNum;
}

@property (strong,nonatomic)UILabel * phoneLab;

@property (strong,nonatomic)HJLoginView * bindView;
@property (strong,nonatomic)UIView * UNbindView;

@end

@implementation HJBindPhoneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self initUI];
    
    [self refreshUI];
    
    [self loginBtnAlpha];
}

- (void)initUI{
    
    self.view.backgroundColor = kkBgGrayColor;
    
    if ([HJCommon shareInstance].userInfoModel.phonenumber == nil) {

        [self.view addSubview:self.bindView];
        
    }else{
        
        [self.view addSubview:self.UNbindView];
    }
}

- (HJLoginView *)bindView{
    
    if (!_bindView) {
        
        _bindView = [[HJLoginView alloc] initWithFrame:CGRectMake(0, KKNavBarHeight, KKSceneWidth, kk_y(500)) withViewType:KKViewType_replace_phone];
    
    }

    
    [_bindView.phoneLoginAreaBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [_bindView.loginBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [_bindView.vcodeBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _bindView.phoneTf.delegate = _bindView.vcodeTf.delegate = self;
    

    return _bindView;
}

- (UIView *)UNbindView{
    
    if (!_UNbindView) {
        
        _UNbindView = [[UIView alloc] init];
        _UNbindView.frame = CGRectMake(0, KKNavBarHeight, KKSceneWidth, kk_y(500));
        
        UILabel * titleLab = [[UILabel alloc] init];
        titleLab.text = KKLanguage(@"lab_me_userInfo_bind_email_text3");
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
        _phoneLab = emailLab;
        
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(kk_x(40), emailLab.frame.origin.y + emailLab.frame.size.height + kk_y(20), KKSceneWidth- 2*kk_x(40), KKButtonHeight);
        [btn setTitle:KKLanguage(@"lab_me_userInfo_bind_email_text6") forState:UIControlStateNormal];
        [btn setTitleColor:kkWhiteColor forState:UIControlStateNormal];
        btn.titleLabel.font = kk_sizefont(KKFont_Normal);
        btn.layer.backgroundColor = KKBgYellowColor.CGColor;
        btn.tag = KKButton_Account_Switch_account;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_UNbindView addSubview:btn];
   
    }
    return _UNbindView;
    
}

- (void)refreshUI{
    
    _phoneLab.text = [HJCommon shareInstance].userInfoModel.userName;

}


- (void)btnClick:(UIButton*)sender{
    
    if (sender.tag == KKButton_Account_Area) {
        
        FCCountryAraeViewController * vc = [[FCCountryAraeViewController alloc] init];
        vc.delegate = ^(NSString *areaNum) {
            [self.bindView.phoneLoginAreaBtn setTitle:areaNum forState:UIControlStateNormal];
        };
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (sender.tag == KKButton_Account_GetVcode){
        
        NSString * mobile =self.bindView.phoneTf.text;
        
        if (!mobile.length) {
            [self showToastInView:self.view time:KKToastTime title:KKLanguage(@"lab_login_enter_phone")];
            return;
        }
        
        HJVcodeModel * model = [HJVcodeModel new];
        model.phoneNumber = [NSString stringWithFormat:@"%@%@",self.bindView.phoneLoginAreaBtn.titleLabel.text,mobile];
        
        NSDictionary * dic = [model toDictionary];
        
        [self showLoadingInView:self.view time:KKTimeOut title:KKLanguage(@"lab_common_loading")];
        
        [KKHttpRequest HttpRequestType:k_POST withrequestType:NO withDataString:dic withUrl:KK_URL_api_user_sms_code withSuccess:^(id result, NSDictionary *resultDic,HJHTTPModel * model) {
            
            if (model.code == KKStatus_success) {
                
                [self showToastInView:self.view time:KKToastTime title:model.msg];
                
                [self startCountDownAction:sender];
                
            }else{
                
                [self showToastInView:self.view time:KKToastTime title:model.msg];
            }
            
        } withError:^(id result, NSDictionary *resultDic, HJHTTPModel * model) {
            
            [self showToastInView:self.view time:KKToastTime title:KKLanguage(@"tips_fail")];
            
        }];
        
    }else if (sender.tag == KKButton_Confirm){
        
        NSString * mobile =self.bindView.phoneTf.text;
        NSString * vcode = self.bindView.vcodeTf.text;
        
        HJReplacePhoneModel * model = [HJReplacePhoneModel new];
        model.phoneNumber = [NSString stringWithFormat:@"%@%@",self.bindView.phoneLoginAreaBtn.titleLabel.text,mobile];
        model.code =vcode;
        
        NSDictionary * dic = [model toDictionary];
        
        [self showLoadingInView:self.view time:KKTimeOut title:KKLanguage(@"lab_common_loading")];
        
        [KKHttpRequest HttpRequestType:k_POST withrequestType:NO withDataString:dic withUrl:KK_URL_api_user_modify_phone withSuccess:^(id result, NSDictionary *resultDic,HJHTTPModel * model) {
            
            if (model.code == KKStatus_success) {
                
                [self showToastInWindows:KKToastTime title:model.msg];
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }else{
                
                [self showToastInView:self.view time:KKToastTime title:model.msg];
            }
            
        } withError:^(id result, NSDictionary *resultDic, HJHTTPModel * model) {
            
            [self showToastInView:self.view time:KKToastTime title:KKLanguage(@"tips_fail")];
            
        }];
        
    }else  if (sender.tag == KKButton_Account_Switch_account) {
        
        [self.view addSubview:self.bindView];
        self.UNbindView.hidden = YES;
    }
}

#pragma mark ============== 方法 ===============
- (void)loginBtnAlpha{
  
    /*
     手机号登录
     */
    if (_phoneTfNum>0 && _phoneVcodeTfNum>0) {
        self.bindView.loginBtn.alpha = 1;
        self.bindView.loginBtn.enabled = YES;
    }else{
        
        self.bindView.loginBtn.alpha = 0.5;
        self.bindView.loginBtn.enabled = NO;
    }
    
  
}


#pragma mark ============== textField 代理 ===============
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.bindView.phoneTf) {
        _phoneTfNum = textField.text.length - range.length + string.length;
    }else if (textField == self.bindView.vcodeTf){
        _phoneVcodeTfNum = textField.text.length - range.length + string.length;
    }
    
    [self loginBtnAlpha];
    
    return YES;
}

@end
