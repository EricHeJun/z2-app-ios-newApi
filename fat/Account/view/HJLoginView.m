//
//  HJLoginView.m
//  fat
//
//  Created by 何军 on 2021/4/14.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import "HJLoginView.h"

@implementation HJLoginView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame withViewType:(KKViewType)type{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        float tfHeight = KKButtonHeight;
        float tfWidth = KKSceneWidth -2*kk_x(40);
        
        
        if (type == KKViewType_login_phone) {
            
            [self phoneLoginView:tfWidth withHeight:tfHeight];
            
        }else if(type == KKViewType_login_email){
            
            [self emailLoginView:tfWidth withHeight:tfHeight];
            
        }else if (type == KKViewType_forgot_phone){
            
            [self phoneForgotView:tfWidth withHeight:tfHeight];
            
        }else if (type == KKViewType_forgot_email){
            
            [self emailForgotView:tfWidth withHeight:tfHeight];
            
        }else if(type == KKViewType_register_phone){
            
            [self phoneRegisterView:tfWidth withHeight:tfHeight];
            
        }else if(type == KKViewType_register_email){
            
            [self emailRegisterView:tfWidth withHeight:tfHeight];
            
        }else if (type == KKViewType_replace_phone){
            
            [self phoneReplaceView:tfWidth withHeight:tfHeight];
        }
    }
    
    return self;
}

#pragma mark ============== 登录视图 phone ===============
- (void)phoneLoginView:(float)tfWidth withHeight:(float)tfHeight{
    
    UIImage * image = [UIImage imageNamed:@"img_login_phone"];
    
    UIImageView * logoImageView = [[UIImageView alloc] init];
    logoImageView.frame = CGRectMake(kk_x(20), tfHeight/2 - image.size.height/2, image.size.width, image.size.height);
    logoImageView.image =  image;

    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(logoImageView.frame.size.width+logoImageView.frame.origin.x, 0, kk_x(140), tfHeight);
   
    [btn setImage:[UIImage imageNamed:@"img_btn_phone_area"] forState:UIControlStateNormal];
    
    [btn setTitle:@"+86" forState:UIControlStateNormal];
    [btn setTitleColor:kkTextGrayColor forState:UIControlStateNormal];
    btn.titleLabel.font = kk_sizefont(KKFont_Normal);
    
    btn.tag = KKButton_Account_Area;
    _phoneLoginAreaBtn = btn;
    
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, -btn.imageView.image.size.width-10, 0, btn.imageView.image.size.width);
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, btn.titleLabel.bounds.size.width+10, 0, -btn.titleLabel.frame.size.width);
   

    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, btn.frame.origin.x+btn.frame.size.width, tfHeight)];
    [view addSubview:logoImageView];
    [view addSubview:_phoneLoginAreaBtn];
    

    UITextField * tf = [[UITextField alloc] initWithFrame:CGRectMake(kk_x(40), kk_y(20), tfWidth, tfHeight)];
    tf.backgroundColor = kkWhiteColor;
    tf.borderStyle = UITextBorderStyleNone;
    tf.keyboardType = UIKeyboardTypePhonePad;
    tf.leftView = view;
    tf.leftViewMode = UITextFieldViewModeAlways;
    tf.placeholder = KKLanguage(@"lab_login_enter_phone");
    tf.font = kk_sizefont(KKFont_Normal);
    
    [self addSubview:tf];
    _loginTf = tf;
    
    
    UITextField * pswtf = [[UITextField alloc] initWithFrame:CGRectMake(kk_x(40), _loginTf.frame.size.height+_loginTf.frame.origin.y+kk_y(20), tfWidth, tfHeight)];
    pswtf.backgroundColor = kkWhiteColor;
    pswtf.borderStyle = UITextBorderStyleNone;
    pswtf.leftViewMode = UITextFieldViewModeAlways;
    pswtf.placeholder = KKLanguage(@"lab_login_password");
    pswtf.secureTextEntry = YES;
    pswtf.font = kk_sizefont(KKFont_Normal);
    image = [UIImage imageNamed:@"img_login_psw"];
    
    logoImageView = [[UIImageView alloc] init];
    logoImageView.frame = CGRectMake(kk_x(20), tfHeight/2 - image.size.height/2, image.size.width, image.size.height);
    logoImageView.image =  image;


    view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, logoImageView.frame.origin.x+logoImageView.frame.size.width+kk_x(20), tfHeight)];
    [view addSubview:logoImageView];

    pswtf.leftView = view;
    
    [self addSubview:pswtf];
    _loginPswTf = pswtf;
    
    
    
    UIButton * loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(_loginTf.frame.origin.x, _loginPswTf.frame.size.height+_loginPswTf.frame.origin.y+kk_y(20)*2, tfWidth, KKButtonHeight);
    [loginBtn setTitle:KKLanguage(@"lab_login_title") forState:UIControlStateNormal];
    [loginBtn setTitleColor:kkWhiteColor forState:UIControlStateNormal];
    loginBtn.backgroundColor = KKBgYellowColor;
    loginBtn.tag = KKButton_Account_Login;
    [self addSubview:loginBtn];
    _loginBtn = loginBtn;
    
    
    
    UIButton * forgetbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetbtn.frame = CGRectMake(_loginBtn.frame.origin.x, _loginBtn.frame.size.height+_loginBtn.frame.origin.y, kk_x(150), KKButtonHeight);
    [forgetbtn setTitle:KKLanguage(@"lab_login_forget_password") forState:UIControlStateNormal];
    [forgetbtn setTitleColor:kkTextBlackColor forState:UIControlStateNormal];
    forgetbtn.tag = KKButton_Account_Forget;
    forgetbtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self addSubview:forgetbtn];
    forgetbtn.titleLabel.font = kk_sizefont(KKFont_Normal);
    _forgotBtn = forgetbtn;
    
    
    UIButton * registerbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registerbtn.frame = CGRectMake(KKSceneWidth-kk_x(40)-forgetbtn.frame.size.width, forgetbtn.frame.origin.y, forgetbtn.frame.size.width, forgetbtn.frame.size.height);
    [registerbtn setTitle:KKLanguage(@"lab_login_reginster") forState:UIControlStateNormal];
    [registerbtn setTitleColor:kkTextBlackColor forState:UIControlStateNormal];
    registerbtn.tag = KKButton_Account_Register;
    registerbtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self addSubview:registerbtn];
    registerbtn.titleLabel.font = kk_sizefont(KKFont_Normal);
    _registerBtn = registerbtn;
}

