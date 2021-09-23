//
//  HJMainVC+AccountList.m
//  fat
//
//  Created by ydd on 2021/4/23.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import "HJMainVC+AccountList.h"
#import <SDWebImage/SDWebImage.h>

@implementation HJMainVC (AccountList)

- (void)initDataAccount:(NSArray*)memberArr{
    
    NSMutableArray * realAccount = [NSMutableArray array];
    
    /*
     获取当前使用者
     */
    HJUserInfoModel * model = [HJCommon shareInstance].userInfoModel;
    model.httpHeadImage = model.ossHeadImageUrl;  //修复数据不同步的bug
    
    /*
     如果没有选中对象时,则默认一个
     */
    if ([HJCommon shareInstance].selectModel.id == nil) {
        [HJCommon shareInstance].selectModel = model;
    }
    
    /*
     访客对象
     */
    
    HJUserInfoModel * testUser = [[HJUserInfoModel alloc] init];
    testUser.nickName = KKLanguage(@"lab_main_visitor_test");
    testUser.id = KKAccount_TestId;
    testUser.sex = [NSString stringWithFormat:@"%d",[[HJCommon shareInstance] getTestSex]];
    
    
    if (memberArr == nil) {
        
        [realAccount addObject:model];
        
    }else{
        
        [realAccount addObject:model];
        
        for (HJUserInfoModel * mod in memberArr) {
            mod.nickName = mod.name;                  //此句意思 是 修改昵称
            [realAccount addObject:mod];
        }
    }
    
    NSArray * testAccount = @[testUser];
    
    self.accountArr = [NSMutableArray arrayWithObjects:realAccount,testAccount, nil];
    
}


- (float)accountViewHeight{
    
    NSArray * realAccount = self.accountArr[0];
    
    NSArray * testAccount = self.accountArr[1];
    
    float accountHeight = (realAccount.count+ testAccount.count)*KKButtonHeight*1.5;
    
    if (accountHeight>KKSceneHeight/2) {
        accountHeight = KKSceneHeight/2;
    }
    
    return accountHeight + 2*KKButtonHeight + kk_y(20) + KKButtomSpace;
}

/*
 高度改变
 */

- (void)accountListViewChange{
    
    self.accountListView.frame = CGRectMake(0, KKSceneHeight-[self accountViewHeight], KKSceneWidth, [self accountViewHeight]);
    
    self.accountListView.addAccountBtn.frame = CGRectMake(0, self.accountListView.frame.size.height - KKButtonHeight - KKButtomSpace, self.accountListView.frame.size.width, KKButtonHeight);
    
    self.accountListView.accountTableView.frame = CGRectMake(0, 0, self.accountListView.frame.size.width,self.accountListView.addAccountBtn.frame.origin.y);
    
    [self.accountListView.accountTableView reloadData];
}

#pragma mark ============== 点击事件 ===============
- (void)AccountbtnClick:(UIButton*)sender{
    
    NSArray * arr = self.accountArr[[sender.accessibilityValue intValue]];
    
    HJUserInfoModel * model = arr[sender.tag];
    
    [HJCommon shareInstance].selectModel = model;
    

    /*
     存储当前连接对象的所有信息
     */
    NSString * jsonString  = [[HJCommon shareInstance].selectModel toJSONString];
    
    [[NSUserDefaults standardUserDefaults] setObject:jsonString forKey:KKAccount_selectModelInfo];
    [[NSUserDefaults standardUserDefaults] synchronize];
    

    [self hideMaskViewSubview:self.accountListView];
    
    [self refreshUI];
    
    /*
     发送切换对象通知
     */
    [[NSNotificationCenter defaultCenter] postNotificationName:KKAccount_Change object:nil];
    
}



-(void)accountTableViewCell:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIImageView * imageView = (UIImageView*)[cell viewWithTag:10000];
    UILabel * textLabel = (UILabel*)[cell viewWithTag:10001];
    textLabel.textColor = kkTextGrayColor;
    
    NSArray * arr = self.accountArr[indexPath.section];

    HJUserInfoModel * userModel = arr[indexPath.row];
    
    
    if([[HJCommon shareInstance].selectModel.id isEqualToString: userModel.id]){
        
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.tintColor = KKBgYellowColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }else{
        
        if ([HJCommon shareInstance].selectModel.id==nil) {
            
            if (indexPath.section == 0 && indexPath.row == 0) {
                
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                cell.tintColor = KKBgYellowColor;
                
            }else{
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }else{
            
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
    }
    
    NSString * nickName = userModel.nickName;
    /*
     没有选中id时,就是自己
     */
    if (indexPath.row == 0 && indexPath.section == 0) {
        nickName = [NSString stringWithFormat:@"%@%@",nickName,KKLanguage(@"lab_main_test_account_self")];
    }
    
    textLabel.text = nickName;
    
    if (indexPath.section == 1) {
        
        imageView.image = [UIImage imageNamed:@"img_bg_guest"];
        
    }else{
        
        //NSURL * url = [NSURL URLWithString:userModel.httpHeadImage];
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:userModel.httpHeadImage] placeholderImage:[UIImage imageNamed:@"img_me_userinfo_photo_s"]];
        
        imageView.contentMode =  UIViewContentModeScaleAspectFill;
        
    }
    
    
}


@end
