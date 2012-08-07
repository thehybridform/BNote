//
//  ActionItemToDecisionConverter.m
//  BeNote
//
//  Created by kristin young on 8/6/12.
//
//

#import "ActionItemToDecisionConverter.h"
#import "Decision.h"

@implementation ActionItemToDecisionConverter

- (BOOL)convert:(Entry *)entryFrom to:(Entry *)entryTo
{
    if ([entryFrom isKindOfClass:[ActionItem class]] && [entryTo isKindOfClass:[Decision class]]) {
        
        ActionItem *actionItem = (ActionItem *)entryFrom;
        NSString *text = [actionItem text];
        
        if ([actionItem responsibility]) {
            text = [BNoteStringUtils append:text, kNewLine, [actionItem responsibility], nil];
        }
        
        if ([actionItem dueDate]) {
            NSDate *dueDate = [NSDate dateWithTimeIntervalSinceReferenceDate:[actionItem dueDate]];
            NSString *date = [BNoteStringUtils dateToString:dueDate];
            text = [BNoteStringUtils append:text, kNewLine, date, nil];
        }
        
        if ([actionItem completed]) {
            NSDate *dueDate = [NSDate dateWithTimeIntervalSinceReferenceDate:[actionItem completed]];
            NSString *date = [BNoteStringUtils dateToString:dueDate];
            text = [BNoteStringUtils append:text, kNewLine, date, nil];
        }
        
        [entryTo setText:text];
        
        return YES;
    }
    
    return NO;
}

@end
