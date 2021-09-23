//
//  HJUserInfoVC.h
//  JiaYueShouYin
//
//  Created by 何军 on 2020/7/3.
//  Copyright © 2020 Eric. All rights reserved.
//

#import "HJBaseViewController.h"
#import "HJNickNameVC.h"
#import "HJUserInfoView.h"
#import "HJMaskView.h"
#import "HJBaseObject.h"
#import "HJFMDBModel.h"
#import "TZImagePickerController.h"
#import "HJOSSUpload.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface HJUserInfoVC : HJBaseViewController


/*
 3种情况
 */

typedef NS_ENUM(NSInteger,KKUserInfoType){
    
    KKUserInfoType_self,
    KKUserInfoType_add,
    KKUserInfoType_other
    
};





@property (assign,nonatomic)KKUserInfoType  userInfoType;
@property (strong,nonatomic)HJUserInfoModel * userModel;

@property (strong,nonatomic)HJMaskView * maskView;

@property (strong,nonatomic)HJUserInfoView * sexView;
@property (strong,nonatomic)HJUserInfoView * birthdayView;
@property (strong,nonatomic)HJUserInfoView * heightView;
@property (strong,nonatomic)HJUserInfoView * weightView;


/*
 保存数据后回调通知
 */
@property (nonatomic,strong) void (^ selectBlock)(HJUserInfoModel * userModel);


@end


