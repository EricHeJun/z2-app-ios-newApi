//
//  HJBaseObject.h
//  JiaYueShouYin
//
//  Created by 何军 on 2020/8/8.
//  Copyright © 2020 Eric. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <JSONModel/JSONModel.h>

@interface HJBaseObject : JSONModel

@end

@interface HJHTTPModel : HJBaseObject
/*
 新
 */
@property (assign,nonatomic)int  code;
@property (copy,nonatomic)NSString * msg;
@property (copy,nonatomic)NSString * token;

/*
 旧
 */
@property (assign,nonatomic)int  errorcode;
@property (strong,nonatomic)NSDictionary * data;



@end

/*
 登录模型
 */
@interface HJLoginModel : HJBaseObject

@property (copy,nonatomic)NSString * loginName;
@property (copy,nonatomic)NSString * passWord;
@property (copy,nonatomic)NSString * userType; //选填

@end

/*
 发送验证码模型
 */
@interface HJVcodeModel : HJBaseObject
@property (copy,nonatomic)NSString *phoneNumber;

@end

/*
 手机注册模型
 */
@interface HJRegisterModel : HJBaseObject

@property (copy,nonatomic)NSString * loginName;
@property (copy,nonatomic)NSString * passWord;
@property (copy,nonatomic)NSString * code;

@end


/*
 手机号找回密码模型
 */
@interface HJForgetPhoneModel : HJBaseObject

@property (copy,nonatomic)NSString * phoneNumber;
@property (copy,nonatomic,getter = thenewPwd)NSString * newPwd;
@property (copy,nonatomic)NSString * code;

@end

/*
 邮箱找回密码模型
 */
@interface HJForgetEmailModel : HJBaseObject

@property (copy,nonatomic)NSString * email;

@end

/*
 修改密码模型
 */
@interface HJEditPswModel : HJBaseObject

@property (copy,nonatomic)NSString * oldPwd;
@property (copy,nonatomic,getter = thenewPwd)NSString * newPwd;


@end

/*
 绑定/解绑邮箱模型
 */
@interface HJBindEmailModel : HJBaseObject

@property (copy,nonatomic)NSString * email;


@end

/*
 更换手机号模型
 */
@interface HJReplacePhoneModel : HJBaseObject

@property (copy,nonatomic)NSString * phoneNumber;
@property (copy,nonatomic)NSString * code;
@end

/*
 意见反馈模型
 */
@interface HJFeedBackModel : HJBaseObject

@property (copy,nonatomic)NSString * userId;
@property (copy,nonatomic)NSString * content;
@property (copy,nonatomic)NSString * imgUrl;
@property (copy,nonatomic)NSString * contactWay;
@property (copy,nonatomic)NSString * appInfo;
@property (copy,nonatomic)NSString * systemType;

@end



/// 当前用户信息
@interface HJUserInfoModel : HJBaseObject

/*
 新增
 */
@property (copy,nonatomic)NSString<Optional> * phoneNumber;
@property (copy,nonatomic)NSString<Optional> * avatar;     //头像图片
@property (copy,nonatomic)NSString<Optional> * sexLable;   //性别 (男女 文字)


@property (copy,nonatomic)NSString<Optional> * userName;
@property (copy,nonatomic)NSString<Optional> * birthday;
@property (copy,nonatomic)NSString<Optional> * createTime;
@property (copy,nonatomic)NSString<Optional> * formatCreateTime;
@property (copy,nonatomic)NSString<Optional> * height;

@property (copy,nonatomic)NSString<Optional> * sex;

@property (copy,nonatomic)NSString<Optional> * userId;
@property (copy,nonatomic)NSString<Optional> * weight;
@property (copy,nonatomic)NSString<Optional> *  id;   //当前选中成员id

@property (copy,nonatomic)NSString<Optional> *email;
@property (copy,nonatomic)NSString<Optional> *isEmail;

@property (copy,nonatomic)NSString<Optional> *firstCharactor; //名称首字母,用于排序

@end

/*
 历史记录请求模型
 */
@interface HJFatRecordHttpModel : HJBaseObject

@property (copy,nonatomic)NSString<Optional> * userId;
@property (copy,nonatomic)NSString<Optional> * familyId;
@property (copy,nonatomic)NSString<Optional> * recordDate;
@property (copy,nonatomic)NSString<Optional> * bodyPosition;
@property (copy,nonatomic)NSString<Optional> * recordType;
@property (copy,nonatomic)NSString<Optional> * curPage;
@property (copy,nonatomic)NSString<Optional> * pageSize;
@end

/*
 图片信息模型
 */
@interface HJChatInfoModel : HJBaseObject

@property (copy,nonatomic)NSString<Optional> * userId;
@property (copy,nonatomic)NSString<Optional> * familyId;
@property (copy,nonatomic)NSString<Optional> * recordDate;
@property (copy,nonatomic)NSString<Optional> * bodyPosition;
@property (copy,nonatomic)NSString<Optional> * recordType;    // 1 肌肉  2 脂肪
 
@property (copy,nonatomic)NSString<Optional> * depth;         //深度
@property (copy,nonatomic)NSString<Optional> * ocxo;          //正元

