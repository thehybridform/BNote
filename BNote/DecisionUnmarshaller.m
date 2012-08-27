//
//  DecisionUnmarshaller.m
//  BeNote
//
//  Created by kristin young on 8/26/12.
//
//

#import "DecisionUnmarshaller.h"
#import "BNoteFactory.h"
#import "BNoteXmlConstants.h"

@interface DecisionUnmarshaller()
@property (strong, nonatomic) Decision *decision;

@end

@implementation DecisionUnmarshaller
@synthesize decision = _decision;

- (NSString *)nodeName
{
    return kDecision;
}

- (void)reset
{
    self.decision = [BNoteFactory createDecision:self.note];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:kText]) {
        self.nodeType = TextNode;
    } else if ([elementName isEqualToString:kCreated]) {
        self.nodeType = CreatedDateNode;
    } else if ([elementName isEqualToString:kLastUpdated]) {
        self.nodeType = LastUpdatedDateNode;
    } else {
        self.nodeType = NoNode;
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    switch (self.nodeType) {
        case TextNode:
            self.decision.text = string;
            break;
            
        case CreatedDateNode:
            self.decision.created = [BNoteXmlConstants toTimeInterval:string];
            break;
            
        case LastUpdatedDateNode:
            self.decision.lastUpdated = [BNoteXmlConstants toTimeInterval:string];
            break;
            
        default:
            break;
    }
}

@end
