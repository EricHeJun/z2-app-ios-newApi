//
//  HJCommon.m
//  JiaYueShouYin
//
//  Created by 何军 on 2020/7/2.
//  Copyright © 2020 Eric. All rights reserved.
//

#import "HJCommon.h"
#import <CommonCrypto/CommonDigest.h>

/** URL、主地址 **/

/// 外网正式
NSString *const HOST_URl = @"http://admin.marvoto.com";
NSString *const STS_URl  = @"http://api.marvoto.com/MarvotoCloudService/mobile/sts_server";


/// 内网测试 - DEBUG
NSString *const HOST_URl_TEST = @"http://192.168.10.198/MarvotoCloudService/mobile/service";
NSString *const STS_URl_TEST = @"http://192.168.10.198/MarvotoCloudService/mobile/sts_server";

/// 请求共钥 / 密钥
NSString *const accessKeyId = @"ios";      
NSString *const accessSecret = @"2ojUCHz5xkA4TPmmdB8As49WJsZoga6M";

NSString *const SECRET_KEY = @"Mt2JtH7rP4h-2018";

/*
 新API
 */
NSString *const KK_URL_api_user_login = @"/api/user/login";  //登陆
NSString *const KK_URL_api_user_logout = @"/api/user/logout";  //退出
NSString *const KK_URL_api_user_info = @"/api/user/info";    //获取用户信息
NSString *const KK_URL_api_user_sms_code = @"/api/user/sms_code";
NSString *const KK_URL_api_user_register = @"/api/user/register";
NSString *const KK_URL_api_user_modify_pwd = @"/api/user/modify_pwd";    //手机找回密码
NSString *const KK_URL_api_user_email_find_pwd = @"/api/user/email_find_pwd";    //邮箱找回密码
NSString *const KK_URL_api_user_reset_pwd = @"/api/user/reset_pwd";   //密码重置

NSString *const KK_URL_api_user_modify_phone = @"/api/user/modify_phone";
NSString *const KK_URL_api_user_set_email = @"/api/user/set_email"; 

NSString *const KK_URL_api_fat_member_list = @"/api/fat/member_list";   
NSString *const KK_URL_api_fat_member_del = @"/api/fat/member_del";    
NSString *const KK_URL_api_fat_member_submit = @"/api/fat/member_submit";

/*
 旧API
 */
NSString *const KK_URL_api_fat_member_modify = @"/api/fat/member_modify";

NSString *const KK_URL_query_member_by_userid = @"query_member_by_userid";
NSString *const KK_URL_add_suggest = @"add_suggest";
NSString *const KK_URL_sts = @"sts";
NSString *const KK_URL_query_fat_record = @"query_fat_record";


NSString *const KK_URL_user_change_phone = @"user_change_phone";
NSString *const KK_URL_unbound_user = @"unbound_user";
NSString *const KK_URL_bound_user = @"bound_user";
NSString *const KK_URL_add_fat_record = @"add_fat_record";
NSString *const KK_URL_del_fat_record = @"del_fat_record";
NSString *const KK_URL_query_fat_record_by_recently = @"query_fat_record_by_recently";
NSString *const KK_URL_query_fat_record_by_date = @"query_fat_record_by_date";
NSString *const KK_URL_get_firmwareinfo = @"get_firmwareinfo";
NSString *const KK_URL_query_adview = @"query_adview";
NSString *const KK_URL_query_fat_record_by_month_avg = @"query_fat_record_by_month_avg";

/** 全局字符定义 **/
NSString *const KKAccount_Debug = @"KKAccount_Debug";
NSString *const KKAccount_All = @"KKAccount_All"; 
NSString *const KKAccount_Quit = @"KKAccount_Quit";
NSString *const KKAccount_Login = @"KKAccount_Login";
NSString *const KKAccount_Phone = @"KKAccount_Phone";
NSString *const KKAccount_Token = @"KKAccount_Token";
NSString *const KKAccount_userId = @"KKAccount_userId";

NSString *const KKAccount_selectModelInfo = @"KKAccount_selectModelInfo";

NSString *const KKAccount_TestId = @"-1";


NSString *const KKAccount_Photo = @"KKAccount_Photo"; 
NSString *const KKAccount_Edit_Photo = @"KKAccount_Edit_Photo";



