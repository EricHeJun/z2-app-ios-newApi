//
//  HJAccountVC.m
//  fat
//
//  Created by 何军 on 2021/4/23.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import "HJAccountVC.h"
#import <SDWebImage/SDWebImage.h>

@interface HJAccountVC ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic)UITableView * tableView;
@property (strong,nonatomic)NSMutableArray * accountArr;
@end

@implementation HJAccountVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initData];
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addRightBtnOneWithImage:RightBtnAddAccount];
    
    [self.view addSubview:self.tableView];
}

- (void)initData{
    
    [self showLoadingInView:self.view time:KKTimeOut title:KKLanguage(@"lab_common_loading")];
    
    [KKHttpRequest HttpRequestType:k_POST withrequestType:NO withDataString:nil withUrl:KK_URL_api_fat_member_list withSuccess:^(id result, NSDictionary *resultDic, HJHTTPModel *model) {
        
        if (model.code == KKStatus_success) {
            
            [self showToastInView:self.view time:KKToastTime title:model.msg];
   
            
            NSMutableArray * array = [HJUserInfoModel arrayOfModelsFromDictionaries:model.data error:nil];
            
            NSMutableArray * accountArr = [NSMutableArray array];
            
            for (HJUserInfoModel * obj in array) {
                obj.firstCharactor =[[HJCommon shareInstance] firstCharactor:obj.userName];
                [accountArr addObject:obj];
            }
            
            self.accountArr = [accountArr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                
                HJUserInfoModel * mod1 = obj1;
                HJUserInfoModel * mod2 = obj2;
                
                return [mod1.firstCharactor compare:mod2.firstCharactor options:NSCaseInsensitiveSearch];
            }];
            
            [self.tableView reloadData];
            
            
        }else{
            [self showToastInView:self.view time:KKToastTime title:model.errormessage];
        }
        
    } withError:^(id result, NSDictionary *resultDic, HJHTTPModel *model) {
        
        [self showToastInView:self.view time:KKToastTime title:KKLanguage(@"tips_fail")];
        
    }];
    
}

- (UITableView *)tableView{
    
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
        
        _tableView = tableview;
    }
    
    return _tableView;
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
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
        
        UIImageView * imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(kk_x(40), kk_y(20), KKButtonHeight*1.5 - 2*kk_y(20), KKButtonHeight*1.5 - 2*kk_y(20));
        imageView.tag = 20;
        imageView.layer.cornerRadius =imageView.frame.size.height/2;
        imageView.layer.masksToBounds = YES;
        [cell.contentView addSubview:imageView];
        
        UILabel * textLabel = [[UILabel alloc] init];
        textLabel.frame = CGRectMake(imageView.frame.size.width+imageView.frame.origin.x+kk_x(40), 0, KKSceneWidth/2, KKButtonHeight*1.5);
        textLabel.font = kk_sizefont(KKFont_Normal);
        textLabel.textColor = kkTextBlackColor;
        textLabel.tag = 30;
        [cell.contentView addSubview:textLabel];
    }
    
    HJUserInfoModel * model = self.accountArr[indexPath.row];
    
    UIImageView * imageView = (UIImageView*)[cell viewWithTag:20];
    UILabel * textLabel = (UILabel*)[cell viewWithTag:30];
    
    textLabel.text = model.userName;
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"img_me_userinfo_photo_s"]];
    
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.accountArr.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    HJUserInfoModel * userModel = self.accountArr[indexPath.row];
    HJUserInfoVC * vc = [[HJUserInfoVC alloc] init];
    vc.userInfoType = KKUserInfoType_other;
    vc.userModel = userModel;
    vc.navigationItem.title = KKLanguage(@"lab_me_userInfo_title");
    [self.navigationController pushViewController:vc animated:YES];
    
    
}
#pragma mark ============== 点击 ===============
- (void)rightBtnOneClick:(UIButton *)sender{
    
    if (sender.tag == KKButton_Main_AddAcount) {
        
        HJUserInfoVC * vc = [[HJUserInfoVC alloc] init];
        vc.userInfoType = KKUserInfoType_add;
        vc.navigationItem.title = KKLanguage(@"lab_main_add_account_title");
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
