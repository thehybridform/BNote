//
//  DueDateActionItemButton.m
//  BNote
//
//  Created by Young Kristin on 6/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DueDateActionItemButton.h"
#import "ActionItemContentViewController.h"
#import "DatePickerViewController.h"
#import "BNoteWriter.h"

@interface DueDateActionItemButton()
@end

@implementation DueDateActionItemButton

- (void)execute:(id)sender
{
    ActionItemContentViewController *controller = (ActionItemContentViewController *) [self entryContentViewController];
 
    ActionItem *actionItem = (ActionItem *) [controller entry];
    if ([actionItem dueDate]) {
        [actionItem setDueDate:0];
        [[BNoteWriter instance] update];
        [self setTitle:@"   due date   " forState:UIControlStateNormal];
    } else {
        [[controller mainTextView] resignFirstResponder];
        [controller showDatePicker];
    }
    
    [[self entryContentViewController] updateDetail];
}


@end
