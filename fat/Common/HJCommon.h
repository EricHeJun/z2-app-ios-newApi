//
//  HJCommon.h
//  JiaYueShouYin
//
//  Created by 何军 on 2020/7/2.
//  Copyright © 2020 Eric. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HJBaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJCommon : NSObject

/** URL、地址 **/
extern NSString *const HOST_URl;
extern NSString *const STS_URl;

extern NSString *const HOST_URl_TEST;
extern NSString *const STS_URl_TEST;

/// 请求共钥 / 密钥
extern NSString *const accessKeyId;       //ios
extern NSString *const accessSecret;      //dn37uKRDp8YlOxX86pN9lKYXA2HJcibB
extern NSString *const SECRET_KEY;


//请求 url
/*
 新API
 */
extern NSString *const KK_URL_api_user_login;  //登陆
extern NSString *const KK_URL_api_user_logout;  //退出
extern NSString *const KK_URL_api_user_info;    //获取用户信息
extern NSString *const KK_URL_api_user_modify;  //用户信息修改
extern NSString *const KK_URL_api_user_sms_code; //手机验证码
extern NSString *const KK_URL_api_user_register; //注册
extern NSString *const KK_URL_api_user_modify_pwd;     //手机找回密码
extern NSString *const KK_URL_api_user_email_find_pwd; //邮箱找回密码
extern NSString *const KK_URL_api_user_reset_pwd; 

extern NSString *const KK_URL_api_user_modify_phone;  //修改手机号
extern NSString *const KK_URL_api_user_set_email;     //绑定邮箱
extern NSString *const KK_URL_api_user_unband_email;  //邮箱解绑

extern NSString *const KK_URL_api_fat_member_list;     //查询成员列表
extern NSString *const KK_URL_api_fat_member_del;       //删除成员
extern NSString *const KK_URL_api_fat_member_submit;    //添加成员
extern NSString *const KK_URL_api_fat_member_modify;    //修改信息
/*
 旧
 */

extern NSString *const KK_URL_add_suggest;                //意见反馈

extern NSString *const KK_URL_sts;                        //获取sts授权
extern NSString *const KK_URL_query_fat_record;           //查询历史记录

extern NSString *const KK_URL_unbound_user;               //解绑

extern NSString *const KK_URL_add_fat_record;             //上报测试记录
extern NSString *const KK_URL_del_fat_record;             //删除测试记录
extern NSString *const KK_URL_query_fat_record_by_recently; //查询最近一条数据
extern NSString *const KK_URL_query_fat_record_by_date;
extern NSString *const KK_URL_get_firmwareinfo;
extern NSString *const KK_URL_query_adview;               //查询广告参数  
extern NSString *const KK_URL_query_fat_record_by_month_avg; //查询某一时间段的每月平均测量值

/** 全局 字符定义 **/
extern NSString *const KKAccount_Debug;
extern NSString *const KKAccount_All;    //所有账户
extern NSString *const KKAccount_Quit;   //退出登陆
extern NSString *const KKAccount_Login;  //登陆信息
extern NSString *const KKAccount_Token;  //用户 token
extern NSString *const KKAccount_userId; //用户 id
extern NSString *const KKAccount_TestId; //访客 id

extern NSString *const KKAccount_selectModelInfo; //选中的用户信息

extern NSString *const KKAccount_Photo;      //用户头像
extern NSString *const KKAccount_Edit_Photo;      //修改用户头像通知


/** 测量功能参数 **/
extern NSString *const KKTest_Currect_Function;         //当前测量功能
extern NSString *const KKTest_Currect_Position;         //当前测量位置
extern NSString *const KKTest_Currect_Sex;              //访客性别
extern NSString *const KKAccount_Change;                //切换测量对象/测量部位
extern NSString *const KKPosition_Change;               //切换部位
extern NSString *const KKPeripheralSetting;
extern NSString *const KKTest_NewData;                  //新的测量数据

/** 蓝牙设置参数 **/
extern NSString *const KKBLEParameter_Depth;    //测量深度
extern NSString *const KKBLEParameter_BLEUnit;  //测量单位
extern NSString *const KKBLEStatus_disConnect;

extern NSString *const KKBLEPeripheralInfo;

//蓝牙测量单位
extern NSString *const KKBLEParameter_cm;
extern NSString *const KKBLEParameter_inch;
extern NSString *const KKBLEParameter_mm;

/*
 肌肉向导
 */
extern NSString *const KKMuscle_guide_belly;
extern NSString *const KKMuscle_guide_arm;
extern NSString *const KKMuscle_guide_ham;
extern NSString *const KKMuscle_guide_calf;


/*
 蓝牙每线数据高度 (暂时定两个档位)
 */
typedef NS_ENUM(NSInteger,KKBLEPxHeight){
    
    KKBLEPxHeight_256 = 256,
    KKBLEPxHeight_477 = 477,
    
};

/*
 蓝牙深度档位
 */
