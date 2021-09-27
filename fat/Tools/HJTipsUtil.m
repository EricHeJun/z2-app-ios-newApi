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
    
    if([url isEqualToString:KK_URL_verification_code]){
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
