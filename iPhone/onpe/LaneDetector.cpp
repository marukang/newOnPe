//
//  LaneDetector.cpp
//  opencvPractice
//
//  Created by Ik ju Song on 2021/01/07.
//

#include "LaneDetector.hpp"


using namespace cv;
using namespace std;

double getAverage(vector<double> vector, int nElements) {
    
    double sum = 0;
    int initialIndex = 0;
    int last30Lines = int(vector.size()) - nElements;
    if (last30Lines > 0) {
        initialIndex = last30Lines;
    }
    
    for (int i=(int)initialIndex; i<vector.size(); i++) {
        sum += vector[i];
    }
    
    int size;
    if (vector.size() < nElements) {
        size = (int)vector.size();
    } else {
        size = nElements;
    }
    return (double)sum/size;
}
String LaneDetector::detectjugglingXY(Mat image) {
    Mat img_input = image;
    Mat img_output;
    //ret, img_color = cap.read()
    
    Scalar red(0, 0, 255);
    
    Mat rgb_color = Mat(1, 1, CV_8UC3, red);
    Mat hsv_color;
    
    cvtColor(rgb_color, hsv_color, COLOR_BGR2HSV);
    
    Mat img_frame = img_input;
    Mat img_hsv;
    
    cvtColor(img_frame, img_hsv, COLOR_BGR2HSV);
    
    
    Mat img_mask1, img_mask2;
    
    int hue_red = 120;
    int hue_blue = 0;
    
    int lower_red = (hue_red - 15, 200, 0);
    int upper_red = (hue_red + 15, 255, 255);
    int lower_blue = (hue_blue - 10, 200, 0);
    int upper_blue = (hue_blue + 10, 255, 255);
    
    
    
    
    //inRange(img_hsv, Scalar(low_hue1, 50, 50), Scalar(high_hue1, 255, 255), img_mask1);
    //img_mask1 = inRange(img_hsv, lower_red, upper_red)
    inRange(img_hsv, Scalar(hue_red - 10, 150, 150), Scalar(hue_red + 10, 255, 255), img_mask1);
    inRange(img_hsv, Scalar(hue_blue - 10, 70, 70), Scalar(hue_blue + 10, 255, 255), img_mask2);
    
    
    /////////////////////////////////////////////////////////////////
    
    
    //    kernel1 = cv.getStructuringElement(cv.MORPH_RECT, (5, 5))
    //    kernel2 = cv.getStructuringElement(cv.MORPH_RECT, (5, 5))
    Mat kernel1 = getStructuringElement(MORPH_RECT, Size(5, 5));
    Mat kernel2 = getStructuringElement(MORPH_RECT, Size(5, 5));
    
    //    img_mask1 = cv.morphologyEx(img_mask1, cv.MORPH_DILATE, kernel1, iterations = 3)
    //    img_mask2 = cv.morphologyEx(img_mask2, cv.MORPH_DILATE, kernel2, iterations = 3)
    dilate(img_mask1, img_mask1, kernel1, Point(-1, -1), 3);
    dilate(img_mask2, img_mask2, kernel2, Point(-1, -1), 3);
    
    
    //    nlabels1, labels1, stats1, centroids1 = cv.connectedComponentsWithStats(img_mask1)
    //    nlabels2, labels2, stats2, centroids2 = cv.connectedComponentsWithStats(img_mask2)
    Mat labels1, stats1, centroids1;
    Mat labels2, stats2, centroids2;
    int nlabels1 = connectedComponentsWithStats(img_mask1, labels1, stats1, centroids1, 8, CV_32S);
    int nlabels2 = connectedComponentsWithStats(img_mask2, labels2, stats2, centroids2, 8, CV_32S);
    
    
    int max1 = -1;
    int max_index1 = -1;
    
    
    for (int i = 1; i < nlabels1; i++) {
        
        
        int area1 = stats1.at<int>(i, CC_STAT_AREA);
        
        if (area1 > max1) {
            max1 = area1;
            max_index1 = i;
        }
    }
    
    int center_x1=0;
    int center_y1=0;
    
    if (max_index1 != -1) {
        
        
        center_x1 = centroids1.at<double>(max_index1, 0);
        center_y1 = centroids1.at<double>(max_index1, 1);
        
        int left1 = stats1.at<int>(max_index1, CC_STAT_LEFT);
        int top1 = stats1.at<int>(max_index1, CC_STAT_TOP);
        int width1 = stats1.at<int>(max_index1, CC_STAT_WIDTH);
        int height1 = stats1.at<int>(max_index1, CC_STAT_HEIGHT);
        
        
        if ((width1 > 40) & (40 < height1)) {
            //rectangle(img_frame, Point(left1, top1), Point(left1 + width1, top1 + height1),Scalar(255, 0, 0), 8);
            circle(img_frame, Point(center_x1, center_y1), 20, Scalar(255, 0, 0), -1, 8, 0);
        }
        
    }
    
    
    int max2 = -1;
    int max_index2 = -1;
    
    for (int i = 1; i < nlabels2; i++) {
        
        int area2 = stats2.at<int>(i, CC_STAT_AREA);
        
        if (area2 > max2) {
            max2 = area2;
            max_index2 = i;
        }
    }
    
    int center_x2=0;
    int center_y2=0;
    
    if (max_index2 != -1) {
        
        
        center_x2 = centroids2.at<double>(max_index2, 0);
        center_y2 = centroids2.at<double>(max_index2, 1);
        
        int left2 = stats2.at<int>(max_index2, CC_STAT_LEFT);
        int top2 = stats2.at<int>(max_index2, CC_STAT_TOP);
        int width2 = stats2.at<int>(max_index2, CC_STAT_WIDTH);
        int height2 = stats2.at<int>(max_index2, CC_STAT_HEIGHT);
        
        
        if ((width2 > 40) & (40 < height2)) {
            //rectangle(img_frame, Point(left2, top2), Point(left2 + width2, top2 + height2),Scalar(0, 0, 255), 8);
            circle(img_frame, Point(center_x2, center_y2), 20, Scalar(0, 0, 255), -1, 8, 0);
        }
        
    }
    
    
    img_output = img_frame;
    
    std::string msg = to_string(center_x1) + ","+ to_string(center_y1)+ ","+to_string(center_x2) + ","+ to_string(center_y2);
    //jstring ret = env->NewStringUTF(msg.c_str());
    
    return msg;
    
    //return img_output;
}
Mat LaneDetector::detectColor(Mat image){
    
    Mat img_input = image;
    Mat img_output;
    //ret, img_color = cap.read()
    
    Scalar red(0, 0, 255);
    
    Mat rgb_color = Mat(1, 1, CV_8UC3, red);
    Mat hsv_color;
    
    cvtColor(rgb_color, hsv_color, COLOR_BGR2HSV);
    
    Mat img_frame = img_input;
    Mat img_hsv;
    
    cvtColor(img_frame, img_hsv, COLOR_BGR2HSV);
    
    
    Mat img_mask1, img_mask2;
    
    int hue_red = 120;
    int hue_blue = 0;
    
    int lower_red = (hue_red - 15, 200, 0);
    int upper_red = (hue_red + 15, 255, 255);
    int lower_blue = (hue_blue - 10, 200, 0);
    int upper_blue = (hue_blue + 10, 255, 255);
    
    
    
    
    //inRange(img_hsv, Scalar(low_hue1, 50, 50), Scalar(high_hue1, 255, 255), img_mask1);
    //img_mask1 = inRange(img_hsv, lower_red, upper_red)
    inRange(img_hsv, Scalar(hue_red - 10, 150, 150), Scalar(hue_red + 10, 255, 255), img_mask1);
    inRange(img_hsv, Scalar(hue_blue - 10, 70, 70), Scalar(hue_blue + 10, 255, 255), img_mask2);
    
    
    /////////////////////////////////////////////////////////////////
    
    
    //    kernel1 = cv.getStructuringElement(cv.MORPH_RECT, (5, 5))
    //    kernel2 = cv.getStructuringElement(cv.MORPH_RECT, (5, 5))
    Mat kernel1 = getStructuringElement(MORPH_RECT, Size(5, 5));
    Mat kernel2 = getStructuringElement(MORPH_RECT, Size(5, 5));
    
    //    img_mask1 = cv.morphologyEx(img_mask1, cv.MORPH_DILATE, kernel1, iterations = 3)
    //    img_mask2 = cv.morphologyEx(img_mask2, cv.MORPH_DILATE, kernel2, iterations = 3)
    dilate(img_mask1, img_mask1, kernel1, Point(-1, -1), 3);
    dilate(img_mask2, img_mask2, kernel2, Point(-1, -1), 3);
    
    
    //    nlabels1, labels1, stats1, centroids1 = cv.connectedComponentsWithStats(img_mask1)
    //    nlabels2, labels2, stats2, centroids2 = cv.connectedComponentsWithStats(img_mask2)
    Mat labels1, stats1, centroids1;
    Mat labels2, stats2, centroids2;
    int nlabels1 = connectedComponentsWithStats(img_mask1, labels1, stats1, centroids1, 8, CV_32S);
    int nlabels2 = connectedComponentsWithStats(img_mask2, labels2, stats2, centroids2, 8, CV_32S);
    
    
    int max1 = -1;
    int max_index1 = -1;
    
    
    for (int i = 1; i < nlabels1; i++) {
        
        
        int area1 = stats1.at<int>(i, CC_STAT_AREA);
        
        if (area1 > max1) {
            max1 = area1;
            max_index1 = i;
        }
    }
    
    int center_x1=0;
    int center_y1=0;
    
    if (max_index1 != -1) {
        
        
        center_x1 = centroids1.at<double>(max_index1, 0);
        center_y1 = centroids1.at<double>(max_index1, 1);
        
        int left1 = stats1.at<int>(max_index1, CC_STAT_LEFT);
        int top1 = stats1.at<int>(max_index1, CC_STAT_TOP);
        int width1 = stats1.at<int>(max_index1, CC_STAT_WIDTH);
        int height1 = stats1.at<int>(max_index1, CC_STAT_HEIGHT);
        
        
        if ((width1 > 40) & (40 < height1)) {
            //rectangle(img_frame, Point(left1, top1), Point(left1 + width1, top1 + height1),Scalar(255, 0, 0), 8);
            circle(img_frame, Point(center_x1, center_y1), 20, Scalar(255, 0, 0), -1, 8, 0);
        }
        
    }
    
    
    int max2 = -1;
    int max_index2 = -1;
    
    for (int i = 1; i < nlabels2; i++) {
        
        int area2 = stats2.at<int>(i, CC_STAT_AREA);
        
        if (area2 > max2) {
            max2 = area2;
            max_index2 = i;
        }
    }
    
    int center_x2=0;
    int center_y2=0;
    
    if (max_index2 != -1) {
        
        
        center_x2 = centroids2.at<double>(max_index2, 0);
        center_y2 = centroids2.at<double>(max_index2, 1);
        
        int left2 = stats2.at<int>(max_index2, CC_STAT_LEFT);
        int top2 = stats2.at<int>(max_index2, CC_STAT_TOP);
        int width2 = stats2.at<int>(max_index2, CC_STAT_WIDTH);
        int height2 = stats2.at<int>(max_index2, CC_STAT_HEIGHT);
        
        
        if ((width2 > 40) & (40 < height2)) {
            //rectangle(img_frame, Point(left2, top2), Point(left2 + width2, top2 + height2),Scalar(0, 0, 255), 8);
            circle(img_frame, Point(center_x2, center_y2), 20, Scalar(0, 0, 255), -1, 8, 0);
        }
        
    }
    
    
    img_output = img_frame;
    String abc = to_string(center_x1) + ","+ to_string(center_y1)+ ","+to_string(center_x2) + ","+ to_string(center_y2);
    
    std::string msg = to_string(center_x1) + ","+ to_string(center_y1)+ ","+to_string(center_x2) + ","+ to_string(center_y2);
    //jstring ret = env->NewStringUTF(msg.c_str());
    return img_output;
    
    //return img_output;
    
}