#pragma mark ============== 登录视图 email ===============
- (void)emailLoginView:(float)tfWidth withHeight:(float)tfHeight{
    
    UIImage * image = [UIImage imageNamed:@"img_login_email"];
    
    UIImageView * logoImageView = [[UIImageView alloc] init];
    logoImageView.frame = CGRectMake(kk_x(20), tfHeight/2 - image.size.height/2, image.size.width, image.size.height);
    logoImageView.image =  image;
   
    
    UIView *  view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, logoImageView.frame.origin.x+logoImageView.frame.size.width+kk_x(20), tfHeight)];
    [view addSubview:logoImageView];


    UITextField * tf = [[UITextField alloc] initWithFrame:CGRectMake(kk_x(40), kk_y(20), tfWidth, tfHeight)];
    tf.backgroundColor = kkWhiteColor;
    tf.borderStyle = UITextBorderStyleNone;
    tf.keyboardType = UIKeyboardTypeASCIICapable;
    tf.placeholder = KKLanguage(@"lab_login_enter_email");
    tf.leftViewMode = UITextFieldViewModeAlways;
    tf.leftView = view;
    tf.font = kk_sizefont(KKFont_Normal);
    [self addSubview:tf];
    _loginTf = tf;
    
    
    
    image = [UIImage imageNamed:@"img_login_psw"];
    
    logoImageView = [[UIImageView alloc] init];
    logoImageView.frame = CGRectMake(kk_x(20), tfHeight/2 - image.size.height/2, image.size.width, image.size.height);
    logoImageView.image =  image;
   
    view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, logoImageView.frame.origin.x+logoImageView.frame.size.width+kk_x(20), tfHeight)];
    [view addSubview:logoImageView];

    
    
    UITextField * pswtf = [[UITextField alloc] initWithFrame:CGRectMake(kk_x(40), _loginTf.frame.size.height+_loginTf.frame.origin.y+kk_y(20), tfWidth, tfHeight)];
    pswtf.backgroundColor = kkWhiteColor;
    pswtf.borderStyle = UITextBorderStyleNone;
    pswtf.leftViewMode = UITextFieldViewModeAlways;
    pswtf.placeholder = KKLanguage(@"lab_login_password");
    pswtf.leftView =view;
    pswtf.secureTextEntry = YES;
    pswtf.font = kk_sizefont(KKFont_Normal);
    [self addSubview:pswtf];
    _loginPswTf = pswtf;
    
    
    
    UIButton * loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(_loginTf.frame.origin.x, _loginPswTf.frame.size.height+_loginPswTf.frame.origin.y+kk_y(20)*2, tfWidth, KKButtonHeight);
    [loginBtn setTitle:KKLanguage(@"lab_login_title") forState:UIControlStateNormal];
    [loginBtn setTitleColor:kkWhiteColor forState:UIControlStateNormal];
    loginBtn.backgroundColor = KKBgYellowColor;
    loginBtn.tag = KKButton_Account_Login_email;
    [self addSubview:loginBtn];
    _loginBtn = loginBtn;
    
    
    
    UIButton * forgetbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetbtn.frame = CGRectMake(loginBtn.frame.origin.x, loginBtn.frame.size.height+loginBtn.frame.origin.y, kk_x(150), KKButtonHeight);
    [forgetbtn setTitle:KKLanguage(@"lab_login_forget_password") forState:UIControlStateNormal];
    [forgetbtn setTitleColor:kkTextBlackColor forState:UIControlStateNormal];
    forgetbtn.tag = KKButton_Account_Forget;
    forgetbtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self addSubview:forgetbtn];
    forgetbtn.titleLabel.font = kk_sizefont(KKFont_Normal);
    _forgotBtn = forgetbtn;
    
    
    UIButton * registerbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registerbtn.frame = CGRectMake(KKSceneWidth-kk_x(40)-forgetbtn.frame.size.width, forgetbtn.frame.origin.y, forgetbtn.frame.size.width, forgetbtn.frame.size.height);
    [registerbtn setTitle:KKLanguage(@"lab_login_reginster") forState:UIControlStateNormal];
    [registerbtn setTitleColor:kkTextBlackColor forState:UIControlStateNormal];
    registerbtn.tag = KKButton_Account_Register;
    registerbtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self addSubview:registerbtn];
    registerbtn.titleLabel.font = kk_sizefont(KKFont_Normal);
    _registerBtn = registerbtn;
}

