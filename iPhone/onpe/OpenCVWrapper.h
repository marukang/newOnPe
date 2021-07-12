//
//  OpenCVWrapper.h
//  opencvPractice
//
//  Created by Ik ju Song on 2020/11/22.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface OpenCVWrapper : NSObject

+ (NSString *)openCVVersionString;

+ (UIImage *) makeGrayImage:(UIImage *) image;

- (UIImage *) detectLaneIn: (UIImage *) image;

- (UIImage *) opencvPractice: (UIImage *) image;
- (NSString *) opencvJugliing: (UIImage *) image;

@end

NS_ASSUME_NONNULL_END
