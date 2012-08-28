//
//  RootUnmarshaller.m
//  BeNote
//
//  Created by kristin young on 8/26/12.
//
//

#import "RootUnmarshaller.h"
#import "NoteUnmarshaller.h"
#import "BNoteXmlConstants.h"
#import "BNoteFactory.h"

@interface RootUnmarshaller()
@property (strong, nonatomic) id<NSXMLParserDelegate> delegate;

@end

@implementation RootUnmarshaller
@synthesize delegate = _delegate;

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:kNote]) {
        Note *note = [BNoteFactory createNote:nil];
        self.delegate = [[NoteUnmarshaller alloc] initWithNote:note andPreviousParser:self];
        parser.delegate = self.delegate;
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    
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