#pragma mark ============== 忘记密码 phone ===============
- (void)phoneForgotView:(float)tfWidth withHeight:(float)tfHeight{

    
    UIImage * image = [UIImage imageNamed:@"img_login_phone"];
    
    UIImageView * logoImageView = [[UIImageView alloc] init];
    logoImageView.frame = CGRectMake(kk_x(20), tfHeight/2 - image.size.height/2, image.size.width, image.size.height);
    logoImageView.image =  image;

    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(logoImageView.frame.size.width+logoImageView.frame.origin.x, 0, kk_x(140), tfHeight);
   
    [btn setImage:[UIImage imageNamed:@"img_btn_phone_area"] forState:UIControlStateNormal];
    
    [btn setTitle:@"+86" forState:UIControlStateNormal];
    [btn setTitleColor:kkTextGrayColor forState:UIControlStateNormal];
    btn.titleLabel.font = kk_sizefont(KKFont_Normal);
    
    btn.tag = KKButton_Account_Area;
    _phoneLoginAreaBtn = btn;
    
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, -btn.imageView.image.size.width-10, 0, btn.imageView.image.size.width);
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, btn.titleLabel.bounds.size.width+10, 0, -btn.titleLabel.frame.size.width);
   

    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, btn.frame.origin.x+btn.frame.size.width, tfHeight)];
    [view addSubview:logoImageView];
    [view addSubview:_phoneLoginAreaBtn];
    

    UITextField * tf = [[UITextField alloc] initWithFrame:CGRectMake(kk_x(40), kk_y(20), tfWidth, tfHeight)];
    tf.backgroundColor = kkWhiteColor;
    tf.borderStyle = UITextBorderStyleNone;
    tf.keyboardType = UIKeyboardTypePhonePad;
    tf.leftView = view;
    tf.leftViewMode = UITextFieldViewModeAlways;
    tf.placeholder = KKLanguage(@"lab_login_enter_phone");
    tf.font = kk_sizefont(KKFont_Normal);
    [self addSubview:tf];
    _phoneTf = tf;
    
    
    
    
    UITextField * pswtf = [[UITextField alloc] initWithFrame:CGRectMake(kk_x(40), tf.frame.size.height+tf.frame.origin.y+kk_y(20), tfWidth, tfHeight)];
    pswtf.backgroundColor = kkWhiteColor;
    pswtf.borderStyle = UITextBorderStyleNone;
    pswtf.leftViewMode = UITextFieldViewModeAlways;
    pswtf.placeholder = KKLanguage(@"lab_login_enter_new_password");
    pswtf.secureTextEntry = YES;
    pswtf.font = kk_sizefont(KKFont_Normal);
    image = [UIImage imageNamed:@"img_login_psw"];
    
    logoImageView = [[UIImageView alloc] init];
    logoImageView.frame = CGRectMake(kk_x(20), tfHeight/2 - image.size.height/2, image.size.width, image.size.height);
    logoImageView.image =  image;


    view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, logoImageView.frame.origin.x+logoImageView.frame.size.width+kk_x(20), tfHeight)];
    [view addSubview:logoImageView];

    pswtf.leftView = view;
    
    [self addSubview:pswtf];
    _pswTf = pswtf;
    
    
    
    UITextField * vcodetf = [[UITextField alloc] initWithFrame:CGRectMake(kk_x(40), pswtf.frame.size.height+pswtf.frame.origin.y+kk_y(20), tfWidth, tfHeight)];
    vcodetf.backgroundColor = kkWhiteColor;
    vcodetf.borderStyle = UITextBorderStyleNone;
    vcodetf.leftViewMode = UITextFieldViewModeAlways;
    vcodetf.keyboardType = UIKeyboardTypePhonePad;
    vcodetf.placeholder = KKLanguage(@"lab_login_enter_vcode");
    vcodetf.font = kk_sizefont(KKFont_Normal);
    
    image = [UIImage imageNamed:@"img_login_vcode"];
    
    logoImageView = [[UIImageView alloc] init];
    logoImageView.frame = CGRectMake(kk_x(20), tfHeight/2 - image.size.height/2, image.size.width, image.size.height);
    logoImageView.image =  image;


    view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, logoImageView.frame.origin.x+logoImageView.frame.size.width+kk_x(20), tfHeight)];
    [view addSubview:logoImageView];

    vcodetf.leftView = view;
    
    [self addSubview:vcodetf];
    _vcodeTf = vcodetf;
    
    
    
    
    
    
    UIButton * vcodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    vcodeBtn.frame = CGRectMake(vcodetf.frame.size.width - kk_x(200), 0, kk_x(200), vcodetf.frame.size.height);
    
    [vcodeBtn setTitle:KKLanguage(@"lab_login_vcode_get") forState:UIControlStateNormal];
    [vcodeBtn setTitleColor:KKBgYellowColor forState:UIControlStateNormal];
    vcodeBtn.titleLabel.font = kk_sizefont(KKFont_small_large);
    
    vcodeBtn.tag = KKButton_Forget_GetVcode;
    [vcodetf addSubview:vcodeBtn];
    _vcodeBtn = vcodeBtn;
    
    
    UIButton * loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(vcodetf.frame.origin.x, vcodetf.frame.size.height+vcodetf.frame.origin.y+KKButtonHeight, tfWidth, KKButtonHeight);
    [loginBtn setTitle:KKLanguage(@"lab_login_find_psw") forState:UIControlStateNormal];
    [loginBtn setTitleColor:kkWhiteColor forState:UIControlStateNormal];
    loginBtn.backgroundColor = KKBgYellowColor;
    loginBtn.tag = KKButton_Forget_Find;
    [self addSubview:loginBtn];
    loginBtn.titleLabel.font = kk_sizefont(KKFont_Normal);
    _findBtn = loginBtn;
    
    
    
    UIButton * findBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    findBtn.frame = CGRectMake(loginBtn.center.x-tfWidth/3/2, loginBtn.frame.size.height+loginBtn.frame.origin.y, tfWidth/3, KKButtonHeight);
    [findBtn setTitleColor:KKBgYellowColor forState:UIControlStateNormal];
    findBtn.tag = KKButton_Forget_FindType;
    findBtn.titleLabel.font = kk_sizefont(KKFont_Normal);
    [self addSubview:findBtn];
    _findTypeBtn = findBtn;
    
    
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:KKLanguage(@"lab_login_find_psw_email")];
    NSRange titleRange = {0,[title length]};
    [title addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:titleRange];
    [findBtn setAttributedTitle:title
                   forState:UIControlStateNormal];
    
    
}

