//
//  HJDeviceInfoVC.m
//  fat
//
//  Created by 何军 on 2021/4/14.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import "HJDeviceInfoVC.h"

@interface HJDeviceInfoVC ()<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource>

@property (strong,nonatomic)UITableView * tableView;

@property (assign,nonatomic)int depthIndex;

@property (strong,nonatomic)HJFirmwareInfoModel * firmwareInfoModel;
@property (strong,nonatomic)HJFirmwareInfoModel * BLEfirmwareInfoModel;


@end

@implementation HJDeviceInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = KKLanguage(@"lab_device_info_title");
    
    [self initData];
    
    [self.view addSubview:self.tableView];
}

- (void)initData{
    
    KKBLEDepth depth = [[HJCommon shareInstance] getBLEDepth];
    
    if (depth == KKBLEDepth_level_5 ||
        depth == KKBLEDepth_level_2) {
        _depthIndex = 0;
    }else{
        
        _depthIndex = 1;
    }

    
    NSArray * arrOne = [NSArray arrayWithObjects:
                        KKLanguage(@"lab_BLE_deviceInfo_text1"),
                        KKLanguage(@"lab_BLE_deviceInfo_text2"),
                        KKLanguage(@"lab_BLE_deviceInfo_text3"),
                        KKLanguage(@"lab_BLE_deviceInfo_text6"),
                        KKLanguage(@"lab_BLE_deviceInfo_text7"),
                        KKLanguage(@"lab_BLE_deviceInfo_text8"),
                        nil];
    
    
    NSArray * arrTwo = [NSArray arrayWithObjects:
                        KKLanguage(@"lab_BLE_deviceInfo_text5"),
                        nil];
    
    self.dataArr = [NSArray arrayWithObjects:arrOne,arrTwo, nil];
    
    /*
     获取超声固件信息
     */
    [self getFirewareInfo];
    
    
    /*
     获取蓝牙固件信息
     */
    [self getBLEFirewareInfo];
    
}

- (UITableView*)tableView{
    
    if (!_tableView) {
        
        UITableView * tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, KKNavBarHeight, KKSceneWidth, KKSceneHeight-KKNavBarHeight) style:UITableViewStylePlain];
        tableview.backgroundColor = self.view.backgroundColor;
        tableview.delegate =self;
        tableview.dataSource = self;
        tableview.showsVerticalScrollIndicator = NO;
        tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableview.rowHeight = KKButtonHeight*1.5;
        
        if (@available(iOS 11.0, *)) {
            tableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        UIView * view = [[UIView alloc] init];
        view.frame = CGRectMake(0,0,KKSceneWidth,kk_y(250));
        
        UIImage * image =[UIImage imageNamed:@"img_device_info_l"];
        
        UIImageView * imageview = [[UIImageView alloc] init];
        imageview.frame = CGRectMake(KKSceneWidth/2-image.size.width/2, view.frame.size.height/2 - image.size.height/2, image.size.width, image.size.height);
        imageview.image = image;
        [view addSubview:imageview];
        
        
        tableview.tableHeaderView = view;
        
        _tableView = tableview;
    }
    
    return _tableView;
}
- (HJMaskView *)maskView{
    
    SW(sw);
    if (!_maskView) {
        
        _maskView=[HJMaskView makeViewWithMask:self.view.frame];
        _maskView.resultblock = ^{
            
            sw.maskView = nil;
            [sw hideMaskViewSubview:sw.depthView];

        };
    }
    return _maskView;
}

