//
//  BNoteUnmarshaller.h
//  BeNote
//
//  Created by kristin young on 8/24/12.
//
//

#import <Foundation/Foundation.h>

@protocol BNoteUnmarshaller <NSObject, NSXMLParserDelegate>

- (BOOL)accept:(NSString *)nodeName;
- (void)reset;

@end