#pragma mark ============== 忘记密码 email ===============
- (void)emailForgotView:(float)tfWidth withHeight:(float)tfHeight{
    
    UITextField * pswtf = [[UITextField alloc] initWithFrame:CGRectMake(kk_x(40), kk_y(20), tfWidth, tfHeight)];
   
    pswtf.backgroundColor = kkWhiteColor;
    pswtf.borderStyle = UITextBorderStyleNone;
    pswtf.leftViewMode = UITextFieldViewModeAlways;
    pswtf.placeholder = KKLanguage(@"lab_login_email");
    pswtf.keyboardType = UIKeyboardTypeASCIICapable;
    pswtf.font = kk_sizefont(KKFont_Normal);
    UIImage * image = [UIImage imageNamed:@"img_login_email"];
    
    UIImageView * logoImageView = [[UIImageView alloc] init];
    logoImageView.frame = CGRectMake(kk_x(20), tfHeight/2 - image.size.height/2, image.size.width, image.size.height);
    logoImageView.image =  image;


    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, logoImageView.frame.origin.x+logoImageView.frame.size.width+kk_x(20), tfHeight)];
    [view addSubview:logoImageView];

    pswtf.leftView = view;
    
    [self addSubview:pswtf];
    _pswTf = pswtf;
    
    


    UIButton * loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(pswtf.frame.origin.x, pswtf.frame.size.height+pswtf.frame.origin.y+KKButtonHeight, tfWidth, KKButtonHeight);
    [loginBtn setTitle:KKLanguage(@"lab_login_find_psw") forState:UIControlStateNormal];
    [loginBtn setTitleColor:kkWhiteColor forState:UIControlStateNormal];
    loginBtn.backgroundColor = KKBgYellowColor;
    loginBtn.tag = KKButton_Forget_Find;
    loginBtn.titleLabel.font = kk_sizefont(KKFont_Normal);
    [self addSubview:loginBtn];
    _findBtn = loginBtn;
    
    
    UIButton * findBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    findBtn.frame = CGRectMake(loginBtn.center.x - tfWidth/3/2 , loginBtn.frame.size.height+loginBtn.frame.origin.y, tfWidth/3, KKButtonHeight);
    [findBtn setTitleColor:KKBgYellowColor forState:UIControlStateNormal];
    findBtn.tag = KKButton_Forget_FindType;
    [self addSubview:findBtn];
    findBtn.titleLabel.font = kk_sizefont(KKFont_Normal);
    _findTypeBtn = findBtn;
    
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:KKLanguage(@"lab_login_find_psw_phone")];
    NSRange titleRange = {0,[title length]};
    [title addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:titleRange];
    [findBtn setAttributedTitle:title
                   forState:UIControlStateNormal];
    
    
}
#pragma mark ============== 注册 phone ===============
- (void)phoneRegisterView:(float)tfWidth withHeight:(float)tfHeight{
    
    UIImage * image = [UIImage imageNamed:@"img_login_phone"];
    
    UIImageView * logoImageView = [[UIImageView alloc] init];
    logoImageView.frame = CGRectMake(kk_x(20), tfHeight/2 - image.size.height/2, image.size.width, image.size.height);
    logoImageView.image =  image;

    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(logoImageView.frame.size.width+logoImageView.frame.origin.x, 0, kk_x(140), tfHeight);
   
    [btn setImage:[UIImage imageNamed:@"img_btn_phone_area"] forState:UIControlStateNormal];
    
    [btn setTitle:@"+86" forState:UIControlStateNormal];
    [btn setTitleColor:kkTextGrayColor forState:UIControlStateNormal];
    btn.titleLabel.font = kk_sizefont(KKFont_Normal);
    
    btn.tag = KKButton_Account_Area;
    _phoneLoginAreaBtn = btn;
    
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, -btn.imageView.image.size.width-10, 0, btn.imageView.image.size.width);
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, btn.titleLabel.bounds.size.width+10, 0, -btn.titleLabel.frame.size.width);
   

    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, btn.frame.origin.x+btn.frame.size.width, tfHeight)];
    [view addSubview:logoImageView];
    [view addSubview:_phoneLoginAreaBtn];
    

    UITextField * tf = [[UITextField alloc] initWithFrame:CGRectMake(kk_x(40), kk_y(20), tfWidth, tfHeight)];
    tf.backgroundColor = kkWhiteColor;
    tf.borderStyle = UITextBorderStyleNone;
    tf.keyboardType = UIKeyboardTypePhonePad;
    tf.leftView = view;
    tf.leftViewMode = UITextFieldViewModeAlways;
    tf.placeholder = KKLanguage(@"lab_login_enter_phone");
    tf.font = kk_sizefont(KKFont_Normal);
    [self addSubview:tf];
    _loginTf = tf;
    
    
    UITextField * pswtf = [[UITextField alloc] initWithFrame:CGRectMake(kk_x(40), _loginTf.frame.size.height+_loginTf.frame.origin.y+kk_y(20), tfWidth, tfHeight)];
    pswtf.backgroundColor = kkWhiteColor;
    pswtf.borderStyle = UITextBorderStyleNone;
    pswtf.leftViewMode = UITextFieldViewModeAlways;
    pswtf.placeholder = KKLanguage(@"lab_login_password");
    pswtf.secureTextEntry = YES;
    pswtf.font = kk_sizefont(KKFont_Normal);
    image = [UIImage imageNamed:@"img_login_psw"];
    
    logoImageView = [[UIImageView alloc] init];
    logoImageView.frame = CGRectMake(kk_x(20), tfHeight/2 - image.size.height/2, image.size.width, image.size.height);
    logoImageView.image =  image;


    view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, logoImageView.frame.origin.x+logoImageView.frame.size.width+kk_x(20), tfHeight)];
    [view addSubview:logoImageView];

    pswtf.leftView = view;
    
    [self addSubview:pswtf];
    _loginPswTf = pswtf;
    
    
    
    
    UITextField * vcodetf = [[UITextField alloc] initWithFrame:CGRectMake(kk_x(40), _loginPswTf.frame.size.height+_loginPswTf.frame.origin.y+kk_y(20), tfWidth, tfHeight)];
    vcodetf.backgroundColor = kkWhiteColor;
    vcodetf.borderStyle = UITextBorderStyleNone;
    vcodetf.leftViewMode = UITextFieldViewModeAlways;
    vcodetf.keyboardType = UIKeyboardTypePhonePad;
    vcodetf.placeholder = KKLanguage(@"lab_login_enter_vcode");
    vcodetf.font = kk_sizefont(KKFont_Normal);
    image = [UIImage imageNamed:@"img_login_vcode"];
    
    logoImageView = [[UIImageView alloc] init];
    logoImageView.frame = CGRectMake(kk_x(20), tfHeight/2 - image.size.height/2, image.size.width, image.size.height);
    logoImageView.image =  image;


    view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, logoImageView.frame.origin.x+logoImageView.frame.size.width+kk_x(20), tfHeight)];
    [view addSubview:logoImageView];

    vcodetf.leftView = view;
    
    [self addSubview:vcodetf];
    _vcodeTf = vcodetf;
    
    UIButton * vcodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    vcodeBtn.frame = CGRectMake(vcodetf.frame.size.width - kk_x(200), 0, kk_x(200), vcodetf.frame.size.height);
    
    [vcodeBtn setTitle:KKLanguage(@"lab_login_vcode_get") forState:UIControlStateNormal];
    [vcodeBtn setTitleColor:KKBgYellowColor forState:UIControlStateNormal];
    vcodeBtn.titleLabel.font = kk_sizefont(KKFont_small_large);
    
    vcodeBtn.tag = KKButton_Register_GetVcode;
    [vcodetf addSubview:vcodeBtn];
    _vcodeBtn = vcodeBtn;
    
    

    
    UIButton * loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(_loginTf.frame.origin.x, _vcodeTf.frame.size.height+_vcodeTf.frame.origin.y+kk_y(20)*2, tfWidth, KKButtonHeight);
    [loginBtn setTitle:KKLanguage(@"lab_login_reginster") forState:UIControlStateNormal];
    [loginBtn setTitleColor:kkWhiteColor forState:UIControlStateNormal];
    loginBtn.backgroundColor = KKBgYellowColor;
    loginBtn.tag = KKButton_Account_Register;
    [self addSubview:loginBtn];
    _loginBtn = loginBtn;
    
    
    image = [UIImage imageNamed:@"img_btn_agreement_nor"];
    
    UIButton * selectAgreementBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectAgreementBtn.frame = CGRectMake(_loginTf.frame.origin.x - (kk_x(60)-image.size.width)/2, _loginBtn.frame.size.height+_loginBtn.frame.origin.y, kk_x(60), KKButtonHeight);
    [selectAgreementBtn setImage:image forState:UIControlStateNormal];
    [selectAgreementBtn setImage:[UIImage imageNamed:@"img_btn_agreement_sel"] forState:UIControlStateSelected];
    selectAgreementBtn.tag = KKButton_Register_selectAgreement;
    [self addSubview:selectAgreementBtn];
    _selectAgreementBtn = selectAgreementBtn;
    
    
    
    float width = [[HJCommon shareInstance] getWidth:KKLanguage(@"lab_login_serve_text1") height:KKButtonHeight font:KKFont_small_large];
    
    UILabel * titleLab = [[UILabel alloc] init];
    titleLab.frame = CGRectMake(selectAgreementBtn.frame.size.width+selectAgreementBtn.frame.origin.x, selectAgreementBtn.frame.origin.y, width, KKButtonHeight);
    titleLab.text = KKLanguage(@"lab_login_serve_text1");
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = kk_sizefont(KKFont_small_large);
    titleLab.textColor = kkTextBlackColor;
    [self addSubview:titleLab];
    
    
    
    width = [[HJCommon shareInstance] getWidth:KKLanguage(@"lab_login_serve_text2") height:KKButtonHeight font:KKFont_small_large];
    
    UIButton * agreementBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    agreementBtn.frame = CGRectMake(titleLab.frame.size.width+titleLab.frame.origin.x, titleLab.frame.origin.y, width, KKButtonHeight);
    [agreementBtn setTitle:KKLanguage(@"lab_login_serve_text2") forState:UIControlStateNormal];
    agreementBtn.tag = KKButton_Register_agreement;
    [agreementBtn setTitleColor:KKBgYellowColor forState:UIControlStateNormal];
    agreementBtn.titleLabel.font = kk_sizefont(KKFont_small_large);
    [self addSubview:agreementBtn];
    _agreementBtn = agreementBtn;
    
    

}

