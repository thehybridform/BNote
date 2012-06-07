//
//  DueDateActionItemButton.m
//  BNote
//
//  Created by Young Kristin on 6/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DueDateActionItemButton.h"
#import "EntriesViewController.h"

@interface DueDateActionItemButton()
@property (strong, nonatomic) UIPopoverController *popup;
@end

@implementation DueDateActionItemButton
@synthesize popup = _popup;

- (void)execute:(id)sender
{
    EntryTableViewCell *cell = [self entryCellView];
    EntriesViewController *controller = [cell parentController];
    [controller setKeepQuickViewAlive:YES];
    
    [[cell textView] resignFirstResponder];
    [[cell subTextView] resignFirstResponder];

    [self showDatePicker];
}

- (void)showDatePicker
{
    NSTimeInterval interval = [[self actionItem] dueDate];
    NSDate *date;
    if (interval) {
        date = [NSDate dateWithTimeIntervalSinceReferenceDate:interval];
    } else {
        date = [[NSDate alloc] init];
    }
    
    DatePickerViewController *controller = [[DatePickerViewController alloc] initWithDate:date];
    [controller setListener:self];
    
    UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:controller];
    [self setPopup:popup];
    
    [popup setPopoverContentSize:[[controller view] bounds].size];
    
    UIView *view = self;
    CGRect rect = [view bounds];
    
    [popup presentPopoverFromRect:rect inView:view
         permittedArrowDirections:UIPopoverArrowDirectionAny 
                         animated:YES];
}

- (void)dateTimeUpdated:(NSDate *)date
{
    ActionItem *actionItem = [self actionItem];
    [actionItem setDueDate:[date timeIntervalSinceReferenceDate]];
}

@end
