//
//  EntryUnmarshallerBasis.m
//  BeNote
//
//  Created by kristin young on 8/26/12.
//
//

#import "EntryUnmarshallerBasis.h"

@interface EntryUnmarshallerBasis()

@end

@implementation EntryUnmarshallerBasis
@synthesize note = _note;
@synthesize previousParser = _previousParser;
@synthesize nodeType = _nodeType;

- (id)initWithNote:(Note *)note andPreviousParser:(id<NSXMLParserDelegate>)previousParser
{
    self = [super init];
    
    if (self) {
        self.note = note;
        self.previousParser = previousParser;
        self.nodeType = NoNode;
    }
    
    return self;
}

- (BOOL)accept:(NSString *)nodeName
{
    return [[self nodeName] isEqualToString:nodeName];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:[self nodeName]]) {
        parser.delegate = self.previousParser;
    } else {
        self.nodeType = NoNode;
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

- (NSString *)nodeName
{
    return nil;
}

- (void)reset
{
    
}


@end
