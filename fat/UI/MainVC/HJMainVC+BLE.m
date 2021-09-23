//
//  HJMainVC+BLE.m
//  fat
//
//  Created by ydd on 2021/4/15.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import "HJMainVC+BLE.h"
#import <SDWebImage/SDWebImage.h>

@interface HJMainVC()
    


@end

@implementation HJMainVC (BLE)

- (float)deviceViewHeight{
    
    float height = 3 * KKButtonHeight + kk_y(40) + self.deviceArr.count * KKButtonHeight*1.5 + KKButtomSpace;
    
    if (height>KKSceneHeight/2) {
        height = KKSceneHeight/2;
    }
    
    return height;
}

- (void)deviceViewChange{
    
    self.deviceListView.searchTitleLab.text =self.deviceArr.count?KKLanguage(@"lab_BLE_search_connect"):KKLanguage(@"lab_BLE_searching");
    
    if ([HJCommon shareInstance].BLEInfoModel.BLEPoweredOn == NO) {
        self.deviceListView.searchTitleLab.text = KKLanguage(@"lab_BLE_off");
    }
    
    self.deviceListView.frame = CGRectMake(0, KKSceneHeight-[self deviceViewHeight], KKSceneWidth, [self deviceViewHeight]);
    
    self.deviceListView.cancelBtn.frame = CGRectMake(kk_x(20), self.deviceListView.frame.size.height - KKButtonHeight - KKButtomSpace - kk_y(40), self.deviceListView.frame.size.width-2*kk_x(20), KKButtonHeight);
    
    self.deviceListView.deviceTableView.frame = CGRectMake(0, 0, self.deviceListView.frame.size.width,self.deviceListView.cancelBtn.frame.origin.y);
    
    [self.deviceListView.deviceTableView reloadData];
    
}

