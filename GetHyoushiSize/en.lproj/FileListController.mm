//
//  FileListController.m
//  GetHyoushiSize
//
//  Created by 内山和也 on 2016/12/19.
//  Copyright (c) 2016年 内山和也. All rights reserved.
//

#import "FileListController.h"
#import "templateWrapper.h"
#define MyPrivateTableViewDataType @"MyPrivateTableViewDataType"

@interface PhotoshopController : NSObject
- (void)setParams:(NSArray*)param;
- (void)saveImage:(NSString*)filePath;
@end

@implementation FileListController

@synthesize tableDaiwari;
@synthesize mywin;

#define TUKAMAX 200
- (IBAction)changeTombo:(id)sender
{
    NSComboBox* b = (NSComboBox*)sender;
    NSString* selectedItem = (NSString*)[b objectValueOfSelectedItem];
    if([selectedItem isEqualToString:@"ルビー"])
    {
        for(NSDictionary* dic in tomboData)
        {
            if([[dic objectForKey:@"Name"] isEqualToString:@"R"])
            {
                currentTombo = dic;
                break;
            }
        }
        [DocHeight setStringValue:@"149"];
    }
    else if([selectedItem isEqualToString:@"スニーカー"])
    {
        for(NSDictionary* dic in tomboData)
        {
            if([[dic objectForKey:@"Name"] isEqualToString:@"S"])
            {
                currentTombo = dic;
                break;
            }
        }
        [DocHeight setStringValue:@"149"];
    }
    else if([selectedItem isEqualToString:@"ビーンズ"])
    {
        for(NSDictionary* dic in tomboData)
        {
            if([[dic objectForKey:@"Name"] isEqualToString:@"B"])
            {
                currentTombo = dic;
                break;
            }
        }
        [DocHeight setStringValue:@"149"];
    }
    else if([selectedItem isEqualToString:@"ホラー"])
    {
        for(NSDictionary* dic in tomboData)
        {
            if([[dic objectForKey:@"Name"] isEqualToString:@"H"])
            {
                currentTombo = dic;
                break;
            }
        }
        [DocHeight setStringValue:@"149"];
    }
    else if([selectedItem isEqualToString:@"B♥PRINCE"])
    {
        for(NSDictionary* dic in tomboData)
        {
            if([[dic objectForKey:@"Name"] isEqualToString:@"BP"])
            {
                currentTombo = dic;
                break;
            }
        }
        [DocHeight setStringValue:@"148"];
    }
    else if([selectedItem isEqualToString:@"ドラゴン"])
    {
        for(NSDictionary* dic in tomboData)
        {
            if([[dic objectForKey:@"Name"] isEqualToString:@"DB"])
            {
                currentTombo = dic;
                break;
            }
        }
        [DocHeight setStringValue:@"148"];
    }
    else if([selectedItem isEqualToString:@"ファンタジア"])
    {
        for(NSDictionary* dic in tomboData)
        {
            if([[dic objectForKey:@"Name"] isEqualToString:@"FA"])
            {
                currentTombo = dic;
                break;
            }
        }
        [DocHeight setStringValue:@"148"];
    }
    else if([selectedItem isEqualToString:@"MW文庫"])
    {
        for(NSDictionary* dic in tomboData)
        {
            if([[dic objectForKey:@"Name"] isEqualToString:@"MW"])
            {
                currentTombo = dic;
                break;
            }
        }
        [DocHeight setStringValue:@"149"];
    }
    else if([selectedItem isEqualToString:@"電撃文庫"])
    {
        for(NSDictionary* dic in tomboData)
        {
            if([[dic objectForKey:@"Name"] isEqualToString:@"D"])
            {
                currentTombo = dic;
                break;
            }
        }
        [DocHeight setStringValue:@"149"];
    }
}



