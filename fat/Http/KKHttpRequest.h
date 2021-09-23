//
//  KKHttpRequest.h
//  ikonke API
//
//  Created by kk on 2019/4/2.
//  Copyright © 2019 hj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "HJAESUtil.h"

typedef NS_ENUM(NSInteger,HttpType){
    
    k_POST = 0,
    k_GET = 1,
    k_PUT = 2,
    K_DELETE = 3,
    
};

typedef void (^WXModuleCallback)(id result,NSDictionary * resultDic,HJHTTPModel * model);

@interface KKHttpRequest : NSObject

+(void)HttpRequestType:(HttpType)type 
       withrequestType:(BOOL)postJson  
        withDataString:(id)dataString 
               withUrl:(NSString*)url 
           withSuccess:(WXModuleCallback)successResult 
             withError:(WXModuleCallback)errorResult;



+ (void)fileDownUrl:(NSString*)url
        withSuccess:(void (^)(NSURL * filePath))successResult;

@end