NSString *const KKTest_Currect_Function = @"KKTest_Currect_Function";
NSString *const KKTest_Currect_Position = @"KKTest_Currect_Position";
NSString *const KKTest_Currect_Sex = @"KKTest_Currect_Sex";
NSString *const KKAccount_Change = @"KKAccount_Change";
NSString *const KKPosition_Change = @"KKPosition_Change";
NSString *const KKPeripheralSetting = @"KKPeripheralSetting";
NSString *const KKTest_NewData = @"KKTest_NewData";

/** 蓝牙设置参数 **/
NSString *const KKBLEParameter_Depth = @"KKBLEParameter_Depth";
NSString *const KKBLEParameter_BLEUnit = @"KKBLEParameter_BLEUnit";

NSString *const KKBLEStatus_disConnect = @"KKBLEStatus_disConnect";
NSString *const KKBLEPeripheralInfo = @"KKBLEPeripheralInfo";

NSString *const KKBLEParameter_cm = @"cm";
NSString *const KKBLEParameter_inch = @"inch";
NSString *const KKBLEParameter_mm = @"mm";


/*
 肌肉向导
 */
NSString *const KKMuscle_guide_belly = @"KKMuscle_guide_belly";
NSString *const KKMuscle_guide_arm =   @"KKMuscle_guide_arm";
NSString *const KKMuscle_guide_ham =   @"KKMuscle_guide_ham";
NSString *const KKMuscle_guide_calf =  @"KKMuscle_guide_calf";

@implementation HJCommon

//初始化
+ (instancetype)shareInstance{
    
    static HJCommon * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
         instance = [[HJCommon alloc] init];
    });
    return instance;
}

- (instancetype)init{
    
    self = [super init];
    if (self) {
        
        _userInfoModel = [[HJUserInfoModel alloc] init];
        
        
        _BLEInfoModel = [[HJBLEInfoModel alloc] initWithString:[[NSUserDefaults standardUserDefaults] objectForKey:KKBLEPeripheralInfo] error:nil];
        
        if(_BLEInfoModel== nil){
            _BLEInfoModel = [[HJBLEInfoModel alloc] init];
        }
        
        _BLEInfoModel.isConnect = NO;
        _BLEInfoModel.BLEPoweredOn = NO;
        
        
        _selectModel = [[HJUserInfoModel alloc] initWithString:[[NSUserDefaults standardUserDefaults] objectForKey:KKAccount_selectModelInfo] error:nil];
        
        if (_selectModel == nil) {
            _selectModel = [[HJUserInfoModel alloc] init];
        }
        
    }
    return self;
}

- (BOOL)isDebug{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:KKAccount_Debug] boolValue];
}


- (BOOL)isLogin{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:KKAccount_Login] boolValue];
}

- (void)saveUserInfo:(HJUserInfoModel*)model{

    NSUserDefaults * ud =  [NSUserDefaults standardUserDefaults];
    
    [ud setObject:model.userId forKey:KKAccount_userId];
    
    [ud synchronize];
    
    _userInfoModel = model;
    
}

//保存token
- (void)saveToken:(NSString*)token{
    
    NSUserDefaults * ud =  [NSUserDefaults standardUserDefaults];
    
    [ud setObject:token forKey:KKAccount_Token];
    [ud setBool:YES forKey:KKAccount_Login]; 
    
    [ud synchronize];
}

- (HJUserInfoModel*)userInfoModel{
    return _userInfoModel;
}

- (HJBLEInfoModel *)BLEInfoModel{
    return _BLEInfoModel;
}

- (HJUserInfoModel*)selectModel{
    return _selectModel;
}

// 退出登录 是否展示退出信息
- (void)logout:(BOOL)isShow toast:(NSString*)toast{
    
    NSUserDefaults * ud =  [NSUserDefaults standardUserDefaults];
    
    [ud setBool:NO forKey:KKAccount_Login];       
    [ud removeObjectForKey:KKAccount_Token];
    [ud removeObjectForKey:KKAccount_Phone];
    [ud removeObjectForKey:KKAccount_userId];
    [ud removeObjectForKey:KKAccount_selectModelInfo];
    [ud removeObjectForKey:KKBLEPeripheralInfo];
    
    /*
     选中的对象赋值为空
     */
    _selectModel = nil;
    
    if (toast == nil) {
        toast = @"";
    }
  
    [[NSNotificationCenter defaultCenter] postNotificationName:KKAccount_Quit object:@{@"isShow":@(isShow),@"toast":toast}];

}