- (IBAction)addBox:(id)sender
{
    // 前提条件
    // 1.MediaBoxはPDFのサイズ
    // 2.データはドキュメントの真ん中
    
    for(int i = 0; i < [daiwariData count]; i++)
    {
        NSString* curFilePath = [[daiwariData objectAtIndex:i] objectAtIndex:1];
        NSString* tukaHaba = [[daiwariData objectAtIndex:i] objectAtIndex:2];
        NSString* savePath = [[ms getCurDir:curFilePath] stringByAppendingPathComponent:APPEND_STR([ms getFileName:curFilePath], @"_test.pdf")];
        int docw = [[[daiwariData objectAtIndex:i] objectAtIndex:3] intValue];
        int doch = [[[daiwariData objectAtIndex:i] objectAtIndex:4] intValue];
        double w = ((double)docw * 2) + [tukaHaba doubleValue];
        double h = (double)doch;
        
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        NSTask *task = [[NSTask alloc] init];
        NSPipe *pipe = [[NSPipe alloc] init];
        
        double wide = [ms mmToPoint:w];
        double high = [ms mmToPoint:h];
        
        NSString* wstr = [NSString stringWithFormat:@"%.13f",wide];
        NSString* hstr = [NSString stringWithFormat:@"%.13f",high];
        NSString *cmd = APPEND_STR(@"cd ", RESPATH, @"; osascript add_box_pdf.scpt \"",
                                   [[@"/" stringByAppendingPathComponent:[ms getVolumeName:curFilePath]] stringByAppendingPathComponent:curFilePath], @"\" \"",
                                   [[@"/" stringByAppendingPathComponent:[ms getVolumeName:curFilePath]] stringByAppendingPathComponent:savePath], @"\" ",
                                   wstr,@" ",
                                   hstr,@" ");
        NSLog(@"%@",cmd);
        
        [task setLaunchPath:@"/bin/sh"];
        [task setArguments:[NSArray arrayWithObjects:@"-c", cmd, nil]];
        [task setStandardOutput:pipe];
        [task launch];
        
        [task release];
        [pipe release];
        [pool release];
    }
//     stringByAppendingPathComponent:@"tmp.jpg"]

    // 幅は105*2+束幅で計算できる

    // 高さはUIで決める
    // 左上のトンボの位置を割り出す
/*    NSPoint p = [self getLUTombo:curFilePath];
    LPoint(@"左上",p);*/
    
}



- (NSString*)searchType:(NSArray*)types
{
	for(int i = 0; i < [types count]; i++)
	{
		if ([[types objectAtIndex:i] isEqualToString:MyPrivateTableViewDataType])
		{
			return MyPrivateTableViewDataType;
		}
		else if ([[types objectAtIndex:i] isEqualToString:NSFilenamesPboardType])
		{
			return NSFilenamesPboardType;
		}
	}
	return nil;
}

//----------------------------------------------------------------------------//
#pragma mark -
#pragma mark Initialization
//----------------------------------------------------------------------------//
- (id)init
{
	self = [super init];
	if (!self)
	{
		return nil;
	}
    tomboData = [NSMutableArray array];
    tukaData = [NSMutableArray array];
    tomboName = @"";
	daiwariData = [NSMutableArray array];
	[daiwariData retain];
	
	return self;
}


