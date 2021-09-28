//
//  HJFMDBModel.m
//  fat
//
//  Created by ydd on 2021/4/25.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import "HJFMDBModel.h"

FMDatabase * _db = nil;

@implementation HJFMDBModel

+ (NSString*)getFilePath
{
    NSString* libPath =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    return  [libPath stringByAppendingPathComponent:@"Table_fat.sqlite"];
}

//获取数据库操作对象
+ (FMDatabase* )getDatabase
{
    if (_db == nil)
    {
        _db = [[FMDatabase alloc] initWithPath:[self getFilePath]];
    }
    return _db;
}

+(void)creatFMDBTable{

    //2.获得数据库
    _db =[self getDatabase];
    
    if ([_db open]){

        BOOL isok=NO;
        
        //用户表
        isok=[_db executeUpdate:@"create table if not exists T_USER_INFO (id text,userName text,nickName text,userId text,passWord text,birthday text,height text,weight text,ossHeadImageUrl text,formatCreateTime text,sex integer,status integer,createTime text,email text,isEmail text);"];
        
        if (isok){
            
            NSLog(@"建立T_USER_INFO数据库成功");
            
        }else{
            
            NSLog(@"建立T_USER_INFO数据库失败");
            
        }
        
        
        
        //历史视图表
        /*
         创建时间  recordDate
         用户id   userId
         成员id   familyId
         
         测量部位 bodyPosition
         测量类别 recordType  1=为肌肉，2=为脂肪
         测量深度 depth
         测量正元 ocxo
         
         平均厚度 recordValue
         
         绘图高度 bitmapHight
         绘图数组(x,y) arrayAvg
         本地图片地址   recordImage
         oss地址      httpRecordImage
         
         设备sn  sn

         传输类型 transType BLE/OTG
         是否已经上传服务器  upload   1已上传 0未上传
         */
        
        isok=[_db executeUpdate:@"create table if not exists T_CHAT_HISTORY (familyId text,userId text,recordDate text,bodyPosition text,recordType text,depth text,ocxo text,recordValue text,bitmapHight text,arrayAvg text,recordImage text,httpRecordImage text,sn text,transType text,upload text);"];
        
        if (isok){
            
            NSLog(@"建立T_CHAT_HISTORY数据库成功");
            
        }else{
            
            NSLog(@"建立T_CHAT_HISTORY数据库失败");
            
        }
        
        
    }
    
}


+ (BOOL)userInfoInsert:(HJUserInfoModel*)model{
    
    _db=[self getDatabase];
    
    BOOL isok=YES;
    
    if ([_db open]){
        
        FMResultSet *rs =[_db executeQuery:@"select * from T_USER_INFO where userId = ?",model.userId];
        
        if([rs next]){
            
            //存在---更新替换
            isok = [_db executeUpdate:@"update T_USER_INFO set userName = ?,userId=?,passWord=?,birthday=?,height=?,weight=?,ossHeadImageUrl=?,formatCreateTime=?,sex=?,status=?,createTime=?,id = ?,email = ?,isEmail = ? where userId = ?",model.userName,model.userId,model.passWord,model.birthday,model.height,model.weight,model.ossHeadImageUrl,model.formatCreateTime,model.sex,model.status,model.createTime,model.id,model.email,model.isEmail,model.userId];
            
            if(isok){
                
                NSLog(@"T_USER_INFO更新成功");
                
            }else{
                
                NSLog(@"T_USER_INFO更新失败");
                
            }
            
        }else{
            
    
            //不存在--插入
            isok=[_db executeUpdate:@"insert into T_USER_INFO (userName,userId,passWord,birthday,height,weight,ossHeadImageUrl,formatCreateTime,sex,status,createTime,id,email,isEmail) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?);",model.userName,model.userId,model.passWord,model.birthday,model.height,model.weight,model.ossHeadImageUrl,model.formatCreateTime,model.sex,model.status,model.createTime,model.id,model.email,model.isEmail];
            
            if(isok){
                
                NSLog(@"T_USER_INFO插入成功");
                
            }else{
                
                NSLog(@"T_USER_INFO插入失败");
                
            }
        }
    }
    return isok;
}

/*
 查询用户表所有用户数据
 */
