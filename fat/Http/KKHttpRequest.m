//
//  KKHttpRequest.m
//  ikonke API
//
//  Created by kk on 2019/4/2.
//  Copyright © 2019 hj. All rights reserved.
//

#import "KKHttpRequest.h"

@implementation KKHttpRequest

+(void)HttpRequestType:(HttpType)type 
       withrequestType:(BOOL)postJson  
        withDataString:(id)dataString 
               withUrl:(NSString*)url 
           withSuccess:(WXModuleCallback)successResult 
             withError:(WXModuleCallback)errorResult{
    
    NSMutableURLRequest * request;
    
    NSString * access_token = [[NSUserDefaults standardUserDefaults] objectForKey:KKAccount_Token];
    
    NSString * timestamp = [[HJCommon shareInstance] getTimestamp];
    
    NSString * requesrUrl = [[HJCommon shareInstance] isDebug]?HOST_URl_TEST:HOST_URl;
    
    NSString * jsonStr = [[HJCommon shareInstance] dictionaryToJson:dataString];
    
    NSString * AES = [HJAESUtil aesEncrypt:jsonStr];
    
    NSString * token = [[HJCommon shareInstance] md5To32bit:[NSString stringWithFormat:@"%@%@%@%@",timestamp,url,AES,SECRET_KEY]];
    
    
    NSMutableDictionary * requestdic =  [NSMutableDictionary dictionary];
    
    

    
    [requestdic setObject:url forKey:@"commandCode"];
    [requestdic setObject:AES forKey:@"data"];
    
    [requestdic setObject:timestamp forKey:@"timeStamp"];
    [requestdic setObject:token forKey:@"token"];
    
    NSString * country = [[[[HJCommon shareInstance] getCurrectLocalCountry] componentsSeparatedByString:@"_"] lastObject];
    [requestdic setObject:country forKey:@"langType"];
    
    NSString * Language = [[[[HJCommon shareInstance] getCurrectLocalLanguage] componentsSeparatedByString:@"-"] firstObject];
    [requestdic setObject:Language forKey:@"language"];
    
    [requestdic setObject:[[HJCommon shareInstance] getAppBundleID] forKey:@"application_ID"];
    [requestdic setObject:@"1.0" forKey:@"server_version"];
    
    [requestdic setObject:access_token==nil?@"":access_token forKey:@"access_token"];
    

    
    switch (type) {
            
        case k_POST:
            
            //json 作为请求体
            if (postJson) {
                
                request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:requesrUrl parameters:requestdic error:nil];
                //请求头类型
                [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                
                
            }else{ //表单 形式作为请求体
                
                request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:requesrUrl parameters:requestdic error:nil];
                
                
                [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
                [request setValue:@"application/json,text/plain" forHTTPHeaderField:@"Accept"];
                
            }
            
           
    
            break;
            
        case k_GET:
            
            request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:requesrUrl parameters:requestdic error:nil];

    
            break;
            
        default:
            break;
    }
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (error) {
                //请求失败
                NSLog(@"hj_error:%@",error);
                errorResult(error,@{@"msg":KKLanguage(@"tips_fail")},nil);
                
            } else {  //请求成功
                
                NSMutableDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                NSError* err = nil;
                
                HJHTTPModel * model = [[HJHTTPModel alloc] initWithData:data error:&err];
                
                if ([dic isKindOfClass:[NSDictionary class]]) {
                    
                    successResult(data,dic,model);
                    
                    NSLog(@"hj_success");
                }else{
                    NSLog(@"hj_success:%@",dic);
                }
            
            }
            
        });
    
    }];
    
    [dataTask resume];  //开始请求
}

+ (void)fileDownUrl:(NSString*)url
        withSuccess:(void (^)(NSURL * _Nullable filePath))successResult{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    NSURLSessionDownloadTask *downTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        //打印下载进度
        NSLog(@"%f",1.0 * downloadProgress.completedUnitCount/downloadProgress.totalUnitCount);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSString *fullPath = [filePath stringByAppendingPathComponent:response.suggestedFilename];
        
        NSLog(@"%@",fullPath);
        return [NSURL fileURLWithPath:fullPath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        if (error == nil) {
            successResult(filePath);
        }

    }];
    
    [downTask resume];
    
}

@end
