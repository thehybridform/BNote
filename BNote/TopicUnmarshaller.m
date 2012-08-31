//
//  TopicUnmarshaller.m
//  BeNote
//
//  Created by kristin young on 8/30/12.
//
//

#import "TopicUnmarshaller.h"
#import "BNoteReader.h"
#import "BNoteFactory.h"

@implementation TopicUnmarshaller
@synthesize topic = _topic;

- (NSString *)nodeName
{
    return kTopic;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:kTopicTitle]) {
        self.nodeType = TopicTitleNode;
    } else if ([elementName isEqualToString:kTopicColor]) {
        self.nodeType = TopicColorNode;
    } else {
        self.nodeType = NoNode;
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)text
{
    NSString *string = [BNoteStringUtils trim:text];
    
    switch (self.nodeType) {
        case TopicTitleNode:
        {
            self.topic = [self findOrCreateTopic:string];
            self.note.topic = self.topic;
        }
            break;
            
        case TopicColorNode:
            self.topic.color = [BNoteXmlConstants longFromString:string];
            self.note.color = self.topic.color;
            
            break;
            
        default:
            break;
    }
}

- (Topic *)findOrCreateTopic:(NSString *)name
{
    Topic *topic = [[BNoteReader instance] getTopicForName:name];
    if (!topic) {
        TopicGroup *group = [[BNoteReader instance] getTopicGroup:kAllTopicGroupName];
        if (!group) {
            group = [BNoteFactory createTopicGroup:kAllTopicGroupName];
        }
        
        topic = [BNoteFactory createTopic:name forGroup:group];
    }
    
    return topic;
}

@end