+ (HJUserInfoModel*)queryCurrectUserInfoWithUserID:(NSString*)userID{
    
    HJUserInfoModel * model = [[HJUserInfoModel alloc] init];
    
    _db =[self getDatabase];
    
    if ([_db open]){
        
        FMResultSet *resultSet =[_db executeQuery:@"select * from T_USER_INFO where userId = ?;",userID];
        
        
        if([resultSet next]){
            
            model = [self modelWithResult:resultSet with:model];
        }
    }
    
    return model;
}


#pragma mark ============== 数据转换方法 ===============
+(HJUserInfoModel*)modelWithResult:(FMResultSet*)resultSet with:(HJUserInfoModel*)mod{
    

    mod.userId=[resultSet stringForColumn:@"userId"];
    
    mod.userName=[resultSet stringForColumn:@"userName"];
    
    
    mod.height=[resultSet stringForColumn:@"height"];
    
    mod.weight=[resultSet stringForColumn:@"weight"];
    
    mod.birthday=[resultSet stringForColumn:@"birthday"];
    
    mod.formatCreateTime=[resultSet stringForColumn:@"formatCreateTime"];
    
    mod.ossHeadImageUrl=[resultSet stringForColumn:@"ossHeadImageUrl"];
    
    mod.passWord=[resultSet stringForColumn:@"passWord"];
     
    mod.sex=[resultSet stringForColumn:@"sex"];
    
    mod.createTime=[resultSet stringForColumn:@"createTime"];
    
    mod.status=[resultSet stringForColumn:@"status"];
    
    mod.id = [resultSet stringForColumn:@"id"];
    
    mod.httpHeadImage = [resultSet stringForColumn:@"ossHeadImageUrl"];
    
    mod.email = [resultSet stringForColumn:@"email"];
    
    mod.isEmail = [resultSet stringForColumn:@"isEmail"];
    
    return mod;
    
}

#pragma mark ============== 测量视图数据 ===============
#pragma mark ============== 测量视图数据 ===============
#pragma mark ============== 测量视图数据 ===============
/*
 插入当前图片数据
 */
+ (BOOL)chatInfoInsert:(HJChatInfoModel*)model{
    
    _db=[self getDatabase];
    
    BOOL isok=YES;
    
    if ([_db open]){
    
        //不存在--插入
        isok=[_db executeUpdate:@"insert into T_CHAT_HISTORY (userId,familyId,recordDate,bodyPosition,recordType,depth,ocxo,recordValue,bitmapHight,arrayAvg,recordImage,sn,transType,upload) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?);",model.userId,model.familyId,model.recordDate,model.bodyPosition,model.recordType,model.depth,model.ocxo,model.recordValue,model.bitmapHight,model.arrayAvg,model.recordImage,model.sn,model.transType,model.upload];
        
        if(isok){
            
            NSLog(@"T_CHAT_HISTORY插入成功");
            
        }else{
            
            NSLog(@"T_CHAT_HISTORY插入失败");
            
        }
        
    }
    return isok;
}

/*
 查询图片数据
 */
+ (NSMutableArray<HJChatInfoModel*>*)queryCurrectChatInfoWithUserID:(NSString*)userID
                                                           familyId:(NSString*)familyId
                                                         recordDate:(NSString*)recordDate
                                                       bodyPosition:(NSString*)bodyPosition
                                                         recordType:(NSString*)recordType
                                                             upload:(NSString*)upload{

    NSMutableArray * arr = [NSMutableArray array];
    
    _db =[self getDatabase];
    
    if ([_db open]){
        
        FMResultSet *resultSet;
        
        NSMutableString * queryString = [NSMutableString string];
        
        [queryString appendFormat:@"select * from T_CHAT_HISTORY where userId = '%@'",userID];
        
        if (familyId.length) {
            [queryString appendFormat:@" and familyId = '%@'",familyId];
        }
        
        if (bodyPosition.length) {
            [queryString appendFormat:@" and bodyPosition = '%@'",bodyPosition];
        }
        
        if ([recordType intValue] == KKTest_Function_Fat ||
            [recordType intValue] == KKTest_Function_Muscle) {
            [queryString appendFormat:@" and recordType = '%@'",recordType];
        }
        
        if (upload.length) {
            [queryString appendFormat:@" and upload = '%@'",upload];
        }
      
        
        [queryString appendString:@";"];
        resultSet =[_db executeQuery:queryString];
 
        
        //遍历结果集合
        while ([resultSet next]){

            HJChatInfoModel * model = [self chatModelWithResult:resultSet];

            [arr addObject:model];

        }
 
    }
    
    return arr;
}

