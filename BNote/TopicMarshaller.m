//
//  TopicMarshaller.m
//  BeNote
//
//  Created by kristin young on 8/17/12.
//
//

#import "TopicMarshaller.h"
#import "Topic.h"
#import "BNoteMarshallingManager.h"

@implementation TopicMarshaller

- (BOOL)accept:(id)obj
{
    return [obj isKindOfClass:[Topic class]];
}

- (void)marshall:(Topic *)topic into:(BNoteExportFileWrapper *)file
{
    for (Note *note in topic.notes) {
        [[BNoteMarshallingManager instance] marshall:note into:file];
    }
    
    for (Note *note in topic.associatedNotes) {
        [[BNoteMarshallingManager instance] marshall:note into:file];
    }
}

@end
