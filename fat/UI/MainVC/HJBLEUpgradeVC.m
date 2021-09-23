//
//  HJBLEUpgradeVC.m
//  fat
//
//  Created by ydd on 2021/5/21.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import "HJBLEUpgradeVC.h"
#import "HJUpgradeView.h"
#import "HJUpgradeTipsView.h"
#import "HJUpgradeProgressView.h"
@interface HJBLEUpgradeVC ()

@property (strong,nonatomic)HJUpgradeView * upgradeView;

@property (strong,nonatomic)HJUpgradeProgressView * progressView;

@property (strong,nonatomic)UIView * bottomView;
@property (strong,nonatomic)UIButton * upgradeBtn;

@property (strong,nonatomic)HJUpgradeTipsView * tipsView;


@property (assign,nonatomic)BOOL isUpdating;  //是否正在升级

@property (assign,nonatomic)NSInteger progress_old;

@end

@implementation HJBLEUpgradeVC

/*
 侧滑取消
 */

-(void)popGestureChange:(UIViewController *)vc enable:(BOOL)enable{

    if ([vc.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        //遍历所有的手势
        for (UIGestureRecognizer *popGesture in vc.navigationController.interactivePopGestureRecognizer.view.gestureRecognizers) {
            popGesture.enabled = enable;
        }
    }
}
 
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self popGestureChange:self enable:NO];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self popGestureChange:self enable:YES];
    [HJCommon shareInstance].isUpgrade = NO;
}
 

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title =self.isBLEUpdate?KKLanguage(@"lab_BLE_deviceInfo_upgrade_text16"):KKLanguage(@"lab_BLE_deviceInfo_text9");
    
    [self initData];
    
    [self initUI];
    
    [self refreshUI];
}

- (void)initData{
    
    //设置蓝牙深度通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(BLEStatus)
                                                 name:KKBLEStatus_disConnect
                                               object:nil];
}

- (void)initUI{
    
    [self addLeftBtnWithImage:LeftBtnWhite];
    
    [self.view addSubview:self.upgradeView];
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.progressView];
    [self.view addSubview:self.tipsView];
    
}

- (HJUpgradeView *)upgradeView{
    
    if (!_upgradeView) {
        _upgradeView = [[HJUpgradeView alloc] initWithFrame:CGRectMake(0, KKNavBarHeight, KKSceneWidth, KKButtonHeight*4)];
    }
    return _upgradeView;
}

- (HJUpgradeProgressView *)progressView{
    if (!_progressView) {
        _progressView = [[HJUpgradeProgressView alloc] initWithFrame:CGRectMake(0, KKNavBarHeight, KKSceneWidth, KKButtonHeight*4)];
    }
    return _progressView;
}

