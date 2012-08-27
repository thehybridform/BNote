//
//  EntryUnmarshallerBasis.h
//  BeNote
//
//  Created by kristin young on 8/26/12.
//
//

#import <Foundation/Foundation.h>
#import "BNoteUnmarshaller.h"
#import "BNoteXmlConstants.h"

@interface EntryUnmarshallerBasis : NSObject <BNoteUnmarshaller>
@property (strong, nonatomic) Note *note;
@property (strong, nonatomic) id<NSXMLParserDelegate> previousParser;
@property (assign, nonatomic) CurrentNode nodeType;

- (id)initWithNote:(Note *)note andPreviousParser:(id<NSXMLParserDelegate>)previousParser;

- (NSString *)nodeName;
- (void)reset;

@end
