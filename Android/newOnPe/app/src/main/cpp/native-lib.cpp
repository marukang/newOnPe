#include <jni.h>
#include <string>
#include <jni.h>
#include <opencv2/opencv.hpp>
#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>
#include <sstream>
#include <string>
#include <iostream>
#include <vector>
#include <iostream>

using namespace cv;
using namespace std;

extern "C"
JNIEXPORT jstring JNICALL
Java_com_funidea_newonpe_JugglingActivity_opencvred(JNIEnv *env, jobject thiz,
                                                   jlong mat_addr_input,
                                                   jlong mat_addr_result) {
    Mat &img_input = *(Mat *) mat_addr_input;
    Mat &img_output = *(Mat *) mat_addr_result;

    //ret, img_color = cap.read()

    Scalar red(0, 0, 255);

    Mat rgb_color = Mat(1, 1, CV_8UC3, red);
    Mat hsv_color;

    cvtColor(rgb_color, hsv_color, COLOR_BGR2HSV);

    Mat img_frame = img_input;
    Mat img_hsv;

    cvtColor(img_frame, img_hsv, COLOR_BGR2HSV);



    Mat img_mask1;
    int hue_red = 120;


    int lower_red = (hue_red - 15, 200, 0);
    int upper_red = (hue_red + 15, 255, 255);

    //inRange(img_hsv, Scalar(low_hue1, 50, 50), Scalar(high_hue1, 255, 255), img_mask1);
    //img_mask1 = inRange(img_hsv, lower_red, upper_red)
    //기
    //inRange(img_hsv, Scalar(hue_red - 10, 50, 50), Scalar(hue_red + 10, 255, 255), img_mask1);
    inRange(img_hsv, Scalar(hue_red - 10, 150, 150), Scalar(hue_red + 10, 255, 255), img_mask1);




    /////////////////////////////////////////////////////////////////


    //    kernel1 = cv.getStructuringElement(cv.MORPH_RECT, (5, 5))
    //    kernel2 = cv.getStructuringElement(cv.MORPH_RECT, (5, 5))
    Mat kernel1 = getStructuringElement(MORPH_RECT, Size(5, 5));


    //    img_mask1 = cv.morphologyEx(img_mask1, cv.MORPH_DILATE, kernel1, iterations = 3)
    //    img_mask2 = cv.morphologyEx(img_mask2, cv.MORPH_DILATE, kernel2, iterations = 3)
    dilate(img_mask1, img_mask1, kernel1, Point(-1, -1), 3);



    //    nlabels1, labels1, stats1, centroids1 = cv.connectedComponentsWithStats(img_mask1)
    //    nlabels2, labels2, stats2, centroids2 = cv.connectedComponentsWithStats(img_mask2)
    Mat labels1, stats1, centroids1;

    int nlabels1 = connectedComponentsWithStats(img_mask1, labels1, stats1, centroids1, 8, CV_32S);



    int max1 = -1;
    int max_index1 = -1;

    int center_x1 = 0;
    int center_y1 = 0;

    for (int i = 1; i < nlabels1; i++) {



        if(i<1){
            continue;
        }


        int area1 = stats1.at<int>(i, CC_STAT_AREA);

        if (area1 > max1) {
            max1 = area1;
            max_index1 = i;
        }
    }


    if (max_index1 != -1) {


        center_x1 = centroids1.at<double>(max_index1, 0);
        center_y1 = centroids1.at<double>(max_index1, 1);

        int left1 = stats1.at<int>(max_index1, CC_STAT_LEFT);
        int top1 = stats1.at<int>(max_index1, CC_STAT_TOP);
        int width1 = stats1.at<int>(max_index1, CC_STAT_WIDTH);
        int height1 = stats1.at<int>(max_index1, CC_STAT_HEIGHT);


        if ((width1 > 40) & (40 < height1)) {

            //rectangle(img_frame, Point(left1, top1), Point(left1 + width1, top1 + height1), Scalar(255, 0, 0), 5);
            circle(img_frame, Point(center_x1, center_y1), 20, Scalar(255,255,255), -1, 8, 0);
        }

    }


    img_output = img_frame;


    //convert c-string to java-string
    std::string msg = to_string(center_x1) + ","+ to_string(center_y1);
    jstring ret = env->NewStringUTF(msg.c_str());
    return ret;

}

