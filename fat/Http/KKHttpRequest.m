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
    
    NSString * Authorization = [[NSUserDefaults standardUserDefaults] objectForKey:KKAccount_Token];
    
    NSString * timestamp = [[HJCommon shareInstance] getTimestamp];
    
    NSString * requesrUrl = [[HJCommon shareInstance] isDebug]?HOST_URl_TEST:HOST_URl;
    
    requesrUrl = [NSString stringWithFormat:@"%@%@",requesrUrl,url];
    

    NSString * Language = [[[[HJCommon shareInstance] getCurrectLocalLanguage] componentsSeparatedByString:@"-"] firstObject];
  
    
    //json 作为请求体
    
    NSMutableURLRequest * request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:requesrUrl parameters:nil error:nil];

    
    //请求头类型
    [request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    [request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Accept"];
    
    [request setValue:[[HJCommon shareInstance] getAppBundleID]  forHTTPHeaderField:@"App-Id"];
    [request setValue:Language forHTTPHeaderField:@"Language"];
    [request setValue:@"1.0" forHTTPHeaderField:@"Version"];
    [request setValue:timestamp forHTTPHeaderField:@"Ts"];
    [request setValue:@"1" forHTTPHeaderField:@"Sign"];
    [request setValue:Authorization==nil?@"":Authorization forHTTPHeaderField:@"Authorization"];
    
    if (dataString) {
        
        NSData * bodyData = [NSJSONSerialization dataWithJSONObject:dataString options:NSJSONWritingPrettyPrinted error:nil];
        
        [request setHTTPBody:bodyData];
    }

    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (error) {
                //请求失败
                NSLog(@"hj_error:%@",error);
                errorResult(error,@{@"msg":KKLanguage(@"tips_fail")},nil);
                
            } else {  //请求成功
                
                NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                NSError* err = nil;
                
                HJHTTPModel * model = [[HJHTTPModel alloc] initWithData:data error:&err];
                
                if ([dic isKindOfClass:[NSDictionary class]]) {
                    
                    NSLog(@"hj_success:%@",dic);
                    
                    if (model.code == KKStatus_Token_invalid) {
                        
                        [[HJCommon shareInstance] logout:YES toast:model.msg];
                        
                    }else{
                        
                        successResult(data,dic,model);
                    }
                
                }else{
                    
                    NSLog(@"特殊hj_success:%@",dic);
                    
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
