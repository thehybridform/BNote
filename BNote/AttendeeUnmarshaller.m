//
//  AttendeeUnmarshaller.m
//  BeNote
//
//  Created by kristin young on 8/27/12.
//
//

#import "AttendeeUnmarshaller.h"
#import "Attendants.h"
#import "Attendant.h"
#import "BNoteFactory.h"

@interface AttendeeUnmarshaller()
@property (strong, nonatomic) Attendant *attendant;

@end

@implementation AttendeeUnmarshaller
@synthesize attendant = _attendant;

- (NSString *)nodeName
{
    return kAttendee;
}

- (void)reset
{
    Attendants *attendants = [BNoteEntryUtils attendantsEntryForNote:self.note];
    if (!attendants) {
        attendants = [BNoteFactory createAttendants:self.note];
    }
    
    self.attendant = [BNoteFactory createAttendant:attendants];
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
            self.attendant.firstName = string;
            break;
            
        case LastNameNode:
            self.attendant.lastName = string;
            break;
            
        case EmailNode:
            self.attendant.email = string;
            break;
            
        default:
            break;
    }
}

@end