- (HJUserInfoView *)depthView{
    
    SW(sw);
    
    if (!_depthView) {
        
        HJUserInfoView *view = [[HJUserInfoView alloc] initWithFrame:CGRectMake(0, KKSceneHeight, KKSceneWidth, kk_y(500)) withType:KKViewType_Userinfo_sex_height_weight];
        _depthView = view;
    }
    
    _depthView.titleLab.text = KKLanguage(@"lab_BLE_deviceInfo_text5");
    _depthView.pickerView.dataSource = self;
    _depthView.pickerView.delegate = self;
    
    [_depthView.pickerView selectRow:_depthIndex inComponent:0 animated:NO];
    
    _depthView.selectBlock = ^(UIButton * _Nonnull sender) {
        
        [sw hideMaskViewSubview:sw.depthView];
        
        if (sender.tag == KKButton_Cancel) {
            
        }else if (sender.tag == KKButton_Confirm){
            
            NSInteger depth;
            
            if(sw.depthIndex==0){
                
                if (pxHeight == KKBLEPxHeight_256) {
                    
                    depth = KKBLEDepth_level_5;
                    
                }else{
                    
                    depth = KKBLEDepth_level_2;
                }
                
            }else{
                
                if (pxHeight == KKBLEPxHeight_256) {
                    
                    depth = KKBLEDepth_level_7;
                    
                }else{
                    
                    depth = KKBLEDepth_level_3;
                }
                
            }
        
            
            [[HJCommon shareInstance] saveBLEDepth:depth];
            
            NSIndexSet *indexSet1 = [[NSIndexSet alloc] initWithIndex:1];
            
            [sw.tableView reloadSections:indexSet1 withRowAnimation:UITableViewRowAnimationNone];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:KKBLEParameter_Depth object:@{@"depth":@(depth)}];
        }
    };

    return _depthView;
}
#pragma mark ============== 方法 ===============
- (void)getFirewareInfo{
    SW(sw);

    NSArray * modeNameArr = [[HJCommon shareInstance].BLEInfoModel.BLEModeName componentsSeparatedByString:@"-"];
  
    if (modeNameArr.count == 0) {
        return;
    }
    
    [self showLoadingInView:self.view time:KKTimeOut title:KKLanguage(@"lab_common_loading")];
    
    HJFirmwareHttpModel * model = [HJFirmwareHttpModel new];
    model.firmwareMode = [modeNameArr firstObject];
    model.firmwareName = [modeNameArr lastObject];
    
    NSDictionary * dic = [model toDictionary];
    
    
    [KKHttpRequest HttpRequestType:k_POST withrequestType:NO withDataString:dic withUrl:KK_URL_get_firmwareinfo withSuccess:^(id result, NSDictionary *resultDic, HJHTTPModel *model) {
        
        [sw hideLoading];
        
        if (model.errorcode == KKStatus_success) {
            
            //解析数据,存储数据库
            NSString * jsonStr = [HJAESUtil aesDecrypt:model.data];
            DLog(@"jsonStr:%@",jsonStr);
            
            sw.firmwareInfoModel = [[HJFirmwareInfoModel alloc] initWithString:jsonStr error:nil];
            
            [self fileDownload:sw.firmwareInfoModel];
            
            [sw refreshUI];
            
        }else{
            
            [sw showToastInView:sw.view time:KKToastTime title:model.errormessage];
        }
        
    } withError:^(id result, NSDictionary *resultDic, HJHTTPModel *model) {
        
        [self showToastInView:self.view time:KKToastTime title:KKLanguage(@"tips_fail")];
    }];
    
}

- (void)getBLEFirewareInfo{
    SW(sw);

    NSArray * modeNameArr = [[HJCommon shareInstance].BLEInfoModel.BLEModeName componentsSeparatedByString:@"-"];
  
    if (modeNameArr.count == 0) {
        return;
    }
    
    HJFirmwareHttpModel * model = [HJFirmwareHttpModel new];
    model.firmwareMode = [modeNameArr firstObject];
    model.firmwareName =[NSString stringWithFormat:@"%@-ble",[modeNameArr lastObject]];;
    
    NSDictionary * dic = [model toDictionary];
    
    
    [KKHttpRequest HttpRequestType:k_POST withrequestType:NO withDataString:dic withUrl:KK_URL_get_firmwareinfo withSuccess:^(id result, NSDictionary *resultDic, HJHTTPModel *model) {
        
        [sw hideLoading];
        
        if (model.errorcode == KKStatus_success) {
            
            //解析数据,存储数据库
            NSString * jsonStr = [HJAESUtil aesDecrypt:model.data];
            DLog(@"jsonStr:%@",jsonStr);
            
            sw.BLEfirmwareInfoModel = [[HJFirmwareInfoModel alloc] initWithString:jsonStr error:nil];
            
            [self fileDownload:sw.BLEfirmwareInfoModel];
            
            [sw refreshUI];
            
        }else{
            
            [sw showToastInView:sw.view time:KKToastTime title:model.errormessage];
        }
        
    } withError:^(id result, NSDictionary *resultDic, HJHTTPModel *model) {
        [self showToastInView:self.view time:KKToastTime title:KKLanguage(@"tips_fail")];
        
    }];
    
}

