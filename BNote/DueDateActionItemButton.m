//
//  DueDateActionItemButton.m
//  BNote
//
//  Created by Young Kristin on 6/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DueDateActionItemButton.h"
#import "EntriesViewController.h"
#import "DatePickerViewController.h"
#import "BNoteWriter.h"
#import "ActionItemEntryCell.h"

@interface DueDateActionItemButton()
@end

@implementation DueDateActionItemButton

- (void)execute:(id)sender
{
    ActionItemEntryCell *cell = (ActionItemEntryCell *) [self entryCellView];
 
    ActionItem *actionItem = (ActionItem *) [cell entry];
    if ([actionItem dueDate]) {
        [actionItem setDueDate:0];
        [[BNoteWriter instance] update];
        [cell updateDetail];
        [self setTitle:@"   due date   " forState:UIControlStateNormal];
    } else {
        [[cell textView] resignFirstResponder];
        [cell showDatePicker];
    }
}


@end
