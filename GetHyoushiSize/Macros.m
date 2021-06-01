//
//  Macros.m
//  GetHyoushiSize
//
//  Created by 内山和也 on 2016/12/19.
//  Copyright (c) 2016年 内山和也. All rights reserved.
//

#import "Macros.h"

@implementation Macros


// ピクセル→mm
- (double)pixcelToMm:(double)p dpi:(double)dpi_
{
	return (double)(((p / dpi_)*2.539999983236)*10);
}

// mm→ピクセル
- (double)mmToPixcel:(double)m dpi:(double)dpi_
{
	return (double)((m * dpi_)/25.39999983236);
}

// point mm
-(double)pointToMm:(double)p
{
    //return (0.35278 * p);
    //return (0.3527777777 * p);
    double keisuu =(((double)1.0/(double)72.0) * (double)25.39999983236);
    return keisuu * p;
}

// mm point
-(double)mmToPoint:(double)m
{
    //return (p / 0.35278);
    //return (m/ 0.3527777777);
    double keisuu =(((double)1.0/(double)72.0) * (double)25.39999983236);
    return m / keisuu;
}

- (NSData*)pdfDataPage:(PDFDocument*)doc
{
	PDFPage* page = [doc pageAtIndex:0]; // 1ページ目のみ
	return [page dataRepresentation]; // 処理時間かかる！
}

- (BOOL)pdf2jpg:(NSData*)page path:(NSString*)savePath x:(int)x y:(int)y w:(double)w h:(double)h scale:(int)sc
{
	NSImage* img;
	
	NSPDFImageRep* pdfImageRep = [[NSPDFImageRep alloc] initWithData:page];

	if(!pdfImageRep)
	{
		return NO;
	}
	NSSize size;
	size.width = w * sc;
	size.height = h * sc;
    
	img = [[NSImage alloc] initWithSize:size];
	
	if (!img)
	{
		return NO;
	}
	[img lockFocus];
	[pdfImageRep drawInRect:NSMakeRect(x, y, (int)([pdfImageRep size].width * sc), (int)([pdfImageRep size].height) * sc)];
	[img unlockFocus];
	
	NSData* tiffRep = [img TIFFRepresentation];
	NSBitmapImageRep* imgRep = [[NSBitmapImageRep alloc] initWithData:tiffRep];
	
	if(!imgRep)
	{
		return NO;
	}
    
	// Jpg出力
	NSDictionary* propJPG;
	propJPG = [NSDictionary dictionaryWithObjectsAndKeys:
			   [NSNumber numberWithInt:(unsigned long)1.0],
			   NSImageCompressionFactor,
			   nil];
	NSData* jpgData;
	BOOL  bResult = YES;
	jpgData = [imgRep representationUsingType:NSJPEGFileType properties:propJPG];
	//NSString* fname = [NSString stringWithFormat:@"%s/%s.jpg", [savePath UTF8String],[filename UTF8String]];
	bResult = [jpgData writeToFile:savePath atomically:YES];
	if (!bResult) {
		NSLog(@"Err");
	}

	return bResult;
}