#pragma mark ============== 注册 email ===============
- (void)emailRegisterView:(float)tfWidth withHeight:(float)tfHeight{
    
    UIImage * image = [UIImage imageNamed:@"img_login_email"];
    
    UIImageView * logoImageView = [[UIImageView alloc] init];
    logoImageView.frame = CGRectMake(kk_x(20), tfHeight/2 - image.size.height/2, image.size.width, image.size.height);
    logoImageView.image =  image;
   
    
    UIView *  view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, logoImageView.frame.origin.x+logoImageView.frame.size.width+kk_x(20), tfHeight)];
    [view addSubview:logoImageView];


    UITextField * tf = [[UITextField alloc] initWithFrame:CGRectMake(kk_x(40), kk_y(20), tfWidth, tfHeight)];
    tf.backgroundColor = kkWhiteColor;
    tf.borderStyle = UITextBorderStyleNone;
    tf.keyboardType = UIKeyboardTypeASCIICapable;
    tf.placeholder = KKLanguage(@"lab_login_enter_email");
    tf.leftViewMode = UITextFieldViewModeAlways;
    tf.leftView = view;
    tf.font = kk_sizefont(KKFont_Normal);
    [self addSubview:tf];
    _loginTf = tf;
    
    
    
    image = [UIImage imageNamed:@"img_login_psw"];
    
    logoImageView = [[UIImageView alloc] init];
    logoImageView.frame = CGRectMake(kk_x(20), tfHeight/2 - image.size.height/2, image.size.width, image.size.height);
    logoImageView.image =  image;
   
    view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, logoImageView.frame.origin.x+logoImageView.frame.size.width+kk_x(20), tfHeight)];
    [view addSubview:logoImageView];

    
    
    UITextField * pswtf = [[UITextField alloc] initWithFrame:CGRectMake(kk_x(40), _loginTf.frame.size.height+_loginTf.frame.origin.y+kk_y(20), tfWidth, tfHeight)];
    pswtf.backgroundColor = kkWhiteColor;
    pswtf.borderStyle = UITextBorderStyleNone;
    pswtf.leftViewMode = UITextFieldViewModeAlways;
    pswtf.placeholder = KKLanguage(@"lab_login_password");
    pswtf.leftView =view;
    pswtf.secureTextEntry = YES;
    pswtf.font = kk_sizefont(KKFont_Normal);
    [self addSubview:pswtf];
    _loginPswTf = pswtf;
    
    
    
    UIButton * loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(_loginTf.frame.origin.x, _loginPswTf.frame.size.height+_loginPswTf.frame.origin.y+kk_y(20)*2, tfWidth, KKButtonHeight);
    [loginBtn setTitle:KKLanguage(@"lab_login_reginster") forState:UIControlStateNormal];
    [loginBtn setTitleColor:kkWhiteColor forState:UIControlStateNormal];
    loginBtn.backgroundColor = KKBgYellowColor;
    loginBtn.tag = KKButton_Account_Register_email;
    [self addSubview:loginBtn];
    _loginBtn = loginBtn;
    
    
    image = [UIImage imageNamed:@"img_btn_agreement_nor"];
    
    UIButton * selectAgreementBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectAgreementBtn.frame = CGRectMake(_loginTf.frame.origin.x - (kk_x(60)-image.size.width)/2, _loginBtn.frame.size.height+_loginBtn.frame.origin.y, kk_x(60), KKButtonHeight);
    [selectAgreementBtn setImage:image forState:UIControlStateNormal];
    [selectAgreementBtn setImage:[UIImage imageNamed:@"img_btn_agreement_sel"] forState:UIControlStateSelected];
    selectAgreementBtn.tag = KKButton_Register_selectAgreement;
    [self addSubview:selectAgreementBtn];
    _selectAgreementBtn = selectAgreementBtn;
    
    
    
    float width = [[HJCommon shareInstance] getWidth:KKLanguage(@"lab_login_serve_text1") height:KKButtonHeight font:KKFont_small_large];
    
    UILabel * titleLab = [[UILabel alloc] init];
    titleLab.frame = CGRectMake(selectAgreementBtn.frame.size.width+selectAgreementBtn.frame.origin.x, selectAgreementBtn.frame.origin.y, width, KKButtonHeight);
    titleLab.text = KKLanguage(@"lab_login_serve_text1");
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = kk_sizefont(KKFont_small_large);
    titleLab.textColor = kkTextBlackColor;
    [self addSubview:titleLab];
    
    
    
    width = [[HJCommon shareInstance] getWidth:KKLanguage(@"lab_login_serve_text2") height:KKButtonHeight font:KKFont_small_large];
    
    UIButton * agreementBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    agreementBtn.frame = CGRectMake(titleLab.frame.size.width+titleLab.frame.origin.x, titleLab.frame.origin.y, width, KKButtonHeight);
    [agreementBtn setTitle:KKLanguage(@"lab_login_serve_text2") forState:UIControlStateNormal];
    agreementBtn.tag = KKButton_Register_agreement;
    [agreementBtn setTitleColor:KKBgYellowColor forState:UIControlStateNormal];
    agreementBtn.titleLabel.font = kk_sizefont(KKFont_small_large);
    [self addSubview:agreementBtn];
    _agreementBtn = agreementBtn;

    
}

