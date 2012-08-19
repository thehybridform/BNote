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

static NSString *kTopicGroup = @"topic-group";

- (BOOL)accept:(id)obj
{
    return [obj isKindOfClass:[TopicGroup class]];
}

- (void)marshall:(TopicGroup *)topicGroup into:(NSFileHandle *)file
{
    [self write:[BNoteXmlFormatter openTag:kTopicGroup withAttribute:kId value:topicGroup.id] into:file];
    
    for (Topic *topic in topicGroup.topics) {
        [[BNoteMarshallingManager instance] marshall:topic into:file];
    }
    
    NSString *s = [BNoteXmlFormatter node:kCreated withText:[self toString:topicGroup.created]];
    [self write:s into:file];
    
    s = [BNoteXmlFormatter node:kLastUpdated withText:[self toString:topicGroup.lastUpdated]];
    [self write:s into:file];

    [self write:[BNoteXmlFormatter closeTag:kTopicGroup] into:file];
}

@end
