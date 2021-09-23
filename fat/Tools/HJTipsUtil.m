//
//  HJTipsUtil.m
//  fat
//
//  Created by ydd on 2021/6/17.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import "HJTipsUtil.h"

@implementation HJTipsUtil

+ (NSString*)resultTips:(HJHTTPModel*)model type:(NSInteger)type{
    
    NSString * url = model.commandCode;
    
    NSString * message = model.errormessage;
    
    if ([url isEqualToString:KK_URL_user_login_v2]) {
        /*
         登录
        */
        
        if (model.errorcode == 0) {
            
            message = KKLanguage(@"lab_login_success");
            
        }else if (model.errorcode == -1){
            
            message = KKLanguage(@"lab_tips_http_text3");
            
        }else if (model.errorcode == -2){
            
            message = KKLanguage(@"lab_tips_http_text2");
            
        }else if (model.errorcode == -3){
            
            message = KKLanguage(@"lab_tips_http_text1");
            
        }else if (model.errorcode == -4){
            
            if (type == KKButton_Account_Login_email) {
                message = KKLanguage(@"lab_tips_http_text13");
            }
        }
        
    }else if([url isEqualToString:KK_URL_verification_code]){
        /*
         验证码
         */
        if (model.errorcode == 0) {
            
            message = KKLanguage(@"lab_login_vcode_tips");
            
        }else if (model.errorcode == -1){
            
            message = KKLanguage(@"lab_tips_http_text3");
            
        }else if (model.errorcode == -2){
            
            message = KKLanguage(@"lab_tips_http_text4");
            
        }else if (model.errorcode == -3){
            
            message = KKLanguage(@"lab_tips_http_text5");
            
        }else if (model.errorcode == -4){
            
            message = KKLanguage(@"lab_tips_http_text1");
        }
        
        
    }else if([url isEqualToString:KK_URL_user_register_v2]){
        /*
         注册
         */
        if (model.errorcode == 0) {
            
            message = KKLanguage(@"lab_login_reginster_success");
            
        }else if (model.errorcode == -1){
            
            message = KKLanguage(@"lab_tips_http_text3");
            
        }else if (model.errorcode == -2){
            
            if (type == KKButton_Account_Register) {
                message = KKLanguage(@"lab_tips_http_text7");
            }else{
                message = KKLanguage(@"lab_tips_http_text19");
            }
            
        }else if (model.errorcode == -3){
            
            if (type == KKButton_Account_Register) {
                message = KKLanguage(@"lab_tips_http_text4");
            }
            
        }else if (model.errorcode == -4){
            
            message = KKLanguage(@"lab_tips_http_text8");
            
        }else if (model.errorcode == -5){
            
            if (type == KKButton_Account_Register_email) {
                message = KKLanguage(@"lab_tips_http_text11");
            }
        }
    }else if([url isEqualToString:KK_URL_find_password_by_phone]){
        /*
         手机找回密码
         */
        if (model.errorcode == 0) {
            
            message = KKLanguage(@"lab_tips_http_text14");
            
        }else if (model.errorcode == -1){
            
            message = KKLanguage(@"lab_tips_http_text3");
            
        }else if (model.errorcode == -2){
            
            message = KKLanguage(@"lab_tips_http_text7");
            
        }else if (model.errorcode == -3){
            
            message = KKLanguage(@"lab_tips_http_text1");
            
        }else if (model.errorcode == -4){
            
            message = KKLanguage(@"lab_tips_http_text15");
            
        }
        
    }else if ([url isEqualToString:KK_URL_find_password_by_email]){
        /*
         邮箱找回密码
         */
        if (model.errorcode == 0) {
            
            message = KKLanguage(@"lab_tips_http_text17");
            
        }else if (model.errorcode == -1){
            
            message = KKLanguage(@"lab_tips_http_text3");
            
        }else if(model.errorcode == -2){
            
            message = KKLanguage(@"lab_tips_http_text1");
            
        }else if(model.errorcode == -4){
            
            message = KKLanguage(@"lab_tips_http_text18");
            
        }else if (model.errorcode == -5){
            
            message = KKLanguage(@"lab_tips_http_text20");
        }
        

    }else if ([url isEqualToString:KK_URL_user_change_phone]){
        
        /*
         修改绑定手机号
         */
        if (model.errorcode == 0) {
            
            message = KKLanguage(@"lab_tips_http_text14");
            
        }else if (model.errorcode == -1){
            
            message = KKLanguage(@"lab_tips_http_text3");
            
        }else if (model.errorcode == -2){
            
            message = KKLanguage(@"lab_tips_http_text4");
            
        }else if (model.errorcode == -3){
            
            message = KKLanguage(@"lab_tips_http_text7");
            
        }else if (model.errorcode == -4){
            
            message = KKLanguage(@"lab_tips_http_text15");
        }
        
    }else if([url isEqualToString:KK_URL_unbound_user]){
        
        /*
         解绑邮箱
         */
        if (model.errorcode == 0) {
            
            message = KKLanguage(@"lab_tips_http_text14");
            
        }else if (model.errorcode == -1){
            
            message = KKLanguage(@"lab_tips_http_text3");
            
        }else if (model.errorcode == -3){
            
            message = KKLanguage(@"lab_tips_http_text16");
            
        }
        
        
    }
    
    return message;
}

@end
