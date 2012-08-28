//
//  ActionItemPlainRenderer.m
//  BNote
//
//  Created by Young Kristin on 6/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ActionItemPlainRenderer.h"
#import "ActionItem.h"

@implementation ActionItemPlainRenderer

- (BOOL)accept:(Entry *)entry
{
    return [entry isKindOfClass:[ActionItem class]];
}

- (NSString *)render:(Entry *)entry
{
    NSString *title = [NSLocalizedString(@"Action Item", nil) stringByAppendingString:@": "];
    NSString *created = [BNoteStringUtils formatDate:[entry created]];
    NSString *text = [entry text];
    
    ActionItem *actionItem = (ActionItem *) entry;
    
    NSTimeInterval dueDate = [actionItem dueDate];
    NSString *dueDateText;
    if (dueDate) {
        dueDateText = [BNoteStringUtils append:NSLocalizedString(@"Due On", nil), @" ", [BNoteStringUtils formatDate:dueDate], nil];
    } else {
        dueDateText = NSLocalizedString(@"No Due Date", nil);
    }
    
    NSTimeInterval completed = [actionItem completed];
    NSString *completedText;
    if (completed) {
        completedText = [BNoteStringUtils append:NSLocalizedString(@"Completed on", nil), @" ", [BNoteStringUtils formatDate:completed], nil];
    } else {
        completedText = NSLocalizedString(@"Not Complete", nil);
    }

    NSString *responsibilityText;
    if ([actionItem attendant]) {
        if ([actionItem attendant]) {
            Attendant *attendant = actionItem.attendant;
            NSString *name  = [BNoteStringUtils append:attendant.firstName, @" ", attendant.lastName, nil];
            responsibilityText = [BNoteStringUtils append:@" ", NSLocalizedString(@"Assigned to", nil), @": ", name, nil];
        }
    } else {
        responsibilityText = NSLocalizedString(@"Not assigned", nil);
    }
    
    
    return [BNoteStringUtils append:title, @" - ", NSLocalizedString(@"Created Date", nil), @": ", created, kNewLine, text, kNewLine, responsibilityText, kNewLine, dueDateText, kNewLine, completedText, kNewLine, kNewLine, nil];
}

@end
