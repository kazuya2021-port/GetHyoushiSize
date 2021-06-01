//
//  tm.cpp
//  GetHyoushiSize
//
//  Created by 内山和也 on 2016/12/19.
//  Copyright (c) 2016年 内山和也. All rights reserved.
//

#include "tm.h"

// イメージ切り出し
//
void cropImageRotate(char* src, char* location, int x, int y, int w, int h)
{
	cv::Mat src_img = cv::imread(src,1);
	if(src_img.empty()) return;
	
	cv::Mat roi_img(src_img, cv::Rect(x,y,w,h));
	
	// 180度回転
	float angle = 180;
	cv::Point2f center(roi_img.cols*(unsigned long)0.5, roi_img.rows*(unsigned long)0.5);
	const cv::Mat affine_matrix = cv::getRotationMatrix2D(center, angle, 1.0);
	cv::Mat dst_img;
	cv::warpAffine(roi_img, dst_img, affine_matrix, roi_img.size());
	cv::Mat retData(dst_img, cv::Rect(2,2, w-2, h-2)); //周囲2px切り抜き
	cv::imwrite(location, retData);
	
	return;
}

void cropImage(char* src, char* location, int x, int y, int w, int h)
{
	cv::Mat src_img = cv::imread(src,1);
	if(src_img.empty()) return;
	
	cv::Mat roi_img(src_img, cv::Rect(x,y,w,h));
	cv::Mat retData(roi_img, cv::Rect(2,2, w-2, h-2)); //周囲2px切り抜き
	cv::imwrite(location, retData);
	
	return;
}

void cropHalfRight(char* src, char* location)// 半分プラス6px
{
	cv::Mat src_img = cv::imread(src,1);
	if(src_img.empty()) return;
    
  	cv::Mat roi_img(src_img, cv::Rect((src_img.cols / 2)+6,0,(src_img.cols / 2) - 6,src_img.rows));
    cv::imwrite(location, roi_img);
    
	return;
}

void cropHalfLeft(char* src, char* location)// 半分マイナス6px
{
	cv::Mat src_img = cv::imread(src,1);
	if(src_img.empty()) return;
    
  	cv::Mat roi_img(src_img, cv::Rect(0,0,(src_img.cols / 2) - 6,src_img.rows));
    cv::imwrite(location, roi_img);
    
	return;
}

cv::Size getImageSize(char* src)
{
	cv::Mat src_img = cv::imread(src,1);
	int w = src_img.cols;
	int h = src_img.rows;
	return cv::Size(w,h);
}
void makeOverlayImage(char* src, char* alpha)
{
	cv::Mat src_img = cv::imread(src,1);
	if(src_img.empty()) return;
	
	cv::Mat overlay(cv::Size(src_img.cols, src_img.rows), CV_8UC3, cv::Scalar(255,255,255));
	cv::imwrite(alpha, overlay);
}

void writeRect(int x, int y, int width, int height, char* moji, char* src)
{
	cv::Mat src_img = cv::imread(src,1);
	if(src_img.empty()) return;
	
	int face = cv::FONT_HERSHEY_SIMPLEX;
	
	cv::rectangle(src_img, cv::Point(x,y), cv::Point(x+width,y+height), cv::Scalar(0,0,255), -1, CV_AA);
	cv::putText(src_img, moji, cv::Point(x+(width/ 6), y+height - 10), face, 1.0, cv::Scalar(255,255,255), 3, CV_AA);
	
	cv::imwrite(src, src_img);
}

void makeAlhaBlend(char* src, char* alpha)
{
	IplImage* src1 = cvLoadImage((const char*)src, CV_LOAD_IMAGE_GRAYSCALE);
	if(src1 == NULL) return;
	IplImage* src2 = cvLoadImage((const char*)alpha, CV_LOAD_IMAGE_GRAYSCALE);
	if(src2 == NULL) return;
	int w = src1->width;
	int h = src1->height;
	double a = 0.4;
	double b = 0.6;
	cvSetImageROI(src1, cvRect(0,0,w,h));
	cvSetImageROI(src2, cvRect(0,0,w,h));
	cvAddWeighted(src1, a, src2, b, 0.0, src1);
	cvResetImageROI(src1);
	cvSaveImage(alpha, src1);
}