#pragma mark ============== 刷新视图 ===============
- (void)refreshUI{
    
    NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:2 inSection:0];
    NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:4 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath1,indexPath2] withRowAnimation:UITableViewRowAnimationNone];
    
}
     
#pragma mark ============== 文件下载 ===============
- (void)fileDownload:(HJFirmwareInfoModel*)model{
    
    
    SW(sw);
    
    [KKHttpRequest fileDownUrl:model.url withSuccess:^(NSURL *filePath) {
        
        NSLog(@"filePath:%@",filePath);
        
        if (model == sw.firmwareInfoModel) {
            
            sw.firmwareInfoModel.localPath = [filePath absoluteString];
            
        }else{
            
            sw.BLEfirmwareInfoModel.localPath = [filePath absoluteString];
        }
        
    }];
}


#pragma mark ============== 隐藏视图 ===============
- (void)hideMaskViewSubview:(UIView*)view{
    
    self.maskView.hidden = view.hidden = YES;
    view.frame =CGRectMake(view.frame.origin.x, KKSceneHeight, view.frame.size.width, view.frame.size.height);
    
}

- (void)showMaskViewSubview:(UIView*)view{
    
    [self.maskView addSubview:view];
    self.maskView.hidden = view.hidden = NO;
    
    [UIView animateWithDuration:0.2 animations:^{
        view.frame = CGRectMake(view.frame.origin.x, KKSceneHeight - view.frame.size.height, view.frame.size.width, view.frame.size.height);
    }];
    
}
#pragma mark ============== pickerviewdelegate ===============
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 2;
}
//返回指定列，行的高度，就是自定义行的高度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    
    return KKButtonHeight;
    
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view API_UNAVAILABLE(tvos){
    
    UILabel * lab =[[UILabel alloc] init];;
    lab.textAlignment = NSTextAlignmentCenter;
    lab.adjustsFontSizeToFitWidth=YES;
    
    NSString * string;

    if (row == 0) {
        
        KKBLEDepth depth;
        
        if (pxHeight == KKBLEPxHeight_256) {
            depth = KKBLEDepth_level_5;
        }else{
            depth = KKBLEDepth_level_2;
        }
        
        int depth_mm =  [[HJCommon shareInstance] getBLEDepth_cm_new:depth bitmapHight:pxHeight withOcxo:OCXO];
   
        string =[NSString stringWithFormat:@"%@ %@",[[HJCommon shareInstance] getCurrectUnitValue:1.0*depth_mm/10],[[HJCommon shareInstance] getBLEUnit]];
        
    }else if(row == 1){
        
        KKBLEDepth depth;
        
        if (pxHeight == KKBLEPxHeight_256) {
            depth = KKBLEDepth_level_7;
        }else{
            depth = KKBLEDepth_level_3;
        }
        
        int depth_mm =  [[HJCommon shareInstance] getBLEDepth_cm_new:depth bitmapHight:pxHeight withOcxo:OCXO];
   
        string =[NSString stringWithFormat:@"%@ %@",[[HJCommon shareInstance] getCurrectUnitValue:1.0*depth_mm/10],[[HJCommon shareInstance] getBLEUnit]];
    }
    
    lab.text = string;
    
    return lab;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.depthIndex = (int)row;
}

