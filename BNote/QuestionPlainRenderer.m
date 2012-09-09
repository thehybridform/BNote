//
//  QuestionPlainRenderer.m
//  BNote
//
//  Created by Young Kristin on 6/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QuestionPlainRenderer.h"

@implementation QuestionPlainRenderer

- (BOOL)accept:(Entry *)entry
{
    return [entry isKindOfClass:[Question class]];
}

- (NSString *)render:(Entry *)entry
{
    NSString *title = [NSLocalizedString(@"Question", nil) stringByAppendingString:@": "];
    NSString *created = [BNoteStringUtils formatDate:[entry created]];
    NSString *text = [entry text];
        
    Question *question = (Question *) entry;
    NSString *answer = [question answer];
    NSString *answerTitle = answer ? [[@" - " stringByAppendingString:NSLocalizedString(@"Answer", nil)] stringByAppendingString:@": "] : nil;
    return [BNoteStringUtils append:title, @" - ", NSLocalizedString(@"Created Date", nil), @": ", created, kNewLine, text, kNewLine, kNewLine, answerTitle, answer, kNewLine, kNewLine, nil];
}

@end