//app名称
-(NSString *)getAppName {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleName"];
    return app_Name;
}

- (NSString *)getAppVersion{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return app_Name;
}

- (NSString *)getAppBundleID{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_id = [infoDictionary objectForKey:@"CFBundleIdentifier"];
    return app_id;
}


- (NSString*)getCurrectLocalCountry{
    // iOS 获取设备当前地区的代码
    NSString *localeIdentifier = [[NSLocale currentLocale] objectForKey:NSLocaleIdentifier];
    NSLog(@"%@",localeIdentifier);
    return localeIdentifier;
}

- (NSString*)getCurrectLocalLanguage{
   // iOS 获取设备当前语言的代码
    NSString *preferredLanguage = [[[NSBundle mainBundle] preferredLocalizations] firstObject];
    NSLog(@"%@",preferredLanguage);
    return preferredLanguage;
}

- (NSString*)whitespaceCharacterSet:(NSString*)string{
    
    if (string==nil) {
        return nil;
    }
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return string;
}


- (NSString*)getSelectId{
    
    return  _selectModel.id;

}

- (NSString*)getSelectName{
    
    return  _selectModel.userName;
    
}


#pragma mark ==============  蓝牙参数 ===============
//存储蓝牙深度
- (void)saveBLEDepth:(NSInteger)value{
    
    [[NSUserDefaults standardUserDefaults] setInteger:value forKey:KKBLEParameter_Depth];
    
}

//获取蓝牙深度
- (KKBLEDepth)getBLEDepth{
    
    NSInteger depth = [[[NSUserDefaults standardUserDefaults] objectForKey:KKBLEParameter_Depth] intValue];
    
    if (depth == 0) {
        if(pxHeight == KKBLEPxHeight_256){
            depth = KKBLEDepth_level_7;
        }else{
            depth = KKBLEDepth_level_3;
        }
    }
    
    return depth;
}

//获取蓝牙深度公式 mm
- (int)getBLEDepth_cm_new:(KKBLEDepth)depth bitmapHight:(NSInteger)bitmapHight withOcxo:(NSInteger)ocxo{

    if (pxHeight == KKBLEPxHeight_256) {
        if (depth == KKBLEDepth_level_5) {
            return 40;
        }
        return 55;
    }
    
    float value = 2. * depth * 77 / ocxo / 100 * bitmapHight;

    return ceilf(value);
}



- (void)saveBLEUnit:(NSString*)value{
    
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:KKBLEParameter_BLEUnit];
}

//获取测量单位
- (NSString*)getBLEUnit{
    
    NSString * unit = [[NSUserDefaults standardUserDefaults] objectForKey:KKBLEParameter_BLEUnit];
    if (unit == nil) {
        unit = KKBLEParameter_cm;
    }
    return unit;
}

/*
 value 为 cm 值, 转化为 cm inch mm
 */
- (NSString *)getCurrectUnitValue:(float)value{
    
    NSString * string;
    /*
     当前单位
     */
    NSString * unit = [self getBLEUnit];
    
    if ([unit isEqualToString:KKBLEParameter_cm]) {
        
        string = [NSString stringWithFormat:@"%.1f",value];
        
    }else if ([unit isEqualToString:KKBLEParameter_inch]){
        
        string = [NSString stringWithFormat:@"%.2f",value/2.54];
        
    }else if ([unit isEqualToString:KKBLEParameter_mm]){
        
        string = [NSString stringWithFormat:@"%.1f",value*10];
    }
    
    
    return string;
}