- (void)awakeFromNib
{
	[tableDaiwari registerForDraggedTypes:ARRAY(MyPrivateTableViewDataType,NSFilenamesPboardType)];
    NSDictionary* dicR = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"R", @"Name",
                          @"R_LU.png", @"LU",
                          @"R_RU.jpg", @"RU",
                          @"R_CL.jpg", @"CL",
                          @"R_CR.jpg", @"CR",
                          @"R_LB.jpg", @"LB",
                          nil];
    [tomboData addObject:dicR];
    NSDictionary* dicH = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"H", @"Name",
                          @"H_LU.png", @"LU",
                          @"H_RU.jpg", @"RU",
                          @"H_CL.jpg", @"CL",
                          @"H_CR.jpg", @"CR",
                          @"H_LB.jpg", @"LB",
                          nil];
    [tomboData addObject:dicH];
    NSDictionary* dicB = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"B", @"Name",
                          @"B_LU.png", @"LU",
                          @"B_RU.jpg", @"RU",
                          @"B_CL.jpg", @"CL",
                          @"B_CR.jpg", @"CR",
                          @"B_LB.jpg", @"LB",
                          nil];
    [tomboData addObject:dicB];
    NSDictionary* dicS = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"S", @"Name",
                          @"S_LU.png", @"LU",
                          @"S_RU.jpg", @"RU",
                          @"S_CL.jpg", @"CL",
                          @"S_CR.jpg", @"CR",
                          @"S_LB.jpg", @"LB",
                          nil];
    [tomboData addObject:dicS];
    NSDictionary* dicDB = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"DB", @"Name",
                          @"DB_LU.png", @"LU",
                          @"DB_RU.jpg", @"RU",
                          @"DB_CL.jpg", @"CL",
                          @"DB_CR.jpg", @"CR",
                          @"DB_LB.jpg", @"LB",
                          nil];
    [tomboData addObject:dicDB];
    NSDictionary* dicFA = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"FA", @"Name",
                           @"FA_LU.png", @"LU",
                           @"FA_RU.jpg", @"RU",
                           @"FA_CL.jpg", @"CL",
                           @"FA_CR.jpg", @"CR",
                           @"FA_LB.jpg", @"LB",
                           nil];
    [tomboData addObject:dicFA];
    NSDictionary* dicBP = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"BP", @"Name",
                           @"BP_LU.png", @"LU",
                           @"BP_RU.jpg", @"RU",
                           @"BP_CL.jpg", @"CL",
                           @"BP_CR.jpg", @"CR",
                           @"BP_LB.jpg", @"LB",
                           nil];
    [tomboData addObject:dicBP];
    NSDictionary* dicMW = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"MW", @"Name",
                           @"MW_LU.png", @"LU",
                           @"MW_RU.jpg", @"RU",
                           @"MW_CL.jpg", @"CL",
                           @"MW_CR.jpg", @"CR",
                           @"MW_LB.jpg", @"LB",
                           nil];
    [tomboData addObject:dicMW];
    NSDictionary* dicD = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"D", @"Name",
                           @"D_LU.png", @"LU",
                           @"D_RU.jpg", @"RU",
                           @"D_CL.jpg", @"CL",
                           @"D_CR.jpg", @"CR",
                           @"D_LB.jpg", @"LB",
                           nil];
    [tomboData addObject:dicD];
    [tomboData retain];
    for(int i = 0; i < TUKAMAX; i++)
    {
        double t = 0.5;
        t = (t * (i + 1));
         [tukaData addObject:[NSNumber numberWithDouble:t]];
    }
    [tukaData retain];

    currentTombo = dicR;
    

}

//----------------------------------------------------------------------------//
#pragma mark -
#pragma mark InternalFuncs
//----------------------------------------------------------------------------//

- (NSMutableArray*)daiwariData
{
	return daiwariData;
}

- (void)setDaiwariData:(NSMutableArray*)ar
{
	[ar retain];
	[daiwariData addObject:ar];
	[ar release];
}

// テンプレ画像と対象画像のパスを指定する。
- (CvRect)TemplateDetectRect:(char*)src tmp:(char*)tmp scale:(double)s w:(int)w h:(int)h
{
	CvRect ret = templateDetectScore2(src, tmp, s, w, h);
	
	return ret;
}

- (CvRect)TemplateDetectRectLR:(char*)src tmp:(char*)tmp scale:(double)s w:(int)w h:(int)h isR:(BOOL)R
{
	CvRect ret = templateDetectScore(src, tmp, s, w, h, R);
	
	return ret;
}

- (void)CropImageLeft:(char*)src location:(char*)loc
{
    cropHalfLeft((char*)src,
              (char*)loc);
}

- (void)CropImageRight:(char*)src location:(char*)loc
{
    cropHalfRight((char*)src,
             (char*)loc);
}

// トンボデータを取る時に使おう Resoucesフォルダにhyoushi.jpgが作成される
- (void)makeOriginalJpeg:(NSString*)file
{
    NSURL* op = [NSURL fileURLWithPath:file];
    PDFDocument* doc = [[[PDFDocument alloc] initWithURL:op] autorelease];
    NSData* pdfPage = [ms pdfDataPage:doc];
    NSString* tmpPath = [RESPATH stringByAppendingPathComponent:@"hyoushi.jpg"];
    CGPDFPageRef pdfPageRef = CGPDFDocumentGetPage([doc documentRef], 1);
    CGRect pdfPageRect = CGPDFPageGetBoxRect(pdfPageRef, kCGPDFMediaBox);
    
    [ms pdf2jpg:pdfPage path:tmpPath x:0 y:0 w:pdfPageRect.size.width h:pdfPageRect.size.height scale:10];
}



