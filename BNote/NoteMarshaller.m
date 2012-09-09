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
#import "Topic.h"
#import "BNoteXmlConstants.h"

@implementation NoteMarshaller

- (BOOL)accept:(id)obj
{
    return [obj isKindOfClass:[Note class]];
}

- (void)marshall:(Note *)note into:(BNoteExportFileWrapper *)file
{
    if ([[BNoteMarshallingManager instance].marshalledNotes containsObject:note]) {
        return;
    }
    
    [self write:[BNoteXmlFormatter openTag:kNote] into:file];
    
    NSString *s = [BNoteXmlFormatter node:kSubject withText:note.subject];
    [self write:s into:file];
    
    for (Entry *entry in note.entries) {
        if ([entry isKindOfClass:[Attendants class]]) {
            [[BNoteMarshallingManager instance] marshall:entry into:file];
        }
    }
    
    for (Entry *entry in note.entries) {
        if (![entry isKindOfClass:[Attendants class]]) {
            [[BNoteMarshallingManager instance] marshall:entry into:file];
        }
    }
    
    s = [BNoteXmlFormatter node:kSummary withText:note.summary];
    [self write:s into:file];
    
    s = [BNoteXmlFormatter node:kCreated withText:[BNoteXmlConstants toString:note.created]];
    [self write:s into:file];
    
    s = [BNoteXmlFormatter node:kLastUpdated withText:[BNoteXmlConstants toString:note.lastUpdated]];
    [self write:s into:file];

    
    [self writeTopic:note.topic into:file forNodeName:kTopic];
    
    for (Topic *topic in note.associatedTopics) {
        [self writeTopic:topic into:file forNodeName:kAssociatedTopicName];
    }
    
    [self write:[BNoteXmlFormatter closeTag:kNote] into:file];
    
    [[BNoteMarshallingManager instance].marshalledNotes addObject:note];
}

- (void)writeTopic:(Topic *)topic into:(BNoteExportFileWrapper *)file forNodeName:(NSString *)name
{
    [self write:[BNoteXmlFormatter openTag:name] into:file];
    
    NSString *s = [BNoteXmlFormatter node:kTopicTitle withText:topic.title];
    [self write:s into:file];
    
    s = [BNoteXmlFormatter node:kTopicColor withText:[BNoteXmlConstants colorToString:topic.color]];
    [self write:s into:file];
    
    [self write:[BNoteXmlFormatter closeTag:name] into:file];
}

@end