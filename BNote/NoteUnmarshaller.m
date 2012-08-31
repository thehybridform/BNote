//
//  NoteUnmarshaller.m
//  BeNote
//
//  Created by kristin young on 8/26/12.
//
//

#import "NoteUnmarshaller.h"
#import "BNoteXmlConstants.h"
#import "BNoteUnmarshaller.h"
#import "ActionItemUnmarshaller.h"
#import "QuestionUnmarshaller.h"
#import "KeyPointUnmarshaller.h"
#import "DecisionUnmarshaller.h"
#import "AttendeeUnmarshaller.h"
#import "TopicUnmarshaller.h"
#import "AssociatedTopicUnmarshaller.h"
#import "BNoteReader.h"
#import "BNoteFactory.h"
#import "Topic.h"

@interface NoteUnmarshaller()
@property (strong, nonatomic) id<NSXMLParserDelegate> previousParser;
@property (strong, nonatomic) NSMutableArray *parsers;
@property (assign, nonatomic) CurrentNode nodeType;
@property (strong, nonatomic) Note *note;
@property (strong, nonatomic) TopicUnmarshaller *topicUnmarshaller;

@end

@implementation NoteUnmarshaller
@synthesize previousParser = _previousParser;
@synthesize parsers = _parsers;
@synthesize nodeType = _nodeType;
@synthesize note = _note;
@synthesize topicUnmarshaller = _topicUnmarshaller;

- (id)initWithNote:(Note *)note andPreviousParser:(id<NSXMLParserDelegate>)previousParser
{
    self = [super init];
    
    if (self) {
        self.note = note;
        self.previousParser = previousParser;
        
        self.parsers = [[NSMutableArray alloc] init];
        [self.parsers addObject:[[ActionItemUnmarshaller alloc] initWithNote:note andPreviousParser:self]];
        [self.parsers addObject:[[QuestionUnmarshaller alloc] initWithNote:note andPreviousParser:self]];
        [self.parsers addObject:[[KeyPointUnmarshaller alloc] initWithNote:note andPreviousParser:self]];
        [self.parsers addObject:[[DecisionUnmarshaller alloc] initWithNote:note andPreviousParser:self]];
        [self.parsers addObject:[[AttendeeUnmarshaller alloc] initWithNote:note andPreviousParser:self]];
        [self.parsers addObject:[[TopicUnmarshaller alloc] initWithNote:note andPreviousParser:self]];
        [self.parsers addObject:[[AssociatedTopicUnmarshaller alloc] initWithNote:note andPreviousParser:self]];
    }
    
    return self;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:kCreated]) {
        self.nodeType = CreatedDateNode;
    } else if ([elementName isEqualToString:kLastUpdated]) {
        self.nodeType = LastUpdatedDateNode;
    } else if ([elementName isEqualToString:kSummary]) {
        self.nodeType = SummaryNode;
    } else if ([elementName isEqualToString:kSubject]) {
        self.nodeType = SubjectNode;
    } else {
        self.nodeType = NoNode;
    }

    if (self.nodeType == NoNode) {
        for (id<BNoteUnmarshaller> unmarshaller in self.parsers) {
            if ([unmarshaller accept:elementName]) {
                [unmarshaller reset];
                parser.delegate = unmarshaller;
                break;
            }
        }
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:kNote]) {
        parser.delegate = self.previousParser;
    } else {
        self.nodeType = NoNode;
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)text
{
    NSString *string = [BNoteStringUtils trim:text];
    switch (self.nodeType) {
        case CreatedDateNode:
            self.note.created = [BNoteXmlConstants toTimeInterval:string];
            break;
            
        case LastUpdatedDateNode:
            self.note.lastUpdated = [BNoteXmlConstants toTimeInterval:string];
            break;
            
        case SummaryNode:
            self.note.summary = string;
            break;
            
        case SubjectNode:
            self.note.subject = string;
            break;

        default:
            break;
    }
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    NSLog(@"%@", parser);
}

- (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError
{
    NSLog(@"%@", parser);
}

@end
