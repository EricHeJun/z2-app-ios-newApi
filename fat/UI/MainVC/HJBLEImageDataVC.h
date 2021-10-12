//
//  HJBLEImageDataVC.h
//  fat
//
//  Created by 何军 on 2021/4/15.
//  Copyright © 2021 Marvoto. All rights reserved.
//



#import "HJBaseViewController.h"
#import "HJBLEChatView.h"
#import "HJFMDBModel.h"
#import "HJOSSUpload.h"
#import "HJShareUtil.h"
#import "HJChartAnalysisModel.h"
#import "HJMuscleGuideView.h"

#define KKTotalCount 150
#define KKDelayCount 10     // 注意,必须被KKTotalCount 整除 的数值

#define KKBLEStart  16
#define KKBLEEnd    1

#define KKEndCount  10

#define KKRefreshTime 10   //界面刷新时间 ms

@interface HJBLEImageDataVC : HJBaseViewController{
    
    
    int _imageViewwidth;    //可视图片大小
    int _imageViewheight;
    
    float _avgHeight;   //平均厚度
    float _maxHeight;   //最大厚度
    float _minHeight;   //最小厚度
    
    dispatch_source_t _timer;
}

@property (strong,nonatomic)HJBLEChatView * chatView;
@property (strong,nonatomic)NSMutableArray * BLEDataArr; //蓝牙数据数组
@property (strong,nonatomic)NSMutableArray * pxArr;  //绘图数组
@property (strong,nonatomic)NSMutableArray * pxBlackArr;    //备用数组 黑色

@property (strong,nonatomic)NSArray * resultPointArr;


@property (strong,nonatomic)UILabel * testTopLab;
@property (strong,nonatomic)UILabel * testValueLab;
@property (strong,nonatomic)UILabel * testAvgLab;
@property (strong,nonatomic)UILabel * testResultLab;

@property (strong,nonatomic)UILabel * testMaxLab;
@property (strong,nonatomic)UILabel * testMinLab;


@property (assign,nonatomic)BOOL isAcceptNewData;    //是否接受新数据
@property (assign,nonatomic)BOOL isImageSuccess;     //是否获取图片成功
  
@property (strong,nonatomic)UIImage * uploadImage;

@property (assign,nonatomic)NSInteger arrGetCount;   //收到的数据笔数

@property (assign,nonatomic)NSInteger endCount;      //未收到的数据笔数统计

@property (strong,nonatomic)HJMuscleGuideView * guideView;

@property (strong,nonatomic)HJBaseView * muscleView;
@property (strong,nonatomic)UILabel * muscleTitleLab;
@property (strong,nonatomic)UIImageView * muscleImageView;


@property (strong,nonatomic)HJBaseView * saveView;

- (void)startTimer;

- (void)stopTimer;

- (void)refreshUI;

@end