@property (copy,nonatomic)NSString<Optional> * recordValue;   //厚度       mm 为单位
@property (copy,nonatomic)NSString<Optional> * bitmapHight;   //测量高度
@property (copy,nonatomic)NSString<Optional> * arrayAvg;      //记录点数据
@property (copy,nonatomic)NSString<Optional> * recordImage;   //本地图片地址
@property (copy,nonatomic)NSString<Optional> * httpRecordImage; //网络图片地址
@property (copy,nonatomic)NSString<Optional> * sn;          //设备号

@property (copy,nonatomic)NSString<Optional> * transType;   //传输类型。BLE/OTG
@property (copy,nonatomic)NSString<Optional> * upload;      //是否上传 1 上传完成。0 未上传
@property (copy,nonatomic)NSString<Optional> * id;   //图片id
@property (copy,nonatomic)NSString<Optional> * pageSize;

@end

/*
 历史记录删除模型
 */
@interface HJDeleteChatInfoModel : HJBaseObject

@property (copy,nonatomic)NSString<Optional> * id;   //图片id

@end

/*
 app的信息
 */
@interface HJAPPInfoModel : HJBaseObject

@property (assign,nonatomic)NSInteger depth;           //蓝牙深度
@property (copy,nonatomic)NSString * depthUnit;        //单位   cm inch mm

@property (strong,nonatomic)HJUserInfoModel * userInfoModel;  //记录最后一次测量者的信息

@property (assign,nonatomic)NSInteger testFunction;         //记录最后的测量功能。 脂肪/肌肉

@property (assign,nonatomic)NSInteger testFunction_fat;     //记录测量脂肪的位置
@property (assign,nonatomic)NSInteger testFunction_muscle;   //记录测量肌肉的位置

@end

/*
 测量部位模型
 */
@interface HJPositionModel : HJBaseObject

@property (copy,nonatomic)NSString * name;
@property (copy,nonatomic)NSString * selImageName;
@property (copy,nonatomic)NSString * norImageName;
@property (assign,nonatomic)NSInteger positionValue;
@property (assign,nonatomic)BOOL isSelected;
@property (copy,nonatomic)NSString * gifImage;
@property (copy,nonatomic)NSString * circleImageSel;
@property (copy,nonatomic)NSString * circleImageNor;
@property (copy,nonatomic)NSString * circleImageNor_s;

@end


/*
 测量功能模型
 */
@interface HJTestFunctionModel : HJBaseObject

@property (copy,nonatomic)NSString * name;
@property (copy,nonatomic)NSString * selImageName;
@property (copy,nonatomic)NSString * norImageName;
@property (assign,nonatomic)NSInteger functionValue;  //是脂肪 还是 肌肉
@property (assign,nonatomic)BOOL isSelected;
@end


/*
 固件信息请求模型
 */
@interface HJFirmwareHttpModel : HJBaseObject

@property (copy,nonatomic)NSString * firmwareName;
@property (copy,nonatomic)NSString * firmwareMode;

@end


/*
 固件信息请求模型
 */
@interface HJFirmwareInfoModel : HJBaseObject

@property (copy,nonatomic)NSString * firmwareName;  // 包含 ble 的就是蓝牙升级,否则是超声升级
@property (copy,nonatomic)NSString * firmwareMode;

@property (copy,nonatomic)NSString * createTime;
@property (copy,nonatomic)NSString * fileSize;
@property (copy,nonatomic)NSString * firmwareDesc;
@property (copy,nonatomic)NSString * firmwarePath;
@property (copy,nonatomic)NSString * formatCreateTime;
@property (copy,nonatomic)NSString * hashCode;
@property (copy,nonatomic)NSString * id;
@property (copy,nonatomic)NSString * log;
@property (copy,nonatomic)NSString * remark;
@property (copy,nonatomic)NSString * url;
@property (copy,nonatomic)NSString * versionCode;
@property (copy,nonatomic)NSString * versionName;

@property (copy,nonatomic)NSString *  localPath; //文件本地地址


@end


/*
 BLE 蓝牙属性模型
 */

@interface HJBLEInfoModel : HJBaseObject

@property (assign,nonatomic)BOOL isConnect;
@property (assign,nonatomic)BOOL BLEPoweredOn;

@property (copy,nonatomic)NSString * BLEVersion;
@property (copy,nonatomic)NSString * BLEBattery;
@property (copy,nonatomic)NSString * BLEModeName;

@property (copy,nonatomic)NSString * PeripheralName;
@property (copy,nonatomic)NSString * PeripheralMac;
/*
 烧录日期
 */
@property (assign,nonatomic)NSString * creatDate;

/*
 超声固件版本
 */
@property (copy,nonatomic)NSString * FirewareVersion;

@end


@interface HJAdviewModel : HJBaseObject

@property (copy,nonatomic)NSString * packageName;
@property (copy,nonatomic)NSString * position;

@end


@interface HJAdviewResponseModel : HJBaseObject

@property (copy,nonatomic)NSString * content;
@property (copy,nonatomic)NSString * contentUrl;
@property (copy,nonatomic)NSString * createTime;
@property (copy,nonatomic)NSString * cycleTime;
@property (copy,nonatomic)NSString * formatCreateTime;
@property (copy,nonatomic)NSString * httpMediaUrl;

@property (copy,nonatomic)NSString * id;
@property (copy,nonatomic)NSString * mediaType;
@property (copy,nonatomic)NSString * mediaUrl;
@property (copy,nonatomic)NSString * packageName;
@property (copy,nonatomic)NSString * position;
@property (copy,nonatomic)NSString * remark;

@property (copy,nonatomic)NSString * status;

@end

