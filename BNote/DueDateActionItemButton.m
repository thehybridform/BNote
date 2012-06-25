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

@interface DueDateActionItemButton()
@end

@implementation DueDateActionItemButton

- (void)execute:(id)sender
{
    EntryContentViewController *controller = [self entryContentViewController];
 
    ActionItem *actionItem = (ActionItem *) [controller entry];
    if ([actionItem dueDate]) {
        [actionItem setDueDate:0];
        [[BNoteWriter instance] update];
        //[cell updateDetail];
        [self setTitle:@"   due date   " forState:UIControlStateNormal];
    } else {
        [[controller mainTextView] resignFirstResponder];
//        [cell showDatePicker];
    }
}


@end