- (NSString*)checkTuka:(NSString*)file
{
    NSURL* op = [NSURL fileURLWithPath:file];
    PDFDocument* doc = [[[PDFDocument alloc] initWithURL:op] autorelease];
    NSData* pdfPage = [ms pdfDataPage:doc];
    NSString* tmpPath = [RESPATH stringByAppendingPathComponent:@"tmp.jpg"];
    NSString* crpPathL = [RESPATH stringByAppendingPathComponent:@"tmpL.jpg"];
    NSString* crpPathR = [RESPATH stringByAppendingPathComponent:@"tmpR.jpg"];
    CGPDFPageRef pdfPageRef = CGPDFDocumentGetPage([doc documentRef], 1);
    CGRect pdfPageRect = CGPDFPageGetBoxRect(pdfPageRef, kCGPDFMediaBox);
    char* src = (char*)[tmpPath UTF8String];
    
    [ms pdf2jpg:pdfPage path:tmpPath x:(unsigned long)0 y:(pdfPageRect.size.height * ((-1 * 0.25 * [sc intValue]) * 3)) w:pdfPageRect.size.width h:(pdfPageRect.size.height / (unsigned long)4) scale:[sc intValue]];
    
    // 左側を切り抜く
    [self CropImageLeft:src location:(char*)[crpPathL UTF8String]];
    
    // 左中のトンボを探す
    NSString* templatePath = [RESPATH stringByAppendingPathComponent:[currentTombo objectForKey:@"CL"]];
    char* tmp = (char*)[templatePath UTF8String];
    NSImage* clImg = [[NSImage alloc] initWithContentsOfFile:templatePath];
    
    if([sc intValue] != 10)
    {
        NSString* templatePathResize = [RESPATH stringByAppendingPathComponent:@"resCL.jpg"];
        NSImage* resIMG = [ms imageResize:clImg newSize:NSMakeSize([clImg size].width / (10/[sc intValue]),[clImg size].height / (10/[sc intValue]))];
        CGImageRef cgRef = [resIMG CGImageForProposedRect:NULL
                                                 context:nil
                                                   hints:nil];
        NSBitmapImageRep *newRep = [[NSBitmapImageRep alloc] initWithCGImage:cgRef];
        [newRep setSize:[resIMG size]];   // if you want the same resolution
        NSDictionary *imageProps = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:1.0] forKey:NSImageCompressionFactor];
        NSData *jpgData = [newRep representationUsingType:NSJPEGFileType properties:imageProps];
        [jpgData writeToFile:templatePathResize atomically:NO];
        [newRep autorelease];
        tmp = (char*)[templatePathResize UTF8String];
        [clImg release];
        clImg = [[NSImage alloc] initWithContentsOfFile:templatePathResize];
    }
    
    CvRect CLRC = [self TemplateDetectRectLR:(char*)[crpPathL UTF8String] tmp:tmp scale:1.0 w:[clImg size].width h:[clImg size].height isR:YES];

    LRect(@"foudL:", NSMakeRect(CLRC.x, CLRC.y, CLRC.width, CLRC.height));
    
    // 右側を切り抜く
    [self CropImageRight:src location:(char*)[crpPathR UTF8String]];
    
    // 右中のトンボを探す
    templatePath = [RESPATH stringByAppendingPathComponent:[currentTombo objectForKey:@"CR"]];
    tmp = (char*)[templatePath UTF8String];
    NSImage* crImg = [[NSImage alloc] initWithContentsOfFile:templatePath];

    if([sc intValue] != 10)
    {
        NSString* templatePathResize = [RESPATH stringByAppendingPathComponent:@"resCR.jpg"];
        NSImage* resIMG = [ms imageResize:crImg newSize:NSMakeSize([crImg size].width / (10/[sc intValue]),[crImg size].height / (10/[sc intValue]))];
        CGImageRef cgRef = [resIMG CGImageForProposedRect:NULL
                                                  context:nil
                                                    hints:nil];
        NSBitmapImageRep *newRep = [[NSBitmapImageRep alloc] initWithCGImage:cgRef];
        [newRep setSize:[resIMG size]];   // if you want the same resolution
        NSDictionary *imageProps = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:1.0] forKey:NSImageCompressionFactor];
        NSData *jpgData = [newRep representationUsingType:NSJPEGFileType properties:imageProps];
        [jpgData writeToFile:templatePathResize atomically:NO];
        [newRep autorelease];
        tmp = (char*)[templatePathResize UTF8String];
        [crImg release];
        crImg = [[NSImage alloc] initWithContentsOfFile:templatePathResize];
    }
    //CvRect CRRC = [self TemplateDetectRect:(char*)[crpPathR UTF8String] tmp:tmp scale:1.0 w:[crImg size].width h:[crImg size].height];
      CvRect CRRC = [self TemplateDetectRectLR:(char*)[crpPathR UTF8String] tmp:tmp scale:1.0 w:[clImg size].width h:[clImg size].height isR:NO];
    [crImg release];
    LRect(@"foudR:", NSMakeRect(CRRC.x, CRRC.y, CRRC.width, CRRC.height));

    // 束幅を計算
    double jpgwidth = (pdfPageRect.size.width * [sc intValue]);
    jpgwidth = ceil(jpgwidth);
    double cropWidth = (jpgwidth / 2) + 6;
    cropWidth = ceil(cropWidth);
    double rightTombo = cropWidth + CRRC.x;
    //double tukaPx =((rightTombo - (CLRC.x + [clImg size].width)) + 2) / [sc intValue];
    double tukaPx =(rightTombo - (CLRC.x + [clImg size].width)) / [sc intValue];
    [clImg release];
    double tuka = [ms pixcelToMm: tukaPx dpi:72];
    NSNumber* number = [[NSNumber alloc] initWithDouble:tuka];
    NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.minimumFractionDigits = 1;
    formatter.maximumFractionDigits = 1;
    [formatter setRoundingMode:NSNumberFormatterRoundHalfUp];
    NSString* ret = [formatter stringFromNumber:number];
    int tukasizePos = 0;
    for(int i = TUKAMAX - 1; i > 0; i--)
    {
        double t = [[tukaData objectAtIndex:i] doubleValue];
        double formattedTuka = [ret doubleValue];
        double difftuka = (t - formattedTuka);
        if(difftuka < 0.5)
        {
            tukasizePos = i;
            break;
        }
    }
    // 左上(LU)の位置を割り出す
    // 左中(LC)の位置を割り出す
    
    // 右中(RC)の位置を割り出す
    //　(RCの左座標 - LCの右座標) / 3 が束幅
    // バウンディングボックス用のデータを作成(LUの右端座標と下側の座標が始点)
    return [[tukaData objectAtIndex:tukasizePos] stringValue];
}

