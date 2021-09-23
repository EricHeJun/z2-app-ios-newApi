//
//  HJOpencvModel.h
//  fat
//
//  Created by ydd on 2021/4/20.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^HJOpencvBlock)(BOOL isSuccess,UIImage * resultImage,NSArray * pointArr);

@interface HJOpencvModel : NSObject

/*
 图片灰度处理
 */
+(UIImage*)imageToGrayImage:(UIImage*)image;


/*
 高斯模糊处理
 */

+ (UIImage *)ImageToGaussianBlur:(UIImage *)image;

/*
 二值化处理
 */

+ (UIImage *)ImageTothreshold:(UIImage *)image;


/*
 边缘检测
 */

+ (UIImage *)ImageToCanny:(UIImage *)image;


/*
 获取轮廓
 */
- (void)ImageTofind:(UIImage*)image
           oldimage:(UIImage*)oldImage
              block:(HJOpencvBlock)callback;


#pragma mark ============== 将以上方法合并 ===============
/*
 获取轮廓 一步完成
 */
- (void)ImageTofindUnit:(UIImage*)image
                  block:(HJOpencvBlock)callback;

@end

