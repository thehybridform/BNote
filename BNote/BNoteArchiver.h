//
//  BNoteArchiver.h
//  BeNote
//
//  Created by kristin young on 8/15/12.
//
//

#import <Foundation/Foundation.h>
#import "Topic.h"
#import "TopicGroup.h"
#import "Note.h"
#import "BNoteExportFileWrapper.h"

@protocol BNoteArchiver <NSObject>

- (NSString *)displayName;
- (NSString *)helpText;

- (BNoteExportFileWrapper *)archiveData:(id)data;
- (BNoteExportFileWrapper *)archiveAll;

@end
