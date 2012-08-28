//
//  ResponsibilityUnmarshaller.m
//  BeNote
//
//  Created by kristin young on 8/27/12.
//
//

#import "ResponsibilityUnmarshaller.h"
#import "Attendant.h"
#import "BNoteFactory.h"

@implementation ResponsibilityUnmarshaller
@synthesize actionItem = _actionItem;

- (NSString *)nodeName
{
    return kResponsibility;
}

- (void)reset
{
    self.actionItem.attendant = [BNoteFactory createAttendant];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:kFirstName]) {
        self.nodeType = FirstNameNode;
    } else if ([elementName isEqualToString:kLastName]) {
        self.nodeType = LastNameNode;
    } else if ([elementName isEqualToString:kEmail]) {
        self.nodeType = EmailNode;
    } else {
        self.nodeType = NoNode;
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)text
{
    NSString *string = [BNoteStringUtils trim:text];
    
    switch (self.nodeType) {
        case FirstNameNode:
            self.actionItem.attendant.firstName = string;
            break;
            
        case LastNameNode:
            self.actionItem.attendant.lastName = string;
            break;
            
        case EmailNode:
            self.actionItem.attendant.email = string;
            break;
            
        default:
            break;
    }
}

@end
