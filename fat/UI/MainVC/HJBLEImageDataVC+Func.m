//
//  HJBLEImageDataVC+Func.m
//  fat
//
//  Created by ydd on 2021/8/7.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import "HJBLEImageDataVC+Func.h"

@implementation HJBLEImageDataVC (Func)

#pragma mark ============== 获取蓝牙数据-非补点 ===============
- (void)getBLEDataTwo{

    SW(sw);
    
    [[HJBLEManage sharedCentral] BLEImageData:^(NSInteger KKBLEActionStatus, BOOL isSucceeded, id  _Nullable response, NSError * _Nullable error) {
        
        if (KKBLEActionStatus != KKBLEActionStatus_image_upload){
            return;
        }
        
        NSArray * dataArr  = response;
        NSData * imageData = [dataArr lastObject];
        
        id dataTag = [dataArr objectAtIndex:1];
        
        DLog(@"getBLEDataTwo开始帧%@ 第几线%d %ld",dataTag,[[dataArr firstObject] intValue],(long)sw.arrGetCount);
        
        /*
         开始帧
         */
        if ([dataTag intValue] == KKBLEStart) {
            
            /*
             如果存在之前测量成功的图像,则上传
             */
            
            [sw saveChatInfoData:sw.resultPointArr];
            
            [sw.pxArr removeAllObjects];
            [sw.pxArr addObjectsFromArray:sw.pxBlackArr];
            
            sw.arrGetCount = 0;
            sw.isAcceptNewData = YES;
            sw.isImageSuccess = NO;
            
            [sw refreshUI];
            
            sw.chatView.frame = CGRectMake(sw.chatView.frame.origin.x, KKSceneHeight - (KKButtonHeight*2+self->_imageViewheight), sw.chatView.frame.size.width, sw.chatView.frame.size.height);
            
        }else if([dataTag intValue] == KKBLEEnd){
            
            sw.isAcceptNewData = NO;
            [sw refreshUI];
            
        }
        
        
        //  if (sw.isAcceptNewData == YES && [dataTag intValue] != KKBLEStart) {
        
        NSData * validData = [imageData subdataWithRange:NSMakeRange(pxHead, imageData.length-pxHead)];
        [sw.pxArr addObject:validData];
        
        if (sw.pxArr.count>0) {
            
            UIImage * image  = [sw imageFromBRGABytesImage];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (sw.isImageSuccess == NO) {
                    sw.chatView.BLEImageView.image = image;
                }
                
            });
        }
        
        [sw.pxArr removeObjectAtIndex:0];
        
        /*
         总笔数累加
         */
        sw.arrGetCount++;
        // }
        
        /*
         收满 最大 线之后,开始取判断图像
         */
        if (sw.arrGetCount >= KKTotalCount && sw.arrGetCount%KKDelayCount == 0 && sw.isAcceptNewData == YES) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [sw detectionImage];
            });
            
        }
        
    }];
    
}


