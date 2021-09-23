//
//  HJFunctionView.h
//  fat
//
//  Created by ydd on 2021/4/15.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import "HJBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJFunctionView : HJBaseView

@property (strong,nonatomic)UIButton * fatBtn; 
@property (strong,nonatomic)UIButton * muslceBtn;

@property (strong,nonatomic)UIView * fatView;

@property (strong,nonatomic)UIButton * fatviewBtnSel;

@property (strong,nonatomic)UIView * muslceView;

@property (strong,nonatomic)UIButton * muslceViewBtnSel;

@property (strong,nonatomic)UIView * sexView; //性别视图
@property (strong,nonatomic)UILabel * sexLab;
@property (strong,nonatomic)UIButton * manBtn;
@property (strong,nonatomic)UIButton * womanBtn;
@property (strong,nonatomic)UIButton * sexBtnSel; 


@property (strong,nonatomic)UILabel * testFunctionLab;


@property (strong,nonatomic)UITableView * deviceTableView;  //设备列表
@property (strong,nonatomic)UIButton * cancelBtn;
@property (strong,nonatomic)UILabel * searchTitleLab;

@property (strong,nonatomic)UILabel * testPointLab;


@property (strong,nonatomic)UITableView * accountTableView;  //用户列表
@property (strong,nonatomic)UIButton * addAccountBtn;
//状态回调
/**
 */
@property (nonatomic,strong) void (^ selectSexBlock)(UIButton * sender);
@property (nonatomic,strong) void (^ selectFatBlock)(UIButton * sender);
@property (nonatomic,strong) void (^ selectMuscleBlock)(UIButton * sender);

- (instancetype)initWithFrame:(CGRect)frame withViewType:(KKViewType)type;

/*
 是否展示 sex 视图
 */
- (void)showSexView:(BOOL)isShow;



@end

NS_ASSUME_NONNULL_END
