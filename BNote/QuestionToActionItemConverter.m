//
//  QuestionToActionItemConverter.m
//  BeNote
//
//  Created by kristin young on 8/6/12.
//
//

#import "QuestionToActionItemConverter.h"

@implementation QuestionToActionItemConverter

- (BOOL)convert:(Entry *)entryFrom to:(Entry *)entryTo
{
    if ([entryFrom isKindOfClass:[Question class]] && [entryTo isKindOfClass:[ActionItem class]]) {
        
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
