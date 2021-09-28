//
//  HJRegisterVC.m
//  fat
//
//  Created by ydd on 2021/4/25.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import "HJRegisterVC.h"
#import "HJLoginView.h"

@interface HJRegisterVC ()<UIScrollViewDelegate,UITextFieldDelegate>{
    
    NSUInteger _phoneTfNum;
    NSUInteger _phonePswTfNum;
    NSUInteger _phoneVcodeTfNum;
    
    NSUInteger _emailTfNum;
    NSUInteger _emailPswTfNum;
    
}

@property (strong,nonatomic)UIScrollView * scrollView;

@property (strong,nonatomic)HJLoginView * phoneLoginView;
@property (strong,nonatomic)HJLoginView * emailLoginView;

@property (strong,nonatomic)UIButton * phoneBtn;
@property (strong,nonatomic)UIButton * emailBtn;

@property (strong,nonatomic)UIView * lineView;

@property (strong,nonatomic)UIButton * loginBtn;

@end

@implementation HJRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initData];
    [self initUI];
    
    [self loginBtnAlpha];
    
}

#pragma mark ============== 数据初始化 ===============
- (void)initData{
    
   // self.dataArr = [[HJCommon shareInstance] accountArr];
}

#pragma mark ============== UI ===============
- (void)initUI{
    
    [self addLeftBtnWithImage:LeftBtnCancel];
    UIImage * image = [UIImage imageNamed:@"img_bg_login"];
    
    UIImageView * bgImageView = [[UIImageView alloc] init];
    bgImageView.frame = self.view.bounds;
    bgImageView.image = image;
    bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:bgImageView];
    
    
    [self.view addSubview:self.scrollView];
    
    self.phoneLoginView = [[HJLoginView alloc] initWithFrame:CGRectMake(0, 0, KKSceneWidth, self.scrollView.frame.size.height) withViewType:KKViewType_register_phone];
    
    [self.scrollView addSubview:self.phoneLoginView];
    
    
    [self.phoneLoginView.phoneLoginAreaBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.phoneLoginView.loginBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.phoneLoginView.selectAgreementBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.phoneLoginView.agreementBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.phoneLoginView.vcodeBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.phoneLoginView.loginTf.delegate = self.phoneLoginView.loginPswTf.delegate =  self.phoneLoginView.vcodeTf.delegate = self;
    
    self.emailLoginView = [[HJLoginView alloc] initWithFrame:CGRectMake(KKSceneWidth, 0, KKSceneWidth, self.scrollView.frame.size.height) withViewType:KKViewType_register_email];
    
    [self.scrollView addSubview:self.emailLoginView];
    [self.emailLoginView.loginBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.emailLoginView.selectAgreementBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.emailLoginView.agreementBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.emailLoginView.loginTf.delegate = self.emailLoginView.loginPswTf.delegate = self;
    
    //手机号视图
    [self.view addSubview:self.phoneBtn];
    // 邮箱视图
    [self.view addSubview:self.emailBtn];
    
    //滑动line
    [self.view addSubview:self.lineView];
    
    
    //已有账号
    [self.view addSubview:self.loginBtn];
}

- (UIScrollView *)scrollView{
    
    if (!_scrollView) {
        
        UIScrollView * scroview = [[UIScrollView alloc] init];
        scroview.frame = CGRectMake(0, kk_y(400), KKSceneWidth, kk_y(600));
        scroview.backgroundColor = [UIColor clearColor];
        scroview.contentSize = CGSizeMake(scroview.frame.size.width * 2, scroview.frame.size.height);
        scroview.pagingEnabled = YES;
        scroview.delegate = self;
        scroview.showsHorizontalScrollIndicator = NO;
        _scrollView = scroview;
    }
    return _scrollView;
}

- (UIButton *)phoneBtn{
    
    float btnWidth = kk_x(150);
    
    if (!_phoneBtn) {
        UIButton * phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        phoneBtn.frame = CGRectMake(KKSceneWidth/2-btnWidth-kk_x(50), self.scrollView.frame.origin.y-KKButtonHeight, btnWidth, KKButtonHeight);
        [phoneBtn setTitle:KKLanguage(@"lab_login_phone") forState:UIControlStateNormal];
        [phoneBtn setTitleColor:kkTextBlackColor forState:UIControlStateNormal];
        [phoneBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        phoneBtn.tag = KKButton_Login_PhoneTitle;
      
        _phoneBtn = phoneBtn;
        
    
        
    }
    
    return _phoneBtn;
}

- (UIButton *)emailBtn{
    
    
    if (!_emailBtn) {
        
        UIButton * emailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        emailBtn.frame = CGRectMake(KKSceneWidth/2+kk_x(50), _phoneBtn.frame.origin.y, _phoneBtn.frame.size.width, _phoneBtn.frame.size.height);
        [emailBtn setTitle:KKLanguage(@"lab_login_email") forState:UIControlStateNormal];
        [emailBtn setTitleColor:kkTextBlackColor forState:UIControlStateNormal];
        [emailBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        emailBtn.tag = KKButton_Login_emailTitle;
      
        _emailBtn = emailBtn;
    }
    
    return _emailBtn;
}
- (UIView *)lineView{
    
    if (!_lineView) {
        
        UIView * lineView = [[UIView alloc] init];
        lineView.bounds = CGRectMake(0, 0, kk_x(100), kk_y(4));
        lineView.center = CGPointMake(_phoneBtn.center.x, _phoneBtn.frame.size.height+_phoneBtn.frame.origin.y-5);
        lineView.backgroundColor = KKBgYellowColor;
        _lineView = lineView;
    }
    
    return _lineView;
}
- (UIButton *)loginBtn{
    
    if (!_loginBtn) {
        
        UIButton * btn  = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(KKSceneWidth/4, KKSceneHeight -KKButtonHeight*2 - KKButtomSpace , KKSceneWidth/2, KKButtonHeight);
        [btn setTitleColor:KKBgYellowColor forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = KKButton_Register_goLogin;
        
        
        NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:KKLanguage(@"lab_login_now")];
        NSRange titleRange = {0,[title length]};
        [title addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:titleRange];
        [btn setAttributedTitle:title
                       forState:UIControlStateNormal];
        btn.titleLabel.font = kk_sizefont(KKFont_Normal);
      
        _loginBtn = btn;
    }
    
    return _loginBtn;
    
}
- (void)btnClick:(UIButton*)sender{
    
    if (sender.tag == KKButton_Account_Area) {
        
        FCCountryAraeViewController * vc = [[FCCountryAraeViewController alloc] init];
        
        vc.delegate = ^(NSString *areaNum){
            NSLog(@"%@",areaNum);
            [self.phoneLoginView.phoneLoginAreaBtn setTitle:areaNum forState:UIControlStateNormal];
        };
        
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }else if (sender.tag == KKButton_Register_GetVcode){
        
        NSString * mobile =self.phoneLoginView.loginTf.text;
        
        if (mobile.length == 0) {
            return;
        }
        
        HJVcodeModel * model = [HJVcodeModel new];
        model.phoneNumber = [NSString stringWithFormat:@"%@%@",self.phoneLoginView.phoneLoginAreaBtn.titleLabel.text,mobile];
        
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
        
    }else if(sender.tag == KKButton_Account_Register){
      
        if (self.phoneLoginView.selectAgreementBtn.selected == NO) {
            [self showToastInView:self.view time:KKToastTime title:KKLanguage(@"lab_login_serve_text3")];
            return;;
        }
        
        if (self.phoneLoginView.loginPswTf.text.length<6 || self.phoneLoginView.loginPswTf.text.length>12) {
            [self showToastInView:self.view time:KKToastTime title:KKLanguage(@"lab_tips_http_text9")];
            return;;
        }
        
        NSString * mobile =self.phoneLoginView.loginTf.text;
        NSString * password = self.phoneLoginView.loginPswTf.text;
        
        
        HJRegisterModel * model = [HJRegisterModel new];
        model.loginName = [NSString stringWithFormat:@"%@%@",self.phoneLoginView.phoneLoginAreaBtn.titleLabel.text,mobile];
        model.passWord = password;
        model.code = self.phoneLoginView.vcodeTf.text;
        
        NSDictionary * dic = [model toDictionary];
        
        [self userRegister:dic type:KKButton_Account_Register];
        
    
    }else if (sender.tag == KKButton_Account_Register_email){
        
        if (self.emailLoginView.selectAgreementBtn.selected == NO) {
            [self showToastInView:self.view time:KKToastTime title:KKLanguage(@"lab_login_serve_text3")];
            return;;
        }

        
        if (self.emailLoginView.loginPswTf.text.length<6 || self.emailLoginView.loginPswTf.text.length>12) {
            [self showToastInView:self.view time:KKToastTime title:KKLanguage(@"lab_tips_http_text9")];
            return;;
        }
        
        NSString * mobile =self.emailLoginView.loginTf.text;
        NSString * password = self.emailLoginView.loginPswTf.text;
        
        
        HJRegisterModel * model = [HJRegisterModel new];
        
        model.loginName = mobile;
        model.passWord = password;

        NSDictionary * dic = [model toDictionary];
        
        [self userRegister:dic type:KKButton_Account_Register_email];
        
      
    }else if (sender.tag == KKButton_Login_PhoneTitle){
        
        _lineView.center = CGPointMake( _phoneBtn.center.x, _lineView.center.y);
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        
        
    }else if (sender.tag == KKButton_Login_emailTitle){
        
        _lineView.center = CGPointMake( _emailBtn.center.x, _lineView.center.y);
        [self.scrollView setContentOffset:CGPointMake(KKSceneWidth, 0) animated:YES];
        
    }else if (sender.tag == KKButton_Register_selectAgreement){
        
        sender.selected = !sender.selected;
        
        
    }else if (sender.tag == KKButton_Register_agreement){
        
        HJWebVC * vc = [[HJWebVC alloc] init];
        vc.webType = KKWebType_Agreement;
        vc.navigationItem.title = KKLanguage(@"lab_login_serve_text5");
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (sender.tag == KKButton_Register_goLogin){
        
        [self leftBack];
        
    }
    
}

#pragma mark ============== 方法 ===============
- (void)loginBtnAlpha{

    /*
     手机号注册
     */
    if (_phoneTfNum>0 && _phonePswTfNum>0 && _phoneVcodeTfNum>0){
        self.phoneLoginView.loginBtn.alpha = 1;
        self.phoneLoginView.loginBtn.enabled = YES;
    }else{
        self.phoneLoginView.loginBtn.alpha = 0.5;
        self.phoneLoginView.loginBtn.enabled = NO;
    }

    /*
     邮箱注册
     */
    if (_emailTfNum>0 && _emailPswTfNum>0) {
        self.emailLoginView.loginBtn.alpha = 1;
        self.emailLoginView.loginBtn.enabled = YES;
    }else{
        self.emailLoginView.loginBtn.alpha = 0.5;
        self.emailLoginView.loginBtn.enabled = NO;
    }
}

/*
 用户注册
 */
- (void)userRegister:(NSDictionary*)dic type:(KKButtonType)type{
    
    [self showLoadingInView:self.view time:KKTimeOut title:KKLanguage(@"lab_common_loading")];
    
    [KKHttpRequest HttpRequestType:k_POST withrequestType:NO withDataString:dic withUrl:KK_URL_api_user_register withSuccess:^(id result, NSDictionary *resultDic, HJHTTPModel *model) {
    
        if (model.code == KKStatus_success) {
            
            if (type == KKButton_Account_Register_email) {
                
                [self showOkAlertViewTitle:model.msg message:KKLanguage(@"lab_login_email_tips") dataArr:nil callback:^(NSInteger index, NSString *titleString) {
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                
            }else{
                
                [self showToastInWindows:KKToastTime title:model.msg];
            
                /*
                 保存token信息
                 */
                [[HJCommon shareInstance] saveToken:model.token];
                
                [self getUserInfo];
            }
        
        }else{
            
            [self showToastInView:self.view time:KKToastTime title:model.msg];
        }
        
    } withError:^(id result, NSDictionary *resultDic, HJHTTPModel *model) {
        
        [self showToastInView:self.view time:KKToastTime title:KKLanguage(@"tips_fail")];
        
    }] ;
  
    
}

#pragma mark ============== 获取用户信息 ===============
- (void)getUserInfo{

    [KKHttpRequest HttpRequestType:k_POST withrequestType:NO withDataString:nil withUrl:KK_URL_api_user_info withSuccess:^(id result, NSDictionary *resultDic, HJHTTPModel *model) {
        
        if (model.code == KKStatus_success) {
            
            //解析数据,存储数据库
            HJUserInfoModel * userModel = [[HJUserInfoModel alloc] initWithDictionary:model.data error:nil];
            
            DLog(@"用户信息:%@",userModel);
            
            /*
             插入本地数据库
             */
            [HJFMDBModel userInfoInsert:userModel];
            
            /*
             保存当前登陆者信息
             */
            [HJCommon shareInstance].userInfoModel = userModel;
            
            [[HJCommon shareInstance] saveUserInfo:userModel];
            
        }
        
        /*
         进入主界面
         */
        if (result) {
            
            AppDelegate *  appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate loginMain];
    
        }
        
    } withError:^(id result, NSDictionary *resultDic, HJHTTPModel *model) {
        
    }];
}

#pragma mark ============== 返回 ===============
- (void)leftBack{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark =============== uiscrollviewDelegate ===============
// 滑动scrollView，并且手指离开时执行。一次有效滑动，只执行一次。
// 当pagingEnabled属性为YES时，不调用，该方法
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    SW(sw);
    
    if (targetContentOffset->x/KKSceneWidth == 1) {
        
        [UIView animateWithDuration:0.2 animations:^{
            sw.lineView.center = CGPointMake(sw.emailBtn.center.x, sw.lineView.center.y);
        }];
        
    }else{ // 防止下拉刷新调用此方法
        
        [UIView animateWithDuration:0.2 animations:^{
            sw.lineView.center = CGPointMake(sw.phoneBtn.center.x, sw.lineView.center.y);
        }];
    }
}

#pragma mark ============== textField 代理 ===============
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.phoneLoginView.loginTf) {
        _phoneTfNum = textField.text.length - range.length + string.length;
    }else if (textField == self.phoneLoginView.loginPswTf){
        
        _phonePswTfNum = textField.text.length - range.length + string.length;
        
    }else if (textField == self.phoneLoginView.vcodeTf){
        _phoneVcodeTfNum = textField.text.length - range.length + string.length;
    }else if (textField == self.emailLoginView.loginTf){
        
        _emailTfNum = textField.text.length - range.length + string.length;
        
        NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        /*
         校验下邮箱格式
         */
        if( [[HJCommon shareInstance] isvalidateEmail:toBeString] == NO){
            _emailTfNum = 0;
        }
        
        
    }else if (textField == self.emailLoginView.loginPswTf){
        _emailPswTfNum = textField.text.length - range.length + string.length;
       
    }
    
    [self loginBtnAlpha];
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    /*
     界面bug跳转问题
     */
    if (textField == self.phoneLoginView.loginTf ||
        textField == self.phoneLoginView.loginPswTf ||
        textField == self.phoneLoginView.vcodeTf) {
        
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }else{
        [self.scrollView setContentOffset:CGPointMake(KKSceneWidth, 0) animated:YES];
    }
    
    
    /*
     placehode 文字显示
     */
    
    if (textField == self.phoneLoginView.loginPswTf) {
        
        self.phoneLoginView.loginPswTf.placeholder = KKLanguage(@"lab_login_placehold_password");
        self.emailLoginView.loginPswTf.placeholder = KKLanguage(@"lab_login_password");
        return;
        
    }
    
    if(textField == self.emailLoginView.loginPswTf){
        
        self.emailLoginView.loginPswTf.placeholder = KKLanguage(@"lab_login_placehold_password");
        self.phoneLoginView.loginPswTf.placeholder = KKLanguage(@"lab_login_password");
        return;
        
    }
    
    self.phoneLoginView.loginPswTf.placeholder = KKLanguage(@"lab_login_password");
    self.emailLoginView.loginPswTf.placeholder = KKLanguage(@"lab_login_password");
    
}


- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    self.phoneLoginView.loginPswTf.placeholder = KKLanguage(@"lab_login_password");
    self.emailLoginView.loginPswTf.placeholder = KKLanguage(@"lab_login_password");
}




@end
