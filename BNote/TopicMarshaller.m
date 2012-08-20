//
//  TopicMarshaller.m
//  BeNote
//
//  Created by kristin young on 8/17/12.
//
//

#import "TopicMarshaller.h"
#import "Topic.h"
#import "BNoteXmlFormatter.h"
#import "BNoteMarshallingManager.h"

@implementation TopicMarshaller

static NSString *kTopic = @"topic";

- (BOOL)accept:(id)obj
{
    return [obj isKindOfClass:[Topic class]];
}

- (void)marshall:(Topic *)topic into:(BNoteExportFileWrapper *)file
{
    [self write:[BNoteXmlFormatter openTag:kTopic withAttribute:kId value:topic.id] into:file];
    
    for (Note *note in topic.notes) {
        [[BNoteMarshallingManager instance] marshall:note into:file];
    }
    for (Note *note in topic.associatedNotes) {
        [[BNoteMarshallingManager instance] marshall:note into:file];
    }
    
    NSString *s = [BNoteXmlFormatter node:kCreated withText:[self toString:topic.created]];
    [self write:s into:file];
    
    s = [BNoteXmlFormatter node:kLastUpdated withText:[self toString:topic.lastUpdated]];
    [self write:s into:file];

    [self write:[BNoteXmlFormatter closeTag:kTopic] into:file];
}

@end
