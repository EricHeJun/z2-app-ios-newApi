//
//  HJHistoryChatVC.m
//  fat
//
//  Created by ydd on 2021/5/7.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import "HJHistoryChatVC.h"

@interface HJHistoryChatVC ()<UITableViewDelegate,UITableViewDataSource>{
    NSInteger _selPageIx;
    NSInteger _selPageSize;
    
    NSInteger _selFunctionIndex;
}

@property (strong,nonatomic)UITableView * tableView;
@property (strong,nonatomic)UIView * headView;

@property (strong,nonatomic)NSMutableArray * localHistoryArr;

@end

@implementation HJHistoryChatVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = KKLanguage(@"lab_chat_history_chat");
    
    [self initUI];
    [self initData];
    
}
- (void)initUI{
    
    [self addRightBtnOneWithImage:RightBtnMore];
    [self.view addSubview:self.tableView];
}

- (void)initData{
    
    _selPageIx = 1;
    _selPageSize = 15;
    _selFunctionIndex = 0;
    
    _localHistoryArr = [NSMutableArray array];
    self.mutableDataArr = [NSMutableArray array];
    
    
    /*
     查询本地数据
     */
    [self queryLocalHistoryData:_selFunctionIndex];
    
    /*
     查询网络数据
     */
    [self getHistoryData:_selFunctionIndex isRefresh:YES];

}
#pragma mark ============== 方法 ===============
- (void)queryLocalHistoryData:(KKTest_Function)function{
    
    NSString * familiId = [HJCommon shareInstance].selectModel.id;
    
    if ([familiId isEqualToString:KKAccount_TestId]) {
        familiId =  [HJCommon shareInstance].userInfoModel.id;
    }
    
    _localHistoryArr = [HJFMDBModel queryCurrectChatInfoWithUserID:[HJCommon shareInstance].userInfoModel.userId
                                                          familyId:familiId
                                                        recordDate:@""
                                                      bodyPosition:[NSString stringWithFormat:@"%ld",(long)self.position]
                                                        recordType:[NSString stringWithFormat:@"%ld",(long)function]
                                                            upload:@"0"];
    
    
    
}
/// 获取历史记录
/// @param function 功能位置
/// @param refresh 是否刷新
- (void)getHistoryData:(KKTest_Function)function isRefresh:(BOOL)refresh{
    
    SW(sw);
    NSInteger pageNum = 1;
    if (refresh) {
        pageNum = 1;
    }else{
        pageNum = _selPageIx+1;
    }
    
    [self showLoadingInView:self.view time:KKTimeOut title:KKLanguage(@"lab_common_loading")];
    
    HJFatRecordHttpModel * model = [[HJFatRecordHttpModel alloc] init];
    
    model.userId = [HJCommon shareInstance].userInfoModel.userId;
   
    if (function) {
        model.recordType= [NSString stringWithFormat:@"%ld",(long)function];
    }
    model.bodyPosition =[NSString stringWithFormat:@"%ld",(long)self.position];
    
    model.curPage = [NSString stringWithFormat:@"%ld",(long)pageNum];
    model.pageSize = [NSString stringWithFormat:@"%ld",(long)_selPageSize];
    
    NSString * familiId = [HJCommon shareInstance].selectModel.id;
    
    if ([familiId isEqualToString:KKAccount_TestId]) {
        familiId =  [HJCommon shareInstance].userInfoModel.id;
    }
    
    model.familyId = familiId;
    
    if (self.recordDate) {
        model.recordDate = self.recordDate;
    }
    
    NSDictionary * dic =[model toDictionary];
    
    [KKHttpRequest HttpRequestType:k_POST withrequestType:NO withDataString:dic withUrl:KK_URL_query_fat_record withSuccess:^(id result, NSDictionary *resultDic, HJHTTPModel *model) {
        
        [self hideLoading];
        [sw.tableView.mj_header endRefreshing];
        [sw.tableView.mj_footer endRefreshing];
        
        
        if (refresh) {
            [self.mutableDataArr removeAllObjects];
        }
        
        
        NSArray * arrNet;
        
        if (model.errorcode == KKStatus_success ) {
            
            //解析数据,存储数据库
            NSString * jsonStr = [HJAESUtil aesDecrypt:model.data];
            DLog(@"jsonStr:%@",jsonStr);
            
            arrNet = [HJChatInfoModel arrayOfModelsFromString:jsonStr error:nil];
           
            // 处理页数
            if (refresh) {
                
                self->_selPageIx = 1;
                sw.tableView.mj_footer.hidden = NO;
                
            }else{
                self->_selPageIx = self->_selPageIx + 1;
            }
            
        }else if(model.errorcode == -2){
            
            [self showToastInView:self.view time:KKToastTime title:KKLanguage(@"tips_NoData")];
            sw.tableView.mj_footer.hidden = YES;
            
        }else{
            
            [self showToastInView:self.view time:KKToastTime title:model.errormessage];
        }
        
        NSArray * arrAll =  [arrNet arrayByAddingObjectsFromArray:self.localHistoryArr] ;
        
        /*
         数据排序
         */
        //对数组进行从小到大排序
        NSArray * resultArr = [arrAll sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
           
            HJChatInfoModel * model1 = (HJChatInfoModel*)obj1;
            HJChatInfoModel * model2 = (HJChatInfoModel*)obj2;
        
            return [model2.recordDate compare:model1.recordDate];
        }];
        
        
        [self.mutableDataArr addObjectsFromArray:resultArr];
        
        [self.tableView reloadData];
        
    } withError:^(id result, NSDictionary *resultDic, HJHTTPModel *model) {
        
        [sw.tableView.mj_header endRefreshing];
        [sw.tableView.mj_footer endRefreshing];
        [self showToastInView:self.view time:KKToastTime title:KKLanguage(@"tips_fail")];
        
        /*
         数据排序
         */
        //对数组进行从小到大排序
        NSArray * resultArr = [self.localHistoryArr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
           
            HJChatInfoModel * model1 = (HJChatInfoModel*)obj1;
            HJChatInfoModel * model2 = (HJChatInfoModel*)obj2;
        
            return [model2.recordDate compare:model1.recordDate];
        }];
        
        [self.mutableDataArr addObjectsFromArray:resultArr];
        
        [self.tableView reloadData];
    }];
}
- (UITableView *)tableView{
    SW(sw);
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
        tableview.tableHeaderView = self.headView;
        
        //开始时需要隐藏文字， 请求完成后再显示
        tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            //进行数据刷新操作
            [sw getHistoryData:self->_selFunctionIndex isRefresh:YES];
        }];
        
        tableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            //进行数据刷新操作
            [sw getHistoryData:self->_selFunctionIndex isRefresh:NO];
        }];
        
        _tableView = tableview;
    }
    
    return _tableView;
}
- (UIView *)headView{
    
    if (!_headView) {
        
        UIView * view = [[UIView alloc] init];
        view.frame = CGRectMake(0, 0, KKSceneWidth, kk_y(60));
        view.backgroundColor = kkBgGrayColor;
      

        UILabel * timeLab = [[UILabel alloc] init];
        timeLab.frame = CGRectMake(0, 0, KKSceneWidth/3, view.frame.size.height);
        timeLab.textAlignment = NSTextAlignmentCenter;
        timeLab.font = kk_sizefont(KKFont_small_12);
        timeLab.textColor = kkTextBlackColor;
        timeLab.text = KKLanguage(@"lab_chat_history_chat_text1");
        [view addSubview:timeLab];
        
        float width = (KKSceneWidth - timeLab.frame.size.width)/5;
        
        UILabel * positionLab = [[UILabel alloc] init];
        positionLab.frame = CGRectMake(timeLab.frame.size.width+timeLab.frame.origin.x, timeLab.frame.origin.y, width, timeLab.frame.size.height);
        positionLab.textAlignment = NSTextAlignmentCenter;
        positionLab.font = kk_sizefont(KKFont_small_12);
        positionLab.textColor = kkTextBlackColor;
        positionLab.text = KKLanguage(@"lab_main_test_point");
        [view addSubview:positionLab];
        positionLab.tag = 2;
        
        UILabel * functionLab = [[UILabel alloc] init];
        functionLab.frame =CGRectMake(positionLab.frame.size.width+positionLab.frame.origin.x, positionLab.frame.origin.y, positionLab.frame.size.width, positionLab.frame.size.height);
        functionLab.textAlignment = NSTextAlignmentCenter;
        functionLab.font = kk_sizefont(KKFont_small_12);
        functionLab.textColor = kkTextBlackColor;
        functionLab.text = KKLanguage(@"lab_chat_history_chat_text2");
        [view addSubview:functionLab];
        functionLab.tag = 3;
        
        UILabel * recordValueLab = [[UILabel alloc] init];
        recordValueLab.frame = CGRectMake(functionLab.frame.size.width+functionLab.frame.origin.x, positionLab.frame.origin.y, positionLab.frame.size.width+positionLab.frame.size.width*1/3, positionLab.frame.size.height);
        recordValueLab.textAlignment = NSTextAlignmentCenter;
        recordValueLab.font = kk_sizefont(KKFont_small_12);
        recordValueLab.textColor = kkTextBlackColor;
        recordValueLab.text = KKLanguage(@"lab_chat_history_chat_text3");
        [view addSubview:recordValueLab];
        recordValueLab.tag = 4;
        
        UILabel * imageViewLab= [[UILabel alloc] init];
        imageViewLab.frame =CGRectMake(recordValueLab.frame.size.width+recordValueLab.frame.origin.x, 0, positionLab.frame.size.width*2/3, positionLab.frame.size.height);
        [view addSubview:imageViewLab];
        
        
        UILabel * caozuoLab= [[UILabel alloc] init];
        caozuoLab.frame =CGRectMake(imageViewLab.frame.size.width+imageViewLab.frame.origin.x, 0, positionLab.frame.size.width, positionLab.frame.size.height);
        caozuoLab.textAlignment = NSTextAlignmentCenter;
        caozuoLab.font = kk_sizefont(KKFont_small_12);
        caozuoLab.textColor = kkTextBlackColor;
        caozuoLab.text = KKLanguage(@"lab_chat_history_chat_text4");
        [view addSubview:caozuoLab];

        
        _headView = view;
        
    }
    
    return _headView;
}