#pragma mark ============== 获取蓝牙数据-补点 ===============
- (void)getBLEData{
    
    SW(sw);
    
    [[HJBLEManage sharedCentral] BLEImageData:^(NSInteger KKBLEActionStatus, BOOL isSucceeded, id  _Nullable response, NSError * _Nullable error) {
        
        if (KKBLEActionStatus != KKBLEActionStatus_image_upload){
            return;
        }
        
        /*
         收取中间数据
         */
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSArray * dataArr  = response;
            id dataTag = [dataArr objectAtIndex:1];
            NSData * imageData = [dataArr lastObject];
            
            
            if ([dataTag intValue] == KKBLEStart) {
                
                /*
                 如果存在之前测量成功的图像,则上传
                 */
                
                [sw saveChatInfoData:sw.resultPointArr];
                
                DLog(@"getBLEData开始帧%@ 第几线%d %d",dataTag,[[dataArr firstObject] intValue],sw.isAcceptNewData);
                
                sw.endCount = 0;
                sw.arrGetCount = 0;
                sw.isAcceptNewData = YES;
                /*
                 视图刷新
                 */
                sw.chatView.frame = CGRectMake(sw.chatView.frame.origin.x, KKSceneHeight - (KKButtonHeight*2+self->_imageViewheight), sw.chatView.frame.size.width, sw.chatView.frame.size.height);
                
                /*
                 蓝牙原始数据
                 */
                [sw.BLEDataArr removeAllObjects];
                
                sw.isImageSuccess = NO;
                
                
                [sw startTimer];
                [sw refreshUI];
                
            }
            
            NSData * validData = [imageData subdataWithRange:NSMakeRange(pxHead, imageData.length-pxHead)];
            [sw.BLEDataArr addObject:validData];
            
            sw.arrGetCount++;
            
            /*
             开始取判断图像
             */
            if (sw.arrGetCount%KKDelayCount == 0 && sw.isAcceptNewData == YES) {
                [sw detectionImage];
            }
            
            
            
        });
        
    }];
    
}

#pragma mark ============== 检测图像是否满足成像条件 ===============
- (void)detectionImage{
    
    if ([[HJCommon shareInstance] getTestFunction] == KKTest_Function_Muscle) {
        self.chatView.oldImage = self.chatView.BLEImageView.image;
        return;
    }
    
    DLog(@"开始检测:%ld",(long)self.arrGetCount);
    
    SW(sw);
    
    [[[HJOpencvModel alloc] init] ImageTofindUnit:self.chatView.BLEImageView.image block:^(BOOL isSuccess,UIImage *resultImage, NSArray *pointArr) {
        
        //DLog(@"ImageTofindUnit:%d",isSuccess);
        
        if (isSuccess) {
            
            [sw stopTimer];
            
            sw.isImageSuccess = YES;
            
            sw.isAcceptNewData = NO;
            
            sw.chatView.pointArr = [NSMutableArray arrayWithArray:pointArr];
            
            sw.chatView.BLEImageView.image = resultImage;
            
            sw.chatView.oldImage = resultImage;
            
            sw.uploadImage = resultImage;
            
            [sw getAvgHeight:pointArr];
            
            sw.resultPointArr = pointArr;
            
            [sw refreshUI];
            
            [sw.chatView drawPointLine:pointArr bitmapHeight:pxHeight];
            
            [sw.chatView movePoint:YES bitmapHeight:pxHeight];
            
            [sw.chatView fatAnimation];
            /*
             拖动黄线后,重新计算值
             */
            sw.chatView.selectBlock = ^(NSArray * _Nonnull pointArr) {
                
                [sw getAvgHeight:pointArr];
                
                sw.resultPointArr = pointArr;
                
                [sw refreshUI];
            };
            
        }else{
            
            [sw.chatView movePoint:NO bitmapHeight:pxHeight];
            
            sw.isAcceptNewData = YES;
            sw.isImageSuccess = NO;
            sw.resultPointArr = nil;
            
        }
    }];
}