extern "C"
JNIEXPORT int JNICALL
Java_com_funidea_newonpe_JugglingActivity_opencvblue(JNIEnv *env, jobject thiz,
                                                    jlong mat_addr_input,
                                                    jlong mat_addr_result) {
    Mat &img_input = *(Mat *) mat_addr_input;
    Mat &img_output = *(Mat *) mat_addr_result;


//    // 이 부분은 필요 없는듯
//    Scalar red(0, 0, 255);
//    Mat rgb_color = Mat(1, 1, CV_8UC3, red);
//    Mat hsv_color;
//    cvtColor(rgb_color, hsv_color, COLOR_BGR2HSV);


    Mat img_frame = img_input;
    Mat img_hsv;

    cvtColor(img_frame, img_hsv, COLOR_BGR2HSV);


    Mat img_mask1;


    //int hue_red = 120;
    int hue_blue = 0;


    //inRange(img_hsv, Scalar(low_hue1, 50, 50), Scalar(high_hue1, 255, 255), img_mask1);
    //img_mask1 = inRange(img_hsv, lower_red, upper_red)
    inRange(img_hsv, Scalar(hue_blue -10, 70, 70), Scalar(hue_blue + 10, 255, 255), img_mask1);


    /////////////////////////////////////////////////////////////////


    //    kernel1 = cv.getStructuringElement(cv.MORPH_RECT, (5, 5))
    //    kernel2 = cv.getStructuringElement(cv.MORPH_RECT, (5, 5))
    Mat kernel1 = getStructuringElement(MORPH_RECT, Size(5, 5));


    //    img_mask1 = cv.morphologyEx(img_mask1, cv.MORPH_DILATE, kernel1, iterations = 3)
    //    img_mask2 = cv.morphologyEx(img_mask2, cv.MORPH_DILATE, kernel2, iterations = 3)
    dilate(img_mask1, img_mask1, kernel1, Point(-1, -1), 3);



    //    nlabels1, labels1, stats1, centroids1 = cv.connectedComponentsWithStats(img_mask1)
    //    nlabels2, labels2, stats2, centroids2 = cv.connectedComponentsWithStats(img_mask2)
    Mat labels1, stats1, centroids1;

    int nlabels1 = connectedComponentsWithStats(img_mask1, labels1, stats1, centroids1, 8, CV_32S);



    int max1 = -1;
    int max_index1 = -1;


    for (int i = 1; i < nlabels1; i++) {



        if(i<1){
            continue;
        }


        int area1 = stats1.at<int>(i, CC_STAT_AREA);

        if (area1 > max1) {
            max1 = area1;
            max_index1 = i;
        }
    }


    if (max_index1 != -1) {


        int center_x1 = centroids1.at<double>(max_index1, 0);
        int center_y1 = centroids1.at<double>(max_index1, 1);

        int left1 = stats1.at<int>(max_index1, CC_STAT_LEFT);
        int top1 = stats1.at<int>(max_index1, CC_STAT_TOP);
        int width1 = stats1.at<int>(max_index1, CC_STAT_WIDTH);
        int height1 = stats1.at<int>(max_index1, CC_STAT_HEIGHT);


        if ((width1 > 40) & (40 < height1)) {
            rectangle(img_frame, Point(left1, top1), Point(left1 + width1, top1 + height1), Scalar(255, 0, 0), 5);
            //circle(img_frame,Point(center_x1,center_y1),20,Scalar(0, 0, 255),3,-1,0);
        }

    }



    img_output = img_frame;

    //리턴값 필요
    return 0;
}


extern "C"
JNIEXPORT jstring JNICALL
Java_com_funidea_newonpe_JugglingActivity_opencvboth(JNIEnv *env, jobject thiz,
                                                    jlong mat_addr_input,
                                                    jlong mat_addr_result) {
    Mat &img_input = *(Mat *) mat_addr_input;
    Mat &img_output = *(Mat *) mat_addr_result;
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
    jstring ret = env->NewStringUTF(msg.c_str());
    return ret;

//    //리턴값 필요
//    return 0;
}

//extern "C"
//JNIEXPORT int JNICALL
//Java_com_funidea_newonpe_JugglingActivity_opencvround(JNIEnv *env, jobject thiz,
//                                                     jlong mat_addr_input, jlong mat_addr_result) {
//    Mat &img_input = *(Mat *) mat_addr_input;
//    Mat &img_output = *(Mat *) mat_addr_result;
//    //ret, img_color = cap.read()
//
//
//    cvtColor(img_input, img_input,COLOR_BGR2GRAY);
//
//
//    Mat img_houghC;
//    img_houghC = img_input;
//
//    vector<Vec3f> circles;
//    HoughCircles(img_houghC, circles, HOUGH_GRADIENT, 1, 70, 60, 80, 0, 0);
//
//    cvtColor(img_houghC, img_houghC,COLOR_BGR2HSV);
//
//    for (size_t i = 0; i < circles.size(); i++)
//    {
//        Vec3i c = circles[i];
//        Point center(c[0], c[1]);
//        int radius = c[2];
//
//        circle(img_houghC, center, radius, Scalar(0, 255, 0), 20);
//        circle(img_houghC, center, 2, Scalar(0, 0, 255), 20);
//    }
//
//
//    img_output = img_houghC;
//
//    //리턴값 필요
//    return 0;
//}

