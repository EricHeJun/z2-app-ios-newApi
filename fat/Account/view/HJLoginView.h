//
//  HJLoginView.h
//  fat
//
//  Created by 何军 on 2021/4/14.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import "HJBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJLoginView : HJBaseView

/*
 登陆
 */
@property (strong,nonatomic)UIButton * phoneLoginAreaBtn;

@property (strong,nonatomic)UITextField * loginTf;
@property (strong,nonatomic)UITextField * loginPswTf;

@property (strong,nonatomic)UIButton * loginBtn;
@property (strong,nonatomic)UIButton * forgotBtn;
@property (strong,nonatomic)UIButton * registerBtn;


/*
 注册
 */
@property (strong,nonatomic)UITextField * vcodeTf;

@property (strong,nonatomic)UIButton * selectAgreementBtn;  //选中
@property (strong,nonatomic)UIButton * agreementBtn;        //用户协议


/*
 忘记密码
 */
@property (strong,nonatomic)UITextField * phoneTf;
@property (strong,nonatomic)UITextField * pswTf;

@property (strong,nonatomic)UIButton * vcodeBtn;

@property (strong,nonatomic)UIButton * findBtn;
@property (strong,nonatomic)UIButton * findTypeBtn;


- (instancetype)initWithFrame:(CGRect)frame withViewType:(KKViewType)type;

@end

NS_ASSUME_NONNULL_END
