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
#import "PhotoUnmarshaller.h"

@interface KeyPointUnmarshaller()
@property (strong, nonatomic) KeyPoint *keyPoint;
@property (strong, nonatomic) PhotoUnmarshaller *photoUnmarshaller;

@end

@implementation KeyPointUnmarshaller
@synthesize keyPoint = _keyPoint;
@synthesize photoUnmarshaller = _photoUnmarshaller;

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
        self.photoUnmarshaller = [[PhotoUnmarshaller alloc] initWithNote:self.note andPreviousParser:self];
        self.photoUnmarshaller.keyPoint = self.keyPoint;
        parser.delegate = self.photoUnmarshaller;
    } else {
        self.nodeType = NoNode;
    }    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)text
{
    NSString *string = [BNoteStringUtils trim:text];
    
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
            
        default:
            break;
    }
}

@end
