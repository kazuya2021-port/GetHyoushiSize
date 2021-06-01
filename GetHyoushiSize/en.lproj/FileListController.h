//
//  FileListController.h
//  GetHyoushiSize
//
//  Created by 内山和也 on 2016/12/19.
//  Copyright (c) 2016年 内山和也. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Macros.h"


@interface FileListController : NSObject {
	NSMutableArray*		  daiwariData;
	IBOutlet NSTableView* tableDaiwari;
	IBOutlet NSWindow*	  mywin;
	IBOutlet Macros*	ms;
    IBOutlet NSTextField* sc;
    IBOutlet NSTextField* DocWidth;
    IBOutlet NSTextField* DocHeight;
    NSString* tomboName;
    NSMutableArray* tomboData;
    NSMutableArray* tukaData;

    NSDictionary* currentTombo;
    
}

- (IBAction)changeTombo:(id)sender;
- (IBAction)addBox:(id)sender;

@property (assign)	NSTableView* tableDaiwari;
@property (assign)	NSWindow* mywin;

- (NSMutableArray*)daiwariData;
- (void)setDaiwariData:(NSMutableArray*)ar;
//-(NSPoint)getLUTombo:(NSString*)file;

- (IBAction)clearFileList:(id)sender;

@end
