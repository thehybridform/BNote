//
//  NoteUnmarshaller.h
//  BeNote
//
//  Created by kristin young on 8/26/12.
//
//

#import <Foundation/Foundation.h>

@interface NoteUnmarshaller : NSObject <NSXMLParserDelegate>

- (id)initWithNote:(Note *)note andPreviousParser:(id<NSXMLParserDelegate>)previousParser;

@end