- (void)initDataBLE{
    
    //设置蓝牙深度通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(BLEDepth:)
                                                 name:KKBLEParameter_Depth
                                               object:nil];
    //退出账号，进入登录界面
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(quit)
                                                 name:KKAccount_Quit
                                               object:nil];
    
    
    
    /*
     切换部位
     */
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(position_Change)
                                                 name:KKPosition_Change
                                               object:nil];
    
    
    if (pxHeight == KKBLEPxHeight_256) {
        
        
        /*
         升级后重新设置下参数
         */
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(peripheralSetting)
                                                     name:KKPeripheralSetting
                                                   object:nil];
        
    }
    
    

    
    SW(sw);
    
    self.deviceArr  = [NSMutableArray array];
    

    
    /*
     蓝牙基本信息
     */
    
    [[HJBLEManage sharedCentral] BLEInfoStatus:^(NSInteger KKBLEActionStatus, BOOL isSucceeded, id  _Nullable response, NSError * _Nullable error) {
    
    
        if(isSucceeded){
            
            switch (KKBLEActionStatus) {
                    
                case KKBLEActionStatus_Model_Number:
                    
                    [HJCommon shareInstance].BLEInfoModel.BLEModeName = response;
                    [HJCommon shareInstance].BLEInfoModel.PeripheralName = [HJBLEManage sharedCentral].peripheral.name;
                    [HJCommon shareInstance].BLEInfoModel.PeripheralMac = [HJBLEManage sharedCentral].peripheral.identifier.UUIDString;
                    
                    break;
                    
                case KKBLEActionStatus_Software_Revision:
                    
                    [HJCommon shareInstance].BLEInfoModel.BLEVersion = response;
                    
                    break;
                    
                case KKBLEActionStatus_Battery_level:
                    
                    [HJCommon shareInstance].BLEInfoModel.BLEBattery = response;
                    
                    
                    [self refreshBLEView:YES];
                    
                    break;
                    
                    
                default:
                    
                    
                    break;
            }
            
        }
    }];
    
    /*
     系统蓝牙状态
     */
    [[HJBLEManage sharedCentral] BLEStatus:^(NSInteger KKBLEActionStatus, BOOL isSucceeded, id  _Nullable response, NSError * _Nullable error) {
        
        NSLog(@"系统蓝牙状态:%ld",(long)KKBLEActionStatus);
        
        [self hideMaskViewSubview:self.deviceListView];
        
        if (KKBLEActionStatus != KKBLEStatus_ON) {
            
            [sw showToastInWindows:KKToastTime title:KKLanguage(@"lab_BLE_off")];
            
            [HJCommon shareInstance].BLEInfoModel.BLEPoweredOn = NO;
            
        }else{
            
            [HJCommon shareInstance].BLEInfoModel.BLEPoweredOn = YES;
            
            /*
             开启自动连接
             */
            self.autoDisConnect = NO;
            [self searchDeviceAuto];
            
        }
        
        [self refreshBLEView:YES];
    }];
    
    /*
     设备连接状态
     */
    [[HJBLEManage sharedCentral] BLEConnectStatus:^(NSInteger KKBLEActionStatus, BOOL isSucceeded, id  _Nullable response, NSError * _Nullable error) {
        
        NSLog(@"设备连接状态:%ld",(long)KKBLEActionStatus);
        
        if(KKBLEActionStatus == KKBLEConnectStatus_connect){
            /*
             存储蓝牙信息, 方便自动连接
             */
            
            [HJCommon shareInstance].BLEInfoModel.PeripheralName = [HJBLEManage sharedCentral].peripheral.name;
            
            [HJCommon shareInstance].BLEInfoModel.isConnect = YES;
            
            [self peripheralSetting];
            
            [self cancelSearchDevice];
            
        }else{
            
            [HJCommon shareInstance].BLEInfoModel.isConnect = NO;
            
            /*
             发送通知
             */
            
            [[NSNotificationCenter defaultCenter] postNotificationName:KKBLEStatus_disConnect object:nil];
            
            /*
             开启自动连接
             */
            [self searchDeviceAuto];

        }
       
        [self refreshBLEView:YES];
            
    }];
    
    /*
     蓝牙图像数据开始传输回调
     */
    [[HJBLEManage sharedCentral] BLEImageDataStartTransmission:^(NSInteger KKBLEActionStatus, BOOL isSucceeded, id  _Nullable response, NSError * _Nullable error) {
        
        //DLog(@"1蓝牙图像数据开始传输回调:%ld",(long)KKBLEActionStatus);
        
        if (KKBLEActionStatus == KKBLEActionStatus_image_upload_start){
            
            if (![self.presentedViewController isKindOfClass:[HJBLEImageDataVC class]]) {
                
                NSLog(@"self.presentedViewController:%@",self.presentedViewController);
                
                HJBLEImageDataVC * vc = [[HJBLEImageDataVC alloc] init];
                vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
                
                [self presentViewController:vc animated:YES completion:^{
                    
                }];
            }
        }
    }];
    
}