Mat LaneDetector::detect_lane(Mat image) {
    
    Mat colorFilteredImage = filter_only_yellow_white(image);
    Mat regionOfInterest = crop_region_of_interest(colorFilteredImage);
    Mat edgesOnly = detect_edges(regionOfInterest);
    
    vector<Vec4i> lines;
    HoughLinesP(edgesOnly, lines, 1, CV_PI/180, 10, 20, 100);
    
    return draw_lines(image, lines);
}

Mat LaneDetector::filter_only_yellow_white(Mat image) {
    
    Mat hlsColorspacedImage;
    cvtColor(image, hlsColorspacedImage, CV_RGB2HLS);
    
    Mat yellowMask;
    Scalar yellowLower = Scalar(10, 0, 90);
    Scalar yellowUpper = Scalar(50, 255, 255);
    inRange(hlsColorspacedImage, yellowLower, yellowUpper, yellowMask);
    
    Mat whiteMask;
    Scalar whiteLower = Scalar(0, 190, 0);
    Scalar whiteUpper = Scalar(255, 255, 255);
    inRange(hlsColorspacedImage, whiteLower, whiteUpper, whiteMask);
    
    Mat mask;
    bitwise_or(yellowMask, whiteMask, mask);
    
    Mat maskedImage;
    bitwise_and(image, image, maskedImage, mask);
    
    return maskedImage;
}

