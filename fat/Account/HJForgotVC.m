//
//  HJForgotVC.m
//  fat
//
//  Created by ydd on 2021/4/25.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import "HJForgotVC.h"

@interface HJForgotVC ()<UITextFieldDelegate>{
    
    NSUInteger _phoneTfNum;
    NSUInteger _phonePswTfNum;
    NSUInteger _phoneVcodeTfNum;
    
    NSUInteger _emailTfNum;
}


@end

@implementation HJForgotVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
    
    [self loginBtnAlpha];
}


- (void)initUI{
    
    self.view.backgroundColor = kkBgGrayColor;
    
    [self.view addSubview:self.forgotPhoneView];
    
    [self.view addSubview:self.forgotEmailView];
    
    self.forgotPhoneView.hidden = NO;
    self.forgotEmailView.hidden = YES;
    
}

- (HJLoginView *)forgotPhoneView{
    
    if (!_forgotPhoneView) {
        
        HJLoginView * view = [[HJLoginView alloc] initWithFrame:CGRectMake(0, KKNavBarHeight + kk_y(50), KKSceneWidth, kk_y(700)) withViewType:KKViewType_forgot_phone];
        _forgotPhoneView = view;
        
        [view.phoneLoginAreaBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [view.vcodeBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [view.findBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [view.findTypeBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        view.phoneTf.delegate = view.pswTf.delegate = view.vcodeTf.delegate = self;
        
    }
    
    return _forgotPhoneView;
    
}

- (HJLoginView *)forgotEmailView{
    
    if (!_forgotEmailView) {
        
        HJLoginView * view = [[HJLoginView alloc] initWithFrame:CGRectMake(0, KKNavBarHeight + kk_y(50), KKSceneWidth, kk_y(500)) withViewType:KKViewType_forgot_email];
        _forgotEmailView = view;
        
        [view.findBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [view.findTypeBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        view.pswTf.delegate = self;
    }
    
    return _forgotEmailView;
    
}

- (void)btnClick:(UIButton*)sender{
    

    if (sender.tag == KKButton_Account_Area) {
        
        FCCountryAraeViewController * vc = [[FCCountryAraeViewController alloc] init];
        
        vc.delegate = ^(NSString *areaNum){
            NSLog(@"%@",areaNum);
            [self.forgotPhoneView.phoneLoginAreaBtn setTitle:areaNum forState:UIControlStateNormal];
        };
        
        [self.navigationController pushViewController:vc animated:YES];
    
    }else if (sender.tag == KKButton_Forget_Find) {
        
        if (_forgotPhoneView.hidden == YES) {
            /*
            邮箱找回
             */
            
            NSString * email =self.forgotEmailView.pswTf.text;

            HJForgetEmailModel * model = [HJForgetEmailModel new];
            model.email = email;
            
            NSDictionary * dic =   [model toDictionary];
    
            [self showLoadingInView:self.view time:KKTimeOut title:KKLanguage(@"lab_common_loading")];
            
            [KKHttpRequest HttpRequestType:k_POST withrequestType:NO withDataString:dic withUrl:KK_URL_api_user_email_find_pwd withSuccess:^(id result, NSDictionary *resultDic, HJHTTPModel *model) {
            
                if (model.code == KKStatus_success) {
                    
                    [self showToastInWindows:KKToastTime*2 title:model.msg];
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }else{
                    
                    [self showToastInView:self.view time:KKToastTime title:model.msg];
                }
                
            } withError:^(id result, NSDictionary *resultDic, HJHTTPModel *model) {
                
                [self showToastInView:self.view time:KKToastTime title:KKLanguage(@"tips_fail")];
            }];
            
        }else if (_forgotEmailView.hidden == YES){
            
            /*
             手机找回
             */
            NSString * mobile = self.forgotPhoneView.phoneTf.text;
            NSString * psw = self.forgotPhoneView.pswTf.text;
            NSString * vcode =self.forgotPhoneView.vcodeTf.text;
            
            if (psw.length<6 || psw.length>12) {
                [self showToastInView:self.view time:KKToastTime title:KKLanguage(@"lab_tips_http_text9")];
                return;;
            }
            
            [self showLoadingInView:self.view time:KKTimeOut title:KKLanguage(@"lab_common_loading")];
        
            HJForgetPhoneModel * model = [HJForgetPhoneModel new];
            model.phoneNumber = [NSString stringWithFormat:@"%@%@",self.forgotPhoneView.phoneLoginAreaBtn.titleLabel.text,mobile];
            model.code = vcode;
            model.newPwd = psw;
            
            NSDictionary * dic =  [model toDictionary];
            
            [KKHttpRequest HttpRequestType:k_POST withrequestType:NO withDataString:dic withUrl:KK_URL_api_user_modify_pwd withSuccess:^(id result, NSDictionary *resultDic, HJHTTPModel *model) {
                
                if (model.code == KKStatus_success) {
                    
                    [self showToastInWindows:KKToastTime*2 title:model.msg];
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }else{
                    
                    [self showToastInView:self.view time:KKToastTime title:model.msg];
                }
                
            } withError:^(id result, NSDictionary *resultDic, HJHTTPModel *model) {
                
                [self showToastInView:self.view time:KKToastTime title:KKLanguage(@"tips_fail")];
                
            }];
            
        }
        
    }else if (sender.tag == KKButton_Forget_FindType){
        
        
        if (_forgotPhoneView.hidden == YES) {
            
            _forgotPhoneView.hidden = NO;
            _forgotEmailView.hidden = YES;
            
        }else if (_forgotEmailView.hidden == YES){
            
            _forgotPhoneView.hidden = YES;
            _forgotEmailView.hidden = NO;
        }
        
        
    }else if (sender.tag == KKButton_Forget_GetVcode){
        
        NSString * mobile =self.forgotPhoneView.phoneTf.text;
        
        if(mobile.length==0){
            return;
        }
    
        HJVcodeModel * model = [HJVcodeModel new];
        model.phoneNumber = [NSString stringWithFormat:@"%@%@",self.forgotPhoneView.phoneLoginAreaBtn.titleLabel.text,mobile];
        
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
        
    }
}


#pragma mark ============== 方法 ===============
- (void)loginBtnAlpha{
  
    /*
     手机号登录
     */
    if (_phoneTfNum>0 && _phonePswTfNum>0 && _phoneVcodeTfNum>0) {
        self.forgotPhoneView.findBtn.alpha = 1;
        self.forgotPhoneView.findBtn.enabled = YES;
    }else{
        self.forgotPhoneView.findBtn.alpha = 0.5;
        self.forgotPhoneView.findBtn.enabled = NO;
    }
    
    /*
     邮箱登录
     */
    if (_emailTfNum>0) {
        self.forgotEmailView.findBtn.alpha = 1;
        self.forgotEmailView.findBtn.enabled = YES;
    }else{
        self.forgotEmailView.findBtn.alpha = 0.5;
        self.forgotEmailView.findBtn.enabled = NO;
    }
}


#pragma mark ============== textField 代理 ===============
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.forgotPhoneView.phoneTf) {
        _phoneTfNum = textField.text.length - range.length + string.length;
    }else if (textField == self.forgotPhoneView.pswTf){
        _phonePswTfNum = textField.text.length - range.length + string.length;
    }else if (textField == self.forgotPhoneView.vcodeTf){
        _phoneVcodeTfNum = textField.text.length - range.length + string.length;
    }else if (textField == self.forgotEmailView.pswTf){
        
        _emailTfNum = textField.text.length - range.length + string.length;
        
        NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        /*
         校验下邮箱格式
         */
        if( [[HJCommon shareInstance] isvalidateEmail:toBeString] == NO){
            _emailTfNum = 0;
        }
    }

    [self loginBtnAlpha];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    /*
     placehode 文字显示
     */
    
    if (textField == self.forgotPhoneView.pswTf) {
        
        self.forgotPhoneView.pswTf.placeholder = KKLanguage(@"lab_login_placehold_password");
        
        return;
        
    }
    
    self.forgotPhoneView.pswTf.placeholder= KKLanguage(@"lab_login_enter_new_password");
    
}


- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    self.forgotPhoneView.pswTf.placeholder= KKLanguage(@"lab_login_enter_new_password");
}


@end