#pragma mark ============== tableviewdelegate ===============
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mutableDataArr.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 定义cell标识  每个cell对应一个自己的标识
    NSString *CellIdentifier = [NSString stringWithFormat:@"cell%ld%ld",(long)indexPath.section,(long)indexPath.row];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        
        cell.accessoryType = UITableViewCellAccessoryNone;

        UILabel * timeLab = [[UILabel alloc] init];
        timeLab.frame = CGRectMake(0, 0, KKSceneWidth/3, KKButtonHeight*1.5);
        timeLab.textAlignment = NSTextAlignmentCenter;
        timeLab.font = kk_sizefont(KKFont_small_12);
        timeLab.textColor = kkTextBlackColor;
        timeLab.numberOfLines = 1;
        timeLab.adjustsFontSizeToFitWidth = YES;
        [cell.contentView addSubview:timeLab];
        timeLab.tag = 1;
        
        float width = (KKSceneWidth - timeLab.frame.size.width)/5;
        
        UILabel * positionLab = [[UILabel alloc] init];
        positionLab.frame = CGRectMake(timeLab.frame.size.width+timeLab.frame.origin.x, timeLab.frame.origin.y, width, timeLab.frame.size.height);
        positionLab.textAlignment = NSTextAlignmentCenter;
        positionLab.font = kk_sizefont(KKFont_small_12);
        positionLab.textColor = kkTextBlackColor;
        [cell.contentView addSubview:positionLab];
        positionLab.tag = 2;
        
        UILabel * functionLab = [[UILabel alloc] init];
        functionLab.frame =CGRectMake(positionLab.frame.size.width+positionLab.frame.origin.x, positionLab.frame.origin.y, positionLab.frame.size.width, positionLab.frame.size.height);
        functionLab.textAlignment = NSTextAlignmentCenter;
        functionLab.font = kk_sizefont(KKFont_small_12);
        functionLab.textColor = kkTextBlackColor;
        [cell.contentView addSubview:functionLab];
        functionLab.tag = 3;
        
        UILabel * recordValueLab = [[UILabel alloc] init];
        recordValueLab.frame = CGRectMake(functionLab.frame.size.width+functionLab.frame.origin.x, positionLab.frame.origin.y, positionLab.frame.size.width+positionLab.frame.size.width*1/3, positionLab.frame.size.height);
        recordValueLab.textAlignment = NSTextAlignmentCenter;
        recordValueLab.font = kk_sizefont(KKFont_small_12);
        recordValueLab.textColor = kkTextBlackColor;
        recordValueLab.numberOfLines  = 0;
        [cell.contentView addSubview:recordValueLab];
        recordValueLab.tag = 4;
        
        UIImageView * imageView= [[UIImageView alloc] init];
        imageView.frame =CGRectMake(recordValueLab.frame.size.width+recordValueLab.frame.origin.x, kk_y(40), positionLab.frame.size.width*2/3, positionLab.frame.size.height-kk_y(40)*2);
        [cell.contentView addSubview:imageView];
        imageView.tag = 5;
        
        
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(imageView.frame.size.width+imageView.frame.origin.x, 0, positionLab.frame.size.width, positionLab.frame.size.height);
        [cell.contentView addSubview:btn];
        btn.tag = KKButton_upload;
        btn.accessibilityValue = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    HJChatInfoModel * model = self.mutableDataArr[indexPath.row];
    
    UILabel * timeLab = (UILabel*)[cell viewWithTag:1];
    UILabel * positionLab = (UILabel*)[cell viewWithTag:2];
    UILabel * functionLab = (UILabel*)[cell viewWithTag:3];
    UILabel * recordValueLab = (UILabel*)[cell viewWithTag:4];
    
    UIImageView  * imageView = (UIImageView*)[cell viewWithTag:5];
    UIButton * btn = (UIButton*)[cell viewWithTag:KKButton_upload];
    
    objc_setAssociatedObject(btn, "firstObject", model, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];


    timeLab.text = model.recordDate;
    
    positionLab.text = [[HJCommon shareInstance] currectPositionToString:[model.bodyPosition integerValue]];
    functionLab.text = [[HJCommon shareInstance] currectFunctionToString:[model.recordType integerValue]];
    
    
    NSString * unit=[[HJCommon shareInstance] getBLEUnit];
    
    NSString * value =[model.recordValue substringToIndex:model.recordValue.length - KKBLEParameter_mm.length];
    
    
    value = [[HJCommon shareInstance] getCurrectUnitValue:[value floatValue]/10];
    
    recordValueLab.text = [NSString stringWithFormat:@"%@ %@",value,unit];
    
    
    
    if ([model.upload isEqualToString:@"0"]) {
        
        /*
         本地
         */
        btn.hidden = NO;
        [btn setImage:[UIImage imageNamed:@"img_device_upload"] forState:UIControlStateNormal];
        
    }else{
        
        btn.hidden = YES;
        /*
         网络
         */
    }
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:model.httpRecordImage] placeholderImage:[[HJCommon shareInstance] getDocumentImage:model.recordImage]];
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
    HJChatInfoModel * model = self.mutableDataArr[indexPath.row];
    
    HJDetailChatVC * vc = [[HJDetailChatVC alloc] init];
    vc.chatInfoModel = model;
    vc.mutableDataArr = self.mutableDataArr;
    vc.selIndex = indexPath.row;
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self showAlertViewTitle:nil message:KKLanguage(@"lab_chat_delete_tips") dataArr:@[KKLanguage(@"lab_chat_delete")] callback:^(NSInteger index, NSString *titleString) {
        
        if ([titleString isEqualToString:KKLanguage(@"lab_chat_delete")]) {
            
            [self deleteChartInfo:indexPath.row];
        }
    }];
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return KKLanguage(@"lab_chat_delete");
}
#pragma mark ============== 点击事件 ===============
- (void)btnClick:(UIButton*)sender{
    
    if (sender.tag ==KKButton_upload) {
        
        HJChatInfoModel *  model = objc_getAssociatedObject(sender, "firstObject");
        UIImage * image = [[HJCommon shareInstance] getDocumentImage:model.recordImage];
        
        if (image == nil) {
            return;
        }
        
        [[HJOSSUpload aliyunInit] uploadImage:@[image] success:^(BOOL result, NSArray<NSString *> * _Nonnull nameArray) {
            
            if (result) {
                model.recordImage = [nameArray firstObject];
                [self uploadChatInfoData:model btn:sender];
                
            }
        }];
    }
}