#pragma mark ============== 生成图片 ===============
- (UIImage *)imageFromBRGABytesImage{
    
    UInt32 rawImageData[pxWidth*pxHeight];
    
    UInt8 a,r,g,b;
    
    a=255;
    
    for (int x = 0; x<pxWidth; x++) {
        
        if (x>self.pxArr.count-1) {
            DLog(@"错误");
            return nil;
        }
        
        NSMutableData * data = self.pxArr[x];
        
        if (data==nil) {
            DLog(@"错误data");
            return nil;
        }
        
        Byte * colorP  = (Byte*)[data bytes];
        
        for (int y = 0; y <pxHeight; y++) {
            
            r = g = b =  colorP[y] & 0xff;
            
            rawImageData[y*pxWidth+x] = ((UInt32)a)<<24 | ((UInt32)r)<<16 | ((UInt32)g)<<8 | ((UInt32)b);
            
        }
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rawImageData,
                                                 pxWidth,
                                                 pxHeight,
                                                 8,
                                                 pxWidth * 4,
                                                 colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return image;
    
}


#pragma mark ==============  获取平均厚度 ===============
- (void)getAvgHeight:(NSArray*)pointArr{
    
    float  imageHeight = pxHeight;
    
    NSInteger depth = [[HJCommon shareInstance] getBLEDepth];

    NSInteger depth_mm = [[HJCommon shareInstance] getBLEDepth_cm_new:depth bitmapHight:pxHeight withOcxo:OCXO];
    float depth_cm = depth_mm/10.0;
    

    float allHeight = 0.0;
    float avgHeight = 0.0;
    
    float maxHeight = 0.0;
    float minHeight = imageHeight;
    
    for (int i = 0; i<pointArr.count; i++) {
        
        CGPoint point = [pointArr[i] CGPointValue];
        allHeight = point.y+allHeight;
        
        if (point.y>maxHeight) {
            maxHeight = point.y;
        }
        
        if (point.y<minHeight) {
            minHeight = point.y;
        }
    }
    
    avgHeight = allHeight/pointArr.count;
    
    avgHeight = depth_cm*avgHeight/imageHeight;
    
    maxHeight = depth_cm*maxHeight/imageHeight;
    
    minHeight = depth_cm*minHeight/imageHeight;
    
    _avgHeight  = avgHeight;
    _maxHeight = maxHeight;
    _minHeight = minHeight;
    
}


#pragma mark ==============  插入图片数据 ===============
- (void)saveChatInfoData:(NSArray*)pointArr{
    
    float imageHeight = pxHeight;
    /*
     如果是访客则不上传数据
     */
    if ([[HJCommon shareInstance].selectModel.id isEqualToString:KKAccount_TestId]) {
        return;
    }
    
    /*
     如果没有成功图像数据也返回
     */
    if (self.resultPointArr == nil) {
        return;
    }
    
    
    NSInteger depth = [[HJCommon shareInstance] getBLEDepth];
    
    
    HJChatInfoModel * model = [[HJChatInfoModel alloc] init];
    
    model.userId  = [HJCommon shareInstance].userInfoModel.userId;
    model.familyId = [HJCommon shareInstance].selectModel.id;
    
    model.recordDate = [[HJCommon shareInstance] todayTime_yyyy_MM_dd_HH_mm_ss];

    model.recordType =[NSString stringWithFormat:@"%ld",(long)[[HJCommon shareInstance] getTestFunction]];
    
    model.bodyPosition = [NSString stringWithFormat:@"%ld",(long)[[HJCommon shareInstance] getTestFunctionPosition]];

 
    model.depth = [NSString stringWithFormat:@"%ld",(long)depth];
    model.ocxo = [NSString stringWithFormat:@"%d",OCXO];
    model.recordValue = [NSString stringWithFormat:@"%f%@",_avgHeight*10,KKBLEParameter_mm];
    
    model.bitmapHight = [NSString stringWithFormat:@"%.0f",imageHeight];
    model.transType = @"BLE";
    model.upload =@"0";
    
    NSMutableString * arrString = [NSMutableString string];
    for (int i = 0; i<pointArr.count; i++) {
        CGPoint point = [pointArr[i] CGPointValue];
        [arrString appendFormat:@"%.0f,",point.x];
        [arrString appendFormat:@"%.0f,",point.y];
    }

    
    model.arrayAvg = arrString;
    model.sn = @"Z2";
    
    self.resultPointArr = nil;
    

    SW(sw);
    
    [self uploadImage:^(BOOL result, NSArray<NSString *> * _Nonnull nameArray) {
        
        if (result) {
            
            model.recordImage = [nameArray firstObject];
        
            [sw uploadChatInfoData:model];
            
            
        }else{
            
            /*
             图片存本地
             */
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [sw savePhotoInLocl:model];
            });
        }
    }];

}
#pragma mark ============== 图片上传 ===============
- (void)uploadImage:(ImageCallback)success {
    
    [[HJOSSUpload aliyunInit] uploadImage:@[self.uploadImage] success:^(BOOL result, NSArray<NSString *> * _Nonnull nameArray) {
        success(result,nameArray);
    }];
    
    
}

