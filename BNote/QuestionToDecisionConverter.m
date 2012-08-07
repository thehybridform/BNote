//
//  QuestionToDecisionConverter.m
//  BeNote
//
//  Created by kristin young on 8/6/12.
//
//

#import "QuestionToDecisionConverter.h"
#import "Decision.h"

@implementation QuestionToDecisionConverter

- (BOOL)convert:(Entry *)entryFrom to:(Entry *)entryTo
{
    if ([entryFrom isKindOfClass:[Question class]] && [entryTo isKindOfClass:[Decision class]]) {
        
        Question *question = (Question *)entryFrom;
        NSString *text = [question text];
        if (![BNoteStringUtils nilOrEmpty:[question answer]]) {
            text = [BNoteStringUtils append:text, kNewLine, [question answer], nil];
        }
        
        [entryTo setText:text];
        
        return YES;
    }
    
    return NO;
}

@end