/*
 查询所有未上传图片数据
 */
+ (NSMutableArray<HJChatInfoModel*>*)queryAllChatInfoWithupload:(NSString*)upload{

    NSMutableArray * arr = [NSMutableArray array];
    
    _db =[self getDatabase];
    
    if ([_db open]){
        
        FMResultSet *resultSet;
        
        NSMutableString * queryString = [NSMutableString string];
        
        [queryString appendFormat:@"select * from T_CHAT_HISTORY where upload = '%@'",upload];
    
        [queryString appendString:@";"];
        resultSet =[_db executeQuery:queryString];
 
        //遍历结果集合
        while ([resultSet next]){

            HJChatInfoModel * model = [self chatModelWithResult:resultSet];

            [arr addObject:model];

        }
 
    }
    
    return arr;
}


/*
 更新图片数据
 */
+ (BOOL)chatInfoUpdate:(HJChatInfoModel*)model{
    
    _db=[self getDatabase];
    
    BOOL isok=YES;
    
    if ([_db open]){
        
        
        NSMutableString * queryString = [NSMutableString string];
        
        [queryString appendFormat:@"update T_CHAT_HISTORY set upload = '1' where userID  = '%@'",model.userId];
        
        if (model.familyId.length) {
            [queryString appendFormat:@" and familyId = '%@'",model.familyId];
        }
        
        [queryString appendFormat:@" and recordDate = '%@'",model.recordDate];
        

        [queryString appendString:@";"];
        
        isok =[_db executeUpdate:queryString];
        
    
        if(isok){
            
            NSLog(@"T_CHAT_HISTORY更新成功");
            
        }else{
            
            NSLog(@"T_CHAT_HISTORY更新失败");
            
        }
        
    }
    return isok;
}


/*
 删除本地数据
 */
+ (void)deleteChartInfoWithUserID:(NSString*)userID
                         familyId:(NSString*)familyId
                       recordDate:(NSString*)recordDate{
    
    _db =[self getDatabase];
    
    if ([_db open]){
        
        FMResultSet *resultSet;
        
        NSMutableString * queryString = [NSMutableString string];
        
        [queryString appendFormat:@"delete from T_CHAT_HISTORY where userId = '%@'",userID];
        
        if (familyId.length) {
            [queryString appendFormat:@" and familyId = '%@'",familyId];
        }
        
        [queryString appendFormat:@" and recordDate = '%@'",recordDate];
        

        [queryString appendString:@";"];
        resultSet =[_db executeQuery:queryString];
 
    }
    
}

#pragma mark ============== 数据转换方法 ===============
+(HJChatInfoModel*)chatModelWithResult:(FMResultSet*)resultSet{
    
    HJChatInfoModel * mod =[[HJChatInfoModel alloc] init];

    mod.userId=[resultSet stringForColumn:@"userId"];
    
    mod.familyId=[resultSet stringForColumn:@"familyId"];
    
    mod.recordDate=[resultSet stringForColumn:@"recordDate"];
    
    mod.bodyPosition=[resultSet stringForColumn:@"bodyPosition"];
    
    mod.recordType=[resultSet stringForColumn:@"recordType"];
    
    mod.depth=[resultSet stringForColumn:@"depth"];
    
    mod.ocxo=[resultSet stringForColumn:@"ocxo"];
    
    mod.recordValue=[resultSet stringForColumn:@"recordValue"];
    
    mod.bitmapHight=[resultSet stringForColumn:@"bitmapHight"];
     
    mod.arrayAvg=[resultSet stringForColumn:@"arrayAvg"];
    
    mod.recordImage=[resultSet stringForColumn:@"recordImage"];
    
    mod.httpRecordImage=[resultSet stringForColumn:@"httpRecordImage"];
    
    mod.sn = [resultSet stringForColumn:@"sn"];
    
    mod.transType = [resultSet stringForColumn:@"transType"];
    
    mod.upload = [resultSet stringForColumn:@"upload"];
    
    return mod;
    
}

@end