- (void)saveTestFunction:(NSInteger)value{
    
    
    [[NSUserDefaults standardUserDefaults] setInteger:value forKey:KKTest_Currect_Function];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (KKTest_Function)getTestFunction{
    
    KKTest_Function value =  [[[NSUserDefaults standardUserDefaults] objectForKey:KKTest_Currect_Function] intValue];
    
    if (value) {
        return value;
    }
    
    return KKTest_Function_Fat;
}


- (void)saveTestFunctionPosition:(NSInteger)value{
    
    [[NSUserDefaults standardUserDefaults] setInteger:value forKey:KKTest_Currect_Position];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (KKTest_Function_Position)getTestFunctionPosition{
    
    KKTest_Function_Position value =  [[[NSUserDefaults standardUserDefaults] objectForKey:KKTest_Currect_Position] intValue];
    
    return value;
    
}


- (void)saveTestSex:(NSInteger)value{
    
    [[NSUserDefaults standardUserDefaults] setInteger:value forKey:KKTest_Currect_Sex];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (KKTest_Sex)getTestSex{
    
    KKTest_Sex value =  [[[NSUserDefaults standardUserDefaults] objectForKey:KKTest_Currect_Sex] intValue];
    return value;
}

- (float)getWidth:(NSString*)title height:(float)height font:(int)font{
    
    //实际尺寸（需要自动调整什么，就取width或者height）
    CGSize actualSize = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kk_sizefont(font)} context:nil].size;
    
    return actualSize.width;
}

- (float)getHeight:(NSString*)title width:(float)width font:(int)font{
    //实际尺寸（需要自动调整什么，就取width或者height）
    CGSize actualSize = [title boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kk_sizefont(font)} context:nil].size;
    
    return actualSize.height;
}

//获取省市区
- (NSArray*)getCity{
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"city" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    NSArray *cityArr;
    if(data){
        NSDictionary *infoDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        cityArr = [infoDict objectForKey:@"data"];
    }
    return cityArr;
}
//判断有没有非法字符(表情符号和下划线) 有返回YES没有返回NO
- (BOOL)isContainsEmoji:(NSString *)string {
    __block BOOL isEomji = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        const unichar hs = [substring characterAtIndex:0];
        if (0xd800 <= hs && hs <= 0xdbff) {
            if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                if (0x1d000 <= uc && uc <= 0x1f77f) {
                    isEomji = YES;
                    *stop = YES;
                }else if (hs == 0xd83e){
                    isEomji = YES;
                    *stop = YES;
                }
            }
        }else if (substring.length > 1) {
            const unichar ls = [substring characterAtIndex:1];
            if (ls == 0x20e3) {
                isEomji = YES;
                *stop = YES;
            }else if (hs == 0x2614 || hs == 0x2602 || hs == 0x0023 || hs == 0x002a || hs == 0x23cf || hs == 0x25b6 || hs == 0x2b05 || hs == 0x231a || hs == 0x2604 || hs == 0x26a1 || hs == 0x2601 || hs == 0x26c5 || hs == 0x2600 || hs == 0x2744 || hs == 0x2603 || hs == 0x26f9 || hs == 0x26f3 || hs == 0x2708 || hs == 0x26f5 || hs == 0x2693 || hs == 0x260e || hs == 0x26f2 || hs == 0x2699){
                isEomji = YES;
                *stop = YES;
            }else if (0x0030 <= hs && hs <= 0x0039){
                isEomji = YES;
                *stop = YES;
            }
        }else {
            if (0x2100 <= hs && hs <= 0x27ff && hs != 0x263b && hs != 0x2103 && hs != 0x2109) {
                isEomji = YES;
                *stop = YES;
            }else if (0x2B05 <= hs && hs <= 0x2b07) {
                isEomji = YES;
                *stop = YES;
            }else if (0x2934 <= hs && hs <= 0x2935) {
                isEomji = YES;
                *stop = YES;
            }else if (0x3297 <= hs && hs <= 0x3299) {
                isEomji = YES;
                *stop = YES;
            }else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030|| hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50|| hs ==0x231a) {
               isEomji = YES;
                *stop = YES;
            }
        }
    }];
    return isEomji;
}
//今日时间 yyyy-mm-dd
-(NSString*)todayTime_yyyy_mm{
    
    NSDate *date = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM"];
    
    NSString *time_now = [formatter stringFromDate:date];
    
    NSLog(@"格式化后的时间%@", time_now);
    
    return time_now;
}

//今日时间戳
-(NSString*)todayTime_yyyy_MM_DD_mm{
    
    NSDate *date = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyyMMddHHmm"];
    
    NSString *time_now = [formatter stringFromDate:date];

    return time_now;
}