CvRect templateDetectScore(char* src, char* tmp, double Scale, int width, int height, bool isR) {
	// イメージ入力
	IplImage* ipl_src = cvLoadImage((const char*)src, CV_LOAD_IMAGE_ANYCOLOR | CV_LOAD_IMAGE_ANYDEPTH);
	if(ipl_src == NULL) return cvRect(0,0,0,0);
    
    IplImage* ipl_tmp = cvLoadImage((const char*)tmp, CV_LOAD_IMAGE_ANYCOLOR | CV_LOAD_IMAGE_ANYDEPTH);
	if(ipl_tmp == NULL) return cvRect(0,0,0,0);
    
    // 領域指定
    CvRect sROI = cvRect(0, 0, 0, 0);
    if(!isR) // 左側をチェック
    {
        sROI = cvRect(0,0,ipl_src->width / 2, ipl_src->height);
        cvSetImageROI(ipl_src, sROI);
    }
    else
    {
        sROI = cvRect(ipl_src->width / 2,0,ipl_src->width / 2, ipl_src->height);
        cvSetImageROI(ipl_src, sROI);
    }
	IplImage* ipl_tmp_tmp = cvCreateImage(cvSize(ipl_tmp->width, ipl_tmp->height), IPL_DEPTH_8U, 3);
	cvResize(ipl_tmp,ipl_tmp_tmp,CV_INTER_LINEAR);
	cvReleaseImage(&ipl_tmp);
	
	CvPoint maxLoc = cvPoint(0,0);
	CvPoint minLoc = cvPoint(0,0);
	double maxVal = 0;
	double minVal = 0;
	
	/*IplImage* ipl_src_res = cvCreateImage(cvSize(ipl_src->width / Scale, ipl_src->height / Scale), IPL_DEPTH_8U, 3);
	 cvResize(ipl_src, ipl_src_res, CV_INTER_LINEAR);
	 cvReleaseImage(&ipl_src);*/
	
	IplImage* ipl_tmp_res = cvCreateImage(cvSize(ipl_tmp_tmp->width / Scale, ipl_tmp_tmp->height / Scale), IPL_DEPTH_8U, 3);
	cvResize(ipl_tmp_tmp, ipl_tmp_res, CV_INTER_LINEAR);
	cvReleaseImage(&ipl_tmp_tmp);
	
	CvSize resultSize = cvSize(sROI.width - ipl_tmp_res->width + 1, ipl_src->height - ipl_tmp_res->height + 1);
	IplImage* resultImage = cvCreateImage(resultSize, IPL_DEPTH_32F, 1);
	
	cvMatchTemplate(ipl_src, ipl_tmp_res, resultImage, CV_TM_CCOEFF_NORMED);
	cvMinMaxLoc(resultImage, &minVal, &maxVal, &minLoc, &maxLoc, NULL);
	
	
    /*cvRectangle(ipl_src, maxLoc, cvPoint(maxLoc.x + ipl_tmp_res->width, maxLoc.y + ipl_tmp_res->height), cvScalar(0, 0, 255), 3);
     cvNamedWindow("search image", CV_WINDOW_AUTOSIZE | CV_WINDOW_FREERATIO);
     cvShowImage("search image", ipl_src);
     cvWaitKey(0);
     cvDestroyWindow("search image");
     */
	
	cvReleaseImage(&ipl_src);
	cvReleaseImage(&ipl_tmp_res);
	cvReleaseImage(&resultImage);
	
    CvRect ret = cvRect(maxLoc.x + sROI.x, maxLoc.y, width, height);
	return ret;
}

CvRect templateDetectScore2(char* src, char* tmp, double Scale, int width, int height) {
	// イメージ入力
	IplImage* ipl_src = cvLoadImage((const char*)src, CV_LOAD_IMAGE_ANYCOLOR | CV_LOAD_IMAGE_ANYDEPTH);
	if(ipl_src == NULL) return cvRect(0,0,0,0);
    
    IplImage* ipl_tmp = cvLoadImage((const char*)tmp, CV_LOAD_IMAGE_ANYCOLOR | CV_LOAD_IMAGE_ANYDEPTH);
	if(ipl_tmp == NULL) return cvRect(0,0,0,0);
    
	IplImage* ipl_tmp_tmp = cvCreateImage(cvSize(ipl_tmp->width, ipl_tmp->height), IPL_DEPTH_8U, 3);
	cvResize(ipl_tmp,ipl_tmp_tmp,CV_INTER_LINEAR);
	cvReleaseImage(&ipl_tmp);
	
	CvPoint maxLoc = cvPoint(0,0);
	CvPoint minLoc = cvPoint(0,0);
	double maxVal = 0;
	double minVal = 0;
	
	/*IplImage* ipl_src_res = cvCreateImage(cvSize(ipl_src->width / Scale, ipl_src->height / Scale), IPL_DEPTH_8U, 3);
	 cvResize(ipl_src, ipl_src_res, CV_INTER_LINEAR);
	 cvReleaseImage(&ipl_src);*/
	
	IplImage* ipl_tmp_res = cvCreateImage(cvSize(ipl_tmp_tmp->width / Scale, ipl_tmp_tmp->height / Scale), IPL_DEPTH_8U, 3);
	cvResize(ipl_tmp_tmp, ipl_tmp_res, CV_INTER_LINEAR);
	cvReleaseImage(&ipl_tmp_tmp);
	
	CvSize resultSize = cvSize(ipl_src->width - ipl_tmp_res->width + 1, ipl_src->height - ipl_tmp_res->height + 1);
	IplImage* resultImage = cvCreateImage(resultSize, IPL_DEPTH_32F, 1);
	
	cvMatchTemplate(ipl_src, ipl_tmp_res, resultImage, CV_TM_CCOEFF_NORMED);
	cvMinMaxLoc(resultImage, &minVal, &maxVal, &minLoc, &maxLoc, NULL);
	
	/*
    cvRectangle(ipl_src, maxLoc, cvPoint(maxLoc.x + ipl_tmp_res->width, maxLoc.y + ipl_tmp_res->height), cvScalar(0, 0, 255), 3);
    cvNamedWindow("search image", CV_WINDOW_AUTOSIZE | CV_WINDOW_FREERATIO);
    cvShowImage("search image", ipl_src);
    cvWaitKey(0);
    cvDestroyWindow("search image");
	*/
	
	cvReleaseImage(&ipl_src);
	cvReleaseImage(&ipl_tmp_res);
	cvReleaseImage(&resultImage);
	
    CvRect ret = cvRect(maxLoc.x, maxLoc.y, width, height);
	return ret;
}