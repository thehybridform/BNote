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
    NSString *title = @" - Action Item: ";
    NSString *created = [BNoteStringUtils formatDate:[entry created]];
    NSString *text = [entry text];
    
    ActionItem *actionItem = entry;
    
    NSTimeInterval dueDate = [actionItem dueDate];
    NSString *dueDateText;
    if (dueDate) {
        dueDateText = [BNoteStringUtils append:@"Due on ", [BNoteStringUtils formatDate:dueDate], nil];
    } else {
        dueDateText = @"No due date";
    }
    
    NSTimeInterval completed = [actionItem completed];
    NSString *completedText;
    if (completed) {
        completedText = [BNoteStringUtils append:@"Completed on ", [BNoteStringUtils formatDate:completed], nil];
    } else {
        completedText = @"Not completed";
    }

    NSString *responsibilityText;
    if ([actionItem responsibility]) {
        responsibilityText = [BNoteStringUtils append:@"Assigned to ", [actionItem responsibility], nil];
    } else {
        responsibilityText = @"Not Assigned";
    }
    
    
    return [BNoteStringUtils append:title, @" - Created: ", created, NewLine, text, NewLine, dueDateText, NewLine, completedText, NewLine, NewLine, nil];
}

@end