#pragma mark ============== 设备设置 ===============
- (void)peripheralSetting{
    
    /*
     存储蓝牙深度
     */
    KKBLEDepth depth =  [[HJCommon shareInstance] getBLEDepth];
    [[HJCommon shareInstance] saveBLEDepth:depth];
    
    /*
     关闭数据开关
     */
    [[HJBLEManage sharedCentral] setDevice_INIT_CTRL:0 withCallback:^(NSInteger KKBLEActionStatus, BOOL isSucceeded, id  _Nullable response, NSError * _Nullable error) {
        
        /*
         获取超声固件版本
         */
        [[HJBLEManage sharedCentral] getDevice_VERSION_CTRL:^(NSInteger KKBLEActionStatus, BOOL isSucceeded, id  _Nullable response, NSError * _Nullable error) {
            
            NSLog(@"版本时间信息:%@",response);
        
            Byte * vaildByte=(Byte*)[response bytes];
            
            
            /*
             超声固件版本号
             */
            float firmware = (vaildByte[10] & 0xff)/10.;
            
            int year_high = vaildByte[12] & 0xff;
            int year_low =  vaildByte[13] & 0xff;
            
            /*
             年
             */
            int year = year_high * 256 + year_low;
            /*
             月
             */
            int month = vaildByte[14] & 0xff;
            /*
             日
             */
            int day = vaildByte[15] & 0xff;
            
            [HJCommon shareInstance].BLEInfoModel.FirewareVersion = [NSString stringWithFormat:@"%.1f",firmware];
            
            [HJCommon shareInstance].BLEInfoModel.creatDate = [NSString stringWithFormat:@"%d/%d/%d",year,month,day];
            
            
            /*
             设置深度
             */
            [[HJBLEManage sharedCentral] setDevice_M_VALUE:depth withCallback:^(NSInteger KKBLEActionStatus, BOOL isSucceeded, id  _Nullable response, NSError * _Nullable error) {
                
                NSInteger DLPF_PARA ;
                
                if (pxHeight == KKBLEPxHeight_256) {
                    
                    if(depth == KKBLEDepth_level_5){
                        DLPF_PARA = KKBLEDLPF_PARA_level_18;
                    }else{
                        DLPF_PARA = KKBLEDLPF_PARA_level_23;
                    }
                    
                }else{
                    
                    if(depth == KKBLEDepth_level_2){
                        DLPF_PARA = KKBLEDLPF_PARA_level_35;
                    }else{
                        DLPF_PARA = KKBLEDLPF_PARA_level_30;
                    }
                    
                }
                
                /*
                 设置增益
                 */
                [[HJBLEManage sharedCentral] setDevice_DLPF_PARA:DLPF_PARA withCallback:^(NSInteger KKBLEActionStatus, BOOL isSucceeded, id  _Nullable response, NSError * _Nullable error) {
                    
                    if(pxHeight == KKBLEPxHeight_256){
                        /*
                         需要设置CD 和 CE指令
                         */
                        /*
                         设置每线高度
                         */
                        [[HJBLEManage sharedCentral] setSAMPLE_LEN:pxHeight head:pxHead withCallback:^(NSInteger KKBLEActionStatus, BOOL isSucceeded, id  _Nullable response, NSError * _Nullable error) {
                            
                            /*
                             设置延时参数
                             */
                            [[HJBLEManage sharedCentral] setRXATE_DELAY:depth length:pxHeight withCallback:^(NSInteger KKBLEActionStatus, BOOL isSucceeded, id  _Nullable response, NSError * _Nullable error) {
                                
                                /*
                                 打开数据开关
                                 */
                                [[HJBLEManage sharedCentral] setDevice_INIT_CTRL:1 withCallback:^(NSInteger KKBLEActionStatus, BOOL isSucceeded, id  _Nullable response, NSError * _Nullable error) {
                                    
                                    self.maskView.hidden = self.deviceListView.hidden = YES;
                                    
                                    [self showToastInView:self.view time:KKToastTime title:KKLanguage(@"lab_BLE_connect_success")];
                                    
                                    
                                    /*
                                     存储当前连接对象的所有信息
                                     */
                                    NSString * bleModelString  = [[HJCommon shareInstance].BLEInfoModel toJSONString];
                                    
                                    [[NSUserDefaults standardUserDefaults] setObject:bleModelString forKey:KKBLEPeripheralInfo];
                                    [[NSUserDefaults standardUserDefaults] synchronize];
                                    
                                }];
                                
                            }];
                            
                        }];
                        
                    }else{
                        
                        
                        [[HJBLEManage sharedCentral] setDevice_LINE_CYCLE:10 withCallback:^(NSInteger KKBLEActionStatus, BOOL isSucceeded, id  _Nullable response, NSError * _Nullable error) {
                                                    
                            /*
                             打开数据开关
                             */
                            [[HJBLEManage sharedCentral] setDevice_INIT_CTRL:1 withCallback:^(NSInteger KKBLEActionStatus, BOOL isSucceeded, id  _Nullable response, NSError * _Nullable error) {
                                
                                self.maskView.hidden = self.deviceListView.hidden = YES;
                                
                                [self showToastInView:self.view time:KKToastTime title:KKLanguage(@"lab_BLE_connect_success")];
                                
                                
                                /*
                                 存储当前连接对象的所有信息
                                 */
                                NSString * bleModelString  = [[HJCommon shareInstance].BLEInfoModel toJSONString];
                                
                                [[NSUserDefaults standardUserDefaults] setObject:bleModelString forKey:KKBLEPeripheralInfo];
                                [[NSUserDefaults standardUserDefaults] synchronize];
                                
                                
                            }];
                        }];
                        
                        
                    }
                    
                }];
                
            }];
            
            
        }];
        
    }];
}
#pragma mark ============== 搜索设备 ===============
- (void)searchDevice{
    
    [self.deviceArr removeAllObjects];
    
    if([HJCommon shareInstance].BLEInfoModel.BLEPoweredOn == NO){
        [self showToastInWindows:KKToastTime title:KKLanguage(@"lab_BLE_off")];
        return;
    }
    
    [self refreshBLEView:YES];
    

    if([HJBLEManage sharedCentral].peripheral){
        [self.deviceArr addObject:[HJBLEManage sharedCentral].peripheral];
    }
    
    [[HJBLEManage sharedCentral] searchDeviceList:^(NSInteger KKBLEActionStatus, BOOL isSucceeded, id  _Nullable response, NSError * _Nullable error) {
        
        if (KKBLEActionStatus == KKBLEActionStatus_list) {
            
            if (![self.deviceArr containsObject:response]) {
                
                [self.deviceArr addObject:response];
                
                [self deviceViewChange];
            }
        }
    }];
    
    [self startCountDown];
}
/*
 蓝牙自动连接功能
 */