typedef NS_ENUM(NSInteger,KKBLEDepth){
    /*
     477 版本参数
     */
    KKBLEDepth_level_2 = 2,
    KKBLEDepth_level_3 = 3,
    
    /*
     256 版本参数
     */
    KKBLEDepth_level_5 = 5,
    KKBLEDepth_level_7 = 7,
    
};

/*
 蓝牙增益设置
 */
typedef NS_ENUM(NSInteger,KKBLEDLPF_PARA){
    
    KKBLEDLPF_PARA_level_18 = 18,
    KKBLEDLPF_PARA_level_23 = 23,
    
    KKBLEDLPF_PARA_level_30 = 30,
    KKBLEDLPF_PARA_level_35 = 35,
};


//测量功能参数
typedef NS_ENUM(NSInteger,KKTest_Function){
    
    KKTest_Function_Muscle = 1,
    KKTest_Function_Fat = 2,
};

//测量位置参数
/*
0 = 腰部
1 = 脸颊
2 = 手臂
3 = 大腿
4 = 胸部
5 = 小腿
6 = 腹部
7 = 手臂前
 */
typedef NS_ENUM(NSInteger,KKTest_Function_Position){
    
    KKTest_Function_Position_Waist = 0,
    KKTest_Function_Position_Face = 1,
    KKTest_Function_Position_Arm = 2,
    KKTest_Function_Position_Ham = 3,
    KKTest_Function_Position_Chest = 4,
    KKTest_Function_Position_Calf = 5,
    KKTest_Function_Position_Belly = 6,
    KKTest_Function_Position_Arm_front = 7,      //先去除
    

};

//测量性别

typedef NS_ENUM(NSInteger,KKTest_Sex){
    
    KKTest_Sex_Woman = 0,
    KKTest_Sex_Man = 1,
    
};


//请求结果
typedef NS_ENUM(NSInteger,KKStatus){
    
    KKStatus_success = 0,           //成功
    KKStatus_fail = 500,            //失败
    KKStatus_Token_invalid = 401,   //token 无效
    
};

//web 网页类型
typedef NS_ENUM(NSInteger,KKWebType){
    
    KKWebType_Agreement = 100,
    KKWebType_official,
    KKWebType_Faq,
    KKWebType_Help,
    KKWebType_advertising,
};



//按钮功能类型
typedef NS_ENUM(NSInteger,KKButtonType){
    //登陆模块
    
    KKButton_Account_Login = 1000,
    KKButton_Account_Login_email ,
    
    KKButton_Account_Register,
    KKButton_Account_Register_email,
    KKButton_Account_Forget,
    KKButton_Account_Switch_vcode_psw,
    KKButton_Account_GetVcode,
    KKButton_Account_Switch_account,
    KKButton_Account_Switch_password,
    
    KKButton_Register_GetVcode,
    KKButton_Register_selectAgreement,
    KKButton_Register_agreement,
    KKButton_Register_goLogin,
    
    
    KKButton_Account_Area,
    
    KKButton_Login_PhoneTitle,
    KKButton_Login_emailTitle,
    
    KKButton_Account_cancel,
    KKButton_Account_showPsw,
    KKButton_Account_logout,
    
    //忘记密码
    KKButton_Forget_GetVcode,
    KKButton_Forget_Find,
    KKButton_Forget_FindType,
    
    KKButton_Forget_showPsw_1,
    KKButton_Forget_showPsw_2,
    
   //主页
    KKButton_SearchBLE,
    KKButton_Device_Info,
    KKButton_Main_TestAccount,
    KKButton_Main_TestPoint,
    
    
    KKButton_Main_TestPoint_fat,
    KKButton_Main_TestPoint_muscle,
    
    
    KKButton_Main_AddAcount,
    
    KKButton_upload,
    
    
    //我的
    KKButton_Me_userInfo,
    KKButton_Me_userInfo_camera,
    KKButton_Me_userInfo_savePhoto,
    
    
    KKButton_Me_userInfo_save,
    
    KKButton_chat_query_history,
    
    KKButton_week,
    KKButton_month,
    KKButton_year,
    
    KKButton_upgrade,
    
    //公共
    KKButton_Cancel,
    KKButton_Confirm,
    KKButton_Share,
    KKButton_Help,
    
    
    KKButton_back,
    KKButton_last,
};


//按钮功能类型
typedef NS_ENUM(NSInteger,KKViewType){
    
    KKViewType_login_phone,
    KKViewType_login_email,
    
    KKViewType_register_phone,
    KKViewType_register_email,
    
    KKViewType_forgot_phone,
    KKViewType_forgot_email,
    
    KKViewType_replace_phone,
    
    KKViewType_testPoint_select,
    KKViewType_DeviceList,
    KKViewType_AccountList,
    
    
    KKViewType_Userinfo_sex_height_weight,
    KKViewType_Userinfo_birthday,

};


#pragma mark ============== 用户基础信息 ===============
/*
 当前管理者
 */
@property (strong,nonatomic)HJUserInfoModel * userInfoModel;

/*
 //选中的 用户对象
 */
@property (strong,nonatomic)HJUserInfoModel * selectModel;   

