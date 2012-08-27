//
//  KeyPointUnmarshaller.m
//  BeNote
//
//  Created by kristin young on 8/26/12.
//
//

#import "KeyPointUnmarshaller.h"
#import "BNoteFactory.h"
#import "BNoteXmlConstants.h"
#import "KeyPoint.h"

@interface KeyPointUnmarshaller()
@property (strong, nonatomic) KeyPoint *keyPoint;

@end

@implementation KeyPointUnmarshaller
@synthesize keyPoint = _keyPoint;

- (NSString *)nodeName
{
    return kKeyPoint;
}

- (void)reset
{
    self.keyPoint = [BNoteFactory createKeyPoint:self.note];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:kText]) {
        self.nodeType = TextNode;
    } else if ([elementName isEqualToString:kCreated]) {
        self.nodeType = CreatedDateNode;
    } else if ([elementName isEqualToString:kLastUpdated]) {
        self.nodeType = LastUpdatedDateNode;
    } else if ([elementName isEqualToString:kPhoto]) {
        self.nodeType = PhotoNode;
    } else {
        self.nodeType = NoNode;
    }    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    switch (self.nodeType) {
        case TextNode:
            self.keyPoint.text = string;
            break;
            
        case CreatedDateNode:
            self.keyPoint.created = [BNoteXmlConstants toTimeInterval:string];
            break;
            
        case LastUpdatedDateNode:
            self.keyPoint.lastUpdated = [BNoteXmlConstants toTimeInterval:string];
            break;
            
        case PhotoNode:

            break;
            
        default:
            break;
    }
}

@end
