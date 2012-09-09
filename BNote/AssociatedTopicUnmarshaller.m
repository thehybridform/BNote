//
//  AssociatedTopicUnmarshaller.m
//  BeNote
//
//  Created by kristin young on 8/30/12.
//
//

#import "AssociatedTopicUnmarshaller.h"

@implementation AssociatedTopicUnmarshaller

- (NSString *)nodeName
{
    return kAssociatedTopicName;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)text
{
    NSString *string = [BNoteStringUtils trim:text];
    
    switch (self.nodeType) {
        case TopicTitleNode:
        {
            self.topic = [self findOrCreateTopic:string];
            [self.note addAssociatedTopicsObject:self.topic];
        }
            break;
            
        case TopicColorNode:
            self.topic.color = [BNoteXmlConstants longFromString:string];
            
            break;
            
        default:
            break;
    }
}

@end

