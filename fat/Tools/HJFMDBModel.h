//
//  HJFMDBModel.h
//  fat
//
//  Created by ydd on 2021/4/25.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import "HJBaseObject.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "FMDatabaseQueue.h"
#import "HJBaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJFMDBModel : HJBaseObject

+ (FMDatabase* )getDatabase;

+ (NSString*)getFilePath;

/*
 创建数据库
 */
+(void)creatFMDBTable;

/*
 插入当前用户数据
 */
+ (BOOL)userInfoInsert:(HJUserInfoModel*)model;

/*
 查询用户数据
 */
+ (HJUserInfoModel*)queryCurrectUserInfoWithUserID:(NSString*)userID;


#pragma mark ============== 测量视图数据 ===============

/*
 插入当前图片数据
 */
+ (BOOL)chatInfoInsert:(HJChatInfoModel*)model;

/*
 查询图片数据 recordType 传 0 代表全部
 */
+ (NSMutableArray<HJChatInfoModel*>*)queryCurrectChatInfoWithUserID:(NSString*)userID
                                                           familyId:(NSString*)familyId
                                                         recordDate:(NSString*)recordDate
                                                       bodyPosition:(NSString*)bodyPosition
                                                         recordType:(NSString*)recordType
                                                             upload:(NSString*)upload;

/*
 查询所有未上传图片数据
 */
+ (NSMutableArray<HJChatInfoModel*>*)queryAllChatInfoWithupload:(NSString*)upload;


/*
 删除本地数据
 */
+ (void)deleteChartInfoWithUserID:(NSString*)userID
                         familyId:(NSString*)familyId
                       recordDate:(NSString*)recordDate;


/*
 更新图片数据
 */
+ (BOOL)chatInfoUpdate:(HJChatInfoModel*)model;

@end

NS_ASSUME_NONNULL_END