/*-(NSPoint)getLUTombo:(NSString*)file
{
    NSData* pdfPage = [NSData dataWithContentsOfFile:file];
    NSString* tmpPath = [RESPATH stringByAppendingPathComponent:@"tmp.png"];
    char* src = (char*)[tmpPath UTF8String];
    CGFloat factor = 2016.0/ 72.0;
    [ms pdf2jpgHi:pdfPage path:tmpPath];
    
    // 左上のトンボを探す
    NSString* templatePath = [RESPATH stringByAppendingPathComponent:[currentTombo objectForKey:@"LU"]];
    char* tmp = (char*)[templatePath UTF8String];
    NSImage* clImg = [[NSImage alloc] initWithContentsOfFile:templatePath];
     
    CvRect LURC = [self TemplateDetectRect:src tmp:tmp scale:1.0 w:[clImg size].width h:[clImg size].height];
    
    LRect(@"foud:", NSMakeRect(LURC.x, LURC.y, LURC.width, LURC.height));
    CGFloat xx = ((CGFloat)(LURC.x + [clImg size].width) / factor);
    CGFloat yy = ((CGFloat)(LURC.y + [clImg size].height) / factor);
    /*NSNumber* numberX = [[NSNumber alloc] initWithDouble:x];
    NSNumber* numberY = [[NSNumber alloc] initWithDouble:y];
    NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.minimumFractionDigits = 2;
    formatter.maximumFractionDigits = 2;
    [formatter setRoundingMode:NSNumberFormatterRoundHalfUp];
    double realX = [[formatter stringFromNumber:numberX] doubleValue];
    double realY = [[formatter stringFromNumber:numberY] doubleValue];

//    double realX = [ms pointToMm:xx];
//    double realY = [ms pointToMm:yy];
    NSPoint ret = NSMakePoint(xx,yy);
    
    [clImg release];
    
    return ret;
}
*/
- (void)setDataToTable:(NSArray*)theFiles
				isFile:(BOOL)isFile
{
	if (isFile)
	{
		for (int i = 0; i < [theFiles count]; i++)
		{
			NSString* theFile = [[theFiles objectAtIndex:i] lastPathComponent];
            [self makeOriginalJpeg:[theFiles objectAtIndex:i]];
            
            NSString* tukaData = [self checkTuka:[theFiles objectAtIndex:i]];
			// quoted form
			//NSString* theFilePath = [@"" stringByAppendingFormat:@"\"%@\"",[theFiles objectAtIndex:i]];
			//theFile = [theFile stringByDeletingPathExtension];
			[daiwariData addObject:ARRAY(theFile, [theFiles objectAtIndex:i], tukaData, [DocWidth stringValue], [DocHeight stringValue])];
		}
	}
	else
	{
		NSArray* arFiles = [ms getFileList:[theFiles objectAtIndex:0] deep:NO onlyDir:NO];
		for (int i = 0; i < [arFiles count]; i++)
		{
			NSString* theFile = [[arFiles objectAtIndex:i] lastPathComponent];
            NSString* tukaData = [self checkTuka:[arFiles objectAtIndex:i]];
			// quoted form
			//NSString* theFilePath = [@"" stringByAppendingFormat:@"\"%@\"",[[theFiles objectAtIndex:0] stringByAppendingPathComponent:[arFiles objectAtIndex:i]]];
			[daiwariData addObject:ARRAY(theFile, [arFiles objectAtIndex:i], tukaData, [DocWidth stringValue], [DocHeight stringValue])];
		}
	}
	[tableDaiwari noteNumberOfRowsChanged];
	[tableDaiwari reloadData];
}