// 左上部分のみ高解像度で切り抜く 高さ1/5 幅1/8
- (BOOL)pdf2jpgHi:(NSData*)page path:(NSString*)savePath
{
    BOOL result = YES;
	NSPDFImageRep* pdfImageRep = [NSPDFImageRep imageRepWithData:page];
    CGFloat factor = 2016.0/72.0;
    
   	if(!pdfImageRep)
	{
        result = NO;
		return result;
	}

    [pdfImageRep setCurrentPage:0];
    
    double x = 0;
    //double y = (pdfImageRep.size.height * (-1 * 0.125 * 7)) * factor;
    double y = 0;
    //double w = (pdfImageRep.size.width * factor) / 5;
    //double h = (pdfImageRep.size.height * factor) / 8;
    double w = (pdfImageRep.size.width * factor);
    double h = (pdfImageRep.size.height * factor);
    NSImage* scaledImage = [[NSImage alloc] initWithSize:NSMakeSize(w, h)];
    [scaledImage lockFocus];
    //[pdfImageRep drawInRect:NSMakeRect((int)x, (int)y, (int)w * 5 , (int)h * 8)];
    [pdfImageRep drawInRect:NSMakeRect((int)x, (int)y, (int)w, (int)h)];
    [scaledImage unlockFocus];

    NSRect proposedRect = NSMakeRect(0, 0, (int)w  , (int)h );
    CGColorSpaceRef colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
    CGContextRef cgContext = CGBitmapContextCreate(NULL, proposedRect.size.width, proposedRect.size.height, 8, 4*proposedRect.size.width, colorSpace, kCGBitmapByteOrderDefault|kCGImageAlphaPremultipliedLast);
    NSGraphicsContext* context = [NSGraphicsContext graphicsContextWithGraphicsPort:cgContext flipped:NO];
    CGContextRelease(cgContext);
    CGImageRef cgImage = [scaledImage CGImageForProposedRect:&proposedRect context:context hints:nil];
    NSURL* sv = [NSURL fileURLWithPath:savePath];
    CGImageDestinationRef destination = CGImageDestinationCreateWithURL(CFBridgingRetain(sv), kUTTypePNG, 1, NULL);
    CGImageDestinationAddImage(destination, cgImage, nil);
    if(!CGImageDestinationFinalize(destination))
    {
        result = NO;
    }
    CFRelease(destination);
    
	return result;
}
/*
-(void)doAppleScript:
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSTask *task = [[NSTask alloc] init];
	NSPipe *pipe = [[NSPipe alloc] init];
	NSString *cmd = APPEND_STR(@"cd ", bundlePath_, @"; osascript ext_pdf.scpt \"", currentPath, @"\" \"", fNameNoExt, @"\" \"", baraSavePath, @"\" ", INT2STR(startPage), @" ", INT2STR(pageKeta));
	NSLog(@"%@",cmd);
	
	[task setLaunchPath:@"/bin/sh"];
	[task setArguments:[NSArray arrayWithObjects:@"-c", cmd, nil]];
	[task setStandardOutput:pipe];
	[task launch];
	
	[task release];
	[pipe release];
	[pool release];
}
*/

- (NSString *)getVolumeName:(NSString *)path {
    // path is the path of a folder
    NSURL *url = [NSURL fileURLWithPath:path];
    NSError *error;
    NSString *volumeName;
    [url getResourceValue:&volumeName forKey:NSURLVolumeNameKey error:&error];
    return volumeName;
}

