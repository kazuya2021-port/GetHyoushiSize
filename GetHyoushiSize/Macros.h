//
//  Macros.h
//  GetHyoushiSize
//
//  Created by 内山和也 on 2016/12/19.
//  Copyright (c) 2016年 内山和也. All rights reserved.
//

#import <Foundation/Foundation.h>

#define _DEBUG_

#define RESPATH 	[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Contents/Resources"]
#define APPEND_STR(first, ...) [[[NSArray arrayWithObjects: first, ##__VA_ARGS__ , nil] componentsJoinedByString:@","] stringByReplacingOccurrencesOfString:@"," withString:@""]
#define ARRAY(first, ...) [NSArray arrayWithObjects: first, ##__VA_ARGS__ , nil]
#define INT2STR(i) [[NSNumber numberWithInt:i]stringValue]
#define FLT2STR(i) [[NSNumber numberWithFloat:i]stringValue]

#ifdef _DEBUG_
#define L(...)				NSLog(__VA_ARGS__)
#define LRect(title,rect)	NSLog(@"%@: (x, y) = (%.1f, %.1f) (width, height) = (%.1f, %.1f)",title, rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)
#define LSize(title,size)	NSLog(@"%@: (width, height) = (%.1f, %.1f)",title, size.width, size.height)
#define LPoint(title,p)		NSLog(@"%@: (x, y) = (%.1f, %.1f)",title, p.x, p.y)
#else
#define L(...)
#define LRect(title,rect)
#define LSize(title,size)
#define LPoint(title,p)
#endif


@interface Macros : NSObject
{
}
- (IBAction)changeTombo:(id)sender;


- (double)pixcelToMm:(double)p dpi:(double)dpi_;
- (double)mmToPixcel:(double)m dpi:(double)dpi_;
-(double)mmToPoint:(double)p;
-(double)pointToMm:(double)p;
- (NSString *)getVolumeName:(NSString *)path;
- (NSString*)getFileExp:(NSString*)path;
- (NSString*)getFileName:(NSString*)path;
- (NSString*)getCurDir:(NSString*)path;
- (NSArray*)getFileList:(NSString *)path deep:(BOOL)deep onlyDir:(BOOL)onD;
- (BOOL)isDirectory:(NSString *)path;
- (NSString*)paddNumber:(int)keta num:(int)num;
- (NSData*)pdfDataPage:(PDFDocument*)doc;
- (BOOL)pdf2jpg:(NSData*)page path:(NSString*)savePath x:(int)x y:(int)y w:(double)w h:(double)h scale:(int)sc;
- (BOOL)pdf2jpgHi:(NSData*)page path:(NSString*)savePath;
- (NSImage *)imageResize:(NSImage*)anImage newSize:(NSSize)newSize;

@end
