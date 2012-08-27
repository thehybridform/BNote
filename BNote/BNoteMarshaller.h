//
//  BNoteMarshaller.h
//  BeNote
//
//  Created by kristin young on 8/16/12.
//
//

#import <Foundation/Foundation.h>
#import "BNoteExportFileWrapper.h"

@protocol BNoteMarshaller <NSObject>

- (BOOL)accept:(id)obj;

- (void)marshall:(id)data into:(BNoteExportFileWrapper *)file;

@end