- (void)searchDeviceAuto{
    
    /*
     未登录
     */
    if([[HJCommon shareInstance] isLogin] == NO){
        return;
    }
    
    /*
     主动断开
     */
    if (self.autoDisConnect == YES) {
        return;
    }
    
    /*
     连接状态下
     */
    if([HJCommon shareInstance].BLEInfoModel.isConnect == YES){
        return;
    }
    
    /*
     蓝牙关闭的情况下
     */
    if ([HJCommon shareInstance].BLEInfoModel.BLEPoweredOn == NO) {
        return;
    }
    
    [self refreshBLEView:YES];
    
    
    NSString * PeripheralName  = [HJCommon shareInstance].BLEInfoModel.PeripheralName;
    NSLog(@"开启自动连接:%@",PeripheralName);
    


    [self.deviceArr removeAllObjects];
    
    if([HJBLEManage sharedCentral].peripheral){
        [self.deviceArr addObject:[HJBLEManage sharedCentral].peripheral];
    }
    
    
    [[HJBLEManage sharedCentral] searchDeviceList:^(NSInteger KKBLEActionStatus, BOOL isSucceeded, id  _Nullable response, NSError * _Nullable error) {
        
        if (KKBLEActionStatus == KKBLEActionStatus_list) {
            
            if (![self.deviceArr containsObject:response]) {
                
                [self.deviceArr addObject:response];
                
                
                CBPeripheral * peripheral = (CBPeripheral*)response;
                NSString * PeripheralName = [HJCommon shareInstance].BLEInfoModel.PeripheralName;
                
                if ([peripheral.name isEqualToString:PeripheralName]) {
                    
                    [[HJBLEManage sharedCentral] connectDevice:peripheral];
                    
                }else{
                    
                    /*
                     隐藏之前的视图
                     */
                    if (self.functionView.hidden == NO) {
                        [self hideMaskViewSubview:self.functionView];
                    }
                    
                    if (self.accountListView.hidden == NO) {
                        [self hideMaskViewSubview:self.accountListView];
                    }
                    
                    
                    if ([HJCommon shareInstance].isUpgrade) {
                        return;
                    }
                    
                    
                    /*
                     显示设备视图
                     */
                    [self showMaskViewSubview:self.deviceListView];
                    [self deviceViewChange];
                    
                }
            }
        }
    }];
    
    [self startCountDown];
    
}