//今日时间戳
-(NSString*)todayTime_yyyy_MM_dd_HH_mm_ss{
    
    NSDate *date = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *time_now = [formatter stringFromDate:date];

    return time_now;
}

- (NSString *)getTimeNow{
    
    NSDate *date = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSString *time_now = [formatter stringFromDate:date];
    
    return time_now;
}

//获取当前时间戳（秒）
-(NSString*)getTimestamp{
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]*1000+1000*60];
    
    return timeSp;
}

- (NSString*)getLastYear{
    
    ///< 当前时间
    NSDate *currentdata = [NSDate date];
    
    ///< NSCalendar -- 日历类，它提供了大部分的日期计算接口，并且允许您在NSDate和NSDateComponents之间转换
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    
    NSDateComponents *datecomps = [[NSDateComponents alloc] init];
    [datecomps setYear:-10];
    [datecomps setMonth:0];
    [datecomps setDay:0];
    
    ///< dateByAddingComponents: 在参数date基础上，增加一个NSDateComponents类型的时间增量
    NSDate *calculatedate = [calendar dateByAddingComponents:datecomps toDate:currentdata options:0];
    
    ///< 打印推算时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *calculateStr = [formatter stringFromDate:calculatedate];

    return calculateStr;
}

- (NSString*)getOldDay:(int)day{
    
    ///< 当前时间
    NSDate *currentdata = [NSDate date];
    
    ///< NSCalendar -- 日历类，它提供了大部分的日期计算接口，并且允许您在NSDate和NSDateComponents之间转换
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    
    NSDateComponents *datecomps = [[NSDateComponents alloc] init];
    [datecomps setYear:0];
    [datecomps setMonth:0];
    [datecomps setDay:day];
    
    ///< dateByAddingComponents: 在参数date基础上，增加一个NSDateComponents类型的时间增量
    NSDate *calculatedate = [calendar dateByAddingComponents:datecomps toDate:currentdata options:0];
    
    ///< 打印推算时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *calculateStr = [formatter stringFromDate:calculatedate];

    return calculateStr;
}

- (NSString*)getOldDay_MM_dd:(int)day{
    
    ///< 当前时间
    NSDate *currentdata = [NSDate date];
    
    ///< NSCalendar -- 日历类，它提供了大部分的日期计算接口，并且允许您在NSDate和NSDateComponents之间转换
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    
    NSDateComponents *datecomps = [[NSDateComponents alloc] init];
    [datecomps setYear:0];
    [datecomps setMonth:0];
    [datecomps setDay:day];
    
    ///< dateByAddingComponents: 在参数date基础上，增加一个NSDateComponents类型的时间增量
    NSDate *calculatedate = [calendar dateByAddingComponents:datecomps toDate:currentdata options:0];
    
    ///< 打印推算时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd"];
    NSString *calculateStr = [formatter stringFromDate:calculatedate];

    return calculateStr;
}

//nsstring 转 nsdate
- (NSDate*)stringToDate:(NSString*)string format:(NSString*)format{
    
    NSString *birthdayStr=string;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSDate * date = [dateFormatter dateFromString:birthdayStr];
    return date;
    
}

//nsdate 转时间戳
- (double)dateToFloat:(NSDate*)date{
    
    NSTimeInterval time=[date timeIntervalSince1970];
    return time;
}

//时间戳 转 字符串
- (NSString*)doubleToString:(double)time format:(NSString*)format{
    
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:time];

    NSDateFormatter * dateformat = [[NSDateFormatter alloc] init];

    dateformat.dateFormat =format;
    
    NSString * string = [dateformat stringFromDate:date];
    
    return string;
}