/*
 蓝牙信息
 */
@property (strong,nonatomic)HJBLEInfoModel * BLEInfoModel;

/*
 测试功能
 */
@property (assign,nonatomic)BOOL isTest;

/*
 蓝牙正在升级中
 */
@property (assign,nonatomic)BOOL isUpgrade;

/*
 初始化
 */
+ (instancetype)shareInstance;


- (NSString *)getAppName;

- (NSString *)getAppVersion;

- (NSString *)getAppBundleID;


#pragma mark ============== 方法 ===============
- (float)getWidth:(NSString*)title height:(float)height font:(int)font;
- (float)getHeight:(NSString*)title width:(float)width font:(int)font;

- (UIImage*)getThumImgOfConextWithData:(NSData*)data withMaxPixelSize:(int)maxPixelSize;

- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize;

/// 等比率缩放
- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize;

//获取省市区
- (NSArray*)getCity;

- (BOOL)isContainsEmoji:(NSString*)text;

- (NSString*)getCurrectLocalCountry;

- (NSString*)getCurrectLocalLanguage;

- (NSString*)whitespaceCharacterSet:(NSString*)string;

#pragma mark ============== 登陆状态 ===============
//是否是debug
- (BOOL)isDebug;

//登陆状态
- (BOOL)isLogin;

//保存用户信息
- (void)saveUserInfo:(HJUserInfoModel*)model;

//保存token
- (void)saveToken:(NSString*)token;
                 
//退出登录
- (void)logout:(BOOL)isShow toast:(NSString*)toast;

#pragma mark ============== 时间方法 ===============
//今日时间 yyyy-mm
-(NSString*)todayTime_yyyy_mm;

//当前时间戳
-(NSString*)todayTime_yyyy_MM_DD_mm;

//今日时间戳 时分秒
-(NSString*)todayTime_yyyy_MM_dd_HH_mm_ss;

//获取当前时间
-(NSString*)getTimeNow;

//获取当前时间戳（秒）
-(NSString*)getTimestamp;

//获取去年当前时间
- (NSString*)getLastYear;

//获取具体的时间
- (NSString*)getOldDay:(int)day;

- (NSString*)getOldDay_MM_dd:(int)day;

//nsstring 转 nsdate
- (NSDate*)stringToDate:(NSString*)string format:(NSString*)format;

//nsdate 转时间戳
- (double)dateToFloat:(NSDate*)date;

//时间戳 转 字符串
- (NSString*)doubleToString:(double)time format:(NSString*)format;


#pragma mark 字典转化字符串
- (NSString*)dictionaryToJson:(NSDictionary *)dic;

- (NSDictionary*)dictionaryWithJsonString:(NSString*)jsonString;

/// md5加密
/// @param input 参数
- (NSString *)md5To32bit:(NSString *)input;


#pragma mark ==============  蓝牙参数 ===============
//存储蓝牙深度
- (void)saveBLEDepth:(NSInteger)value;

//获取蓝牙深度
- (KKBLEDepth)getBLEDepth;


//获取蓝牙深度 (低挡位 4cm  高挡位 7cm)
//- (int)getBLEDepth_cm:(KKBLEDepth)value;


//获取蓝牙深度公式 mm
- (int)getBLEDepth_cm_new:(KKBLEDepth)depth bitmapHight:(NSInteger)bitmapHight withOcxo:(NSInteger)ocxo;


//存储测量单位
- (void)saveBLEUnit:(NSString*)value;

//获取测量单位
- (NSString*)getBLEUnit;

/*
 value 为 cm 值, 转化为 cm inch mm
 */
- (NSString *)getCurrectUnitValue:(float)value;

#pragma mark ============== 首页模块 ===============
- (void)saveTestFunction:(NSInteger)value;

- (KKTest_Function)getTestFunction;

- (void)saveTestFunctionPosition:(NSInteger)value;

- (KKTest_Function_Position)getTestFunctionPosition;

/*
 访客性别存储
 */
- (void)saveTestSex:(NSInteger)value;

- (KKTest_Sex)getTestSex;

- (BOOL)isvalidateEmail:(NSString *)email;

#pragma mark ============== 图片处理 ===============
-(void)saveImageDocuments:(UIImage *)image fileName:(NSString*)fileName size:(CGSize)size;

-(UIImage *)getDocumentImage:(NSString*)fileName;

/**
*对图片尺寸截取
*/
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;


#pragma mark ============== 方法 ===============
- (HJPositionModel*)currectPositionToString;

- (HJPositionModel*)selPositionToString:(NSString*)position;

- (NSString*)currectPositionToString:(NSInteger)value;

- (HJTestFunctionModel*)currectFunctionToString;

- (NSString*)currectFunctionToString:(NSInteger)value;



#pragma mark ============== 获取文件sha1标签 ===============
-(NSString *)sha1OfPath:(NSString *)path;

/*
 获取 中文 的首字母
 */
- (NSString *)firstCharactor:(NSString *)aString;

@end

NS_ASSUME_NONNULL_END