#pragma mark ============== tableviewDelegate ===============
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray * arr = self.dataArr[section];
    
    return arr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return KKButtonHeight/2;
    }
    return CGFLOAT_MIN;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc] init];
    float height = section == 1?KKButtonHeight/2:CGFLOAT_MIN;
    view.frame = CGRectMake(0, 0, KKSceneWidth, height);
    
    if (section == 1) {
        
        UILabel * titleLab = [[UILabel alloc] init];
        titleLab.frame = CGRectMake(kk_x(20), 0, view.frame.size.width-2*kk_x(20), view.frame.size.height);
        titleLab.text = KKLanguage(@"lab_BLE_deviceInfo_text4");
        titleLab.font = kk_sizefont(KKFont_small_12);
        titleLab.textColor = kkTextGrayColor;
        [view addSubview:titleLab];
        
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = kkBgGrayColor;
        lineView.frame = CGRectMake(kk_x(20),  view.frame.size.height - kk_y(1), titleLab.frame.size.width, kk_y(1));
        [view addSubview:lineView];
        
    }

    return view;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    // 定义cell标识  每个cell对应一个自己的标识
    NSString *CellIdentifier = [NSString stringWithFormat:@"cell%ld%ld",(long)indexPath.section,(long)indexPath.row];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        //底线
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = kkBgGrayColor;
        lineView.frame = CGRectMake(kk_x(20), KKButtonHeight*1.5 - kk_y(1), KKSceneWidth - 2 * kk_x(20), kk_y(1));
        lineView.tag = 10;
        [cell.contentView addSubview:lineView];
        
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray * arr = self.dataArr[indexPath.section];

    cell.textLabel.text = arr[indexPath.row];
    cell.textLabel.font = kk_sizefont(KKFont_Normal);
    
    cell.detailTextLabel.numberOfLines = 0;
    cell.detailTextLabel.textColor = kkTextGrayColor;
    
    if ([cell.textLabel.text isEqualToString:KKLanguage(@"lab_BLE_deviceInfo_text5")]) {
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        NSInteger depth = [[HJCommon shareInstance] getBLEDepth];
        float depth_mm = [[HJCommon shareInstance] getBLEDepth_cm_new:depth bitmapHight:pxHeight withOcxo:OCXO];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@",[[HJCommon shareInstance] getCurrectUnitValue:depth_mm/10*1.0],[[HJCommon shareInstance] getBLEUnit]];
        
    }else if([cell.textLabel.text isEqualToString:KKLanguage(@"lab_BLE_deviceInfo_text1")]){
        cell.detailTextLabel.text = KKLanguage(@"lab_BLE_deviceInfo_name");
    }else if([cell.textLabel.text isEqualToString:KKLanguage(@"lab_BLE_deviceInfo_text2")]){
       
        
        NSArray * modeNameArr = [[HJCommon shareInstance].BLEInfoModel.BLEModeName componentsSeparatedByString:@"-"];
      
        if (modeNameArr.count == 0) {
            return;
        }
 
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Z2-E%@",[modeNameArr lastObject]];
        
    }else if([cell.textLabel.text isEqualToString:KKLanguage(@"lab_BLE_deviceInfo_text3")]){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        NSString * newVersion = self.firmwareInfoModel.versionName;
        NSString * version = [HJCommon shareInstance].BLEInfoModel.FirewareVersion;
        
        if (version == nil) {
            return;
        }
        
        if ([version hasPrefix:@"V"] == NO) {
            version = [NSString stringWithFormat:@"V%@",version];
        }
        
        if ([version compare:newVersion] == NSOrderedAscending) {
            
            NSString * string = [NSString stringWithFormat:@"_%@_",KKLanguage(@"lab_BLE_deviceInfo_new")];
            
            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:string];
            
            [attrStr setAttributes:@{NSForegroundColorAttributeName :kkBgRedColor} range:NSMakeRange(0, 1)];
            [attrStr setAttributes:@{NSForegroundColorAttributeName :kkWhiteColor} range:NSMakeRange(1, attrStr.length-2)];
            [attrStr setAttributes:@{NSForegroundColorAttributeName :kkBgRedColor} range:NSMakeRange(attrStr.length-1, 1)];
            
            cell.detailTextLabel.attributedText = attrStr;
            
            cell.detailTextLabel.layer.backgroundColor = kkBgRedColor.CGColor;
            cell.detailTextLabel.layer.cornerRadius = 10;
            cell.detailTextLabel.layer.masksToBounds = YES;
            cell.detailTextLabel.textAlignment = NSTextAlignmentCenter;
            
            
        }else{
            
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",version];
            
        }
        
    }else if([cell.textLabel.text isEqualToString:KKLanguage(@"lab_BLE_deviceInfo_text6")]){
        
        NSString * name = [HJCommon shareInstance].BLEInfoModel.PeripheralName;
        
        if (name) {
            
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",name];
        }
        
    }else if([cell.textLabel.text isEqualToString:KKLanguage(@"lab_BLE_deviceInfo_text7")]){
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        NSString * newVersion = self.BLEfirmwareInfoModel.versionName;
        NSString * version = [HJCommon shareInstance].BLEInfoModel.BLEVersion;
        
        if (version == nil) {
            return;
        }
        
        if ([version hasPrefix:@"V"] == NO) {
            version = [NSString stringWithFormat:@"V%@",version];
        }
        
        if ([version compare:newVersion] == NSOrderedAscending) {
            
            NSString * string = [NSString stringWithFormat:@"_%@_",KKLanguage(@"lab_BLE_deviceInfo_new")];
            
            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:string];
            
            [attrStr setAttributes:@{NSForegroundColorAttributeName :kkBgRedColor} range:NSMakeRange(0, 1)];
            [attrStr setAttributes:@{NSForegroundColorAttributeName :kkWhiteColor} range:NSMakeRange(1, attrStr.length-2)];
            [attrStr setAttributes:@{NSForegroundColorAttributeName :kkBgRedColor} range:NSMakeRange(attrStr.length-1, 1)];
            
            cell.detailTextLabel.attributedText = attrStr;
            
            cell.detailTextLabel.layer.backgroundColor = kkBgRedColor.CGColor;
            cell.detailTextLabel.layer.cornerRadius = 10;
            cell.detailTextLabel.layer.masksToBounds = YES;
            cell.detailTextLabel.textAlignment = NSTextAlignmentCenter;
            
            
        }else{
            
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",version];
            
        }
        
    }else if([cell.textLabel.text isEqualToString:KKLanguage(@"lab_BLE_deviceInfo_text8")]){
        
        NSString * PeripheralMac = [HJCommon shareInstance].BLEInfoModel.PeripheralMac;
        
        if (PeripheralMac) {
            
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",PeripheralMac];
        }
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell.textLabel.text isEqualToString:KKLanguage(@"lab_BLE_deviceInfo_text5")]) {
    
        [self showMaskViewSubview:self.depthView];
        
    }else if([cell.textLabel.text isEqualToString:KKLanguage(@"lab_BLE_deviceInfo_text3")]) {
        
        
        HJBLEUpgradeVC * vc = [[HJBLEUpgradeVC alloc] init];
        
        vc.firmwareInfoModel = self.firmwareInfoModel;
      
        [self.navigationController pushViewController:vc animated:YES];
        
        vc.updateResult = ^(BOOL isSucceeded) {
            
            if (isSucceeded) {
                
                [HJCommon shareInstance].BLEInfoModel.FirewareVersion = self.firmwareInfoModel.versionName;
                NSString * version = [HJCommon shareInstance].BLEInfoModel.FirewareVersion;
                
                if ([version hasPrefix:@"V"] == NO) {
                    version = [NSString stringWithFormat:@"V%@",version];
                }
                
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",version];
                cell.detailTextLabel.layer.backgroundColor = [UIColor clearColor].CGColor;
                
            }
            
        };
        
    }else if([cell.textLabel.text isEqualToString:KKLanguage(@"lab_BLE_deviceInfo_text7")]) {
        
        HJBLEUpgradeVC * vc = [[HJBLEUpgradeVC alloc] init];
        vc.firmwareInfoModel = self.BLEfirmwareInfoModel;
        vc.isBLEUpdate = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
        vc.updateResult = ^(BOOL isSucceeded) {
            
            if (isSucceeded) {
                
                [HJCommon shareInstance].BLEInfoModel.BLEVersion = self.BLEfirmwareInfoModel.versionName;
                NSString * version = [HJCommon shareInstance].BLEInfoModel.BLEVersion;
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",version];
                cell.detailTextLabel.layer.backgroundColor = [UIColor clearColor].CGColor;
                
            }
        };
        
    }
    
}

@end
