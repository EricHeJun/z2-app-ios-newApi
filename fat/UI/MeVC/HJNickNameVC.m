//
//  HJNickNameVC.m
//  fat
//
//  Created by ydd on 2021/4/26.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import "HJNickNameVC.h"

@interface HJNickNameVC ()<UITextFieldDelegate>

@end

@implementation HJNickNameVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self initUI];
    
    [self refreshUI];
    
}
- (void)initUI{
    
    [self addRightBtnOneWithString:KKLanguage(@"lab_me_userInfo_save")];
    self.view.backgroundColor = kkBgGrayColor;
    
    UIView * bgView = [[UIView alloc] init];
    bgView.frame  = CGRectMake(0, 0, kk_x(20), KKButtonHeight);
    
    UITextField * tf = [[UITextField alloc] init];
    tf.frame = CGRectMake(0, kk_y(20)+KKNavBarHeight, KKSceneWidth, KKButtonHeight);
    tf.backgroundColor = kkWhiteColor;
    tf.leftView = bgView;
    tf.leftViewMode = UITextFieldViewModeAlways;
    tf.delegate = self;
    [self.view addSubview:tf];
    [tf becomeFirstResponder];
    _nickTf = tf;
    
    UILabel * titleLab = [[UILabel alloc] init];
    titleLab.frame = CGRectMake(0, tf.frame.size.height+tf.frame.origin.y, KKSceneWidth, KKButtonHeight);
    titleLab.text = KKLanguage(@"lab_me_userInfo_text_20");
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = kk_sizefont(KKFont_small_12);
    titleLab.textColor = kkTextGrayColor;
    [self.view addSubview:titleLab];

}

- (void)refreshUI{
    
    _nickTf.text = self.nickName;
    
}

- (void)rightBtnOneClick:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
    
    if (self.selectBlock) {
        self.selectBlock(_nickTf.text?_nickTf.text:@"");
    }
    
}
#pragma mark ============== uitextdelegate ===============
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if ([toBeString length] > 20) {
        textField.text = [toBeString substringToIndex:20];
        return NO;
    }
    
    return YES;
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
