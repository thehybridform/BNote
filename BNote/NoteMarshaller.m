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

@implementation NoteMarshaller

static NSString *kNote = @"note";
static NSString *kSubject = @"subject";
static NSString *kSummary = @"summary";

- (BOOL)accept:(id)obj
{
    return [obj isKindOfClass:[Note class]];
}

- (void)marshall:(Note *)note into:(NSFileHandle *)file
{
    [self write:[BNoteXmlFormatter openTag:kNote withAttribute:kId value:note.id] into:file];
    
    NSString *s = [BNoteXmlFormatter node:kSubject withText:note.subject];
    [self write:s into:file];
    
    for (Entry *entry in note.entries) {
        [[BNoteMarshallingManager instance] marshall:entry into:file];
    }
    
    s = [BNoteXmlFormatter node:kCreated withText:[self toString:note.created]];
    [self write:s into:file];
    
    s = [BNoteXmlFormatter node:kLastUpdated withText:[self toString:note.lastUpdated]];
    [self write:s into:file];

    s = [BNoteXmlFormatter node:kSummary withText:note.summary];
    [self write:s into:file];

    [self write:[BNoteXmlFormatter closeTag:kNote] into:file];
}

@end