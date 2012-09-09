//
//  BNoteXmlFormatter.m
//  BeNote
//
//  Created by kristin young on 8/17/12.
//
//

#import "BNoteXmlFormatter.h"

@implementation BNoteXmlFormatter

static NSString *kOpenTag = @"<%@>\n";
static NSString *kCloseTag = @"</%@>\n";
static NSString *kNode = @"<%@>%@</%@>\n";

static NSString *spaces = @"    ";
static int level = 0;

+ (NSString *)openTag:(NSString *)tag
{
    level++;
    return [self formatLine:[NSString stringWithFormat:kOpenTag, tag]];
}

+ (NSString *)closeTag:(NSString *)tag
{
    NSString *line = [self formatLine:[NSString stringWithFormat:kCloseTag, tag]];
    level--;
    return line;
}

+ (NSString *)node:(NSString *)name withText:(NSString *)value
{
    NSString *line;
    if (value) {
        level++;
        line = [self formatLine:[NSString stringWithFormat:kNode, name, value, name]];
        level--;
    }
    
    return line;
}

+ (NSString *)formatLine:(NSString *)line
{
    NSString *spacing = @"";
    for (int i = 0; i < level; i++) {
        spacing = [spacing stringByAppendingString:spaces];
    }
    
    return [spacing stringByAppendingString:line];
}

@end
