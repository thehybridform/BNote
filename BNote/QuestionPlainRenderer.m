//
//  QuestionPlainRenderer.m
//  BNote
//
//  Created by Young Kristin on 6/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QuestionPlainRenderer.h"
#import "Question.h"

@implementation QuestionPlainRenderer

- (BOOL)accept:(Entry *)entry
{
    return [entry isKindOfClass:[Question class]];
}

- (NSString *)render:(Entry *)entry
{
    NSString *title = @" - Question: ";
    NSString *created = [BNoteStringUtils formatDate:[entry created]];
    NSString *text = [entry text];
        
    Question *question = (Question *) entry;
    NSString *answer = [question answer];
    NSString *answerTitle = answer ? @"Answer: " : nil;
    return [BNoteStringUtils append:title, @" - Created: ", created, NewLine, text, NewLine, NewLine, answerTitle, answer, NewLine, NewLine, nil];
}

@end
