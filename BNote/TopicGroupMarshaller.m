//
//  TopicGroupMarshaller.m
//  BeNote
//
//  Created by kristin young on 8/16/12.
//
//

#import "TopicGroupMarshaller.h"
#import "BNoteMarshallingManager.h"
#import "BNoteXmlFormatter.h"

@implementation TopicGroupMarshaller

- (BOOL)accept:(id)obj
{
    return [obj isKindOfClass:[TopicGroup class]];
}

- (void)marshall:(TopicGroup *)topicGroup into:(BNoteExportFileWrapper *)file
{
    for (Topic *topic in topicGroup.topics) {
        [[BNoteMarshallingManager instance] marshall:topic into:file];
    }
}

@end
