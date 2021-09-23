//
//  HJMainVC+AccountList.h
//  fat
//
//  Created by ydd on 2021/4/23.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import "HJMainVC.h"


@interface HJMainVC (AccountList)


- (void)AccountbtnClick:(UIButton*)sender;


/*
 初始化使用者
 */
- (void)initDataAccount:(NSArray*)memberArr;


/*
 获取高度
 */
- (float)accountViewHeight;

/*
 高度改变
 */
- (void)accountListViewChange;


-(void)accountTableViewCell:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

@end