- (IBAction)clearFileList:(id)sender
{
	[daiwariData release];
	daiwariData = nil;
	daiwariData = [NSMutableArray array];
	[daiwariData retain];
	[tableDaiwari noteNumberOfRowsChanged];
	[tableDaiwari reloadData];
}

//----------------------------------------------------------------------------//
#pragma mark -
#pragma mark NSTableView
//----------------------------------------------------------------------------//
- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
	if (aTableView == tableDaiwari)
	{
		return [daiwariData count];
	}
	return 0;
}

- (id)tableView:(NSTableView *)aTableView
objectValueForTableColumn:(NSTableColumn *)aTableColumn
			row:(int)rowIndex
{
	if (aTableView == tableDaiwari)
	{
		// ページの列
		if([[aTableColumn identifier] isEqualToString:@"file"])
		{
			return [[daiwariData objectAtIndex:rowIndex] objectAtIndex:0];
		}
		// ファイル名の列
		else if([[aTableColumn identifier] isEqualToString:@"path"])
		{
			return [[daiwariData objectAtIndex:rowIndex] objectAtIndex:1];
		}
        else if([[aTableColumn identifier] isEqualToString:@"tuka"])
		{
			return [[daiwariData objectAtIndex:rowIndex] objectAtIndex:2];
		}
        else if([[aTableColumn identifier] isEqualToString:@"docW"])
		{
			return [[daiwariData objectAtIndex:rowIndex] objectAtIndex:3];
		}
        else if([[aTableColumn identifier] isEqualToString:@"docH"])
		{
			return [[daiwariData objectAtIndex:rowIndex] objectAtIndex:4];
		}
	}
	
	// ここには来ないはず
	return nil;
}

- (void)tableView:(NSTableView *)aTableView
   setObjectValue:(id)anObject
   forTableColumn:(NSTableColumn *)aTableColumn
			  row:(int)rowIndex
{
    if (aTableView == tableDaiwari)
	{
		NSMutableArray* rowData = [daiwariData objectAtIndex:rowIndex];
		NSMutableArray* setData = [[NSMutableArray alloc] initWithCapacity:0];
		
		if ([[aTableColumn identifier] isEqualToString:@"file"])
		{
			[setData addObject:anObject];
			[setData addObject:[rowData objectAtIndex:1]];
		}
		else if ([[aTableColumn identifier] isEqualToString:@"path"])
		{
			[setData addObject:[rowData objectAtIndex:0]];
			[setData addObject:anObject];
		}
        [daiwariData replaceObjectAtIndex:rowIndex withObject:setData];
	}
}


