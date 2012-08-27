//
//  NoteMarshaller.m
//  BeNote
//
//  Created by kristin young on 8/17/12.
//
//

#import "NoteMarshaller.h"
#import "BNoteXmlFormatter.h"
#import "BNoteMarshallingManager.h"
#import "Note.h"
#import "Topic.h"
#import "BNoteXmlConstants.h"

@implementation NoteMarshaller

- (BOOL)accept:(id)obj
{
    return [obj isKindOfClass:[Note class]];
}

- (void)marshall:(Note *)note into:(BNoteExportFileWrapper *)file
{
    [self write:[BNoteXmlFormatter openTag:kNote] into:file];
    
    NSString *s = [BNoteXmlFormatter node:kSubject withText:note.subject];
    [self write:s into:file];
    
    for (Entry *entry in note.entries) {
        [[BNoteMarshallingManager instance] marshall:entry into:file];
    }
    
    s = [BNoteXmlFormatter node:kNoteColor withText:[BNoteXmlConstants colorToString:note.color]];
    [self write:s into:file];
    
    s = [BNoteXmlFormatter node:kSummary withText:note.summary];
    [self write:s into:file];
    
    s = [BNoteXmlFormatter node:kCreated withText:[BNoteXmlConstants toString:note.created]];
    [self write:s into:file];
    
    s = [BNoteXmlFormatter node:kLastUpdated withText:[BNoteXmlConstants toString:note.lastUpdated]];
    [self write:s into:file];

    s = [BNoteXmlFormatter node:kTopicName withText:note.topic.title];
    [self write:s into:file];
    
    [self write:[BNoteXmlFormatter closeTag:kNote] into:file];
}

@end