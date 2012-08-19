//
//  BNoteXmlFormatter.h
//  BeNote
//
//  Created by kristin young on 8/17/12.
//
//

#import <Foundation/Foundation.h>

@interface BNoteXmlFormatter : NSObject

+ (NSString *)openTag:(NSString *)tag;
+ (NSString *)openTag:(NSString *)tag withAttribute:(NSString *)attribute value:(NSString *)value;
+ (NSString *)closeTag:(NSString *)tag;
+ (NSString *)node:(NSString *)name withText:(NSString *)value;

@end
