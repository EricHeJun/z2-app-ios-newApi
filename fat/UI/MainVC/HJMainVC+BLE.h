//
//  HJMainVC+BLE.h
//  fat
//
//  Created by ydd on 2021/4/15.
//  Copyright © 2021 Marvoto. All rights reserved.
//


#import "HJMainVC.h"


@interface HJMainVC (BLE)

- (void)BLEbtnClick:(UIButton*)sender;

/*
 初始化蓝牙
 */
- (void)initDataBLE;

/*
 蓝牙参数设置
 */
- (void)peripheralSetting;

/*
 搜索设备
 */
- (void)searchDevice;

/*
 停止搜索
 */
- (void)cancelSearchDevice;

/*
 获取高度
 */
- (float)deviceViewHeight;

/*
 改变视图位置
 */
- (void)deviceViewChange;

/*
 刷新gif图
 */
- (void)refreshBLEView:(BOOL)searching;

- (void)refreshGIF;


-(void)deviceTableViewCell:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

@end