- (void)rightBtnOneClick:(UIButton *)sender{
    
    SW(sw);
    
    [self showAlertSheetTitle:nil message:nil dataArr:@[KKLanguage(@"lab_chat_history_chat_more_1"),KKLanguage(@"lab_chat_history_chat_more_2"),KKLanguage(@"lab_chat_history_chat_more_3")] callback:^(NSInteger index, NSString *titleString) {
        
        if ([titleString isEqualToString:KKLanguage(@"lab_chat_history_chat_more_1")]) {
            
            self->_selFunctionIndex = 0;
            
        }else if ([titleString isEqualToString:KKLanguage(@"lab_chat_history_chat_more_2")]) {
            
            self->_selFunctionIndex = KKTest_Function_Fat;
            
        }else if ([titleString isEqualToString:KKLanguage(@"lab_chat_history_chat_more_3")]) {
            
            self->_selFunctionIndex = KKTest_Function_Muscle;
        }
        
        [sw.mutableDataArr removeAllObjects];
        [sw getHistoryData:self->_selFunctionIndex isRefresh:YES];
        
    }];
}
#pragma mark ============== 删除记录 ===============
- (void)deleteChartInfo:(NSInteger)index{
    
    HJChatInfoModel * chatInfomodel = self.mutableDataArr[index];
    
    [self showLoadingInView:self.view time:KKTimeOut title:KKLanguage(@"lab_common_loading")];
    
    HJDeleteChatInfoModel * deleteModel = [HJDeleteChatInfoModel new];
    deleteModel.id = chatInfomodel.id;
    
    NSDictionary * dic = [deleteModel toDictionary];
    
    [KKHttpRequest HttpRequestType:k_POST withrequestType:NO withDataString:dic withUrl:KK_URL_del_fat_record withSuccess:^(id result, NSDictionary *resultDic, HJHTTPModel *model) {
        
        if (model.errorcode == KKStatus_success ) {
            [self hideLoading];
            //解析数据,存储数据库
            NSString * jsonStr = [HJAESUtil aesDecrypt:model.data];
            DLog(@"jsonStr:%@",jsonStr);
            
            [self.mutableDataArr removeObject:chatInfomodel];
            [self.tableView reloadData];
            
        }else{
            
            [self showToastInView:self.view time:KKToastTime title:model.errormessage];
        }
    
    } withError:^(id result, NSDictionary *resultDic, HJHTTPModel *model) {
        [self showToastInView:self.view time:KKToastTime title:KKLanguage(@"tips_fail")];
    }];
}


