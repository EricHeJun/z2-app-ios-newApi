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
        
        //把原来的 NSURLRequest 改成 NSMutableURLRequest, 这样可以加入新的请求头参数, 就加入这么点东西,其余的代码不改.
        NSMutableURLRequest * request;
        
        NSString * access_token = [[NSUserDefaults standardUserDefaults] objectForKey:KKAccount_Token];
        
        NSString * timestamp = [[HJCommon shareInstance] getTimestamp];
        
        NSString * requesrUrl = authServerUrl;
        
        NSString * jsonStr = [[HJCommon shareInstance] dictionaryToJson:@{@"name":@"sts"}];
        
        NSString * AES = [HJAESUtil aesEncrypt:jsonStr];
        
        NSString * token = [[HJCommon shareInstance] md5To32bit:[NSString stringWithFormat:@"%@%@%@%@",timestamp,KK_URL_sts,AES,SECRET_KEY]];
        
        NSMutableDictionary * requestdic =  [NSMutableDictionary dictionary];
        
        [requestdic setObject:KK_URL_sts forKey:@"commandCode"];
        [requestdic setObject:AES forKey:@"data"];
        
        [requestdic setObject:timestamp forKey:@"timeStamp"];
        [requestdic setObject:token forKey:@"token"];
        
        [requestdic setObject:[[HJCommon shareInstance] getCurrectLocalCountry] forKey:@"langType"];
        [requestdic setObject:[[HJCommon shareInstance] getCurrectLocalLanguage] forKey:@"language"];
        
        [requestdic setObject:[[HJCommon shareInstance] getAppBundleID] forKey:@"application_ID"];
        [requestdic setObject:@"1.0" forKey:@"server_version"];
        
        [requestdic setObject:access_token==nil?@"":access_token forKey:@"access_token"];
        
        
        request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:requesrUrl parameters:requestdic error:nil];
        
        
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"application/json,text/plain" forHTTPHeaderField:@"Accept"];
        
        
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
            NSString *OSS_STSTOKEN_URL =[[HJCommon shareInstance] isDebug]?STS_URl_TEST:STS_URl;
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


