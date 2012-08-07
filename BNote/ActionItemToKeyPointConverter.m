//
//  ActionItemToKeyPointConverter.m
//  BeNote
//
//  Created by kristin young on 8/6/12.
//
//

#import "ActionItemToKeyPointConverter.h"

@implementation ActionItemToKeyPointConverter

- (BOOL)convert:(Entry *)entryFrom to:(Entry *)entryTo
{
    if ([entryFrom isKindOfClass:[ActionItem class]] && [entryTo isKindOfClass:[KeyPoint class]]) {
        
        ActionItem *actionItem = (ActionItem *)entryFrom;
        NSString *text = [actionItem text];
       
        if ([actionItem responsibility]) {
            text = [BNoteStringUtils append:text, kNewLine, @"Responsibility: ", [actionItem responsibility], nil];
        }
        
        if ([actionItem dueDate]) {
            NSDate *dueDate = [NSDate dateWithTimeIntervalSinceReferenceDate:[actionItem dueDate]];
            NSString *date = [BNoteStringUtils dateToString:dueDate];
            text = [BNoteStringUtils append:text, kNewLine, @"Due Date: ", date, nil];
        }
        
        if ([actionItem completed]) {
            NSDate *dueDate = [NSDate dateWithTimeIntervalSinceReferenceDate:[actionItem completed]];
            NSString *date = [BNoteStringUtils dateToString:dueDate];
            text = [BNoteStringUtils append:text, kNewLine, @"Completed: ", date, nil];
        }

        [entryTo setText:text];
        
        return YES;
    }
    
    return NO;
}

@end
