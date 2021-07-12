//
//  OpenCVWrapper.m
//  opencvPractice
//
//  Created by Ik ju Song on 2020/11/22.
//
#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>
#import <UIKit/UIKit.h>
#import "OpenCVWrapper.h"
#include "LaneDetector.hpp"

@implementation OpenCVWrapper
+ (NSString *)openCVVersionString {
    
    return [NSString stringWithFormat:@"OpenCV Version %s",  CV_VERSION];
}



+ (UIImage *) makeGrayImage:(UIImage *) image {
    // Transform UIImage to cv::Mat
    cv::Mat imageMat;
   
    UIImageToMat(image, imageMat);
   
    // If the image was alread grayscale, return it
    if (imageMat.channels() == 1)
        return image;
   
    // Transform the cv::mat color image to gray
    cv::Mat grayMat;
    cv::cvtColor(imageMat, grayMat, CV_BGR2GRAY);
   
    // Transform grayMat to UIImage and return
    return MatToUIImage(grayMat);
}

- (UIImage *) detectLaneIn: (UIImage *) image {
    
    // convert uiimage to mat
    cv::Mat opencvImage;
    UIImageToMat(image, opencvImage, true);
    
    // convert colorspace to the one expected by the lane detector algorithm (RGB)
    cv::Mat convertedColorSpaceImage;
    cv::cvtColor(opencvImage, convertedColorSpaceImage, CV_RGBA2RGB);
    
    // Run lane detection
    LaneDetector laneDetector;
    cv::Mat imageWithLaneDetected = laneDetector.detect_lane(convertedColorSpaceImage);
    
    // convert mat to uiimage and return it to the caller
    return MatToUIImage(imageWithLaneDetected);
}




- (UIImage *) opencvPractice:(UIImage *) image {
    LaneDetector laneDetector;
    cv::Mat imageMat;
    UIImageToMat(image, imageMat);
    
    imageMat = laneDetector.detectColor(imageMat);
    return MatToUIImage(imageMat);
    
    
}

-(NSString *) opencvJugliing:(UIImage *) image {
    NSString *result = @"";
    LaneDetector laneDetector;
    cv::Mat imageMat;
    UIImageToMat(image, imageMat);
    std::string jugglingStr;
    jugglingStr = laneDetector.detectjugglingXY(imageMat);
    result = [NSString stringWithUTF8String:jugglingStr.c_str()];
    return result;
}
/*
std::string cppString = "std::string에서 NSString로 형변환 테스트";
08.NSString *objectiveString = [NSString stringWithUTF8String:cppString.c_str()];
*/

@end