Mat LaneDetector::crop_region_of_interest(Mat image) {
    
    /*
     The code below draws the region of interest into a new image of the same dimensions as the original image.
     The region of interest is filled with the color we want to filter for in the image.
     Lastly it combines the two images.
     The result is only the color within the region of interest.
     */
    
    int maxX = image.rows;
    int maxY = image.cols;
    
    Point shape[1][5];
    shape[0][0] = Point(0, maxX);
    shape[0][1] = Point(maxY, maxX);
    shape[0][2] = Point((int)(0.55 * maxY), (int)(0.6 * maxX));
    shape[0][3] = Point((int)(0.45 * maxY), (int)(0.6 * maxX));
    shape[0][4] = Point(0, maxX);
    
    Scalar color_to_filter(255, 255, 255);
    
    Mat filledPolygon = Mat::zeros(image.rows, image.cols, CV_8UC3); // empty image with same dimensions as original
    const Point* polygonPoints[1] = { shape[0] };
    int numberOfPoints[] = { 5 };
    int numberOfPolygons = 1;
    fillPoly(filledPolygon, polygonPoints, numberOfPoints, numberOfPolygons, color_to_filter);
    
    // Cobine images into one
    Mat maskedImage;
    bitwise_and(image, filledPolygon, maskedImage);
    
    return maskedImage;
}

