//
//  HJMeVC.m
//  fat
//
//  Created by 何军 on 2021/4/14.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import "HJMeVC.h"
#import <SDWebImage/SDWebImage.h>
@interface HJMeVC ()<UITableViewDelegate,UITableViewDataSource>{
    
    UIButton * _iconImageBtn;
    UILabel * _shopNickerLab;
    UILabel * _aliPayAccountLab;
    
    UILabel * _shopNameLab;
    UILabel * _shopPhoneLab;
    UILabel * _manageNameLab;
    UILabel * _managePhoneLab;
    
    UILabel * _addressLab;
    UILabel * _addressDetailLab;
    UILabel * _creditCodeLab;
    
    UILabel * _versionLab;
    
}

@property (strong,nonatomic)UITableView * tableView;
@property (strong,nonatomic)UIView * headView;

@property (strong,nonatomic)HJAdviewResponseModel * adviewModel;

@property (strong,nonatomic)UIImage * dataImage;

@end

@implementation HJMeVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refreshUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addNavBackgroundColor:self.view.backgroundColor];
    
    [self initData];
    [self initUI];
    
}
- (void)initData{
    
    self.dataArr = [NSArray arrayWithObjects:
                    @[KKLanguage(@"lab_me_account_manage")],
                    @[//KKLanguage(@"lab_me_use"),
                      KKLanguage(@"lab_me_question"),
                      KKLanguage(@"lab_me_feedback"),
                      KKLanguage(@"lab_me_setting")], nil];
    
    
 
    
    /*
     查询广告
     */
    [self queryAdview];
    
    
}

#pragma mark ============== UI ===============
- (void)initUI{
    
    self.view.backgroundColor = kkBgGrayColor;
    [self.view addSubview:self.tableView];
    
}

