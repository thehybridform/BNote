//
//  BNoteExportFileWrapper.h
//  BeNote
//
//  Created by kristin young on 8/19/12.
//
//

#import <Foundation/Foundation.h>
#import "ZipFile.h"

@interface BNoteExportFileWrapper : NSObject

@property (strong, nonatomic) ZipFile *zipFile;
@property (strong, nonatomic) NSFileHandle *file;
@property (strong, nonatomic) NSString *filename;

@end