#pragma mark 字典转化字符串
- (NSString*)dictionaryToJson:(NSDictionary *)dic{
    if (dic==nil) {
        return @"";
    }
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

//json格式字符串转字典：
- (NSDictionary*)dictionaryWithJsonString:(NSString*)jsonString{

    if (jsonString == nil) {
        
        return nil;
        
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options:NSJSONReadingMutableContainers
                         
                                                          error:&err];
    
    if(err) {
        
        NSLog(@"json解析失败：%@",err);
        
        return nil;
        
    }
    
    return dic;
    

}



- (NSString *)md5To32bit:(NSString *)input{
    
    const char* str = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(str, (CC_LONG)strlen(str), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH;i++){
        [ret appendFormat:@"%02x",result[i]];
        
    }
    return ret;
    
}


/** 利用画布对图片尺寸进行修改
 @param data ---- 图片Data
 @param maxPixelSize ---- 图片最大宽/高尺寸 ，设置后图片会根据最大宽/高 来等比例缩放图片

 @return 目标尺寸的图片Image */
- (UIImage*)getThumImgOfConextWithData:(NSData*)data withMaxPixelSize:(int)maxPixelSize{
    UIImage *imgResult = nil;
    if(data == nil)         { return imgResult; }
    if(data.length <= 0)    { return imgResult; }
    if(maxPixelSize <= 0)   { return imgResult; }
    
    const int sizeTo = maxPixelSize/[UIScreen mainScreen].scale; // 图片最大的宽/高
    CGSize sizeResult;
    UIImage *img = [UIImage imageWithData:data];
    if(img.size.width > img.size.height){ // 根据最大的宽/高 值，等比例计算出最终目标尺寸
        float value = img.size.width/ sizeTo;
        int height = img.size.height / value;
        sizeResult = CGSizeMake(sizeTo, height);
    } else {
        float value = img.size.height/ sizeTo;
        int width = img.size.width / value;
        sizeResult = CGSizeMake(width, sizeTo);
    }
    
    UIGraphicsBeginImageContextWithOptions(sizeResult, NO, 0);
    [img drawInRect:CGRectMake(0, 0, sizeResult.width, sizeResult.height)];
    img = nil;
    imgResult = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return imgResult;
}


/// 图片自定长宽
- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize{
    
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return reSizeImage;
}

/// 等比率缩放
- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize{
    
   // UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize), NO , [UIScreen mainScreen].scale);
    
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
    
}
//保存图片

-(void)saveImageDocuments:(UIImage *)image fileName:(NSString*)fileName size:(CGSize)size{
    
    //拿到图片
    UIImage* imagesave = [self scaleToSize:image size:size];//调用图片大小截取方法

    NSString * documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) firstObject];
    NSString *imagePath = [documentPath stringByAppendingPathComponent:@"Fat"];   // 保存文件的名称
    
    /*
     创建Fat文件夹
     */
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL isDir = NO;
    
    // fileExistsAtPath 判断一个文件或目录是否有效，isDirectory判断是否一个目录
    BOOL existed = [fileManager fileExistsAtPath:imagePath isDirectory:&isDir];
    
    if (!(isDir && existed)) {
        // 在Document目录下创建一个archiver目录
        [fileManager createDirectoryAtPath:imagePath withIntermediateDirectories:YES attributes:nil error:nil];
    }

    // 在Fat下写入文件
     NSString *path = [imagePath stringByAppendingPathComponent:fileName];

    //把图片直接保存到指定的路径（同时应该把图片的路径imagePath存起来，下次就可以直接用来取）
    
    BOOL result = [UIImagePNGRepresentation(imagesave) writeToFile:path atomically:YES];
    
    if (result) {
        NSLog(@"ok");
    }else{
        NSLog(@"file");
    }
    
}

// 读取并存贮到相册

-(UIImage *)getDocumentImage:(NSString*)fileName{
    
    NSString * documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) firstObject];
    NSString *imagePath = [documentPath stringByAppendingPathComponent:@"Fat"];   // 保存文件的名称
    
    // 读取沙盒路径图片
    
    NSString *aPath3=[NSString stringWithFormat:@"%@/%@.png",imagePath,fileName];
    
    // 拿到沙盒路径图片
    UIImage *imgFromUrl3=[[UIImage alloc]initWithContentsOfFile:aPath3];
    
    // 图片保存相册
    //UIImageWriteToSavedPhotosAlbum(imgFromUrl3, self, nil, nil);
    
    return imgFromUrl3;

}

/**
*对图片尺寸截取
*/
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0,0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    //返回新的改变大小后的图片
    return scaledImage;
}

