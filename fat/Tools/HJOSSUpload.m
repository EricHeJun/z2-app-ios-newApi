//
//  HJOSSUpload.m
//  fat
//
//  Created by ydd on 2021/5/6.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import "HJOSSUpload.h"

/// 在使用 initWithAuthServerUrl 这种方式初始化阿里云的时候, 传入的 url 是自己家的url.
/// 但是! 一般自己家的url在做请求的时候, 往往在请求头(HTTPHeaderField)里面需要加入参数, 比如自己家用户登录的时候拿到的 token, 需要在后续所有请求头里加上这个token,
/// 再就是加入一些其他请求头参数, 比如, 哪个端,iOS,Android, 版本号之类.
/// 所以,我们 新建一个类, 继承自 OSSFederationCredentialProvider, 然后把 阿 里 云 代 码 直 接 拷 贝 过 来 改写.
@interface ISAuthCredentialProvider : OSSFederationCredentialProvider
@property (nonatomic, copy) NSString * authServerUrl;
@property (nonatomic, copy) NSData * (^responseDecoder)(NSData *);
- (instancetype)initWithAuthServerUrl:(NSString *)authServerUrl;
- (instancetype)initWithAuthServerUrl:(NSString *)authServerUrl responseDecoder:(nullable OSSResponseDecoderBlock)decoder;
@end

@implementation ISAuthCredentialProvider

- (instancetype)initWithAuthServerUrl:(NSString *)authServerUrl {
    return [self initWithAuthServerUrl:authServerUrl responseDecoder:nil];
}

- (instancetype)initWithAuthServerUrl:(NSString *)authServerUrl responseDecoder:(nullable OSSResponseDecoderBlock)decoder {
    
    self = [super initWithFederationTokenGetter:^OSSFederationToken * {
        
        NSString * Authorization = [[NSUserDefaults standardUserDefaults] objectForKey:KKAccount_Token];
        
        NSString * timestamp = [[HJCommon shareInstance] getTimestamp];
        
        NSString * requesrUrl = [[HJCommon shareInstance] isDebug]?HOST_URl_TEST:HOST_URl;
        
        requesrUrl = [NSString stringWithFormat:@"%@%@",requesrUrl,KK_URL_api_system_api_sts_server];
        
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
        
        [request setTimeoutInterval:12];
    
        
        OSSTaskCompletionSource * tcs = [OSSTaskCompletionSource taskCompletionSource];
        NSURLSession * session = [NSURLSession sharedSession];
        NSURLSessionTask * sessionTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error) {
                [tcs setError:error];
                return;
            }
            [tcs setResult:data];
        }];
        
        [sessionTask resume];
        [tcs.task waitUntilFinished];
        if (tcs.task.error) {
            return nil;
        } else {
            NSData* data = tcs.task.result;
            if(decoder){
                data = decoder(data);
            }
            NSDictionary * object = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:kNilOptions
                                                                      error:nil];
            int statusCode = [[object objectForKey:@"StatusCode"] intValue];
            if (statusCode == 200) {
                OSSFederationToken * token = [OSSFederationToken new];
                // All the entries below are mandatory.
                token.tAccessKey = [object objectForKey:@"AccessKeyId"];
                token.tSecretKey = [object objectForKey:@"AccessKeySecret"];
                token.tToken = [object objectForKey:@"SecurityToken"];
                token.expirationTimeInGMTFormat = [object objectForKey:@"Expiration"];
                OSSLogDebug(@"token: %@ %@ %@ %@", token.tAccessKey, token.tSecretKey, token.tToken, [object objectForKey:@"Expiration"]);
                return token;
            }else{
                return nil;
            }
            
        }
    }];

    
    if(self){
        self.authServerUrl = authServerUrl;
    }
    return self;
}

@end



OSSClient * client;

@implementation HJOSSUpload

static HJOSSUpload *_uploader;

+ (HJOSSUpload *)aliyunInit {
    @synchronized(self) {
        
        if (_uploader == nil) {
            
            //[OSSLog enableLog];
            
            _uploader = [[HJOSSUpload alloc] init];
            
            NSString *OSS_STSTOKEN_URL =[[HJCommon shareInstance] isDebug]?HOST_URl_TEST:HOST_URl;
            
            id<OSSCredentialProvider> credentialProvider = [[ISAuthCredentialProvider alloc] initWithAuthServerUrl:OSS_STSTOKEN_URL];
            
            OSSClientConfiguration *cfg = [[OSSClientConfiguration alloc] init];
            
            client = [[OSSClient alloc] initWithEndpoint:OSS_ENDPOINT credentialProvider:credentialProvider clientConfiguration:cfg];
            
      
        }
    }
    return _uploader;
}


- (void)uploadImage:(NSArray <UIImage *>*)imgArray success:(ImageCallback)success{
    
    dispatch_group_t group = dispatch_group_create();
    
    //名字数组
    NSMutableArray *nameArray = [NSMutableArray array];
    
    for (int i = 0; i < imgArray.count; i ++) {
        
        dispatch_group_enter(group); //进入组
        
        NSString * uuid = [NSUUID UUID].UUIDString;
        
        uuid = [uuid substringToIndex:13];

        NSString * fileAdreess = [NSString stringWithFormat:@"Fat/%@_%@.byte",[[HJCommon shareInstance] todayTime_yyyy_MM_DD_mm],uuid];
        

        OSSPutObjectRequest * put = [OSSPutObjectRequest new];
        put.contentType = @"image/jpeg";
        put.bucketName = BucketName;
        put.objectKey = fileAdreess;
        put.uploadingData = UIImageJPEGRepresentation(imgArray[i], 1);
        
        put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
            NSLog(@"进度%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
        };
        
        OSSTask * putTask = [client putObject:put];
        
        [putTask continueWithBlock:^id(OSSTask *task) {
            if (!task.error) {
                NSLog(@"图片上传成功!");
                [nameArray addObject:fileAdreess];
                
                success(YES,nameArray);
                
            } else{
                NSLog(@"图片上传失败: %@" , task.error);
                success(NO,nameArray);
            }
            dispatch_group_leave(group);  //不论是成功或者失败,都离开组
            return nil;
        }];
    }
    
//    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
//        
//        NSLog(@"任务全部完成,当前线程 %@",[NSThread currentThread]); //收到任务全部完成的通知
//    });
}



@end