#pragma mark ============== 上传记录 ===============
- (void)uploadChatInfoData:(HJChatInfoModel*)model{
    
    DLog(@"上传图像数据");
    
    SW(sw);
    
    NSDictionary * dic = [model toDictionary];
    
    [KKHttpRequest HttpRequestType:k_POST withrequestType:NO withDataString:dic withUrl:KK_URL_add_fat_record withSuccess:^(id result, NSDictionary *resultDic, HJHTTPModel * httpmodel) {
        
        if (httpmodel.errorcode == KKStatus_success) {
            
            //解析数据,存储数据库
            NSString * jsonStr = [HJAESUtil aesDecrypt:httpmodel.data];
            DLog(@"jsonStr:%@",jsonStr);
            
            [sw showToastInWindows:KKToastTime title:KKLanguage(@"tips_upload_success") userInteractionEnabled:NO];
            
            /*
             发送新数据通知
             */
            [[NSNotificationCenter defaultCenter] postNotificationName:KKTest_NewData object:nil];
            
        }else{
            
            [sw showToastInView:sw.view time:KKToastTime title:httpmodel.errormessage];
            
            /*
             图片存本地
             */
            dispatch_async(dispatch_get_main_queue(), ^{
                [sw savePhotoInLocl:model];
            });
            
        }
        
    } withError:^(id result, NSDictionary *resultDic, HJHTTPModel * httpmodel) {
        
        [sw showToastInView:sw.view time:KKToastTime title:KKLanguage(@"tips_fail")];
        
        /*
         图片存本地
         */
        dispatch_async(dispatch_get_main_queue(), ^{
            [sw savePhotoInLocl:model];
        });
        
    }];
    
}

#pragma mark ============== 图片插入本地 ===============
- (void)savePhotoInLocl:(HJChatInfoModel*)model{
    
    NSString * fileName = [NSString stringWithFormat:@"%@.png",model.recordDate];
    [[HJCommon shareInstance] saveImageDocuments:self.uploadImage fileName:fileName size:CGSizeMake(_imageViewwidth, _imageViewheight)];
    model.recordImage = fileName;
    [HJFMDBModel chatInfoInsert:model];
    
    [self showToastInWindows:KKToastTime title:KKLanguage(@"tips_uploadimage_success") userInteractionEnabled:NO];
}


- (void)addGuideView:(BOOL)show{
    

    
    KKTest_Function  Test_Function= [[HJCommon shareInstance] getTestFunction];
    HJPositionModel * model = [[HJCommon shareInstance] currectPositionToString];
    

    
    if (Test_Function == KKTest_Function_Muscle) {
        
        BOOL showGuide = NO;
        
        if (model.positionValue == KKTest_Function_Position_Belly) {
            
            showGuide =  [[[NSUserDefaults standardUserDefaults] objectForKey:KKMuscle_guide_belly] boolValue];
            
        }else if(model.positionValue == KKTest_Function_Position_Arm){
            
            showGuide =  [[[NSUserDefaults standardUserDefaults] objectForKey:KKMuscle_guide_arm] boolValue];
            
        }else if (model.positionValue ==  KKTest_Function_Position_Ham){
            
            showGuide =  [[[NSUserDefaults standardUserDefaults] objectForKey:KKMuscle_guide_ham] boolValue];
            
        }else if (model.positionValue == KKTest_Function_Position_Calf){
            
            showGuide =  [[[NSUserDefaults standardUserDefaults] objectForKey:KKMuscle_guide_calf] boolValue];
        }
        
        if (show) {
            showGuide = NO;
        }
        
        if (showGuide == NO) {
            
            [self.view addSubview:self.guideView];
            
            [self refreshGuide:self.guideView.indexTag];
        }
        

    }
}