- (BOOL)isvalidateEmail:(NSString *)email{
    
    /*
     去掉键盘引起的特殊字符
     */
    email = [email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    email = [email stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    email = [email stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    

    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

#pragma mark ============== 方法 ===============
- (HJPositionModel*)currectPositionToString{
    
    KKTest_Function_Position value = [self getTestFunctionPosition];
    
    HJPositionModel * model = [[HJPositionModel alloc] init];
    
    NSString * fatNorImageStr;
    NSString * fatImageStr;
    NSString * fatPositionStr;
    
    NSString * circleImageSel;
    NSString * circleImageNor;
    NSString * circleImageNor_s;
    
    BOOL isSelected;
    
    switch (value) {
            
        case KKTest_Function_Position_Waist:
            
            fatNorImageStr =  @"img_main_waist_nor";
            fatImageStr = @"img_main_waist_sel";
            fatPositionStr = KKLanguage(@"lab_main_test_waist");
            isSelected = YES;
            
            circleImageSel = @"img_btn_waist_sel";
            circleImageNor = @"img_btn_waist_nor";
            circleImageNor_s = @"img_btn_waist_nor_s";
            
            break;
            
        case KKTest_Function_Position_Belly:
            
            fatNorImageStr =  @"img_main_belly_nor";
            fatImageStr = @"img_main_belly_sel";
            fatPositionStr = KKLanguage(@"lab_main_test_belly");
            isSelected = YES;
            
            circleImageSel = @"img_btn_belly_sel";
            circleImageNor = @"img_btn_belly_nor";
            circleImageNor_s = @"img_btn_belly_nor_s";
            
            break;
            
        case KKTest_Function_Position_Arm:
            
            fatNorImageStr =  @"img_main_arm_nor";
            fatImageStr = @"img_main_arm_sel";
            fatPositionStr = KKLanguage(@"lab_main_test_arm");
            isSelected = YES;
            
            circleImageSel = @"img_btn_arm_sel";
            circleImageNor = @"img_btn_arm_nor";
            circleImageNor_s = @"img_btn_arm_nor_s";
            
            break;
            
        case KKTest_Function_Position_Arm_front:
            
            fatNorImageStr =  @"img_main_arm_nor";
            fatImageStr = @"img_main_arm_muscle_sel";
            fatPositionStr = KKLanguage(@"lab_main_test_arm_front");
            isSelected = YES;
            
            circleImageSel = @"img_btn_arm_sel";
            circleImageNor = @"img_btn_arm_nor";
            circleImageNor_s = @"img_btn_arm_nor_s";
            
            break;
            
        case KKTest_Function_Position_Ham:
            
            fatNorImageStr =  @"img_main_ham_nor";
            fatImageStr = @"img_main_ham_sel";
            fatPositionStr = KKLanguage(@"lab_main_test_ham");
            isSelected = YES;
            
            circleImageSel = @"img_btn_ham_sel";
            circleImageNor = @"img_btn_ham_nor";
            circleImageNor_s = @"img_btn_ham_nor_s";
            
            break;
            
        case KKTest_Function_Position_Calf:
            
            fatNorImageStr =  @"img_main_calf_nor";
            fatImageStr = @"img_main_calf_sel";
            fatPositionStr = KKLanguage(@"lab_main_test_calf");
            isSelected = YES;
            
            circleImageSel = @"img_btn_calf_sel";
            circleImageNor = @"img_btn_calf_nor";
            circleImageNor_s = @"img_btn_calf_nor_s";
            
            break;
            
        default:
            
            isSelected = NO;
            
            break;
    }
    
    model.name = fatPositionStr;
    model.selImageName = fatImageStr;
    model.norImageName = fatNorImageStr;
    model.positionValue = value;
    model.isSelected = isSelected;
    model.gifImage = fatImageStr;
    model.circleImageSel = circleImageSel;
    model.circleImageNor = circleImageNor;
    model.circleImageNor_s = circleImageNor_s;
    
    return model;
}

- (HJPositionModel*)selPositionToString:(NSString*)position{
    
    HJPositionModel * model = [[HJPositionModel alloc] init];
    NSInteger positionValue;
    
    if ([position isEqualToString:KKLanguage(@"lab_main_test_waist")]) {
        
        positionValue = KKTest_Function_Position_Waist;
    }else if([position isEqualToString:KKLanguage(@"lab_main_test_belly")]){
        
        positionValue = KKTest_Function_Position_Belly;
    }else if([position isEqualToString:KKLanguage(@"lab_main_test_arm")]){
        
        positionValue = KKTest_Function_Position_Arm;
    }else if([position isEqualToString:KKLanguage(@"lab_main_test_ham")]){
        
        positionValue = KKTest_Function_Position_Ham;
        
    }else if([position isEqualToString:KKLanguage(@"lab_main_test_calf")]){
        
        positionValue = KKTest_Function_Position_Calf;
        
    }else {
        
        positionValue = KKTest_Function_Position_Waist;
    }
    
    model.positionValue = positionValue;
    
    return model;
}

- (HJTestFunctionModel*)currectFunctionToString{
    
    KKTest_Function value = [self getTestFunction];
    
    HJTestFunctionModel * model = [[HJTestFunctionModel alloc] init];
    
    NSString * fatNorImageStr;
    NSString * fatImageStr;
    NSString * fatPositionStr;
    BOOL isSelected;
    
    switch (value) {
            
        case KKTest_Function_Fat:
            
            fatNorImageStr =  @"img_btn_fat_nor";
            fatImageStr = @"img_btn_fat_sel";
            fatPositionStr = KKLanguage(@"lab_main_fat");
            isSelected = YES;
            break;
            
        case KKTest_Function_Muscle:
            
            fatNorImageStr =  @"img_btn_muscle_nor";
            fatImageStr = @"img_btn_muscle_sel";
            fatPositionStr = KKLanguage(@"lab_main_muscle");
            isSelected = YES;
            
            break;
            
        default:
            break;
    }
    
    model.name = fatPositionStr;
    model.selImageName = fatImageStr;
    model.norImageName = fatNorImageStr;
    model.functionValue = value;
    model.isSelected = isSelected;
    
    return model;
    
}

- (NSString*)currectPositionToString:(NSInteger)value{
    NSString * fatPositionStr;
    switch (value) {
            
        case KKTest_Function_Position_Waist:
        
            fatPositionStr = KKLanguage(@"lab_main_test_waist");
            
            break;
            
        case KKTest_Function_Position_Belly:

            fatPositionStr = KKLanguage(@"lab_main_test_belly");

            break;
            
        case KKTest_Function_Position_Arm:

            fatPositionStr = KKLanguage(@"lab_main_test_arm");
            
            break;
            
        case KKTest_Function_Position_Arm_front:
            
            fatPositionStr = KKLanguage(@"lab_main_test_arm_front");
            
            break;
            
        case KKTest_Function_Position_Ham:
            
            fatPositionStr = KKLanguage(@"lab_main_test_ham");
            
            break;
            
        case KKTest_Function_Position_Calf:

            fatPositionStr = KKLanguage(@"lab_main_test_calf");
            
            break;
            
        default:

            break;
    }
    
    return fatPositionStr;
}


- (NSString*)currectFunctionToString:(NSInteger)value{
    
    NSString * fatPositionStr;
    
    switch (value) {
            
        case KKTest_Function_Fat:

            fatPositionStr = KKLanguage(@"lab_main_fat");
            break;
            
        case KKTest_Function_Muscle:
            
            fatPositionStr = KKLanguage(@"lab_main_muscle");
            
            break;
            
        default:
            break;
    }
    return fatPositionStr;
}

#pragma mark 获取文件sha1标签
-(NSString *)sha1OfPath:(NSString *)path{

    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:path]];
    unsigned char digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1( data.bytes, (CC_LONG)data.length, digest );
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for( int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++ )
    {
        [output appendFormat:@"%02X", digest[i]];
    }
    
    return output;
    
}

- (NSString *)firstCharactor:(NSString *)aString{
    
    NSMutableString *str = [NSMutableString stringWithString:aString];
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    
    NSString *pinYin = [str capitalizedString];
    
    NSString *firatCharactors = [NSMutableString string];
    for (int i = 0; i < pinYin.length; i++) {
        if ([pinYin characterAtIndex:i] >= 'A' && [pinYin characterAtIndex:i] <= 'Z') {
            firatCharactors = [firatCharactors stringByAppendingString:[NSString stringWithFormat:@"%C",[pinYin characterAtIndex:i]]];
        }
    }
    return firatCharactors;
}

@end