#pragma mark ============== 倒计时搜索 ===============
- (void)startCountDown{
    
    SW(sw);
    //开始倒计时
    __block NSInteger timeCount = 60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    if (_timer == nil) {
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_resume(_timer);
    }
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        
        if(timeCount <= 0){ //倒计时结束，关闭
            
            
            dispatch_source_cancel(_timer);
            _timer = nil;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [sw hideMaskViewSubview:sw.deviceListView];
                
                if([HJCommon shareInstance].BLEInfoModel.isConnect == YES){
                    return;
                }
                
                if([HJCommon shareInstance].BLEInfoModel.BLEPoweredOn == NO){
                    return;
                }
                
                if ([HJCommon shareInstance].isUpgrade) {
                    return;
                }
                
                [sw showAlertViewTitle:KKLanguage(@"lab_BLE_search_No_device") message:nil dataArr:@[KKLanguage(@"lab_BLE_searching_again"),KKLanguage(@"lab_BLE_help")] callback:^(NSInteger index, NSString *titleString) {
                    
                    if ([titleString isEqualToString:KKLanguage(@"lab_BLE_searching_again")]) {
                        
                        [sw searchDeviceAuto];
                        
                    }else if ([titleString isEqualToString:KKLanguage(@"lab_BLE_help")]){
                        
                        [sw cancelSearchDevice];
                        
                    }else{
                        
                        [sw cancelSearchDevice];
                    }
                    
                }];
                
            });
            
        }else{
            
            timeCount--;
        }
    });
}


/*
 停止搜索
 */
- (void)cancelSearchDevice{
    
    [[HJBLEManage sharedCentral] cancelSeach];
    [self refreshBLEView:NO];
    
    self.autoDisConnect = NO;
    
    /*
     取消连接
     */
    if(_connectTimer){
        dispatch_source_cancel(_connectTimer);
        _connectTimer = nil;
    }
    
    /*
    取消搜索
     */
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }

    
    
}
#pragma mark ============== 点击事件 ===============
- (void)BLEDepth:(NSNotification*)obj{
    
    NSDictionary * dic = [obj object];
    
    NSInteger depth=[dic[@"depth"] intValue];
    
    if ([HJBLEManage sharedCentral].isConnect == NO) {
        [self showToastInWindows:KKToastTime title:KKLanguage(@"lab_main_deviceDetail_text3")];
        return;
    }

    [self showLoadingInWindows:KKToastTime title:KKLanguage(@"lab_common_loading")];
    
    
    NSInteger level;
    
    
    if (pxHeight == KKBLEPxHeight_256) {
        
        if (depth == KKBLEDepth_level_5) {
            level = KKBLEDLPF_PARA_level_18;
        }else{
            level = KKBLEDLPF_PARA_level_23;
        }
        
    }else{
        
        if (depth == KKBLEDepth_level_2) {
            level = KKBLEDLPF_PARA_level_35;
        }else{
            level = KKBLEDLPF_PARA_level_30;
        }
    }
    
    
    [[HJBLEManage sharedCentral] setDevice_M_VALUE:depth withCallback:^(NSInteger KKBLEActionStatus, BOOL isSucceeded, id  _Nullable response, NSError * _Nullable error) {
        
        /*
         设置增益
         */
        [[HJBLEManage sharedCentral] setDevice_DLPF_PARA:level withCallback:^(NSInteger KKBLEActionStatus, BOOL isSucceeded, id  _Nullable response, NSError * _Nullable error) {
            
            if (pxHeight == KKBLEPxHeight_256) {
                
                /*
                 设置延时参数
                 */
                [[HJBLEManage sharedCentral] setRXATE_DELAY:depth length:pxHeight withCallback:^(NSInteger KKBLEActionStatus, BOOL isSucceeded, id  _Nullable response, NSError * _Nullable error) {
                    
                    if(isSucceeded == NO){
                        [self showToastInWindows:KKToastTime title:KKLanguage(@"tips_fail")];
                    }else{
                        [self showToastInWindows:KKToastTime title:KKLanguage(@"lab_BLE_setting_success")];
                    }
                    
                }];
                
                
            }else{
                
                if(isSucceeded == NO){
                    [self showToastInWindows:KKToastTime title:KKLanguage(@"tips_fail")];
                }else{
                    [self showToastInWindows:KKToastTime title:KKLanguage(@"lab_BLE_setting_success")];
                }
                
            }
            
        }];
        
    }];
    
}
#pragma mark ============== 通知 ===============
- (void)quit{
    
    [[HJBLEManage sharedCentral] disconnectDevice:[HJBLEManage sharedCentral].peripheral];
    [self cancelSearchDevice];
}