- (NSString*)doShellScript:(NSArray*)command
{
	//int pid = [[NSProcessInfo processInfo] processIdentifier];
	NSPipe* pipe = [NSPipe pipe];
	NSFileHandle* file = pipe.fileHandleForReading;
	
	NSTask* task = [[NSTask alloc] init];
	task.launchPath = @"/bin/sh";
	task.arguments = command;
	task.standardOutput = pipe;
	
	[task launch];
	
	NSData* data = [file readDataToEndOfFile];
	[file closeFile];
	NSString* output = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	output = [output stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	return output;
}

- (NSString*)getFileExp:(NSString*)path
{
	NSString* topStr = [path substringToIndex:1];
	if([topStr isEqualToString:@"\""])
	{
		// nop
	}
	else {
		path = [path stringByAppendingString:@"\""];
		path = [@"\"" stringByAppendingString:path];
	}
    
	NSString* command1 = [[@"fpath=" stringByAppendingString:path] stringByAppendingString:@";fext=\"${fpath##*.}\" ; echo $fext"];
	NSArray* command = ARRAY(@"-c", command1);
	return [self doShellScript:command];
}

- (NSString*)getFileName:(NSString*)path
{
	NSString* topStr = [path substringToIndex:1];
	if([topStr isEqualToString:@"\""])
	{
		// nop
	}
	else {
		path = [path stringByAppendingString:@"\""];
		path = [@"\"" stringByAppendingString:path];
	}
	
	NSString* command1 = [[@"fpath=" stringByAppendingString:path] stringByAppendingString:@";fname_ext=\"${fpath##*/}\"; fname=\"${fname_ext%.*}\"; echo $fname"];
	NSArray* command = ARRAY(@"-c", command1);
	return [self doShellScript:command];
}

- (NSString*)getCurDir:(NSString*)path
{
	NSString* topStr = [path substringToIndex:1];
	if([topStr isEqualToString:@"\""])
	{
		// nop
	}
	else {
		path = [path stringByAppendingString:@"\""];
		path = [@"\"" stringByAppendingString:path];
	}
	
	NSString* command1 = [[@"fpath=" stringByAppendingString:path] stringByAppendingString:@";fdir=\"${fpath%/*}\"; echo $fdir"];
	NSArray* command = ARRAY(@"-c", command1);
	return [self doShellScript:command];
}

- (BOOL)isFile:(NSString *)path
{
	NSFileManager* myFile = [NSFileManager defaultManager];
	NSDictionary* attr = [myFile attributesOfItemAtPath:path error:nil];
	NSString* a = [attr valueForKey:NSFileType];
	if([a isEqualToString:@"NSFileTypeRegular"])
		return YES;
	else
		return FALSE;
}

- (BOOL)isDirectory:(NSString *)path
{
	NSFileManager* myFile = [NSFileManager defaultManager];
	NSDictionary* attr = [myFile attributesOfItemAtPath:path error:nil];
	NSString* a = [attr valueForKey:NSFileType];
	if([a isEqualToString:@"NSFileTypeDirectory"])
		return YES;
	else
		return FALSE;
}

- (NSArray*)getFileList:(NSString *)path deep:(BOOL)deep onlyDir:(BOOL)onD
{
	NSFileManager*	myFile   = [NSFileManager defaultManager];
	NSArray*		fileList;
	NSMutableArray*	ret		 = [[NSMutableArray alloc]initWithCapacity:0];
	if (deep)
	{
		fileList = [myFile subpathsOfDirectoryAtPath:path error:nil];
	}
	else
	{
		fileList = [myFile contentsOfDirectoryAtPath:path error:nil];
	}
	
	for(int i=0; i<[fileList count]; i++)
	{
		NSString* file = [fileList objectAtIndex:i];
		if([file characterAtIndex:0] == '.') continue; // 隠しファイルは無視
		if (onD)
		{
			if([self isFile:[path stringByAppendingPathComponent:file]]) continue;
			[ret addObject:file];
		}
		else
		{
			if([self isDirectory:[path stringByAppendingPathComponent:file]]) continue;
			[ret addObject:file];
		}
		
		
	}
	return ret;
}

- (NSImage *)imageResize:(NSImage*)anImage newSize:(NSSize)newSize {
    NSImage *sourceImage = anImage;
    [sourceImage setScalesWhenResized:YES];
    
    // Report an error if the source isn't a valid image
    if (![sourceImage isValid]){
        NSLog(@"Invalid Image");
    } else {
        NSImage *smallImage = [[NSImage alloc] initWithSize: newSize];
        [smallImage lockFocus];
        [sourceImage setSize: newSize];
        [[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
        [sourceImage drawAtPoint:NSZeroPoint fromRect:CGRectMake(0, 0, newSize.width, newSize.height) operation:NSCompositeCopy fraction:1.0];
        [smallImage unlockFocus];
        return smallImage;
    }
    return nil;
}

// 引数の数字(文字列)を先頭に0を入れた数字に変換
- (NSString*)paddNumber:(int)keta num:(int)num
{
	NSString* str_num = [NSString stringWithFormat:@"%d",num];
	int numLength = [str_num length];
	
	if(numLength == keta)
	{
		return str_num;
	}
	
	if(numLength < keta)
	{
		int i = 0;
		while (i < (keta - numLength))
		{
			str_num = [@"0" stringByAppendingString:str_num];
			i++;
		}
		return str_num;
	}
	if (numLength > keta)
	{
		return str_num;
	}
	return @"";
}
@end
