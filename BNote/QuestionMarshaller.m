//
//  QuestionMarshaller.m
//  BeNote
//
//  Created by kristin young on 8/17/12.
//
//

#import "QuestionMarshaller.h"
#import "BNoteXmlFormatter.h"
#import "BNoteXmlConstants.h"

@implementation QuestionMarshaller

- (BOOL)accept:(id)obj
{
    return [obj isKindOfClass:[Question class]];
}

- (void)marshall:(Question *)question into:(BNoteExportFileWrapper *)file
{
    [self write:[BNoteXmlFormatter openTag:kQuestion] into:file];
    
    NSString *s = [BNoteXmlFormatter node:kText withText:question.text];
    [self write:s into:file];

    s = [BNoteXmlFormatter node:kAnswer withText:question.answer];
    [self write:s into:file];

    s = [BNoteXmlFormatter node:kCreated withText:[BNoteXmlConstants toString:question.created]];
    [self write:s into:file];
    
    s = [BNoteXmlFormatter node:kLastUpdated withText:[BNoteXmlConstants toString:question.lastUpdated]];
    [self write:s into:file];
    
    [self write:[BNoteXmlFormatter closeTag:kQuestion] into:file];
}

@end