- (void)refreshUI{
    
    _shopNickerLab.text = [HJCommon shareInstance].userInfoModel.userName;
    
    [_iconImageBtn sd_setImageWithURL:[NSURL URLWithString:[HJCommon shareInstance].userInfoModel.avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"img_me_userinfo_photo_m"]];
    
    _iconImageBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
}
- (UITableView*)tableView{
    
    if (!_tableView) {
        
        float tabBarHeight = self.tabBarController.tabBar.frame.size.height;
        
        UITableView * tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KKSceneWidth, KKSceneHeight-tabBarHeight) style:UITableViewStylePlain];
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
        
        _tableView = tableview;
    }
    
    return _tableView;
}
- (UIView*)headView{
    
    if (!_headView) {
        
        UIView * view = [[UIView alloc] init];
        view.frame = CGRectMake(0, 0, KKSceneWidth, kk_y(310));
        view.backgroundColor = KKBgYellowColor;
        _headView = view;
        
        UIImage * image = [UIImage imageNamed:@"img_me_userinfo_photo_m"];
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(kk_x(40), kk_y(160), image.size.width, image.size.height);
        [btn setImage:image forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = KKButton_Me_userInfo;
        btn.layer.cornerRadius = btn.frame.size.height/2;
        btn.layer.masksToBounds = YES;
        [view addSubview:btn];
        _iconImageBtn = btn;
        
        
        UILabel * labName = [[UILabel alloc] init];
        labName.frame = CGRectMake(btn.frame.size.width+btn.frame.origin.x + kk_x(40), btn.frame.origin.y, view.frame.size.width - (btn.frame.size.width+btn.frame.origin.x + kk_x(40)+kk_x(100)), btn.frame.size.height);
        labName.font = kk_sizefont(KKFont_Big);
        labName.textColor = kkWhiteColor;
        [view addSubview:labName];
        _shopNickerLab = labName;
    
    }
    
    return _headView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
   NSArray * arr =self.dataArr[section];
   return  arr.count;

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (self.adviewModel) {
        
        UIImage *image =  self.dataImage;
        
        float scale = image.size.height/image.size.width;

        if (section == 0) {
            return scale*(KKSceneWidth-kk_x(20)*2)+kk_y(20)*2;
        }
    }
   
    return kk_y(20);
    
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
  
    UIImage *image =  self.dataImage;
    
    float imageHeight = kk_y(20);
    float scale = image.size.height/image.size.width;
    
    if (image) {
        imageHeight = scale*(KKSceneWidth-kk_x(20)*2);
    }
    
    float height = section==0?imageHeight:kk_y(20);
    
    UIView * view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, KKSceneWidth, height+kk_y(20)*2);
    view.backgroundColor = self.view.backgroundColor;
    
    if (section == 0) {
        
        UIImageView * imageView = [[UIImageView alloc] init];
        imageView.userInteractionEnabled = YES;
        imageView.frame = CGRectMake(kk_x(20), kk_y(20), KKSceneWidth-kk_x(20)*2, imageHeight);
        imageView.image = image;
        [view addSubview:imageView];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [imageView addGestureRecognizer:tap];
        
    }
    
    return view;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 定义cell标识  每个cell对应一个自己的标识
    NSString *CellIdentifier = [NSString stringWithFormat:@"cell%ld%ld",(long)indexPath.section,(long)indexPath.row];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        //底线
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = kkBgGrayColor;
        lineView.frame = CGRectMake(kk_x(20), KKButtonHeight*1.5 - kk_y(1), KKSceneWidth - 2 * kk_x(20), kk_y(1));
        lineView.tag = 10;
        [cell.contentView addSubview:lineView];
        
    }
    
    UIView * lineView = (UIView*)[cell.contentView viewWithTag:10];
    NSArray * arr = self.dataArr[indexPath.section];
    
    if (indexPath.row == arr.count-1) {
        lineView.hidden = YES;
    }

    cell.textLabel.text = arr[indexPath.row];
    cell.textLabel.font = kk_sizefont(KKFont_Normal);
    
    
    return cell;
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
        [self refreshUI];
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell.textLabel.text isEqualToString:KKLanguage(@"lab_me_account_manage")]) {
        
        HJAccountVC * vc = [[HJAccountVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;   //关键代码 （隐藏tabBar）
        vc.navigationItem.title = KKLanguage(@"lab_me_account_manage");
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([cell.textLabel.text isEqualToString:KKLanguage(@"lab_me_use")]) {
        
        HJGuideVC * vc = [[HJGuideVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;   //关键代码 （隐藏tabBar）
        vc.navigationItem.title = KKLanguage(@"lab_me_use");
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([cell.textLabel.text isEqualToString:KKLanguage(@"lab_me_question")]) {

        
        HJWebVC * vc = [[HJWebVC alloc] init];
        vc.webType = KKWebType_Faq;
        vc.hidesBottomBarWhenPushed = YES;   //关键代码 （隐藏tabBar）
        vc.navigationItem.title = KKLanguage(@"lab_me_question");
        [self.navigationController pushViewController:vc animated:YES];
        
        
        
    }else if ([cell.textLabel.text isEqualToString:KKLanguage(@"lab_me_feedback")]) {
        
        HJFeedBackVC * vc = [[HJFeedBackVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;   //关键代码 （隐藏tabBar）
        vc.navigationItem.title = KKLanguage(@"lab_me_feedback");
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([cell.textLabel.text isEqualToString:KKLanguage(@"lab_me_setting")]) {
        
        HJSettingVC * vc = [[HJSettingVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;   //关键代码 （隐藏tabBar）
        vc.navigationItem.title = KKLanguage(@"lab_me_setting");
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
}

#pragma mark ============== 广告页获取 ===============
- (void)queryAdview{
    
    HJAdviewModel * model = [HJAdviewModel new];
    model.position = @"4";
    model.packageName = [[HJCommon shareInstance] getAppBundleID];
    
    NSDictionary *dic = [model toDictionary];
    
    [KKHttpRequest HttpRequestType:k_POST withrequestType:NO withDataString:dic withUrl:KK_URL_query_adview withSuccess:^(id result, NSDictionary *resultDic, HJHTTPModel *model) {
        
        if (model.errorcode == KKStatus_success) {

            //解析数据,存储数据库
            NSString * jsonStr = [HJAESUtil aesDecrypt:model.data];
            
            HJAdviewResponseModel *adviewModel = [[HJAdviewResponseModel alloc] initWithString:jsonStr error:nil];
            self.adviewModel = adviewModel;
            
            dispatch_queue_t queue =  dispatch_get_global_queue(0, 0);
            dispatch_async(queue, ^{
               
                NSData *data = [NSData  dataWithContentsOfURL:[NSURL URLWithString:self.adviewModel.httpMediaUrl]];
                self.dataImage =  [UIImage imageWithData:data];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.tableView reloadData];
                    
                });
            });
            
            DLog(@"广告信息:%@",jsonStr);
        }
        
    } withError:^(id result, NSDictionary *resultDic, HJHTTPModel *model) {
        
        
    }];
}

#pragma mark ============== 点击事件 ===============
- (void)btnClick:(UIButton*)sender{
    
    if (sender.tag == KKButton_Me_userInfo) {
        
        HJUserInfoVC * vc = [[HJUserInfoVC alloc] init];
        vc.navigationItem.title = KKLanguage(@"lab_me_userInfo_title");
        vc.hidesBottomBarWhenPushed = YES;   //关键代码 （隐藏tabBar）
        vc.userInfoType = KKUserInfoType_self;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

- (void)tap{
    
    HJWebVC * vc = [[HJWebVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;   //关键代码 （隐藏tabBar）
    vc.navigationItem.title = self.adviewModel.content;
    vc.urlString = self.adviewModel.contentUrl;
    [self.navigationController pushViewController:vc animated:YES];
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