- (void)position_Change{
    
    /*
     存储蓝牙深度
     */
    KKBLEDepth depth =  [[HJCommon shareInstance] getBLEDepth];
    
    HJPositionModel * model = [[HJCommon shareInstance] currectPositionToString];
    
    NSInteger level;
    
    
    if (pxHeight == KKBLEPxHeight_256) {
        if (model.positionValue == KKTest_Function_Position_Arm) {
            level = KKBLEDLPF_PARA_level_18;
            depth = KKBLEDepth_level_5;
        }else{
            level = KKBLEDLPF_PARA_level_23;
        }
    }else{
        
        if (model.positionValue == KKTest_Function_Position_Arm) {
            level = KKBLEDLPF_PARA_level_35;
            depth = KKBLEDepth_level_2;
        }else{
            level = KKBLEDLPF_PARA_level_30;
        }
    }
    
    
    [[HJCommon shareInstance] saveBLEDepth:depth];
    
    
    /*
     设置深度
     */
    [[HJBLEManage sharedCentral] setDevice_M_VALUE:depth withCallback:^(NSInteger KKBLEActionStatus, BOOL isSucceeded, id  _Nullable response, NSError * _Nullable error) {
        
        /*
         设置增益
         */
        [[HJBLEManage sharedCentral] setDevice_DLPF_PARA:level withCallback:^(NSInteger KKBLEActionStatus, BOOL isSucceeded, id  _Nullable response, NSError * _Nullable error) {
            
            
            if (pxHeight == KKBLEPxHeight_256) {
                
                NSLog(@"设置增益:%@",response);
                /*
                 设置延时参数
                 */
                [[HJBLEManage sharedCentral] setRXATE_DELAY:depth length:pxHeight withCallback:^(NSInteger KKBLEActionStatus, BOOL isSucceeded, id  _Nullable response, NSError * _Nullable error) {
                    
                }];
                
            }
            

        }];
        
    }];
    
}

- (void)BLEbtnClick:(UIButton*)sender{
    
    [self hideMaskViewSubview:self.deviceListView];
    
    if (self.deviceArr.count>sender.tag) {
        
        CBPeripheral * Peripheral = self.deviceArr[sender.tag];

        if (Peripheral == [HJBLEManage sharedCentral].peripheral) {
            return;
        }
        
        /*
         断开之前的连接
         */
        [[HJBLEManage sharedCentral] disconnectDevice:[HJBLEManage sharedCentral].peripheral];
        self.autoDisConnect = YES;
        
        /*
         连接新的设备
         */
        [[HJBLEManage sharedCentral] connectDevice:Peripheral];
        [self showLoadingInWindows:KKTimeOut title:KKLanguage(@"lab_common_loading")];
        
        [self deviceConnectTimer:Peripheral];
    }

}

