//
//  HJAboutVC.m
//  fat
//
//  Created by ydd on 2021/4/29.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import "HJAboutVC.h"

@interface HJAboutVC ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic)UITableView * tableView;

@end

@implementation HJAboutVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initData];
    
    [self.view addSubview:self.tableView];
    
}

- (void)initData{
    
    self.dataArr = @[KKLanguage(@"lab_login_serve_text5"),
                     KKLanguage(@"lab_login_serve_text6")];
    
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
        view.frame = CGRectMake(0,0,KKSceneWidth,kk_y(400));
        
        UIImage * image =[UIImage imageNamed:@"img_icon_m"];
        UIImageView * imageview = [[UIImageView alloc] init];
        imageview.frame = CGRectMake(KKSceneWidth/2-image.size.width/2, kk_y(80), image.size.width, image.size.height);
        imageview.image = image;
        imageview.layer.cornerRadius = 10;
        imageview.layer.masksToBounds = YES;
        [view addSubview:imageview];
        
        UILabel * titleLab = [[UILabel alloc] init];
        titleLab.frame = CGRectMake(0, imageview.frame.size.height+imageview.frame.origin.y, view.frame.size.width, kk_y(60));
        titleLab.text = KKLanguage(@"lab_login_serve_text7");
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.font = kk_sizefont(KKFont_small_large);
        titleLab.textColor = kkTextBlackColor;
        [view addSubview:titleLab];
        
        
        titleLab = [[UILabel alloc] init];
        titleLab.frame = CGRectMake(0, imageview.frame.size.height+imageview.frame.origin.y+kk_y(60), view.frame.size.width, kk_y(60));
        
        
        if ([[HJCommon shareInstance] isDebug]) {
            
            titleLab.text =[NSString stringWithFormat:@"%@:V%@(Debug)",KKLanguage(@"lab_login_serve_text8"),[[HJCommon shareInstance] getAppVersion]];
        }else{
            
            titleLab.text =[NSString stringWithFormat:@"%@:V%@",KKLanguage(@"lab_login_serve_text8"),[[HJCommon shareInstance] getAppVersion]];
        }
        
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.font = kk_sizefont(KKFont_small_large);
        titleLab.textColor = kkTextGrayColor;
        [view addSubview:titleLab];
        
        tableview.tableHeaderView = view;
        
        _tableView = tableview;
        
        
        //创建手势识别器对象
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        //设置手势识别器对象的具体属性
        // 连续敲击2次
        tap.numberOfTapsRequired = 5;
        //添加手势识别器到对应的view上
        [view addGestureRecognizer:tap];

        //监听手势的触发
        [tap addTarget:self action:@selector(tapCilck)];
        
    }
    
    return _tableView;
}


#pragma mark ============== tableviewDelegate ===============
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    // 定义cell标识  每个cell对应一个自己的标识
    NSString *CellIdentifier = [NSString stringWithFormat:@"cell%ld%ld",(long)indexPath.section,(long)indexPath.row];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        //底线
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = kkBgGrayColor;
        lineView.frame = CGRectMake(kk_x(20), KKButtonHeight*1.5 - kk_y(1), KKSceneWidth - 2 * kk_x(20), kk_y(1));
        lineView.tag = 10;
        [cell.contentView addSubview:lineView];
        
    }

    cell.textLabel.text = self.dataArr[indexPath.row];
    cell.textLabel.font = kk_sizefont(KKFont_Normal);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell.textLabel.text isEqualToString:KKLanguage(@"lab_login_serve_text5")]) {
        
        HJWebVC * vc = [[HJWebVC alloc] init];
        vc.webType = KKWebType_Agreement;
        vc.navigationItem.title = KKLanguage(@"lab_login_serve_text5");
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if([cell.textLabel.text isEqualToString:KKLanguage(@"lab_login_serve_text6")]) {
        
        HJWebVC * vc = [[HJWebVC alloc] init];
        vc.webType = KKWebType_official;
        vc.navigationItem.title = KKLanguage(@"lab_login_serve_text6");
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}


- (void)tapCilck{
    
    [self showAlertSheetTitle:KKLanguage(@"tips_service_change") message:nil dataArr:@[KKLanguage(@"tips_service_change")] callback:^(NSInteger index, NSString *titleString) {
        
        if ([titleString isEqualToString:KKLanguage(@"tips_service_change")]) {
            
            BOOL isDebug = [[HJCommon shareInstance] isDebug];
            
            [[NSUserDefaults standardUserDefaults] setBool:!isDebug forKey:KKAccount_Debug];
            
            [KKHttpRequest HttpRequestType:k_POST withrequestType:YES withDataString:nil withUrl:KK_URL_api_user_logout withSuccess:^(id result, NSDictionary *resultDic, HJHTTPModel *model) {
                
                if (model.code == KKStatus_success) {
                    [[HJCommon shareInstance] logout:NO toast:@""];
                }else{
                    [self showToastInView:self.view time:KKToastTime title:model.msg];
                }
                
            } withError:^(id result, NSDictionary *resultDic, HJHTTPModel *model) {
                
            }];
        }
        
    }];
    
}


@end
