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
#import "Topic.h"

@interface TopicUnmarshaller()
@property (strong, nonatomic) Topic *topic;

@end

@implementation TopicUnmarshaller
@synthesize topic = _topic;
@synthesize associated = _associated;

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
            Topic *topic = [[BNoteReader instance] getTopicForName:string];
            if (!topic) {
                TopicGroup *group = [[BNoteReader instance] getTopicGroup:kAllTopicGroupName];
                if (!group) {
                    group = [BNoteFactory createTopicGroup:kAllTopicGroupName];
                }
                
                topic = [BNoteFactory createTopic:string forGroup:group];
                topic.color = [BNoteXmlConstants longFromString:string];
            }
            
            self.topic = topic;
        }
            break;
            
        case TopicColorNode:
            if (!self.topic.color) {
                self.topic.color = [BNoteXmlConstants longFromString:string];
            }
            
            if (self.associated) {
                [self.note addAssociatedTopicsObject:self.topic];
            } else {
                self.note.topic = self.topic;
            }
            
            break;
            
        default:
            break;
    }
}


@end