#pragma mark ============== 连接超时 ===============
- (void)deviceConnectTimer:(CBPeripheral*)Peripheral{
    
    SW(sw);
    //开始倒计时
    __block NSInteger timeCount = KKTimeOut; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    
    if (_connectTimer == nil) {
        _connectTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_resume(_connectTimer);
    }

    
    dispatch_source_set_timer(_connectTimer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_connectTimer, ^{
        
        if(timeCount <= 0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_connectTimer);
            _connectTimer = nil;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                

                if([HJCommon shareInstance].BLEInfoModel.isConnect == YES &&
                   [[HJCommon shareInstance].BLEInfoModel.PeripheralName isEqualToString:Peripheral.name]){
                    return;
                }
                
                
                [sw showAlertViewTitle:KKLanguage(@"lab_BLE_connect_fail_tips") message:nil dataArr:@[KKLanguage(@"lab_BLE_searching_again"),KKLanguage(@"lab_BLE_help")] callback:^(NSInteger index, NSString *titleString) {
                    
                    if ([titleString isEqualToString:KKLanguage(@"lab_BLE_searching_again")]) {
                        
                        sw.autoDisConnect = NO;
                        [sw searchDeviceAuto];
                        
                    }else if ([titleString isEqualToString:KKLanguage(@"lab_BLE_help")]){
                        
                        [sw cancelSearchDevice];
                        
                    }else{
                        
                        [sw cancelSearchDevice];
                    }
                    
                }];

            });
            
        }else{
            
            timeCount--;
        }
    });
}

/*
 数据展示
 */
-(void)deviceTableViewCell:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CBPeripheral * Peripheral = self.deviceArr[indexPath.row];
    cell.textLabel.text = Peripheral.name;
    cell.detailTextLabel.text = Peripheral.identifier.UUIDString;
    cell.imageView.image = [UIImage imageNamed:@"img_device_info_l"];
    
    if ([HJBLEManage sharedCentral].peripheral) {
        
        if (Peripheral == [HJBLEManage sharedCentral].peripheral) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            cell.tintColor = KKBgYellowColor;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
}

#pragma mark ============== 刷新gif ===============
- (void)refreshBLEView:(BOOL)searching{
    
    [self refreshGIF];
    
    /*
     左上角 蓝牙状态信息
     */
    
    [self.BLEStatusView BLErefresh:[[HJCommon shareInstance].BLEInfoModel.BLEBattery intValue]
                         isConnect:[HJCommon shareInstance].BLEInfoModel.isConnect
                         BLEStatus:[HJCommon shareInstance].BLEInfoModel.BLEPoweredOn
                         searching:searching];
    
}

- (void)refreshGIF{
    
    if([HJCommon shareInstance].BLEInfoModel.isConnect){

        HJPositionModel * model  = [[HJCommon shareInstance] currectPositionToString];
        
        KKTest_Function function  = [[HJCommon shareInstance] getTestFunction];
        
        NSString * pathStr = model.gifImage;
        
        if (model.positionValue == KKTest_Function_Position_Arm && function == KKTest_Function_Muscle) {
            pathStr = @"img_main_arm_muscle_sel";
        }
        
        NSString *path = [[NSBundle mainBundle] pathForResource:pathStr ofType:@"gif"];
        
        NSData *gifData = [NSData dataWithContentsOfFile:path];
        
        self.deviceBgView.deviceImageView.image= [UIImage sd_imageWithGIFData:gifData];
        
        self.deviceBgView.deviceDetailLab.text = KKLanguage(@"lab_main_deviceDetail_text2");
        
        self.deviceBgView.deviceConnectLab.text = KKLanguage(@"lab_main_deviceDetail_text4");
        
    }else{
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"img_main_connect" ofType:@"gif"];
        NSData *gifData = [NSData dataWithContentsOfFile:path];
        self.deviceBgView.deviceImageView.image= [UIImage sd_imageWithGIFData:gifData];
        
        self.deviceBgView.deviceDetailLab.text = KKLanguage(@"lab_main_deviceDetail_text1");
        self.deviceBgView.deviceConnectLab.text = KKLanguage(@"lab_main_deviceDetail_text3");

    }
    
}

@end

