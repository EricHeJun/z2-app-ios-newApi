//
//  HJBLEImageDataVC+Func.h
//  fat
//
//  Created by ydd on 2021/8/7.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import "HJBLEImageDataVC.h"
#import "HJOpencvModel.h"

@interface HJBLEImageDataVC (Func)


/*
 获取蓝牙数据-非补点
 */
- (void)getBLEDataTwo;

/*
 检测图像是否满足成像条件
 */
- (void)detectionImage;

/*
 生成图片
 */
- (UIImage *)imageFromBRGABytesImage;

/*
 获取平均高度
 */
- (void)getAvgHeight:(NSArray*)pointArr;

/*
 插入图片数据
 */
- (void)saveChatInfoData:(NSArray*)pointArr;

/*
 加载向导视图
 */
- (void)addGuideView:(BOOL)show;

/*
 刷新向导视图
 */
- (void)refreshGuide:(NSInteger)indexTag;


- (void)addMuscleView;


- (void)refreshMuscleView;

@end