- (void)addMuscleView{
    
    KKTest_Function  Test_Function= [[HJCommon shareInstance] getTestFunction];
    
    if (Test_Function == KKTest_Function_Muscle) {
        
        [self.view addSubview:self.muscleView];
        
        [self refreshMuscleView];
        
        
    }
}


- (void)refreshGuide:(NSInteger)indexTag{

    
    HJPositionModel * model = [[HJCommon shareInstance] currectPositionToString];
    
    NSString * titleString;
    NSString * firstString;
    NSString * twoString;
    
    NSString * imageString;
    NSString * lastString = KKLanguage(@"lab_guide_last");
    
    switch (model.positionValue) {
            
        case KKTest_Function_Position_Belly:
            
            titleString = KKLanguage(@"lab_guide_text_1");
            
            if (indexTag == 0) {
                
                firstString = KKLanguage(@"lab_guide_text_2");
                twoString = KKLanguage(@"lab_guide_text_3");
                imageString = @"img_guide_belly_1";
                
            }else if (indexTag == 1){
                
                firstString = KKLanguage(@"lab_guide_text_4");
                twoString = KKLanguage(@"lab_guide_text_5");
                imageString = @"img_guide_belly_2";
                
            }else if (indexTag == 2){
                
                firstString = KKLanguage(@"lab_guide_text_6");
                twoString = KKLanguage(@"lab_guide_text_7");
                imageString = @"img_guide_belly_3";
                
            }else if (indexTag == 3){
                
                firstString = KKLanguage(@"lab_guide_text_8");
                twoString = KKLanguage(@"lab_guide_text_9");
                imageString = @"img_guide_belly_4";
                lastString = KKLanguage(@"lab_guide_quit");
            }
            
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:KKMuscle_guide_belly];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            break;

            
        case KKTest_Function_Position_Arm:
            
            titleString = KKLanguage(@"lab_guide_text_10");
            
            if (indexTag == 0) {
                
                firstString = KKLanguage(@"lab_guide_text_2");
                twoString = KKLanguage(@"lab_guide_text_11");
                imageString = @"img_guide_arm_1";
                
            }else if (indexTag == 1){
                
                firstString = KKLanguage(@"lab_guide_text_12");
                twoString = KKLanguage(@"lab_guide_text_13");
                imageString = @"img_guide_arm_2";
                
            }else if (indexTag == 2){
                
                firstString = KKLanguage(@"lab_guide_text_6");
                twoString = KKLanguage(@"lab_guide_text_14");
                imageString = @"img_guide_arm_3";
                
            }else if (indexTag == 3){
                
                firstString = KKLanguage(@"lab_guide_text_15");
                twoString = KKLanguage(@"lab_guide_text_16");
                imageString = @"img_guide_arm_4";
                lastString = KKLanguage(@"lab_guide_quit");
            }
            
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:KKMuscle_guide_arm];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            break;
            
        case KKTest_Function_Position_Ham:
            
            titleString = KKLanguage(@"lab_guide_text_17");
            
            if (indexTag == 0) {
                
                firstString = KKLanguage(@"lab_guide_text_2");
                twoString = KKLanguage(@"lab_guide_text_18");
                imageString = @"img_guide_ham_1";
                
            }else if (indexTag == 1){
                
                firstString = KKLanguage(@"lab_guide_text_19");
                twoString = KKLanguage(@"lab_guide_text_20");
                imageString = @"img_guide_ham_2";
                
            }else if (indexTag == 2){
                
                firstString = KKLanguage(@"lab_guide_text_6");
                twoString = KKLanguage(@"lab_guide_text_21");
                imageString = @"img_guide_ham_3";
                
            }else if (indexTag == 3){
                
                firstString = KKLanguage(@"lab_guide_text_22");
                twoString = KKLanguage(@"lab_guide_text_23");
                imageString = @"img_guide_ham_4";
                lastString = KKLanguage(@"lab_guide_quit");
            }
            
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:KKMuscle_guide_ham];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            break;
            
        case KKTest_Function_Position_Calf:
            
            titleString = KKLanguage(@"lab_guide_text_24");
            
            if (indexTag == 0) {
                
                firstString = KKLanguage(@"lab_guide_text_2");
                twoString = KKLanguage(@"lab_guide_text_25");
                imageString = @"img_guide_calf_1";
                
            }else if (indexTag == 1){
                
                firstString = KKLanguage(@"lab_guide_text_26");
                twoString = KKLanguage(@"lab_guide_text_27");
                imageString = @"img_guide_calf_2";
                
            }else if (indexTag == 2){
                
                firstString = KKLanguage(@"lab_guide_text_6");
                twoString = KKLanguage(@"lab_guide_text_28");
                imageString = @"img_guide_calf_3";
                
            }else if (indexTag == 3){
                
                firstString = KKLanguage(@"lab_guide_text_22");
                twoString = KKLanguage(@"lab_guide_text_23");
                imageString = @"img_guide_calf_4";
                lastString = KKLanguage(@"lab_guide_quit");
            }
            
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:KKMuscle_guide_calf];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            break;
            
        default:
            break;
    }
    
    
    self.guideView.titleLab.text = titleString;
    self.guideView.firstLab.text = firstString;
    self.guideView.twoLab.text = twoString;
    self.guideView.imageView.image = [UIImage imageNamed:imageString];
    [self.guideView.lastBtn setTitle:lastString forState:UIControlStateNormal];
    
    
    
    if (indexTag == 0) {
        
        float width = kk_x(320);
        float height = kk_y(60);
        
        self.guideView.backBtn.hidden = YES;
       
        self.guideView.lastBtn.frame = CGRectMake(self.guideView.frame.size.width/2 - width/2, self.guideView.frame.size.height - height - kk_y(20), width, height);
        
        
    }else{
        
        self.guideView.backBtn.hidden = NO;
        
        float width = kk_x(320);
        float height = kk_y(60);
        
        self.guideView.backBtn.frame = CGRectMake(self.guideView.frame.size.width/2 - width/2 - width/2/2 - kk_x(10),self.guideView.frame.size.height - height - kk_y(20), width/2, height);
        
        
        self.guideView.lastBtn.frame = CGRectMake(self.guideView.frame.size.width/2 - width/4+kk_x(10), self.guideView.frame.size.height - height - kk_y(20), width, height);
        
        
        
        if (indexTag == 4){
            [self.guideView remove];
        }
    }
    
    
}

- (void)refreshMuscleView{
    
    HJPositionModel * model = [[HJCommon shareInstance] currectPositionToString];
    
    NSString * titleString;
    NSString * imageString;
   
    
    switch (model.positionValue) {
            
        case KKTest_Function_Position_Belly:
            
            titleString = KKLanguage(@"lab_guide_text_29");
            imageString = @"img_guide_body_belly";
            
        
            break;

            
        case KKTest_Function_Position_Arm:
            
            titleString = KKLanguage(@"lab_guide_text_30");
            imageString = @"img_guide_body_arm";
            
            
            break;
            
        case KKTest_Function_Position_Ham:
            
            titleString = KKLanguage(@"lab_guide_text_31");
            imageString = @"img_guide_body_ham";
            
            
            break;
            
        case KKTest_Function_Position_Calf:
            
            titleString = KKLanguage(@"lab_guide_text_32");
            imageString = @"img_guide_body_calf";
            
            break;
            
        default:
            break;
    }
    
    
    self.muscleTitleLab.text = titleString;
    self.muscleImageView.image = [UIImage imageNamed:imageString];
    
}

@end
