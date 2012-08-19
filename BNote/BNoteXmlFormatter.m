//
//  BNoteXmlFormatter.m
//  BeNote
//
//  Created by kristin young on 8/17/12.
//
//

#import "BNoteXmlFormatter.h"

@implementation BNoteXmlFormatter

static NSString *kOpenTag = @"<%@>\r\n";
static NSString *kOpenTagWithAtribute = @"<%@ %@=\"%@\">\r\n";
static NSString *kCloseTag = @"</%@>\r\n";
static NSString *kNode = @"<%@>%@</%@>\r\n";

+ (NSString *)openTag:(NSString *)tag
{
    return [NSString stringWithFormat:kOpenTag, tag];
}

+ (NSString *)openTag:(NSString *)tag withAttribute:(NSString *)attribute value:(NSString *)value
{
    return [NSString stringWithFormat:kOpenTagWithAtribute, tag, attribute, value];
}

+ (NSString *)closeTag:(NSString *)tag
{
    return [NSString stringWithFormat:kCloseTag, tag];
}

+ (NSString *)node:(NSString *)name withText:(NSString *)value
{
    if (value) {
        return [NSString stringWithFormat:kNode, name, value, name];
    }
    
    return nil;
}

@end