Mat LaneDetector::draw_lines(Mat image, vector<Vec4i> lines) {
    
    vector<double> rightSlope, leftSlope, rightIntercept, leftIntercept;
    
    for (int i=0; i<lines.size(); i++) {
        Vec4i line = lines[i];
        double x1 = line[0];
        double y1 = line[1];
        double x2 = line[2];
        double y2 = line[3];
        
        double yDiff = y1-y2;
        double xDiff = x1-x2;
        double slope = yDiff/xDiff;
        double yIntecept = y2 - (slope*x2);
        
        if ((slope > 0.3) && (x1 > 500)) {
            rightSlope.push_back(slope);
            rightIntercept.push_back(yIntecept);
        } else if ((slope < -0.3) && (x1 < 600)) {
            leftSlope.push_back(slope);
            leftIntercept.push_back(yIntecept);
        }
    }
    
    double leftAvgSlope = getAverage(leftSlope, 30);
    double leftAvgIntercept = getAverage(leftIntercept, 30);
    double rightAvgSlope = getAverage(rightSlope, 30);
    double rightAvgIntercept = getAverage(rightIntercept, 30);
    
    int leftLineX1 = int(((0.65*image.rows) - leftAvgIntercept)/leftAvgSlope);
    int leftLineX2 = int((image.rows - leftAvgIntercept)/leftAvgSlope);
    int rightLineX1 = int(((0.65*image.rows) - rightAvgIntercept)/rightAvgSlope);
    int rightLineX2 = int((image.rows - rightAvgIntercept)/rightAvgSlope);
    
    Point shape[1][4];
    shape[0][0] = Point(leftLineX1, int(0.65*image.rows));
    shape[0][1] = Point(leftLineX2, int(image.rows));
    shape[0][2] = Point(rightLineX2, int(image.rows));
    shape[0][3] = Point(rightLineX1, int(0.65*image.rows));
    
    const Point* polygonPoints[1] = { shape[0] };
    int numberOfPoints[] = { 4 };
    int numberOfPolygons = 1;
    Scalar fillColor(0, 0, 255);
    fillPoly(image, polygonPoints, numberOfPoints, numberOfPolygons, fillColor);
    
    Scalar rightColor(0,255,0);
    Scalar leftColor(255,0,0);
    line(image, shape[0][0], shape[0][1], leftColor, 10);
    line(image, shape[0][3], shape[0][2], rightColor, 10);
    
    return image;
}

Mat LaneDetector::detect_edges(Mat image) {
    
    Mat greyScaledImage;
    cvtColor(image, greyScaledImage, CV_RGB2GRAY);
    
    Mat edgedOnlyImage;
    Canny(greyScaledImage, edgedOnlyImage, 50, 120);
    
    return edgedOnlyImage;
}