//----------------------------------------------------------------------------//
#pragma mark -
#pragma mark Drag & Drop
//----------------------------------------------------------------------------//
- (BOOL)tableView:(NSTableView *)tv
writeRowsWithIndexes:(NSIndexSet *)rowIndexes
	 toPasteboard:(NSPasteboard*)pboard
{
	// Copy the row numbers to the pasteboard.
	NSData *zNSIndexSetData = [NSKeyedArchiver archivedDataWithRootObject:rowIndexes];
	// MyPrivateTableViewDataType タイプを付加してpboardに書き込み
	[pboard declareTypes:ARRAY(MyPrivateTableViewDataType) owner:self];
	[pboard setData:zNSIndexSetData forType:MyPrivateTableViewDataType];
	return YES;
}

- (NSDragOperation)tableView:(NSTableView*)tv
                validateDrop:(id <NSDraggingInfo>)info
                 proposedRow:(NSInteger)row
       proposedDropOperation:(NSTableViewDropOperation)op
{
	NSDragOperation retOperation = NSDragOperationNone;
	NSArray* dataTypes = [[info draggingPasteboard] types];
	
	if ([[self searchType:dataTypes] isEqualToString:MyPrivateTableViewDataType])
	{
		// 行の移動
		if ([[NSApp currentEvent] modifierFlags] & NSAlternateKeyMask)
		{
			// Option押した場合はコピー
			retOperation = NSDragOperationCopy;
		}
		else
		{
			retOperation = NSDragOperationMove;
		}
		
	}
	else if ([[self searchType:dataTypes] isEqualToString:NSFilenamesPboardType])
	{
		// ファイル／フォルダドロップ時
		retOperation = NSDragOperationCopy;
	}
	return retOperation;
}

- (BOOL)tableView:(NSTableView *)aTableView
       acceptDrop:(id )info
              row:(NSInteger)row
    dropOperation:(NSTableViewDropOperation)operation
{
	
	NSPasteboard* pboard = [info draggingPasteboard];
	NSArray* dataTypes = [pboard types];
	
	if ([[self searchType:dataTypes] isEqualToString:MyPrivateTableViewDataType])
	{
		NSData* rowData = [pboard dataForType:MyPrivateTableViewDataType];
		NSIndexSet* rowIndexes = [NSKeyedUnarchiver unarchiveObjectWithData:rowData];
		NSInteger dragRow = [rowIndexes firstIndex];
		
		if ([info draggingSourceOperationMask] == 15)
		{
			// NSDragOperationMove = 15
			
			// Move the specified row to its new location...
			// if we remove a row then everything moves down by one
			// so do an insert prior to the delete
			// --- depends which way were moving the data!!!
			if (dragRow < row)
			{
				[daiwariData insertObject:[daiwariData objectAtIndex:dragRow] atIndex:row];
				[daiwariData removeObjectAtIndex:dragRow];
				[self.tableDaiwari noteNumberOfRowsChanged];
				[self.tableDaiwari reloadData];
				return YES;
			}
			NSString* tmp = [daiwariData objectAtIndex:dragRow];
			[daiwariData removeObjectAtIndex:dragRow];
			[daiwariData insertObject:tmp atIndex:row];
			[self.tableDaiwari noteNumberOfRowsChanged];
			[self.tableDaiwari reloadData];
			return YES;
		}
		else if ([info draggingSourceOperationMask] == 1)
		{
			// NSDragOperationCopy = 1
			[daiwariData insertObject:[daiwariData objectAtIndex:dragRow] atIndex:row];
			[self.tableDaiwari noteNumberOfRowsChanged];
			[self.tableDaiwari reloadData];
			return YES;
		}
	}
	else if ([[self searchType:dataTypes] isEqualToString:NSFilenamesPboardType])
	{
		NSData* data = [pboard dataForType:NSFilenamesPboardType];
		NSString* errorDescription;
		NSArray* theFiles = [NSPropertyListSerialization propertyListFromData:data mutabilityOption:kCFPropertyListImmutable format:nil errorDescription:&errorDescription];
		if ([ms isDirectory:[theFiles objectAtIndex:0]])
		{
			[self setDataToTable:theFiles isFile:NO];
		}
		else
		{
			[self setDataToTable:theFiles isFile:YES];
		}
		return YES;
	}
	return NO;
}
@end
