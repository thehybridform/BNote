//
//  ActionItemUnmarshaller.m
//  BeNote
//
//  Created by kristin young on 8/26/12.
//
//

#import "ActionItemUnmarshaller.h"
#import "BNoteFactory.h"
#import "ResponsibilityUnmarshaller.h"

@interface ActionItemUnmarshaller()
@property (strong, nonatomic) ActionItem *actionItem;
@property (strong, nonatomic) ResponsibilityUnmarshaller *responsibilityUnmarshaller;

@end

@implementation ActionItemUnmarshaller
@synthesize actionItem = _actionItem;
@synthesize responsibilityUnmarshaller = _responsibilityUnmarshaller;

- (NSString *)nodeName
{
    return kActionItem;
}

- (void)reset
{
    self.actionItem = [BNoteFactory createActionItem:self.note];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:kText]) {
        self.nodeType = TextNode;
    } else if ([elementName isEqualToString:kCreated]) {
        self.nodeType = CreatedDateNode;
    } else if ([elementName isEqualToString:kLastUpdated]) {
        self.nodeType = LastUpdatedDateNode;
    } else if ([elementName isEqualToString:kDueDate]) {
        self.nodeType = DueDateNode;
    } else if ([elementName isEqualToString:kCompletedDate]) {
        self.nodeType = CompletedDateNode;
    } else if ([elementName isEqualToString:kResponsibility]) {
        self.responsibilityUnmarshaller = [[ResponsibilityUnmarshaller alloc] initWithNote:self.note andPreviousParser:self];
        parser.delegate = self.responsibilityUnmarshaller;
    } else {
        self.nodeType = NoNode;
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)text
{
    NSString *string = [BNoteStringUtils trim:text];
    
    switch (self.nodeType) {
        case TextNode:
            self.actionItem.text = string;
            break;
            
        case DueDateNode:
            self.actionItem.dueDate = [BNoteXmlConstants toTimeInterval:string];
            break;
            
        case CreatedDateNode:
            self.actionItem.created = [BNoteXmlConstants toTimeInterval:string];
            break;
            
        case LastUpdatedDateNode:
            self.actionItem.lastUpdated = [BNoteXmlConstants toTimeInterval:string];
            break;
            
        case CompletedDateNode:
            self.actionItem.completed = [BNoteXmlConstants toTimeInterval:string];
            break;
            
        default:
            break;
    }
}

@end
