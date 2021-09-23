//
//  HJOpencvModel.m
//  fat
//
//  Created by ydd on 2021/4/20.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#include "opencv2/core.hpp"
#include "opencv2/imgproc.hpp"
#include "opencv2/imgcodecs.hpp"
#include "opencv2/highgui.hpp"
#include "opencv2/highgui/highgui_c.h"
#include "opencv2/imgcodecs/ios.h"   //此文件是 UIImageToMat 和 MatToUIImage 方法



#import "HJOpencvModel.h"

using namespace cv;
using namespace std;


@interface HJOpencvModel ()

@property (nonatomic, readonly) cv::Mat CVMat;
@property (nonatomic, readonly) cv::Mat CVGrayscaleMat;

@end

@implementation HJOpencvModel


/*
 图片灰度处理
 */
+(UIImage*)imageToGrayImage:(UIImage*)image{

    //image源文件
     // 1.将iOS的UIImage转成c++图片（数据：矩阵）
     Mat mat_image_gray;
     UIImageToMat(image, mat_image_gray);

     // 2. 将c++彩色图片转成灰度图片
     // 参数一：数据源
     // 参数二：目标数据
     // 参数三：转换类型
     Mat mat_image_dst;
    
     cvtColor(mat_image_gray, mat_image_dst, COLOR_BGR2GRAY);

     // 4. 将c++处理之后的图片转成iOS能识别的UIImage
     return MatToUIImage(mat_image_dst);

}

/*
 高斯模糊处理
 */

+ (UIImage *)ImageToGaussianBlur:(UIImage *)image{
    //实现功能
    //第一步：将iOS图片->OpenCV图片(Mat矩阵)
    Mat mat_image_src;
    UIImageToMat(image, mat_image_src);
    
    Mat mat_image_dst;
    
    GaussianBlur(mat_image_src,mat_image_dst,cv::Size(15,15),0,0);
    
    return MatToUIImage(mat_image_dst);
}


/*
 二值化处理
 */

+ (UIImage *)ImageTothreshold:(UIImage *)image{
    //实现功能
    //第一步：将iOS图片->OpenCV图片(Mat矩阵)
    Mat mat_image_src;
    UIImageToMat(image, mat_image_src);
    
    Mat mat_image_dst;

    threshold(mat_image_src, mat_image_dst, 125, 255, THRESH_BINARY);

    return MatToUIImage(mat_image_dst);
}

/*
 边缘检测
 */

+ (UIImage *)ImageToCanny:(UIImage *)image{
    
    //实现功能
    //第一步：将iOS图片->OpenCV图片(Mat矩阵)
    Mat mat_image_src;
    UIImageToMat(image, mat_image_src);
    
    Mat mat_image_dst;

    Canny(mat_image_src, mat_image_dst, 50, 150, 3);

    return MatToUIImage(mat_image_dst);
    
}

+ (UIImage *)ImageTofind:(UIImage*)image withOldimage:(UIImage*)oldImage{
    

    Mat mat_image_src_old;
    UIImageToMat(oldImage, mat_image_src_old);
    
    //实现功能
    //第一步：将iOS图片->OpenCV图片(Mat矩阵)
    Mat mat_image_src;
    UIImageToMat(image, mat_image_src);
    
    vector<vector<cv::Point>> contours;
    
    vector<Vec4i> hierarchy;
    

    findContours(mat_image_src, contours, hierarchy, CV_RETR_EXTERNAL, CV_CHAIN_APPROX_NONE);
    

    double weightValue = -10;
    int index = -1;


    for (int i =0; i<contours.size(); i++) {

        cv::Rect rect = boundingRect(contours[i]);
        
        double area = contourArea(contours[i]);

        double length = arcLength(contours[i],true);

        int realW = mat_image_src.size().width;

        NSLog(@"length:%f   realW:%d  rect.x:%d  rect.y:%d",length,realW,rect.x,rect.y);

        if (rect.width >= ((realW)) && rect.height < 50 && rect.y>5 && length < 3*realW) {

            NSLog(@"符合条件");

            double weight = rect.width*20 + area - (rect.y*5) + length/2;

            if(weight >weightValue){

                weightValue = weight;
                index = i;
            }
        }
    }

    if(index>=0){
        
        Scalar color = Scalar(255,0,0,255); //RGBA

        drawContours(mat_image_src_old, contours, index, color,1,8,hierarchy);
        
    }
    
    return MatToUIImage(mat_image_src_old);
}

/*
 获取轮廓
 */
