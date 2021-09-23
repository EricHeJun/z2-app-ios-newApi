//
//  HJMaskView.h
//  JiaYueShouYin
//
//  Created by 何军 on 2020/7/24.
//  Copyright © 2020 Eric. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HJMaskView : UIView

//蒙层添加到Window上
+ (instancetype)makeViewWithMask:(CGRect)frame;

//状态回调
/**
 */
@property (nonatomic,strong) void (^ resultblock)(void);

@end