- (UIView *)bottomView{
    
    if (!_bottomView) {
        
        UIView * view = [[UIView alloc] init];
        view.frame = CGRectMake(0, KKSceneHeight - 2*KKButtonHeight - KKButtomSpace, KKSceneWidth, KKButtonHeight*2);
        
        _bottomView = view;
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(kk_x(20), 0, KKSceneWidth - 2*kk_x(20), KKButtonHeight);
        [btn setTitle:KKLanguage(@"lab_BLE_deviceInfo_upgrade_text4") forState:UIControlStateNormal];
        [btn setTitleColor:kkWhiteColor forState:UIControlStateNormal];
        btn.backgroundColor = KKBgYellowColor;
        btn.titleLabel.font = kk_sizefont(KKFont_Normal);
        btn.tag = KKButton_upgrade;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        
        
        UILabel * titleLab = [[UILabel alloc] init];
        titleLab.frame = CGRectMake(kk_x(20), btn.frame.size.height, btn.frame.size.width, KKButtonHeight);
        titleLab.text = KKLanguage(@"lab_BLE_deviceInfo_upgrade_text5");
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.font = kk_sizefont(KKFont_small_12);
        titleLab.textColor = kkTextBlackColor;
        [view addSubview:titleLab];
       
    }
    
    return _bottomView;
}
- (HJUpgradeTipsView *)tipsView{
    
    if (!_tipsView) {
        
        _tipsView = [[HJUpgradeTipsView alloc] initWithFrame: CGRectMake(0, KKNavBarHeight, KKSceneWidth, KKSceneHeight-KKNavBarHeight)];
    }
    
    [_tipsView.cancelBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
   
    
    return _tipsView;
}

- (void)refreshUI{

    self.tipsView.hidden = YES;
    self.progressView.hidden = YES;
    
    NSString * newVersion = self.firmwareInfoModel.versionName;
    NSString * version = [HJCommon shareInstance].BLEInfoModel.FirewareVersion;
    
    NSString * creatDate = [HJCommon shareInstance].BLEInfoModel.creatDate;
    
    if (self.isBLEUpdate) {
        
        version = [HJCommon shareInstance].BLEInfoModel.BLEVersion;
        creatDate = self.firmwareInfoModel.formatCreateTime;
    }
    
    if ([version hasPrefix:@"V"] == NO) {
        version = [NSString stringWithFormat:@"V%@",version];
    }
    
    
    if ([version compare:newVersion] == NSOrderedAscending) {
        
        _upgradeView.titleLab.text =self.isBLEUpdate?KKLanguage(@"lab_BLE_deviceInfo_upgrade_text17"):KKLanguage(@"lab_BLE_deviceInfo_upgrade_text11");
        _upgradeView.currectLab.text =[NSString stringWithFormat:@"%@:%@(%@)",self.isBLEUpdate?KKLanguage(@"lab_BLE_deviceInfo_upgrade_text18"):KKLanguage(@"lab_BLE_deviceInfo_upgrade_text1"),version,creatDate];
        
        NSString *versionName = _firmwareInfoModel.versionName;
        _upgradeView.freshLab.text =[NSString stringWithFormat:@"%@:%@",self.isBLEUpdate?KKLanguage(@"lab_BLE_deviceInfo_upgrade_text19"):KKLanguage(@"lab_BLE_deviceInfo_upgrade_text2"),versionName];
        
        _upgradeView.logLab.text =[NSString stringWithFormat:@"%@:%@",KKLanguage(@"lab_BLE_deviceInfo_upgrade_text3"),_firmwareInfoModel.log];
        
    }else{
        
        _upgradeView.titleLab.text = KKLanguage(@"lab_BLE_deviceInfo_upgrade_text10");
        _upgradeView.currectLab.text =[NSString stringWithFormat:@"%@:%@",self.isBLEUpdate?KKLanguage(@"lab_BLE_deviceInfo_upgrade_text18"):KKLanguage(@"lab_BLE_deviceInfo_upgrade_text1"),version];
        
        self.bottomView.hidden = YES;
        
    }

}

- (void)refreshUpgredeResult:(BOOL)isSuccess{
    
    self.tipsView.hidden = NO;
    self.upgradeView.hidden = self.bottomView.hidden = self.progressView.hidden = YES;
    
    self.isUpdating = NO;
    
    if (isSuccess) {
        
        self.tipsView.imageView.image  = [UIImage imageNamed:@"img_BLE_upgrade_success"];
        self.tipsView.resultLab.text = KKLanguage(@"lab_BLE_deviceInfo_upgrade_text9");
        
        if (self.isBLEUpdate) {
            self.tipsView.detailLab.text = KKLanguage(@"lab_BLE_deviceInfo_upgrade_text13_1");
        }else{
            self.tipsView.detailLab.text = KKLanguage(@"lab_BLE_deviceInfo_upgrade_text13");
        }
        

    }else{
        
        self.tipsView.imageView.image  = [UIImage imageNamed:@"img_BLE_upgrade_fail"];
        self.tipsView.resultLab.text = KKLanguage(@"lab_BLE_deviceInfo_upgrade_text12");
        self.tipsView.detailLab.text = KKLanguage(@"lab_BLE_deviceInfo_upgrade_text15");

    }
}
#pragma mark ============== 通知 ===============
- (void)BLEStatus{
    
    if (self.isBLEUpdate) {
        /*
         如果是蓝牙升级,出现的断开操作,直接pass 这是正常的断开,不处理
         */
        return;
    }
    
    [self refreshUpgredeResult:NO];
    [self hideLoading];
}

- (void)leftBack{
    
    if (self.isUpdating) {
        [self showToastInView:self.view time:KKToastTime title:KKLanguage(@"lab_BLE_deviceInfo_upgrading")];
        return;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)btnClick:(UIButton*)sender{
    
    NSString * sha1;
    
    switch (sender.tag) {
            
        case KKButton_upgrade:
            
            if ([HJCommon shareInstance].BLEInfoModel.isConnect == NO) {
                [self showToastInWindows:KKToastTime title:KKLanguage(@"lab_main_deviceDetail_text3")];
                return;
            }
            
            /*
             1.文件校验
             */
            
            self.upgradeView.hidden = self.bottomView.hidden = YES;
            self.progressView.hidden = NO;
            [self.view bringSubviewToFront:self.progressView];
            
            self.progressView.titleLab.text = KKLanguage(@"lab_BLE_deviceInfo_upgrade_text6");
            
            sha1 =  [[HJCommon shareInstance] sha1OfPath:self.firmwareInfoModel.localPath];
            
            if ([sha1 isEqualToString:self.firmwareInfoModel.hashCode]) {
                
                self.isUpdating = YES;
                
                [HJCommon shareInstance].isUpgrade = YES;
                
                if (self.isBLEUpdate) {
                    /*
                     蓝牙升级
                     */
                    [self BLEUpdgrade];
                
                }else{
                    
                    /*
                     超声升级
                     */
                    [self BLEUltrasoundUpdgrade];
                    
                    
                }
                
                
                
            }else{
                
                [self showToastInView:self.view time:KKToastTime title:KKLanguage(@"lab_BLE_deviceInfo_upgrade_text12")];
                
            }
            
            break;
            
        case KKButton_Cancel:
            
            [self.navigationController popViewControllerAnimated:YES];
            
            break;
            
        default:
            break;
    }
    
}

#pragma mark ============== 超声升级 ===============
- (void)BLEUltrasoundUpdgrade{
    
    [[HJBLEManage sharedCentral] BLEUltrasoundUpdgrade:self.firmwareInfoModel.localPath progress:^(float progress, BOOL isSucceeded, id  _Nullable response, NSError * _Nullable error) {
        
        
        self.progressView.slider.value = progress*100;
        
        self.progressView.titleLab.text =[NSString stringWithFormat:@"%@(%.0f%%)",KKLanguage(@"lab_BLE_deviceInfo_upgrade_text8"),progress*100] ;
        
        /*
         升级进度回调
         */
        NSLog(@"超声升级进度回调:%f",progress);
        
    } callback:^(NSInteger KKBLEActionStatus, BOOL isSucceeded, id  _Nullable response, NSError * _Nullable error) {
        
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            
            /*
             升级完成回调
             */
            
            NSLog(@"升级完成回调:%d",isSucceeded);
            [self refreshUpgredeResult:isSucceeded];
            
            if(self.updateResult){
                self.updateResult(YES);
            }
            
            /*
             如果设置成功,需要重新设置下
             */
            if (isSucceeded) {
            
                [[NSNotificationCenter defaultCenter] postNotificationName:KKPeripheralSetting object:nil];
            }
            
        });
    }];
}

