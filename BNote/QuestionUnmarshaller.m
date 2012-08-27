//
//  QuestionUnmarshaller.m
//  BeNote
//
//  Created by kristin young on 8/26/12.
//
//

#import "QuestionUnmarshaller.h"
#import "BNoteFactory.h"
#import "BNoteXmlConstants.h"
#import "Question.h"

@interface QuestionUnmarshaller()
@property (strong, nonatomic) Question *question;

@end

@implementation QuestionUnmarshaller
@synthesize question = _question;

- (NSString *)nodeName
{
    return kQuestion;
}

- (void)reset
{
    self.question = [BNoteFactory createQuestion:self.note];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:kText]) {
        self.nodeType = TextNode;
    } else if ([elementName isEqualToString:kCreated]) {
        self.nodeType = CreatedDateNode;
    } else if ([elementName isEqualToString:kLastUpdated]) {
        self.nodeType = LastUpdatedDateNode;
    } else if ([elementName isEqualToString:kAnswer]) {
        self.nodeType = QuestionAnswerNode;
    } else {
        self.nodeType = NoNode;
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    switch (self.nodeType) {
        case TextNode:
            self.question.text = string;
            break;
            
        case CreatedDateNode:
            self.question.created = [BNoteXmlConstants toTimeInterval:string];
            break;
            
        case LastUpdatedDateNode:
            self.question.lastUpdated = [BNoteXmlConstants toTimeInterval:string];
            break;
            
        case QuestionAnswerNode:
            self.question.answer = string;
            break;
            
        default:
            break;
    }
}

@end
