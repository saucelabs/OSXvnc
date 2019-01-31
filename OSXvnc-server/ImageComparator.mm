//
//  ImageComparator.m
//  OSXvnc-server
//
//  Created by Mykola Mokhnach on 31.01.19.
//

#import "opencv2/core.hpp"
#import "opencv2/imgproc.hpp"
#import "ImageComparator.h"

@implementation ImageComparator

+ (BOOL)compareImage1:(char *)img1Buffer
             toImage2:(char *)img2Buffer
                width:(size_t)width
               height:(size_t)height
        bytesPerPixel:(char)bytesPerPixel
           rectangles:(char **)rectangles
      rectanglesCount:(size_t *)rectanglesCount
{
    cv::Mat img1 = cv::Mat((int)height, (int)width, CV_8UC4, img1Buffer, bytesPerPixel * width);
    cv::Mat img1BW;
    cvtColor(img1, img1BW, CV_BGR2GRAY);
    cv::Mat img2 = cv::Mat((int)height, (int)width, CV_8UC4, img2Buffer, bytesPerPixel * width);
    cv::Mat img2BW;
    cvtColor(img2, img2BW, CV_BGR2GRAY);
    cv::Mat diff;
    absdiff(img1BW, img2BW, diff);
    img1BW.release();
    img2BW.release();
    cv::Mat thresh;
    threshold(diff, thresh, 0, 255, cv::THRESH_BINARY_INV | cv::THRESH_OTSU);
    diff.release();

    std::vector< std::vector<cv::Point> > contours;
    std::vector<cv::Vec4i> hierarchy;
    findContours(thresh, contours, hierarchy, CV_RETR_TREE, cv::CHAIN_APPROX_SIMPLE);
    char *boxes = (char *)malloc(contours.size() * sizeof(BoxRec));
    if (!boxes) {
        return NO;
    }
    size_t boxesIdx = 0;
    for (int i = 0; i < contours.size(); ++i) {
        if (hierarchy[i][2] < 0) {
            // Only get leaf contours
            continue;
        }
        cv::Rect box = boundingRect(contours[i]);
        BoxRec boxRec;
        boxRec.x1 = box.x;
        boxRec.y1 = box.y;
        boxRec.x2 = box.x + box.width;
        boxRec.y2 = box.y + box.height;
        memcpy(boxes + boxesIdx++ * sizeof(BoxRec), &boxRec, sizeof(BoxRec));
    }
    thresh.release();
    *rectangles = boxes;
    *rectanglesCount = boxesIdx;
    return YES;
}

@end