#pragma mark ============== 上传记录 ===============
- (void)uploadChatInfoData:(HJChatInfoModel*)model btn:(UIButton*)sender{
    
    SW(sw);
    
    NSDictionary * dic = [model toDictionary];
    
    [KKHttpRequest HttpRequestType:k_POST withrequestType:NO withDataString:dic withUrl:KK_URL_add_fat_record withSuccess:^(id result, NSDictionary *resultDic, HJHTTPModel * httpmodel) {
        
        if (httpmodel.errorcode == KKStatus_success) {
            
            //解析数据,存储数据库
            NSString * jsonStr = [HJAESUtil aesDecrypt:httpmodel.data];
            DLog(@"jsonStr:%@",jsonStr);
            
        
            /*
             更新本地数据记录
             */
            [HJFMDBModel chatInfoUpdate:model];
            
            sender.hidden = YES;
            
            /*
             上传本地照片
             */
            
            [sw showToastInWindows:KKToastTime title:KKLanguage(@"tips_upload_success")];
            
            /*
             删除本地记录
             */
            [sw.localHistoryArr removeObject:model];
            
        }else{
            
            [sw showToastInView:self.view time:KKToastTime title:httpmodel.errormessage];
            
        }
        
    } withError:^(id result, NSDictionary *resultDic, HJHTTPModel * httpmodel) {
        [self showToastInView:self.view time:KKToastTime title:KKLanguage(@"tips_fail")];
    }];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