#pragma mark ============== 蓝牙升级 ===============
- (void)BLEUpdgrade{
    
    self.progress_old = 0;

    dispatch_queue_t mianqueue = dispatch_get_main_queue();
    
    NSData * resourcedata=[NSData dataWithContentsOfURL:[NSURL URLWithString:self.firmwareInfoModel.localPath]];
    
    
    DFUServiceInitiator * initiator = [[DFUServiceInitiator alloc] initWithQueue:mianqueue delegateQueue:mianqueue progressQueue:mianqueue loggerQueue:mianqueue];
    
    self.selectedFirmware = [[DFUFirmware alloc] initWithZipFile:resourcedata];
    
    initiator = [initiator withFirmware:self.selectedFirmware];
    
    initiator.logger = self;
    initiator.delegate = self;
    initiator.progressDelegate = self;
    initiator.enableUnsafeExperimentalButtonlessServiceInSecureDfu = YES;
    initiator.alternativeAdvertisingNameEnabled = NO;
    self.dfuController = [initiator startWithTarget:[HJBLEManage sharedCentral].peripheral];
    
    

}

- (void)dfuError:(enum DFUError)error didOccurWithMessage:(NSString *)message{
    
    if (error) {
        [self refreshUpgredeResult:NO];
    }
    
    DLog(@"dfuError:%@ %ld",message,(long)error);
}

- (void)dfuProgressDidChangeFor:(NSInteger)part outOf:(NSInteger)totalParts to:(NSInteger)progress currentSpeedBytesPerSecond:(double)currentSpeedBytesPerSecond avgSpeedBytesPerSecond:(double)avgSpeedBytesPerSecond{
    
    
    if (progress<self.progress_old) {
        return;
    }
    self.progress_old = progress;
    
   self.progressView.titleLab.text =[NSString stringWithFormat:@"%@(%ld%%)",KKLanguage(@"lab_BLE_deviceInfo_upgrade_text8"),(long)progress] ;
    
   self.progressView.slider.value = progress;
    
}

- (void)dfuStateDidChangeTo:(enum DFUState)state{
    
    if (state == DFUStateCompleted) {
        
        [self refreshUpgredeResult:YES];
        
        if(self.updateResult){
            self.updateResult(YES);
        }

    }else if (state == DFUStateAborted){
        
        [self refreshUpgredeResult:NO];
    }
    
    DLog(@"dfuStateDidChangeTo:%ld",(long)state);

}

- (void)logWith:(enum LogLevel)level message:(NSString *)message{
    
    //DLog(@"logWith:%@",message);
}


@end
