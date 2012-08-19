//
//  QuestionMarshaller.m
//  BeNote
//
//  Created by kristin young on 8/17/12.
//
//

#import "QuestionMarshaller.h"
#import "Question.h"
#import "BNoteXmlFormatter.h"
#import "BNoteMarshallingManager.h"

@implementation QuestionMarshaller

static NSString *kQuestion = @"question";
static NSString *kAnswer = @"answer";

- (BOOL)accept:(id)obj
{
    return [obj isKindOfClass:[Question class]];
}

- (void)marshall:(Question *)question into:(NSFileHandle *)file
{
    [self write:[BNoteXmlFormatter openTag:kQuestion] into:file];
    
    NSString *s = [BNoteXmlFormatter node:kText withText:question.text];
    [self write:s into:file];

    s = [BNoteXmlFormatter node:kAnswer withText:question.answer];
    [self write:s into:file];

    s = [BNoteXmlFormatter node:kCreated withText:[self toString:question.created]];
    [self write:s into:file];
    
    s = [BNoteXmlFormatter node:kLastUpdated withText:[self toString:question.lastUpdated]];
    [self write:s into:file];
    
    [self write:[BNoteXmlFormatter closeTag:kQuestion] into:file];
}

@end
