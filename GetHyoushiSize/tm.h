//
//  tm.h
//  GetHyoushiSize
//
//  Created by 内山和也 on 2016/12/19.
//  Copyright (c) 2016年 内山和也. All rights reserved.
//

#ifndef __GetHyoushiSize__tm__
#define __GetHyoushiSize__tm__

#include <iostream>
#include <opencv/cv.h>
#include <opencv/cxcore.h>
#include <opencv/cxcore.h>
#include <opencv/highgui.h>
#include <opencv2/core/core.hpp>
#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/highgui/highgui.hpp>

using namespace std;

void cropImage(char* src, char* location, int x, int y, int w, int h);
void cropImageRotate(char* src, char* location, int x, int y, int w, int h);
void cropHalfRight(char* src, char* location);
void cropHalfLeft(char* src, char* location);
cv::Size getImageSize(char* src);
void makeOverlayImage(char* src, char* alpha);
void writeRect(int x, int y, int width, int height, char* moji, char* src);
void makeAlhaBlend(char* src, char* alpha);
//double templateDetectScore2(char* src, char* tmp, double Scale);
//CvRect templateDetectScore(char* src, char* tmp, double Scale);
CvRect templateDetectScore2(char* src, char* tmp, double Scale, int width, int height);
CvRect templateDetectScore(char* src, char* tmp, double Scale, int width, int height, bool isR);
#endif /* defined(__GetHyoushiSize__tm__) */