- (void)ImageTofind:(UIImage*)image
           oldimage:(UIImage*)oldImage
              block:(HJOpencvBlock)callback{
    
    //实现功能
    //第一步：将iOS图片->OpenCV图片(Mat矩阵)
    Mat mat_image_src;
    UIImageToMat(image, mat_image_src);
    
    vector<vector<cv::Point>> contours;
    
    vector<Vec4i> hierarchy;
    

    findContours(mat_image_src, contours, hierarchy, CV_RETR_EXTERNAL, CV_CHAIN_APPROX_NONE);
    

    double weightValue = -10;
    int index = -1;


    for (int i =0; i<contours.size(); i++) {

        cv::Rect rect = boundingRect(contours[i]);
        
        double area = contourArea(contours[i]);

        double length = arcLength(contours[i],true);

        int realW = mat_image_src.size().width;

        NSLog(@"length:%f   realW:%d  rect.x:%d  rect.y:%d",length,realW,rect.x,rect.y);

        if (rect.width >= ((realW)) && rect.height < 50 && rect.y>5 && length < 3*realW) {

            NSLog(@"符合条件");

            double weight = rect.width*20 + area - (rect.y*5) + length/2;

            if(weight >weightValue){

                weightValue = weight;
                index = i;
            }
        }
    }
    
    Mat mat_image_src_old;
    UIImageToMat(oldImage, mat_image_src_old);
    
    NSMutableArray * pointArr = [NSMutableArray array];
    BOOL isSuccess = NO;
    if(index>=0){
        
        isSuccess = YES;
        
        Scalar color = Scalar(255,0,0,255); //RGBA
        drawContours(mat_image_src_old, contours, index, color,1,8,hierarchy);
        
        for(int j=0;j<contours[index].size()/2;j++){
            
            if (j%2 == 0) {
                
                CGPoint point;

                point.x =contours[index][j].x;
                point.y = contours[index][j].y;
                
                [pointArr addObject:[NSValue valueWithCGPoint:point]];
            }
            
        }
    }
    
    callback(isSuccess,MatToUIImage(mat_image_src_old),pointArr);
    
}

- (void)ImageTofindUnit:(UIImage*)image
                  block:(HJOpencvBlock)callback{
    /*
     灰度处理
     */
    //image源文件
    // 1.将iOS的UIImage转成c++图片（数据：矩阵）
    Mat mat_image_gray;
    UIImageToMat(image, mat_image_gray);
    
    // 备用原始数据
    Mat mat_image_oldImage;
    UIImageToMat(image, mat_image_oldImage);
    
    
    Mat mat_image_dst;
    cvtColor(mat_image_gray, mat_image_dst, COLOR_BGR2GRAY);
    
    
    /*
     高斯模糊
     */
    GaussianBlur(mat_image_dst,mat_image_dst,cv::Size(15,15),0,0);
    
    /*
     二值化处理
     */
    threshold(mat_image_dst, mat_image_dst, 125, 255, THRESH_BINARY);
    
    /*
     边缘检测
     */
    Canny(mat_image_dst, mat_image_dst, 50, 150, 3);
    
    
    /*
     找寻最合理的曲线
     */
    vector<vector<cv::Point>> contours;
    
    vector<Vec4i> hierarchy;
    
    findContours(mat_image_dst, contours, hierarchy, CV_RETR_EXTERNAL, CV_CHAIN_APPROX_NONE);
    
    double weightValue = -10;
    int index = -1;


    for (int i =0; i<contours.size(); i++) {

        cv::Rect rect = boundingRect(contours[i]);
        
        double area = contourArea(contours[i]);

        double length = arcLength(contours[i],true);

        int realW = mat_image_oldImage.size().width;


        if (rect.width >= realW && rect.height < 50 && rect.y>10 && length < 3*realW) {

          //  NSLog(@"符合条件:length:%f   realW:%d  rect.x:%d  rect.y:%d %d area:%f",length,realW,rect.x,rect.y,rect.width,area);

            double weight =rect.width*20+area - (rect.y*5) + length/2;

            if(weight > weightValue){
                
             //   NSLog(@"%f %f %d",weight,weightValue,i);

                weightValue = weight;
                index = i;
            }
        }
    }
    
  
    NSMutableArray * pointArr = [NSMutableArray array];
    BOOL isSuccess = NO;
    
    if(index>=0){
        
        isSuccess = YES;
        
        /*
         opencv 绘图代码
         */
//        Scalar color = Scalar(255,211,6,255); //RGBA
//        drawContours(mat_image_oldImage, contours, index, color,3);
    
        NSMutableArray * arr = [NSMutableArray array];
        
        for(int j=0;j<contours[index].size();j++){
            
            CGPoint point;
            
            point.x = contours[index][j].x;
            point.y = contours[index][j].y;
            
            [arr addObject:[NSValue valueWithCGPoint:point]];
        }
        
        //对数组进行从小到大排序
        NSArray * resultArr = [arr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
           
            CGPoint point1 = [obj1 CGPointValue];
            CGPoint point2 = [obj2 CGPointValue];
        
            return [@(point1.x) compare:@(point2.x)];
        }];
        
        for (int i = 0; i<resultArr.count; i++) {
            
            if (i%25==0) {
                
                CGPoint point = [resultArr[i] CGPointValue];
                [pointArr addObject:[NSValue valueWithCGPoint:point]];
            }
        }
    }
    
    callback(isSuccess,MatToUIImage(mat_image_oldImage),pointArr);
}



@end