#pragma mark ============== 更换手机号 ===============
- (void)phoneReplaceView:(float)tfWidth withHeight:(float)tfHeight{
    
    UILabel * titleLab = [[UILabel alloc] init];
    titleLab.frame = CGRectMake(kk_x(40), 0, self.frame.size.width - kk_x(40), KKButtonHeight);
    titleLab.text = KKLanguage(@"lab_me_userInfo_bind_email_text2");
    titleLab.textAlignment = NSTextAlignmentLeft;
    titleLab.font = kk_sizefont(KKFont_small_large);
    titleLab.textColor = kkTextBlackColor;
    [self addSubview:titleLab];
    
    
    UIImage * image = [UIImage imageNamed:@"img_login_phone"];
    
    UIImageView * logoImageView = [[UIImageView alloc] init];
    logoImageView.frame = CGRectMake(kk_x(20), tfHeight/2 - image.size.height/2, image.size.width, image.size.height);
    logoImageView.image =  image;

    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(logoImageView.frame.size.width+logoImageView.frame.origin.x, 0, kk_x(140), tfHeight);
   
    [btn setImage:[UIImage imageNamed:@"img_btn_phone_area"] forState:UIControlStateNormal];
    
    [btn setTitle:@"+86" forState:UIControlStateNormal];
    [btn setTitleColor:kkTextGrayColor forState:UIControlStateNormal];
    btn.titleLabel.font = kk_sizefont(KKFont_Normal);
    
    btn.tag = KKButton_Account_Area;
    _phoneLoginAreaBtn = btn;
    
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, -btn.imageView.image.size.width-10, 0, btn.imageView.image.size.width);
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, btn.titleLabel.bounds.size.width+10, 0, -btn.titleLabel.frame.size.width);
   

    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, btn.frame.origin.x+btn.frame.size.width, tfHeight)];
    [view addSubview:logoImageView];
    [view addSubview:_phoneLoginAreaBtn];
    

    UITextField * tf = [[UITextField alloc] initWithFrame:CGRectMake(kk_x(40), titleLab.frame.size.height, tfWidth, tfHeight)];
    tf.backgroundColor = kkWhiteColor;
    tf.borderStyle = UITextBorderStyleNone;
    tf.keyboardType = UIKeyboardTypePhonePad;
    tf.leftView = view;
    tf.leftViewMode = UITextFieldViewModeAlways;
    tf.placeholder = KKLanguage(@"lab_login_enter_phone");
    tf.font = kk_sizefont(KKFont_Normal);
    [self addSubview:tf];
    _phoneTf = tf;
    
    
    
    UITextField * vcodetf = [[UITextField alloc] initWithFrame:CGRectMake(kk_x(40), tf.frame.size.height+tf.frame.origin.y+kk_y(20), tfWidth, tfHeight)];
    vcodetf.backgroundColor = kkWhiteColor;
    vcodetf.borderStyle = UITextBorderStyleNone;
    vcodetf.leftViewMode = UITextFieldViewModeAlways;
    vcodetf.keyboardType = UIKeyboardTypePhonePad;
    vcodetf.placeholder = KKLanguage(@"lab_login_enter_vcode");
    vcodetf.font = kk_sizefont(KKFont_Normal);
    image = [UIImage imageNamed:@"img_login_vcode"];
    
    logoImageView = [[UIImageView alloc] init];
    logoImageView.frame = CGRectMake(kk_x(20), tfHeight/2 - image.size.height/2, image.size.width, image.size.height);
    logoImageView.image =  image;


    view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, logoImageView.frame.origin.x+logoImageView.frame.size.width+kk_x(20), tfHeight)];
    [view addSubview:logoImageView];

    vcodetf.leftView = view;
    
    [self addSubview:vcodetf];
    _vcodeTf = vcodetf;
    
    
    

    
    UIButton * vcodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    vcodeBtn.frame = CGRectMake(vcodetf.frame.size.width - kk_x(200), 0, kk_x(200), vcodetf.frame.size.height);
    
    [vcodeBtn setTitle:KKLanguage(@"lab_login_vcode_get") forState:UIControlStateNormal];
    [vcodeBtn setTitleColor:KKBgYellowColor forState:UIControlStateNormal];
    vcodeBtn.titleLabel.font = kk_sizefont(KKFont_small_large);
    
    vcodeBtn.tag = KKButton_Account_GetVcode;
    [vcodetf addSubview:vcodeBtn];
    _vcodeBtn = vcodeBtn;
    
    
    UIButton * loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(vcodetf.frame.origin.x, vcodetf.frame.size.height+vcodetf.frame.origin.y+KKButtonHeight, tfWidth, KKButtonHeight);
    [loginBtn setTitle:KKLanguage(@"lab_feedback_submit") forState:UIControlStateNormal];
    [loginBtn setTitleColor:kkWhiteColor forState:UIControlStateNormal];
    loginBtn.backgroundColor = KKBgYellowColor;
    loginBtn.tag = KKButton_Confirm;
    [self addSubview:loginBtn];
    loginBtn.titleLabel.font = kk_sizefont(KKFont_Normal);
    _loginBtn = loginBtn;
    

}


@end
